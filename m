Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755066Ab2FMWXb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 18:23:31 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:44209 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754831Ab2FMWWH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 18:22:07 -0400
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
Subject: [PATCH 09/14] staging/xgifb: Replace constant arrays with constant values
Date: Thu, 14 Jun 2012 00:21:47 +0200
Message-Id: <1339626112-20671-9-git-send-email-peterhuewe@gmx.de>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1339626112-20671-1-git-send-email-peterhuewe@gmx.de>
References: <1339626112-20671-1-git-send-email-peterhuewe@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes the arrays in XGI_GetVCLK2Ptr which each contain only
one value four times and replaces them with their constant value.

Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
---
 drivers/staging/xgifb/vb_setmode.c |   28 +++++-----------------------
 1 files changed, 5 insertions(+), 23 deletions(-)

diff --git a/drivers/staging/xgifb/vb_setmode.c b/drivers/staging/xgifb/vb_setmode.c
index ad1e23d..47d60c8 100644
--- a/drivers/staging/xgifb/vb_setmode.c
+++ b/drivers/staging/xgifb/vb_setmode.c
@@ -1010,24 +1010,6 @@ static unsigned short XGI_GetVCLK2Ptr(unsigned short ModeNo,
 		struct xgi_hw_device_info *HwDeviceExtension,
 		struct vb_device_info *pVBInfo)
 {
-	unsigned short LCDXlat1VCLK[4] = { VCLK65_315 + 2,
-					   VCLK65_315 + 2,
-					   VCLK65_315 + 2,
-					   VCLK65_315 + 2 };
-	unsigned short LCDXlat2VCLK[4] = { VCLK108_2_315 + 5,
-					   VCLK108_2_315 + 5,
-					   VCLK108_2_315 + 5,
-					   VCLK108_2_315 + 5 };
-	unsigned short LVDSXlat1VCLK[4] = { VCLK40, VCLK40, VCLK40, VCLK40 };
-	unsigned short LVDSXlat2VCLK[4] = { VCLK65_315 + 2,
-					    VCLK65_315 + 2,
-					    VCLK65_315 + 2,
-					    VCLK65_315 + 2 };
-	unsigned short LVDSXlat3VCLK[4] = { VCLK65_315 + 2,
-					    VCLK65_315 + 2,
-					    VCLK65_315 + 2,
-					    VCLK65_315 + 2 };
-
 	unsigned short CRT2Index, VCLKIndex;
 	unsigned short modeflag, resinfo;
 
@@ -1040,9 +1022,9 @@ static unsigned short XGI_GetVCLK2Ptr(unsigned short ModeNo,
 		CRT2Index = CRT2Index >> 6; /*  for LCD */
 		if (pVBInfo->VBInfo & (SetCRT2ToLCD | XGI_SetCRT2ToLCDA)) { /*301b*/
 			if (pVBInfo->LCDResInfo != Panel_1024x768)
-				VCLKIndex = LCDXlat2VCLK[CRT2Index];
+				VCLKIndex =  VCLK108_2_315 + 5; /* LCDXlat2VCLK */
 			else
-				VCLKIndex = LCDXlat1VCLK[CRT2Index];
+				VCLKIndex = VCLK65_315 + 2; /* LCDXlat1VCLK */
 		} else if (pVBInfo->VBInfo & SetCRT2ToHiVision) {
 			if (pVBInfo->SetFlag & RPLLDIV2XO) {
 				VCLKIndex = TVCLKBASE_315 + HiTVVCLKDIV2;
@@ -1093,12 +1075,12 @@ static unsigned short XGI_GetVCLK2Ptr(unsigned short ModeNo,
 		VCLKIndex = VCLKIndex >> 6;
 		if ((pVBInfo->LCDResInfo == Panel_800x600) ||
 		    (pVBInfo->LCDResInfo == Panel_320x480))
-			VCLKIndex = LVDSXlat1VCLK[VCLKIndex];
+			VCLKIndex = VCLK40; /* LVDSXlat1VCLK */
 		else if ((pVBInfo->LCDResInfo == Panel_1024x768) ||
 			 (pVBInfo->LCDResInfo == Panel_1024x768x75))
-			VCLKIndex = LVDSXlat2VCLK[VCLKIndex];
+			VCLKIndex = VCLK65_315 + 2; /* LVDSXlat2VCLK */
 		else
-			VCLKIndex = LVDSXlat3VCLK[VCLKIndex];
+			VCLKIndex = VCLK65_315 + 2; /* LVDSXlat3VCLK */
 	}
 
 	return VCLKIndex;
-- 
1.7.3.4

