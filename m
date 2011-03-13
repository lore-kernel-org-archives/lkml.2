Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755112Ab1CMK1J (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Mar 2011 06:27:09 -0400
Received: from filtteri5.pp.htv.fi ([213.243.153.188]:46228 "EHLO
	filtteri5.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755042Ab1CMK0X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Mar 2011 06:26:23 -0400
From: Aaro Koskinen <aaro.koskinen@iki.fi>
To: gregkh@suse.de, devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        arnaud.patard@rtp-net.org
Subject: [PATCH v2 15/24] staging: xgifb: replace XGINew_GetReg3() with inl()
Date: Sun, 13 Mar 2011 12:26:19 +0200
Message-Id: <1300011988-2109-16-git-send-email-aaro.koskinen@iki.fi>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1300011988-2109-1-git-send-email-aaro.koskinen@iki.fi>
References: <1300011988-2109-1-git-send-email-aaro.koskinen@iki.fi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace XGINew_GetReg3() with inl().

Signed-off-by: Aaro Koskinen <aaro.koskinen@iki.fi>
---
 drivers/staging/xgifb/vb_init.c |    8 ++++----
 drivers/staging/xgifb/vb_util.c |    9 ---------
 drivers/staging/xgifb/vb_util.h |    1 -
 3 files changed, 4 insertions(+), 14 deletions(-)

diff --git a/drivers/staging/xgifb/vb_init.c b/drivers/staging/xgifb/vb_init.c
index 22a3bea..0c9e277 100644
--- a/drivers/staging/xgifb/vb_init.c
+++ b/drivers/staging/xgifb/vb_init.c
@@ -1428,12 +1428,12 @@ unsigned char XGIInitNew(struct xgi_hw_device_info *HwDeviceExtension)
 		temp1 &= 0x02;
 		if (temp1 == 0x02) {
 			XGINew_SetReg4(0xcf8, 0x80000000);
-			ChipsetID = XGINew_GetReg3(0x0cfc);
+			ChipsetID = inl(0x0cfc);
 			XGINew_SetReg4(0xcf8, 0x8000002C);
-			VendorID = XGINew_GetReg3(0x0cfc);
+			VendorID = inl(0x0cfc);
 			VendorID &= 0x0000FFFF;
 			XGINew_SetReg4(0xcf8, 0x8001002C);
-			GraphicVendorID = XGINew_GetReg3(0x0cfc);
+			GraphicVendorID = inl(0x0cfc);
 			GraphicVendorID &= 0x0000FFFF;
 
 			if (ChipsetID == 0x7301039)
@@ -1468,7 +1468,7 @@ unsigned char XGIInitNew(struct xgi_hw_device_info *HwDeviceExtension)
 		/* Set AGP customize registers (in SetDefAGPRegs) End */
 		/* [Hsuan]2004/12/14 AGP Input Delay Adjustment on 850 */
 		/*        XGINew_SetReg4(0xcf8 , 0x80000000); */
-		/*        ChipsetID = XGINew_GetReg3(0x0cfc); */
+		/*        ChipsetID = inl(0x0cfc); */
 		/*        if (ChipsetID == 0x25308086) */
 		/*            XGINew_SetReg1(pVBInfo->P3d4, 0x77, 0xF0); */
 
diff --git a/drivers/staging/xgifb/vb_util.c b/drivers/staging/xgifb/vb_util.c
index 299f05c..be6224e 100644
--- a/drivers/staging/xgifb/vb_util.c
+++ b/drivers/staging/xgifb/vb_util.c
@@ -40,15 +40,6 @@ unsigned char XGINew_GetReg1(unsigned long port, unsigned short index)
 	return data;
 }
 
-unsigned long XGINew_GetReg3(unsigned long port)
-{
-	unsigned long data;
-
-	data = inl(port);
-
-	return data;
-}
-
 void XGINew_SetRegANDOR(unsigned long Port, unsigned short Index,
 		unsigned short DataAND, unsigned short DataOR)
 {
diff --git a/drivers/staging/xgifb/vb_util.h b/drivers/staging/xgifb/vb_util.h
index e211320..b35c63d 100644
--- a/drivers/staging/xgifb/vb_util.h
+++ b/drivers/staging/xgifb/vb_util.h
@@ -4,7 +4,6 @@ extern   void     XGINew_SetReg1(unsigned long, unsigned short, unsigned short);
 extern   void     XGINew_SetReg3(unsigned long, unsigned short);
 extern    unsigned char     XGINew_GetReg1(unsigned long, unsigned short);
 extern   void     XGINew_SetReg4(unsigned long, unsigned long);
-extern   unsigned long    XGINew_GetReg3(unsigned long);
 extern   void     XGINew_SetRegOR(unsigned long Port,unsigned short Index,unsigned short DataOR);
 extern   void     XGINew_SetRegAND(unsigned long Port,unsigned short Index,unsigned short DataAND);
 extern   void     XGINew_SetRegANDOR(unsigned long Port,unsigned short Index,unsigned short DataAND,unsigned short DataOR);
-- 
1.5.6.5

