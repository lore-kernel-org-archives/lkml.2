Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755127Ab2FMWYA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 18:24:00 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:44040 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753229Ab2FMWWG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 18:22:06 -0400
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX195k7Z12xR5k2zTi/u5w3AIVOjhzUahnyk0KBowIc
	0L1W2ciNAgTNzC
From: Peter Huewe <peterhuewe@gmx.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Arnaud Patard <arnaud.patard@rtp-net.org>,
        Aaro Koskinen <aaro.koskinen@iki.fi>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Peter Huewe <peterhuewe@gmx.de>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 07/14] staging/xgifb: Inline XGINew_SetDRAMSizingType
Date: Thu, 14 Jun 2012 00:21:45 +0200
Message-Id: <1339626112-20671-7-git-send-email-peterhuewe@gmx.de>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1339626112-20671-1-git-send-email-peterhuewe@gmx.de>
References: <1339626112-20671-1-git-send-email-peterhuewe@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since the function XGINew_SetDRAMSizingType is only called from one
location and consist only of 2 valuable lines we can simply inline it
here.

Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
---
 drivers/staging/xgifb/vb_init.c |   16 ++++------------
 1 files changed, 4 insertions(+), 12 deletions(-)

diff --git a/drivers/staging/xgifb/vb_init.c b/drivers/staging/xgifb/vb_init.c
index 512284c..63011af 100644
--- a/drivers/staging/xgifb/vb_init.c
+++ b/drivers/staging/xgifb/vb_init.c
@@ -579,17 +579,6 @@ static void XGINew_SetDRAMDefaultRegister340(
 		      pVBInfo->SR15[3][pVBInfo->ram_type]); /* SR1B */
 }
 
-static void XGINew_SetDRAMSizingType(int index,
-		const unsigned short DRAMTYPE_TABLE[][5],
-		struct vb_device_info *pVBInfo)
-{
-	unsigned short data;
-
-	data = DRAMTYPE_TABLE[index][4];
-	xgifb_reg_and_or(pVBInfo->P3c4, 0x13, 0x80, data);
-	udelay(15);
-	/* should delay 50 ns */
-}
 
 static unsigned short XGINew_SetDRAMSize20Reg(int index,
 		const unsigned short DRAMTYPE_TABLE[][5],
@@ -912,7 +901,10 @@ static int XGINew_DDRSizing340(struct xgi_hw_device_info *HwDeviceExtension,
 	}
 
 	for (i = 0; i < size; i++) {
-		XGINew_SetDRAMSizingType(i, dram_table, pVBInfo);
+		/* SetDRAMSizingType */
+		xgifb_reg_and_or(pVBInfo->P3c4, 0x13, 0x80, dram_table[i][4]);
+		udelay(15); /* should delay 50 ns */
+
 		memsize = XGINew_SetDRAMSize20Reg(i, dram_table, pVBInfo);
 
 		if (memsize == 0)
-- 
1.7.3.4

