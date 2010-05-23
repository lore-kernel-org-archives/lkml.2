Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752452Ab0EWHL2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 May 2010 03:11:28 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:55536 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751122Ab0EWHLZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 May 2010 03:11:25 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: linux-fbdev@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Cc: uclinux-dist-devel@blackfin.uclinux.org
Subject: [PATCH] fbdev: bfin-t350mcqb-fb: avoid unused warnings in backlight code
Date: Sun, 23 May 2010 03:15:23 -0400
Message-Id: <1274598923-12688-1-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The current backlight code is stubbed out, so the new props changes added
some warnings about unused label/prop.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 drivers/video/bfin-t350mcqb-fb.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/video/bfin-t350mcqb-fb.c b/drivers/video/bfin-t350mcqb-fb.c
index c2ec3dc..7a50272 100644
--- a/drivers/video/bfin-t350mcqb-fb.c
+++ b/drivers/video/bfin-t350mcqb-fb.c
@@ -420,7 +420,9 @@ static irqreturn_t bfin_t350mcqb_irq_error(int irq, void *dev_id)
 
 static int __devinit bfin_t350mcqb_probe(struct platform_device *pdev)
 {
+#ifndef NO_BL_SUPPORT
 	struct backlight_properties props;
+#endif
 	struct bfin_t350mcqbfb_info *info;
 	struct fb_info *fbinfo;
 	int ret;
@@ -550,7 +552,8 @@ static int __devinit bfin_t350mcqb_probe(struct platform_device *pdev)
 		printk(KERN_ERR DRIVER_NAME
 			": unable to register backlight.\n");
 		ret = -EINVAL;
-		goto out9;
+		unregister_framebuffer(fbinfo);
+		goto out8;
 	}
 
 	lcd_dev = lcd_device_register(DRIVER_NAME, NULL, &bfin_lcd_ops);
@@ -559,8 +562,6 @@ static int __devinit bfin_t350mcqb_probe(struct platform_device *pdev)
 
 	return 0;
 
-out9:
-	unregister_framebuffer(fbinfo);
 out8:
 	free_irq(info->irq, info);
 out7:
-- 
1.7.1

