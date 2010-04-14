Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756972Ab0DNVgh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Apr 2010 17:36:37 -0400
Received: from mail.perches.com ([173.55.12.10]:1486 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755935Ab0DNVgf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Apr 2010 17:36:35 -0400
Subject: Re: [PATCH 1/4] hmc6352: Add driver for the HMC6352 compass
From: Joe Perches <joe@perches.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Kalhan Trisal <kalhan.trisal@intel.com>
Cc: Jonathan Cameron <kernel@jic23.retrosnub.co.uk>, linux-i2c@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20100414161904.713eef78@lxorguk.ukuu.org.uk>
References: <20100414124913.23181.75903.stgit@localhost.localdomain>
	 <20100414125136.23181.16788.stgit@localhost.localdomain>
	 <4BC5C7A8.1040807@cam.ac.uk> <20100414153234.22765666@lxorguk.ukuu.org.uk>
	 <4BC5D681.20707@jic23.retrosnub.co.uk>
	 <20100414161904.713eef78@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 14 Apr 2010 14:36:33 -0700
Message-ID: <1271280993.1833.36.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Trivial neatening

Argument alignment
Spacing
Make chars static
Remove prefixes from dev_<level> logging

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/misc/hmc6352.c |   44 ++++++++++++++++++++++----------------------
 1 files changed, 22 insertions(+), 22 deletions(-)

diff --git a/drivers/misc/hmc6352.c b/drivers/misc/hmc6352.c
index 1c1e974..2c12dc3 100644
--- a/drivers/misc/hmc6352.c
+++ b/drivers/misc/hmc6352.c
@@ -30,13 +30,14 @@
 #include <linux/sysfs.h>
 
 static ssize_t compass_calibration_store(struct device *dev,
-		struct device_attribute *attr, const char *buf, size_t count)
+					 struct device_attribute *attr,
+					 const char *buf, size_t count)
 {
 	struct i2c_client *client = to_i2c_client(dev);
 	int ret;
 	unsigned long val;
-	char  cmd = 'C';	/* Calibrate */
-	char  cmd1 = 'E';	/* Exit calibration mode */
+	static char cmd = 'C';		/* Calibrate */
+	static char cmd1 = 'E';		/* Exit calibration mode */
 	struct i2c_msg msg[] = {
 		{ client->addr, 0, 1, &cmd },
 	};
@@ -49,13 +50,13 @@ static ssize_t compass_calibration_store(struct device *dev,
 	if (val == 1) {
 		ret = i2c_transfer(client->adapter, msg, 1);
 		if (ret != 1) {
-			dev_warn(dev, "hmc6352_comp: i2c calib start cmd failed\n");
+			dev_warn(dev, "i2c calib start cmd failed\n");
 			return ret;
 		}
 	} else if (val == 2) {
 		ret = i2c_transfer(client->adapter, msg1, 1);
 		if (ret != 1) {
-			dev_warn(dev, "hmc6352_comp: i2c calib stop cmd failed\n");
+			dev_warn(dev, "i2c calib stop cmd failed\n");
 			return ret;
 		}
 	} else
@@ -65,9 +66,9 @@ static ssize_t compass_calibration_store(struct device *dev,
 }
 
 static ssize_t compass_heading_data_show(struct device *dev,
-			struct device_attribute *attr, char *buf)
+					 struct device_attribute *attr,
+					 char *buf)
 {
-
 	struct i2c_client *client = to_i2c_client(dev);
 	static char cmd = 'A';		/* Get Data */
 	unsigned char i2c_data[2];
@@ -81,22 +82,22 @@ static ssize_t compass_heading_data_show(struct device *dev,
 
 	ret = i2c_transfer(client->adapter, msg, 1);
 	if (ret != 1) {
-		dev_warn(dev, "hmc6352: i2c cmd 0x41 failed\n");
+		dev_warn(dev, "i2c cmd 0x41 failed\n");
 		return ret;
 	}
-	msleep(10); /* sending 0x41 cmd we need to wait for 7-10 milli second*/
+	msleep(10); /* sending 0x41 cmd we need to wait for 7-10 milliseconds */
 	ret = i2c_transfer(client->adapter, msg1, 1);
 	if (ret != 1) {
-		dev_warn(dev, "hmc6352: i2c read data cmd failed\n");
+		dev_warn(dev, "i2c read data cmd failed\n");
 		return ret;
 	}
-	ret_val = i2c_data[0];
-	ret_val = ((ret_val << 8) | i2c_data[1]);
+	ret_val = ((unsigned int)i2c_data[0] << 8) | i2c_data[1];
 	return sprintf(buf, "%d.%d\n", ret_val/10, ret_val%10);
 }
 
 static ssize_t compass_power_mode_store(struct device *dev,
-		struct device_attribute *attr, const  char *buf, size_t count)
+					struct device_attribute *attr,
+					const char *buf, size_t count)
 {
 
 	struct i2c_client *client = to_i2c_client(dev);
@@ -117,11 +118,11 @@ static ssize_t compass_power_mode_store(struct device *dev,
 	if (val == 0) {
 		ret = i2c_transfer(client->adapter, msg, 1);
 		if (ret != 1)
-			dev_warn(dev, "hmc6352: i2c cmd  sleep mode failed\n");
+			dev_warn(dev, "i2c cmd sleep mode failed\n");
 	} else if (val == 1) {
 		ret = i2c_transfer(client->adapter, msg1, 1);
 		if (ret != 1)
-			dev_warn(dev, "hmc6352: i2c cmd active mode failed\n");
+			dev_warn(dev, "i2c cmd active mode failed\n");
 	} else
 		return -EINVAL;
 
@@ -144,18 +145,17 @@ static struct attribute_group m_compass_gr = {
 	.attrs = mid_att_compass
 };
 
-static int  hmc6352_probe(struct i2c_client *client,
-					const struct i2c_device_id *id)
+static int hmc6352_probe(struct i2c_client *client,
+			 const struct i2c_device_id *id)
 {
 	int res;
 
 	res = sysfs_create_group(&client->dev.kobj, &m_compass_gr);
 	if (res) {
-		dev_err(&client->dev, "hmc6352: device_create_file failed\n");
+		dev_err(&client->dev, "sysfs_create_group failed\n");
 		return res;
 	}
-	dev_info(&client->dev, "%s HMC6352 compass chip found\n",
-		client->name);
+	dev_info(&client->dev, "%s HMC6352 compass chip found\n", client->name);
 	return 0;
 }
 
@@ -174,7 +174,7 @@ MODULE_DEVICE_TABLE(i2c, hmc6352_id);
 
 static struct i2c_driver hmc6352_driver = {
 	.driver = {
-	.name = "hmc6352",
+		.name = "hmc6352",
 	},
 	.probe = hmc6352_probe,
 	.remove = hmc6352_remove,
@@ -186,7 +186,7 @@ static int __init sensor_hmc6352_init(void)
 	return i2c_add_driver(&hmc6352_driver);
 }
 
-static void  __exit sensor_hmc6352_exit(void)
+static void __exit sensor_hmc6352_exit(void)
 {
 	i2c_del_driver(&hmc6352_driver);
 }


