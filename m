Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752844Ab1BUWOV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Feb 2011 17:14:21 -0500
Received: from filtteri6.pp.htv.fi ([213.243.153.189]:32917 "EHLO
	filtteri6.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751343Ab1BUWOT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Feb 2011 17:14:19 -0500
From: Aaro Koskinen <aaro.koskinen@iki.fi>
To: gregkh@suse.de, arnaud.patard@rtp-net.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] staging: xgifb: delete dead code for skipping the video memory sizing
Date: Tue, 22 Feb 2011 00:14:25 +0200
Message-Id: <1298326466-22707-1-git-send-email-aaro.koskinen@iki.fi>
X-Mailer: git-send-email 1.5.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Delete dead code for skipping the video memory sizing.

Signed-off-by: Aaro Koskinen <aaro.koskinen@iki.fi>
---
 drivers/staging/xgifb/XGI_main_26.c |    1 -
 drivers/staging/xgifb/vb_init.c     |   23 +++--------------------
 drivers/staging/xgifb/vgatypes.h    |    2 --
 3 files changed, 3 insertions(+), 23 deletions(-)

diff --git a/drivers/staging/xgifb/XGI_main_26.c b/drivers/staging/xgifb/XGI_main_26.c
index 7f821ae..c6ae792 100644
--- a/drivers/staging/xgifb/XGI_main_26.c
+++ b/drivers/staging/xgifb/XGI_main_26.c
@@ -3025,7 +3025,6 @@ static int __devinit xgifb_probe(struct pci_dev *pdev,
 		printk(KERN_INFO "XGIfb: Video ROM usage disabled\n");
 	}
 	XGIhw_ext.pjCustomizedROMImage = NULL;
-	XGIhw_ext.bSkipDramSizing = 0;
 	XGIhw_ext.pQueryVGAConfigSpace = &XGIfb_query_VGA_config_space;
 	/* XGIhw_ext.pQueryNorthBridgeSpace = &XGIfb_query_north_bridge_space; */
 	strcpy(XGIhw_ext.szVBIOSVer, "0.84");
diff --git a/drivers/staging/xgifb/vb_init.c b/drivers/staging/xgifb/vb_init.c
index 8d59182..9a5aa6c 100644
--- a/drivers/staging/xgifb/vb_init.c
+++ b/drivers/staging/xgifb/vb_init.c
@@ -120,8 +120,6 @@ unsigned char XGIInitNew(struct xgi_hw_device_info *HwDeviceExtension)
 
 	/* unsigned long j, k; */
 
-	struct XGI_DSReg *pSR;
-
 	unsigned long Temp;
 
 	pVBInfo->ROMAddr = HwDeviceExtension->pjVirtualRomBase;
@@ -427,24 +425,9 @@ unsigned char XGIInitNew(struct xgi_hw_device_info *HwDeviceExtension)
 
 		XGINew_SetDRAMDefaultRegister340(HwDeviceExtension, pVBInfo->P3d4, pVBInfo);
 
-		if (HwDeviceExtension->bSkipDramSizing == 1) {
-			pSR = HwDeviceExtension->pSR;
-			if (pSR != NULL) {
-				while (pSR->jIdx != 0xFF) {
-					XGINew_SetReg1(pVBInfo->P3c4, pSR->jIdx, pSR->jVal);
-					pSR++;
-				}
-			}
-			/* XGINew_SetDRAMModeRegister340(pVBInfo); */
-		} /* SkipDramSizing */
-		else {
-			{
-				printk("20");
-				XGINew_SetDRAMSize_340(HwDeviceExtension, pVBInfo);
-			}
-			printk("21");
-
-		}
+		printk("20");
+		XGINew_SetDRAMSize_340(HwDeviceExtension, pVBInfo);
+		printk("21");
 	} /* XG40 */
 
 	printk("22");
diff --git a/drivers/staging/xgifb/vgatypes.h b/drivers/staging/xgifb/vgatypes.h
index df839ee..92a9ee5 100644
--- a/drivers/staging/xgifb/vgatypes.h
+++ b/drivers/staging/xgifb/vgatypes.h
@@ -101,8 +101,6 @@ struct xgi_hw_device_info
 
     unsigned char bIntegratedMMEnabled;/* supporting integration MM enable */
 
-    unsigned char bSkipDramSizing;     /* True: Skip video memory sizing. */
-
     unsigned char bSkipSense;
 
     unsigned char bIsPowerSaving;     /* True: XGIInit() is invoked by power management,
-- 
1.5.6.5

