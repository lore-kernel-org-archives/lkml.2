Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753668Ab1CJVCw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 16:02:52 -0500
Received: from filtteri2.pp.htv.fi ([213.243.153.185]:53046 "EHLO
	filtteri2.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753465Ab1CJVCr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 16:02:47 -0500
From: Aaro Koskinen <aaro.koskinen@iki.fi>
To: gregkh@suse.de, devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        arnaud.patard@rtp-net.org
Subject: [PATCH 14/22] staging: xgifb: replace XGINew_GetReg2() with inb()
Date: Thu, 10 Mar 2011 23:02:39 +0200
Message-Id: <1299790967-7135-15-git-send-email-aaro.koskinen@iki.fi>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1299790967-7135-1-git-send-email-aaro.koskinen@iki.fi>
References: <1299790967-7135-1-git-send-email-aaro.koskinen@iki.fi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace XGINew_GetReg2() with inb().

Signed-off-by: Aaro Koskinen <aaro.koskinen@iki.fi>
---
 drivers/staging/xgifb/vb_setmode.c |   50 ++++++++++++++++++------------------
 drivers/staging/xgifb/vb_util.c    |    9 ------
 drivers/staging/xgifb/vb_util.h    |    1 -
 3 files changed, 25 insertions(+), 35 deletions(-)

diff --git a/drivers/staging/xgifb/vb_setmode.c b/drivers/staging/xgifb/vb_setmode.c
index c9a97e6..32f06e8 100644
--- a/drivers/staging/xgifb/vb_setmode.c
+++ b/drivers/staging/xgifb/vb_setmode.c
@@ -321,15 +321,15 @@ static void XGI_SetATTRegs(unsigned short ModeNo, unsigned short StandTableIndex
 			}
 		}
 
-		XGINew_GetReg2(pVBInfo->P3da); /* reset 3da */
+		inb(pVBInfo->P3da); /* reset 3da */
 		XGINew_SetReg3(pVBInfo->P3c0, i); /* set index */
 		XGINew_SetReg3(pVBInfo->P3c0, ARdata); /* set data */
 	}
 
-	XGINew_GetReg2(pVBInfo->P3da); /* reset 3da */
+	inb(pVBInfo->P3da); /* reset 3da */
 	XGINew_SetReg3(pVBInfo->P3c0, 0x14); /* set index */
 	XGINew_SetReg3(pVBInfo->P3c0, 0x00); /* set data */
-	XGINew_GetReg2(pVBInfo->P3da); /* Enable Attribute */
+	inb(pVBInfo->P3da); /* Enable Attribute */
 	XGINew_SetReg3(pVBInfo->P3c0, 0x20);
 }
 
