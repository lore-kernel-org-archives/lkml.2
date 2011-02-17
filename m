Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758120Ab1BQV3U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 16:29:20 -0500
Received: from filtteri2.pp.htv.fi ([213.243.153.185]:56520 "EHLO
	filtteri2.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758125Ab1BQV3R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Feb 2011 16:29:17 -0500
From: Aaro Koskinen <aaro.koskinen@iki.fi>
To: arnaud.patard@rtp-net.org, gregkh@suse.de, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 4/7] staging: xgifb: replace XGINew_LCD_Wait_Time() with mdelay()
Date: Thu, 17 Feb 2011 23:29:14 +0200
Message-Id: <1297978157-14927-4-git-send-email-aaro.koskinen@iki.fi>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1297978157-14927-1-git-send-email-aaro.koskinen@iki.fi>
References: <1297978157-14927-1-git-send-email-aaro.koskinen@iki.fi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

XGINew_LCD_Wait_Time() is implemented using the I/O port 0x61, which is
X86-specific and will fail on other platforms. The code did not make any
sense, but I guess the intention has been to provide a function where
the unit for the delay is milliseconds.

Signed-off-by: Aaro Koskinen <aaro.koskinen@iki.fi>
---
 drivers/staging/xgifb/vb_setmode.c |   47 +++++++----------------------------
 1 files changed, 10 insertions(+), 37 deletions(-)

diff --git a/drivers/staging/xgifb/vb_setmode.c b/drivers/staging/xgifb/vb_setmode.c
index e19b932..fa2cf96 100644
--- a/drivers/staging/xgifb/vb_setmode.c
+++ b/drivers/staging/xgifb/vb_setmode.c
@@ -1,5 +1,6 @@
 
 #include <asm/io.h>
+#include <linux/delay.h>
 #include <linux/types.h>
 #include <linux/version.h>
 #include "XGIfb.h"
@@ -161,7 +162,6 @@ void     XGI_GetRAMDAC2DATA(unsigned short ModeNo, unsigned short ModeIdIndex, u
 void     XGI_UnLockCRT2(struct xgi_hw_device_info *, struct vb_device_info *pVBInfo);
 void     XGI_LockCRT2(struct xgi_hw_device_info *, struct vb_device_info *pVBInfo);
 void     XGINew_EnableCRT2(struct vb_device_info *pVBInfo);
-void     XGINew_LCD_Wait_Time(unsigned char DelayTime, struct vb_device_info *pVBInfo);
 void     XGI_LongWait(struct vb_device_info *pVBInfo);
 void     XGI_SetCRT1Offset(unsigned short ModeNo, unsigned short ModeIdIndex, unsigned short RefreshRateTableIndex, struct xgi_hw_device_info *HwDeviceExtension, struct vb_device_info *pVBInfo);
 void     XGI_GetLCDVCLKPtr(unsigned char *di_0, unsigned char *di_1,
@@ -3788,7 +3788,7 @@ void XGI_SenseCRT1(struct vb_device_info *pVBInfo)
 	XGI_VBLongWait(pVBInfo);
 	XGI_VBLongWait(pVBInfo);
 
-	XGINew_LCD_Wait_Time(0x01, pVBInfo);
+	mdelay(1);
 
 	XGI_WaitDisply(pVBInfo);
 	temp = XGINew_GetReg2(pVBInfo->P3c2);
@@ -6716,16 +6716,16 @@ void XGI_SetPanelDelay(unsigned short tempbl, struct vb_device_info *pVBInfo)
 	index = XGI_GetLCDCapPtr(pVBInfo);
 
 	if (tempbl == 1)
-		XGINew_LCD_Wait_Time(pVBInfo->LCDCapList[index].PSC_S1, pVBInfo);
+		mdelay(pVBInfo->LCDCapList[index].PSC_S1);
 
 	if (tempbl == 2)
-		XGINew_LCD_Wait_Time(pVBInfo->LCDCapList[index].PSC_S2, pVBInfo);
+		mdelay(pVBInfo->LCDCapList[index].PSC_S2);
 
 	if (tempbl == 3)
-		XGINew_LCD_Wait_Time(pVBInfo->LCDCapList[index].PSC_S3, pVBInfo);
+		mdelay(pVBInfo->LCDCapList[index].PSC_S3);
 
 	if (tempbl == 4)
-		XGINew_LCD_Wait_Time(pVBInfo->LCDCapList[index].PSC_S4, pVBInfo);
+		mdelay(pVBInfo->LCDCapList[index].PSC_S4);
 }
 
 /* --------------------------------------------------------------------- */
@@ -6897,20 +6897,16 @@ void XGI_XG21SetPanelDelay(unsigned short tempbl,
 
 	index = XGI_GetLVDSOEMTableIndex(pVBInfo);
 	if (tempbl == 1)
-		XGINew_LCD_Wait_Time(pVBInfo->XG21_LVDSCapList[index].PSC_S1,
-				pVBInfo);
+		mdelay(pVBInfo->XG21_LVDSCapList[index].PSC_S1);
 
 	if (tempbl == 2)
-		XGINew_LCD_Wait_Time(pVBInfo->XG21_LVDSCapList[index].PSC_S2,
-				pVBInfo);
+		mdelay(pVBInfo->XG21_LVDSCapList[index].PSC_S2);
 
 	if (tempbl == 3)
-		XGINew_LCD_Wait_Time(pVBInfo->XG21_LVDSCapList[index].PSC_S3,
-				pVBInfo);
+		mdelay(pVBInfo->XG21_LVDSCapList[index].PSC_S3);
 
 	if (tempbl == 4)
-		XGINew_LCD_Wait_Time(pVBInfo->XG21_LVDSCapList[index].PSC_S4,
-				pVBInfo);
+		mdelay(pVBInfo->XG21_LVDSCapList[index].PSC_S4);
 }
 
 unsigned char XGI_XG21CheckLVDSMode(unsigned short ModeNo,
@@ -8637,29 +8633,6 @@ void XGINew_EnableCRT2(struct vb_device_info *pVBInfo)
 	XGINew_SetRegANDOR(pVBInfo->P3c4, 0x1E, 0xFF, 0x20);
 }
 
-void XGINew_LCD_Wait_Time(unsigned char DelayTime,
-		struct vb_device_info *pVBInfo)
-{
-	unsigned short i, j;
-
-	unsigned long temp, flag;
-
-	flag = 0;
-	/* printk("XGINew_LCD_Wait_Time"); */
-	/* return; */
-	for (i = 0; i < DelayTime; i++) {
-		for (j = 0; j < 66; j++) {
-			temp = XGINew_GetReg3(0x61);
-			/* temp &= 0x10000000; */
-			temp &= 0x10;
-			if (temp == flag)
-				continue;
-
-			flag = temp;
-		}
-	}
-}
-
 unsigned char XGI_BridgeIsOn(struct vb_device_info *pVBInfo)
 {
 	unsigned short flag;
-- 
1.5.6.5

