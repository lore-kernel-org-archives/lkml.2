Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753180Ab2JIGKk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 02:10:40 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:38957 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752698Ab2JIGCr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 02:02:47 -0400
From: Len Brown <lenb@kernel.org>
To: linux-acpi@vger.kernel.org, linux-pm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Zhang Rui <rui.zhang@intel.com>
Subject: [PATCH 07/30] Thermal: rename structure thermal_cooling_device_instance to thermal_instance
Date: Tue,  9 Oct 2012 01:53:57 -0400
Message-Id: <b81b6ba3d9ac5feb14388bb73ac5a39d9a7540dc.1349761836.git.len.brown@intel.com>
X-Mailer: git-send-email 1.8.0.rc1
In-Reply-To: <1349762060-25334-1-git-send-email-lenb@kernel.org>
References: <1349762060-25334-1-git-send-email-lenb@kernel.org>
In-Reply-To: <e3f25e6e5836c4790fbe395ff42e241f372d859d.1349761836.git.len.brown@intel.com>
References: <e3f25e6e5836c4790fbe395ff42e241f372d859d.1349761836.git.len.brown@intel.com>
Reply-To: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Zhang Rui <rui.zhang@intel.com>

This struct is used to describe the behavior for a thermal
cooling device on a certain trip point for a certain thremal zone.

thermal_cooling_device_instance is not accurate, as a cooling device
can be used for more than one trip point in one thermal zone device.

Signed-off-by: Zhang Rui <rui.zhang@intel.com>
Reviewed-by: Rafael J. Wysocki <rjw@sisk.pl>
Reviewed-by: Eduardo Valentin <eduardo.valentin@ti.com>
---
 drivers/thermal/thermal_sys.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/thermal/thermal_sys.c b/drivers/thermal/thermal_sys.c
index 735e6e6..3eba397 100644
--- a/drivers/thermal/thermal_sys.c
+++ b/drivers/thermal/thermal_sys.c
@@ -46,7 +46,7 @@ MODULE_LICENSE("GPL");
  * a certain cooling device on a certain trip point
  * in a certain thermal zone
  */
-struct thermal_cooling_device_instance {
+struct thermal_instance {
 	int id;
 	char name[THERMAL_NAME_LENGTH];
 	struct thermal_zone_device *tz;
@@ -430,10 +430,10 @@ static ssize_t
 thermal_cooling_device_trip_point_show(struct device *dev,
 				       struct device_attribute *attr, char *buf)
 {
-	struct thermal_cooling_device_instance *instance;
+	struct thermal_instance *instance;
 
 	instance =
-	    container_of(attr, struct thermal_cooling_device_instance, attr);
+	    container_of(attr, struct thermal_instance, attr);
 
 	if (instance->trip == THERMAL_TRIPS_NONE)
 		return sprintf(buf, "-1\n");
@@ -716,7 +716,7 @@ static void thermal_zone_device_passive(struct thermal_zone_device *tz,
 					int temp, int trip_temp, int trip)
 {
 	enum thermal_trend trend;
-	struct thermal_cooling_device_instance *instance;
+	struct thermal_instance *instance;
 	struct thermal_cooling_device *cdev;
 	long state, max_state;
 
@@ -812,8 +812,8 @@ int thermal_zone_bind_cooling_device(struct thermal_zone_device *tz,
 				     struct thermal_cooling_device *cdev,
 				     unsigned long upper, unsigned long lower)
 {
-	struct thermal_cooling_device_instance *dev;
-	struct thermal_cooling_device_instance *pos;
+	struct thermal_instance *dev;
+	struct thermal_instance *pos;
 	struct thermal_zone_device *pos1;
 	struct thermal_cooling_device *pos2;
 	unsigned long max_state;
@@ -844,7 +844,7 @@ int thermal_zone_bind_cooling_device(struct thermal_zone_device *tz,
 		return -EINVAL;
 
 	dev =
-	    kzalloc(sizeof(struct thermal_cooling_device_instance), GFP_KERNEL);
+	    kzalloc(sizeof(struct thermal_instance), GFP_KERNEL);
 	if (!dev)
 		return -ENOMEM;
 	dev->tz = tz;
@@ -909,7 +909,7 @@ int thermal_zone_unbind_cooling_device(struct thermal_zone_device *tz,
 				       int trip,
 				       struct thermal_cooling_device *cdev)
 {
-	struct thermal_cooling_device_instance *pos, *next;
+	struct thermal_instance *pos, *next;
 
 	mutex_lock(&tz->lock);
 	list_for_each_entry_safe(pos, next, &tz->cooling_devices, node) {
@@ -1095,7 +1095,7 @@ EXPORT_SYMBOL(thermal_cooling_device_unregister);
 static void thermal_zone_trip_update(struct thermal_zone_device *tz,
 				     int trip, long temp)
 {
-	struct thermal_cooling_device_instance *instance;
+	struct thermal_instance *instance;
 	struct thermal_cooling_device *cdev = NULL;
 	unsigned long cur_state, max_state;
 	long trip_temp;
-- 
1.8.0.rc1

