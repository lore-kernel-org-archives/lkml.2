Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751926Ab3AFJRK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jan 2013 04:17:10 -0500
Received: from mail.active-venture.com ([67.228.131.205]:54750 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751740Ab3AFJRI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jan 2013 04:17:08 -0500
X-Virus-Scan: Scanned by ClamAV 0.97.2 (no viruses);
  Sun, 06 Jan 2013 03:17:07 -0600
X-Originating-IP: 108.223.40.66
From: Guenter Roeck <linux@roeck-us.net>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, Pawel Moll <pawel.moll@arm.com>,
        Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH] mfd: vexpress: export global functions to fix build error
Date: Sun,  6 Jan 2013 01:16:19 -0800
Message-Id: <1357463779-28096-1-git-send-email-linux@roeck-us.net>
X-Mailer: git-send-email 1.7.9.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Compiling vexpress client drivers as module results in error messages such as

ERROR: "__vexpress_config_func_get" [drivers/hwmon/vexpress.ko] undefined!
ERROR: "vexpress_config_func_put" [drivers/hwmon/vexpress.ko] undefined!

This is because the global functions in drivers/mfd/vexpress-config.c are not
exported. Fix it.

Signed-off-by: Guenter Roeck <linux@roeck-us.net>
---
 drivers/mfd/vexpress-config.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/mfd/vexpress-config.c b/drivers/mfd/vexpress-config.c
index fae15d8..82fed98 100644
--- a/drivers/mfd/vexpress-config.c
+++ b/drivers/mfd/vexpress-config.c
@@ -67,6 +67,7 @@ struct vexpress_config_bridge *vexpress_config_bridge_register(
 
 	return bridge;
 }
+EXPORT_SYMBOL(vexpress_config_bridge_register);
 
 void vexpress_config_bridge_unregister(struct vexpress_config_bridge *bridge)
 {
@@ -83,6 +84,7 @@ void vexpress_config_bridge_unregister(struct vexpress_config_bridge *bridge)
 	while (!list_empty(&__bridge.transactions))
 		cpu_relax();
 }
+EXPOPORT_SYMBOL(vexpress_config_bridge_unregister);
 
 
 struct vexpress_config_func {
@@ -142,6 +144,7 @@ struct vexpress_config_func *__vexpress_config_func_get(struct device *dev,
 
 	return func;
 }
+EXPORT_SYMBOL(__vexpress_config_func_get);
 
 void vexpress_config_func_put(struct vexpress_config_func *func)
 {
@@ -149,7 +152,7 @@ void vexpress_config_func_put(struct vexpress_config_func *func)
 	of_node_put(func->bridge->node);
 	kfree(func);
 }
-
+EXPORT_SYMBOL(vexpress_config_func_put);
 
 struct vexpress_config_trans {
 	struct vexpress_config_func *func;
@@ -229,6 +232,7 @@ void vexpress_config_complete(struct vexpress_config_bridge *bridge,
 
 	complete(&trans->completion);
 }
+EXPORT_SYMBOL(vexpress_config_complete);
 
 int vexpress_config_wait(struct vexpress_config_trans *trans)
 {
@@ -236,7 +240,7 @@ int vexpress_config_wait(struct vexpress_config_trans *trans)
 
 	return trans->status;
 }
-
+EXPORT_SYMBOL(vexpress_config_wait);
 
 int vexpress_config_read(struct vexpress_config_func *func, int offset,
 		u32 *data)
-- 
1.7.9.7

