Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933322Ab2GEPWF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 11:22:05 -0400
Received: from smtp3.mundo-r.com ([212.51.32.191]:55657 "EHLO
	smtp4.mundo-r.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752718Ab2GEPUk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 11:20:40 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Av8EAJGv9U9bdWOb/2dsb2JhbABCA4VfsUiBB4IZAQUaAQgECwFGECUCJgICVwcSiA+mdZJSgSCNNoIPgRIDlTeQA4Jh
X-IronPort-AV: E=Sophos;i="4.77,531,1336341600"; 
   d="scan'208";a="939596325"
From: =?UTF-8?q?Miguel=20G=C3=B3mez?= <magomez@igalia.com>
To: arnaud.patard@rtp-net.org, gregkh@linuxfoundation.org,
        aaro.koskinen@iki.fi, dan.carpenter@oracle.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        =?UTF-8?q?Miguel=20G=C3=B3mez?= <magomez@igalia.com>
Subject: [PATCH 01/19] Staging: xgifb: Comment cleaning.
Date: Thu,  5 Jul 2012 16:45:44 +0200
Message-Id: <c43dc4d9658a520bc62592d51ec9b7b2a3d81fd7.1341498465.git.magomez@igalia.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <cover.1341498465.git.magomez@igalia.com>
References: <cover.1341498465.git.magomez@igalia.com>
In-Reply-To: <cover.1341498465.git.magomez@igalia.com>
References: <cover.1341498465.git.magomez@igalia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove commented code and useless comments. Leave only those with relevant
hints to the code.

Signed-off-by: Miguel Gómez <magomez@igalia.com>
---
 drivers/staging/xgifb/XGI_main.h    |    4 -
 drivers/staging/xgifb/XGI_main_26.c |  131 +++--------------------------
 drivers/staging/xgifb/XGIfb.h       |    8 +-
 drivers/staging/xgifb/vb_def.h      |    3 -
 drivers/staging/xgifb/vb_init.c     |  155 ++++-------------------------------
 drivers/staging/xgifb/vb_init.h     |    1 -
 drivers/staging/xgifb/vb_setmode.c  |   26 +++---
 drivers/staging/xgifb/vb_struct.h   |    3 -
 drivers/staging/xgifb/vb_table.h    |   35 +++-----
 drivers/staging/xgifb/vb_util.h     |    1 -
 drivers/staging/xgifb/vgatypes.h    |    3 -
 11 files changed, 55 insertions(+), 315 deletions(-)

diff --git a/drivers/staging/xgifb/XGI_main.h b/drivers/staging/xgifb/XGI_main.h
index be6bb7d..1686c5a 100644
--- a/drivers/staging/xgifb/XGI_main.h
+++ b/drivers/staging/xgifb/XGI_main.h
@@ -68,9 +68,6 @@ static int XGIfb_crt2type = -1;
 /* PR: Tv plug type (for overriding autodetection) */
 static int XGIfb_tvplug = -1;
 
-/* TW: For ioctl XGIFB_GET_INFO */
-/* XGIfb_info XGIfbinfo; */
-
 #define MD_XGI315 1
 
 /* mode table */
@@ -240,7 +237,6 @@ static const struct _chswtable {
 	{ 0,      0,      ""       , ""       }
 };
 
-/* Eden Chen */
 static const struct _XGI_TV_filter {
 	u8 filter[9][4];
 } XGI_TV_filter[] = {
diff --git a/drivers/staging/xgifb/XGI_main_26.c b/drivers/staging/xgifb/XGI_main_26.c
index fe9061d..511890b 100644
--- a/drivers/staging/xgifb/XGI_main_26.c
+++ b/drivers/staging/xgifb/XGI_main_26.c
@@ -1,9 +1,3 @@
-/*
- * XG20, XG21, XG40, XG42 frame buffer device
- * for Linux kernels  2.5.x, 2.6.x
- * Base on TW's sis fbdev code.
- */
-
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
 #include <linux/module.h>
@@ -36,36 +30,6 @@ static void dumpVGAReg(void)
 	u8 i, reg;
 
 	xgifb_reg_set(XGISR, 0x05, 0x86);
-	/*
-	xgifb_reg_set(XGISR, 0x08, 0x4f);
-	xgifb_reg_set(XGISR, 0x0f, 0x20);
-	xgifb_reg_set(XGISR, 0x11, 0x4f);
-	xgifb_reg_set(XGISR, 0x13, 0x45);
-	xgifb_reg_set(XGISR, 0x14, 0x51);
-	xgifb_reg_set(XGISR, 0x1e, 0x41);
-	xgifb_reg_set(XGISR, 0x1f, 0x0);
-	xgifb_reg_set(XGISR, 0x20, 0xa1);
-	xgifb_reg_set(XGISR, 0x22, 0xfb);
-	xgifb_reg_set(XGISR, 0x26, 0x22);
-	xgifb_reg_set(XGISR, 0x3e, 0x07);
-	*/
-
-	/* xgifb_reg_set(XGICR, 0x19, 0x00); */
-	/* xgifb_reg_set(XGICR, 0x1a, 0x3C); */
-	/* xgifb_reg_set(XGICR, 0x22, 0xff); */
-	/* xgifb_reg_set(XGICR, 0x3D, 0x10); */
-
-	/* xgifb_reg_set(XGICR, 0x4a, 0xf3); */
-
-	/* xgifb_reg_set(XGICR, 0x57, 0x0); */
-	/* xgifb_reg_set(XGICR, 0x7a, 0x2c); */
-
-	/* xgifb_reg_set(XGICR, 0x82, 0xcc); */
-	/* xgifb_reg_set(XGICR, 0x8c, 0x0); */
-	/*
-	xgifb_reg_set(XGICR, 0x99, 0x1);
-	xgifb_reg_set(XGICR, 0x41, 0x40);
-	*/
 
 	for (i = 0; i < 0x4f; i++) {
 		reg = xgifb_reg_get(XGISR, i);
@@ -78,30 +42,6 @@ static void dumpVGAReg(void)
 		pr_debug("\no 3d4 %x", i);
 		pr_debug("\ni 3d5 => %x", reg);
 	}
-	/*
-	xgifb_reg_set(XGIPART1,0x2F,1);
-	for (i=1; i < 0x50; i++) {
-		reg = xgifb_reg_get(XGIPART1, i);
-		pr_debug("\no d004 %x", i);
-		pr_debug("\ni d005 => %x", reg);
-	}
-
-	for (i=0; i < 0x50; i++) {
-		 reg = xgifb_reg_get(XGIPART2, i);
-		 pr_debug("\no d010 %x", i);
-		 pr_debug("\ni d011 => %x", reg);
-	}
-	for (i=0; i < 0x50; i++) {
-		reg = xgifb_reg_get(XGIPART3, i);
-		pr_debug("\no d012 %x",i);
-		pr_debug("\ni d013 => %x",reg);
-	}
-	for (i=0; i < 0x50; i++) {
-		reg = xgifb_reg_get(XGIPART4, i);
-		pr_debug("\no d014 %x",i);
-		pr_debug("\ni d015 => %x",reg);
-	}
-	*/
 }
 #else
 static inline void dumpVGAReg(void)
@@ -215,15 +155,6 @@ static int XGIfb_mode_rate_to_ddata(struct vb_device_info *XGI_Pr,
 			| ((unsigned short) (sr_data & 0x01) << 10);
 	A = VT + 2;
 
-	/* cr_data = XGI_Pr->XGINEWUB_CRT1Table[index].CR[10]; */
-
-	/* Vertical display enable end */
-	/*
-	VDE = (cr_data & 0xff) |
-		((unsigned short) (cr_data2 & 0x02) << 7) |
-		((unsigned short) (cr_data2 & 0x40) << 3) |
-		((unsigned short) (sr_data & 0x02) << 9);
-	*/
 	VDE = XGI_Pr->RefIndex[RefreshRateTableIndex].YRes - 1;
 	E = VDE + 1;
 
@@ -590,7 +521,7 @@ static int XGIfb_validate_mode(struct xgifb_video_info *xgifb_info, int myindex)
 				if (XGIbios_mode[myindex].yres != 576)
 					return -1;
 			}
-			/*  TW: LVDS/CHRONTEL does not support 720 */
+			/* LVDS/CHRONTEL does not support 720 */
 			if (xgifb_info->hasVB == HASVB_LVDS_CHRONTEL ||
 			    xgifb_info->hasVB == HASVB_CHRONTEL) {
 				return -1;
@@ -794,26 +725,21 @@ static void XGIfb_post_setmode(struct xgifb_video_info *xgifb_info)
 {
 	u8 reg;
 	unsigned char doit = 1;
-	/*
-	xgifb_reg_set(XGISR,IND_SIS_PASSWORD,SIS_PASSWORD);
-	xgifb_reg_set(XGICR, 0x13, 0x00);
-	xgifb_reg_and_or(XGISR,0x0E, 0xF0, 0x01);
-	*test*
-	*/
+
 	if (xgifb_info->video_bpp == 8) {
-		/* TW: We can't switch off CRT1 on LVDS/Chrontel
+		/* We can't switch off CRT1 on LVDS/Chrontel
 		 * in 8bpp Modes */
 		if ((xgifb_info->hasVB == HASVB_LVDS) ||
 		    (xgifb_info->hasVB == HASVB_LVDS_CHRONTEL)) {
 			doit = 0;
 		}
-		/* TW: We can't switch off CRT1 on 301B-DH
+		/* We can't switch off CRT1 on 301B-DH
 		 * in 8bpp Modes if using LCD */
 		if (xgifb_info->display2 == XGIFB_DISP_LCD)
 			doit = 0;
 	}
 
-	/* TW: We can't switch off CRT1 if bridge is in slave mode */
+	/* We can't switch off CRT1 if bridge is in slave mode */
 	if (xgifb_info->hasVB != HASVB_NONE) {
 		reg = xgifb_reg_get(XGIPART1, 0x00);
 
@@ -1038,7 +964,6 @@ static int XGIfb_do_set_var(struct fb_var_screeninfo *var, int isactive,
 	unsigned int drate = 0, hrate = 0;
 	int found_mode = 0;
 	int old_mode;
-	/* unsigned char reg, reg1; */
 
 	info->var.xres_virtual = var->xres_virtual;
 	info->var.yres_virtual = var->yres_virtual;
@@ -1049,8 +974,6 @@ static int XGIfb_do_set_var(struct fb_var_screeninfo *var, int isactive,
 	else if ((var->vmode & FB_VMODE_MASK) == FB_VMODE_DOUBLE)
 		vtotal <<= 2;
 	else if ((var->vmode & FB_VMODE_MASK) == FB_VMODE_INTERLACED) {
-		/* vtotal <<= 1; */
-		/* var->yres <<= 1; */
 	}
 
 	if (!htotal || !vtotal) {
@@ -1388,16 +1311,7 @@ static int XGIfb_check_var(struct fb_var_screeninfo *var, struct fb_info *info)
 		xgifb_info->refresh_rate = 60;
 	}
 
-	/*
-	if ((var->pixclock) && (htotal)) {
-		drate = 1E12 / var->pixclock;
-		hrate = drate / htotal;
-		refresh_rate = (unsigned int) (hrate / vtotal * 2 + 0.5);
-	} else {
-		refresh_rate = 60;
-	}
-	*/
-	/* TW: Calculation wrong for 1024x600 - force it to 60Hz */
+	/* Calculation wrong for 1024x600 - force it to 60Hz */
 	if ((var->xres == 1024) && (var->yres == 600))
 		refresh_rate = 60;
 
@@ -1446,8 +1360,6 @@ static int XGIfb_check_var(struct fb_var_screeninfo *var, struct fb_info *info)
 		}
 	}
 
-	/* TW: TODO: Check the refresh rate */
-
 	/* Adapt RGB settings */
 	XGIfb_bpp_to_var(xgifb_info, var);
 
@@ -1462,16 +1374,7 @@ static int XGIfb_check_var(struct fb_var_screeninfo *var, struct fb_info *info)
 			var->xres_virtual = var->xres;
 		if (var->yres != var->yres_virtual)
 			var->yres_virtual = var->yres;
-	} /* else { */
-		/* TW: Now patch yres_virtual if we use panning */
-		/* May I do this? */
-		/* var->yres_virtual = xgifb_info->heapstart /
-			(var->xres * (var->bits_per_pixel >> 3)); */
-		/* if (var->yres_virtual <= var->yres) { */
-		/* TW: Paranoia check */
-		/* var->yres_virtual = var->yres; */
-		/* } */
-	/* } */
+	}
 
 	/* Truncate offsets to maximum if too high */
 	if (var->xoffset > var->xres_virtual - var->xres)
@@ -1553,7 +1456,6 @@ static struct fb_ops XGIfb_ops = {
 	.fb_fillrect = cfb_fillrect,
 	.fb_copyarea = cfb_copyarea,
 	.fb_imageblit = cfb_imageblit,
-	/* .fb_mmap = XGIfb_mmap, */
 };
 
 /* ---------------- Chip generation dependent routines ---------------- */
@@ -1630,9 +1532,6 @@ static int XGIfb_get_dram_size(struct xgifb_video_info *xgifb_info)
 	}
 
 	xgifb_info->video_size = xgifb_info->video_size * ChannelNum;
-	/* PLiad fixed for benchmarking and fb set */
-	/* xgifb_info->video_size = 0x200000; */ /* 1024x768x16 */
-	/* xgifb_info->video_size = 0x1000000; */ /* benchmark */
 
 	pr_info("SR14=%x DramSzie %x ChannelNum %x\n",
 	       reg,
@@ -1680,7 +1579,7 @@ static void XGIfb_detect_VB(struct xgifb_video_info *xgifb_info)
 	}
 
 	if (XGIfb_tvplug != -1)
-		/* PR/TW: Override with option */
+		/* Override with option */
 		xgifb_info->TV_plug = XGIfb_tvplug;
 	else if (cr32 & SIS_VB_HIVISION) {
 		xgifb_info->TV_type = TVMODE_HIVISION;
@@ -1700,7 +1599,7 @@ static void XGIfb_detect_VB(struct xgifb_video_info *xgifb_info)
 			xgifb_info->TV_type = TVMODE_NTSC;
 	}
 
-	/* TW: Copy forceCRT1 option to CRT1off if option is given */
+	/* Copy forceCRT1 option to CRT1off if option is given */
 	if (XGIfb_forcecrt1 != -1) {
 		if (XGIfb_forcecrt1)
 			XGIfb_crt1off = 0;
@@ -1794,7 +1693,7 @@ static int __init XGIfb_setup(char *options)
 			XGIfb_search_tvstd(this_opt + 7);
 		} else if (!strncmp(this_opt, "dstn", 4)) {
 			enable_dstn = 1;
-			/* TW: DSTN overrules forcecrt2type */
+			/* DSTN overrules forcecrt2type */
 			XGIfb_crt2type = XGIFB_DISP_LCD;
 		} else if (!strncmp(this_opt, "noypan", 6)) {
 			XGIfb_ypan = 0;
@@ -1981,13 +1880,7 @@ static int __devinit xgifb_probe(struct pci_dev *pdev,
 			dev_info(&pdev->dev,
 				 "XGI301LV bridge detected (revision 0x%02x)\n",
 				 reg);
-		}
-		/* else if (reg >= 0xB0) {
-			hw_info->ujVBChipID = VB_CHIP_301B;
-			reg1 = xgifb_reg_get(XGIPART4, 0x23);
-			pr_debug("XGIfb: XGI301B bridge detected\n");
-		} */
-		else {
+		} else {
 			hw_info->ujVBChipID = VB_CHIP_301;
 			dev_info(&pdev->dev, "XGI301 bridge detected\n");
 		}
@@ -2104,7 +1997,7 @@ static int __devinit xgifb_probe(struct pci_dev *pdev,
 		goto error_1;
 	}
 
-	/* yilin set default refresh rate */
+	/* set default refresh rate */
 	xgifb_info->refresh_rate = refresh_rate;
 	if (xgifb_info->refresh_rate == 0)
 		xgifb_info->refresh_rate = 60;
diff --git a/drivers/staging/xgifb/XGIfb.h b/drivers/staging/xgifb/XGIfb.h
index 741bba3..8054798 100644
--- a/drivers/staging/xgifb/XGIfb.h
+++ b/drivers/staging/xgifb/XGIfb.h
@@ -30,13 +30,13 @@ enum xgi_tvtype {
 	TVMODE_NTSC = 0,
 	TVMODE_PAL,
 	TVMODE_HIVISION,
-	TVTYPE_PALM,	/* vicki@030226 */
-	TVTYPE_PALN,	/* vicki@030226 */
-	TVTYPE_NTSCJ,	/* vicki@030226 */
+	TVTYPE_PALM,
+	TVTYPE_PALN,
+	TVTYPE_NTSCJ,
 	TVMODE_TOTAL
 };
 
-enum xgi_tv_plug { /* vicki@030226 */
+enum xgi_tv_plug {
 	TVPLUG_UNKNOWN = 0,
 	TVPLUG_COMPOSITE = 1,
 	TVPLUG_SVIDEO = 2,
diff --git a/drivers/staging/xgifb/vb_def.h b/drivers/staging/xgifb/vb_def.h
index 5b987a6..69078d9 100644
--- a/drivers/staging/xgifb/vb_def.h
+++ b/drivers/staging/xgifb/vb_def.h
@@ -1,5 +1,3 @@
-/* $XFree86: xc/programs/Xserver/hw/xfree86/drivers/xgi/initdef.h
- * ,v 1.4 2000/12/02 01:16:17 dawes Exp $*/
 #ifndef _VB_DEF_
 #define _VB_DEF_
 #include "../../video/sis/initdef.h"
@@ -12,7 +10,6 @@
 #define SetCHTVOverScan         0x8000
 
 #define Panel_320x480            0x07 /*fstn*/
-/* [ycchen] 02/12/03 Modify for Multi-Sync. LCD Support */
 #define PanelResInfo            0x1F /* CR36 Panel Type/LCDResInfo */
 #define Panel_1024x768x75        0x22
 #define Panel_1280x1024x75       0x23
diff --git a/drivers/staging/xgifb/vb_init.c b/drivers/staging/xgifb/vb_init.c
index 7c555a7..6bb0206 100644
--- a/drivers/staging/xgifb/vb_init.c
+++ b/drivers/staging/xgifb/vb_init.c
@@ -1,4 +1,4 @@
-#include <linux/delay.h> /* udelay */
+#include <linux/delay.h>
 #include <linux/vmalloc.h>
 
 #include "XGIfb.h"
@@ -132,10 +132,8 @@ static void XGINew_SetMemoryClock(struct xgi_hw_device_info *HwDeviceExtension,
 		      0x30,
 		      pVBInfo->ECLKData[pVBInfo->ram_type].SR30);
 
-	/* [Vicent] 2004/07/07,
-	 * When XG42 ECLK = MCLK = 207MHz, Set SR32 D[1:0] = 10b */
-	/* [Hsuan] 2004/08/20,
-	 * Modify SR32 value, when MCLK=207MHZ, ELCK=250MHz,
+	/* When XG42 ECLK = MCLK = 207MHz, Set SR32 D[1:0] = 10b */
+	/* Modify SR32 value, when MCLK=207MHZ, ELCK=250MHz,
 	 * Set SR32 D[1:0] = 10b */
 	if (HwDeviceExtension->jChipType == XG42) {
 		if ((pVBInfo->MCLKData[pVBInfo->ram_type].SR28 == 0x1C) &&
@@ -160,7 +158,6 @@ static void XGINew_DDRII_Bootup_XG27(
 	XGINew_SetMemoryClock(HwDeviceExtension, pVBInfo);
 
 	/* Set Double Frequency */
-	/* xgifb_reg_set(P3d4, 0x97, 0x11); *//* CR97 */
 	xgifb_reg_set(P3d4, 0x97, pVBInfo->XGINew_CR97); /* CR97 */
 
 	udelay(200);
@@ -192,7 +189,6 @@ static void XGINew_DDRII_Bootup_XG27(
 	udelay(30);
 	xgifb_reg_set(P3c4, 0x16, 0x00); /* Set SR16 */
 	xgifb_reg_set(P3c4, 0x16, 0x80); /* Set SR16 */
-	/* udelay(15); */
 
 	xgifb_reg_set(P3c4, 0x1B, 0x04); /* Set SR1B */
 	udelay(60);
@@ -252,7 +248,6 @@ static void XGINew_DDR2_MRS_XG20(struct xgi_hw_device_info *HwDeviceExtension,
 	xgifb_reg_set(P3c4, 0x16, 0x05);
 	xgifb_reg_set(P3c4, 0x16, 0x85);
 
-	/* xgifb_reg_set(P3c4, 0x18, 0x52); */ /* MRS1 */
 	xgifb_reg_set(P3c4, 0x18, 0x42); /* MRS1 */
 	xgifb_reg_set(P3c4, 0x19, 0x02);
 	xgifb_reg_set(P3c4, 0x16, 0x05);
@@ -264,7 +259,6 @@ static void XGINew_DDR2_MRS_XG20(struct xgi_hw_device_info *HwDeviceExtension,
 	xgifb_reg_set(P3c4, 0x1B, 0x00); /* SR1B */
 	udelay(100);
 
-	/* xgifb_reg_set(P3c4 ,0x18, 0x52); */ /* MRS2 */
 	xgifb_reg_set(P3c4, 0x18, 0x42); /* MRS1 */
 	xgifb_reg_set(P3c4, 0x19, 0x00);
 	xgifb_reg_set(P3c4, 0x16, 0x05);
@@ -290,14 +284,12 @@ static void XGINew_DDR1x_MRS_XG20(unsigned long P3c4,
 	xgifb_reg_set(P3c4,
 		      0x18,
 		      pVBInfo->SR15[2][pVBInfo->ram_type]); /* SR18 */
-	/* xgifb_reg_set(P3c4, 0x18, 0x31); */
 	xgifb_reg_set(P3c4, 0x19, 0x01);
 	xgifb_reg_set(P3c4, 0x16, 0x03);
 	xgifb_reg_set(P3c4, 0x16, 0x83);
 	mdelay(1);
 	xgifb_reg_set(P3c4, 0x1B, 0x03);
 	udelay(500);
-	/* xgifb_reg_set(P3c4, 0x18, 0x31); */
 	xgifb_reg_set(P3c4,
 		      0x18,
 		      pVBInfo->SR15[2][pVBInfo->ram_type]); /* SR18 */
@@ -546,7 +538,6 @@ static void XGINew_SetDRAMDefaultRegister340(
 	xgifb_reg_set(P3d4, 0x87, 0x00); /* CR87 */
 	xgifb_reg_set(P3d4, 0xCF, XG40_CRCF); /* CRCF */
 	if (pVBInfo->ram_type) {
-		/* xgifb_reg_set(P3c4, 0x17, 0xC0); */ /* SR17 DDRII */
 		xgifb_reg_set(P3c4, 0x17, 0x80); /* SR17 DDRII */
 		if (HwDeviceExtension->jChipType == XG27)
 			xgifb_reg_set(P3c4, 0x17, 0x02); /* SR17 DDRII */
@@ -597,19 +588,12 @@ static unsigned short XGINew_SetDRAMSize20Reg(
 
 		memsize = data >> 4;
 
-		/* [2004/03/25] Vicent, Fix DRAM Sizing Error */
+		/* Fix DRAM Sizing Error */
 		xgifb_reg_set(pVBInfo->P3c4,
 			      0x14,
 			      (xgifb_reg_get(pVBInfo->P3c4, 0x14) & 0x0F) |
 				(data & 0xF0));
 		udelay(15);
-
-		/* data |= pVBInfo->ram_channel << 2; */
-		/* data |= (pVBInfo->ram_bus / 64) << 1; */
-		/* xgifb_reg_set(pVBInfo->P3c4, 0x14, data); */
-
-		/* should delay */
-		/* XGINew_SetDRAMModeRegister340(pVBInfo); */
 	}
 	return memsize;
 }
@@ -628,8 +612,7 @@ static int XGINew_ReadWriteRest(unsigned short StopAddr,
 		writel(Position, fbaddr + Position);
 	}
 
-	udelay(500); /* [Vicent] 2004/04/16.
-			Fix #1759 Memory Size error in Multi-Adapter. */
+	udelay(500); /* Fix #1759 Memory Size error in Multi-Adapter. */
 
 	Position = 0;
 
@@ -925,9 +908,6 @@ static void XGINew_SetDRAMSize_340(struct xgifb_video_info *xgifb_info,
 	xgifb_reg_set(pVBInfo->P3c4, 0x21, (unsigned short) (data & 0xDF));
 	XGI_DisplayOff(xgifb_info, HwDeviceExtension, pVBInfo);
 
-	/* data = xgifb_reg_get(pVBInfo->P3c4, 0x1); */
-	/* data |= 0x20 ; */
-	/* xgifb_reg_set(pVBInfo->P3c4, 0x01, data); *//* Turn OFF Display */
 	XGINew_DDRSizing340(HwDeviceExtension, pVBInfo);
 	data = xgifb_reg_get(pVBInfo->P3c4, 0x21);
 	/* enable read cache */
@@ -1308,16 +1288,11 @@ unsigned char XGIInitNew(struct pci_dev *pdev)
 	struct vb_device_info VBINF;
 	struct vb_device_info *pVBInfo = &VBINF;
 	unsigned char i, temp = 0, temp1;
-	/* VBIOSVersion[5]; */
-
-	/* unsigned long j, k; */
 
 	pVBInfo->FBAddr = HwDeviceExtension->pjVideoMemoryAddress;
 
 	pVBInfo->BaseAddr = xgifb_info->vga_base;
 
-	/* Newdebugcode(0x99); */
-
 	if (pVBInfo->FBAddr == NULL) {
 		dev_dbg(&pdev->dev, "pVBInfo->FBAddr == 0\n");
 		return 0;
@@ -1331,10 +1306,6 @@ unsigned char XGIInitNew(struct pci_dev *pdev)
 
 	pVBInfo->ISXPDOS = 0;
 
-	/* VBIOSVersion[4] = 0x0; */
-
-	/* 09/07/99 modify by domao */
-
 	pVBInfo->P3c4 = pVBInfo->BaseAddr + 0x14;
 	pVBInfo->P3d4 = pVBInfo->BaseAddr + 0x24;
 	pVBInfo->P3c0 = pVBInfo->BaseAddr + 0x10;
@@ -1353,7 +1324,7 @@ unsigned char XGIInitNew(struct pci_dev *pdev)
 	pVBInfo->Part4Port = pVBInfo->BaseAddr + SIS_CRT2_PORT_14;
 	pVBInfo->Part5Port = pVBInfo->BaseAddr + SIS_CRT2_PORT_14 + 2;
 
-	if (HwDeviceExtension->jChipType < XG20) /* kuku 2004/06/25 */
+	if (HwDeviceExtension->jChipType < XG20)
 		/* Run XGI_GetVBType before InitTo330Pointer */
 		XGI_GetVBType(pVBInfo);
 
@@ -1361,7 +1332,7 @@ unsigned char XGIInitNew(struct pci_dev *pdev)
 
 	xgifb_read_vbios(pdev, pVBInfo);
 
-	/* 1.Openkey */
+	/* Openkey */
 	xgifb_reg_set(pVBInfo->P3c4, 0x05, 0x86);
 
 	/* GetXG21Sense (GPIO) */
@@ -1371,7 +1342,7 @@ unsigned char XGIInitNew(struct pci_dev *pdev)
 	if (HwDeviceExtension->jChipType == XG27)
 		XGINew_GetXG27Sense(HwDeviceExtension, pVBInfo);
 
-	/* 2.Reset Extended register */
+	/* Reset Extended register */
 
 	for (i = 0x06; i < 0x20; i++)
 		xgifb_reg_set(pVBInfo->P3c4, i, 0);
@@ -1379,31 +1350,20 @@ unsigned char XGIInitNew(struct pci_dev *pdev)
 	for (i = 0x21; i <= 0x27; i++)
 		xgifb_reg_set(pVBInfo->P3c4, i, 0);
 
-	/* for(i = 0x06; i <= 0x27; i++) */
-	/* xgifb_reg_set(pVBInfo->P3c4, i, 0); */
-
 	for (i = 0x31; i <= 0x3B; i++)
 		xgifb_reg_set(pVBInfo->P3c4, i, 0);
 
-	/* [Hsuan] 2004/08/20 Auto over driver for XG42 */
+	/* Auto over driver for XG42 */
 	if (HwDeviceExtension->jChipType == XG42)
 		xgifb_reg_set(pVBInfo->P3c4, 0x3B, 0xC0);
 
-	/* for (i = 0x30; i <= 0x3F; i++) */
-	/* xgifb_reg_set(pVBInfo->P3d4, i, 0); */
-
 	for (i = 0x79; i <= 0x7C; i++)
-		xgifb_reg_set(pVBInfo->P3d4, i, 0); /* shampoo 0208 */
+		xgifb_reg_set(pVBInfo->P3d4, i, 0);
 
 	if (HwDeviceExtension->jChipType >= XG20)
 		xgifb_reg_set(pVBInfo->P3d4, 0x97, pVBInfo->XGINew_CR97);
 
-	/* 3.SetMemoryClock
-
-	pVBInfo->ram_type = XGINew_GetXG20DRAMType(HwDeviceExtension, pVBInfo);
-	*/
-
-	/* 4.SetDefExt1Regs begin */
+	/* SetDefExt1Regs begin */
 	xgifb_reg_set(pVBInfo->P3c4, 0x07, XGI330_SR07);
 	if (HwDeviceExtension->jChipType == XG27) {
 		xgifb_reg_set(pVBInfo->P3c4, 0x40, XG27_SR40);
@@ -1411,62 +1371,16 @@ unsigned char XGIInitNew(struct pci_dev *pdev)
 	}
 	xgifb_reg_set(pVBInfo->P3c4, 0x11, 0x0F);
 	xgifb_reg_set(pVBInfo->P3c4, 0x1F, XGI330_SR1F);
-	/* xgifb_reg_set(pVBInfo->P3c4, 0x20, 0x20); */
-	/* alan, 2001/6/26 Frame buffer can read/write SR20 */
+	/* Frame buffer can read/write SR20 */
 	xgifb_reg_set(pVBInfo->P3c4, 0x20, 0xA0);
-	/* Hsuan, 2006/01/01 H/W request for slow corner chip */
+	/* H/W request for slow corner chip */
 	xgifb_reg_set(pVBInfo->P3c4, 0x36, 0x70);
-	if (HwDeviceExtension->jChipType == XG27) /* Alan 12/07/2006 */
+	if (HwDeviceExtension->jChipType == XG27)
 		xgifb_reg_set(pVBInfo->P3c4, 0x36, XG27_SR36);
 
-	/* SR11 = 0x0F; */
-	/* xgifb_reg_set(pVBInfo->P3c4, 0x11, SR11); */
-
-	if (HwDeviceExtension->jChipType < XG20) { /* kuku 2004/06/25 */
+	if (HwDeviceExtension->jChipType < XG20) {
 		u32 Temp;
 
-		/* Set AGP Rate */
-		/*
-		temp1 = xgifb_reg_get(pVBInfo->P3c4, 0x3B);
-		temp1 &= 0x02;
-		if (temp1 == 0x02) {
-			outl(0x80000000, 0xcf8);
-			ChipsetID = inl(0x0cfc);
-			outl(0x8000002C, 0xcf8);
-			VendorID = inl(0x0cfc);
-			VendorID &= 0x0000FFFF;
-			outl(0x8001002C, 0xcf8);
-			GraphicVendorID = inl(0x0cfc);
-			GraphicVendorID &= 0x0000FFFF;
-
-			if (ChipsetID == 0x7301039)
-				xgifb_reg_set(pVBInfo->P3d4, 0x5F, 0x09);
-
-			ChipsetID &= 0x0000FFFF;
-
-			if ((ChipsetID == 0x700E) ||
-			    (ChipsetID == 0x1022) ||
-			    (ChipsetID == 0x1106) ||
-			    (ChipsetID == 0x10DE)) {
-				if (ChipsetID == 0x1106) {
-					if ((VendorID == 0x1019) &&
-					    (GraphicVendorID == 0x1019))
-						xgifb_reg_set(pVBInfo->P3d4,
-							      0x5F,
-							      0x0D);
-					else
-						xgifb_reg_set(pVBInfo->P3d4,
-							      0x5F,
-							      0x0B);
-				} else {
-					xgifb_reg_set(pVBInfo->P3d4,
-						      0x5F,
-						      0x0B);
-				}
-			}
-		}
-		*/
-
 		/* Set AGP customize registers (in SetDefAGPRegs) Start */
 		for (i = 0x47; i <= 0x4C; i++)
 			xgifb_reg_set(pVBInfo->P3d4,
@@ -1482,12 +1396,6 @@ unsigned char XGIInitNew(struct pci_dev *pdev)
 			xgifb_reg_set(pVBInfo->P3d4,
 				      i,
 				      pVBInfo->AGPReg[8 + i - 0x74]);
-		/* Set AGP customize registers (in SetDefAGPRegs) End */
-		/* [Hsuan]2004/12/14 AGP Input Delay Adjustment on 850 */
-		/*        outl(0x80000000, 0xcf8); */
-		/*        ChipsetID = inl(0x0cfc); */
-		/*        if (ChipsetID == 0x25308086) */
-		/*            xgifb_reg_set(pVBInfo->P3d4, 0x77, 0xF0); */
 
 		pci_read_config_dword(pdev, 0x50, &Temp);
 		Temp >>= 20;
@@ -1502,10 +1410,10 @@ unsigned char XGIInitNew(struct pci_dev *pdev)
 	xgifb_reg_set(pVBInfo->P3c4, 0x24, XGI330_SR24);
 	xgifb_reg_set(pVBInfo->P3c4, 0x25, XGI330_SR25);
 
-	if (HwDeviceExtension->jChipType < XG20) { /* kuku 2004/06/25 */
+	if (HwDeviceExtension->jChipType < XG20) {
 		/* Set VB */
 		XGI_UnLockCRT2(HwDeviceExtension, pVBInfo);
-		/* alan, disable VideoCapture */
+		/* disable VideoCapture */
 		xgifb_reg_and_or(pVBInfo->Part0Port, 0x3F, 0xEF, 0x00);
 		xgifb_reg_set(pVBInfo->Part1Port, 0x00, 0x00);
 		/* chk if BCLK>=100MHz */
@@ -1535,10 +1443,7 @@ unsigned char XGIInitNew(struct pci_dev *pdev)
 	}
 	xgifb_reg_set(pVBInfo->P3c4, 0x33, XGI330_SR33);
 
-	/*
-	 SetPowerConsume (HwDeviceExtension, pVBInfo->P3c4);	*/
-
-	if (HwDeviceExtension->jChipType < XG20) { /* kuku 2004/06/25 */
+	if (HwDeviceExtension->jChipType < XG20) {
 		if (XGI_BridgeIsOn(pVBInfo) == 1) {
 			if (pVBInfo->IF_DEF_LVDS == 0) {
 				xgifb_reg_set(pVBInfo->Part2Port, 0x00, 0x1C);
@@ -1557,7 +1462,6 @@ unsigned char XGIInitNew(struct pci_dev *pdev)
 
 	XGI_SenseCRT1(pVBInfo);
 
-	/* XGINew_DetectMonitor(HwDeviceExtension); */
 	if (HwDeviceExtension->jChipType == XG21) {
 
 		xgifb_reg_and_or(pVBInfo->P3d4,
@@ -1585,32 +1489,9 @@ unsigned char XGIInitNew(struct pci_dev *pdev)
 
 	XGINew_SetDRAMSize_340(xgifb_info, HwDeviceExtension, pVBInfo);
 
-	/* SetDefExt2Regs begin */
-	/*
-	AGP = 1;
-	temp = (unsigned char) xgifb_reg_get(pVBInfo->P3c4, 0x3A);
-	temp &= 0x30;
-	if (temp == 0x30)
-		AGP = 0;
-
-	if (AGP == 0)
-		pVBInfo->SR21 &= 0xEF;
-
-	xgifb_reg_set(pVBInfo->P3c4, 0x21, pVBInfo->SR21);
-	if (AGP == 1)
-		pVBInfo->SR22 &= 0x20;
-	xgifb_reg_set(pVBInfo->P3c4, 0x22, pVBInfo->SR22);
-	*/
-	/* base = 0x80000000; */
-	/* OutPortLong(0xcf8, base); */
-	/* Temp = (InPortLong(0xcfc) & 0xFFFF); */
-	/* if (Temp == 0x1039) { */
 	xgifb_reg_set(pVBInfo->P3c4,
 		      0x22,
 		      (unsigned char) ((pVBInfo->SR22) & 0xFE));
-	/* } else { */
-	/*	xgifb_reg_set(pVBInfo->P3c4, 0x22, pVBInfo->SR22); */
-	/* } */
 
 	xgifb_reg_set(pVBInfo->P3c4, 0x21, pVBInfo->SR21);
 
diff --git a/drivers/staging/xgifb/vb_init.h b/drivers/staging/xgifb/vb_init.h
index a27b4fe..be5589c 100644
--- a/drivers/staging/xgifb/vb_init.h
+++ b/drivers/staging/xgifb/vb_init.h
@@ -3,4 +3,3 @@
 extern unsigned char XGIInitNew(struct pci_dev *pdev);
 extern struct XGI21_LVDSCapStruct  XGI21_LCDCapList[13];
 #endif
-
diff --git a/drivers/staging/xgifb/vb_setmode.c b/drivers/staging/xgifb/vb_setmode.c
index 479362e..3ba3c48 100644
--- a/drivers/staging/xgifb/vb_setmode.c
+++ b/drivers/staging/xgifb/vb_setmode.c
@@ -1859,7 +1859,6 @@ static void *XGI_GetTVPtr(unsigned short BX, unsigned short ModeNo,
 		i++;
 	}
 
-	/* 07/05/22 */
 	if (table == 0x04) {
 		switch (tempdi[i].DATAPTR) {
 		case 0:
@@ -2519,7 +2518,7 @@ static void XGI_UpdateModeInfo(struct xgi_hw_device_info *HwDeviceExtension,
 		temp &= 0x0f;
 
 		if (!(temp == 0x08)) {
-			/* Check ChannelA by Part1_13 [2003/10/03] */
+			/* Check ChannelA */
 			tempax = xgifb_reg_get(pVBInfo->Part1Port, 0x13);
 			if (tempax & 0x04)
 				tempcl = tempcl | ActiveLCD;
@@ -2675,7 +2674,6 @@ static void XGI_GetVBInfo(unsigned short ModeNo, unsigned short ModeIdIndex,
 		}
 
 		if (pVBInfo->IF_DEF_YPbPr == 1) {
-			/* [Billy] 07/05/04 */
 			if (((pVBInfo->IF_DEF_LVDS == 0) &&
 			    ((pVBInfo->VBType & VB_SIS301LV) ||
 			    (pVBInfo->VBType & VB_SIS302LV) ||
@@ -2927,7 +2925,7 @@ static unsigned char XGI_GetLCDInfo(unsigned short ModeNo,
 	if (tempbx == 0)
 		tempbx = Panel_1024x768; /* default */
 
-	/* LCD75 [2003/8/22] Vicent */
+	/* LCD75 */
 	if ((tempbx == Panel_1024x768) || (tempbx == Panel_1280x1024)) {
 		if (pVBInfo->VBInfo & DriverMode) {
 			tempax = xgifb_reg_get(pVBInfo->P3d4, 0x33);
@@ -4591,7 +4589,7 @@ static void XGI_SetGroup2(unsigned short ModeNo, unsigned short ModeIdIndex,
 		}
 	}
 
-	/* [ycchen] 01/14/03 Modify for 301C PALM Support */
+	/* Modify for 301C PALM Support */
 	if (pVBInfo->VBType & VB_XGI301C) {
 		if (pVBInfo->TVInfo & TVSetPALM)
 			xgifb_reg_and_or(pVBInfo->Part2Port, 0x4E, ~0x08,
@@ -6245,8 +6243,7 @@ unsigned short XGI_GetRatePtrCRT2(struct xgi_hw_device_info *pXGIHWDE,
 		    (pVBInfo->RefIndex[RefreshRateTableIndex].YRes == 600)) {
 			index++;
 		}
-		/* Alan 10/19/2007;
-		 * do the similar adjustment like XGISearchCRT1Rate() */
+		/* do the similar adjustment like XGISearchCRT1Rate() */
 		if ((pVBInfo->RefIndex[RefreshRateTableIndex].XRes == 1024) &&
 		    (pVBInfo->RefIndex[RefreshRateTableIndex].YRes == 768)) {
 			index++;
@@ -6354,7 +6351,7 @@ void XGI_SenseCRT1(struct vb_device_info *pVBInfo)
 	int i;
 	xgifb_reg_set(pVBInfo->P3c4, 0x05, 0x86);
 
-	/* [2004/05/06] Vicent to fix XG42 single LCD sense to CRT+LCD */
+	/* to fix XG42 single LCD sense to CRT+LCD */
 	xgifb_reg_set(pVBInfo->P3d4, 0x57, 0x4A);
 	xgifb_reg_set(pVBInfo->P3d4, 0x53, (unsigned char) (xgifb_reg_get(
 			pVBInfo->P3d4, 0x53) | 0x02));
@@ -6419,7 +6416,7 @@ void XGI_SenseCRT1(struct vb_device_info *pVBInfo)
 	else
 		xgifb_reg_and_or(pVBInfo->P3d4, 0x32, 0xDF, 0x00);
 
-	/* alan, avoid display something, set BLACK DAC if not restore DAC */
+	/* avoid display something, set BLACK DAC if not restore DAC */
 	outb(0x00, pVBInfo->P3c8);
 
 	for (i = 0; i < 256; i++) {
@@ -6432,7 +6429,6 @@ void XGI_SenseCRT1(struct vb_device_info *pVBInfo)
 	xgifb_reg_set(pVBInfo->P3d4, 0x63, CR63);
 	xgifb_reg_set(pVBInfo->P3c4, 0x31, SR31);
 
-	/* [2004/05/11] Vicent */
 	xgifb_reg_set(pVBInfo->P3d4, 0x53, (unsigned char) (xgifb_reg_get(
 			pVBInfo->P3d4, 0x53) & 0xFD));
 	xgifb_reg_set(pVBInfo->P3c4, 0x1F, (unsigned char) SR1F);
@@ -6653,7 +6649,7 @@ unsigned char XGISetModeNew(struct xgifb_video_info *xgifb_info,
 	pVBInfo->IF_DEF_LVDS = 0;
 	pVBInfo->IF_DEF_LCDA = 1;
 
-	if (HwDeviceExtension->jChipType >= XG20) { /* kuku 2004/06/25 */
+	if (HwDeviceExtension->jChipType >= XG20) {
 		pVBInfo->IF_DEF_YPbPr = 0;
 		pVBInfo->IF_DEF_HiVision = 0;
 		pVBInfo->IF_DEF_CRT2Monitor = 0;
@@ -6695,7 +6691,7 @@ unsigned char XGISetModeNew(struct xgifb_video_info *xgifb_info,
 		}
 	}
 
-	if (HwDeviceExtension->jChipType < XG20) /* kuku 2004/06/25 */
+	if (HwDeviceExtension->jChipType < XG20)
 		XGI_GetVBType(pVBInfo);
 
 	InitTo330Pointer(HwDeviceExtension->jChipType, pVBInfo);
@@ -6703,12 +6699,12 @@ unsigned char XGISetModeNew(struct xgifb_video_info *xgifb_info,
 		ModeNo = ModeNo & 0x7F;
 	xgifb_reg_set(pVBInfo->P3c4, 0x05, 0x86);
 
-	if (HwDeviceExtension->jChipType < XG20) /* kuku 2004/06/25 1.Openkey */
+	if (HwDeviceExtension->jChipType < XG20)
 		XGI_UnLockCRT2(HwDeviceExtension, pVBInfo);
 
 	XGI_SearchModeID(ModeNo, &ModeIdIndex, pVBInfo);
 
-	if (HwDeviceExtension->jChipType < XG20) { /* kuku 2004/06/25 */
+	if (HwDeviceExtension->jChipType < XG20) {
 		XGI_GetVBInfo(ModeNo, ModeIdIndex, HwDeviceExtension, pVBInfo);
 		XGI_GetTVInfo(ModeNo, ModeIdIndex, pVBInfo);
 		XGI_GetLCDInfo(ModeNo, ModeIdIndex, pVBInfo);
@@ -6779,7 +6775,7 @@ unsigned char XGISetModeNew(struct xgifb_video_info *xgifb_info,
 
 	XGI_UpdateModeInfo(HwDeviceExtension, pVBInfo);
 
-	if (HwDeviceExtension->jChipType < XG20) { /* kuku 2004/06/25 */
+	if (HwDeviceExtension->jChipType < XG20) {
 		XGI_LockCRT2(HwDeviceExtension, pVBInfo);
 	}
 
diff --git a/drivers/staging/xgifb/vb_struct.h b/drivers/staging/xgifb/vb_struct.h
index aea760a..22c8eb9 100644
--- a/drivers/staging/xgifb/vb_struct.h
+++ b/drivers/staging/xgifb/vb_struct.h
@@ -28,7 +28,6 @@ struct XGI_Ext2Struct {
 	unsigned char  ModeID;
 	unsigned short XRes;
 	unsigned short YRes;
-	/* unsigned short ROM_OFFSET; */
 };
 
 struct XGI_ECLKDataStruct {
@@ -167,7 +166,6 @@ struct vb_device_info {
 	unsigned short   LCDHRS, LCDVRS, LCDHDES, LCDVDES;
 
 	unsigned short   ModeType;
-	/* ,IF_DEF_FSTN; add for dstn */
 	unsigned short   IF_DEF_LVDS, IF_DEF_TRUMPION, IF_DEF_DSTN;
 	unsigned short   IF_DEF_CRT2Monitor;
 	unsigned short   IF_DEF_LCDA, IF_DEF_YPbPr;
@@ -225,7 +223,6 @@ struct vb_device_info {
 	struct SiS_StandTable_S  *StandTable;
 	struct XGI_ExtStruct         *EModeIDTable;
 	struct XGI_Ext2Struct        *RefIndex;
-	/* XGINew_CRT1TableStruct *CRT1Table; */
 	struct XGI_CRT1TableStruct    *XGINEWUB_CRT1Table;
 	struct SiS_VCLKData    *VCLKData;
 	struct SiS_VBVCLKData  *VBVCLKData;
diff --git a/drivers/staging/xgifb/vb_table.h b/drivers/staging/xgifb/vb_table.h
index 75da7c3..ca8c68d 100644
--- a/drivers/staging/xgifb/vb_table.h
+++ b/drivers/staging/xgifb/vb_table.h
@@ -1,6 +1,5 @@
 #ifndef _VB_TABLE_
 #define _VB_TABLE_
-/* yilin modify for xgi20 */
 static struct SiS_MCLKData XGI340New_MCLKData[] = {
 	{0x16, 0x01, 0x01, 166},
 	{0x19, 0x02, 0x01, 124},
@@ -23,7 +22,6 @@ static struct SiS_MCLKData XGI27New_MCLKData[] = {
 	{0x5c, 0x23, 0x01, 166}
 };
 
-/* yilin modify for xgi20 */
 static struct XGI_ECLKDataStruct XGI340_ECLKData[] = {
 	{0x5c, 0x23, 0x01, 166},
 	{0x55, 0x84, 0x01, 123},
@@ -424,13 +422,9 @@ static struct SiS_LCDData  XGI_StLCD1024x768Data[] = {
 };
 
 static struct SiS_LCDData  XGI_ExtLCD1024x768Data[] = {
-	/* { 12, 5, 896, 512,1344, 806}, // alan 09/12/2003 */
 	{42, 25, 1536, 419, 1344, 806},
-	/* { 12, 5, 896, 510,1344, 806}, // alan 09/12/2003 */
 	{48, 25, 1536, 369, 1344, 806},
-	/* { 32, 15,1008, 505,1344, 806}, // alan 09/12/2003 */
 	{42, 25, 1536, 419, 1344, 806},
-	/* { 32, 15,1008, 514,1344, 806}, // alan 09/12/2003 */
 	{48, 25, 1536, 369, 1344, 806},
 	{12, 5,  896,  500, 1344, 806},
 	{42, 25, 1024, 625, 1344, 806},
@@ -504,14 +498,10 @@ static struct SiS_LCDData xgifb_lcd_1400x1050[] = {
 };
 
 static struct SiS_LCDData  XGI_ExtLCD1600x1200Data[] = {
-	{4,  1,  1620, 420,  2160, 1250}, /* { 3,1,2160,425,2160,1250 },
-					  // 00 (320x200,320x400,
-					  //	 640x200,640x400)
-					  //	 // alan 10/14/2003 */
+	{4,  1,  1620, 420,  2160, 1250}, /* 00 (320x200,320x400,
+						 640x200,640x400)*/
 	{27, 7,  1920, 375,  2160, 1250}, /* 01 (320x350,640x350) */
-	{4,  1,  1620, 420,  2160, 1250}, /* { 3,1,2160,425,2160,1250 },
-					  // 02 (360x400,720x400)
-					  // // alan 10/14/2003 */
+	{4,  1,  1620, 420,  2160, 1250}, /* 02 (360x400,720x400)*/
 	{27, 7,  1920, 375,  2160, 1250}, /* 03 (720x350) */
 	{27, 4,  800,  500,  2160, 1250}, /* 04 (640x480x60Hz) */
 	{4,  1,  1080, 625,  2160, 1250}, /* 05 (800x600x60Hz) */
@@ -615,8 +605,7 @@ static struct SiS_LCDData  XGI_NoScalingDatax75[] = {
 	{1, 1, 1056, 625,  1056, 625},  /* ; 05 (800x600x75Hz) */
 	{1, 1, 1312, 800,  1312, 800},  /* ; 06 (1024x768x75Hz) */
 	{1, 1, 1688, 1066, 1688, 1066}, /* ; 07 (1280x1024x75Hz) */
-	{1, 1, 1688, 1066, 1688, 1066}, /* ; 08 (1400x1050x75Hz)
-					   ;;[ycchen] 12/19/02 */
+	{1, 1, 1688, 1066, 1688, 1066}, /* ; 08 (1400x1050x75Hz)*/
 	{1, 1, 2160, 1250, 2160, 1250}, /* ; 09 (1600x1200x75Hz) */
 	{1, 1, 1688, 806,  1688, 806}   /* ; 0A (1280x768x75Hz) */
 };
@@ -823,8 +812,7 @@ static struct XGI330_LCDDataDesStruct2  XGI_NoScalingDesData[] = {
 	{9, 849,  627, 600,  128,  4}, /* 05 (800x600x60Hz) */
 	{9, 1057, 805, 770,  0136, 6}, /* 06 (1024x768x60Hz) */
 	{9, 1337, 0,   1025, 112,  3}, /* 07 (1280x1024x60Hz) */
-	{9, 1457, 0,   1051, 112,  3}, /* 08 (1400x1050x60Hz) },
-					//;[ycchen] 12/19/02 */
+	{9, 1457, 0,   1051, 112,  3}, /* 08 (1400x1050x60Hz)*/
 	{9, 1673, 0,   1201, 192,  3}, /* 09 (1600x1200x60Hz) */
 	{9, 1337, 0,   771,  112,  6}  /* 0A (1280x768x60Hz) */
 };
@@ -910,8 +898,7 @@ static struct XGI330_LCDDataDesStruct2 XGI_NoScalingDesDatax75[] =  {
 	{9, 825,  0,   601,  80,  3}, /* ; 05 (800x600x75Hz) */
 	{9, 1049, 0,   769,  96,  3}, /* ; 06 (1024x768x75Hz) */
 	{9, 1305, 0,   1025, 144, 3}, /* ; 07 (1280x1024x75Hz) */
-	{9, 1457, 0,   1051, 112, 3}, /* ; 08 (1400x1050x60Hz)
-					 ;;[ycchen] 12/19/02 */
+	{9, 1457, 0,   1051, 112, 3}, /* ; 08 (1400x1050x60Hz)*/
 	{9, 1673, 0,   1201, 192, 3}, /* ; 09 (1600x1200x75Hz) */
 	{9, 1337, 0,   771,  112, 6}  /* ; 0A (1280x768x60Hz) */
 };
@@ -1308,7 +1295,7 @@ static struct SiS_LVDSData XGI_LVDSNoScalingData[] = {
 	{1056,  628, 1056,  628}, /* 05 (800x600x60Hz) */
 	{1344,  806, 1344,  806}, /* 06 (1024x768x60Hz) */
 	{1688, 1066, 1688, 1066}, /* 07 (1280x1024x60Hz) */
-	{1688, 1066, 1688, 1066}, /* 08 (1400x1050x60Hz) ;;[ycchen] 12/19/02 */
+	{1688, 1066, 1688, 1066}, /* 08 (1400x1050x60Hz) */
 	{2160, 1250, 2160, 1250}, /* 09 (1600x1200x60Hz) */
 	{1688,  806, 1688,  806}  /* 0A (1280x768x60Hz) */
 };
@@ -1469,8 +1456,7 @@ static struct XGI330_LCDDataDesStruct2  XGI_LVDSNoScalingDesData[] = {
 	{0,  840,  627,  600, 128, 4}, /* 05 (800x600x60Hz) */
 	{0, 1048,  805,  770, 136, 6}, /* 06 (1024x768x60Hz) */
 	{0, 1328,    0, 1025, 112, 3}, /* 07 (1280x1024x60Hz) */
-	{0, 1438,    0, 1051, 112, 3}, /* 08 (1400x1050x60Hz)
-					;;[ycchen] 12/19/02 */
+	{0, 1438,    0, 1051, 112, 3}, /* 08 (1400x1050x60Hz)*/
 	{0, 1664,    0, 1201, 192, 3}, /* 09 (1600x1200x60Hz) */
 	{0, 1328,    0, 0771, 112, 6}  /* 0A (1280x768x60Hz) */
 };
@@ -1518,7 +1504,7 @@ static struct SiS_LVDSData XGI_LVDS1280x1024Des_1x75[] = {
 };
 
 /* The Display setting for DE Mode Panel */
-/* [ycchen] 02/18/03 Set DE as default */
+/* Set DE as default */
 static struct SiS_LVDSData XGI_LVDS1280x1024Des_2x75[] = {
 	{1368,  976, 752,  711}, /* ; 00 (320x200,320x400,640x200,640x400) */
 	{1368,  976, 729,  688}, /* ; 01 (320x350,640x350) */
@@ -1541,8 +1527,7 @@ static struct XGI330_LCDDataDesStruct2 XGI_LVDSNoScalingDesDatax75[] = {
 	{0,  816,   0,  601,  80, 3}, /* ; 05 (800x600x75Hz) */
 	{0, 1040,   0,  769,  96, 3}, /* ; 06 (1024x768x75Hz) */
 	{0, 1296,   0, 1025, 144, 3}, /* ; 07 (1280x1024x75Hz) */
-	{0, 1448,   0, 1051, 112, 3}, /* ; 08 (1400x1050x75Hz)
-					 ;;[ycchen] 12/19/02 */
+	{0, 1448,   0, 1051, 112, 3}, /* ; 08 (1400x1050x75Hz) */
 	{0, 1664,   0, 1201, 192, 3}, /* ; 09 (1600x1200x75Hz) */
 	{0, 1328,   0,  771, 112, 6}  /* ; 0A (1280x768x75Hz) */
 };
diff --git a/drivers/staging/xgifb/vb_util.h b/drivers/staging/xgifb/vb_util.h
index 9161de1..ff40247 100644
--- a/drivers/staging/xgifb/vb_util.h
+++ b/drivers/staging/xgifb/vb_util.h
@@ -6,4 +6,3 @@ extern void xgifb_reg_or(unsigned long, u8, unsigned);
 extern void xgifb_reg_and(unsigned long, u8, unsigned);
 extern void xgifb_reg_and_or(unsigned long, u8, unsigned, unsigned);
 #endif
-
diff --git a/drivers/staging/xgifb/vgatypes.h b/drivers/staging/xgifb/vgatypes.h
index 7fc0719..839acb40 100644
--- a/drivers/staging/xgifb/vgatypes.h
+++ b/drivers/staging/xgifb/vgatypes.h
@@ -79,7 +79,4 @@ struct xgi_hw_device_info {
 	unsigned long ulCRT2LCDType; /* defined in the data structure type */
 };
 
-/* Additional IOCTL for communication xgifb <> X driver        */
-/* If changing this, xgifb.h must also be changed (for xgifb) */
 #endif
-
-- 
1.7.9.5

