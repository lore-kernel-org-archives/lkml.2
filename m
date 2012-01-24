Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753973Ab2AXXgl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jan 2012 18:36:41 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:48565 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753636Ab2AXXgk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jan 2012 18:36:40 -0500
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>, Len Brown <len.brown@intel.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 4/4] thermal_sys: Convert printks to pr_<level>
Date: Tue, 24 Jan 2012 15:35:38 -0800
Message-Id: <1c7ffad305f38ef390800244bef69ffab62f25f8.1327447797.git.joe@perches.com>
X-Mailer: git-send-email 1.7.8.111.gad25c.dirty
In-Reply-To: <cover.1327447797.git.joe@perches.com>
References: <cover.1327447797.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the current logging style.

Remove PREFIX, add pr_fmt, convert the printks.
All dmesg output now prefixed with "thermal_sys: ".

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/thermal/thermal_sys.c |   14 ++++++--------
 1 files changed, 6 insertions(+), 8 deletions(-)

diff --git a/drivers/thermal/thermal_sys.c b/drivers/thermal/thermal_sys.c
index 68df616..9c69d8a 100644
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
@@ -1025,8 +1025,7 @@ void thermal_zone_device_update(struct thermal_zone_device *tz)
 
 	if (tz->ops->get_temp(tz, &temp)) {
 		/* get_temp failed - retry it later */
-		printk(KERN_WARNING PREFIX "failed to read out thermal zone "
-		       "%d\n", tz->id);
+		pr_warn("failed to read out thermal zone %d\n", tz->id);
 		goto leave;
 	}
 
@@ -1041,9 +1040,8 @@ void thermal_zone_device_update(struct thermal_zone_device *tz)
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
@@ -1346,7 +1344,7 @@ int generate_netlink_event(u32 orig, enum events event)
 
 	result = genlmsg_multicast(skb, 0, thermal_event_mcgrp.id, GFP_ATOMIC);
 	if (result)
-		printk(KERN_INFO "failed to send netlink event:%d", result);
+		pr_info("failed to send netlink event:%d\n", result);
 
 	return result;
 }
-- 
1.7.8.111.gad25c.dirty

