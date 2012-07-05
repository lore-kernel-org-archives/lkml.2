Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933187Ab2GEOqk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 10:46:40 -0400
Received: from smtp3.mundo-r.com ([212.51.32.191]:57200 "EHLO
	smtp4.mundo-r.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933152Ab2GEOq0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 10:46:26 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Av4EANqn9U9bdWOb/2dsb2JhbABFhV+xR4EHghkBBSMECwFGECUCJgICVwcSiA+mepJWgSCPRYESA5U3kAOCYQ
X-IronPort-AV: E=Sophos;i="4.77,531,1336341600"; 
   d="scan'208";a="926562646"
From: =?UTF-8?q?Miguel=20G=C3=B3mez?= <magomez@igalia.com>
To: arnaud.patard@rtp-net.org, gregkh@linuxfoundation.org,
        aaro.koskinen@iki.fi, dan.carpenter@oracle.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        =?UTF-8?q?Miguel=20G=C3=B3mez?= <magomez@igalia.com>
Subject: [PATCH 05/19] Staging: xgifb: Improve debug strings.
Date: Thu,  5 Jul 2012 16:45:48 +0200
Message-Id: <8e9d31bda6a900ef71ba4a19014624939540455c.1341498465.git.magomez@igalia.com>
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

Signed-off-by: Miguel Gómez <magomez@igalia.com>
---
 drivers/staging/xgifb/XGI_main_26.c |   34 +++++++++++++++++-----------------
 drivers/staging/xgifb/vb_init.c     |    4 ++--
 2 files changed, 19 insertions(+), 19 deletions(-)

diff --git a/drivers/staging/xgifb/XGI_main_26.c b/drivers/staging/xgifb/XGI_main_26.c
index b3e8983..818e248 100644
--- a/drivers/staging/xgifb/XGI_main_26.c
+++ b/drivers/staging/xgifb/XGI_main_26.c
@@ -33,14 +33,14 @@ static void dumpVGAReg(void)
 
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
@@ -585,7 +585,7 @@ static u8 XGIfb_search_refresh_rate(struct xgifb_video_info *xgifb_info,
 				break;
 			} else if (XGIfb_vrate[i].refresh > rate) {
 				if ((XGIfb_vrate[i].refresh - rate) <= 3) {
-					pr_debug("XGIfb: Adjusting rate from %d up to %d\n",
+					pr_debug("Adjusting rate from %d up to %d\n",
 						 rate, XGIfb_vrate[i].refresh);
 					xgifb_info->rate_idx =
 						XGIfb_vrate[i].idx;
@@ -594,7 +594,7 @@ static u8 XGIfb_search_refresh_rate(struct xgifb_video_info *xgifb_info,
 				} else if (((rate - XGIfb_vrate[i - 1].refresh)
 						<= 2) && (XGIfb_vrate[i].idx
 						!= 1)) {
-					pr_debug("XGIfb: Adjusting rate from %d down to %d\n",
+					pr_debug("Adjusting rate from %d down to %d\n",
 						 rate, XGIfb_vrate[i-1].refresh);
 					xgifb_info->rate_idx =
 						XGIfb_vrate[i - 1].idx;
@@ -603,7 +603,7 @@ static u8 XGIfb_search_refresh_rate(struct xgifb_video_info *xgifb_info,
 				}
 				break;
 			} else if ((rate - XGIfb_vrate[i].refresh) <= 2) {
-				pr_debug("XGIfb: Adjusting rate from %d down to %d\n",
+				pr_debug("Adjusting rate from %d down to %d\n",
 					 rate, XGIfb_vrate[i].refresh);
 				xgifb_info->rate_idx = XGIfb_vrate[i].idx;
 				break;
@@ -977,7 +977,7 @@ static int XGIfb_do_set_var(struct fb_var_screeninfo *var, int isactive,
 	}
 
 	if (!htotal || !vtotal) {
-		pr_debug("XGIfb: Invalid 'var' information\n");
+		pr_debug("Invalid 'var' information\n");
 		return -EINVAL;
 	} pr_debug("var->pixclock=%d, htotal=%d, vtotal=%d\n",
 			var->pixclock, htotal, vtotal);
@@ -1053,7 +1053,7 @@ static int XGIfb_do_set_var(struct fb_var_screeninfo *var, int isactive,
 
 		XGIfb_post_setmode(xgifb_info);
 
-		pr_debug("XGIfb: Set new mode: %dx%dx%d-%d\n",
+		pr_debug("Set new mode: %dx%dx%d-%d\n",
 			 XGIbios_mode[xgifb_info->mode_idx].xres,
 			 XGIbios_mode[xgifb_info->mode_idx].yres,
 			 XGIbios_mode[xgifb_info->mode_idx].bpp,
@@ -1099,7 +1099,7 @@ static int XGIfb_do_set_var(struct fb_var_screeninfo *var, int isactive,
 			break;
 		default:
 			xgifb_info->video_cmap_len = 16;
-			pr_err("Unsupported depth %d",
+			pr_err("Unsupported depth %d\n",
 			       xgifb_info->video_bpp);
 			break;
 		}
@@ -1293,7 +1293,7 @@ static int XGIfb_check_var(struct fb_var_screeninfo *var, struct fb_info *info)
 				+ var->vsync_len;
 
 	if (!(htotal) || !(vtotal)) {
-		pr_debug("XGIfb: no valid timing data\n");
+		pr_debug("No valid timing data\n");
 		return -EINVAL;
 	}
 
@@ -1651,7 +1651,7 @@ static int __init xgifb_optval(char *fullopt, int validx)
 	unsigned long lres;
 
 	if (kstrtoul(fullopt + validx, 0, &lres) < 0 || lres > INT_MAX) {
-		pr_err("xgifb: invalid value for option: %s\n", fullopt);
+		pr_err("Invalid value for option: %s\n", fullopt);
 		return 0;
 	}
 	return lres;
@@ -1664,7 +1664,7 @@ static int __init XGIfb_setup(char *options)
 	if (!options || !*options)
 		return 0;
 
-	pr_info("xgifb: options: %s\n", options);
+	pr_info("Options: %s\n", options);
 
 	while ((this_opt = strsep(&options, ",")) != NULL) {
 
@@ -1757,7 +1757,7 @@ static int __devinit xgifb_probe(struct pci_dev *pdev,
 	reg1 = xgifb_reg_get(XGISR, IND_SIS_PASSWORD);
 
 	if (reg1 != 0xa1) { /*I/O error */
-		dev_err(&pdev->dev, "I/O error!!!");
+		dev_err(&pdev->dev, "I/O error!!!\n");
 		ret = -EIO;
 		goto error_disable;
 	}
@@ -1807,7 +1807,7 @@ static int __devinit xgifb_probe(struct pci_dev *pdev,
 	if (!request_mem_region(xgifb_info->video_base,
 				xgifb_info->video_size,
 				"XGIfb FB")) {
-		dev_err(&pdev->dev, "unable request memory size %x\n",
+		dev_err(&pdev->dev, "Unable request memory size %x\n",
 		       xgifb_info->video_size);
 		dev_err(&pdev->dev,
 			"Fatal error: Unable to reserve frame buffer memory. "
@@ -1963,7 +1963,7 @@ static int __devinit xgifb_probe(struct pci_dev *pdev,
 	}
 
 	if (xgifb_info->mode_idx < 0) {
-		dev_err(&pdev->dev, "no supported video mode found\n");
+		dev_err(&pdev->dev, "No supported video mode found\n");
 		goto error_1;
 	}
 
@@ -2075,7 +2075,7 @@ static int __devinit xgifb_probe(struct pci_dev *pdev,
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

