Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756596Ab1CHUQX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Mar 2011 15:16:23 -0500
Received: from filtteri1.pp.htv.fi ([213.243.153.184]:58623 "EHLO
	filtteri1.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756260Ab1CHUQN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Mar 2011 15:16:13 -0500
From: Aaro Koskinen <aaro.koskinen@iki.fi>
To: gregkh@suse.de, devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        arnaud.patard@rtp-net.org
Subject: [PATCH 04/15] staging: xgifb: delete unused fields from xgi_hw_device_info
Date: Tue,  8 Mar 2011 22:16:09 +0200
Message-Id: <1299615380-22922-5-git-send-email-aaro.koskinen@iki.fi>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1299615380-22922-1-git-send-email-aaro.koskinen@iki.fi>
References: <1299615380-22922-1-git-send-email-aaro.koskinen@iki.fi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Delete unused fields from xgi_hw_device_info.

Signed-off-by: Aaro Koskinen <aaro.koskinen@iki.fi>
---
 drivers/staging/xgifb/XGI_main_26.c |    4 ----
 drivers/staging/xgifb/vgatypes.h    |   29 -----------------------------
 2 files changed, 0 insertions(+), 33 deletions(-)

diff --git a/drivers/staging/xgifb/XGI_main_26.c b/drivers/staging/xgifb/XGI_main_26.c
index aeccdee..fa30a26 100644
--- a/drivers/staging/xgifb/XGI_main_26.c
+++ b/drivers/staging/xgifb/XGI_main_26.c
@@ -2287,7 +2287,6 @@ static int __devinit xgifb_probe(struct pci_dev *pdev,
 		break;
 	}
 
-	XGIhw_ext.pDevice = NULL;
 	if ((xgi_video_info.chip == XG21) || (XGIfb_userom)) {
 		XGIhw_ext.pjVirtualRomBase = xgifb_copy_rom(pdev);
 		if (XGIhw_ext.pjVirtualRomBase)
@@ -2298,10 +2297,7 @@ static int __devinit xgifb_probe(struct pci_dev *pdev,
 		XGIhw_ext.pjVirtualRomBase = NULL;
 		printk(KERN_INFO "XGIfb: Video ROM usage disabled\n");
 	}
-	XGIhw_ext.pjCustomizedROMImage = NULL;
 	XGIhw_ext.pQueryVGAConfigSpace = &XGIfb_query_VGA_config_space;
-	/* XGIhw_ext.pQueryNorthBridgeSpace = &XGIfb_query_north_bridge_space; */
-	strcpy(XGIhw_ext.szVBIOSVer, "0.84");
 
 	if (!XGIvga_enabled) {
 		/* Mapping Max FB Size for 315 Init */
diff --git a/drivers/staging/xgifb/vgatypes.h b/drivers/staging/xgifb/vgatypes.h
index dacdac3..13c02be 100644
--- a/drivers/staging/xgifb/vgatypes.h
+++ b/drivers/staging/xgifb/vgatypes.h
@@ -4,10 +4,6 @@
 
 #include <linux/ioctl.h>
 
-#ifndef VBIOS_VER_MAX_LENGTH
-#define VBIOS_VER_MAX_LENGTH    5
-#endif
-
 #ifndef XGI_VB_CHIP_TYPE
 enum XGI_VB_CHIP_TYPE {
     VB_CHIP_Legacy = 0,
@@ -65,10 +61,6 @@ struct xgi_hw_device_info
 
     unsigned char *pjVirtualRomBase;    /* ROM image */
 
-    unsigned char UseROM;		 /* Use the ROM image if provided */
-
-    void *pDevice;
-
     unsigned char *pjVideoMemoryAddress;/* base virtual memory address */
                                  /* of Linear VGA memory */
 
@@ -76,12 +68,6 @@ struct xgi_hw_device_info
 
     unsigned char *pjIOAddress;          /* base I/O address of VGA ports (0x3B0) */
 
-    unsigned char *pjCustomizedROMImage;
-
-    unsigned char *pj2ndVideoMemoryAddress;
-    unsigned long  ul2ndVideoMemorySize;
-
-    unsigned char *pj2ndIOAddress;
     unsigned char  jChipType;            /* Used to Identify Graphics Chip */
                                  /* defined in the data structure type  */
                                  /* "XGI_CHIP_TYPE" */
@@ -92,30 +78,15 @@ struct xgi_hw_device_info
                                  /* defined in the data structure type */
                                  /* "XGI_VB_CHIP_TYPE" */
 
-    unsigned char    bNewScratch;
-
     unsigned long  ulCRT2LCDType;        /* defined in the data structure type */
 
-    unsigned long usExternalChip;       /* NO VB or other video bridge (other than  */
-                                 /*  video bridge) */
-
     unsigned char bIntegratedMMEnabled;/* supporting integration MM enable */
 
     unsigned char bSkipSense;
 
-    unsigned char bIsPowerSaving;     /* True: XGIInit() is invoked by power management,
-                                   otherwise by 2nd adapter's initialzation */
-
 	unsigned char(*pQueryVGAConfigSpace)(struct xgi_hw_device_info *,
 					    unsigned long, unsigned long,
 					    unsigned long *);
-
-	unsigned char(*pQueryNorthBridgeSpace)(struct xgi_hw_device_info *,
-					      unsigned long, unsigned long,
-					      unsigned long *);
-
-    unsigned char szVBIOSVer[VBIOS_VER_MAX_LENGTH];
-
 };
 
 /* Addtional IOCTL for communication xgifb <> X driver        */
-- 
1.5.6.5

