Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752649Ab2AWAtt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jan 2012 19:49:49 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:47038 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752593Ab2AWAtI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jan 2012 19:49:08 -0500
From: Sam Hansen <solid.se7en@gmail.com>
To: Arnaud Patard <arnaud.patard@rtp-net.org>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Aaro Koskinen <aaro.koskinen@iki.fi>,
        Dan Carpenter <dan.carpenter@oracle.com>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Sam Hansen <solid.se7en@gmail.com>
Subject: [PATCH V2 3/3] xgifb: checkpatch cleanup printk() -> pr_lvl()
Date: Sun, 22 Jan 2012 16:48:53 -0800
Message-Id: <1327279733-3350-4-git-send-email-solid.se7en@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1327279733-3350-1-git-send-email-solid.se7en@gmail.com>
References: <1327279733-3350-1-git-send-email-solid.se7en@gmail.com>
In-Reply-To: <originalemailid>
References: <originalemailid>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rewrote code to use pr_lvl() instead of printk().  There are still a few
instances of printk(), mainly in the debug code which looks like it's going to
be dropped/rewrote (most of it is blocked out).

Signed-off-by: Sam Hansen <solid.se7en@gmail.com>
---
 drivers/staging/xgifb/XGI_main_26.c |   88 +++++++++++++++++------------------
 1 files changed, 43 insertions(+), 45 deletions(-)

diff --git a/drivers/staging/xgifb/XGI_main_26.c b/drivers/staging/xgifb/XGI_main_26.c
index a743e1b..13686d1 100644
--- a/drivers/staging/xgifb/XGI_main_26.c
+++ b/drivers/staging/xgifb/XGI_main_26.c
@@ -55,7 +55,7 @@ static unsigned int refresh_rate;
 #undef XGIFBDEBUG
 
 #ifdef XGIFBDEBUG
-#define DPRINTK(fmt, args...) printk(KERN_DEBUG "%s: " fmt, __func__ , ## args)
+#define DPRINTK(fmt, args...) pr_debug("%s: " fmt, __func__ , ## args)
 #else
 #define DPRINTK(fmt, args...)
 #endif
@@ -142,7 +142,7 @@ static inline void dumpVGAReg(void)
 #if 1
 #define DEBUGPRN(x)
 #else
-#define DEBUGPRN(x) printk(KERN_INFO x "\n");
+#define DEBUGPRN(x) pr_info(x "\n");
 #endif
 
 /* --------------- Hardware Access Routines -------------------------- */
@@ -424,7 +424,7 @@ static void XGIfb_search_mode(struct xgifb_video_info *xgifb_info,
 		i++;
 	}
 	if (!j)
-		printk(KERN_INFO "XGIfb: Invalid mode '%s'\n", name);
+		pr_info("Invalid mode '%s'\n", name);
 }
 
 static void XGIfb_search_vesamode(struct xgifb_video_info *xgifb_info,
@@ -449,7 +449,7 @@ static void XGIfb_search_vesamode(struct xgifb_video_info *xgifb_info,
 
 invalid:
 	if (!j)
-		printk(KERN_INFO "XGIfb: Invalid VESA mode 0x%x'\n", vesamode);
+		pr_info("Invalid VESA mode 0x%x'\n", vesamode);
 }
 
 static int XGIfb_validate_mode(struct xgifb_video_info *xgifb_info, int myindex)
@@ -692,7 +692,7 @@ static void XGIfb_search_crt2type(const char *name)
 		i++;
 	}
 	if (XGIfb_crt2type < 0)
