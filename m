Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754039Ab1CJVEp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 16:04:45 -0500
Received: from filtteri2.pp.htv.fi ([213.243.153.185]:53047 "EHLO
	filtteri2.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753342Ab1CJVCs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 16:02:48 -0500
From: Aaro Koskinen <aaro.koskinen@iki.fi>
To: gregkh@suse.de, devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        arnaud.patard@rtp-net.org
Subject: [PATCH 16/22] staging: xgifb: replace XGINew_SetReg3() with outb()
Date: Thu, 10 Mar 2011 23:02:41 +0200
Message-Id: <1299790967-7135-17-git-send-email-aaro.koskinen@iki.fi>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1299790967-7135-1-git-send-email-aaro.koskinen@iki.fi>
References: <1299790967-7135-1-git-send-email-aaro.koskinen@iki.fi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace XGINew_SetReg3() with outb().

Signed-off-by: Aaro Koskinen <aaro.koskinen@iki.fi>
---
 drivers/staging/xgifb/vb_init.c    |    2 +-
 drivers/staging/xgifb/vb_setmode.c |   67 +++++++++++++++++-------------------
 drivers/staging/xgifb/vb_util.c    |    5 ---
 drivers/staging/xgifb/vb_util.h    |    1 -
 4 files changed, 33 insertions(+), 42 deletions(-)

diff --git a/drivers/staging/xgifb/vb_init.c b/drivers/staging/xgifb/vb_init.c
index 0c9e277..46ccdf1 100644
--- a/drivers/staging/xgifb/vb_init.c
+++ b/drivers/staging/xgifb/vb_init.c
@@ -1313,7 +1313,7 @@ unsigned char XGIInitNew(struct xgi_hw_device_info *HwDeviceExtension)
 	}
 	printk("2");
 
-	XGINew_SetReg3((pVBInfo->BaseAddr + 0x12), 0x67); /* 3c2 <- 67 ,ynlai */
+	outb(0x67, (pVBInfo->BaseAddr + 0x12)); /* 3c2 <- 67 ,ynlai */
 
 	pVBInfo->ISXPDOS = 0;
 	printk("3");
diff --git a/drivers/staging/xgifb/vb_setmode.c b/drivers/staging/xgifb/vb_setmode.c
index 32f06e8..b4f2112 100644
--- a/drivers/staging/xgifb/vb_setmode.c
+++ b/drivers/staging/xgifb/vb_setmode.c
@@ -265,7 +265,7 @@ static void XGI_SetMiscRegs(unsigned short StandTableIndex,
 	}
 	*/
 
-	XGINew_SetReg3(pVBInfo->P3c2, Miscdata); /* Set Misc(3c2) */
+	outb(Miscdata, pVBInfo->P3c2); /* Set Misc(3c2) */
 }
 
 static void XGI_SetCRTCRegs(struct xgi_hw_device_info *HwDeviceExtension,
@@ -322,15 +322,15 @@ static void XGI_SetATTRegs(unsigned short ModeNo, unsigned short StandTableIndex
 		}
 
 		inb(pVBInfo->P3da); /* reset 3da */
-		XGINew_SetReg3(pVBInfo->P3c0, i); /* set index */
-		XGINew_SetReg3(pVBInfo->P3c0, ARdata); /* set data */
+		outb(i, pVBInfo->P3c0); /* set index */
+		outb(ARdata, pVBInfo->P3c0); /* set data */
 	}
 
 	inb(pVBInfo->P3da); /* reset 3da */
-	XGINew_SetReg3(pVBInfo->P3c0, 0x14); /* set index */
-	XGINew_SetReg3(pVBInfo->P3c0, 0x00); /* set data */
+	outb(0x14, pVBInfo->P3c0); /* set index */
+	outb(0x00, pVBInfo->P3c0); /* set data */
 	inb(pVBInfo->P3da); /* Enable Attribute */
