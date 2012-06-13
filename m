Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755097Ab2FMWXs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 18:23:48 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:44082 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754922Ab2FMWWG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 18:22:06 -0400
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX1/2HyESkNH2E8gGumXC+biUhQ8ZTRIpqra29Maisc
	yDIItP3T5sUCrF
From: Peter Huewe <peterhuewe@gmx.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Arnaud Patard <arnaud.patard@rtp-net.org>,
        Aaro Koskinen <aaro.koskinen@iki.fi>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Peter Huewe <peterhuewe@gmx.de>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 08/14] staging/xgifb: Remove unnecessary fields of XGINew_DDRDRAM_TYPE{340,20}
Date: Thu, 14 Jun 2012 00:21:46 +0200
Message-Id: <1339626112-20671-8-git-send-email-peterhuewe@gmx.de>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1339626112-20671-1-git-send-email-peterhuewe@gmx.de>
References: <1339626112-20671-1-git-send-email-peterhuewe@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since the first three entries in XGINew_DDRDRAM_TYPE{340,20} are never
used, we can simply remove them;
and instead of passing XGINew_DDRDRAM_TYPE with an index we can simply
pass the value directly to XGINew_SetDRAMSize20Reg.

Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
---
 drivers/staging/xgifb/vb_init.c |   50 +++++++++++++++++++-------------------
 1 files changed, 25 insertions(+), 25 deletions(-)

diff --git a/drivers/staging/xgifb/vb_init.c b/drivers/staging/xgifb/vb_init.c
index 63011af..944653d 100644
--- a/drivers/staging/xgifb/vb_init.c
+++ b/drivers/staging/xgifb/vb_init.c
@@ -6,25 +6,25 @@
 #include "vb_util.h"
 #include "vb_setmode.h"
 
-static const unsigned short XGINew_DDRDRAM_TYPE340[4][5] = {
-	{ 2, 13, 9, 16, 0x45},
-	{ 2, 12, 9,  8, 0x35},
-	{ 2, 12, 8,  4, 0x31},
-	{ 2, 11, 8,  2, 0x21} };
-
-static const unsigned short XGINew_DDRDRAM_TYPE20[12][5] = {
-	{ 2, 14, 11, 128, 0x5D},
-	{ 2, 14, 10, 64, 0x59},
-	{ 2, 13, 11, 64, 0x4D},
-	{ 2, 14,  9, 32, 0x55},
-	{ 2, 13, 10, 32, 0x49},
-	{ 2, 12, 11, 32, 0x3D},
-	{ 2, 14,  8, 16, 0x51},
-	{ 2, 13,  9, 16, 0x45},
-	{ 2, 12, 10, 16, 0x39},
-	{ 2, 13,  8,  8, 0x41},
-	{ 2, 12,  9,  8, 0x35},
-	{ 2, 12,  8,  4, 0x31} };
+static const unsigned short XGINew_DDRDRAM_TYPE340[4][2] = {
+	{ 16, 0x45},
+	{  8, 0x35},
+	{  4, 0x31},
+	{  2, 0x21} };
+
+static const unsigned short XGINew_DDRDRAM_TYPE20[12][2] = {
+	{ 128, 0x5D},
+	{ 64, 0x59},
+	{ 64, 0x4D},
+	{ 32, 0x55},
+	{ 32, 0x49},
+	{ 32, 0x3D},
+	{ 16, 0x51},
+	{ 16, 0x45},
+	{ 16, 0x39},
+	{  8, 0x41},
+	{  8, 0x35},
+	{  4, 0x31} };
 
 #define XGIFB_ROM_SIZE	65536
 
@@ -580,15 +580,15 @@ static void XGINew_SetDRAMDefaultRegister340(
 }
 
 
-static unsigned short XGINew_SetDRAMSize20Reg(int index,
-		const unsigned short DRAMTYPE_TABLE[][5],
+static unsigned short XGINew_SetDRAMSize20Reg(
+		unsigned short dram_size,
 		struct vb_device_info *pVBInfo)
 {
 	unsigned short data = 0, memsize = 0;
 	int RankSize;
 	unsigned char ChannelNo;
 
-	RankSize = DRAMTYPE_TABLE[index][3] * pVBInfo->ram_bus / 8;
+	RankSize = dram_size * pVBInfo->ram_bus / 8;
 	data = xgifb_reg_get(pVBInfo->P3c4, 0x13);
 	data &= 0x80;
 
@@ -884,7 +884,7 @@ static int XGINew_DDRSizing340(struct xgi_hw_device_info *HwDeviceExtension,
 {
 	u8 i, size;
 	unsigned short memsize, start_addr;
-	const unsigned short (*dram_table)[5];
+	const unsigned short (*dram_table)[2];
 
 	xgifb_reg_set(pVBInfo->P3c4, 0x15, 0x00); /* noninterleaving */
 	xgifb_reg_set(pVBInfo->P3c4, 0x1C, 0x00); /* nontiling */
@@ -902,10 +902,10 @@ static int XGINew_DDRSizing340(struct xgi_hw_device_info *HwDeviceExtension,
 
 	for (i = 0; i < size; i++) {
 		/* SetDRAMSizingType */
-		xgifb_reg_and_or(pVBInfo->P3c4, 0x13, 0x80, dram_table[i][4]);
+		xgifb_reg_and_or(pVBInfo->P3c4, 0x13, 0x80, dram_table[i][1]);
 		udelay(15); /* should delay 50 ns */
 
-		memsize = XGINew_SetDRAMSize20Reg(i, dram_table, pVBInfo);
+		memsize = XGINew_SetDRAMSize20Reg(dram_table[i][0], pVBInfo);
 
 		if (memsize == 0)
 			continue;
-- 
1.7.3.4

