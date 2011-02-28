Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754521Ab1B1S72 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Feb 2011 13:59:28 -0500
Received: from filtteri1.pp.htv.fi ([213.243.153.184]:48018 "EHLO
	filtteri1.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753420Ab1B1S71 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Feb 2011 13:59:27 -0500
From: Aaro Koskinen <aaro.koskinen@iki.fi>
To: arnaud.patard@rtp-net.org, gregkh@suse.de, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/5] staging: xgifb: eliminate fbcon_XGI_fillrect()
Date: Mon, 28 Feb 2011 20:59:22 +0200
Message-Id: <1298919565-6061-2-git-send-email-aaro.koskinen@iki.fi>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1298919565-6061-1-git-send-email-aaro.koskinen@iki.fi>
References: <1298919565-6061-1-git-send-email-aaro.koskinen@iki.fi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fbcon_XGI_fillrect() implementation is trivial and can be replaced with
cfb_fillrect().

Signed-off-by: Aaro Koskinen <aaro.koskinen@iki.fi>
---
 drivers/staging/xgifb/XGI_accel.c   |    9 ---------
 drivers/staging/xgifb/XGI_accel.h   |    2 --
 drivers/staging/xgifb/XGI_main.h    |    2 --
 drivers/staging/xgifb/XGI_main_26.c |    2 +-
 4 files changed, 1 insertions(+), 14 deletions(-)

diff --git a/drivers/staging/xgifb/XGI_accel.c b/drivers/staging/xgifb/XGI_accel.c
index 968ac04..1e4c06c 100644
--- a/drivers/staging/xgifb/XGI_accel.c
+++ b/drivers/staging/xgifb/XGI_accel.c
@@ -114,12 +114,3 @@ void XGIfb_syncaccel(void)
     XGI310Sync();
 
 }
-
-void fbcon_XGI_fillrect(struct fb_info *info, const struct fb_fillrect *rect)
-{
-	if (!rect->width || !rect->height)
-		return;
-
-	cfb_fillrect(info, rect);
-	return;
-}
diff --git a/drivers/staging/xgifb/XGI_accel.h b/drivers/staging/xgifb/XGI_accel.h
index 836ee40..a1fb5d3 100644
--- a/drivers/staging/xgifb/XGI_accel.h
+++ b/drivers/staging/xgifb/XGI_accel.h
@@ -478,6 +478,4 @@ int fbcon_XGI_sync(struct fb_info *info);
 
 extern struct video_info xgi_video_info;
 
-void fbcon_XGI_fillrect(struct fb_info *info, const struct fb_fillrect *rect);
-
 #endif
diff --git a/drivers/staging/xgifb/XGI_main.h b/drivers/staging/xgifb/XGI_main.h
index 15d72ee..39e15de 100644
--- a/drivers/staging/xgifb/XGI_main.h
+++ b/drivers/staging/xgifb/XGI_main.h
@@ -793,8 +793,6 @@ static int      XGIfb_blank(int blank,
 /*static int 	XGIfb_mmap(struct fb_info *info, struct file *file,
 		           struct vm_area_struct *vma);
 */
-extern void     fbcon_XGI_fillrect(struct fb_info *info,
-                                   const struct fb_fillrect *rect);
 
 static int XGIfb_ioctl(struct fb_info *info, unsigned int cmd,
 			    unsigned long arg);
diff --git a/drivers/staging/xgifb/XGI_main_26.c b/drivers/staging/xgifb/XGI_main_26.c
index 6cf2eea..fa97c37 100644
--- a/drivers/staging/xgifb/XGI_main_26.c
+++ b/drivers/staging/xgifb/XGI_main_26.c
@@ -1738,7 +1738,7 @@ static struct fb_ops XGIfb_ops = {
 	.fb_pan_display = XGIfb_pan_display,
 #endif
 	.fb_blank = XGIfb_blank,
-	.fb_fillrect = fbcon_XGI_fillrect,
+	.fb_fillrect = cfb_fillrect,
 	.fb_copyarea = cfb_copyarea,
 	.fb_imageblit = cfb_imageblit,
 	.fb_ioctl = XGIfb_ioctl,
-- 
1.5.6.5

