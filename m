Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752793Ab0CSPTO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Mar 2010 11:19:14 -0400
Received: from kroah.org ([198.145.64.141]:45908 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752577Ab0CSPTB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Mar 2010 11:19:01 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Magnus Damm <damm@opensource.se>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 06/12] Driver core: Early platform kernel-doc update
Date: Fri, 19 Mar 2010 08:18:49 -0700
Message-Id: <1269011935-8886-6-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.0.2
In-Reply-To: <20100319151311.GA8541@kroah.com>
References: <20100319151311.GA8541@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Magnus Damm <damm@opensource.se>

This patch updates the kernel-doc notation for early
platform functions.

Signed-off-by: Magnus Damm <damm@opensource.se>
Acked-by: Randy Dunlap <rdunlap@xenotime.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/base/platform.c |   27 ++++++++++++++++++++-------
 1 files changed, 20 insertions(+), 7 deletions(-)

diff --git a/drivers/base/platform.c b/drivers/base/platform.c
index 1ba9d61..f6bcf22 100644
--- a/drivers/base/platform.c
+++ b/drivers/base/platform.c
@@ -1052,9 +1052,11 @@ static __initdata LIST_HEAD(early_platform_driver_list);
 static __initdata LIST_HEAD(early_platform_device_list);
 
 /**
- * early_platform_driver_register
+ * early_platform_driver_register - register early platform driver
  * @epdrv: early_platform driver structure
  * @buf: string passed from early_param()
+ *
+ * Helper function for early_platform_init() / early_platform_init_buffer()
  */
 int __init early_platform_driver_register(struct early_platform_driver *epdrv,
 					  char *buf)
@@ -1106,9 +1108,12 @@ int __init early_platform_driver_register(struct early_platform_driver *epdrv,
 }
 
 /**
- * early_platform_add_devices - add a numbers of early platform devices
+ * early_platform_add_devices - adds a number of early platform devices
  * @devs: array of early platform devices to add
  * @num: number of early platform devices in array
+ *
+ * Used by early architecture code to register early platform devices and
+ * their platform data.
  */
 void __init early_platform_add_devices(struct platform_device **devs, int num)
 {
@@ -1128,8 +1133,12 @@ void __init early_platform_add_devices(struct platform_device **devs, int num)
 }
 
 /**
- * early_platform_driver_register_all
+ * early_platform_driver_register_all - register early platform drivers
  * @class_str: string to identify early platform driver class
+ *
+ * Used by architecture code to register all early platform drivers
+ * for a certain class. If omitted then only early platform drivers
+ * with matching kernel command line class parameters will be registered.
  */
 void __init early_platform_driver_register_all(char *class_str)
 {
@@ -1151,7 +1160,7 @@ void __init early_platform_driver_register_all(char *class_str)
 }
 
 /**
- * early_platform_match
+ * early_platform_match - find early platform device matching driver
  * @epdrv: early platform driver structure
  * @id: id to match against
  */
@@ -1169,7 +1178,7 @@ early_platform_match(struct early_platform_driver *epdrv, int id)
 }
 
 /**
- * early_platform_left
+ * early_platform_left - check if early platform driver has matching devices
  * @epdrv: early platform driver structure
  * @id: return true if id or above exists
  */
@@ -1187,7 +1196,7 @@ static  __init int early_platform_left(struct early_platform_driver *epdrv,
 }
 
 /**
- * early_platform_driver_probe_id
+ * early_platform_driver_probe_id - probe drivers matching class_str and id
  * @class_str: string to identify early platform driver class
  * @id: id to match against
  * @nr_probe: number of platform devices to successfully probe before exiting
@@ -1257,10 +1266,14 @@ static int __init early_platform_driver_probe_id(char *class_str,
 }
 
 /**
- * early_platform_driver_probe
+ * early_platform_driver_probe - probe a class of registered drivers
  * @class_str: string to identify early platform driver class
  * @nr_probe: number of platform devices to successfully probe before exiting
  * @user_only: only probe user specified early platform devices
+ *
+ * Used by architecture code to probe registered early platform drivers
+ * within a certain class. For probe to happen a registered early platform
+ * device matching a registered early platform driver is needed.
  */
 int __init early_platform_driver_probe(char *class_str,
 				       int nr_probe,
-- 
1.7.0.2

