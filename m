Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758113Ab0LTVuM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Dec 2010 16:50:12 -0500
Received: from filtteri6.pp.htv.fi ([213.243.153.189]:54123 "EHLO
	filtteri6.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758050Ab0LTVuH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Dec 2010 16:50:07 -0500
From: Aaro Koskinen <aaro.koskinen@iki.fi>
To: linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        thomas@winischhofer.net
Cc: aaro.koskinen@iki.fi
Subject: [PATCH 12/13] sisfb: delete unused register I/O macros
Date: Mon, 20 Dec 2010 23:50:21 +0200
Message-Id: <1292881822-32630-13-git-send-email-aaro.koskinen@iki.fi>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1292881822-32630-1-git-send-email-aaro.koskinen@iki.fi>
References: <1292881822-32630-1-git-send-email-aaro.koskinen@iki.fi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Delete unused register I/O macros.

Signed-off-by: Aaro Koskinen <aaro.koskinen@iki.fi>
Cc: Thomas Winischhofer <thomas@winischhofer.net>
---
 drivers/video/sis/sis.h |   54 +----------------------------------------------
 1 files changed, 1 insertions(+), 53 deletions(-)

diff --git a/drivers/video/sis/sis.h b/drivers/video/sis/sis.h
index acf0766..eac7a01 100644
--- a/drivers/video/sis/sis.h
+++ b/drivers/video/sis/sis.h
@@ -307,7 +307,7 @@
 #define VB2_LCDOVER1600BRIDGE	(VB2_307T  | VB2_307LV)
 #define VB2_RAMDAC202MHZBRIDGE	(VB2_301C  | VB2_307T)
 
-/* I/O port access macros and functions */
+/* I/O port access functions */
 
 void SiS_SetReg(SISIOADDRESS, u8, u8);
 void SiS_SetRegByte(SISIOADDRESS, u8);
@@ -321,58 +321,6 @@ u8 SiS_GetRegByte(SISIOADDRESS);
 u16 SiS_GetRegShort(SISIOADDRESS);
 u32 SiS_GetRegLong(SISIOADDRESS);
 
-#define inSISREG(base)		inb(base)
-
-#define outSISREG(base,val)	outb(val,base)
-
-#define orSISREG(base,val)      			\
-		do {					\
-			u8 __Temp = inSISREG(base); 	\
-			outSISREG(base, __Temp | (val));\
-		} while (0)
-
-#define andSISREG(base,val)     			\
-		do {					\
-			u8 __Temp = inSISREG(base); 	\
-			outSISREG(base, __Temp & (val));\
-		} while (0)
-
-#define inSISIDXREG(base,idx,var)			\
-		do {					\
-			outSISREG(base, idx); 		\
-			var = inSISREG((base)+1);	\
-		} while (0)
-
-#define outSISIDXREG(base,idx,val)			\
-		do {					\
-			outSISREG(base, idx);		\
-			outSISREG((base)+1, val);	\
-		} while (0)
-
-#define orSISIDXREG(base,idx,val)				\
-		do {						\
-			u8 __Temp; 				\
-			outSISREG(base, idx);   		\
-			__Temp = inSISREG((base)+1) | (val); 	\
-			outSISREG((base)+1, __Temp);		\
-		} while (0)
-
-#define andSISIDXREG(base,idx,and)				\
-		do {						\
-			u8 __Temp; 				\
-			outSISREG(base, idx);   		\
-			__Temp = inSISREG((base)+1) & (and); 	\
-			outSISREG((base)+1, __Temp);		\
-		} while (0)
-
-#define setSISIDXREG(base,idx,and,or)   				\
-		do {							\
-			u8 __Temp; 					\
-			outSISREG(base, idx);				\
-			__Temp = (inSISREG((base)+1) & (and)) | (or); 	\
-			outSISREG((base)+1, __Temp);			\
-		} while (0)
-
 /* MMIO access macros */
 #define MMIO_IN8(base, offset)  readb((base+offset))
 #define MMIO_IN16(base, offset) readw((base+offset))
-- 
1.5.6.5

