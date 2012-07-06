Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030190Ab2GFKpm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 06:45:42 -0400
Received: from smtp3.mundo-r.com ([212.51.32.191]:58350 "EHLO
	smtp4.mundo-r.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933157Ab2GFKlZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 06:41:25 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Av4EAHC/9k9bdWOb/2dsb2JhbABFhWSxVIEHghkBBSMECwFGECUCJgICVwcSiA+nOZMDgSCPLYESA5U3kAOCYQ
X-IronPort-AV: E=Sophos;i="4.77,537,1336341600"; 
   d="scan'208";a="940130681"
From: =?UTF-8?q?Miguel=20G=C3=B3mez?= <magomez@igalia.com>
To: arnaud.patard@rtp-net.org, gregkh@linuxfoundation.org,
        aaro.koskinen@iki.fi, dan.carpenter@oracle.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        =?UTF-8?q?Miguel=20G=C3=B3mez?= <magomez@igalia.com>
Subject: [PATCH 05/19 v2] Staging: xgifb: Improve debug strings.
Date: Fri,  6 Jul 2012 12:40:40 +0200
Message-Id: <a5d640e3a43fe361b7485bac3d96dbd99fb5fd08.1341569486.git.magomez@igalia.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <cover.1341569486.git.magomez@igalia.com>
References: <cover.1341498465.git.magomez@igalia.com>
 <cover.1341569486.git.magomez@igalia.com>
In-Reply-To: <cover.1341569486.git.magomez@igalia.com>
References: <cover.1341569486.git.magomez@igalia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Miguel Gómez <magomez@igalia.com>
---
 drivers/staging/xgifb/XGI_main_26.c |   34 +++++++++++++++++-----------------
 drivers/staging/xgifb/vb_init.c     |    4 ++--
 2 files changed, 19 insertions(+), 19 deletions(-)

diff --git a/drivers/staging/xgifb/XGI_main_26.c b/drivers/staging/xgifb/XGI_main_26.c
index 0307eca..d5c87ea 100644
--- a/drivers/staging/xgifb/XGI_main_26.c
+++ b/drivers/staging/xgifb/XGI_main_26.c
@@ -39,14 +39,14 @@ static void dumpVGAReg(void)
 
 	for (i = 0; i < 0x4f; i++) {
 		reg = xgifb_reg_get(XGISR, i);
-		pr_debug("\no 3c4 %x", i);
-		pr_debug("\ni 3c5 => %x", reg);
+		pr_debug("o 3c4 %x\n", i);
+		pr_debug("i 3c5 => %x\n", reg);
 	}
 
 	for (i = 0; i < 0xF0; i++) {
 		reg = xgifb_reg_get(XGICR, i);
-		pr_debug("\no 3d4 %x", i);
-		pr_debug("\ni 3d5 => %x", reg);
+		pr_debug("o 3d4 %x\n", i);
+		pr_debug("i 3d5 => %x\n", reg);
 	}
 }
 #else
