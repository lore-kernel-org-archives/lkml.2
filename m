Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932259Ab2BIUMa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Feb 2012 15:12:30 -0500
Received: from mailout-de.gmx.net ([213.165.64.22]:58266 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932120Ab2BIUM2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Feb 2012 15:12:28 -0500
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX1/DL1ExEcDDz+mUvNfVZ725+qGjVgoRdYy+DFGEjG
	m448/sQAFmbHHz
From: Peter Huewe <peterhuewe@gmx.de>
To: gregkh@linuxfoundation.org
Cc: Arnaud Patard <arnaud.patard@rtp-net.org>,
        Aaro Koskinen <aaro.koskinen@iki.fi>,
        Dan Carpenter <dan.carpenter@oracle.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, Peter Huewe <peterhuewe@gmx.de>
Subject: [PATCH 6/7] staging/xgifb: Use TVCLKBASE_315 as a base address
Date: Thu,  9 Feb 2012 21:11:48 +0100
Message-Id: <1328818309-5103-7-git-send-email-peterhuewe@gmx.de>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1328818309-5103-1-git-send-email-peterhuewe@gmx.de>
References: <1328818309-5103-1-git-send-email-peterhuewe@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since the defines TVVCLKDIV2, TVVCLK, HiTVVCLKDIV2, HiTVVCLK,
HiTVSimuVCLK and HiTVTextVCLK are now defined as relative values, we
have to use TVCLKBASE_315 (0x31) as a base address to get the same values
as before the merge.

The old and now duplicated defines were removed

Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
---
 drivers/staging/xgifb/vb_def.h     |    6 ------
 drivers/staging/xgifb/vb_setmode.c |   24 ++++++++++++------------
 2 files changed, 12 insertions(+), 18 deletions(-)

diff --git a/drivers/staging/xgifb/vb_def.h b/drivers/staging/xgifb/vb_def.h
index a4fedbd..d2e0bcd 100644
--- a/drivers/staging/xgifb/vb_def.h
+++ b/drivers/staging/xgifb/vb_def.h
@@ -288,12 +288,6 @@
 #define VCLK217_325          0x55
 #define XGI_YPbPr750pVCLK    0x57
 
-#define TVVCLKDIV2           0x3A
-#define TVVCLK               0x3B
-#define HiTVVCLKDIV2         0x3C
-#define HiTVVCLK             0x3D
-#define HiTVSimuVCLK         0x3E
-#define HiTVTextVCLK         0x3F
 #define VCLK39_77            0x40
 #define YPbPr525pVCLK           0x3A
 #define NTSC1024VCLK         0x41
diff --git a/drivers/staging/xgifb/vb_setmode.c b/drivers/staging/xgifb/vb_setmode.c
index 42eaec7..2919924 100644
--- a/drivers/staging/xgifb/vb_setmode.c
+++ b/drivers/staging/xgifb/vb_setmode.c
@@ -1273,19 +1273,19 @@ static unsigned short XGI_GetVCLK2Ptr(unsigned short ModeNo,
 				VCLKIndex = LCDXlat1VCLK[CRT2Index];
 		} else if (pVBInfo->VBInfo & SetCRT2ToHiVision) {
 			if (pVBInfo->SetFlag & RPLLDIV2XO) {
-				VCLKIndex = HiTVVCLKDIV2;
+				VCLKIndex = TVCLKBASE_315 + HiTVVCLKDIV2;
 				VCLKIndex += 25;
 			} else {
-				VCLKIndex = HiTVVCLK;
+				VCLKIndex = TVCLKBASE_315 + HiTVVCLK;
 				VCLKIndex += 25;
 			}
 
 			if (pVBInfo->SetFlag & TVSimuMode) {
 				if (modeflag & Charx8Dot) {
-					VCLKIndex = HiTVSimuVCLK;
+					VCLKIndex = TVCLKBASE_315 + HiTVSimuVCLK;
 					VCLKIndex += 25;
 				} else {
-					VCLKIndex = HiTVTextVCLK;
+					VCLKIndex = TVCLKBASE_315 + HiTVTextVCLK;
 					VCLKIndex += 25;
 				}
 			}
@@ -1304,10 +1304,10 @@ static unsigned short XGI_GetVCLK2Ptr(unsigned short ModeNo,
 			}
 		} else if (pVBInfo->VBInfo & SetCRT2ToTV) {
 			if (pVBInfo->SetFlag & RPLLDIV2XO) {
-				VCLKIndex = TVVCLKDIV2;
+				VCLKIndex = TVCLKBASE_315 + TVVCLKDIV2;
 				VCLKIndex += 25;
 			} else {
-				VCLKIndex = TVVCLK;
+				VCLKIndex = TVCLKBASE_315 + TVVCLK;
 				VCLKIndex += 25;
 			}
 		} else { /* for CRT2 */
@@ -2845,13 +2845,13 @@ static unsigned char XGI_GetVCLKPtr(unsigned short RefreshRateTableIndex,
 		     VB_SIS302LV |
 		     VB_XGI301C)) {
 			if (pVBInfo->VBInfo & SetCRT2ToHiVision) {
-				tempal = HiTVVCLKDIV2;
+				tempal = TVCLKBASE_315 + HiTVVCLKDIV2;
 				if (!(pVBInfo->TVInfo & RPLLDIV2XO))
-					tempal = HiTVVCLK;
+					tempal = TVCLKBASE_315 + HiTVVCLK;
 				if (pVBInfo->TVInfo & TVSimuMode) {
-					tempal = HiTVSimuVCLK;
+					tempal = TVCLKBASE_315 + HiTVSimuVCLK;
 					if (!(modeflag & Charx8Dot))
-						tempal = HiTVTextVCLK;
+						tempal = TVCLKBASE_315 + HiTVTextVCLK;
 
 				}
 				return tempal;
@@ -2870,9 +2870,9 @@ static unsigned char XGI_GetVCLKPtr(unsigned short RefreshRateTableIndex,
 			tempal = NTSC1024VCLK;
 
 			if (!(pVBInfo->TVInfo & NTSC1024x768)) {
-				tempal = TVVCLKDIV2;
+				tempal = TVCLKBASE_315 + TVVCLKDIV2;
 				if (!(pVBInfo->TVInfo & RPLLDIV2XO))
-					tempal = TVVCLK;
+					tempal = TVCLKBASE_315 + TVVCLK;
 			}
 
 			if (pVBInfo->VBInfo & SetCRT2ToTV)
-- 
1.7.3.4

