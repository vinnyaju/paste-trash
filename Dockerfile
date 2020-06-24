#Depending on the operating system of the host machines(s) that will build or run the containers, the image specified in the FROM statement may need to be changed.
#For more information, please see https://aka.ms/containercompat

FROM mcr.microsoft.com/dotnet/core/sdk:3.1 AS build
WORKDIR /source

# copy csproj and restore as distinct layers
COPY *.sln . 
COPY paste-trash-api/* ./paste-trash-api/


WORKDIR /source/paste-trash-api
RUN dotnet restore
RUN dotnet publish -c Release -o /app --no-restore


# final stage/image
FROM mcr.microsoft.com/dotnet/core/aspnet:3.1

WORKDIR /app
COPY --from=build /app ./
EXPOSE $PORT

CMD ASPNETCORE_URLS=http://*:$PORT dotnet paste-trash-api.dll
