Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759215Ab2GLNBK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 09:01:10 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:59302 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756924Ab2GLNBI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 09:01:08 -0400
From: Toshiaki Yamane <yamanetoshi@gmail.com>
To: greg@kroah.com, willy@meta-x.org
Cc: linux-kernel@vger.kernel.org, joe@perches.com, rmallon@gmail.com,
        Toshiaki Yamane <yamanetoshi@gmail.com>
Subject: [PATCH 2/3] panel: Use pr_info(...) rather than printk(KERN_INFO
Date: Thu, 12 Jul 2012 22:01:00 +0900
Message-Id: <1342098060-7966-1-git-send-email-yamanetoshi@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1342098033-7932-1-git-send-email-yamanetoshi@gmail.com>
References: <1342098033-7932-1-git-send-email-yamanetoshi@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-Added pr_fmt.
-Converted printk(KERN_INFO to pr_info
-Removed embedded message prefixes.

Signed-off-by: Toshiaki Yamane <yamanetoshi@gmail.com>
---
 drivers/staging/panel/panel.c |   12 +++++++-----
 1 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/panel/panel.c b/drivers/staging/panel/panel.c
index c625567..6f6d0c8 100644
--- a/drivers/staging/panel/panel.c
+++ b/drivers/staging/panel/panel.c
@@ -34,6 +34,8 @@
  *
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/module.h>
 
 #include <linux/types.h>
@@ -2289,12 +2291,12 @@ int panel_init(void)
 	register_reboot_notifier(&panel_notifier);
 
 	if (pprt)
-		printk(KERN_INFO "Panel driver version " PANEL_VERSION
-		       " registered on parport%d (io=0x%lx).\n", parport,
-		       pprt->port->base);
+		pr_info("driver version " PANEL_VERSION
+			" registered on parport%d (io=0x%lx).\n", parport,
+			pprt->port->base);
 	else
-		printk(KERN_INFO "Panel driver version " PANEL_VERSION
-		       " not yet registered\n");
+		pr_info("driver version " PANEL_VERSION
+			" not yet registered\n");
 	/* tells various subsystems about the fact that initialization
 	   is finished */
 	init_in_progress = 0;
-- 
1.7.5.4

