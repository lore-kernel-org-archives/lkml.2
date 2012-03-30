Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760878Ab2C3NTA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 09:19:00 -0400
Received: from vms173021pub.verizon.net ([206.46.173.21]:33467 "EHLO
	vms173021pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760829Ab2C3NSU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 09:18:20 -0400
From: Len Brown <lenb@kernel.org>
To: linux-acpi@vger.kernel.org, linux-pm@lists.linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Joe Perches <joe@perches.com>,
        Jesper Juhl <jj@chaosbits.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Len Brown <len.brown@intel.com>
Subject: [PATCH 17/76] thermal_sys: convert printks to pr_<level>
Date: Fri, 30 Mar 2012 06:13:20 -0400
Message-id: <c5a01dd52dc4903772f464ea580895ccc36e911d.1333101989.git.len.brown@intel.com>
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

Use the current logging style.

Remove PREFIX, add pr_fmt, convert the printks.  All dmesg output now
prefixed with "thermal_sys: ".

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Jesper Juhl <jj@chaosbits.net>
Cc: Len Brown <lenb@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Len Brown <len.brown@intel.com>
---
 drivers/thermal/thermal_sys.c |   14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff --git a/drivers/thermal/thermal_sys.c b/drivers/thermal/thermal_sys.c
index db5d8f8..fab970d 100644
--- a/drivers/thermal/thermal_sys.c
+++ b/drivers/thermal/thermal_sys.c
@@ -23,6 +23,8 @@
  * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/module.h>
 #include <linux/device.h>
 #include <linux/err.h>
@@ -39,8 +41,6 @@ MODULE_AUTHOR("Zhang Rui");
 MODULE_DESCRIPTION("Generic thermal management sysfs support");
 MODULE_LICENSE("GPL");
 
-#define PREFIX "Thermal: "
-
 struct thermal_cooling_device_instance {
 	int id;
 	char name[THERMAL_NAME_LENGTH];
@@ -1023,8 +1023,7 @@ void thermal_zone_device_update(struct thermal_zone_device *tz)
 
 	if (tz->ops->get_temp(tz, &temp)) {
 		/* get_temp failed - retry it later */
-		printk(KERN_WARNING PREFIX "failed to read out thermal zone "
-		       "%d\n", tz->id);
+		pr_warn("failed to read out thermal zone %d\n", tz->id);
 		goto leave;
 	}
 
@@ -1039,9 +1038,8 @@ void thermal_zone_device_update(struct thermal_zone_device *tz)
 					ret = tz->ops->notify(tz, count,
 							      trip_type);
 				if (!ret) {
-					printk(KERN_EMERG
-					       "Critical temperature reached (%ld C), shutting down.\n",
-					       temp/1000);
+					pr_emerg("Critical temperature reached (%ld C), shutting down\n",
+						 temp/1000);
 					orderly_poweroff(true);
 				}
 			}
@@ -1345,7 +1343,7 @@ int thermal_generate_netlink_event(u32 orig, enum events event)
 
 	result = genlmsg_multicast(skb, 0, thermal_event_mcgrp.id, GFP_ATOMIC);
 	if (result)
-		printk(KERN_INFO "failed to send netlink event:%d", result);
+		pr_info("failed to send netlink event:%d\n", result);
 
 	return result;
 }
-- 
1.7.10.rc2.19.gfae9d

