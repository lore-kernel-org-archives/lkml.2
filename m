Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756516Ab1CHUTq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Mar 2011 15:19:46 -0500
Received: from filtteri1.pp.htv.fi ([213.243.153.184]:58631 "EHLO
	filtteri1.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756401Ab1CHUQP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Mar 2011 15:16:15 -0500
From: Aaro Koskinen <aaro.koskinen@iki.fi>
To: gregkh@suse.de, devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        arnaud.patard@rtp-net.org
Subject: [PATCH 06/15] staging: xgifb: delete bIntegratedMMEnabled
Date: Tue,  8 Mar 2011 22:16:11 +0200
Message-Id: <1299615380-22922-7-git-send-email-aaro.koskinen@iki.fi>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1299615380-22922-1-git-send-email-aaro.koskinen@iki.fi>
References: <1299615380-22922-1-git-send-email-aaro.koskinen@iki.fi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

bIntegratedMMEnabled is always true, so the field and checks can be
eliminated.

Signed-off-by: Aaro Koskinen <aaro.koskinen@iki.fi>
---
 drivers/staging/xgifb/XGI_main_26.c |   14 --------------
 drivers/staging/xgifb/vb_init.c     |    3 ---
 drivers/staging/xgifb/vgatypes.h    |    2 --
 3 files changed, 0 insertions(+), 19 deletions(-)

diff --git a/drivers/staging/xgifb/XGI_main_26.c b/drivers/staging/xgifb/XGI_main_26.c
index fa30a26..ce569af 100644
--- a/drivers/staging/xgifb/XGI_main_26.c
+++ b/drivers/staging/xgifb/XGI_main_26.c
@@ -2273,20 +2273,6 @@ static int __devinit xgifb_probe(struct pci_dev *pdev,
 	printk("XGIfb:chipid = %x\n", xgi_video_info.chip);
 	XGIhw_ext.jChipType = xgi_video_info.chip;
 
-	switch (xgi_video_info.chip) {
-	case XG40:
-	case XG41:
-	case XG42:
-	case XG45:
-	case XG20:
-	case XG21:
-	case XG27:
-		XGIhw_ext.bIntegratedMMEnabled = 1;
-		break;
-	default:
-		break;
-	}
-
 	if ((xgi_video_info.chip == XG21) || (XGIfb_userom)) {
 		XGIhw_ext.pjVirtualRomBase = xgifb_copy_rom(pdev);
 		if (XGIhw_ext.pjVirtualRomBase)
diff --git a/drivers/staging/xgifb/vb_init.c b/drivers/staging/xgifb/vb_init.c
index e33259a..a16827e 100644
--- a/drivers/staging/xgifb/vb_init.c
+++ b/drivers/staging/xgifb/vb_init.c
@@ -152,9 +152,6 @@ unsigned char XGIInitNew(struct xgi_hw_device_info *HwDeviceExtension)
 	pVBInfo->ISXPDOS = 0;
 	printk("3");
 
-	if (!HwDeviceExtension->bIntegratedMMEnabled)
-		return 0; /* alan */
-
 	printk("4");
 
 	/* VBIOSVersion[4] = 0x0; */
diff --git a/drivers/staging/xgifb/vgatypes.h b/drivers/staging/xgifb/vgatypes.h
index c4624cc..4b87951 100644
--- a/drivers/staging/xgifb/vgatypes.h
+++ b/drivers/staging/xgifb/vgatypes.h
@@ -80,8 +80,6 @@ struct xgi_hw_device_info
 
     unsigned long  ulCRT2LCDType;        /* defined in the data structure type */
 
-    unsigned char bIntegratedMMEnabled;/* supporting integration MM enable */
-
 	unsigned char(*pQueryVGAConfigSpace)(struct xgi_hw_device_info *,
 					    unsigned long, unsigned long,
 					    unsigned long *);
-- 
1.5.6.5

