Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752702Ab2GOMoa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jul 2012 08:44:30 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:57175 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751535Ab2GOMoV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jul 2012 08:44:21 -0400
From: Cruz Julian Bishop <cruz@massive-dynamics.biz>
To: greg@kroah.com, willy@meta-x.org
Cc: linux-kernel@vger.kernel.org, Cruz Julian Bishop <cruzjbishop@gmail.com>,
        Cruz Julian Bishop <cruz@massive-dynamics.biz>
Subject: [PATCH] Checkpatch fixes for drivers/staging/panel/panel.c
Date: Sun, 15 Jul 2012 22:44:06 +1000
Message-Id: <1342356246-17233-1-git-send-email-cruz@massive-dynamics.biz>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Cruz Julian Bishop <cruzjbishop@gmail.com>

This commit changes printk calls to pr_info, _err, and _debug

Signed-off-by: Cruz Julian Bishop <cruz@massive-dynamics.biz>
---
 drivers/staging/panel/panel.c |   27 +++++++++++----------------
 1 file changed, 11 insertions(+), 16 deletions(-)

diff --git a/drivers/staging/panel/panel.c b/drivers/staging/panel/panel.c
index 7365089..2cfce81 100644
--- a/drivers/staging/panel/panel.c
+++ b/drivers/staging/panel/panel.c
@@ -1838,8 +1838,7 @@ static void panel_process_inputs(void)
 	struct logical_input *input;
 
 #if 0
-	printk(KERN_DEBUG
-	       "entering panel_process_inputs with pp=%016Lx & pc=%016Lx\n",
+	pr_debug("entering panel_process_inputs with pp=%016Lx & pc=%016Lx\n",
 	       phys_prev, phys_curr);
 #endif
 
@@ -1988,7 +1987,7 @@ static struct logical_input *panel_bind_key(char *name, char *press,
 
 	key = kzalloc(sizeof(struct logical_input), GFP_KERNEL);
 	if (!key) {
-		printk(KERN_ERR "panel: not enough memory\n");
+		pr_err("panel: not enough memory\n");
 		return NULL;
 	}
 	if (!input_name2mask(name, &key->mask, &key->value, &scan_mask_i,
@@ -2003,7 +2002,7 @@ static struct logical_input *panel_bind_key(char *name, char *press,
 	key->fall_time = 1;
 
 #if 0
-	printk(KERN_DEBUG "bind: <%s> : m=%016Lx v=%016Lx\n", name, key->mask,
+	pr_debug("bind: <%s> : m=%016Lx v=%016Lx\n", name, key->mask,
 	       key->value);
 #endif
 	strncpy(key->u.kbd.press_str, press, sizeof(key->u.kbd.press_str));
@@ -2031,7 +2030,7 @@ static struct logical_input *panel_bind_callback(char *name,
 
 	callback = kmalloc(sizeof(struct logical_input), GFP_KERNEL);
 	if (!callback) {
-		printk(KERN_ERR "panel: not enough memory\n");
+		pr_err("panel: not enough memory\n");
 		return NULL;
 	}
 	memset(callback, 0, sizeof(struct logical_input));
@@ -2110,8 +2109,7 @@ static void panel_attach(struct parport *port)
 		return;
 
 	if (pprt) {
-		printk(KERN_ERR
-		       "panel_attach(): port->number=%d parport=%d, "
+		pr_err("panel_attach(): port->number=%d parport=%d, "
 		       "already registered !\n",
 		       port->number, parport);
 		return;
@@ -2129,8 +2127,7 @@ static void panel_attach(struct parport *port)
 	}
 
 	if (parport_claim(pprt)) {
-		printk(KERN_ERR
-		       "Panel: could not claim access to parport%d. "
+		pr_err("Panel: could not claim access to parport%d. "
 		       "Aborting.\n", parport);
 		goto err_unreg_device;
 	}
@@ -2165,8 +2162,7 @@ static void panel_detach(struct parport *port)
 		return;
 
 	if (!pprt) {
-		printk(KERN_ERR
-		       "panel_detach(): port->number=%d parport=%d, "
+		pr_err("panel_detach(): port->number=%d parport=%d, "
 		       "nothing to unregister.\n",
 		       port->number, parport);
 		return;
@@ -2278,8 +2274,7 @@ int panel_init(void)
 	init_in_progress = 1;
 
 	if (parport_register_driver(&panel_driver)) {
-		printk(KERN_ERR
-		       "Panel: could not register with parport. Aborting.\n");
+		pr_err("Panel: could not register with parport. Aborting.\n");
 		return -EIO;
 	}
 
@@ -2291,7 +2286,7 @@ int panel_init(void)
 			pprt = NULL;
 		}
 		parport_unregister_driver(&panel_driver);
-		printk(KERN_ERR "Panel driver version " PANEL_VERSION
+		pr_err("Panel driver version " PANEL_VERSION
 		       " disabled.\n");
 		return -ENODEV;
 	}
@@ -2299,11 +2294,11 @@ int panel_init(void)
 	register_reboot_notifier(&panel_notifier);
 
 	if (pprt)
-		printk(KERN_INFO "Panel driver version " PANEL_VERSION
+		pr_info("Panel driver version " PANEL_VERSION
 		       " registered on parport%d (io=0x%lx).\n", parport,
 		       pprt->port->base);
 	else
-		printk(KERN_INFO "Panel driver version " PANEL_VERSION
+		pr_err("Panel driver version " PANEL_VERSION
 		       " not yet registered\n");
 	/* tells various subsystems about the fact that initialization
 	   is finished */
-- 
1.7.9.5

