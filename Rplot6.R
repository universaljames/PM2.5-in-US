#Data Preparation
DataFile <- "NEI_data.zip"
DataFileURL <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
download.file(url=DataFileURL,destfile=DataFileFile,method="curl")
unzip(DataFile)
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")
colToFactor <- c("year", "type", "Pollutant","SCC","fips")
NEI[,colToFactor] <- lapply(NEI[,colToFactor], factor)
levels(NEI$fips)[1] = NA
NEIdata<-NEI[complete.cases(NEI),]
colSums(is.na(NEIdata))

#Question 6
NEIvehicleBalti<-subset(NEIvehicleSSC, fips == "24510")
NEIvehicleBalti$city <- "Baltimore City"
NEIvehiclela<-subset(NEIvehicleSSC, fips == "06037")
NEIvehiclela$city <- "Los Angeles County"
NEIBothCity <- rbind(NEIvehicleBalti, NEIvehiclela)

ggplot(NEIBothCity, aes(x=year, y=Emissions, fill=city)) +
  geom_bar(aes(fill=year),stat="identity") +
 facet_grid(.~city) +
 guides(fill=FALSE) + theme_bw() +
 labs(x="year", y=expression("Total PM"[2.5]*" Emission (Kilo-Tons)")) + 
 labs(title=expression("PM"[2.5]*" Motor Vehicle Source Emissions in Baltimore & LA, 1999-2008"))
 
aggregateEmissions <- aggregate(Emissions~city+year, data=NEIBothCity, sum)
aggregate(Emissions~city, data=aggregateEmissions, range)
