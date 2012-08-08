Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030909Ab2HHVMj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2012 17:12:39 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:49480 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030848Ab2HHVM1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2012 17:12:27 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/3] ACPI / PM: Fix unused function warnings for CONFIG_PM_SLEEP
Date: Wed, 8 Aug 2012 23:09:14 +0200
User-Agent: KMail/1.13.6 (Linux/3.5.0+; KDE/4.6.0; x86_64; ; )
Cc: Linux PM list <linux-pm@vger.kernel.org>, Len Brown <lenb@kernel.org>,
        ACPI Devel Mailing List <linux-acpi@vger.kernel.org>,
        Matthew Garrett <mjg@redhat.com>, platform-driver-x86@vger.kernel.org
References: <201208082308.15466.rjw@sisk.pl>
In-Reply-To: <201208082308.15466.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201208082309.14658.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


According to compiler warnings, several suspend/resume functions
in ACPI drivers are not used for CONFIG_PM_SLEEP unset, so add
#ifdefs to prevent them from being built in that case.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 drivers/acpi/ac.c      |    4 ++++
 drivers/acpi/battery.c |    2 ++
 drivers/acpi/button.c  |    4 ++++
 drivers/acpi/fan.c     |    4 ++++
 drivers/acpi/power.c   |    4 ++++
 drivers/acpi/sbs.c     |    2 ++
 drivers/acpi/thermal.c |    4 ++++
 7 files changed, 24 insertions(+)

Index: linux/drivers/acpi/ac.c
===================================================================
--- linux.orig/drivers/acpi/ac.c
+++ linux/drivers/acpi/ac.c
@@ -69,7 +69,9 @@ static const struct acpi_device_id ac_de
 };
 MODULE_DEVICE_TABLE(acpi, ac_device_ids);
 
+#ifdef CONFIG_PM_SLEEP
 static int acpi_ac_resume(struct device *dev);