-		printk(KERN_INFO "XGIfb: Invalid CRT2 type: %s\n", name);
+		pr_info("Invalid CRT2 type: %s\n", name);
 }
 
 static u8 XGIfb_search_refresh_rate(struct xgifb_video_info *xgifb_info,
@@ -742,7 +742,7 @@ static u8 XGIfb_search_refresh_rate(struct xgifb_video_info *xgifb_info,
 	if (xgifb_info->rate_idx > 0) {
 		return xgifb_info->rate_idx;
 	} else {
-		printk(KERN_INFO "XGIfb: Unsupported rate %d for %dx%d\n",
+		pr_info("Unsupported rate %d for %dx%d\n",
 		       rate, xres, yres);
 		return 0;
 	}
@@ -1118,7 +1118,7 @@ static int XGIfb_do_set_var(struct fb_var_screeninfo *var, int isactive,
 	if (!htotal || !vtotal) {
 		DPRINTK("XGIfb: Invalid 'var' information\n");
 		return -EINVAL;
-	} printk(KERN_DEBUG "XGIfb: var->pixclock=%d, htotal=%d, vtotal=%d\n",
+	} pr_debug("var->pixclock=%d, htotal=%d, vtotal=%d\n",
 			var->pixclock, htotal, vtotal);
 
 	if (var->pixclock && htotal && vtotal) {
@@ -1130,7 +1130,7 @@ static int XGIfb_do_set_var(struct fb_var_screeninfo *var, int isactive,
 		xgifb_info->refresh_rate = 60;
 	}
 
-	printk(KERN_DEBUG "XGIfb: Change mode to %dx%dx%d-%dHz\n",
+	pr_debug("Change mode to %dx%dx%d-%dHz\n",
 	       var->xres,
 	       var->yres,
 	       var->bits_per_pixel,
@@ -1158,7 +1158,7 @@ static int XGIfb_do_set_var(struct fb_var_screeninfo *var, int isactive,
 		xgifb_info->mode_idx = -1;
 
 	if (xgifb_info->mode_idx < 0) {
-		printk(KERN_ERR "XGIfb: Mode %dx%dx%d not supported\n",
+		pr_err("Mode %dx%dx%d not supported\n",
 		       var->xres, var->yres, var->bits_per_pixel);
 		xgifb_info->mode_idx = old_mode;
 		return -EINVAL;
@@ -1177,7 +1177,7 @@ static int XGIfb_do_set_var(struct fb_var_screeninfo *var, int isactive,
 		if (XGISetModeNew(xgifb_info, hw_info,
 				  XGIbios_mode[xgifb_info->mode_idx].mode_no)
 					== 0) {
-			printk(KERN_ERR "XGIfb: Setting mode[0x%x] failed\n",
+			pr_err("Setting mode[0x%x] failed\n",
 			       XGIbios_mode[xgifb_info->mode_idx].mode_no);
 			return -EINVAL;
 		}
@@ -1239,7 +1239,7 @@ static int XGIfb_do_set_var(struct fb_var_screeninfo *var, int isactive,
 			break;
 		default:
 			xgifb_info->video_cmap_len = 16;
-			printk(KERN_ERR "XGIfb: Unsupported depth %d",
+			pr_err("Unsupported depth %d",
 			       xgifb_info->video_bpp);
 			break;
 		}
@@ -1441,7 +1441,7 @@ static int XGIfb_check_var(struct fb_var_screeninfo *var, struct fb_info *info)
 		hrate = (drate * 1000) / htotal;
 		xgifb_info->refresh_rate =
 			(unsigned int) (hrate * 2 / vtotal);
-		printk(KERN_DEBUG
+		pr_debug(
 			"%s: pixclock = %d ,htotal=%d, vtotal=%d\n"
 			"%s: drate=%d, hrate=%d, refresh_rate=%d\n",
 			__func__, var->pixclock, htotal, vtotal,
@@ -1479,7 +1479,7 @@ static int XGIfb_check_var(struct fb_var_screeninfo *var, struct fb_info *info)
 
 	if (!found_mode) {
 
-		printk(KERN_ERR "XGIfb: %dx%dx%d is no valid mode\n",
+		pr_err("%dx%dx%d is no valid mode\n",
 			var->xres, var->yres, var->bits_per_pixel);
 		search_idx = 0;
 		while (XGIbios_mode[search_idx].mode_no != 0) {
@@ -1498,11 +1498,11 @@ static int XGIfb_check_var(struct fb_var_screeninfo *var, struct fb_info *info)
 		if (found_mode) {
 			var->xres = XGIbios_mode[search_idx].xres;
 			var->yres = XGIbios_mode[search_idx].yres;
-			printk(KERN_DEBUG "XGIfb: Adapted to mode %dx%dx%d\n",
+			pr_debug("Adapted to mode %dx%dx%d\n",
 				var->xres, var->yres, var->bits_per_pixel);
 
 		} else {
-			printk(KERN_ERR "XGIfb: Failed to find similar mode to %dx%dx%d\n",
+			pr_err("Failed to find similar mode to %dx%dx%d\n",
 				var->xres, var->yres, var->bits_per_pixel);
 			return -EINVAL;
 		}
@@ -1711,7 +1711,7 @@ static int XGIfb_get_dram_size(struct xgifb_video_info *xgifb_info)
 	/* xgifb_info->video_size = 0x200000; */ /* 1024x768x16 */
 	/* xgifb_info->video_size = 0x1000000; */ /* benchmark */
 
-	printk("XGIfb: SR14=%x DramSzie %x ChannelNum %x\n",
+	pr_info("SR14=%x DramSzie %x ChannelNum %x\n",
 	       reg,
 	       xgifb_info->video_size, ChannelNum);
 	return 0;
@@ -1917,7 +1917,7 @@ static int __devinit xgifb_probe(struct pci_dev *pdev,
 	xgifb_info->vga_base = pci_resource_start(pdev, 2) + 0x30;
 	hw_info->pjIOAddress = (unsigned char *)xgifb_info->vga_base;
 	/* XGI_Pr.RelIO  = ioremap(pci_resource_start(pdev, 2), 128) + 0x30; */
-	printk("XGIfb: Relocate IO address: %lx [%08lx]\n",
+	pr_info("Relocate IO address: %lx [%08lx]\n",
 	       (unsigned long)pci_resource_start(pdev, 2),
 	       xgifb_info->dev_info.RelIO);
 
@@ -1937,7 +1937,7 @@ static int __devinit xgifb_probe(struct pci_dev *pdev,
 	reg1 = xgifb_reg_get(XGISR, IND_XGI_PASSWORD);
 
 	if (reg1 != 0xa1) { /*I/O error */
-		printk("\nXGIfb: I/O error!!!");
+		pr_err("I/O error!!!");
 		ret = -EIO;
 		goto error;
 	}
@@ -1968,11 +1968,11 @@ static int __devinit xgifb_probe(struct pci_dev *pdev,
 		goto error;
 	}
 
-	printk("XGIfb:chipid = %x\n", xgifb_info->chip);
+	pr_info("chipid = %x\n", xgifb_info->chip);
 	hw_info->jChipType = xgifb_info->chip;
 
 	if (XGIfb_get_dram_size(xgifb_info)) {
-		printk(KERN_INFO "XGIfb: Fatal error: Unable to determine RAM size.\n");
+		pr_err("Fatal error: Unable to determine RAM size.\n");
 		ret = -ENODEV;
 		goto error;
 	}
@@ -1989,10 +1989,10 @@ static int __devinit xgifb_probe(struct pci_dev *pdev,
 	if (!request_mem_region(xgifb_info->video_base,
 				xgifb_info->video_size,
 				"XGIfb FB")) {
-		printk("unable request memory size %x",
+		pr_err("unable request memory size %x\n",
 		       xgifb_info->video_size);
-		printk(KERN_ERR "XGIfb: Fatal error: Unable to reserve frame buffer memory\n");
-		printk(KERN_ERR "XGIfb: Is there another framebuffer driver active?\n");
+		pr_err("Fatal error: Unable to reserve frame buffer memory\n");
+		pr_err("Is there another framebuffer driver active?\n");
 		ret = -ENODEV;
 		goto error;
 	}
@@ -2000,7 +2000,7 @@ static int __devinit xgifb_probe(struct pci_dev *pdev,
 	if (!request_mem_region(xgifb_info->mmio_base,
 				xgifb_info->mmio_size,
 				"XGIfb MMIO")) {
-		printk(KERN_ERR "XGIfb: Fatal error: Unable to reserve MMIO region\n");
+		pr_err("Fatal error: Unable to reserve MMIO region\n");
 		ret = -ENODEV;
 		goto error_0;
 	}
@@ -2010,20 +2010,18 @@ static int __devinit xgifb_probe(struct pci_dev *pdev,
 	xgifb_info->mmio_vbase = ioremap(xgifb_info->mmio_base,
 					    xgifb_info->mmio_size);
 
-	printk(KERN_INFO "XGIfb: Framebuffer at 0x%lx, mapped to 0x%p, size %dk\n",
+	pr_info("Framebuffer at 0x%lx, mapped to 0x%p, size %dk\n",
 	       xgifb_info->video_base,
 	       xgifb_info->video_vbase,
 	       xgifb_info->video_size / 1024);
 
-	printk(KERN_INFO "XGIfb: MMIO at 0x%lx, mapped to 0x%p, size %ldk\n",
+	pr_info("MMIO at 0x%lx, mapped to 0x%p, size %ldk\n",
 	       xgifb_info->mmio_base, xgifb_info->mmio_vbase,
 	       xgifb_info->mmio_size / 1024);
-	printk("XGIfb: XGIInitNew() ...");
+
 	pci_set_drvdata(pdev, xgifb_info);
-	if (XGIInitNew(pdev))
-		printk("OK\n");
-	else
-		printk("Fail\n");
+	if (!XGIInitNew(pdev))
+		pr_err("XGIInitNew() failed!\n");
 
 	xgifb_info->mtrr = (unsigned int) 0;
 
@@ -2052,10 +2050,10 @@ static int __devinit xgifb_probe(struct pci_dev *pdev,
 		reg = xgifb_reg_get(XGIPART4, 0x01);
 		if (reg >= 0xE0) {
 			hw_info->ujVBChipID = VB_CHIP_302LV;
-			printk(KERN_INFO "XGIfb: XGI302LV bridge detected (revision 0x%02x)\n", reg);
+			pr_info("XGI302LV bridge detected (revision 0x%02x)\n", reg);
 		} else if (reg >= 0xD0) {
 			hw_info->ujVBChipID = VB_CHIP_301LV;
-			printk(KERN_INFO "XGIfb: XGI301LV bridge detected (revision 0x%02x)\n", reg);
+			pr_info("XGI301LV bridge detected (revision 0x%02x)\n", reg);
 		}
 		/* else if (reg >= 0xB0) {
 			hw_info->ujVBChipID = VB_CHIP_301B;
@@ -2064,17 +2062,17 @@ static int __devinit xgifb_probe(struct pci_dev *pdev,
 		} */
 		else {
 			hw_info->ujVBChipID = VB_CHIP_301;
-			printk("XGIfb: XGI301 bridge detected\n");
+			pr_info("XGI301 bridge detected\n");
 		}
 		break;
 	case HASVB_302:
 		reg = xgifb_reg_get(XGIPART4, 0x01);
 		if (reg >= 0xE0) {
 			hw_info->ujVBChipID = VB_CHIP_302LV;
-			printk(KERN_INFO "XGIfb: XGI302LV bridge detected (revision 0x%02x)\n", reg);
+			pr_info("XGI302LV bridge detected (revision 0x%02x)\n", reg);
 		} else if (reg >= 0xD0) {
 			hw_info->ujVBChipID = VB_CHIP_301LV;
-			printk(KERN_INFO "XGIfb: XGI302LV bridge detected (revision 0x%02x)\n", reg);
+			pr_info("XGI302LV bridge detected (revision 0x%02x)\n", reg);
 		} else if (reg >= 0xB0) {
 			reg1 = xgifb_reg_get(XGIPART4, 0x23);
 
@@ -2082,27 +2080,27 @@ static int __devinit xgifb_probe(struct pci_dev *pdev,
 
 		} else {
 			hw_info->ujVBChipID = VB_CHIP_302;
-			printk(KERN_INFO "XGIfb: XGI302 bridge detected\n");
+			pr_info("XGI302 bridge detected\n");
 		}
 		break;
 	case HASVB_LVDS:
 		hw_info->ulExternalChip = 0x1;
-		printk(KERN_INFO "XGIfb: LVDS transmitter detected\n");
+		pr_info("LVDS transmitter detected\n");
 		break;
 	case HASVB_TRUMPION:
 		hw_info->ulExternalChip = 0x2;
-		printk(KERN_INFO "XGIfb: Trumpion Zurac LVDS scaler detected\n");
+		pr_info("Trumpion Zurac LVDS scaler detected\n");
 		break;
 	case HASVB_CHRONTEL:
 		hw_info->ulExternalChip = 0x4;
-		printk(KERN_INFO "XGIfb: Chrontel TV encoder detected\n");
+		pr_info("Chrontel TV encoder detected\n");
 		break;
 	case HASVB_LVDS_CHRONTEL:
 		hw_info->ulExternalChip = 0x5;
-		printk(KERN_INFO "XGIfb: LVDS transmitter and Chrontel TV encoder detected\n");
+		pr_info("LVDS transmitter and Chrontel TV encoder detected\n");
 		break;
 	default:
-		printk(KERN_INFO "XGIfb: No or unknown bridge type detected\n");
+		pr_info("No or unknown bridge type detected\n");
 		break;
 	}
 
@@ -2218,12 +2216,12 @@ static int __devinit xgifb_probe(struct pci_dev *pdev,
 		break;
 	default:
 		xgifb_info->video_cmap_len = 16;
-		printk(KERN_INFO "XGIfb: Unsupported depth %d",
+		pr_info("Unsupported depth %d\n",
 		       xgifb_info->video_bpp);
 		break;
 	}
 
-	printk(KERN_INFO "XGIfb: Default mode is %dx%dx%d (%dHz)\n",
+	pr_info("Default mode is %dx%dx%d (%dHz)\n",
 	       xgifb_info->video_width,
 	       xgifb_info->video_height,
 	       xgifb_info->video_bpp,
@@ -2400,7 +2398,7 @@ MODULE_PARM_DESC(filter,
 static void __exit xgifb_remove_module(void)
 {
 	pci_unregister_driver(&xgifb_driver);
-	printk(KERN_DEBUG "xgifb: Module unloaded\n");
+	pr_debug("Module unloaded\n");
 }
 
 module_exit(xgifb_remove_module);
-- 
1.7.5.4

