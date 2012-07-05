Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933294Ab2GEPVn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 11:21:43 -0400
Received: from smtp3.mundo-r.com ([212.51.32.191]:32474 "EHLO
	smtp4.mundo-r.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756721Ab2GEPUl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 11:20:41 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Av4EAJGv9U9bdWOb/2dsb2JhbABFhV+xSIEHghkBBSMECwFGECUCJgICVwcSiA+mdZJSgSCBIY4kgRIDlTeJJoZdgmE
X-IronPort-AV: E=Sophos;i="4.77,531,1336341600"; 
   d="scan'208";a="939596357"
From: =?UTF-8?q?Miguel=20G=C3=B3mez?= <magomez@igalia.com>
To: arnaud.patard@rtp-net.org, gregkh@linuxfoundation.org,
        aaro.koskinen@iki.fi, dan.carpenter@oracle.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        =?UTF-8?q?Miguel=20G=C3=B3mez?= <magomez@igalia.com>
Subject: [PATCH 17/19] Staging: xgifb: Rework some conditions in XGI_SetCRT2ModeRegs().
Date: Thu,  5 Jul 2012 16:46:00 +0200
Message-Id: <122705931eb0d639379835a29470531fa1ab662a.1341498466.git.magomez@igalia.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <cover.1341498465.git.magomez@igalia.com>
References: <cover.1341498465.git.magomez@igalia.com>
In-Reply-To: <cover.1341498465.git.magomez@igalia.com>
References: <cover.1341498465.git.magomez@igalia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rework some conditions to reduce indentation and fix style warnings.

Signed-off-by: Miguel Gómez <magomez@igalia.com>
---
 drivers/staging/xgifb/vb_setmode.c |   81 ++++++++++++++++--------------------
 1 file changed, 36 insertions(+), 45 deletions(-)

diff --git a/drivers/staging/xgifb/vb_setmode.c b/drivers/staging/xgifb/vb_setmode.c
index 3e0d668..f41e595 100644
--- a/drivers/staging/xgifb/vb_setmode.c
+++ b/drivers/staging/xgifb/vb_setmode.c
@@ -5993,59 +5993,50 @@ static void XGI_SetCRT2ModeRegs(unsigned short ModeNo,
 	tempah = 0x08;
 	tempbl = 0xf0;
 
-	if (pVBInfo->VBInfo & DisableCRT2Display) {
-		xgifb_reg_and_or(pVBInfo->Part1Port, 0x2e, tempbl, tempah);
-	} else {
+	do {
+		if (pVBInfo->VBInfo & DisableCRT2Display)
+			break;
+
 		tempah = 0x00;
 		tempbl = 0xff;
 
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
+		if (!(pVBInfo->VBInfo & (SetCRT2ToRAMDAC | SetCRT2ToTV |
+					 SetCRT2ToLCD | XGI_SetCRT2ToLCDA)))
+			break;
 
-				if (pVBInfo->VBInfo &
-				    (SetCRT2ToRAMDAC |
-				     SetCRT2ToTV |
-				     SetCRT2ToLCD)) {
-					tempbl &= 0xf8;
-					tempah = 0x01;
+		if ((pVBInfo->VBInfo & XGI_SetCRT2ToLCDA) &&
+		    (!(pVBInfo->VBInfo & SetSimuScanMode))) {
+			tempbl &= 0xf7;
+			tempah |= 0x01;
+			break;
+		}
 
-					if (!(pVBInfo->VBInfo & SetInSlaveMode))
-						tempah |= 0x02;
+		if (pVBInfo->VBInfo & XGI_SetCRT2ToLCDA) {
+			tempbl &= 0xf7;
+			tempah |= 0x01;
+		}
 
-					if (!(pVBInfo->VBInfo &
-					      SetCRT2ToRAMDAC)) {
-						tempah = tempah ^ 0x05;
-						if (!(pVBInfo->VBInfo &
-						      SetCRT2ToLCD))
-							tempah = tempah ^ 0x01;
-					}
+		if (!(pVBInfo->VBInfo &
+		      (SetCRT2ToRAMDAC | SetCRT2ToTV | SetCRT2ToLCD)))
+			break;
 
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
+		tempbl &= 0xf8;
+		tempah = 0x01;
+
+		if (!(pVBInfo->VBInfo & SetInSlaveMode))
+			tempah |= 0x02;
+
+		if (!(pVBInfo->VBInfo & SetCRT2ToRAMDAC)) {
+			tempah = tempah ^ 0x05;
+			if (!(pVBInfo->VBInfo & SetCRT2ToLCD))
+				tempah = tempah ^ 0x01;
 		}
-	}
+
+		if (!(pVBInfo->VBInfo & SetCRT2ToDualEdge))
+			tempah |= 0x08;
+
+	} while (0);
+	xgifb_reg_and_or(pVBInfo->Part1Port, 0x2e, tempbl, tempah);
 
 	if (pVBInfo->VBInfo & (SetCRT2ToRAMDAC | SetCRT2ToTV | SetCRT2ToLCD
 			| XGI_SetCRT2ToLCDA)) {
-- 
1.7.9.5

