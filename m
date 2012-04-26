Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757066Ab2DZSqJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2012 14:46:09 -0400
Received: from smtp4.mundo-r.com ([212.51.32.151]:52353 "EHLO
	smtp4.mundo-r.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755088Ab2DZSqG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2012 14:46:06 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Av0EAE+XmU9bdWOb/2dsb2JhbABFsXCBB4IKAQUnUhBRPBsHEogRuniQZQSVfZBAgmo
X-IronPort-AV: E=Sophos;i="4.75,487,1330902000"; 
   d="scan'208";a="981960571"
From: "Javier M. Mellid" <jmunhoz@igalia.com>
To: gregkh@linuxfoundation.org, gewang@siliconmotion.com,
        boyod.yang@siliconmotion.com.cn, wuzhangjin@gmail.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        "Javier M. Mellid" <jmunhoz@igalia.com>
Subject: [PATCH RESEND 3/7] staging: sm7xx: use dynamic debug support
Date: Thu, 26 Apr 2012 20:45:51 +0200
Message-Id: <1335465955-32057-4-git-send-email-jmunhoz@igalia.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <20120425205532.GA9642@kroah.com>
References: <20120425205532.GA9642@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch uses dynamic debug support.

Tested with SM712

Signed-off-by: Javier M. Mellid <jmunhoz@igalia.com>
---
 drivers/staging/sm7xx/smtcfb.c |   30 ++++++++++++------------------
 1 files changed, 12 insertions(+), 18 deletions(-)

diff --git a/drivers/staging/sm7xx/smtcfb.c b/drivers/staging/sm7xx/smtcfb.c
index abed491..69721c2 100644
--- a/drivers/staging/sm7xx/smtcfb.c
+++ b/drivers/staging/sm7xx/smtcfb.c
@@ -33,12 +33,6 @@
 
 #include "smtcfb.h"
 
-#ifdef DEBUG
-#define smdbg(format, arg...) printk(KERN_DEBUG format , ## arg)
-#else
-#define smdbg(format, arg...)
-#endif
-
 struct screen_info smtc_screen_info;
 
 /*
@@ -134,8 +128,9 @@ static void sm712_set_timing(struct smtcfb_info *sfb,
 	int i = 0, j = 0;
 	u32 m_nScreenStride;
 
-	smdbg("\nppar_info->width = %d ppar_info->height = %d"
-			"sfb->fb.var.bits_per_pixel = %d ppar_info->hz = %d\n",
+	dev_dbg(&sfb->dev->dev,
+	       "ppar_info->width=%d ppar_info->height=%d"
+			"sfb->fb.var.bits_per_pixel=%d ppar_info->hz=%d\n",
 			ppar_info->width, ppar_info->height,
 			sfb->fb.var.bits_per_pixel, ppar_info->hz);
 
@@ -145,13 +140,14 @@ static void sm712_set_timing(struct smtcfb_info *sfb,
 		    VGAMode[j].bpp == sfb->fb.var.bits_per_pixel &&
 		    VGAMode[j].hz == ppar_info->hz) {
 
-			smdbg("\nVGAMode[j].mmSizeX  = %d VGAMode[j].mmSizeY ="
-					"%d VGAMode[j].bpp = %d"
-					"VGAMode[j].hz=%d\n",
-					VGAMode[j].mmSizeX, VGAMode[j].mmSizeY,
-					VGAMode[j].bpp, VGAMode[j].hz);
+			dev_dbg(&sfb->dev->dev,
+				"VGAMode[j].mmSizeX=%d VGAMode[j].mmSizeY=%d"
+				"VGAMode[j].bpp=%d VGAMode[j].hz=%d\n",
+				VGAMode[j].mmSizeX, VGAMode[j].mmSizeY,
+				VGAMode[j].bpp, VGAMode[j].hz);
 
-			smdbg("VGAMode index=%d\n", j);
+			dev_dbg(&sfb->dev->dev,
+				"VGAMode index=%d\n", j);
 
 			smtc_mmiowb(0x0, 0x3c6);
 
@@ -805,16 +801,14 @@ static int __init sm712vga_setup(char *options)
 {
 	int index;
 
-	if (!options || !*options) {
-		smdbg("\n No vga parameter\n");
+	if (!options || !*options)
 		return -EINVAL;
-	}
 
 	smtc_screen_info.lfb_width = 0;
 	smtc_screen_info.lfb_height = 0;
 	smtc_screen_info.lfb_depth = 0;
 
-	smdbg("\nsm712vga_setup = %s\n", options);
+	pr_debug("sm712vga_setup = %s\n", options);
 
 	for (index = 0;
 	     index < ARRAY_SIZE(vesa_mode);
-- 
1.7.2.5