@@ -591,7 +591,7 @@ static u8 XGIfb_search_refresh_rate(struct xgifb_video_info *xgifb_info,
 				break;
 			} else if (XGIfb_vrate[i].refresh > rate) {
 				if ((XGIfb_vrate[i].refresh - rate) <= 3) {
-					pr_debug("XGIfb: Adjusting rate from %d up to %d\n",
+					pr_debug("Adjusting rate from %d up to %d\n",
 						 rate, XGIfb_vrate[i].refresh);
 					xgifb_info->rate_idx =
 						XGIfb_vrate[i].idx;
@@ -600,7 +600,7 @@ static u8 XGIfb_search_refresh_rate(struct xgifb_video_info *xgifb_info,
 				} else if (((rate - XGIfb_vrate[i - 1].refresh)
 						<= 2) && (XGIfb_vrate[i].idx
 						!= 1)) {
-					pr_debug("XGIfb: Adjusting rate from %d down to %d\n",
+					pr_debug("Adjusting rate from %d down to %d\n",
 						 rate, XGIfb_vrate[i-1].refresh);
 					xgifb_info->rate_idx =
 						XGIfb_vrate[i - 1].idx;
@@ -609,7 +609,7 @@ static u8 XGIfb_search_refresh_rate(struct xgifb_video_info *xgifb_info,
 				}
 				break;
 			} else if ((rate - XGIfb_vrate[i].refresh) <= 2) {
-				pr_debug("XGIfb: Adjusting rate from %d down to %d\n",
+				pr_debug("Adjusting rate from %d down to %d\n",
 					 rate, XGIfb_vrate[i].refresh);
 				xgifb_info->rate_idx = XGIfb_vrate[i].idx;
 				break;
@@ -987,7 +987,7 @@ static int XGIfb_do_set_var(struct fb_var_screeninfo *var, int isactive,
 	}
 
 	if (!htotal || !vtotal) {
-		pr_debug("XGIfb: Invalid 'var' information\n");
+		pr_debug("Invalid 'var' information\n");
 		return -EINVAL;
 	} pr_debug("var->pixclock=%d, htotal=%d, vtotal=%d\n",
 			var->pixclock, htotal, vtotal);
@@ -1063,7 +1063,7 @@ static int XGIfb_do_set_var(struct fb_var_screeninfo *var, int isactive,
 
 		XGIfb_post_setmode(xgifb_info);
 
-		pr_debug("XGIfb: Set new mode: %dx%dx%d-%d\n",
+		pr_debug("Set new mode: %dx%dx%d-%d\n",
 			 XGIbios_mode[xgifb_info->mode_idx].xres,
 			 XGIbios_mode[xgifb_info->mode_idx].yres,
 			 XGIbios_mode[xgifb_info->mode_idx].bpp,
@@ -1109,7 +1109,7 @@ static int XGIfb_do_set_var(struct fb_var_screeninfo *var, int isactive,
 			break;
 		default:
 			xgifb_info->video_cmap_len = 16;
-			pr_err("Unsupported depth %d",
+			pr_err("Unsupported depth %d\n",
 			       xgifb_info->video_bpp);
 			break;
 		}
@@ -1303,7 +1303,7 @@ static int XGIfb_check_var(struct fb_var_screeninfo *var, struct fb_info *info)
 				+ var->vsync_len;
 
 	if (!(htotal) || !(vtotal)) {
-		pr_debug("XGIfb: no valid timing data\n");
+		pr_debug("No valid timing data\n");
 		return -EINVAL;
 	}
 
@@ -1661,7 +1661,7 @@ static int __init xgifb_optval(char *fullopt, int validx)
 	unsigned long lres;
 
 	if (kstrtoul(fullopt + validx, 0, &lres) < 0 || lres > INT_MAX) {
-		pr_err("xgifb: invalid value for option: %s\n", fullopt);
+		pr_err("Invalid value for option: %s\n", fullopt);
 		return 0;
 	}
 	return lres;
@@ -1674,7 +1674,7 @@ static int __init XGIfb_setup(char *options)
 	if (!options || !*options)
 		return 0;
 
-	pr_info("xgifb: options: %s\n", options);
+	pr_info("Options: %s\n", options);
 
 	while ((this_opt = strsep(&options, ",")) != NULL) {
 
@@ -1767,7 +1767,7 @@ static int __devinit xgifb_probe(struct pci_dev *pdev,
 	reg1 = xgifb_reg_get(XGISR, IND_SIS_PASSWORD);
 
 	if (reg1 != 0xa1) { /*I/O error */
-		dev_err(&pdev->dev, "I/O error!!!");
+		dev_err(&pdev->dev, "I/O error\n");
 		ret = -EIO;
 		goto error_disable;
 	}
@@ -1817,7 +1817,7 @@ static int __devinit xgifb_probe(struct pci_dev *pdev,
 	if (!request_mem_region(xgifb_info->video_base,
 				xgifb_info->video_size,
 				"XGIfb FB")) {
-		dev_err(&pdev->dev, "unable request memory size %x\n",
+		dev_err(&pdev->dev, "Unable request memory size %x\n",
 		       xgifb_info->video_size);
 		dev_err(&pdev->dev,
 			"Fatal error: Unable to reserve frame buffer memory. "
@@ -1973,7 +1973,7 @@ static int __devinit xgifb_probe(struct pci_dev *pdev,
 	}
 
 	if (xgifb_info->mode_idx < 0) {
-		dev_err(&pdev->dev, "no supported video mode found\n");
+		dev_err(&pdev->dev, "No supported video mode found\n");
 		goto error_1;
 	}
 
@@ -2085,7 +2085,7 @@ static int __devinit xgifb_probe(struct pci_dev *pdev,
 	xgifb_info->mtrr = mtrr_add(xgifb_info->video_base,
 		xgifb_info->video_size, MTRR_TYPE_WRCOMB, 1);
 	if (xgifb_info->mtrr >= 0)
-		dev_info(&pdev->dev, "added MTRR\n");
+		dev_info(&pdev->dev, "Added MTRR\n");
 #endif
 
 	if (register_framebuffer(fb_info) < 0) {
diff --git a/drivers/staging/xgifb/vb_init.c b/drivers/staging/xgifb/vb_init.c
index 6bb0206..64935fa 100644
--- a/drivers/staging/xgifb/vb_init.c
+++ b/drivers/staging/xgifb/vb_init.c
@@ -951,7 +951,7 @@ static void xgifb_read_vbios(struct pci_dev *pdev,
 	pVBInfo->IF_DEF_LVDS = 0;
 	vbios = xgifb_copy_rom(pdev, &vbios_size);
 	if (vbios == NULL) {
-		dev_err(&pdev->dev, "video BIOS not available\n");
+		dev_err(&pdev->dev, "Video BIOS not available\n");
 		return;
 	}
 	if (vbios_size <= 0x65)
@@ -1006,7 +1006,7 @@ static void xgifb_read_vbios(struct pci_dev *pdev,
 	pVBInfo->IF_DEF_LVDS = 1;
 	return;
 error:
-	dev_err(&pdev->dev, "video BIOS corrupted\n");
+	dev_err(&pdev->dev, "Video BIOS corrupted\n");
 	vfree(vbios);
 }
 
-- 
1.7.9.5

