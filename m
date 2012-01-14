Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758014Ab2ANBjo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jan 2012 20:39:44 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:48900 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757850Ab2ANBjl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jan 2012 20:39:41 -0500
MIME-Version: 1.0
Date: Fri, 13 Jan 2012 19:39:41 -0600
Message-ID: <CAPbJ=B=Z=FRiuR0Cb5uQhtNxWoARr59iFocnd0VRzNfSKXLp_w@mail.gmail.com>
Subject: [RFC][PATCH 1/2] hwmon: (w83627ehf) Replace deprecated strict_strto*
From: Alex Rio <scasbyte@gmail.com>
To: khali@linux-fr.org, guenter.roeck@ericsson.com
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replaces deprecated function strict_strto* to kstrto*. In the future
the strict_strto could disappear so the replacement was done.
I'm not sure if this is being done for all the files in a single
patch, anyway I'm including it here just in case.
Checkpatch.pl now leaves 5 "errors", they are mostly
assignments inside if's statements, taking them out does not
significantly increases readability.

Signed-off-by: Alex Rio <scasbyte@gmail.com>
---
 drivers/hwmon/w83627ehf.c |   22 +++++++++++-----------
 1 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/hwmon/w83627ehf.c b/drivers/hwmon/w83627ehf.c
index 93f5fc7..0e0af04 100644
--- a/drivers/hwmon/w83627ehf.c
+++ b/drivers/hwmon/w83627ehf.c
@@ -937,7 +937,7 @@ store_in_##reg(struct device *dev, struct
device_attribute *attr, \
 	int nr = sensor_attr->index; \
 	unsigned long val; \
 	int err; \
-	err = strict_strtoul(buf, 10, &val); \
+	err = kstrtoul(buf, 10, &val); \
 	if (err < 0) \
 		return err; \
 	mutex_lock(&data->update_lock); \
@@ -1054,7 +1054,7 @@ store_fan_min(struct device *dev, struct
device_attribute *attr,
 	unsigned int reg;
 	u8 new_div;

-	err = strict_strtoul(buf, 10, &val);
+	err = kstrtoul(buf, 10, &val);
 	if (err < 0)
 		return err;

@@ -1199,7 +1199,7 @@ store_##reg(struct device *dev, struct
device_attribute *attr, \
 	int nr = sensor_attr->index; \
 	int err; \
 	long val; \
-	err = strict_strtol(buf, 10, &val); \
+	err = kstrtol(buf, 10, &val); \
 	if (err < 0) \
 		return err; \
 	mutex_lock(&data->update_lock); \
@@ -1324,7 +1324,7 @@ store_pwm_mode(struct device *dev, struct
device_attribute *attr,
 	int err;
 	u16 reg;

-	err = strict_strtoul(buf, 10, &val);
+	err = kstrtoul(buf, 10, &val);
 	if (err < 0)
 		return err;

@@ -1351,7 +1351,7 @@ store_pwm(struct device *dev, struct
device_attribute *attr,
 	unsigned long val;
 	int err;

-	err = strict_strtoul(buf, 10, &val);
+	err = kstrtoul(buf, 10, &val);
 	if (err < 0)
 		return err;

@@ -1376,7 +1376,7 @@ store_pwm_enable(struct device *dev, struct
device_attribute *attr,
 	int err;
 	u16 reg;

-	err = strict_strtoul(buf, 10, &val);
+	err = kstrtoul(buf, 10, &val);
 	if (err < 0)
 		return err;

@@ -1430,7 +1430,7 @@ store_target_temp(struct device *dev, struct
device_attribute *attr,
 	long val;
 	int err;

-	err = strict_strtol(buf, 10, &val);
+	err = kstrtol(buf, 10, &val);
 	if (err < 0)
 		return err;

@@ -1455,7 +1455,7 @@ store_tolerance(struct device *dev, struct
device_attribute *attr,
 	long val;
 	int err;

-	err = strict_strtol(buf, 10, &val);
+	err = kstrtol(buf, 10, &val);
 	if (err < 0)
 		return err;

@@ -1556,7 +1556,7 @@ store_##reg(struct device *dev, struct
device_attribute *attr, \
 	int nr = sensor_attr->index; \
 	unsigned long val; \
 	int err; \
-	err = strict_strtoul(buf, 10, &val); \
+	err = kstrtoul(buf, 10, &val); \
 	if (err < 0) \
 		return err; \
 	val = SENSORS_LIMIT(val, 1, 255); \
@@ -1595,7 +1595,7 @@ store_##reg(struct device *dev, struct
device_attribute *attr, \
 	int nr = sensor_attr->index; \
 	unsigned long val; \
 	int err; \
-	err = strict_strtoul(buf, 10, &val); \
+	err = kstrtoul(buf, 10, &val); \
 	if (err < 0) \
 		return err; \
 	val = step_time_to_reg(val, data->pwm_mode[nr]); \
@@ -1702,7 +1702,7 @@ clear_caseopen(struct device *dev, struct
device_attribute *attr,
 	unsigned long val;
 	u16 reg, mask;

-	if (strict_strtoul(buf, 10, &val) || val != 0)
+	if (kstrtoul(buf, 10, &val) || val != 0)
 		return -EINVAL;

 	mask = to_sensor_dev_attr_2(attr)->nr;
