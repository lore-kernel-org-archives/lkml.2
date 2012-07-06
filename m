Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030241Ab2GFKmf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 06:42:35 -0400
Received: from smtp3.mundo-r.com ([212.51.32.191]:29884 "EHLO
	smtp4.mundo-r.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S964810Ab2GFKlc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 06:41:32 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Av4EAHC/9k9bdWOb/2dsb2JhbABFhWSxVIEHghkBBSMECwFGECUCJgICVwcSiA+nOZMDgSCBIY4MgRIDlTeJJoZdgmE
X-IronPort-AV: E=Sophos;i="4.77,537,1336341600"; 
   d="scan'208";a="940130715"
From: =?UTF-8?q?Miguel=20G=C3=B3mez?= <magomez@igalia.com>
To: arnaud.patard@rtp-net.org, gregkh@linuxfoundation.org,
        aaro.koskinen@iki.fi, dan.carpenter@oracle.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        =?UTF-8?q?Miguel=20G=C3=B3mez?= <magomez@igalia.com>
Subject: [PATCH 17/19 v2] Staging: xgifb: Rework some conditions in XGI_SetCRT2ModeRegs().
Date: Fri,  6 Jul 2012 12:40:52 +0200
Message-Id: <da5dc479b1a5e5692f18c717b3d6b538efc95d21.1341569486.git.magomez@igalia.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <cover.1341569486.git.magomez@igalia.com>
References: <cover.1341498465.git.magomez@igalia.com>
 <cover.1341569486.git.magomez@igalia.com>
In-Reply-To: <cover.1341569486.git.magomez@igalia.com>
References: <cover.1341569486.git.magomez@igalia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rework some conditions to reduce indentation and fix style warnings.

Signed-off-by: Miguel Gómez <magomez@igalia.com>
---
 drivers/staging/xgifb/vb_setmode.c |   83 ++++++++++++++++--------------------
 1 file changed, 36 insertions(+), 47 deletions(-)

diff --git a/drivers/staging/xgifb/vb_setmode.c b/drivers/staging/xgifb/vb_setmode.c
index 53135c5..01a3ef3 100644
--- a/drivers/staging/xgifb/vb_setmode.c
+++ b/drivers/staging/xgifb/vb_setmode.c
@@ -5990,60 +5990,49 @@ static void XGI_SetCRT2ModeRegs(unsigned short ModeNo,
 	tempah = 0x08;
 	tempbl = 0xf0;
 
-	if (pVBInfo->VBInfo & DisableCRT2Display) {
-		xgifb_reg_and_or(pVBInfo->Part1Port, 0x2e, tempbl, tempah);
-	} else {
-		tempah = 0x00;
-		tempbl = 0xff;
+	if (pVBInfo->VBInfo & DisableCRT2Display)
+		goto reg_and_or;
 
-		if (pVBInfo->VBInfo & (SetCRT2ToRAMDAC | SetCRT2ToTV
-				| SetCRT2ToLCD | XGI_SetCRT2ToLCDA)) {
-			if ((pVBInfo->VBInfo & XGI_SetCRT2ToLCDA) &&
-			    (!(pVBInfo->VBInfo & SetSimuScanMode))) {
-				tempbl &= 0xf7;
-				tempah |= 0x01;
-				xgifb_reg_and_or(pVBInfo->Part1Port, 0x2e,
-						tempbl, tempah);
-			} else {
-				if (pVBInfo->VBInfo & XGI_SetCRT2ToLCDA) {
-					tempbl &= 0xf7;
-					tempah |= 0x01;
-				}
+	tempah = 0x00;
+	tempbl = 0xff;
 
-				if (pVBInfo->VBInfo &
-				    (SetCRT2ToRAMDAC |
-				     SetCRT2ToTV |
-				     SetCRT2ToLCD)) {
-					tempbl &= 0xf8;
-					tempah = 0x01;
+	if (!(pVBInfo->VBInfo & (SetCRT2ToRAMDAC | SetCRT2ToTV |
+				 SetCRT2ToLCD | XGI_SetCRT2ToLCDA)))
+		goto reg_and_or;
 
-					if (!(pVBInfo->VBInfo & SetInSlaveMode))
-						tempah |= 0x02;
+	if ((pVBInfo->VBInfo & XGI_SetCRT2ToLCDA) &&
+	    (!(pVBInfo->VBInfo & SetSimuScanMode))) {
+		tempbl &= 0xf7;
+		tempah |= 0x01;
+		goto reg_and_or;
+	}
 
-					if (!(pVBInfo->VBInfo &
-					      SetCRT2ToRAMDAC)) {
-						tempah = tempah ^ 0x05;
-						if (!(pVBInfo->VBInfo &
-						      SetCRT2ToLCD))
-							tempah = tempah ^ 0x01;
-					}
+	if (pVBInfo->VBInfo & XGI_SetCRT2ToLCDA) {
+		tempbl &= 0xf7;
+		tempah |= 0x01;
+	}
 
-					if (!(pVBInfo->VBInfo &
-					      SetCRT2ToDualEdge))
-						tempah |= 0x08;
-					xgifb_reg_and_or(pVBInfo->Part1Port,
-							0x2e, tempbl, tempah);
-				} else {
-					xgifb_reg_and_or(pVBInfo->Part1Port,
-							0x2e, tempbl, tempah);
-				}
-			}
-		} else {
-			xgifb_reg_and_or(pVBInfo->Part1Port, 0x2e, tempbl,
-					tempah);
-		}
+	if (!(pVBInfo->VBInfo & (SetCRT2ToRAMDAC | SetCRT2ToTV | SetCRT2ToLCD)))
+		goto reg_and_or;
+
+	tempbl &= 0xf8;
+	tempah = 0x01;
+
+	if (!(pVBInfo->VBInfo & SetInSlaveMode))
+		tempah |= 0x02;
+
+	if (!(pVBInfo->VBInfo & SetCRT2ToRAMDAC)) {
+		tempah = tempah ^ 0x05;
+		if (!(pVBInfo->VBInfo & SetCRT2ToLCD))
+			tempah = tempah ^ 0x01;
 	}
 
+	if (!(pVBInfo->VBInfo & SetCRT2ToDualEdge))
+		tempah |= 0x08;
+
+reg_and_or:
+	xgifb_reg_and_or(pVBInfo->Part1Port, 0x2e, tempbl, tempah);
+
 	if (pVBInfo->VBInfo & (SetCRT2ToRAMDAC | SetCRT2ToTV | SetCRT2ToLCD
 			| XGI_SetCRT2ToLCDA)) {
 		tempah &= (~0x08);
-- 
1.7.9.5

