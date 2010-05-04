Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756810Ab0EDJ4r (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 May 2010 05:56:47 -0400
Received: from ch-smtp02.sth.basefarm.net ([80.76.149.213]:54029 "EHLO
	ch-smtp02.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754775Ab0EDJ4q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 May 2010 05:56:46 -0400
From: "Henrik Rydberg" <rydberg@euromail.se>
To: Jean Delvare <khali@linux-fr.org>
Cc: lm-sensors@lm-sensors.org, linux-kernel@vger.kernel.org,
       Alex Murray <murray.alex@gmail.com>,
       Henrik Rydberg <rydberg@euromail.se>
Subject: [PATCH] hwmon: applesmc: Add temperature sensor labels to sysfs interface
Date: Tue,  4 May 2010 11:55:29 +0200
Message-Id: <1272966929-14501-1-git-send-email-rydberg@euromail.se>
X-Mailer: git-send-email 1.6.3.3
X-Originating-IP: 83.248.196.134
X-Scan-Result: No virus found in message 1O9Eqw-0007sy-7t.
X-Scan-Signature: ch-smtp02.sth.basefarm.net 1O9Eqw-0007sy-7t 639090a029340c69ead1f5f88f3de658
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alex Murray <murray.alex@gmail.com>

The Apple SMC uses a systematic labeling scheme for the hardware
temperature sensors. This scheme is currently hidden from
userland. Since the sensor set, and consequently the numbering,
differs between models, an extensive database of configurations is
required for an application such as fan control. This patch adds the
SMC labels to the hwmon sysfs interface, allowing applications to use
the sensors more intelligibly.

Signed-off-by: Alex Murray <murray.alex@gmail.com>
Signed-off-by: Henrik Rydberg <rydberg@euromail.se>
---
 drivers/hwmon/applesmc.c |  145 +++++++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 144 insertions(+), 1 deletions(-)

diff --git a/drivers/hwmon/applesmc.c b/drivers/hwmon/applesmc.c
index 36a0d62..8be86ef 100644
--- a/drivers/hwmon/applesmc.c
+++ b/drivers/hwmon/applesmc.c
@@ -657,6 +657,17 @@ out:
 		return snprintf(sysfsbuf, PAGE_SIZE, "(%d,%d)\n", left, right);
 }
 
+/* Displays sensor key as label */
+static ssize_t applesmc_show_sensor_label(struct device *dev,
+			struct device_attribute *devattr, char *sysfsbuf)
+{
+	struct sensor_device_attribute *attr = to_sensor_dev_attr(devattr);
+	const char *key =
+		temperature_sensors_sets[applesmc_temperature_set][attr->index];
+
+	return snprintf(sysfsbuf, PAGE_SIZE, "%s\n", key);
+}
+
 /* Displays degree Celsius * 1000 */
 static ssize_t applesmc_show_temperature(struct device *dev,
 			struct device_attribute *devattr, char *sysfsbuf)
@@ -1124,6 +1135,86 @@ static const struct attribute_group fan_attribute_groups[] = {
 /*
  * Temperature sensors sysfs entries.
  */
+static SENSOR_DEVICE_ATTR(temp1_label, S_IRUGO,
+					applesmc_show_sensor_label, NULL, 0);
+static SENSOR_DEVICE_ATTR(temp2_label, S_IRUGO,
+					applesmc_show_sensor_label, NULL, 1);
+static SENSOR_DEVICE_ATTR(temp3_label, S_IRUGO,
+					applesmc_show_sensor_label, NULL, 2);
+static SENSOR_DEVICE_ATTR(temp4_label, S_IRUGO,
+					applesmc_show_sensor_label, NULL, 3);
+static SENSOR_DEVICE_ATTR(temp5_label, S_IRUGO,
+					applesmc_show_sensor_label, NULL, 4);
+static SENSOR_DEVICE_ATTR(temp6_label, S_IRUGO,
+					applesmc_show_sensor_label, NULL, 5);
+static SENSOR_DEVICE_ATTR(temp7_label, S_IRUGO,
+					applesmc_show_sensor_label, NULL, 6);
+static SENSOR_DEVICE_ATTR(temp8_label, S_IRUGO,
+					applesmc_show_sensor_label, NULL, 7);
+static SENSOR_DEVICE_ATTR(temp9_label, S_IRUGO,
+					applesmc_show_sensor_label, NULL, 8);
+static SENSOR_DEVICE_ATTR(temp10_label, S_IRUGO,
+					applesmc_show_sensor_label, NULL, 9);
+static SENSOR_DEVICE_ATTR(temp11_label, S_IRUGO,
+					applesmc_show_sensor_label, NULL, 10);
+static SENSOR_DEVICE_ATTR(temp12_label, S_IRUGO,
+					applesmc_show_sensor_label, NULL, 11);
+static SENSOR_DEVICE_ATTR(temp13_label, S_IRUGO,
+					applesmc_show_sensor_label, NULL, 12);
+static SENSOR_DEVICE_ATTR(temp14_label, S_IRUGO,
+					applesmc_show_sensor_label, NULL, 13);
+static SENSOR_DEVICE_ATTR(temp15_label, S_IRUGO,
+					applesmc_show_sensor_label, NULL, 14);
+static SENSOR_DEVICE_ATTR(temp16_label, S_IRUGO,
+					applesmc_show_sensor_label, NULL, 15);
+static SENSOR_DEVICE_ATTR(temp17_label, S_IRUGO,
+					applesmc_show_sensor_label, NULL, 16);
+static SENSOR_DEVICE_ATTR(temp18_label, S_IRUGO,
+					applesmc_show_sensor_label, NULL, 17);
+static SENSOR_DEVICE_ATTR(temp19_label, S_IRUGO,
+					applesmc_show_sensor_label, NULL, 18);
+static SENSOR_DEVICE_ATTR(temp20_label, S_IRUGO,
+					applesmc_show_sensor_label, NULL, 19);
+static SENSOR_DEVICE_ATTR(temp21_label, S_IRUGO,
+					applesmc_show_sensor_label, NULL, 20);
+static SENSOR_DEVICE_ATTR(temp22_label, S_IRUGO,
+					applesmc_show_sensor_label, NULL, 21);
+static SENSOR_DEVICE_ATTR(temp23_label, S_IRUGO,
+					applesmc_show_sensor_label, NULL, 22);
+static SENSOR_DEVICE_ATTR(temp24_label, S_IRUGO,
+					applesmc_show_sensor_label, NULL, 23);
+static SENSOR_DEVICE_ATTR(temp25_label, S_IRUGO,
+					applesmc_show_sensor_label, NULL, 24);
+static SENSOR_DEVICE_ATTR(temp26_label, S_IRUGO,
+					applesmc_show_sensor_label, NULL, 25);
+static SENSOR_DEVICE_ATTR(temp27_label, S_IRUGO,
+					applesmc_show_sensor_label, NULL, 26);
+static SENSOR_DEVICE_ATTR(temp28_label, S_IRUGO,
+					applesmc_show_sensor_label, NULL, 27);
+static SENSOR_DEVICE_ATTR(temp29_label, S_IRUGO,
+					applesmc_show_sensor_label, NULL, 28);
+static SENSOR_DEVICE_ATTR(temp30_label, S_IRUGO,
+					applesmc_show_sensor_label, NULL, 29);
+static SENSOR_DEVICE_ATTR(temp31_label, S_IRUGO,
+					applesmc_show_sensor_label, NULL, 30);
+static SENSOR_DEVICE_ATTR(temp32_label, S_IRUGO,
+					applesmc_show_sensor_label, NULL, 31);
+static SENSOR_DEVICE_ATTR(temp33_label, S_IRUGO,
+					applesmc_show_sensor_label, NULL, 32);
+static SENSOR_DEVICE_ATTR(temp34_label, S_IRUGO,
+					applesmc_show_sensor_label, NULL, 33);
+static SENSOR_DEVICE_ATTR(temp35_label, S_IRUGO,
+					applesmc_show_sensor_label, NULL, 34);
+static SENSOR_DEVICE_ATTR(temp36_label, S_IRUGO,
+					applesmc_show_sensor_label, NULL, 35);
+static SENSOR_DEVICE_ATTR(temp37_label, S_IRUGO,
+					applesmc_show_sensor_label, NULL, 36);
+static SENSOR_DEVICE_ATTR(temp38_label, S_IRUGO,
+					applesmc_show_sensor_label, NULL, 37);
+static SENSOR_DEVICE_ATTR(temp39_label, S_IRUGO,
+					applesmc_show_sensor_label, NULL, 38);
+static SENSOR_DEVICE_ATTR(temp40_label, S_IRUGO,
+					applesmc_show_sensor_label, NULL, 39);
 static SENSOR_DEVICE_ATTR(temp1_input, S_IRUGO,
 					applesmc_show_temperature, NULL, 0);
 static SENSOR_DEVICE_ATTR(temp2_input, S_IRUGO,
@@ -1205,6 +1296,50 @@ static SENSOR_DEVICE_ATTR(temp39_input, S_IRUGO,
 static SENSOR_DEVICE_ATTR(temp40_input, S_IRUGO,
 					applesmc_show_temperature, NULL, 39);
 
+static struct attribute *label_attributes[] = {
+	&sensor_dev_attr_temp1_label.dev_attr.attr,
+	&sensor_dev_attr_temp2_label.dev_attr.attr,
+	&sensor_dev_attr_temp3_label.dev_attr.attr,
+	&sensor_dev_attr_temp4_label.dev_attr.attr,
+	&sensor_dev_attr_temp5_label.dev_attr.attr,
+	&sensor_dev_attr_temp6_label.dev_attr.attr,
+	&sensor_dev_attr_temp7_label.dev_attr.attr,
+	&sensor_dev_attr_temp8_label.dev_attr.attr,
+	&sensor_dev_attr_temp9_label.dev_attr.attr,
+	&sensor_dev_attr_temp10_label.dev_attr.attr,
+	&sensor_dev_attr_temp11_label.dev_attr.attr,
+	&sensor_dev_attr_temp12_label.dev_attr.attr,
+	&sensor_dev_attr_temp13_label.dev_attr.attr,
+	&sensor_dev_attr_temp14_label.dev_attr.attr,
+	&sensor_dev_attr_temp15_label.dev_attr.attr,
+	&sensor_dev_attr_temp16_label.dev_attr.attr,
+	&sensor_dev_attr_temp17_label.dev_attr.attr,
+	&sensor_dev_attr_temp18_label.dev_attr.attr,
+	&sensor_dev_attr_temp19_label.dev_attr.attr,
+	&sensor_dev_attr_temp20_label.dev_attr.attr,
+	&sensor_dev_attr_temp21_label.dev_attr.attr,
+	&sensor_dev_attr_temp22_label.dev_attr.attr,
+	&sensor_dev_attr_temp23_label.dev_attr.attr,
+	&sensor_dev_attr_temp24_label.dev_attr.attr,
+	&sensor_dev_attr_temp25_label.dev_attr.attr,
+	&sensor_dev_attr_temp26_label.dev_attr.attr,
+	&sensor_dev_attr_temp27_label.dev_attr.attr,
+	&sensor_dev_attr_temp28_label.dev_attr.attr,
+	&sensor_dev_attr_temp29_label.dev_attr.attr,
+	&sensor_dev_attr_temp30_label.dev_attr.attr,
+	&sensor_dev_attr_temp31_label.dev_attr.attr,
+	&sensor_dev_attr_temp32_label.dev_attr.attr,
+	&sensor_dev_attr_temp33_label.dev_attr.attr,
+	&sensor_dev_attr_temp34_label.dev_attr.attr,
+	&sensor_dev_attr_temp35_label.dev_attr.attr,
+	&sensor_dev_attr_temp36_label.dev_attr.attr,
+	&sensor_dev_attr_temp37_label.dev_attr.attr,
+	&sensor_dev_attr_temp38_label.dev_attr.attr,
+	&sensor_dev_attr_temp39_label.dev_attr.attr,
+	&sensor_dev_attr_temp40_label.dev_attr.attr,
+	NULL
+};
+
 static struct attribute *temperature_attributes[] = {
 	&sensor_dev_attr_temp1_input.dev_attr.attr,
 	&sensor_dev_attr_temp2_input.dev_attr.attr,
@@ -1252,6 +1387,9 @@ static struct attribute *temperature_attributes[] = {
 static const struct attribute_group temperature_attributes_group =
 	{ .attrs = temperature_attributes };
 
+static const struct attribute_group label_attributes_group = {
+	.attrs = label_attributes
+};
 /* Module stuff */
 
 /*
@@ -1568,7 +1706,8 @@ static int __init applesmc_init(void)
 	for (i = 0;
 	     temperature_sensors_sets[applesmc_temperature_set][i] != NULL;
 	     i++) {
-		if (temperature_attributes[i] == NULL) {
+		if (temperature_attributes[i] == NULL ||
+		    label_attributes[i] == NULL) {
 			printk(KERN_ERR "applesmc: More temperature sensors "
 				"in temperature_sensors_sets (at least %i)"
 				"than available sysfs files in "
@@ -1578,6 +1717,8 @@ static int __init applesmc_init(void)
 		}
 		ret = sysfs_create_file(&pdev->dev.kobj,
 						temperature_attributes[i]);
+		ret = sysfs_create_file(&pdev->dev.kobj,
+						label_attributes[i]);
 		if (ret)
 			goto out_temperature;
 	}
@@ -1630,6 +1771,7 @@ out_accelerometer:
 	if (applesmc_accelerometer)
 		applesmc_release_accelerometer();
 out_temperature:
+	sysfs_remove_group(&pdev->dev.kobj, &label_attributes_group);
 	sysfs_remove_group(&pdev->dev.kobj, &temperature_attributes_group);
 	sysfs_remove_group(&pdev->dev.kobj, &fan_attribute_groups[0]);
 out_fan_1:
@@ -1659,6 +1801,7 @@ static void __exit applesmc_exit(void)
 	}
 	if (applesmc_accelerometer)
 		applesmc_release_accelerometer();
+	sysfs_remove_group(&pdev->dev.kobj, &label_attributes_group);
 	sysfs_remove_group(&pdev->dev.kobj, &temperature_attributes_group);
 	sysfs_remove_group(&pdev->dev.kobj, &fan_attribute_groups[0]);
 	sysfs_remove_group(&pdev->dev.kobj, &fan_attribute_groups[1]);
-- 
1.6.3.3

