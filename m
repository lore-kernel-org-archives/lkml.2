Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756634Ab1HSTla (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Aug 2011 15:41:30 -0400
Received: from filtteri1.pp.htv.fi ([213.243.153.184]:60205 "EHLO
	filtteri1.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756126Ab1HSTkc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Aug 2011 15:40:32 -0400
From: Aaro Koskinen <aaro.koskinen@iki.fi>
To: apatard@mandriva.com, gregkh@suse.de, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 10/12] staging: xgifb: delete write-only variables
Date: Fri, 19 Aug 2011 22:40:28 +0300
Message-Id: <1313782830-31461-11-git-send-email-aaro.koskinen@iki.fi>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1313782830-31461-1-git-send-email-aaro.koskinen@iki.fi>
References: <1313782830-31461-1-git-send-email-aaro.koskinen@iki.fi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Delete couple write-only variables.

Signed-off-by: Aaro Koskinen <aaro.koskinen@iki.fi>
---
 drivers/staging/xgifb/XGI_main.h    |    8 --------
 drivers/staging/xgifb/XGI_main_26.c |   10 ----------
 2 files changed, 0 insertions(+), 18 deletions(-)

diff --git a/drivers/staging/xgifb/XGI_main.h b/drivers/staging/xgifb/XGI_main.h
index 2f82488..168f25c 100644
--- a/drivers/staging/xgifb/XGI_main.h
+++ b/drivers/staging/xgifb/XGI_main.h
@@ -179,7 +179,6 @@ static int XGIfb_userom = 0;
 /*static int XGIfb_useoem = -1; */
 
 /* global flags */
-static int XGIfb_registered;
 static int XGIfb_tvmode = 0;
 static int XGIfb_pdc = 0;
 static int enable_dstn = 0;
@@ -193,13 +192,6 @@ static int XGIfb_crt2type = -1;
 /* PR: Tv plug type (for overriding autodetection) */
 static int XGIfb_tvplug = -1;
 
-static unsigned char XGIfb_detectedpdc = 0;
-
-static unsigned char XGIfb_detectedlcda = 0xff;
-
-
-
-
 /* TW: For ioctl XGIFB_GET_INFO */
 /* XGIfb_info XGIfbinfo; */
 
diff --git a/drivers/staging/xgifb/XGI_main_26.c b/drivers/staging/xgifb/XGI_main_26.c
index 7d06c05..ebd63ad 100644
--- a/drivers/staging/xgifb/XGI_main_26.c
+++ b/drivers/staging/xgifb/XGI_main_26.c
@@ -2046,8 +2046,6 @@ static int __devinit xgifb_probe(struct pci_dev *pdev,
 	if (XGIfb_off)
 		return -ENXIO;
 
-	XGIfb_registered = 0;
-
 	memset(&XGIhw_ext, 0, sizeof(struct xgi_hw_device_info));
 	fb_info = framebuffer_alloc(sizeof(struct fb_info), &pdev->dev);
 	if (!fb_info)
@@ -2307,12 +2305,6 @@ static int __devinit xgifb_probe(struct pci_dev *pdev,
 		}
 	}
 
-	XGIfb_detectedpdc = 0;
-
-	XGIfb_detectedlcda = 0xff;
-
-	/* TW: Try to find about LCDA */
-
 	if ((XGIhw_ext.ujVBChipID == VB_CHIP_302B) ||
 			(XGIhw_ext.ujVBChipID == VB_CHIP_301LV) ||
 			(XGIhw_ext.ujVBChipID == VB_CHIP_302LV)) {
@@ -2476,8 +2468,6 @@ static int __devinit xgifb_probe(struct pci_dev *pdev,
 		goto error_1;
 	}
 
-	XGIfb_registered = 1;
-
 	printk(KERN_INFO "fb%d: %s frame buffer device, Version %d.%d.%02d\n",
 	       fb_info->node, myid, VER_MAJOR, VER_MINOR, VER_LEVEL);
 
-- 
1.7.2.5

