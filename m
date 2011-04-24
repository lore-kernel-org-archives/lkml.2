Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755479Ab1DXHok (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Apr 2011 03:44:40 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:41062 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750807Ab1DXHog (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Apr 2011 03:44:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=Ozi7IYahWVU+7+xInbDhtF3eyWxjBjl3eairDtWd8lnfl/Ib12YsMsVY5LcYEwbsyr
         +VbtS6eoXPK1sZ9N+aR40+KsvIz68kwalPI6Jgv9vLuozwef3RCzkq6g28lt0y1TqI7o
         oACK0MyzroaXhmExJfmrhR1rNKJTu/xx5N7WA=
From: Kenji Toyama <kenji.toyama@gmail.com>
To: gregkh@suse.de, aaro.koskinen@iki.fi, wfp5p@virginia.edu,
        martinez.javier@gmail.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Kenji Toyama <kenji.toyama@gmail.com>
Subject: [PATCH 12/12] Staging: xgifb: Fixed style issues.
Date: Sun, 24 Apr 2011 15:44:10 +0800
Message-Id: <1303631050-4247-1-git-send-email-kenji.toyama@gmail.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Not all warnings/errors were silenced, some of them are related to
simple printk() messages that imho should not be split across multiple
lines (it makes it harder to grep for example), and some of them are
related to long lines that are pretty much impossible to split without
proper code refactoring.

Signed-off-by: Daniel Kenji Toyama <kenji.toyama@gmail.com>
---
 drivers/staging/xgifb/XGI_main_26.c |  417 +++++++++++++++++++++++------------
 1 files changed, 274 insertions(+), 143 deletions(-)

diff --git a/drivers/staging/xgifb/XGI_main_26.c b/drivers/staging/xgifb/XGI_main_26.c
index 721bd25..b1894e3 100644
--- a/drivers/staging/xgifb/XGI_main_26.c
+++ b/drivers/staging/xgifb/XGI_main_26.c
@@ -33,7 +33,7 @@
 #define XGIFB_PAN
 #endif
 
-#include <asm/io.h>
+#include <linux/io.h>
 #ifdef CONFIG_MTRR
 #include <asm/mtrr.h>
 #endif
@@ -348,10 +348,10 @@ static int XGIfb_mode_rate_to_ddata(struct vb_device_info *XGI_Pr,
 	else {
 		j = 0;
 		while (XGI_Pr->EModeIDTable[j].Ext_ModeID != 0xff) {
-			if (XGI_Pr->EModeIDTable[j].Ext_ModeID
-					== XGI_Pr->RefIndex[RefreshRateTableIndex].ModeID) {
-				if (XGI_Pr->EModeIDTable[j].Ext_ModeFlag
-						& DoubleScanMode) {
+			if (XGI_Pr->EModeIDTable[j].Ext_ModeID ==
+			    XGI_Pr->RefIndex[RefreshRateTableIndex].ModeID) {
+				if (XGI_Pr->EModeIDTable[j].Ext_ModeFlag &
+				    DoubleScanMode) {
 					*vmode = FB_VMODE_DOUBLE;
 				}
 				break;
@@ -377,12 +377,16 @@ static void XGIRegInit(struct vb_device_info *XGI_Pr, unsigned long BaseAddr)
 	XGI_Pr->P3c8 = BaseAddr + 0x18;
 	XGI_Pr->P3c9 = BaseAddr + 0x19;
 	XGI_Pr->P3da = BaseAddr + 0x2A;
-	XGI_Pr->Part1Port = BaseAddr + XGI_CRT2_PORT_04; /* Digital video interface registers (LCD) */
-	XGI_Pr->Part2Port = BaseAddr + XGI_CRT2_PORT_10; /* 301 TV Encoder registers */
-	XGI_Pr->Part3Port = BaseAddr + XGI_CRT2_PORT_12; /* 301 Macrovision registers */
-	XGI_Pr->Part4Port = BaseAddr + XGI_CRT2_PORT_14; /* 301 VGA2 (and LCD) registers */
-	XGI_Pr->Part5Port = BaseAddr + XGI_CRT2_PORT_14 + 2; /* 301 palette address port registers */
-
+	/* Digital video interface registers (LCD) */
+	XGI_Pr->Part1Port = BaseAddr + XGI_CRT2_PORT_04;
+	/* 301 TV Encoder registers */
+	XGI_Pr->Part2Port = BaseAddr + XGI_CRT2_PORT_10;
+	/* 301 Macrovision registers */
+	XGI_Pr->Part3Port = BaseAddr + XGI_CRT2_PORT_12;
+	/* 301 VGA2 (and LCD) registers */
+	XGI_Pr->Part4Port = BaseAddr + XGI_CRT2_PORT_14;
+	/* 301 palette address port registers */
+	XGI_Pr->Part5Port = BaseAddr + XGI_CRT2_PORT_14 + 2;
 }
 
 void XGIfb_set_reg4(u16 port, unsigned long data)
@@ -437,8 +441,12 @@ unsigned char XGIfb_query_VGA_config_space(
 }
 
 /*
-unsigned char XGIfb_query_north_bridge_space(struct xgi_hw_device_info *pXGIhw_ext,
-	unsigned long offset, unsigned long set, unsigned long *value)
+unsigned char XGIfb_query_north_bridge_space(
+	struct xgi_hw_device_info *pXGIhw_ext,
+	unsigned long offset,
+	unsigned long set,
+	unsigned long *value
+)
 {
 	static struct pci_dev *pdev = NULL;
 	static unsigned char init = 0, valid_pdev = 0;
@@ -551,8 +559,8 @@ static void XGIfb_search_vesamode(unsigned int vesamode)
 	vesamode &= 0x1dff; /* Clean VESA mode number from other flags */
 
 	while (XGIbios_mode[i].mode_no != 0) {
-		if ((XGIbios_mode[i].vesa_mode_no_1 == vesamode)
-				|| (XGIbios_mode[i].vesa_mode_no_2 == vesamode)) {
+		if ((XGIbios_mode[i].vesa_mode_no_1 == vesamode) ||
+		    (XGIbios_mode[i].vesa_mode_no_2 == vesamode)) {
 			xgifb_mode_idx = i;
 			j = 1;
 			break;
@@ -573,7 +581,9 @@ static int XGIfb_GetXG21LVDSData(void)
 	outXGIIDXREG(XGISR, 0x1e, tmp | 4);
 
 	pData = xgi_video_info.mmio_vbase + 0x20000;
-	if ((pData[0x0] == 0x55) && (pData[0x1] == 0xAA) && (pData[0x65] & 0x1)) {
+	if ((pData[0x0] == 0x55) &&
+	    (pData[0x1] == 0xAA) &&
+	    (pData[0x65] & 0x1)) {
 		i = pData[0x316] | (pData[0x317] << 8);
 		j = pData[i - 1];
 		if (j == 0xff)
@@ -656,8 +666,8 @@ static int XGIfb_validate_mode(int myindex)
 				return -1;
 			if (XGIbios_mode[myindex].yres > yres)
 				return -1;
-			if ((XGIbios_mode[myindex].xres < xres)
-					&& (XGIbios_mode[myindex].yres < yres)) {
+			if ((XGIbios_mode[myindex].xres < xres) &&
+			    (XGIbios_mode[myindex].yres < yres)) {
 				if (XGIbios_mode[myindex].bpp > 8)
 					return -1;
 			}
@@ -733,7 +743,7 @@ static int XGIfb_validate_mode(int myindex)
 		if (XGIbios_mode[myindex].yres > yres)
 			return -1;
 		if ((XGIhw_ext.ulExternalChip == 0x01) || /* LVDS */
-				(XGIhw_ext.ulExternalChip == 0x05)) { /* LVDS+Chrontel */
+		    (XGIhw_ext.ulExternalChip == 0x05)) { /* LVDS+Chrontel */
 			switch (XGIbios_mode[myindex].xres) {
 			case 512:
 				if (XGIbios_mode[myindex].yres != 512)
@@ -756,9 +766,8 @@ static int XGIfb_validate_mode(int myindex)
 						&& (XGIbios_mode[myindex].yres
 								!= 768))
 					return -1;
-				if ((XGIbios_mode[myindex].yres == 600)
-						&& (XGIhw_ext.ulCRT2LCDType
-								!= LCD_1024x600))
+				if ((XGIbios_mode[myindex].yres == 600) &&
+				    (XGIhw_ext.ulCRT2LCDType != LCD_1024x600))
 					return -1;
 				break;
 			case 1152:
@@ -768,13 +777,11 @@ static int XGIfb_validate_mode(int myindex)
 					return -1;
 				break;
 			case 1280:
-				if ((XGIbios_mode[myindex].yres != 768)
-						&& (XGIbios_mode[myindex].yres
-								!= 1024))
+				if ((XGIbios_mode[myindex].yres != 768) &&
+				    (XGIbios_mode[myindex].yres != 1024))
 					return -1;
-				if ((XGIbios_mode[myindex].yres == 768)
-						&& (XGIhw_ext.ulCRT2LCDType
-								!= LCD_1280x768))
+				if ((XGIbios_mode[myindex].yres == 768) &&
+				    (XGIhw_ext.ulCRT2LCDType != LCD_1280x768))
 					return -1;
 				break;
 			case 1400:
@@ -847,8 +854,8 @@ static int XGIfb_validate_mode(int myindex)
 					return -1;
 			}
 			/*  TW: LVDS/CHRONTEL does not support 720 */
-			if (xgi_video_info.hasVB == HASVB_LVDS_CHRONTEL
-					|| xgi_video_info.hasVB	== HASVB_CHRONTEL) {
+			if (xgi_video_info.hasVB == HASVB_LVDS_CHRONTEL ||
+			    xgi_video_info.hasVB == HASVB_CHRONTEL) {
 				return -1;
 			}
 			break;
@@ -910,16 +917,16 @@ static u8 XGIfb_search_refresh_rate(unsigned int rate)
 					DPRINTK("XGIfb: Adjusting rate from %d up to %d\n",
 							rate, XGIfb_vrate[i].refresh);
 					XGIfb_rate_idx = XGIfb_vrate[i].idx;
-					xgi_video_info.refresh_rate
-							= XGIfb_vrate[i].refresh;
+					xgi_video_info.refresh_rate =
+						XGIfb_vrate[i].refresh;
 				} else if (((rate - XGIfb_vrate[i - 1].refresh)
 						<= 2) && (XGIfb_vrate[i].idx
 						!= 1)) {
 					DPRINTK("XGIfb: Adjusting rate from %d down to %d\n",
 							rate, XGIfb_vrate[i-1].refresh);
 					XGIfb_rate_idx = XGIfb_vrate[i - 1].idx;
-					xgi_video_info.refresh_rate
-							= XGIfb_vrate[i - 1].refresh;
+					xgi_video_info.refresh_rate =
+						XGIfb_vrate[i - 1].refresh;
 				}
 				break;
 			} else if ((rate - XGIfb_vrate[i].refresh) <= 2) {
@@ -934,8 +941,8 @@ static u8 XGIfb_search_refresh_rate(unsigned int rate)
 	if (XGIfb_rate_idx > 0) {
 		return XGIfb_rate_idx;
 	} else {
-		printk(KERN_INFO
-				"XGIfb: Unsupported rate %d for %dx%d\n", rate, xres, yres);
+		printk(KERN_INFO "XGIfb: Unsupported rate %d for %dx%d\n",
+		       rate, xres, yres);
 		return 0;
 	}
 }
@@ -1008,7 +1015,9 @@ static int XGIfb_do_set_var(struct fb_var_screeninfo *var, int isactive,
 	/* unsigned char reg, reg1; */
 
 	DEBUGPRN("Inside do_set_var");
-	/* printk(KERN_DEBUG "XGIfb:var->yres=%d, var->upper_margin=%d, var->lower_margin=%d, var->vsync_len=%d\n", var->yres, var->upper_margin, var->lower_margin, var->vsync_len); */
+	/* printk(KERN_DEBUG "XGIfb:var->yres=%d, var->upper_margin=%d,
+		  var->lower_margin=%d, var->vsync_len=%d\n", var->yres,
+		  var->upper_margin, var->lower_margin, var->vsync_len); */
 
 	info->var.xres_virtual = var->xres_virtual;
 	info->var.yres_virtual = var->yres_virtual;
@@ -1039,7 +1048,8 @@ static int XGIfb_do_set_var(struct fb_var_screeninfo *var, int isactive,
 	}
 
 	printk(KERN_DEBUG "XGIfb: Change mode to %dx%dx%d-%dHz\n",
-			var->xres, var->yres, var->bits_per_pixel, xgi_video_info.refresh_rate);
+	       var->xres, var->yres, var->bits_per_pixel,
+	       xgi_video_info.refresh_rate);
 
 	old_mode = xgifb_mode_idx;
 	xgifb_mode_idx = 0;
@@ -1064,8 +1074,8 @@ static int XGIfb_do_set_var(struct fb_var_screeninfo *var, int isactive,
 		xgifb_mode_idx = -1;
 
 	if (xgifb_mode_idx < 0) {
-		printk(KERN_ERR "XGIfb: Mode %dx%dx%d not supported\n", var->xres,
-				var->yres, var->bits_per_pixel);
+		printk(KERN_ERR "XGIfb: Mode %dx%dx%d not supported\n",
+		       var->xres, var->yres, var->bits_per_pixel);
 		xgifb_mode_idx = old_mode;
 		return -EINVAL;
 	}
@@ -1079,7 +1089,8 @@ static int XGIfb_do_set_var(struct fb_var_screeninfo *var, int isactive,
 
 		XGIfb_pre_setmode();
 		if (XGISetModeNew(&XGIhw_ext, XGIfb_mode_no) == 0) {
-			printk(KERN_ERR "XGIfb: Setting mode[0x%x] failed\n", XGIfb_mode_no);
+			printk(KERN_ERR "XGIfb: Setting mode[0x%x] failed\n",
+			       XGIfb_mode_no);
 			return -EINVAL;
 		}
 		info->fix.line_length = ((info->var.xres_virtual
@@ -1088,7 +1099,9 @@ static int XGIfb_do_set_var(struct fb_var_screeninfo *var, int isactive,
 		outXGIIDXREG(XGISR, IND_XGI_PASSWORD, XGI_PASSWORD);
 
 		outXGIIDXREG(XGICR, 0x13, (info->fix.line_length & 0x00ff));
-		outXGIIDXREG(XGISR, 0x0E, (info->fix.line_length & 0xff00) >> 8);
+		outXGIIDXREG(XGISR,
+			     0x0E,
+			     (info->fix.line_length & 0xff00) >> 8);
 
 		XGIfb_post_setmode();
 
@@ -1136,7 +1149,8 @@ static int XGIfb_do_set_var(struct fb_var_screeninfo *var, int isactive,
 			break;
 		default:
 			xgi_video_info.video_cmap_len = 16;
-			printk(KERN_ERR "XGIfb: Unsupported depth %d", xgi_video_info.video_bpp);
+			printk(KERN_ERR "XGIfb: Unsupported depth %d",
+			       xgi_video_info.video_bpp);
 			break;
 		}
 	}
@@ -1307,7 +1321,8 @@ static int XGIfb_check_var(struct fb_var_screeninfo *var, struct fb_info *info)
 	if (var->pixclock && htotal && vtotal) {
 		drate = 1000000000 / var->pixclock;
 		hrate = (drate * 1000) / htotal;
-		xgi_video_info.refresh_rate = (unsigned int) (hrate * 2	/ vtotal);
+		xgi_video_info.refresh_rate =
+				(unsigned int) (hrate * 2 / vtotal);
 		printk(KERN_DEBUG
 			"%s: pixclock = %d ,htotal=%d, vtotal=%d\n"
 			"%s: drate=%d, hrate=%d, refresh_rate=%d\n",
@@ -1350,10 +1365,10 @@ static int XGIfb_check_var(struct fb_var_screeninfo *var, struct fb_info *info)
 			var->xres, var->yres, var->bits_per_pixel);
 		search_idx = 0;
 		while (XGIbios_mode[search_idx].mode_no != 0) {
-
 			if ((var->xres <= XGIbios_mode[search_idx].xres) &&
-				(var->yres <= XGIbios_mode[search_idx].yres) &&
-				(var->bits_per_pixel == XGIbios_mode[search_idx].bpp)) {
+			    (var->yres <= XGIbios_mode[search_idx].yres) &&
+			    (var->bits_per_pixel ==
+				 XGIbios_mode[search_idx].bpp)) {
 				if (XGIfb_validate_mode(search_idx) > 0) {
 					found_mode = 1;
 					break;
@@ -1393,7 +1408,8 @@ static int XGIfb_check_var(struct fb_var_screeninfo *var, struct fb_info *info)
 	} /* else { */
 		/* TW: Now patch yres_virtual if we use panning */
 		/* May I do this? */
-		/* var->yres_virtual = xgi_video_info.heapstart / (var->xres * (var->bits_per_pixel >> 3)); */
+		/* var->yres_virtual = xgi_video_info.heapstart /
+				(var->xres * (var->bits_per_pixel >> 3)); */
 		/* if (var->yres_virtual <= var->yres) { */
 		/* TW: Paranoia check */
 		/* var->yres_virtual = var->yres; */
@@ -1908,12 +1924,14 @@ static void XGIfb_post_setmode(void)
 	*test*
 	*/
 	if (xgi_video_info.video_bpp == 8) {
-		/* TW: We can't switch off CRT1 on LVDS/Chrontel in 8bpp Modes */
-		if ((xgi_video_info.hasVB == HASVB_LVDS)
-				|| (xgi_video_info.hasVB == HASVB_LVDS_CHRONTEL)) {
+		/* TW: We can't switch off CRT1 on LVDS/Chrontel
+		 * in 8bpp Modes */
+		if ((xgi_video_info.hasVB == HASVB_LVDS) ||
+		    (xgi_video_info.hasVB == HASVB_LVDS_CHRONTEL)) {
 			doit = 0;
 		}
-		/* TW: We can't switch off CRT1 on 301B-DH in 8bpp Modes if using LCD */
+		/* TW: We can't switch off CRT1 on 301B-DH
+		 * in 8bpp Modes if using LCD */
 		if (xgi_video_info.disp_state & DISPTYPE_LCD)
 			doit = 0;
 	}
@@ -1947,16 +1965,20 @@ static void XGIfb_post_setmode(void)
 
 			switch (xgi_video_info.video_width) {
 			case 320:
-				filter_tb = (xgi_video_info.TV_type == TVMODE_NTSC) ? 4 : 12;
+				filter_tb = (xgi_video_info.TV_type ==
+					     TVMODE_NTSC) ? 4 : 12;
 				break;
 			case 640:
-				filter_tb = (xgi_video_info.TV_type == TVMODE_NTSC) ? 5 : 13;
+				filter_tb = (xgi_video_info.TV_type ==
+					     TVMODE_NTSC) ? 5 : 13;
 				break;
 			case 720:
-				filter_tb = (xgi_video_info.TV_type == TVMODE_NTSC) ? 6 : 14;
+				filter_tb = (xgi_video_info.TV_type ==
+					     TVMODE_NTSC) ? 6 : 14;
 				break;
 			case 800:
-				filter_tb = (xgi_video_info.TV_type == TVMODE_NTSC) ? 7 : 15;
+				filter_tb = (xgi_video_info.TV_type ==
+					     TVMODE_NTSC) ? 7 : 15;
 				break;
 			default:
 				filter = -1;
@@ -1980,22 +2002,46 @@ static void XGIfb_post_setmode(void)
 
 					switch (xgi_video_info.video_width) {
 					case 640:
-						outXGIIDXREG(XGIPART2, 0x35, 0xEB);
-						outXGIIDXREG(XGIPART2, 0x36, 0x04);
-						outXGIIDXREG(XGIPART2, 0x37, 0x25);
-						outXGIIDXREG(XGIPART2, 0x38, 0x18);
+						outXGIIDXREG(XGIPART2,
+							     0x35,
+							     0xEB);
+						outXGIIDXREG(XGIPART2,
+							     0x36,
+							     0x04);
+						outXGIIDXREG(XGIPART2,
+							     0x37,
+							     0x25);
+						outXGIIDXREG(XGIPART2,
+							     0x38,
+							     0x18);
 						break;
 					case 720:
-						outXGIIDXREG(XGIPART2, 0x35, 0xEE);
-						outXGIIDXREG(XGIPART2, 0x36, 0x0C);
-						outXGIIDXREG(XGIPART2, 0x37, 0x22);
-						outXGIIDXREG(XGIPART2, 0x38, 0x08);
+						outXGIIDXREG(XGIPART2,
+							     0x35,
+							     0xEE);
+						outXGIIDXREG(XGIPART2,
+							     0x36,
+							     0x0C);
+						outXGIIDXREG(XGIPART2,
+							     0x37,
+							     0x22);
+						outXGIIDXREG(XGIPART2,
+							     0x38,
+							     0x08);
 						break;
 					case 800:
-						outXGIIDXREG(XGIPART2, 0x35, 0xEB);
-						outXGIIDXREG(XGIPART2, 0x36, 0x15);
-						outXGIIDXREG(XGIPART2, 0x37, 0x25);
-						outXGIIDXREG(XGIPART2, 0x38, 0xF6);
+						outXGIIDXREG(XGIPART2,
+							     0x35,
+							     0xEB);
+						outXGIIDXREG(XGIPART2,
+							     0x36,
+							     0x15);
+						outXGIIDXREG(XGIPART2,
+							     0x37,
+							     0x25);
+						outXGIIDXREG(XGIPART2,
+							     0x38,
+							     0xF6);
 						break;
 					}
 				}
@@ -2015,22 +2061,46 @@ static void XGIfb_post_setmode(void)
 
 					switch (xgi_video_info.video_width) {
 					case 640:
-						outXGIIDXREG(XGIPART2, 0x35, 0xF1);
-						outXGIIDXREG(XGIPART2, 0x36, 0xF7);
-						outXGIIDXREG(XGIPART2, 0x37, 0x1F);
-						outXGIIDXREG(XGIPART2, 0x38, 0x32);
+						outXGIIDXREG(XGIPART2,
+							     0x35,
+							     0xF1);
+						outXGIIDXREG(XGIPART2,
+							     0x36,
+							     0xF7);
+						outXGIIDXREG(XGIPART2,
+							     0x37,
+							     0x1F);
+						outXGIIDXREG(XGIPART2,
+							     0x38,
+							     0x32);
 						break;
 					case 720:
-						outXGIIDXREG(XGIPART2, 0x35, 0xF3);
-						outXGIIDXREG(XGIPART2, 0x36, 0x00);
-						outXGIIDXREG(XGIPART2, 0x37, 0x1D);
-						outXGIIDXREG(XGIPART2, 0x38, 0x20);
+						outXGIIDXREG(XGIPART2,
+							     0x35,
+							     0xF3);
+						outXGIIDXREG(XGIPART2,
+							     0x36,
+							     0x00);
+						outXGIIDXREG(XGIPART2,
+							     0x37,
+							     0x1D);
+						outXGIIDXREG(XGIPART2,
+							     0x38,
+							     0x20);
 						break;
 					case 800:
-						outXGIIDXREG(XGIPART2, 0x35, 0xFC);
-						outXGIIDXREG(XGIPART2, 0x36, 0xFB);
-						outXGIIDXREG(XGIPART2, 0x37, 0x14);
-						outXGIIDXREG(XGIPART2, 0x38, 0x2A);
+						outXGIIDXREG(XGIPART2,
+							     0x35,
+							     0xFC);
+						outXGIIDXREG(XGIPART2,
+							     0x36,
+							     0xFB);
+						outXGIIDXREG(XGIPART2,
+							     0x37,
+							     0x14);
+						outXGIIDXREG(XGIPART2,
+							     0x38,
+							     0x2A);
 						break;
 					}
 				}
@@ -2038,33 +2108,38 @@ static void XGIfb_post_setmode(void)
 
 			if ((filter >= 0) && (filter <= 7)) {
 				DPRINTK("FilterTable[%d]-%d: %02x %02x %02x %02x\n", filter_tb, filter,
-						XGI_TV_filter[filter_tb].filter[filter][0],
-						XGI_TV_filter[filter_tb].filter[filter][1],
-						XGI_TV_filter[filter_tb].filter[filter][2],
-						XGI_TV_filter[filter_tb].filter[filter][3]
+					XGI_TV_filter[filter_tb].
+						filter[filter][0],
+					XGI_TV_filter[filter_tb].
+						filter[filter][1],
+					XGI_TV_filter[filter_tb].
+						filter[filter][2],
+					XGI_TV_filter[filter_tb].
+						filter[filter][3]
 				);
 				outXGIIDXREG(
-						XGIPART2,
-						0x35,
-						(XGI_TV_filter[filter_tb].filter[filter][0]));
+					XGIPART2,
+					0x35,
+					(XGI_TV_filter[filter_tb].
+						filter[filter][0]));
 				outXGIIDXREG(
-						XGIPART2,
-						0x36,
-						(XGI_TV_filter[filter_tb].filter[filter][1]));
+					XGIPART2,
+					0x36,
+					(XGI_TV_filter[filter_tb].
+						filter[filter][1]));
 				outXGIIDXREG(
-						XGIPART2,
-						0x37,
-						(XGI_TV_filter[filter_tb].filter[filter][2]));
+					XGIPART2,
+					0x37,
+					(XGI_TV_filter[filter_tb].
+						filter[filter][2]));
 				outXGIIDXREG(
-						XGIPART2,
-						0x38,
-						(XGI_TV_filter[filter_tb].filter[filter][3]));
+					XGIPART2,
+					0x38,
+					(XGI_TV_filter[filter_tb].
+						filter[filter][3]));
 			}
-
 		}
-
 	}
-
 }
 
 XGIINITSTATIC int __init XGIfb_setup(char *options)
@@ -2086,15 +2161,19 @@ XGIINITSTATIC int __init XGIfb_setup(char *options)
 		if (!strncmp(this_opt, "mode:", 5)) {
 			XGIfb_search_mode(this_opt + 5);
 		} else if (!strncmp(this_opt, "vesa:", 5)) {
-			XGIfb_search_vesamode(simple_strtoul(this_opt + 5, NULL, 0));
+			XGIfb_search_vesamode(simple_strtoul(this_opt + 5,
+							     NULL, 0));
 		} else if (!strncmp(this_opt, "mode:", 5)) {
 			XGIfb_search_mode(this_opt + 5);
 		} else if (!strncmp(this_opt, "vesa:", 5)) {
-			XGIfb_search_vesamode(simple_strtoul(this_opt + 5, NULL, 0));
+			XGIfb_search_vesamode(simple_strtoul(this_opt + 5,
+							     NULL, 0));
 		} else if (!strncmp(this_opt, "vrate:", 6)) {
-			xgi_video_info.refresh_rate = simple_strtoul(this_opt + 6, NULL, 0);
+			xgi_video_info.refresh_rate = simple_strtoul(
+						this_opt + 6, NULL, 0);
 		} else if (!strncmp(this_opt, "rate:", 5)) {
-			xgi_video_info.refresh_rate = simple_strtoul(this_opt + 5, NULL, 0);
+			xgi_video_info.refresh_rate = simple_strtoul(
+						this_opt + 5, NULL, 0);
 		} else if (!strncmp(this_opt, "off", 3)) {
 			XGIfb_off = 1;
 		} else if (!strncmp(this_opt, "crt1off", 7)) {
@@ -2104,7 +2183,8 @@ XGIINITSTATIC int __init XGIfb_setup(char *options)
 		} else if (!strncmp(this_opt, "forcecrt2type:", 14)) {
 			XGIfb_search_crt2type(this_opt + 14);
 		} else if (!strncmp(this_opt, "forcecrt1:", 10)) {
-			XGIfb_forcecrt1 = (int)simple_strtoul(this_opt + 10, NULL, 0);
+			XGIfb_forcecrt1 = (int)simple_strtoul(this_opt + 10,
+							      NULL, 0);
 		} else if (!strncmp(this_opt, "tvmode:", 7)) {
 			XGIfb_search_tvstd(this_opt + 7);
 		} else if (!strncmp(this_opt, "tvstandard:", 11)) {
@@ -2122,12 +2202,17 @@ XGIINITSTATIC int __init XGIfb_setup(char *options)
 		} else if (!strncmp(this_opt, "noypan", 6)) {
 			XGIfb_ypan = 0;
 		} else if (!strncmp(this_opt, "userom:", 7)) {
-			XGIfb_userom = (int)simple_strtoul(this_opt + 7, NULL, 0);
+			XGIfb_userom = (int)simple_strtoul(this_opt + 7,
+							   NULL,
+							   0);
 			/* } else if (!strncmp(this_opt, "useoem:", 7)) { */
-			/* XGIfb_useoem = (int)simple_strtoul(this_opt + 7, NULL, 0); */
+			/* XGIfb_useoem = (int)simple_strtoul(this_opt + 7,
+							      NULL,
+							      0); */
 		} else {
 			XGIfb_search_mode(this_opt);
-			/* printk(KERN_INFO "XGIfb: Invalid option %s\n", this_opt); */
+			/* printk(KERN_INFO "XGIfb: Invalid option %s\n",
+				  this_opt); */
 		}
 
 		/* TW: Panning only with acceleration */
@@ -2178,7 +2263,9 @@ static int __devinit xgifb_probe(struct pci_dev *pdev,
 		return -ENOMEM;
 
 	xgi_video_info.chip_id = pdev->device;
-	pci_read_config_byte(pdev, PCI_REVISION_ID, &xgi_video_info.revision_id);
+	pci_read_config_byte(pdev,
+			     PCI_REVISION_ID,
+			     &xgi_video_info.revision_id);
 	XGIhw_ext.jChipRevision = xgi_video_info.revision_id;
 
 	xgi_video_info.pcibus = pdev->bus->number;
@@ -2194,7 +2281,7 @@ static int __devinit xgifb_probe(struct pci_dev *pdev,
 	XGIhw_ext.pjIOAddress = (unsigned char *)xgi_video_info.vga_base;
 	/* XGI_Pr.RelIO  = ioremap(pci_resource_start(pdev, 2), 128) + 0x30; */
 	printk("XGIfb: Relocate IO address: %lx [%08lx]\n",
-			(unsigned long)pci_resource_start(pdev, 2), XGI_Pr.RelIO);
+	       (unsigned long)pci_resource_start(pdev, 2), XGI_Pr.RelIO);
 
 	if (pci_enable_device(pdev)) {
 		ret = -EIO;
@@ -2264,17 +2351,23 @@ static int __devinit xgifb_probe(struct pci_dev *pdev,
 		goto error;
 	}
 
-	if ((xgifb_mode_idx < 0) || ((XGIbios_mode[xgifb_mode_idx].mode_no) != 0xFF)) {
+	if ((xgifb_mode_idx < 0) ||
+	    ((XGIbios_mode[xgifb_mode_idx].mode_no) != 0xFF)) {
 		/* Enable PCI_LINEAR_ADDRESSING and MMIO_ENABLE  */
-		orXGIIDXREG(XGISR, IND_XGI_PCI_ADDRESS_SET, (XGI_PCI_ADDR_ENABLE | XGI_MEM_MAP_IO_ENABLE));
+		orXGIIDXREG(XGISR,
+			    IND_XGI_PCI_ADDRESS_SET,
+			    (XGI_PCI_ADDR_ENABLE | XGI_MEM_MAP_IO_ENABLE));
 		/* Enable 2D accelerator engine */
 		orXGIIDXREG(XGISR, IND_XGI_MODULE_ENABLE, XGI_ENABLE_2D);
 	}
 
 	XGIhw_ext.ulVideoMemorySize = xgi_video_info.video_size;
 
-	if (!request_mem_region(xgi_video_info.video_base, xgi_video_info.video_size, "XGIfb FB")) {
-		printk("unable request memory size %x", xgi_video_info.video_size);
+	if (!request_mem_region(xgi_video_info.video_base,
+				xgi_video_info.video_size,
+				"XGIfb FB")) {
+		printk("unable request memory size %x",
+		       xgi_video_info.video_size);
 		printk(KERN_ERR "XGIfb: Fatal error: Unable to reserve frame buffer memory\n");
 		printk(KERN_ERR "XGIfb: Is there another framebuffer driver active?\n");
 		ret = -ENODEV;
@@ -2308,9 +2401,11 @@ static int __devinit xgifb_probe(struct pci_dev *pdev,
 
 	xgi_video_info.mtrr = (unsigned int) 0;
 
-	if ((xgifb_mode_idx < 0) || ((XGIbios_mode[xgifb_mode_idx].mode_no) != 0xFF)) {
+	if ((xgifb_mode_idx < 0) ||
+	    ((XGIbios_mode[xgifb_mode_idx].mode_no) != 0xFF)) {
 		xgi_video_info.hasVB = HASVB_NONE;
-		if ((xgi_video_info.chip == XG20) || (xgi_video_info.chip == XG27)) {
+		if ((xgi_video_info.chip == XG20) ||
+		    (xgi_video_info.chip == XG27)) {
 			xgi_video_info.hasVB = HASVB_NONE;
 		} else if (xgi_video_info.chip == XG21) {
 			inXGIIDXREG(XGICR, 0x38, CR38);
@@ -2318,10 +2413,22 @@ static int __devinit xgifb_probe(struct pci_dev *pdev,
 				xgi_video_info.disp_state = DISPTYPE_LCD;
 				if (!XGIfb_GetXG21LVDSData()) {
 					int m;
-					for (m = 0; m < sizeof(XGI21_LCDCapList)/sizeof(struct XGI21_LVDSCapStruct); m++) {
-						if ((XGI21_LCDCapList[m].LVDSHDE == XGIbios_mode[xgifb_mode_idx].xres) &&
-								(XGI21_LCDCapList[m].LVDSVDE == XGIbios_mode[xgifb_mode_idx].yres)) {
-							xgifb_reg_set(XGI_Pr.P3d4, 0x36, m);
+					for (m = 0;
+					     m < sizeof(XGI21_LCDCapList)/
+					     sizeof(struct XGI21_LVDSCapStruct);
+					     m++) {
+						if ((XGI21_LCDCapList[m].
+							LVDSHDE ==
+						    XGIbios_mode[
+							xgifb_mode_idx].xres) &&
+						    (XGI21_LCDCapList[m].
+							LVDSVDE ==
+						    XGIbios_mode[
+							xgifb_mode_idx].yres)) {
+							xgifb_reg_set(
+								XGI_Pr.P3d4,
+								0x36,
+								m);
 						}
 					}
 				}
@@ -2404,9 +2511,11 @@ static int __devinit xgifb_probe(struct pci_dev *pdev,
 			if (XGIfb_crt1off)
 				xgi_video_info.disp_state |= DISPMODE_SINGLE;
 			else
-				xgi_video_info.disp_state |= (DISPMODE_MIRROR | DISPTYPE_CRT1);
+				xgi_video_info.disp_state |= (DISPMODE_MIRROR |
+							      DISPTYPE_CRT1);
 		} else {
-			xgi_video_info.disp_state = DISPMODE_SINGLE | DISPTYPE_CRT1;
+			xgi_video_info.disp_state = DISPMODE_SINGLE |
+						    DISPTYPE_CRT1;
 		}
 
 		if (xgi_video_info.disp_state & DISPTYPE_LCD) {
@@ -2433,19 +2542,23 @@ static int __devinit xgifb_probe(struct pci_dev *pdev,
 			int tmp;
 			inXGIIDXREG(XGICR, 0x34, tmp);
 			if (tmp <= 0x13) {
-				/* Currently on LCDA? (Some BIOSes leave CR38) */
+				/* Currently on LCDA?
+				 * (Some BIOSes leave CR38) */
 				inXGIIDXREG(XGICR, 0x38, tmp);
 				if ((tmp & 0x03) == 0x03) {
 					/* XGI_Pr.XGI_UseLCDA = 1; */
 				} else {
-					/* Currently on LCDA? (Some newer BIOSes set D0 in CR35) */
+					/* Currently on LCDA?
+					 * (Some newer BIOSes set D0 in CR35) */
 					inXGIIDXREG(XGICR, 0x35, tmp);
 					if (tmp & 0x01) {
 						/* XGI_Pr.XGI_UseLCDA = 1; */
 					} else {
 						inXGIIDXREG(XGICR, 0x30, tmp);
 						if (tmp & 0x20) {
-							inXGIIDXREG(XGIPART1, 0x13, tmp);
+							inXGIIDXREG(XGIPART1,
+								    0x13,
+								    tmp);
 							if (tmp & 0x04) {
 								/* XGI_Pr.XGI_UseLCDA = 1; */
 							}
@@ -2464,7 +2577,8 @@ static int __devinit xgifb_probe(struct pci_dev *pdev,
 			case DISPTYPE_LCD:
 				xgifb_mode_idx = DEFAULT_LCDMODE;
 				if (xgi_video_info.chip == XG21)
-					xgifb_mode_idx = XGIfb_GetXG21DefaultLVDSModeIdx();
+					xgifb_mode_idx =
+					    XGIfb_GetXG21DefaultLVDSModeIdx();
 				break;
 			case DISPTYPE_TV:
 				xgifb_mode_idx = DEFAULT_TVMODE;
@@ -2478,17 +2592,25 @@ static int __devinit xgifb_probe(struct pci_dev *pdev,
 		XGIfb_mode_no = XGIbios_mode[xgifb_mode_idx].mode_no;
 
 		if (xgi_video_info.refresh_rate == 0)
-			xgi_video_info.refresh_rate = 60; /* yilin set default refresh rate */
-		if (XGIfb_search_refresh_rate(xgi_video_info.refresh_rate) == 0) {
+			/* yilin set default refresh rate */
+			xgi_video_info.refresh_rate = 60;
+		if (XGIfb_search_refresh_rate(xgi_video_info.refresh_rate) ==
+		    0) {
 			XGIfb_rate_idx = XGIbios_mode[xgifb_mode_idx].rate_idx;
 			xgi_video_info.refresh_rate = 60;
 		}
 
 		xgi_video_info.video_bpp = XGIbios_mode[xgifb_mode_idx].bpp;
-		xgi_video_info.video_vwidth = xgi_video_info.video_width = XGIbios_mode[xgifb_mode_idx].xres;
-		xgi_video_info.video_vheight = xgi_video_info.video_height = XGIbios_mode[xgifb_mode_idx].yres;
+		xgi_video_info.video_vwidth =
+			xgi_video_info.video_width =
+				XGIbios_mode[xgifb_mode_idx].xres;
+		xgi_video_info.video_vheight =
+			xgi_video_info.video_height =
+				XGIbios_mode[xgifb_mode_idx].yres;
 		xgi_video_info.org_x = xgi_video_info.org_y = 0;
-		xgi_video_info.video_linelength = xgi_video_info.video_width * (xgi_video_info.video_bpp >> 3);
+		xgi_video_info.video_linelength =
+			xgi_video_info.video_width *
+			(xgi_video_info.video_bpp >> 3);
 		switch (xgi_video_info.video_bpp) {
 		case 8:
 			xgi_video_info.DstColor = 0x0000;
@@ -2507,16 +2629,23 @@ static int __devinit xgifb_probe(struct pci_dev *pdev,
 			break;
 		default:
 			xgi_video_info.video_cmap_len = 16;
-			printk(KERN_INFO "XGIfb: Unsupported depth %d", xgi_video_info.video_bpp);
+			printk(KERN_INFO "XGIfb: Unsupported depth %d",
+			       xgi_video_info.video_bpp);
 			break;
 		}
 
 		printk(KERN_INFO "XGIfb: Default mode is %dx%dx%d (%dHz)\n",
-				xgi_video_info.video_width, xgi_video_info.video_height, xgi_video_info.video_bpp,
-				xgi_video_info.refresh_rate);
-
-		default_var.xres = default_var.xres_virtual = xgi_video_info.video_width;
-		default_var.yres = default_var.yres_virtual = xgi_video_info.video_height;
+		       xgi_video_info.video_width,
+		       xgi_video_info.video_height,
+		       xgi_video_info.video_bpp,
+		       xgi_video_info.refresh_rate);
+
+		default_var.xres =
+			default_var.xres_virtual =
+				xgi_video_info.video_width;
+		default_var.yres =
+			default_var.yres_virtual =
+				xgi_video_info.video_height;
 		default_var.bits_per_pixel = xgi_video_info.video_bpp;
 
 		XGIfb_bpp_to_var(&default_var);
@@ -2532,10 +2661,12 @@ static int __devinit xgifb_probe(struct pci_dev *pdev,
 			&default_var.hsync_len, &default_var.vsync_len,
 			&default_var.sync, &default_var.vmode)) {
 
-			if ((default_var.vmode & FB_VMODE_MASK) == FB_VMODE_INTERLACED) {
+			if ((default_var.vmode & FB_VMODE_MASK) ==
+			    FB_VMODE_INTERLACED) {
 				default_var.yres <<= 1;
 				default_var.yres_virtual <<= 1;
-			} else if ((default_var.vmode & FB_VMODE_MASK) == FB_VMODE_DOUBLE) {
+			} else if ((default_var.vmode & FB_VMODE_MASK) ==
+				   FB_VMODE_DOUBLE) {
 				default_var.pixclock >>= 1;
 				default_var.yres >>= 1;
 				default_var.yres_virtual >>= 1;
@@ -2555,9 +2686,10 @@ static int __devinit xgifb_probe(struct pci_dev *pdev,
 		fb_alloc_cmap(&fb_info->cmap, 256 , 0);
 
 #ifdef CONFIG_MTRR
-		xgi_video_info.mtrr = mtrr_add((unsigned int) xgi_video_info.video_base,
-				(unsigned int) xgi_video_info.video_size,
-				MTRR_TYPE_WRCOMB, 1);
+		xgi_video_info.mtrr =
+			mtrr_add((unsigned int) xgi_video_info.video_base,
+				 (unsigned int) xgi_video_info.video_size,
+				 MTRR_TYPE_WRCOMB, 1);
 		if (xgi_video_info.mtrr)
 			printk(KERN_INFO "XGIfb: Added MTRRs\n");
 #endif
@@ -2570,8 +2702,7 @@ static int __devinit xgifb_probe(struct pci_dev *pdev,
 		XGIfb_registered = 1;
 
 		printk(KERN_INFO "fb%d: %s frame buffer device, Version %d.%d.%02d\n",
-				fb_info->node, myid, VER_MAJOR, VER_MINOR, VER_LEVEL);
-
+		       fb_info->node, myid, VER_MAJOR, VER_MINOR, VER_LEVEL);
 	}
 
 	dumpVGAReg();
-- 
1.7.1

