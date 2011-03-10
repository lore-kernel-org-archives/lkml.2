Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753836Ab1CJVFm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 16:05:42 -0500
Received: from filtteri5.pp.htv.fi ([213.243.153.188]:55770 "EHLO
	filtteri5.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753410Ab1CJVCq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 16:02:46 -0500
From: Aaro Koskinen <aaro.koskinen@iki.fi>
To: gregkh@suse.de, devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        arnaud.patard@rtp-net.org
Subject: [PATCH 17/22] staging: xgifb: replace XGINew_SetReg4() with outl()
Date: Thu, 10 Mar 2011 23:02:42 +0200
Message-Id: <1299790967-7135-18-git-send-email-aaro.koskinen@iki.fi>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1299790967-7135-1-git-send-email-aaro.koskinen@iki.fi>
References: <1299790967-7135-1-git-send-email-aaro.koskinen@iki.fi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace XGINew_SetReg4() with outl().

Signed-off-by: Aaro Koskinen <aaro.koskinen@iki.fi>
---
 drivers/staging/xgifb/vb_init.c |    8 ++++----
 drivers/staging/xgifb/vb_util.c |    5 -----
 drivers/staging/xgifb/vb_util.h |    1 -
 3 files changed, 4 insertions(+), 10 deletions(-)

diff --git a/drivers/staging/xgifb/vb_init.c b/drivers/staging/xgifb/vb_init.c
index 46ccdf1..577f7de 100644
--- a/drivers/staging/xgifb/vb_init.c
+++ b/drivers/staging/xgifb/vb_init.c
@@ -1427,12 +1427,12 @@ unsigned char XGIInitNew(struct xgi_hw_device_info *HwDeviceExtension)
 		temp1 = XGINew_GetReg1(pVBInfo->P3c4, 0x3B);
 		temp1 &= 0x02;
 		if (temp1 == 0x02) {
-			XGINew_SetReg4(0xcf8, 0x80000000);
+			outl(0x80000000, 0xcf8);
 			ChipsetID = inl(0x0cfc);
-			XGINew_SetReg4(0xcf8, 0x8000002C);
+			outl(0x8000002C, 0xcf8);
 			VendorID = inl(0x0cfc);
 			VendorID &= 0x0000FFFF;
-			XGINew_SetReg4(0xcf8, 0x8001002C);
+			outl(0x8001002C, 0xcf8);
 			GraphicVendorID = inl(0x0cfc);
 			GraphicVendorID &= 0x0000FFFF;
 
@@ -1467,7 +1467,7 @@ unsigned char XGIInitNew(struct xgi_hw_device_info *HwDeviceExtension)
 			XGINew_SetReg1(pVBInfo->P3d4, i, pVBInfo->AGPReg[8 + i - 0x74]);
 		/* Set AGP customize registers (in SetDefAGPRegs) End */
 		/* [Hsuan]2004/12/14 AGP Input Delay Adjustment on 850 */
-		/*        XGINew_SetReg4(0xcf8 , 0x80000000); */
+		/*        outl(0x80000000, 0xcf8); */
 		/*        ChipsetID = inl(0x0cfc); */
 		/*        if (ChipsetID == 0x25308086) */
 		/*            XGINew_SetReg1(pVBInfo->P3d4, 0x77, 0xF0); */
diff --git a/drivers/staging/xgifb/vb_util.c b/drivers/staging/xgifb/vb_util.c
index 064580e..a919fd6 100644
--- a/drivers/staging/xgifb/vb_util.c
+++ b/drivers/staging/xgifb/vb_util.c
@@ -21,11 +21,6 @@ void XGINew_SetReg1(unsigned long port, unsigned short index,
 	outb(data, port + 1);
 }
 
-void XGINew_SetReg4(unsigned long port, unsigned long data)
-{
-	outl(data, port);
-}
-
 unsigned char XGINew_GetReg1(unsigned long port, unsigned short index)
 {
 	unsigned char data;
diff --git a/drivers/staging/xgifb/vb_util.h b/drivers/staging/xgifb/vb_util.h
index a67f720..7049fc7 100644
--- a/drivers/staging/xgifb/vb_util.h
+++ b/drivers/staging/xgifb/vb_util.h
@@ -2,7 +2,6 @@
 #define _VBUTIL_
 extern   void     XGINew_SetReg1(unsigned long, unsigned short, unsigned short);
 extern    unsigned char     XGINew_GetReg1(unsigned long, unsigned short);
-extern   void     XGINew_SetReg4(unsigned long, unsigned long);
 extern   void     XGINew_SetRegOR(unsigned long Port,unsigned short Index,unsigned short DataOR);
 extern   void     XGINew_SetRegAND(unsigned long Port,unsigned short Index,unsigned short DataAND);
 extern   void     XGINew_SetRegANDOR(unsigned long Port,unsigned short Index,unsigned short DataAND,unsigned short DataOR);
-- 
1.5.6.5

