Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754976Ab2FMWWL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 18:22:11 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:44495 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754947Ab2FMWWJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 18:22:09 -0400
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX190qIsuRY50lK3k8gcG8qMq9CMxbvio3MOFv56+CY
	utrTVstBfEpE9D
From: Peter Huewe <peterhuewe@gmx.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Arnaud Patard <arnaud.patard@rtp-net.org>,
        Aaro Koskinen <aaro.koskinen@iki.fi>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Peter Huewe <peterhuewe@gmx.de>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 10/14] staging/xgifb: Simplyfy XGI_GetVCLK2Ptr a bit
Date: Thu, 14 Jun 2012 00:21:48 +0200
Message-Id: <1339626112-20671-10-git-send-email-peterhuewe@gmx.de>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1339626112-20671-1-git-send-email-peterhuewe@gmx.de>
References: <1339626112-20671-1-git-send-email-peterhuewe@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch simplyfies the XGI_GetVCLK2Ptr a bit by moving the +=25 to
a define and removing statements without effect.

Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
---
 drivers/staging/xgifb/vb_setmode.c |   26 ++++++++------------------
 1 files changed, 8 insertions(+), 18 deletions(-)

diff --git a/drivers/staging/xgifb/vb_setmode.c b/drivers/staging/xgifb/vb_setmode.c
index 47d60c8..3b9a0f7 100644
--- a/drivers/staging/xgifb/vb_setmode.c
+++ b/drivers/staging/xgifb/vb_setmode.c
@@ -7,6 +7,7 @@
 
 
 #define  IndexMask 0xff
+#define TVCLKBASE_315_25 (TVCLKBASE_315 + 25)
 
 static const unsigned short XGINew_VGA_DAC[] = {
 	0x00, 0x10, 0x04, 0x14, 0x01, 0x11, 0x09, 0x15,
@@ -1027,20 +1028,16 @@ static unsigned short XGI_GetVCLK2Ptr(unsigned short ModeNo,
 				VCLKIndex = VCLK65_315 + 2; /* LCDXlat1VCLK */
 		} else if (pVBInfo->VBInfo & SetCRT2ToHiVision) {
 			if (pVBInfo->SetFlag & RPLLDIV2XO) {
-				VCLKIndex = TVCLKBASE_315 + HiTVVCLKDIV2;
-				VCLKIndex += 25;
+				VCLKIndex = TVCLKBASE_315_25 + HiTVVCLKDIV2;
 			} else {
-				VCLKIndex = TVCLKBASE_315 + HiTVVCLK;
-				VCLKIndex += 25;
+				VCLKIndex = TVCLKBASE_315_25 + HiTVVCLK;
 			}
 
 			if (pVBInfo->SetFlag & TVSimuMode) {
 				if (modeflag & Charx8Dot) {
-					VCLKIndex = TVCLKBASE_315 + HiTVSimuVCLK;
-					VCLKIndex += 25;
+					VCLKIndex = TVCLKBASE_315_25 + HiTVSimuVCLK;
 				} else {
-					VCLKIndex = TVCLKBASE_315 + HiTVTextVCLK;
-					VCLKIndex += 25;
+					VCLKIndex = TVCLKBASE_315_25 + HiTVTextVCLK;
 				}
 			}
 
@@ -1058,11 +1055,9 @@ static unsigned short XGI_GetVCLK2Ptr(unsigned short ModeNo,
 			}
 		} else if (pVBInfo->VBInfo & SetCRT2ToTV) {
 			if (pVBInfo->SetFlag & RPLLDIV2XO) {
-				VCLKIndex = TVCLKBASE_315 + TVVCLKDIV2;
-				VCLKIndex += 25;
+				VCLKIndex = TVCLKBASE_315_25 + TVVCLKDIV2;
 			} else {
-				VCLKIndex = TVCLKBASE_315 + TVVCLK;
-				VCLKIndex += 25;
+				VCLKIndex = TVCLKBASE_315_25 + TVVCLK;
 			}
 		} else { /* for CRT2 */
 			/* di+Ext_CRTVCLK */
@@ -1071,16 +1066,11 @@ static unsigned short XGI_GetVCLK2Ptr(unsigned short ModeNo,
 			VCLKIndex &= IndexMask;
 		}
 	} else { /* LVDS */
-		VCLKIndex = CRT2Index;
-		VCLKIndex = VCLKIndex >> 6;
 		if ((pVBInfo->LCDResInfo == Panel_800x600) ||
 		    (pVBInfo->LCDResInfo == Panel_320x480))
 			VCLKIndex = VCLK40; /* LVDSXlat1VCLK */
-		else if ((pVBInfo->LCDResInfo == Panel_1024x768) ||
-			 (pVBInfo->LCDResInfo == Panel_1024x768x75))
-			VCLKIndex = VCLK65_315 + 2; /* LVDSXlat2VCLK */
 		else
-			VCLKIndex = VCLK65_315 + 2; /* LVDSXlat3VCLK */
+			VCLKIndex = VCLK65_315 + 2; /* LVDSXlat2VCLK, LVDSXlat3VCLK  */
 	}
 
 	return VCLKIndex;
-- 
1.7.3.4

