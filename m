Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752608Ab0EIKMj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 May 2010 06:12:39 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:52864 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752113Ab0EIKMh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 May 2010 06:12:37 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Cc: uclinux-dist-devel@blackfin.uclinux.org,
       Michael Hennerich <michael.hennerich@analog.com>
Subject: [PATCH 1/6] ad525x_dpot: simplify duplicated sysfs defines
Date: Sun,  9 May 2010 06:15:24 -0400
Message-Id: <1273400129-26101-1-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michael Hennerich <michael.hennerich@analog.com>

Macro away the duplication to make maintenance easier.

Signed-off-by: Michael Hennerich <michael.hennerich@analog.com>
Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 drivers/misc/ad525x_dpot.c |  238 ++++++++------------------------------------
 1 files changed, 43 insertions(+), 195 deletions(-)

diff --git a/drivers/misc/ad525x_dpot.c b/drivers/misc/ad525x_dpot.c
index 30a59f2..e6b274b 100644
--- a/drivers/misc/ad525x_dpot.c
+++ b/drivers/misc/ad525x_dpot.c
@@ -158,175 +158,45 @@ static ssize_t sysfs_do_cmd(struct device *dev,
 
 /* ------------------------------------------------------------------------- */
 
-static ssize_t show_rdac0(struct device *dev,
-			  struct device_attribute *attr, char *buf)
-{
-	return sysfs_show_reg(dev, attr, buf, AD525X_I2C_RDAC | AD525X_RDAC0);
-}
-
-static ssize_t set_rdac0(struct device *dev,
-			 struct device_attribute *attr,
-			 const char *buf, size_t count)
-{
-	return sysfs_set_reg(dev, attr, buf, count,
-			     AD525X_I2C_RDAC | AD525X_RDAC0);
-}
-
-static DEVICE_ATTR(rdac0, S_IWUSR | S_IRUGO, show_rdac0, set_rdac0);
-
-static ssize_t show_eeprom0(struct device *dev,
-			    struct device_attribute *attr, char *buf)
-{
-	return sysfs_show_reg(dev, attr, buf, AD525X_I2C_EEPROM | AD525X_RDAC0);
-}
-
-static ssize_t set_eeprom0(struct device *dev,
-			   struct device_attribute *attr,
-			   const char *buf, size_t count)
-{
-	return sysfs_set_reg(dev, attr, buf, count,
-			     AD525X_I2C_EEPROM | AD525X_RDAC0);
-}
-
-static DEVICE_ATTR(eeprom0, S_IWUSR | S_IRUGO, show_eeprom0, set_eeprom0);
-
-static ssize_t show_tolerance0(struct device *dev,
-			       struct device_attribute *attr, char *buf)
-{
-	return sysfs_show_reg(dev, attr, buf,
-			      AD525X_I2C_EEPROM | AD525X_TOL_RDAC0);
-}
-
-static DEVICE_ATTR(tolerance0, S_IRUGO, show_tolerance0, NULL);
-
-/* ------------------------------------------------------------------------- */
-
-static ssize_t show_rdac1(struct device *dev,
-			  struct device_attribute *attr, char *buf)
-{
-	return sysfs_show_reg(dev, attr, buf, AD525X_I2C_RDAC | AD525X_RDAC1);
+#define DPOT_DEVICE_SHOW(_name, _reg) static ssize_t \
+show_##_name(struct device *dev, \
+			  struct device_attribute *attr, char *buf) \
+{ \
+	return sysfs_show_reg(dev, attr, buf, _reg); \
 }
 
-static ssize_t set_rdac1(struct device *dev,
-			 struct device_attribute *attr,
-			 const char *buf, size_t count)
-{
-	return sysfs_set_reg(dev, attr, buf, count,
-			     AD525X_I2C_RDAC | AD525X_RDAC1);
+#define DPOT_DEVICE_SET(_name, _reg) static ssize_t \
+set_##_name(struct device *dev, \
+			 struct device_attribute *attr, \
+			 const char *buf, size_t count) \
+{ \
+	return sysfs_set_reg(dev, attr, buf, count, _reg); \
 }
 
-static DEVICE_ATTR(rdac1, S_IWUSR | S_IRUGO, show_rdac1, set_rdac1);
+#define DPOT_DEVICE_SHOW_SET(name, reg) \
+DPOT_DEVICE_SHOW(name, reg) \
+DPOT_DEVICE_SET(name, reg) \
+static DEVICE_ATTR(name, S_IWUSR | S_IRUGO, show_##name, set_##name);
 
-static ssize_t show_eeprom1(struct device *dev,
-			    struct device_attribute *attr, char *buf)
-{
-	return sysfs_show_reg(dev, attr, buf, AD525X_I2C_EEPROM | AD525X_RDAC1);
-}
+#define DPOT_DEVICE_SHOW_ONLY(name, reg) \
+DPOT_DEVICE_SHOW(name, reg) \
+static DEVICE_ATTR(name, S_IWUSR | S_IRUGO, show_##name, NULL);
 
-static ssize_t set_eeprom1(struct device *dev,
-			   struct device_attribute *attr,
-			   const char *buf, size_t count)
-{
-	return sysfs_set_reg(dev, attr, buf, count,
-			     AD525X_I2C_EEPROM | AD525X_RDAC1);
-}
+DPOT_DEVICE_SHOW_SET(rdac0, AD525X_I2C_RDAC | AD525X_RDAC0);
+DPOT_DEVICE_SHOW_SET(eeprom0, AD525X_I2C_EEPROM | AD525X_RDAC0);
+DPOT_DEVICE_SHOW_ONLY(tolerance0, AD525X_I2C_EEPROM | AD525X_TOL_RDAC0);
 
-static DEVICE_ATTR(eeprom1, S_IWUSR | S_IRUGO, show_eeprom1, set_eeprom1);
+DPOT_DEVICE_SHOW_SET(rdac1, AD525X_I2C_RDAC | AD525X_RDAC1);
+DPOT_DEVICE_SHOW_SET(eeprom1, AD525X_I2C_EEPROM | AD525X_RDAC1);
+DPOT_DEVICE_SHOW_ONLY(tolerance1, AD525X_I2C_EEPROM | AD525X_TOL_RDAC1);
 
-static ssize_t show_tolerance1(struct device *dev,
-			       struct device_attribute *attr, char *buf)
-{
-	return sysfs_show_reg(dev, attr, buf,
-			      AD525X_I2C_EEPROM | AD525X_TOL_RDAC1);
-}
-
-static DEVICE_ATTR(tolerance1, S_IRUGO, show_tolerance1, NULL);
+DPOT_DEVICE_SHOW_SET(rdac2, AD525X_I2C_RDAC | AD525X_RDAC2);
+DPOT_DEVICE_SHOW_SET(eeprom2, AD525X_I2C_EEPROM | AD525X_RDAC2);
+DPOT_DEVICE_SHOW_ONLY(tolerance2, AD525X_I2C_EEPROM | AD525X_TOL_RDAC2);
 
-/* ------------------------------------------------------------------------- */
-
-static ssize_t show_rdac2(struct device *dev,
-			  struct device_attribute *attr, char *buf)
-{
-	return sysfs_show_reg(dev, attr, buf, AD525X_I2C_RDAC | AD525X_RDAC2);
-}
-
-static ssize_t set_rdac2(struct device *dev,
-			 struct device_attribute *attr,
-			 const char *buf, size_t count)
-{
-	return sysfs_set_reg(dev, attr, buf, count,
-			     AD525X_I2C_RDAC | AD525X_RDAC2);
-}
-
-static DEVICE_ATTR(rdac2, S_IWUSR | S_IRUGO, show_rdac2, set_rdac2);
-
-static ssize_t show_eeprom2(struct device *dev,
-			    struct device_attribute *attr, char *buf)
-{
-	return sysfs_show_reg(dev, attr, buf, AD525X_I2C_EEPROM | AD525X_RDAC2);
-}
-
-static ssize_t set_eeprom2(struct device *dev,
-			   struct device_attribute *attr,
-			   const char *buf, size_t count)
-{
-	return sysfs_set_reg(dev, attr, buf, count,
-			     AD525X_I2C_EEPROM | AD525X_RDAC2);
-}
-
-static DEVICE_ATTR(eeprom2, S_IWUSR | S_IRUGO, show_eeprom2, set_eeprom2);
-
-static ssize_t show_tolerance2(struct device *dev,
-			       struct device_attribute *attr, char *buf)
-{
-	return sysfs_show_reg(dev, attr, buf,
-			      AD525X_I2C_EEPROM | AD525X_TOL_RDAC2);
-}
-
-static DEVICE_ATTR(tolerance2, S_IRUGO, show_tolerance2, NULL);
-
-/* ------------------------------------------------------------------------- */
-
-static ssize_t show_rdac3(struct device *dev,
-			  struct device_attribute *attr, char *buf)
-{
-	return sysfs_show_reg(dev, attr, buf, AD525X_I2C_RDAC | AD525X_RDAC3);
-}
-
-static ssize_t set_rdac3(struct device *dev,
-			 struct device_attribute *attr,
-			 const char *buf, size_t count)
-{
-	return sysfs_set_reg(dev, attr, buf, count,
-			     AD525X_I2C_RDAC | AD525X_RDAC3);
-}
-
-static DEVICE_ATTR(rdac3, S_IWUSR | S_IRUGO, show_rdac3, set_rdac3);
-
-static ssize_t show_eeprom3(struct device *dev,
-			    struct device_attribute *attr, char *buf)
-{
-	return sysfs_show_reg(dev, attr, buf, AD525X_I2C_EEPROM | AD525X_RDAC3);
-}
-
-static ssize_t set_eeprom3(struct device *dev,
-			   struct device_attribute *attr,
-			   const char *buf, size_t count)
-{
-	return sysfs_set_reg(dev, attr, buf, count,
-			     AD525X_I2C_EEPROM | AD525X_RDAC3);
-}
-
-static DEVICE_ATTR(eeprom3, S_IWUSR | S_IRUGO, show_eeprom3, set_eeprom3);
-
-static ssize_t show_tolerance3(struct device *dev,
-			       struct device_attribute *attr, char *buf)
-{
-	return sysfs_show_reg(dev, attr, buf,
-			      AD525X_I2C_EEPROM | AD525X_TOL_RDAC3);
-}
-
-static DEVICE_ATTR(tolerance3, S_IRUGO, show_tolerance3, NULL);
+DPOT_DEVICE_SHOW_SET(rdac3, AD525X_I2C_RDAC | AD525X_RDAC3);
+DPOT_DEVICE_SHOW_SET(eeprom3, AD525X_I2C_EEPROM | AD525X_RDAC3);
+DPOT_DEVICE_SHOW_ONLY(tolerance3, AD525X_I2C_EEPROM | AD525X_TOL_RDAC3);
 
 static struct attribute *ad525x_attributes_wipers[4][4] = {
 	{
@@ -361,41 +231,19 @@ static const struct attribute_group ad525x_group_wipers[] = {
 
 /* ------------------------------------------------------------------------- */
 
-static ssize_t set_inc_all(struct device *dev,
-			   struct device_attribute *attr,
-			   const char *buf, size_t count)
-{
-	return sysfs_do_cmd(dev, attr, buf, count, AD525X_INC_ALL);
-}
-
-static DEVICE_ATTR(inc_all, S_IWUSR, NULL, set_inc_all);
-
-static ssize_t set_dec_all(struct device *dev,
-			   struct device_attribute *attr,
-			   const char *buf, size_t count)
-{
-	return sysfs_do_cmd(dev, attr, buf, count, AD525X_DEC_ALL);
-}
-
-static DEVICE_ATTR(dec_all, S_IWUSR, NULL, set_dec_all);
-
-static ssize_t set_inc_all_6db(struct device *dev,
-			       struct device_attribute *attr,
-			       const char *buf, size_t count)
-{
-	return sysfs_do_cmd(dev, attr, buf, count, AD525X_INC_ALL_6DB);
-}
-
-static DEVICE_ATTR(inc_all_6db, S_IWUSR, NULL, set_inc_all_6db);
-
-static ssize_t set_dec_all_6db(struct device *dev,
-			       struct device_attribute *attr,
-			       const char *buf, size_t count)
-{
-	return sysfs_do_cmd(dev, attr, buf, count, AD525X_DEC_ALL_6DB);
-}
-
-static DEVICE_ATTR(dec_all_6db, S_IWUSR, NULL, set_dec_all_6db);
+#define DPOT_DEVICE_DO_CMD(_name, _cmd) static ssize_t \
+set_##_name(struct device *dev, \
+			 struct device_attribute *attr, \
+			 const char *buf, size_t count) \
+{ \
+	return sysfs_do_cmd(dev, attr, buf, count, _cmd); \
+} \
+static DEVICE_ATTR(_name, S_IWUSR | S_IRUGO, NULL, set_##_name);
+
+DPOT_DEVICE_DO_CMD(inc_all, AD525X_INC_ALL);
+DPOT_DEVICE_DO_CMD(dec_all, AD525X_DEC_ALL);
+DPOT_DEVICE_DO_CMD(inc_all_6db, AD525X_INC_ALL_6DB);
+DPOT_DEVICE_DO_CMD(dec_all_6db, AD525X_DEC_ALL_6DB);
 
 static struct attribute *ad525x_attributes_commands[] = {
 	&dev_attr_inc_all.attr,
-- 
1.7.1

