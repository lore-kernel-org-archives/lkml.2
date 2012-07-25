Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933109Ab2GYDox (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2012 23:44:53 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:51542 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933074Ab2GYDno (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2012 23:43:44 -0400
From: Len Brown <lenb@kernel.org>
To: linux-acpi@vger.kernel.org, linux-pm@lists.linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Zhang Rui <rui.zhang@intel.com>,
        Len Brown <len.brown@intel.com>
Subject: [PATCH 52/52] Thermal: Documentation update
Date: Tue, 24 Jul 2012 23:41:48 -0400
Message-Id: <8eaa8d6ca27788aa23659082362a608c1fabcdfe.1343187618.git.len.brown@intel.com>
X-Mailer: git-send-email 1.7.12.rc0
In-Reply-To: <1343187708-19532-1-git-send-email-lenb@kernel.org>
References: <1343187708-19532-1-git-send-email-lenb@kernel.org>
In-Reply-To: <6af1c4fc5227af65092ebc848989693562bfa3e8.1343187617.git.len.brown@intel.com>
References: <6af1c4fc5227af65092ebc848989693562bfa3e8.1343187617.git.len.brown@intel.com>
Reply-To: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Zhang Rui <rui.zhang@intel.com>

With commit 6503e5df08008b9a47022b5e9ebba658c8fa69af,
the value of /sys/class/thermal/thermal_zoneX/mode has been changed
from user/kernel to enabled/disabled.
Update the documentation so that users won't be confused.

Signed-off-by: Zhang Rui <rui.zhang@intel.com>
Signed-off-by: Len Brown <len.brown@intel.com>
---
 Documentation/thermal/sysfs-api.txt | 20 ++++++++++----------
 drivers/acpi/thermal.c              |  6 ++----
 2 files changed, 12 insertions(+), 14 deletions(-)

diff --git a/Documentation/thermal/sysfs-api.txt b/Documentation/thermal/sysfs-api.txt
index 2ba4c9b..c087dbc 100644
--- a/Documentation/thermal/sysfs-api.txt
+++ b/Documentation/thermal/sysfs-api.txt
@@ -47,11 +47,11 @@ temperature) and throttle appropriate devices.
 	.bind: bind the thermal zone device with a thermal cooling device.
 	.unbind: unbind the thermal zone device with a thermal cooling device.
 	.get_temp: get the current temperature of the thermal zone.
-	.get_mode: get the current mode (user/kernel) of the thermal zone.
-	    - "kernel" means thermal management is done in kernel.
-	    - "user" will prevent kernel thermal driver actions upon trip points
+	.get_mode: get the current mode (enabled/disabled) of the thermal zone.
+	    - "enabled" means the kernel thermal management is enabled.
+	    - "disabled" will prevent kernel thermal driver action upon trip points
 	      so that user applications can take charge of thermal management.
-	.set_mode: set the mode (user/kernel) of the thermal zone.
+	.set_mode: set the mode (enabled/disabled) of the thermal zone.
 	.get_trip_type: get the type of certain trip point.
 	.get_trip_temp: get the temperature above which the certain trip point
 			will be fired.
@@ -170,14 +170,14 @@ temp
 	RO, Required
 
 mode
-	One of the predefined values in [kernel, user].
+	One of the predefined values in [enabled, disabled].
 	This file gives information about the algorithm that is currently
 	managing the thermal zone. It can be either default kernel based
 	algorithm or user space application.
-	kernel	= Thermal management in kernel thermal zone driver.
-	user	= Preventing kernel thermal zone driver actions upon
-		  trip points so that user application can take full
-		  charge of the thermal management.
+	enabled		= enable Kernel Thermal management.
+	disabled	= Preventing kernel thermal zone driver actions upon
+			  trip points so that user application can take full
+			  charge of the thermal management.
 	RW, Optional
 
 trip_point_[0-*]_temp
@@ -256,7 +256,7 @@ method, the sys I/F structure will be built like this:
 |thermal_zone1:
     |---type:			acpitz
     |---temp:			37000
-    |---mode:			kernel
+    |---mode:			enabled
     |---trip_point_0_temp:	100000
     |---trip_point_0_type:	critical
     |---trip_point_1_temp:	80000
diff --git a/drivers/acpi/thermal.c b/drivers/acpi/thermal.c
index 2107d1b..8275e7b 100644
--- a/drivers/acpi/thermal.c
+++ b/drivers/acpi/thermal.c
@@ -550,8 +550,6 @@ static int thermal_get_temp(struct thermal_zone_device *thermal,
 	return 0;
 }
 
-static const char enabled[] = "kernel";
-static const char disabled[] = "user";
 static int thermal_get_mode(struct thermal_zone_device *thermal,
 				enum thermal_device_mode *mode)
 {
@@ -588,8 +586,8 @@ static int thermal_set_mode(struct thermal_zone_device *thermal,
 	if (enable != tz->tz_enabled) {
 		tz->tz_enabled = enable;
 		ACPI_DEBUG_PRINT((ACPI_DB_INFO,
-			"%s ACPI thermal control\n",
-			tz->tz_enabled ? enabled : disabled));
+			"%s kernel ACPI thermal control\n",
+			tz->tz_enabled ? "Enable" : "Disable"));
 		acpi_thermal_check(tz);
 	}
 	return 0;
-- 
1.7.12.rc0

