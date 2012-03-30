Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933630Ab2C3MTA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 08:19:00 -0400
Received: from vms173011pub.verizon.net ([206.46.173.11]:48688 "EHLO
	vms173011pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933361Ab2C3MSb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 08:18:31 -0400
From: Len Brown <lenb@kernel.org>
To: linux-acpi@vger.kernel.org, linux-pm@lists.linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Joe Perches <joe@perches.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Len Brown <len.brown@intel.com>
Subject: [PATCH 16/76] thermal_sys: kernel style cleanups
Date: Fri, 30 Mar 2012 06:13:19 -0400
Message-id: <caca8b803520b0694423e2ac0ee3d58650b04a12.1333101989.git.len.brown@intel.com>
X-Mailer: git-send-email 1.7.10.rc2.19.gfae9d
In-reply-to: <1333102459-23750-1-git-send-email-lenb@kernel.org>
References: <1333102459-23750-1-git-send-email-lenb@kernel.org>
In-reply-to: <09f98a825a821f7a3f1b162f9ed023f37213a63b.1333101989.git.len.brown@intel.com>
References: <09f98a825a821f7a3f1b162f9ed023f37213a63b.1333101989.git.len.brown@intel.com>
Reply-to: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joe Perches <joe@perches.com>

Just a few tidies to make it more like most kernel sources.

A couple of long lines still remain.

Signed-off-by: Joe Perches <joe@perches.com>
Reviewed-by: Jesper Juhl <jj@chaosbits.net>
Cc: Len Brown <lenb@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Len Brown <len.brown@intel.com>
---
 drivers/thermal/thermal_sys.c |   30 +++++++++++++-----------------
 1 file changed, 13 insertions(+), 17 deletions(-)

diff --git a/drivers/thermal/thermal_sys.c b/drivers/thermal/thermal_sys.c
index 11237bc..db5d8f8 100644
--- a/drivers/thermal/thermal_sys.c
+++ b/drivers/thermal/thermal_sys.c
@@ -64,7 +64,7 @@ static int get_idr(struct idr *idr, struct mutex *lock, int *id)
 {
 	int err;
 
-      again:
+again:
 	if (unlikely(idr_pre_get(idr, GFP_KERNEL) == 0))
 		return -ENOMEM;
 
@@ -816,15 +816,14 @@ int thermal_zone_bind_cooling_device(struct thermal_zone_device *tz,
 		return 0;
 
 	device_remove_file(&tz->device, &dev->attr);
-      remove_symbol_link:
+remove_symbol_link:
 	sysfs_remove_link(&tz->device.kobj, dev->name);
-      release_idr:
+release_idr:
 	release_idr(&tz->idr, &tz->lock, dev->id);
-      free_mem:
+free_mem:
 	kfree(dev);
 	return result;
 }
-
 EXPORT_SYMBOL(thermal_zone_bind_cooling_device);
 
 /**
@@ -854,14 +853,13 @@ int thermal_zone_unbind_cooling_device(struct thermal_zone_device *tz,
 
 	return -ENODEV;
 
-      unbind:
+unbind:
 	device_remove_file(&tz->device, &pos->attr);
 	sysfs_remove_link(&tz->device.kobj, pos->name);
 	release_idr(&tz->idr, &tz->lock, pos->id);
 	kfree(pos);
 	return 0;
 }
-
 EXPORT_SYMBOL(thermal_zone_unbind_cooling_device);
 
 static void thermal_release(struct device *dev)
@@ -869,7 +867,8 @@ static void thermal_release(struct device *dev)
 	struct thermal_zone_device *tz;
 	struct thermal_cooling_device *cdev;
 
-	if (!strncmp(dev_name(dev), "thermal_zone", sizeof "thermal_zone" - 1)) {
+	if (!strncmp(dev_name(dev), "thermal_zone",
+		     sizeof("thermal_zone") - 1)) {
 		tz = to_thermal_zone(dev);
 		kfree(tz);
 	} else {
@@ -889,8 +888,9 @@ static struct class thermal_class = {
  * @devdata:	device private data.
  * @ops:		standard thermal cooling devices callbacks.
  */
-struct thermal_cooling_device *thermal_cooling_device_register(
-     char *type, void *devdata, const struct thermal_cooling_device_ops *ops)
+struct thermal_cooling_device *
+thermal_cooling_device_register(char *type, void *devdata,
+				const struct thermal_cooling_device_ops *ops)
 {
 	struct thermal_cooling_device *cdev;
 	struct thermal_zone_device *pos;
@@ -955,12 +955,11 @@ struct thermal_cooling_device *thermal_cooling_device_register(
 	if (!result)
 		return cdev;
 
-      unregister:
+unregister:
 	release_idr(&thermal_cdev_idr, &thermal_idr_lock, cdev->id);
 	device_unregister(&cdev->device);
 	return ERR_PTR(result);
 }
-
 EXPORT_SYMBOL(thermal_cooling_device_register);
 
 /**
@@ -1005,7 +1004,6 @@ void thermal_cooling_device_unregister(struct
 	device_unregister(&cdev->device);
 	return;
 }
-
 EXPORT_SYMBOL(thermal_cooling_device_unregister);
 
 /**
@@ -1081,7 +1079,7 @@ void thermal_zone_device_update(struct thermal_zone_device *tz)
 
 	tz->last_temperature = temp;
 
-      leave:
+leave:
 	if (tz->passive)
 		thermal_zone_device_set_polling(tz, tz->passive_delay);
 	else if (tz->polling_delay)
@@ -1221,12 +1219,11 @@ struct thermal_zone_device *thermal_zone_device_register(char *type,
 	if (!result)
 		return tz;
 
-      unregister:
+unregister:
 	release_idr(&thermal_tz_idr, &thermal_idr_lock, tz->id);
 	device_unregister(&tz->device);
 	return ERR_PTR(result);
 }
-
 EXPORT_SYMBOL(thermal_zone_device_register);
 
 /**
@@ -1278,7 +1275,6 @@ void thermal_zone_device_unregister(struct thermal_zone_device *tz)
 	device_unregister(&tz->device);
 	return;
 }
-
 EXPORT_SYMBOL(thermal_zone_device_unregister);
 
 #ifdef CONFIG_NET
-- 
1.7.10.rc2.19.gfae9d