-	XGINew_SetReg3(pVBInfo->P3c0, 0x20);
+	outb(0x20, pVBInfo->P3c0);
 }
 
 static void XGI_SetGRCRegs(unsigned short StandTableIndex,
@@ -525,7 +525,7 @@ static void XGI_SetSync(unsigned short RefreshRateTableIndex,
 	sync &= 0xC0;
 	temp = 0x2F;
 	temp |= sync;
-	XGINew_SetReg3(pVBInfo->P3c2, temp); /* Set Misc(3c2) */
+	outb(temp, pVBInfo->P3c2); /* Set Misc(3c2) */
 }
 
 static void XGI_SetCRT1Timing_H(struct vb_device_info *pVBInfo,
@@ -1734,9 +1734,9 @@ static void XGI_WriteDAC(unsigned short dl, unsigned short ah, unsigned short al
 			bh = temp;
 		}
 	}
-	XGINew_SetReg3(pVBInfo->P3c9, (unsigned short) dh);
-	XGINew_SetReg3(pVBInfo->P3c9, (unsigned short) bh);
-	XGINew_SetReg3(pVBInfo->P3c9, (unsigned short) bl);
+	outb((unsigned short) dh, pVBInfo->P3c9);
+	outb((unsigned short) bh, pVBInfo->P3c9);
+	outb((unsigned short) bl, pVBInfo->P3c9);
 }
 
 static void XGI_LoadDAC(unsigned short ModeNo, unsigned short ModeIdIndex,
@@ -1769,8 +1769,8 @@ static void XGI_LoadDAC(unsigned short ModeNo, unsigned short ModeIdIndex,
 	else
 		j = time;
 
-	XGINew_SetReg3(pVBInfo->P3c6, 0xFF);
-	XGINew_SetReg3(pVBInfo->P3c8, 0x00);
+	outb(0xFF, pVBInfo->P3c6);
+	outb(0x00, pVBInfo->P3c8);
 
 	for (i = 0; i < j; i++) {
 		data = table[i];
@@ -1784,7 +1784,7 @@ static void XGI_LoadDAC(unsigned short ModeNo, unsigned short ModeIdIndex,
 			if (data & 0x02)
 				data2 += 0x15;
 
-			XGINew_SetReg3(pVBInfo->P3c9, data2);
+			outb(data2, pVBInfo->P3c9);
 			data = data >> 2;
 		}
 	}
@@ -1794,7 +1794,7 @@ static void XGI_LoadDAC(unsigned short ModeNo, unsigned short ModeIdIndex,
 			data = table[i];
 
 			for (k = 0; k < 3; k++)
-				XGINew_SetReg3(pVBInfo->P3c9, data);
+				outb(data, pVBInfo->P3c9);
 		}
 
 		si = 32;
@@ -6471,7 +6471,7 @@ static void XGI_SetXG21LVDSPara(unsigned short ModeNo, unsigned short ModeIdInde
 	temp &= LCDPolarity;
 	Miscdata = (unsigned char) inb(pVBInfo->P3cc);
 
-	XGINew_SetReg3(pVBInfo->P3c2, (Miscdata & 0x3F) | temp);
+	outb((Miscdata & 0x3F) | temp, pVBInfo->P3c2);
 
 	temp = (unsigned char) (pVBInfo->XG21_LVDSCapList[lvdstableindex].LVDS_Capability
 					& LCDPolarity);
@@ -6629,11 +6629,11 @@ static void XGI_SetXG21LVDSPara(unsigned short ModeNo, unsigned short ModeIdInde
 
 	if (!(modeflag & Charx8Dot)) {
 		inb(pVBInfo->P3da); /* reset 3da */
-		XGINew_SetReg3(pVBInfo->P3c0, 0x13); /* set index */
-		XGINew_SetReg3(pVBInfo->P3c0, 0x00); /* set data, panning = 0, shift left 1 dot*/
+		outb(0x13, pVBInfo->P3c0); /* set index */
+		outb(0x00, pVBInfo->P3c0); /* set data, panning = 0, shift left 1 dot*/
 
 		inb(pVBInfo->P3da); /* Enable Attribute */
-		XGINew_SetReg3(pVBInfo->P3c0, 0x20);
+		outb(0x20, pVBInfo->P3c0);
 
 		inb(pVBInfo->P3da); /* reset 3da */
 	}
@@ -6656,7 +6656,7 @@ static void XGI_SetXG27LVDSPara(unsigned short ModeNo, unsigned short ModeIdInde
 	temp &= LCDPolarity;
 	Miscdata = (unsigned char) inb(pVBInfo->P3cc);
 
-	XGINew_SetReg3(pVBInfo->P3c2, (Miscdata & 0x3F) | temp);
+	outb((Miscdata & 0x3F) | temp, pVBInfo->P3c2);
 
 	temp = (unsigned char) (pVBInfo->XG21_LVDSCapList[lvdstableindex].LVDS_Capability
 					& LCDPolarity);
@@ -6813,11 +6813,11 @@ static void XGI_SetXG27LVDSPara(unsigned short ModeNo, unsigned short ModeIdInde
 
 	if (!(modeflag & Charx8Dot)) {
 		inb(pVBInfo->P3da); /* reset 3da */
-		XGINew_SetReg3(pVBInfo->P3c0, 0x13); /* set index */
-		XGINew_SetReg3(pVBInfo->P3c0, 0x00); /* set data, panning = 0, shift left 1 dot*/
+		outb(0x13, pVBInfo->P3c0); /* set index */
+		outb(0x00, pVBInfo->P3c0); /* set data, panning = 0, shift left 1 dot*/
 
 		inb(pVBInfo->P3da); /* Enable Attribute */
-		XGINew_SetReg3(pVBInfo->P3c0, 0x20);
+		outb(0x20, pVBInfo->P3c0);
 
 		inb(pVBInfo->P3da); /* reset 3da */
 	}
@@ -7995,15 +7995,12 @@ void XGI_SenseCRT1(struct vb_device_info *pVBInfo)
 	XGINew_SetReg1(pVBInfo->P3c4, 0x2B, 0x1B);
 	XGINew_SetReg1(pVBInfo->P3c4, 0x2C, 0xE1);
 
-	XGINew_SetReg3(pVBInfo->P3c8, 0x00);
+	outb(0x00, pVBInfo->P3c8);
 
 	for (i = 0; i < 256; i++) {
-		XGINew_SetReg3((pVBInfo->P3c8 + 1),
-				(unsigned char) DAC_TEST_PARMS[0]);
-		XGINew_SetReg3((pVBInfo->P3c8 + 1),
-				(unsigned char) DAC_TEST_PARMS[1]);
-		XGINew_SetReg3((pVBInfo->P3c8 + 1),
-				(unsigned char) DAC_TEST_PARMS[2]);
+		outb((unsigned char) DAC_TEST_PARMS[0], (pVBInfo->P3c8 + 1));
+		outb((unsigned char) DAC_TEST_PARMS[1], (pVBInfo->P3c8 + 1));
+		outb((unsigned char) DAC_TEST_PARMS[2], (pVBInfo->P3c8 + 1));
 	}
 
 	XGI_VBLongWait(pVBInfo);
@@ -8021,12 +8018,12 @@ void XGI_SenseCRT1(struct vb_device_info *pVBInfo)
 		XGINew_SetRegANDOR(pVBInfo->P3d4, 0x32, 0xDF, 0x00);
 
 	/* alan, avoid display something, set BLACK DAC if not restore DAC */
-	XGINew_SetReg3(pVBInfo->P3c8, 0x00);
+	outb(0x00, pVBInfo->P3c8);
 
 	for (i = 0; i < 256; i++) {
-		XGINew_SetReg3((pVBInfo->P3c8 + 1), 0);
-		XGINew_SetReg3((pVBInfo->P3c8 + 1), 0);
-		XGINew_SetReg3((pVBInfo->P3c8 + 1), 0);
+		outb(0, (pVBInfo->P3c8 + 1));
+		outb(0, (pVBInfo->P3c8 + 1));
+		outb(0, (pVBInfo->P3c8 + 1));
 	}
 
 	XGINew_SetReg1(pVBInfo->P3c4, 0x01, SR01);
@@ -8231,13 +8228,13 @@ static void XGI_SetCRT1Group(struct xgi_hw_device_info *HwDeviceExtension,
 			XGINew_SetReg1(pVBInfo->P3c4, 0x2B, 0x4E);
 			XGINew_SetReg1(pVBInfo->P3c4, 0x2C, 0xE9);
 			b3CC = (unsigned char) inb(XGINew_P3cc);
-			XGINew_SetReg3(XGINew_P3cc, (b3CC |= 0x0C));
+			outb((b3CC |= 0x0C), XGINew_P3cc);
 		} else if ((ModeNo == 0x04) | (ModeNo == 0x05) | (ModeNo
 				== 0x0D)) {
 			XGINew_SetReg1(pVBInfo->P3c4, 0x2B, 0x1B);
 			XGINew_SetReg1(pVBInfo->P3c4, 0x2C, 0xE3);
 			b3CC = (unsigned char) inb(XGINew_P3cc);
-			XGINew_SetReg3(XGINew_P3cc, (b3CC |= 0x0C));
+			outb((b3CC |= 0x0C), XGINew_P3cc);
 		}
 	}
 
diff --git a/drivers/staging/xgifb/vb_util.c b/drivers/staging/xgifb/vb_util.c
index be6224e..064580e 100644
--- a/drivers/staging/xgifb/vb_util.c
+++ b/drivers/staging/xgifb/vb_util.c
@@ -21,11 +21,6 @@ void XGINew_SetReg1(unsigned long port, unsigned short index,
 	outb(data, port + 1);
 }
 
-void XGINew_SetReg3(unsigned long port, unsigned short data)
-{
-	outb(data, port);
-}
-
 void XGINew_SetReg4(unsigned long port, unsigned long data)
 {
 	outl(data, port);
diff --git a/drivers/staging/xgifb/vb_util.h b/drivers/staging/xgifb/vb_util.h
index b35c63d..a67f720 100644
--- a/drivers/staging/xgifb/vb_util.h
+++ b/drivers/staging/xgifb/vb_util.h
@@ -1,7 +1,6 @@
 #ifndef _VBUTIL_
 #define _VBUTIL_
 extern   void     XGINew_SetReg1(unsigned long, unsigned short, unsigned short);
-extern   void     XGINew_SetReg3(unsigned long, unsigned short);
 extern    unsigned char     XGINew_GetReg1(unsigned long, unsigned short);
 extern   void     XGINew_SetReg4(unsigned long, unsigned long);
 extern   void     XGINew_SetRegOR(unsigned long Port,unsigned short Index,unsigned short DataOR);
-- 
1.5.6.5