@@ -968,7 +968,7 @@ static void XGI_SetXG21LCD(struct vb_device_info *pVBInfo,
 	XGINew_SetRegAND(pVBInfo->P3c4, 0x35, ~0x80);
 
 	if (ModeNo <= 0x13) {
-		b3CC = (unsigned char) XGINew_GetReg2(XGI_P3cc);
+		b3CC = (unsigned char) inb(XGI_P3cc);
 		if (b3CC & 0x40)
 			XGINew_SetRegOR(pVBInfo->P3c4, 0x30, 0x20); /* Hsync polarity */
 		if (b3CC & 0x80)
@@ -1016,7 +1016,7 @@ static void XGI_SetXG27LCD(struct vb_device_info *pVBInfo,
 	XGINew_SetRegAND(pVBInfo->P3c4, 0x35, ~0x80); /* Vsync polarity */
 
 	if (ModeNo <= 0x13) {
-		b3CC = (unsigned char) XGINew_GetReg2(XGI_P3cc);
+		b3CC = (unsigned char) inb(XGI_P3cc);
 		if (b3CC & 0x40)
 			XGINew_SetRegOR(pVBInfo->P3c4, 0x30, 0x20); /* Hsync polarity */
 		if (b3CC & 0x80)
@@ -1355,7 +1355,7 @@ static unsigned short XGI_GetVCLK2Ptr(unsigned short ModeNo,
 					}
 				}
 			} else { /* for CRT2 */
-				VCLKIndex = (unsigned char) XGINew_GetReg2(
+				VCLKIndex = (unsigned char) inb(
 						(pVBInfo->P3ca + 0x02)); /* Port 3cch */
 				VCLKIndex = ((VCLKIndex >> 2) & 0x03);
 				if (ModeNo > 0x13) {
@@ -3204,7 +3204,7 @@ static unsigned char XGI_GetVCLKPtr(unsigned short RefreshRateTableIndex,
 
 	}
 
-	tempal = (unsigned char) XGINew_GetReg2((pVBInfo->P3ca + 0x02));
+	tempal = (unsigned char) inb((pVBInfo->P3ca + 0x02));
 	tempal = tempal >> 2;
 	tempal &= 0x03;
 
@@ -4190,18 +4190,18 @@ void XGI_DisplayOff(struct xgi_hw_device_info *pXGIHWDE,
 
 static void XGI_WaitDisply(struct vb_device_info *pVBInfo)
 {
-	while ((XGINew_GetReg2(pVBInfo->P3da) & 0x01))
+	while ((inb(pVBInfo->P3da) & 0x01))
 		break;
 
-	while (!(XGINew_GetReg2(pVBInfo->P3da) & 0x01))
+	while (!(inb(pVBInfo->P3da) & 0x01))
 		break;
 }
 
 #if 0
 static void XGI_WaitDisplay(struct vb_device_info *pVBInfo)
 {
-	while (!(XGINew_GetReg2(pVBInfo->P3da) & 0x01));
-	while (XGINew_GetReg2(pVBInfo->P3da) & 0x01);
+	while (!(inb(pVBInfo->P3da) & 0x01));
+	while (inb(pVBInfo->P3da) & 0x01);
 }
 #endif
 
@@ -6469,7 +6469,7 @@ static void XGI_SetXG21LVDSPara(unsigned short ModeNo, unsigned short ModeIdInde
 	temp = (unsigned char) ((pVBInfo->XG21_LVDSCapList[lvdstableindex].LVDS_Capability
 					& (LCDPolarity << 8)) >> 8);
 	temp &= LCDPolarity;
-	Miscdata = (unsigned char) XGINew_GetReg2(pVBInfo->P3cc);
+	Miscdata = (unsigned char) inb(pVBInfo->P3cc);
 
 	XGINew_SetReg3(pVBInfo->P3c2, (Miscdata & 0x3F) | temp);
 
@@ -6628,14 +6628,14 @@ static void XGI_SetXG21LVDSPara(unsigned short ModeNo, unsigned short ModeIdInde
 	}
 
 	if (!(modeflag & Charx8Dot)) {
-		XGINew_GetReg2(pVBInfo->P3da); /* reset 3da */
+		inb(pVBInfo->P3da); /* reset 3da */
 		XGINew_SetReg3(pVBInfo->P3c0, 0x13); /* set index */
 		XGINew_SetReg3(pVBInfo->P3c0, 0x00); /* set data, panning = 0, shift left 1 dot*/
 
-		XGINew_GetReg2(pVBInfo->P3da); /* Enable Attribute */
+		inb(pVBInfo->P3da); /* Enable Attribute */
 		XGINew_SetReg3(pVBInfo->P3c0, 0x20);
 
-		XGINew_GetReg2(pVBInfo->P3da); /* reset 3da */
+		inb(pVBInfo->P3da); /* reset 3da */
 	}
 
 }
@@ -6654,7 +6654,7 @@ static void XGI_SetXG27LVDSPara(unsigned short ModeNo, unsigned short ModeIdInde
 	temp = (unsigned char) ((pVBInfo->XG21_LVDSCapList[lvdstableindex].LVDS_Capability
 					& (LCDPolarity << 8)) >> 8);
 	temp &= LCDPolarity;
-	Miscdata = (unsigned char) XGINew_GetReg2(pVBInfo->P3cc);
+	Miscdata = (unsigned char) inb(pVBInfo->P3cc);
 
 	XGINew_SetReg3(pVBInfo->P3c2, (Miscdata & 0x3F) | temp);
 
@@ -6812,14 +6812,14 @@ static void XGI_SetXG27LVDSPara(unsigned short ModeNo, unsigned short ModeIdInde
 	}
 
 	if (!(modeflag & Charx8Dot)) {
-		XGINew_GetReg2(pVBInfo->P3da); /* reset 3da */
+		inb(pVBInfo->P3da); /* reset 3da */
 		XGINew_SetReg3(pVBInfo->P3c0, 0x13); /* set index */
 		XGINew_SetReg3(pVBInfo->P3c0, 0x00); /* set data, panning = 0, shift left 1 dot*/
 
-		XGINew_GetReg2(pVBInfo->P3da); /* Enable Attribute */
+		inb(pVBInfo->P3da); /* Enable Attribute */
 		XGINew_SetReg3(pVBInfo->P3c0, 0x20);
 
-		XGINew_GetReg2(pVBInfo->P3da); /* reset 3da */
+		inb(pVBInfo->P3da); /* reset 3da */
 	}
 
 }
@@ -7716,12 +7716,12 @@ void XGI_LongWait(struct vb_device_info *pVBInfo)
 
 	if (!(i & 0xC0)) {
 		for (i = 0; i < 0xFFFF; i++) {
-			if (!(XGINew_GetReg2(pVBInfo->P3da) & 0x08))
+			if (!(inb(pVBInfo->P3da) & 0x08))
 				break;
 		}
 
 		for (i = 0; i < 0xFFFF; i++) {
-			if ((XGINew_GetReg2(pVBInfo->P3da) & 0x08))
+			if ((inb(pVBInfo->P3da) & 0x08))
 				break;
 		}
 	}
@@ -7735,7 +7735,7 @@ static void XGI_VBLongWait(struct vb_device_info *pVBInfo)
 		temp = 0;
 		for (i = 0; i < 3; i++) {
 			for (j = 0; j < 100; j++) {
-				tempal = XGINew_GetReg2(pVBInfo->P3da);
+				tempal = inb(pVBInfo->P3da);
 				if (temp & 0x01) { /* VBWaitMode2 */
 					if ((tempal & 0x08))
 						continue;
@@ -8013,7 +8013,7 @@ void XGI_SenseCRT1(struct vb_device_info *pVBInfo)
 	mdelay(1);
 
 	XGI_WaitDisply(pVBInfo);
-	temp = XGINew_GetReg2(pVBInfo->P3c2);
+	temp = inb(pVBInfo->P3c2);
 
 	if (temp & 0x10)
 		XGINew_SetRegANDOR(pVBInfo->P3d4, 0x32, 0xDF, 0x20);
@@ -8230,13 +8230,13 @@ static void XGI_SetCRT1Group(struct xgi_hw_device_info *HwDeviceExtension,
 		if ((ModeNo == 0x00) | (ModeNo == 0x01)) {
 			XGINew_SetReg1(pVBInfo->P3c4, 0x2B, 0x4E);
 			XGINew_SetReg1(pVBInfo->P3c4, 0x2C, 0xE9);
-			b3CC = (unsigned char) XGINew_GetReg2(XGINew_P3cc);
+			b3CC = (unsigned char) inb(XGINew_P3cc);
 			XGINew_SetReg3(XGINew_P3cc, (b3CC |= 0x0C));
 		} else if ((ModeNo == 0x04) | (ModeNo == 0x05) | (ModeNo
 				== 0x0D)) {
 			XGINew_SetReg1(pVBInfo->P3c4, 0x2B, 0x1B);
 			XGINew_SetReg1(pVBInfo->P3c4, 0x2C, 0xE3);
-			b3CC = (unsigned char) XGINew_GetReg2(XGINew_P3cc);
+			b3CC = (unsigned char) inb(XGINew_P3cc);
 			XGINew_SetReg3(XGINew_P3cc, (b3CC |= 0x0C));
 		}
 	}
diff --git a/drivers/staging/xgifb/vb_util.c b/drivers/staging/xgifb/vb_util.c
index 465bcda..299f05c 100644
--- a/drivers/staging/xgifb/vb_util.c
+++ b/drivers/staging/xgifb/vb_util.c
@@ -40,15 +40,6 @@ unsigned char XGINew_GetReg1(unsigned long port, unsigned short index)
 	return data;
 }
 
-unsigned char XGINew_GetReg2(unsigned long port)
-{
-	unsigned char data;
-
-	data = inb(port);
-
-	return data;
-}
-
 unsigned long XGINew_GetReg3(unsigned long port)
 {
 	unsigned long data;
diff --git a/drivers/staging/xgifb/vb_util.h b/drivers/staging/xgifb/vb_util.h
index bf52127..e211320 100644
--- a/drivers/staging/xgifb/vb_util.h
+++ b/drivers/staging/xgifb/vb_util.h
@@ -3,7 +3,6 @@
 extern   void     XGINew_SetReg1(unsigned long, unsigned short, unsigned short);
 extern   void     XGINew_SetReg3(unsigned long, unsigned short);
 extern    unsigned char     XGINew_GetReg1(unsigned long, unsigned short);
-extern    unsigned char     XGINew_GetReg2(unsigned long);
 extern   void     XGINew_SetReg4(unsigned long, unsigned long);
 extern   unsigned long    XGINew_GetReg3(unsigned long);
 extern   void     XGINew_SetRegOR(unsigned long Port,unsigned short Index,unsigned short DataOR);
-- 
1.5.6.5

