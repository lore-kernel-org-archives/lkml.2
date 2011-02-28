Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754838Ab1B1S77 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Feb 2011 13:59:59 -0500
Received: from filtteri1.pp.htv.fi ([213.243.153.184]:48024 "EHLO
	filtteri1.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754497Ab1B1S72 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Feb 2011 13:59:28 -0500
From: Aaro Koskinen <aaro.koskinen@iki.fi>
To: arnaud.patard@rtp-net.org, gregkh@suse.de, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 3/5] staging: xgifb: eliminate "accel" field from video_info
Date: Mon, 28 Feb 2011 20:59:23 +0200
Message-Id: <1298919565-6061-3-git-send-email-aaro.koskinen@iki.fi>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1298919565-6061-1-git-send-email-aaro.koskinen@iki.fi>
References: <1298919565-6061-1-git-send-email-aaro.koskinen@iki.fi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The value is always false, so the field can be eliminated.

Signed-off-by: Aaro Koskinen <aaro.koskinen@iki.fi>
---
 drivers/staging/xgifb/XGI_main_26.c |    9 ---------
 drivers/staging/xgifb/XGIfb.h       |    1 -
 2 files changed, 0 insertions(+), 10 deletions(-)

diff --git a/drivers/staging/xgifb/XGI_main_26.c b/drivers/staging/xgifb/XGI_main_26.c
index fa97c37..f2a4a2a 100644
--- a/drivers/staging/xgifb/XGI_main_26.c
+++ b/drivers/staging/xgifb/XGI_main_26.c
@@ -1187,7 +1187,6 @@ static int XGIfb_do_set_var(struct fb_var_screeninfo *var, int isactive,
 		xgi_video_info.org_x = xgi_video_info.org_y = 0;
 		xgi_video_info.video_linelength = info->var.xres_virtual
 				* (xgi_video_info.video_bpp >> 3);
-		xgi_video_info.accel = 0;
 		switch (xgi_video_info.video_bpp) {
 		case 8:
 			xgi_video_info.DstColor = 0x0000;
@@ -1219,7 +1218,6 @@ static int XGIfb_do_set_var(struct fb_var_screeninfo *var, int isactive,
 		default:
 			xgi_video_info.video_cmap_len = 16;
 			printk(KERN_ERR "XGIfb: Unsupported depth %d", xgi_video_info.video_bpp);
-			xgi_video_info.accel = 0;
 			break;
 		}
 	}
@@ -1635,7 +1633,6 @@ static int XGIfb_ioctl(struct fb_info *info, unsigned int cmd,
 		default:
 			xgi_video_info.video_cmap_len = 16;
 			printk(KERN_ERR "XGIfb: Unsupported accel depth %d", xgi_video_info.video_bpp);
-			xgi_video_info.accel = 0;
 			break;
 		}
 
@@ -2617,10 +2614,6 @@ static void XGIfb_pre_setmode(void)
 	outXGIIDXREG(XGICR, IND_XGI_SCRATCH_REG_CR30, cr30);
 	outXGIIDXREG(XGICR, IND_XGI_SCRATCH_REG_CR31, cr31);
 	outXGIIDXREG(XGICR, IND_XGI_SCRATCH_REG_CR33, (XGIfb_rate_idx & 0x0F));
-
-	if (xgi_video_info.accel)
-		XGIfb_syncaccel();
-
 }
 
 static void XGIfb_post_setmode(void)
@@ -3341,8 +3334,6 @@ static int __devinit xgifb_probe(struct pci_dev *pdev,
 
 		}
 
-		xgi_video_info.accel = 0;
-
 		fb_info->flags = FBINFO_FLAG_DEFAULT;
 		fb_info->var = default_var;
 		fb_info->fix = XGIfb_fix;
diff --git a/drivers/staging/xgifb/XGIfb.h b/drivers/staging/xgifb/XGIfb.h
index b6715ba..8e59e15 100644
--- a/drivers/staging/xgifb/XGIfb.h
+++ b/drivers/staging/xgifb/XGIfb.h
@@ -193,7 +193,6 @@ struct video_info{
         unsigned int   pcislot;
         unsigned int   pcifunc;
 
-        int            accel;
         unsigned short subsysvendor;
         unsigned short subsysdevice;
 
-- 
1.5.6.5

