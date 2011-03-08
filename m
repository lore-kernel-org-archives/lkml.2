Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756555Ab1CHUQU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Mar 2011 15:16:20 -0500
Received: from filtteri1.pp.htv.fi ([213.243.153.184]:58628 "EHLO
	filtteri1.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756287Ab1CHUQN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Mar 2011 15:16:13 -0500
From: Aaro Koskinen <aaro.koskinen@iki.fi>
To: gregkh@suse.de, devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        arnaud.patard@rtp-net.org
Subject: [PATCH 05/15] staging: xgifb: delete bSkipSense
Date: Tue,  8 Mar 2011 22:16:10 +0200
Message-Id: <1299615380-22922-6-git-send-email-aaro.koskinen@iki.fi>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1299615380-22922-1-git-send-email-aaro.koskinen@iki.fi>
References: <1299615380-22922-1-git-send-email-aaro.koskinen@iki.fi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

bSkipSense is always false, thus redundant.

Signed-off-by: Aaro Koskinen <aaro.koskinen@iki.fi>
---
 drivers/staging/xgifb/vb_init.c  |   44 ++++++++++++++++++-------------------
 drivers/staging/xgifb/vgatypes.h |    2 -
 2 files changed, 21 insertions(+), 25 deletions(-)

diff --git a/drivers/staging/xgifb/vb_init.c b/drivers/staging/xgifb/vb_init.c
index 9a5aa6c..e33259a 100644
--- a/drivers/staging/xgifb/vb_init.c
+++ b/drivers/staging/xgifb/vb_init.c
@@ -388,34 +388,32 @@ unsigned char XGIInitNew(struct xgi_hw_device_info *HwDeviceExtension)
 		XGINew_SetReg1(pVBInfo->P3d4, 0x83, 0x00);
 	printk("181");
 
-	if (HwDeviceExtension->bSkipSense == 0) {
-		printk("182");
+	printk("182");
 
-		XGI_SenseCRT1(pVBInfo);
+	XGI_SenseCRT1(pVBInfo);
 
-		printk("183");
-		/* XGINew_DetectMonitor(HwDeviceExtension); */
-		pVBInfo->IF_DEF_CH7007 = 0;
-		if ((HwDeviceExtension->jChipType == XG21) && (pVBInfo->IF_DEF_CH7007)) {
-			printk("184");
-			XGI_GetSenseStatus(HwDeviceExtension, pVBInfo); /* sense CRT2 */
-			printk("185");
+	printk("183");
+	/* XGINew_DetectMonitor(HwDeviceExtension); */
+	pVBInfo->IF_DEF_CH7007 = 0;
+	if ((HwDeviceExtension->jChipType == XG21) && (pVBInfo->IF_DEF_CH7007)) {
+		printk("184");
+		XGI_GetSenseStatus(HwDeviceExtension, pVBInfo); /* sense CRT2 */
+		printk("185");
 
-		}
-		if (HwDeviceExtension->jChipType == XG21) {
-			printk("186");
+	}
+	if (HwDeviceExtension->jChipType == XG21) {
+		printk("186");
 
-			XGINew_SetRegANDOR(pVBInfo->P3d4, 0x32, ~Monitor1Sense, Monitor1Sense); /* Z9 default has CRT */
-			temp = GetXG21FPBits(pVBInfo);
-			XGINew_SetRegANDOR(pVBInfo->P3d4, 0x37, ~0x01, temp);
-			printk("187");
+		XGINew_SetRegANDOR(pVBInfo->P3d4, 0x32, ~Monitor1Sense, Monitor1Sense); /* Z9 default has CRT */
+		temp = GetXG21FPBits(pVBInfo);
+		XGINew_SetRegANDOR(pVBInfo->P3d4, 0x37, ~0x01, temp);
+		printk("187");
 
-		}
-		if (HwDeviceExtension->jChipType == XG27) {
-			XGINew_SetRegANDOR(pVBInfo->P3d4, 0x32, ~Monitor1Sense, Monitor1Sense); /* Z9 default has CRT */
-			temp = GetXG27FPBits(pVBInfo);
-			XGINew_SetRegANDOR(pVBInfo->P3d4, 0x37, ~0x03, temp);
-		}
+	}
+	if (HwDeviceExtension->jChipType == XG27) {
+		XGINew_SetRegANDOR(pVBInfo->P3d4, 0x32, ~Monitor1Sense, Monitor1Sense); /* Z9 default has CRT */
+		temp = GetXG27FPBits(pVBInfo);
+		XGINew_SetRegANDOR(pVBInfo->P3d4, 0x37, ~0x03, temp);
 	}
 	printk("19");
 
diff --git a/drivers/staging/xgifb/vgatypes.h b/drivers/staging/xgifb/vgatypes.h
index 13c02be..c4624cc 100644
--- a/drivers/staging/xgifb/vgatypes.h
+++ b/drivers/staging/xgifb/vgatypes.h
@@ -82,8 +82,6 @@ struct xgi_hw_device_info
 
     unsigned char bIntegratedMMEnabled;/* supporting integration MM enable */
 
-    unsigned char bSkipSense;
-
 	unsigned char(*pQueryVGAConfigSpace)(struct xgi_hw_device_info *,
 					    unsigned long, unsigned long,
 					    unsigned long *);
-- 
1.5.6.5

