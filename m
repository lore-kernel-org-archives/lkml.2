Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754662Ab1B1S73 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Feb 2011 13:59:29 -0500
Received: from filtteri1.pp.htv.fi ([213.243.153.184]:48010 "EHLO
	filtteri1.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753428Ab1B1S71 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Feb 2011 13:59:27 -0500
From: Aaro Koskinen <aaro.koskinen@iki.fi>
To: arnaud.patard@rtp-net.org, gregkh@suse.de, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/5] staging: xgifb: eliminate fbcon_XGI_copyarea()
Date: Mon, 28 Feb 2011 20:59:21 +0200
Message-Id: <1298919565-6061-1-git-send-email-aaro.koskinen@iki.fi>
X-Mailer: git-send-email 1.5.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fbcon_XGI_copyarea() implementation is trivial and can be replaced with
cfb_copyarea().

Signed-off-by: Aaro Koskinen <aaro.koskinen@iki.fi>
---
 drivers/staging/xgifb/XGI_accel.c   |    9 ---------
 drivers/staging/xgifb/XGI_accel.h   |    2 --
 drivers/staging/xgifb/XGI_main.h    |    2 --
 drivers/staging/xgifb/XGI_main_26.c |    2 +-
 4 files changed, 1 insertions(+), 14 deletions(-)

diff --git a/drivers/staging/xgifb/XGI_accel.c b/drivers/staging/xgifb/XGI_accel.c
index 905b34a..968ac04 100644
--- a/drivers/staging/xgifb/XGI_accel.c
+++ b/drivers/staging/xgifb/XGI_accel.c
@@ -123,12 +123,3 @@ void fbcon_XGI_fillrect(struct fb_info *info, const struct fb_fillrect *rect)
 	cfb_fillrect(info, rect);
 	return;
 }
-
-void fbcon_XGI_copyarea(struct fb_info *info, const struct fb_copyarea *area)
-{
-   	cfb_copyarea(info, area);
-	return;
-}
-
-
-
diff --git a/drivers/staging/xgifb/XGI_accel.h b/drivers/staging/xgifb/XGI_accel.h
index 6cecdf7..836ee40 100644
--- a/drivers/staging/xgifb/XGI_accel.h
+++ b/drivers/staging/xgifb/XGI_accel.h
@@ -479,7 +479,5 @@ int fbcon_XGI_sync(struct fb_info *info);
 extern struct video_info xgi_video_info;
 
 void fbcon_XGI_fillrect(struct fb_info *info, const struct fb_fillrect *rect);
-void fbcon_XGI_copyarea(struct fb_info *info, const struct fb_copyarea *area);
-
 
 #endif
diff --git a/drivers/staging/xgifb/XGI_main.h b/drivers/staging/xgifb/XGI_main.h
index 1b45414..15d72ee 100644
--- a/drivers/staging/xgifb/XGI_main.h
+++ b/drivers/staging/xgifb/XGI_main.h
@@ -795,8 +795,6 @@ static int      XGIfb_blank(int blank,
 */
 extern void     fbcon_XGI_fillrect(struct fb_info *info,
                                    const struct fb_fillrect *rect);
-extern void     fbcon_XGI_copyarea(struct fb_info *info,
-                                   const struct fb_copyarea *area);
 
 static int XGIfb_ioctl(struct fb_info *info, unsigned int cmd,
 			    unsigned long arg);
diff --git a/drivers/staging/xgifb/XGI_main_26.c b/drivers/staging/xgifb/XGI_main_26.c
index 5e69728..6cf2eea 100644
--- a/drivers/staging/xgifb/XGI_main_26.c
+++ b/drivers/staging/xgifb/XGI_main_26.c
@@ -1739,7 +1739,7 @@ static struct fb_ops XGIfb_ops = {
 #endif
 	.fb_blank = XGIfb_blank,
 	.fb_fillrect = fbcon_XGI_fillrect,
-	.fb_copyarea = fbcon_XGI_copyarea,
+	.fb_copyarea = cfb_copyarea,
 	.fb_imageblit = cfb_imageblit,
 	.fb_ioctl = XGIfb_ioctl,
 	/* .fb_mmap = XGIfb_mmap, */
-- 
1.5.6.5

