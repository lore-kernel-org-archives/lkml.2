Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759221Ab2GLNBa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 09:01:30 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:65314 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754813Ab2GLNB3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 09:01:29 -0400
From: Toshiaki Yamane <yamanetoshi@gmail.com>
To: greg@kroah.com, willy@meta-x.org
Cc: linux-kernel@vger.kernel.org, joe@perches.com, rmallon@gmail.com,
        Toshiaki Yamane <yamanetoshi@gmail.com>
Subject: [PATCH 3/3] panel: Use pr_err(...) rather than printk(KERN_ERR ...)
Date: Thu, 12 Jul 2012 22:01:17 +0900
Message-Id: <1342098077-8001-1-git-send-email-yamanetoshi@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1342098033-7932-1-git-send-email-yamanetoshi@gmail.com>
References: <1342098033-7932-1-git-send-email-yamanetoshi@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-Removed unnecessary OOM messages.
-Removed embedded message prefixes.
-Added __func__ to some pr_err messages.
-Converted printk(KERN_ERR to pr_err
-Refactored split printk strings onto a single line
-Removed the space before the '!'.

Signed-off-by: Toshiaki Yamane <yamanetoshi@gmail.com>
---
 drivers/staging/panel/panel.c |   38 ++++++++++++++------------------------
 1 files changed, 14 insertions(+), 24 deletions(-)

diff --git a/drivers/staging/panel/panel.c b/drivers/staging/panel/panel.c
index 6f6d0c8..39f9982 100644
--- a/drivers/staging/panel/panel.c
+++ b/drivers/staging/panel/panel.c
@@ -1983,10 +1983,9 @@ static struct logical_input *panel_bind_key(char *name, char *press,
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
@@ -2022,10 +2021,9 @@ static struct logical_input *panel_bind_callback(char *name,
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
@@ -2102,10 +2100,8 @@ static void panel_attach(struct parport *port)
 		return;
 
 	if (pprt) {
-		printk(KERN_ERR
-		       "panel_attach(): port->number=%d parport=%d, "
-		       "already registered !\n",
-		       port->number, parport);
+		pr_err("%s: port->number=%d parport=%d, already registered!\n",
+		       __func__, port->number, parport);
 		return;
 	}
 
@@ -2114,16 +2110,14 @@ static void panel_attach(struct parport *port)
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
+		pr_err("could not claim access to parport%d. Aborting.\n",
+		       parport);
 		goto err_unreg_device;
 	}
 
@@ -2157,10 +2151,8 @@ static void panel_detach(struct parport *port)
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
 
@@ -2270,8 +2262,7 @@ int panel_init(void)
 	init_in_progress = 1;
 
 	if (parport_register_driver(&panel_driver)) {
-		printk(KERN_ERR
-		       "Panel: could not register with parport. Aborting.\n");
+		pr_err("could not register with parport. Aborting.\n");
 		return -EIO;
 	}
 
@@ -2283,8 +2274,7 @@ int panel_init(void)
 			pprt = NULL;
 		}
 		parport_unregister_driver(&panel_driver);
-		printk(KERN_ERR "Panel driver version " PANEL_VERSION
-		       " disabled.\n");
+		pr_err("driver version " PANEL_VERSION " disabled.\n");
 		return -ENODEV;
 	}
 
-- 
1.7.5.4

