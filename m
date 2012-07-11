Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753463Ab2GKI7V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 04:59:21 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:61910 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751771Ab2GKI7S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 04:59:18 -0400
From: Toshiaki Yamane <yamanetoshi@gmail.com>
To: greg@kroah.com, willy@meta-x.org
Cc: linux-kernel@vger.kernel.org, Toshiaki Yamane <yamanetoshi@gmail.com>
Subject: [PATCH v2] panel: Use pr_err(...) rather than printk(KERN_ERR ...)
Date: Wed, 11 Jul 2012 17:59:07 +0900
Message-Id: <1341997147-25417-1-git-send-email-yamanetoshi@gmail.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This change is inspired by checkpatch.

Signed-off-by: Toshiaki Yamane <yamanetoshi@gmail.com>
---
 drivers/staging/panel/panel.c |   42 +++++++++++++++++-----------------------
 1 files changed, 18 insertions(+), 24 deletions(-)

diff --git a/drivers/staging/panel/panel.c b/drivers/staging/panel/panel.c
index 7365089..4b038e1 100644
--- a/drivers/staging/panel/panel.c
+++ b/drivers/staging/panel/panel.c
@@ -34,6 +34,8 @@
  *
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/module.h>
 
 #include <linux/types.h>
@@ -1987,10 +1989,9 @@ static struct logical_input *panel_bind_key(char *name, char *press,
 	struct logical_input *key;
 
 	key = kzalloc(sizeof(struct logical_input), GFP_KERNEL);
-	if (!key) {
-		printk(KERN_ERR "panel: not enough memory\n");
+	if (!key)
 		return NULL;
-	}
+
 	if (!input_name2mask(name, &key->mask, &key->value, &scan_mask_i,
 			     &scan_mask_o)) {
 		kfree(key);
@@ -2030,10 +2031,9 @@ static struct logical_input *panel_bind_callback(char *name,
 	struct logical_input *callback;
 
 	callback = kmalloc(sizeof(struct logical_input), GFP_KERNEL);
-	if (!callback) {
-		printk(KERN_ERR "panel: not enough memory\n");
+	if (!callback)
 		return NULL;
-	}
+
 	memset(callback, 0, sizeof(struct logical_input));
 	if (!input_name2mask(name, &callback->mask, &callback->value,
 			     &scan_mask_i, &scan_mask_o))
@@ -2110,10 +2110,8 @@ static void panel_attach(struct parport *port)
 		return;
 
 	if (pprt) {
-		printk(KERN_ERR
-		       "panel_attach(): port->number=%d parport=%d, "
-		       "already registered !\n",
-		       port->number, parport);
+		pr_err("%s: port->number=%d parport=%d, already registerd !\n",
+		       __func__, port->number, parport);
 		return;
 	}
 
@@ -2122,16 +2120,14 @@ static void panel_attach(struct parport *port)
 				       /*PARPORT_DEV_EXCL */
 				       0, (void *)&pprt);
 	if (pprt == NULL) {
-		pr_err("panel_attach(): port->number=%d parport=%d, "
-		       "parport_register_device() failed\n",
-		       port->number, parport);
+		pr_err("%s: port->number=%d parport=%d, parport_register_device() failed\n",
+		       __func__, port->number, parport);
 		return;
 	}
 
 	if (parport_claim(pprt)) {
-		printk(KERN_ERR
-		       "Panel: could not claim access to parport%d. "
-		       "Aborting.\n", parport);
+		pr_err("%s: could not claim access to parport%d. Aborting.\n",
+		       __func__, parport);
 		goto err_unreg_device;
 	}
 
@@ -2165,10 +2161,8 @@ static void panel_detach(struct parport *port)
 		return;
 
 	if (!pprt) {
-		printk(KERN_ERR
-		       "panel_detach(): port->number=%d parport=%d, "
-		       "nothing to unregister.\n",
-		       port->number, parport);
+		pr_err("%s: port->number=%d parport=%d, nothing to unregister.\n",
+		       __func__, port->number, parport);
 		return;
 	}
 
@@ -2278,8 +2272,8 @@ int panel_init(void)
 	init_in_progress = 1;
 
 	if (parport_register_driver(&panel_driver)) {
-		printk(KERN_ERR
-		       "Panel: could not register with parport. Aborting.\n");
+		pr_err("%s: could not register with parport. Aborting.\n",
+		       __func__);
 		return -EIO;
 	}
 
@@ -2291,8 +2285,8 @@ int panel_init(void)
 			pprt = NULL;
 		}
 		parport_unregister_driver(&panel_driver);
-		printk(KERN_ERR "Panel driver version " PANEL_VERSION
-		       " disabled.\n");
+		pr_err("%s: Panel driver version " PANEL_VERSION " disabled.\n",
+		       __func__);
 		return -ENODEV;
 	}
 
-- 
1.7.5.4

