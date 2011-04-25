Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753314Ab1DYUVS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Apr 2011 16:21:18 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:34655 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752339Ab1DYUVR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Apr 2011 16:21:17 -0400
From: John Stultz <john.stultz@linaro.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Akihiro MAEDA <sola.1980.a@gmail.com>,
        Anton Vorontsov <cbouatmailru@gmail.com>,
        John Stultz <john.stultz@linaro.org>
Subject: [PATCH 2/3][RFC] power: virtual battery driver tweaks
Date: Mon, 25 Apr 2011 13:20:28 -0700
Message-Id: <1303762829-18000-3-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.7.3.2.146.gca209
In-Reply-To: <1303762829-18000-1-git-send-email-john.stultz@linaro.org>
References: <1303762829-18000-1-git-send-email-john.stultz@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Akihiro MAEDA <sola.1980.a@gmail.com>

This patch tweaks the virtual battery driver, setting
arguments as const and adding new kernel_param_ops.

CC: Anton Vorontsov <cbouatmailru@gmail.com>
Signed-off-by: Akihiro MAEDA <sola.1980.a@gmail.com>
[john.stultz: Reworded commit log]
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 drivers/power/virtual_battery.c |   53 ++++++++++++++++++++++++++++++--------
 1 files changed, 42 insertions(+), 11 deletions(-)

diff --git a/drivers/power/virtual_battery.c b/drivers/power/virtual_battery.c
index 4ae79d4..ed686ef 100644
--- a/drivers/power/virtual_battery.c
+++ b/drivers/power/virtual_battery.c
@@ -5,6 +5,7 @@
  *
  * Copyright (C) 2008 Pylone, Inc.
  * Author: Masashi YOKOTA <yokota@pylone.jp>
+ * Modified by: Akihiro MAEDA <sola.1980.a@gmail.com>
  *
  * This software is licensed under the terms of the GNU General Public
  * License version 2, as published by the Free Software Foundation, and
@@ -190,7 +191,7 @@ static const char * map_get_key(struct battery_property_map * map, int value, co
 	return def_key;
 }
 
-static int param_set_ac_status(const char *key, struct kernel_param *kp)
+static int param_set_ac_status(const char *key, const struct kernel_param *kp)
 {
 	dev_dbg(&bat_pdev->dev, "%s: name=%s, key=%s\n", __func__, kp->name, key);
 	ac_status = map_get_value( map_ac_online, key, ac_status);
@@ -198,14 +199,14 @@ static int param_set_ac_status(const char *key, struct kernel_param *kp)
 	return 0;
 }
 
-static int param_get_ac_status(char *buffer, struct kernel_param *kp)
+static int param_get_ac_status(char *buffer, const struct kernel_param *kp)
 {
 	dev_dbg(&bat_pdev->dev, "%s: name=%s\n", __func__, kp->name);
 	strcpy(buffer, map_get_key( map_ac_online, ac_status, "unknown"));
 	return strlen(buffer);
 }
 
-static int param_set_battery_status(const char *key, struct kernel_param *kp)
+static int param_set_battery_status(const char *key, const struct kernel_param *kp)
 {
 	dev_dbg(&bat_pdev->dev, "%s: name=%s, key=%s.\n", __func__, kp->name, key);
 	battery_status = map_get_value( map_status, key, battery_status);
@@ -213,14 +214,14 @@ static int param_set_battery_status(const char *key, struct kernel_param *kp)
 	return 0;
 }
 
-static int param_get_battery_status(char *buffer, struct kernel_param *kp)
+static int param_get_battery_status(char *buffer, const struct kernel_param *kp)
 {
 	dev_dbg(&bat_pdev->dev, "%s: name=%s\n", __func__, kp->name);
 	strcpy(buffer, map_get_key( map_status, battery_status, "unknown"));
 	return strlen(buffer);
 }
 
