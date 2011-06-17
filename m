Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757509Ab1FQICE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jun 2011 04:02:04 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:34207 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751994Ab1FQICB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jun 2011 04:02:01 -0400
From: Chris Forbes <chrisf@ijw.co.nz>
To: Zhang Rui <rui.zhang@intel.com>
Cc: Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org, Chris Forbes <chrisf@ijw.co.nz>
Subject: [PATCH] Drivers: acpi: thermal: fix coding style issues
Date: Fri, 17 Jun 2011 20:01:36 +1200
Message-Id: <1308297696-29837-1-git-send-email-chrisf@ijw.co.nz>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed some coding style issues flagged by checkpatch.pl

Signed-off-by: Chris Forbes <chrisf@ijw.co.nz>
---
 drivers/acpi/thermal.c |   30 ++++++++++++++++++------------
 1 files changed, 18 insertions(+), 12 deletions(-)

diff --git a/drivers/acpi/thermal.c b/drivers/acpi/thermal.c
index 2607e17..c3d1080 100644
--- a/drivers/acpi/thermal.c
+++ b/drivers/acpi/thermal.c
@@ -41,7 +41,7 @@
 #include <linux/kmod.h>
 #include <linux/reboot.h>
 #include <linux/device.h>
-#include <asm/uaccess.h>
+#include <linux/uaccess.h>
 #include <linux/thermal.h>
 #include <acpi/acpi_bus.h>
 #include <acpi/acpi_drivers.h>
@@ -173,7 +173,7 @@ struct acpi_thermal_flags {
 };
 
 struct acpi_thermal {
-	struct acpi_device * device;
+	struct acpi_device *device;
 	acpi_bus_id name;
 	unsigned long temperature;
 	unsigned long last_temperature;
@@ -405,8 +405,7 @@ static int acpi_thermal_trips_update(struct acpi_thermal *tz, int flag)
 			printk(KERN_WARNING PREFIX
 				"Invalid passive threshold\n");
 			tz->trips.passive.flags.valid = 0;
-		}
-		else
+		} else
 			tz->trips.passive.flags.valid = 1;
 
 		if (memcmp(&tz->trips.passive.devices, &devices,
@@ -460,7 +459,7 @@ static int acpi_thermal_trips_update(struct acpi_thermal *tz, int flag)
 		}
 
 		name[2] = 'L';
-		if ((flag & ACPI_TRIPS_DEVICES) && tz->trips.active[i].flags.valid ) {
+		if ((flag & ACPI_TRIPS_DEVICES) && tz->trips.active[i].flags.valid) {
 			memset(&devices, 0, sizeof(struct acpi_handle_list));
 			status = acpi_evaluate_reference(tz->device->handle,
 						name, NULL, &devices);
@@ -468,8 +467,7 @@ static int acpi_thermal_trips_update(struct acpi_thermal *tz, int flag)
 				printk(KERN_WARNING PREFIX
 					"Invalid active%d threshold\n", i);
 				tz->trips.active[i].flags.valid = 0;
-			}
-			else
+			} else
 				tz->trips.active[i].flags.valid = 1;
 
 			if (memcmp(&tz->trips.active[i].devices, &devices,
@@ -841,7 +839,8 @@ static int acpi_thermal_register_thermal_zone(struct acpi_thermal *tz)
 		trips++;
 
 	for (i = 0; i < ACPI_THERMAL_MAX_ACTIVE &&
-			tz->trips.active[i].flags.valid; i++, trips++);
+			tz->trips.active[i].flags.valid; i++, trips++)
+		;
 
 	if (tz->trips.passive.flags.valid)
 		tz->thermal_zone =
@@ -1075,7 +1074,8 @@ static int acpi_thermal_resume(struct acpi_device *device)
 	return AE_OK;
 }
 
-static int thermal_act(const struct dmi_system_id *d) {
+static int thermal_act(const struct dmi_system_id *d)
+{
 
 	if (act == 0) {
 		printk(KERN_NOTICE "ACPI: %s detected: "
@@ -1084,14 +1084,18 @@ static int thermal_act(const struct dmi_system_id *d) {
 	}
 	return 0;
 }
-static int thermal_nocrt(const struct dmi_system_id *d) {
+
+static int thermal_nocrt(const struct dmi_system_id *d)
+{
 
 	printk(KERN_NOTICE "ACPI: %s detected: "
 		"disabling all critical thermal trip point actions.\n", d->ident);
 	nocrt = 1;
 	return 0;
 }
-static int thermal_tzp(const struct dmi_system_id *d) {
+
+static int thermal_tzp(const struct dmi_system_id *d)
+{
 
 	if (tzp == 0) {
 		printk(KERN_NOTICE "ACPI: %s detected: "
@@ -1100,7 +1104,9 @@ static int thermal_tzp(const struct dmi_system_id *d) {
 	}
 	return 0;
 }
-static int thermal_psv(const struct dmi_system_id *d) {
+
+static int thermal_psv(const struct dmi_system_id *d)
+{
 
 	if (psv == 0) {
 		printk(KERN_NOTICE "ACPI: %s detected: "
-- 
1.7.4.1

