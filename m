Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756879Ab2DIUQA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2012 16:16:00 -0400
Received: from csmtp3.one.com ([91.198.169.23]:58554 "EHLO csmtp3.one.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755531Ab2DIUP3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2012 16:15:29 -0400
From: Eric Andersson <eric.andersson@unixphere.com>
To: linux-kernel@vger.kernel.org
Cc: gregkh@linuxfoundation.org, alan@lxorguk.ukuu.org.uk, arnd@arndb.de,
        zhengguang.guo@bosch-sensortec.com, peter.moeller@cn.bosch.com,
        stefan.nilsson@unixphere.com, broonie@opensource.wolfsonmicro.com,
        christoph.mair@gmail.com,
        Eric Andersson <eric.andersson@unixphere.com>
Subject: [PATCHv5 1/3] misc: clean up bmp085 driver
Date: Mon,  9 Apr 2012 22:16:15 +0200
Message-Id: <1334002577-7786-2-git-send-email-eric.andersson@unixphere.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1334002577-7786-1-git-send-email-eric.andersson@unixphere.com>
References: <1334002577-7786-1-git-send-email-eric.andersson@unixphere.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch includes various cleaning of the bmp085 driver including:
- Whitespaces and alignment fixes
- Minor typos
- Consistency fixes

Reviewed-by: Stefan Nilsson <stefan.nilsson@unixphere.com>
Signed-off-by: Eric Andersson <eric.andersson@unixphere.com>
---
 drivers/misc/bmp085.c |  206 ++++++++++++++++++++++++------------------------
 1 files changed, 103 insertions(+), 103 deletions(-)

diff --git a/drivers/misc/bmp085.c b/drivers/misc/bmp085.c
index 76c3064..6f572bc 100644
--- a/drivers/misc/bmp085.c
+++ b/drivers/misc/bmp085.c
@@ -1,62 +1,63 @@
 /*  Copyright (c) 2010  Christoph Mair <christoph.mair@gmail.com>
-
-    This driver supports the bmp085 digital barometric pressure
-    and temperature sensor from Bosch Sensortec. The datasheet
-    is available from their website:
-    http://www.bosch-sensortec.com/content/language1/downloads/BST-BMP085-DS000-05.pdf
-
-    A pressure measurement is issued by reading from pressure0_input.
-    The return value ranges from 30000 to 110000 pascal with a resulution
-    of 1 pascal (0.01 millibar) which enables measurements from 9000m above
-    to 500m below sea level.
-
-    The temperature can be read from temp0_input. Values range from
-    -400 to 850 representing the ambient temperature in degree celsius
-    multiplied by 10.The resolution is 0.1 celsius.
-
-    Because ambient pressure is temperature dependent, a temperature
-    measurement will be executed automatically even if the user is reading
-    from pressure0_input. This happens if the last temperature measurement
-    has been executed more then one second ago.
-
-    To decrease RMS noise from pressure measurements, the bmp085 can
-    autonomously calculate the average of up to eight samples. This is
-    set up by writing to the oversampling sysfs file. Accepted values
-    are 0, 1, 2 and 3. 2^x when x is the value written to this file
-    specifies the number of samples used to calculate the ambient pressure.
-    RMS noise is specified with six pascal (without averaging) and decreases
-    down to 3 pascal when using an oversampling setting of 3.
-
-    This program is free software; you can redistribute it and/or modify
-    it under the terms of the GNU General Public License as published by
-    the Free Software Foundation; either version 2 of the License, or
-    (at your option) any later version.
-
-    This program is distributed in the hope that it will be useful,
-    but WITHOUT ANY WARRANTY; without even the implied warranty of
-    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-    GNU General Public License for more details.
-
-    You should have received a copy of the GNU General Public License
-    along with this program; if not, write to the Free Software
-    Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
-*/
-
+ *  Copyright (c) 2012  Bosch Sensortec GmbH
+ *  Copyright (c) 2012  Unixphere AB
+ *
+ *  This driver supports the bmp085 digital barometric pressure
+ *  and temperature sensor from Bosch Sensortec. The datasheet
+ *  is available from their website:
+ *  http://www.bosch-sensortec.com/content/language1/downloads/BST-BMP085-DS000-05.pdf
+ *
+ *  A pressure measurement is issued by reading from pressure0_input.
+ *  The return value ranges from 30000 to 110000 pascal with a resulution
+ *  of 1 pascal (0.01 millibar) which enables measurements from 9000m above
+ *  to 500m below sea level.
+ *
+ *  The temperature can be read from temp0_input. Values range from
+ *  -400 to 850 representing the ambient temperature in degree celsius
+ *  multiplied by 10.The resolution is 0.1 celsius.
+ *
+ *  Because ambient pressure is temperature dependent, a temperature
+ *  measurement will be executed automatically even if the user is reading
+ *  from pressure0_input. This happens if the last temperature measurement
+ *  has been executed more then one second ago.
+ *
+ *  To decrease RMS noise from pressure measurements, the bmp085 can
+ *  autonomously calculate the average of up to eight samples. This is
+ *  set up by writing to the oversampling sysfs file. Accepted values
+ *  are 0, 1, 2 and 3. 2^x when x is the value written to this file
+ *  specifies the number of samples used to calculate the ambient pressure.
+ *  RMS noise is specified with six pascal (without averaging) and decreases
+ *  down to 3 pascal when using an oversampling setting of 3.
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License as published by
+ *  the Free Software Foundation; either version 2 of the License, or
+ *  (at your option) any later version.
+ *
+ *  This program is distributed in the hope that it will be useful,
+ *  but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *  GNU General Public License for more details.
+ *
+ *  You should have received a copy of the GNU General Public License
+ *  along with this program; if not, write to the Free Software
+ *  Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+ */
 
 #include <linux/module.h>
+#include <linux/device.h>
 #include <linux/init.h>
 #include <linux/i2c.h>
 #include <linux/slab.h>
 #include <linux/delay.h>
 
-
+#define BMP085_NAME			"bmp085"
 #define BMP085_I2C_ADDRESS		0x77
 #define BMP085_CHIP_ID			0x55
 
 #define BMP085_CALIBRATION_DATA_START	0xAA
 #define BMP085_CALIBRATION_DATA_LENGTH	11	/* 16 bit values */
 #define BMP085_CHIP_ID_REG		0xD0
-#define BMP085_VERSION_REG		0xD1
 #define BMP085_CTRL_REG			0xF4
 #define BMP085_TEMP_MEASUREMENT		0x2E
 #define BMP085_PRESSURE_MEASUREMENT	0x34
@@ -65,9 +66,6 @@
 #define BMP085_CONVERSION_REGISTER_XLSB	0xF8
 #define BMP085_TEMP_CONVERSION_TIME	5
 
-#define BMP085_CLIENT_NAME		"bmp085"
-
-
 static const unsigned short normal_i2c[] = { BMP085_I2C_ADDRESS,
 							I2C_CLIENT_END };
 
@@ -78,20 +76,18 @@ struct bmp085_calibration_data {
 	s16 MB, MC, MD;
 };
 
-
-/* Each client has this additional data */
 struct bmp085_data {
-	struct i2c_client *client;
-	struct mutex lock;
-	struct bmp085_calibration_data calibration;
-	u32 raw_temperature;
-	u32 raw_pressure;
-	unsigned char oversampling_setting;
+	struct	i2c_client *client;
+	struct	mutex lock;
+	struct	bmp085_calibration_data calibration;
+	u8	oversampling_setting;
+	u32	raw_temperature;
+	u32	raw_pressure;
+	u32	temp_measurement_period;
 	unsigned long last_temp_measurement;
-	s32 b6; /* calculated temperature correction coefficient */
+	s32	b6; /* calculated temperature correction coefficient */
 };
 
-
 static s32 bmp085_read_calibration_data(struct i2c_client *client)
 {
 	u16 tmp[BMP085_CALIBRATION_DATA_LENGTH];
@@ -99,12 +95,12 @@ static s32 bmp085_read_calibration_data(struct i2c_client *client)
 	struct bmp085_calibration_data *cali = &(data->calibration);
 	s32 status = i2c_smbus_read_i2c_block_data(client,
 				BMP085_CALIBRATION_DATA_START,
-				BMP085_CALIBRATION_DATA_LENGTH*sizeof(u16),
+				(BMP085_CALIBRATION_DATA_LENGTH << 1),
 				(u8 *)tmp);
 	if (status < 0)
 		return status;
 
-	if (status != BMP085_CALIBRATION_DATA_LENGTH*sizeof(u16))
+	if (status != (BMP085_CALIBRATION_DATA_LENGTH << 1))
 		return -EIO;
 
 	cali->AC1 =  be16_to_cpu(tmp[0]);
@@ -121,7 +117,6 @@ static s32 bmp085_read_calibration_data(struct i2c_client *client)
 	return 0;
 }
 
-
 static s32 bmp085_update_raw_temperature(struct bmp085_data *data)
 {
 	u16 tmp;
@@ -130,7 +125,7 @@ static s32 bmp085_update_raw_temperature(struct bmp085_data *data)
 	mutex_lock(&data->lock);
 	status = i2c_smbus_write_byte_data(data->client, BMP085_CTRL_REG,
 						BMP085_TEMP_MEASUREMENT);
-	if (status != 0) {
+	if (status < 0) {
 		dev_err(&data->client->dev,
 			"Error while requesting temperature measurement.\n");
 		goto exit;
@@ -163,8 +158,9 @@ static s32 bmp085_update_raw_pressure(struct bmp085_data *data)
 
 	mutex_lock(&data->lock);
 	status = i2c_smbus_write_byte_data(data->client, BMP085_CTRL_REG,
-		BMP085_PRESSURE_MEASUREMENT + (data->oversampling_setting<<6));
-	if (status != 0) {
+			BMP085_PRESSURE_MEASUREMENT +
+			(data->oversampling_setting << 6));
+	if (status < 0) {
 		dev_err(&data->client->dev,
 			"Error while requesting pressure measurement.\n");
 		goto exit;
@@ -193,7 +189,6 @@ exit:
 	return status;
 }
 
-
 /*
  * This function starts the temperature measurement and returns the value
  * in tenth of a degree celsius.
@@ -205,7 +200,7 @@ static s32 bmp085_get_temperature(struct bmp085_data *data, int *temperature)
 	int status;
 
 	status = bmp085_update_raw_temperature(data);
-	if (status != 0)
+	if (status < 0)
 		goto exit;
 
 	x1 = ((data->raw_temperature - cali->AC6) * cali->AC5) >> 15;
@@ -222,8 +217,10 @@ exit:
 /*
  * This function starts the pressure measurement and returns the value
  * in millibar. Since the pressure depends on the ambient temperature,
- * a temperature measurement is executed if the last known value is older
- * than one second.
+ * a temperature measurement is executed according to the given temperature
+ * measurement period (default is 1 sec boundary). This period could vary
+ * and needs to be adjusted according to the sensor environment, i.e. if big
+ * temperature variations then the temperature needs to be read out often.
  */
 static s32 bmp085_get_pressure(struct bmp085_data *data, int *pressure)
 {
@@ -234,16 +231,16 @@ static s32 bmp085_get_pressure(struct bmp085_data *data, int *pressure)
 	int status;
 
 	/* alt least every second force an update of the ambient temperature */
-	if (data->last_temp_measurement == 0 ||
-			time_is_before_jiffies(data->last_temp_measurement + 1*HZ)) {
+	if ((data->last_temp_measurement == 0) ||
+	    time_is_before_jiffies(data->last_temp_measurement + 1*HZ)) {
 		status = bmp085_get_temperature(data, NULL);
-		if (status != 0)
-			goto exit;
+		if (status < 0)
+			return status;
 	}
 
 	status = bmp085_update_raw_pressure(data);
-	if (status != 0)
-		goto exit;
+	if (status < 0)
+		return status;
 
 	x1 = (data->b6 * data->b6) >> 12;
 	x1 *= cali->B2;
@@ -274,15 +271,14 @@ static s32 bmp085_get_pressure(struct bmp085_data *data, int *pressure)
 
 	*pressure = p;
 
-exit:
-	return status;
+	return 0;
 }
 
 /*
  * This function sets the chip-internal oversampling. Valid values are 0..3.
  * The chip will use 2^oversampling samples for internal averaging.
  * This influences the measurement time and the accuracy; larger values
- * increase both. The datasheet gives on overview on how measurement time,
+ * increase both. The datasheet gives an overview on how measurement time,
  * accuracy and noise correlate.
  */
 static void bmp085_set_oversampling(struct bmp085_data *data,
@@ -309,12 +305,16 @@ static ssize_t set_oversampling(struct device *dev,
 	struct i2c_client *client = to_i2c_client(dev);
 	struct bmp085_data *data = i2c_get_clientdata(client);
 	unsigned long oversampling;
-	int success = strict_strtoul(buf, 10, &oversampling);
-	if (success == 0) {
+	int err = kstrtoul(buf, 10, &oversampling);
+
+	if (err == 0) {
+		mutex_lock(&data->lock);
 		bmp085_set_oversampling(data, oversampling);
+		mutex_unlock(&data->lock);
 		return count;
 	}
-	return success;
+
+	return err;
 }
 
 static ssize_t show_oversampling(struct device *dev,
@@ -322,6 +322,7 @@ static ssize_t show_oversampling(struct device *dev,
 {
 	struct i2c_client *client = to_i2c_client(dev);
 	struct bmp085_data *data = i2c_get_clientdata(client);
+
 	return sprintf(buf, "%u\n", bmp085_get_oversampling(data));
 }
 static DEVICE_ATTR(oversampling, S_IWUSR | S_IRUGO,
@@ -337,7 +338,7 @@ static ssize_t show_temperature(struct device *dev,
 	struct bmp085_data *data = i2c_get_clientdata(client);
 
 	status = bmp085_get_temperature(data, &temperature);
-	if (status != 0)
+	if (status < 0)
 		return status;
 	else
 		return sprintf(buf, "%d\n", temperature);
@@ -354,7 +355,7 @@ static ssize_t show_pressure(struct device *dev,
 	struct bmp085_data *data = i2c_get_clientdata(client);
 
 	status = bmp085_get_pressure(data, &pressure);
-	if (status != 0)
+	if (status < 0)
 		return status;
 	else
 		return sprintf(buf, "%d\n", pressure);
@@ -386,25 +387,23 @@ static int bmp085_detect(struct i2c_client *client, struct i2c_board_info *info)
 
 static int bmp085_init_client(struct i2c_client *client)
 {
-	unsigned char version;
-	int status;
 	struct bmp085_data *data = i2c_get_clientdata(client);
+	int status = bmp085_read_calibration_data(client);
+
+	if (status < 0)
+		return status;
+
 	data->client = client;
-	status = bmp085_read_calibration_data(client);
-	if (status != 0)
-		goto exit;
-	version = i2c_smbus_read_byte_data(client, BMP085_VERSION_REG);
 	data->last_temp_measurement = 0;
+	data->temp_measurement_period = 1*HZ;
 	data->oversampling_setting = 3;
 	mutex_init(&data->lock);
-	dev_info(&data->client->dev, "BMP085 ver. %d.%d found.\n",
-			(version & 0x0F), (version & 0xF0) >> 4);
-exit:
-	return status;
+
+	return 0;
 }
 
 static int __devinit bmp085_probe(struct i2c_client *client,
-			 const struct i2c_device_id *id)
+			const struct i2c_device_id *id)
 {
 	struct bmp085_data *data;
 	int err = 0;
@@ -415,14 +414,11 @@ static int __devinit bmp085_probe(struct i2c_client *client,
 		goto exit;
 	}
 
-	/* default settings after POR */
-	data->oversampling_setting = 0x00;
-
 	i2c_set_clientdata(client, data);
 
 	/* Initialize the BMP085 chip */
 	err = bmp085_init_client(client);
-	if (err != 0)
+	if (err < 0)
 		goto exit_free;
 
 	/* Register sysfs hooks */
@@ -430,8 +426,9 @@ static int __devinit bmp085_probe(struct i2c_client *client,
 	if (err)
 		goto exit_free;
 
-	dev_info(&data->client->dev, "Successfully initialized bmp085!\n");
-	goto exit;
+	dev_info(&client->dev, "Successfully initialized %s!\n", BMP085_NAME);
+
+	return 0;
 
 exit_free:
 	kfree(data);
@@ -441,13 +438,16 @@ exit:
 
 static int __devexit bmp085_remove(struct i2c_client *client)
 {
+	struct bmp085_data *data = i2c_get_clientdata(client);
+
 	sysfs_remove_group(&client->dev.kobj, &bmp085_attr_group);
-	kfree(i2c_get_clientdata(client));
+	kfree(data);
+
 	return 0;
 }
 
 static const struct i2c_device_id bmp085_id[] = {
-	{ "bmp085", 0 },
+	{ BMP085_NAME, 0 },
 	{ }
 };
 MODULE_DEVICE_TABLE(i2c, bmp085_id);
@@ -455,7 +455,7 @@ MODULE_DEVICE_TABLE(i2c, bmp085_id);
 static struct i2c_driver bmp085_driver = {
 	.driver = {
 		.owner = THIS_MODULE,
-		.name	= "bmp085"
+		.name	= BMP085_NAME
 	},
 	.id_table	= bmp085_id,
 	.probe		= bmp085_probe,
@@ -467,6 +467,6 @@ static struct i2c_driver bmp085_driver = {
 
 module_i2c_driver(bmp085_driver);
 
-MODULE_AUTHOR("Christoph Mair <christoph.mair@gmail.com");
+MODULE_AUTHOR("Christoph Mair <christoph.mair@gmail.com>");
 MODULE_DESCRIPTION("BMP085 driver");
 MODULE_LICENSE("GPL");
-- 
1.7.3.4