-static int param_set_battery_health(const char *key, struct kernel_param *kp)
+static int param_set_battery_health(const char *key, const struct kernel_param *kp)
 {
 	dev_dbg(&bat_pdev->dev, "%s: name=%s, key=%s\n", __func__, kp->name, key);
 	battery_health = map_get_value( map_health, key, battery_health);
@@ -228,14 +229,14 @@ static int param_set_battery_health(const char *key, struct kernel_param *kp)
 	return 0;
 }
 
-static int param_get_battery_health(char *buffer, struct kernel_param *kp)
+static int param_get_battery_health(char *buffer, const struct kernel_param *kp)
 {
 	dev_dbg(&bat_pdev->dev, "%s: name=%s\n", __func__, kp->name);
 	strcpy(buffer, map_get_key( map_health, battery_health, "unknown"));
 	return strlen(buffer);
 }
 
-static int param_set_battery_present(const char *key, struct kernel_param *kp)
+static int param_set_battery_present(const char *key, const struct kernel_param *kp)
 {
 	dev_dbg(&bat_pdev->dev, "%s: name=%s, key=%s\n", __func__, kp->name, key);
 	battery_present = map_get_value( map_present, key, battery_present);
@@ -243,14 +244,14 @@ static int param_set_battery_present(const char *key, struct kernel_param *kp)
 	return 0;
 }
 
-static int param_get_battery_present(char *buffer, struct kernel_param *kp)
+static int param_get_battery_present(char *buffer, const struct kernel_param *kp)
 {
 	dev_dbg(&bat_pdev->dev, "%s: name=%s\n", __func__, kp->name);
 	strcpy(buffer, map_get_key( map_present, battery_present, "unknown"));
 	return strlen(buffer);
 }
 
-static int param_set_battery_technology(const char *key, struct kernel_param *kp)
+static int param_set_battery_technology(const char *key, const struct kernel_param *kp)
 {
 	dev_dbg(&bat_pdev->dev, "%s: name=%s, key=%s\n", __func__, kp->name, key);
 	battery_technology = map_get_value( map_technology, key, battery_technology);
@@ -258,14 +259,14 @@ static int param_set_battery_technology(const char *key, struct kernel_param *kp
 	return 0;
 }
 
-static int param_get_battery_technology(char *buffer, struct kernel_param *kp)
+static int param_get_battery_technology(char *buffer, const struct kernel_param *kp)
 {
 	dev_dbg(&bat_pdev->dev, "%s: name=%s\n", __func__, kp->name);
 	strcpy(buffer, map_get_key( map_technology, battery_technology, "unknown"));
 	return strlen(buffer);
 }
 
-static int param_set_battery_capacity(const char *key, struct kernel_param *kp)
+static int param_set_battery_capacity(const char *key, const struct kernel_param *kp)
 {
 	int tmp;
 
@@ -314,6 +315,36 @@ static void __exit virtual_battery_exit(void)
 	printk(KERN_INFO KBUILD_BASENAME": unregistered \n");
 }
 
+static struct kernel_param_ops param_ops_ac_status = {
+	.set = param_set_ac_status,
+	.get = param_get_ac_status,
+};
+
+static struct kernel_param_ops param_ops_battery_status = {
+	.set = param_set_battery_status,
+	.get = param_get_battery_status,
+};
+
+static struct kernel_param_ops param_ops_battery_present = {
+	.set = param_set_battery_present,
+	.get = param_get_battery_present,
+};
+
+static struct kernel_param_ops param_ops_battery_technology = {
+	.set = param_set_battery_technology,
+	.get = param_get_battery_technology,
+};
+
+static struct kernel_param_ops param_ops_battery_health = {
+	.set = param_set_battery_health,
+	.get = param_get_battery_health,
+};
+
+static struct kernel_param_ops param_ops_battery_capacity = {
+	.set = param_set_battery_capacity,
+	.get = param_get_battery_capacity,
+};
+
 module_init(virtual_battery_init);
 module_exit(virtual_battery_exit);
 
-- 
1.7.3.2.146.gca209

