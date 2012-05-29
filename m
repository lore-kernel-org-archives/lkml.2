Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753372Ab2E2JiA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2012 05:38:00 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:61820 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753299Ab2E2Jh4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2012 05:37:56 -0400
From: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
To: Anton Vorontsov <cbou@mail.ru>
Cc: David Woodhouse <dwmw2@infradead.org>, linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] test_power: add VOLTAGE_NOW and BATTERY_TEMP properties
Date: Tue, 29 May 2012 13:37:44 +0400
Message-Id: <1338284264-6193-2-git-send-email-dmitry_eremin@mentor.com>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1338284264-6193-1-git-send-email-dmitry_eremin@mentor.com>
References: <1338284264-6193-1-git-send-email-dmitry_eremin@mentor.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Emulate battery temperature (fixed to 26) and battery voltage (variable)
properties.

Signed-off-by: Dmitry Eremin-Solenikov <dmitry_eremin@mentor.com>
---
 drivers/power/test_power.c |   16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/drivers/power/test_power.c b/drivers/power/test_power.c
index a61b596..b99a452 100644
--- a/drivers/power/test_power.c
+++ b/drivers/power/test_power.c
@@ -28,6 +28,7 @@ static int battery_health		= POWER_SUPPLY_HEALTH_GOOD;
 static int battery_present		= 1; /* true */
 static int battery_technology		= POWER_SUPPLY_TECHNOLOGY_LION;
 static int battery_capacity		= 50;
+static int battery_voltage		= 3300;
 
 static int test_power_get_ac_property(struct power_supply *psy,
 				      enum power_supply_property psp,
@@ -101,6 +102,12 @@ static int test_power_get_battery_property(struct power_supply *psy,
 	case POWER_SUPPLY_PROP_TIME_TO_FULL_NOW:
 		val->intval = 3600;
 		break;
+	case POWER_SUPPLY_PROP_TEMP:
+		val->intval = 26;
+		break;
+	case POWER_SUPPLY_PROP_VOLTAGE_NOW:
+		val->intval = battery_voltage;
+		break;
 	default:
 		pr_info("%s: some properties deliberately report errors.\n",
 			__func__);
@@ -129,6 +136,8 @@ static enum power_supply_property test_power_battery_props[] = {
 	POWER_SUPPLY_PROP_MODEL_NAME,
 	POWER_SUPPLY_PROP_MANUFACTURER,
 	POWER_SUPPLY_PROP_SERIAL_NUMBER,
+	POWER_SUPPLY_PROP_TEMP,
+	POWER_SUPPLY_PROP_VOLTAGE_NOW,
 };
 
 static char *test_power_ac_supplied_to[] = {
@@ -437,6 +446,10 @@ static struct kernel_param_ops param_ops_battery_capacity = {
 	.get = param_get_battery_capacity,
 };
 
+static struct kernel_param_ops param_ops_battery_voltage = {
+	.set = param_set_battery_voltage,
+	.get = param_get_battery_voltage,
+};
 
 #define param_check_ac_online(name, p) __param_check(name, p, void);
 #define param_check_usb_online(name, p) __param_check(name, p, void);
@@ -445,6 +458,7 @@ static struct kernel_param_ops param_ops_battery_capacity = {
 #define param_check_battery_technology(name, p) __param_check(name, p, void);
 #define param_check_battery_health(name, p) __param_check(name, p, void);
 #define param_check_battery_capacity(name, p) __param_check(name, p, void);
+#define param_check_battery_voltage(name, p) __param_check(name, p, void);
 
 
 module_param(ac_online, ac_online, 0644);
@@ -472,6 +486,8 @@ MODULE_PARM_DESC(battery_health,
 module_param(battery_capacity, battery_capacity, 0644);
 MODULE_PARM_DESC(battery_capacity, "battery capacity (percentage)");
 
+module_param(battery_voltage, battery_voltage, 0644);
+MODULE_PARM_DESC(battery_voltage, "battery voltage (millivolts)");
 
 MODULE_DESCRIPTION("Power supply driver for testing");
 MODULE_AUTHOR("Anton Vorontsov <cbouatmailru@gmail.com>");
-- 
1.7.10