+#endif
 static SIMPLE_DEV_PM_OPS(acpi_ac_pm, NULL, acpi_ac_resume);
 
 static struct acpi_driver acpi_ac_driver = {
@@ -313,6 +315,7 @@ static int acpi_ac_add(struct acpi_devic
 	return result;
 }
 
+#ifdef CONFIG_PM_SLEEP
 static int acpi_ac_resume(struct device *dev)
 {
 	struct acpi_ac *ac;
@@ -332,6 +335,7 @@ static int acpi_ac_resume(struct device
 		kobject_uevent(&ac->charger.dev->kobj, KOBJ_CHANGE);
 	return 0;
 }
+#endif
 
 static int acpi_ac_remove(struct acpi_device *device, int type)
 {
Index: linux/drivers/acpi/battery.c
===================================================================
--- linux.orig/drivers/acpi/battery.c
+++ linux/drivers/acpi/battery.c
@@ -1052,6 +1052,7 @@ static int acpi_battery_remove(struct ac
 	return 0;
 }
 
+#ifdef CONFIG_PM_SLEEP
 /* this is needed to learn about changes made in suspended state */
 static int acpi_battery_resume(struct device *dev)
 {
@@ -1068,6 +1069,7 @@ static int acpi_battery_resume(struct de
 	acpi_battery_update(battery);
 	return 0;
 }
+#endif
 
 static SIMPLE_DEV_PM_OPS(acpi_battery_pm, NULL, acpi_battery_resume);
 
Index: linux/drivers/acpi/button.c
===================================================================
--- linux.orig/drivers/acpi/button.c
+++ linux/drivers/acpi/button.c
@@ -78,7 +78,9 @@ static int acpi_button_add(struct acpi_d
 static int acpi_button_remove(struct acpi_device *device, int type);
 static void acpi_button_notify(struct acpi_device *device, u32 event);
 
+#ifdef CONFIG_PM_SLEEP
 static int acpi_button_resume(struct device *dev);
+#endif
 static SIMPLE_DEV_PM_OPS(acpi_button_pm, NULL, acpi_button_resume);
 
 static struct acpi_driver acpi_button_driver = {
@@ -310,6 +312,7 @@ static void acpi_button_notify(struct ac
 	}
 }
 
+#ifdef CONFIG_PM_SLEEP
 static int acpi_button_resume(struct device *dev)
 {
 	struct acpi_device *device = to_acpi_device(dev);
@@ -319,6 +322,7 @@ static int acpi_button_resume(struct dev
 		return acpi_lid_send_state(device);
 	return 0;
 }
+#endif
 
 static int acpi_button_add(struct acpi_device *device)
 {
Index: linux/drivers/acpi/fan.c
===================================================================
--- linux.orig/drivers/acpi/fan.c
+++ linux/drivers/acpi/fan.c
@@ -53,8 +53,10 @@ static const struct acpi_device_id fan_d
 };
 MODULE_DEVICE_TABLE(acpi, fan_device_ids);
 
+#ifdef CONFIG_PM_SLEEP
 static int acpi_fan_suspend(struct device *dev);
 static int acpi_fan_resume(struct device *dev);
+#endif
 static SIMPLE_DEV_PM_OPS(acpi_fan_pm, acpi_fan_suspend, acpi_fan_resume);
 
 static struct acpi_driver acpi_fan_driver = {
@@ -184,6 +186,7 @@ static int acpi_fan_remove(struct acpi_d
 	return 0;
 }
 
+#ifdef CONFIG_PM_SLEEP
 static int acpi_fan_suspend(struct device *dev)
 {
 	if (!dev)
@@ -207,6 +210,7 @@ static int acpi_fan_resume(struct device
 
 	return result;
 }
+#endif
 
 static int __init acpi_fan_init(void)
 {
Index: linux/drivers/acpi/power.c
===================================================================
--- linux.orig/drivers/acpi/power.c
+++ linux/drivers/acpi/power.c
@@ -67,7 +67,9 @@ static const struct acpi_device_id power
 };
 MODULE_DEVICE_TABLE(acpi, power_device_ids);
 
+#ifdef CONFIG_PM_SLEEP
 static int acpi_power_resume(struct device *dev);
+#endif
 static SIMPLE_DEV_PM_OPS(acpi_power_pm, NULL, acpi_power_resume);
 
 static struct acpi_driver acpi_power_driver = {
@@ -775,6 +777,7 @@ static int acpi_power_remove(struct acpi
 	return 0;
 }
 
+#ifdef CONFIG_PM_SLEEP
 static int acpi_power_resume(struct device *dev)
 {
 	int result = 0, state;
@@ -803,6 +806,7 @@ static int acpi_power_resume(struct devi
 
 	return result;
 }
+#endif
 
 int __init acpi_power_init(void)
 {
Index: linux/drivers/acpi/sbs.c
===================================================================
--- linux.orig/drivers/acpi/sbs.c
+++ linux/drivers/acpi/sbs.c
@@ -988,6 +988,7 @@ static void acpi_sbs_rmdirs(void)
 #endif
 }
 
+#ifdef CONFIG_PM_SLEEP
 static int acpi_sbs_resume(struct device *dev)
 {
 	struct acpi_sbs *sbs;
@@ -997,6 +998,7 @@ static int acpi_sbs_resume(struct device
 	acpi_sbs_callback(sbs);
 	return 0;
 }
+#endif
 
 static SIMPLE_DEV_PM_OPS(acpi_sbs_pm, NULL, acpi_sbs_resume);
 
Index: linux/drivers/acpi/thermal.c
===================================================================
--- linux.orig/drivers/acpi/thermal.c
+++ linux/drivers/acpi/thermal.c
@@ -106,7 +106,9 @@ static const struct acpi_device_id  ther
 };
 MODULE_DEVICE_TABLE(acpi, thermal_device_ids);
 
+#ifdef CONFIG_PM_SLEEP
 static int acpi_thermal_resume(struct device *dev);
+#endif
 static SIMPLE_DEV_PM_OPS(acpi_thermal_pm, NULL, acpi_thermal_resume);
 
 static struct acpi_driver acpi_thermal_driver = {
@@ -1041,6 +1043,7 @@ static int acpi_thermal_remove(struct ac
 	return 0;
 }
 
+#ifdef CONFIG_PM_SLEEP
 static int acpi_thermal_resume(struct device *dev)
 {
 	struct acpi_thermal *tz;
@@ -1075,6 +1078,7 @@ static int acpi_thermal_resume(struct de
 
 	return AE_OK;
 }
+#endif
 
 static int thermal_act(const struct dmi_system_id *d) {
 

