Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755197Ab2GJLZ0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2012 07:25:26 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:63885 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755106Ab2GJLZX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2012 07:25:23 -0400
From: Toshiaki Yamane <yamanetoshi@gmail.com>
To: greg@kroah.com, willy@meta-x.org
Cc: linux-kernel@vger.kernel.org, Toshiaki Yamane <yamanetoshi@gmail.com>
Subject: [PATCH 3/3] panel: Use pr_err(...) rather than printk(KERN_ERR ...)
Date: Tue, 10 Jul 2012 20:25:15 +0900
Message-Id: <1341919515-8909-1-git-send-email-yamanetoshi@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1341919338-8800-1-git-send-email-yamanetoshi@gmail.com>
References: <1341919338-8800-1-git-send-email-yamanetoshi@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This change is inspired by checkpatch.

Signed-off-by: Toshiaki Yamane <yamanetoshi@gmail.com>
---
 drivers/staging/panel/panel.c |   18 +++++++-----------
 1 files changed, 7 insertions(+), 11 deletions(-)

diff --git a/drivers/staging/panel/panel.c b/drivers/staging/panel/panel.c
index 7b79f53..d6a7a51 100644
--- a/drivers/staging/panel/panel.c
+++ b/drivers/staging/panel/panel.c
@@ -1987,7 +1987,7 @@ static struct logical_input *panel_bind_key(char *name, char *press,
 
 	key = kzalloc(sizeof(struct logical_input), GFP_KERNEL);
 	if (!key) {
-		printk(KERN_ERR "panel: not enough memory\n");
+		pr_err("panel: not enough memory\n");
 		return NULL;
 	}
 	if (!input_name2mask(name, &key->mask, &key->value, &scan_mask_i,
@@ -2030,7 +2030,7 @@ static struct logical_input *panel_bind_callback(char *name,
 
 	callback = kmalloc(sizeof(struct logical_input), GFP_KERNEL);
 	if (!callback) {
-		printk(KERN_ERR "panel: not enough memory\n");
+		pr_err("panel: not enough memory\n");
 		return NULL;
 	}
 	memset(callback, 0, sizeof(struct logical_input));
@@ -2109,8 +2109,7 @@ static void panel_attach(struct parport *port)
 		return;
 
 	if (pprt) {
-		printk(KERN_ERR
-		       "panel_attach(): port->number=%d parport=%d, "
+		pr_err("panel_attach(): port->number=%d parport=%d, "
 		       "already registered !\n",
 		       port->number, parport);
 		return;
@@ -2128,8 +2127,7 @@ static void panel_attach(struct parport *port)
 	}
 
 	if (parport_claim(pprt)) {
-		printk(KERN_ERR
-		       "Panel: could not claim access to parport%d. "
+		pr_err("Panel: could not claim access to parport%d. "
 		       "Aborting.\n", parport);
 		goto err_unreg_device;
 	}
@@ -2164,8 +2162,7 @@ static void panel_detach(struct parport *port)
 		return;
 
 	if (!pprt) {
-		printk(KERN_ERR
-		       "panel_detach(): port->number=%d parport=%d, "
+		pr_err("panel_detach(): port->number=%d parport=%d, "
 		       "nothing to unregister.\n",
 		       port->number, parport);
 		return;
@@ -2277,8 +2274,7 @@ int panel_init(void)
 	init_in_progress = 1;
 
 	if (parport_register_driver(&panel_driver)) {
-		printk(KERN_ERR
-		       "Panel: could not register with parport. Aborting.\n");
+		pr_err("Panel: could not register with parport. Aborting.\n");
 		return -EIO;
 	}
 
@@ -2290,7 +2286,7 @@ int panel_init(void)
 			pprt = NULL;
 		}
 		parport_unregister_driver(&panel_driver);
-		printk(KERN_ERR "Panel driver version " PANEL_VERSION
+		pr_err("Panel driver version " PANEL_VERSION
 		       " disabled.\n");
 		return -ENODEV;
 	}
-- 
1.7.5.4

