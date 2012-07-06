Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030225Ab2GFKnc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 06:43:32 -0400
Received: from smtp3.mundo-r.com ([212.51.32.191]:46829 "EHLO
	smtp4.mundo-r.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933143Ab2GFKl3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 06:41:29 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Av4EAHC/9k9bdWOb/2dsb2JhbABFhWSxVIEHghkBBSMECwFGECUCJgICVwcSiA+nOZMDgSCPLYESA5U3iSaGXYJh
X-IronPort-AV: E=Sophos;i="4.77,537,1336341600"; 
   d="scan'208";a="940130710"
From: =?UTF-8?q?Miguel=20G=C3=B3mez?= <magomez@igalia.com>
To: arnaud.patard@rtp-net.org, gregkh@linuxfoundation.org,
        aaro.koskinen@iki.fi, dan.carpenter@oracle.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        =?UTF-8?q?Miguel=20G=C3=B3mez?= <magomez@igalia.com>
Subject: [PATCH 16/19 v2] Staging: xgifb: Rework conditions in XGI_EnableBridge().
Date: Fri,  6 Jul 2012 12:40:51 +0200
Message-Id: <1a3d3a03fdb9653ec75ec88989a88d464b917f62.1341569486.git.magomez@igalia.com>
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
 drivers/staging/xgifb/vb_setmode.c |   44 +++++++++++++++---------------------
 1 file changed, 18 insertions(+), 26 deletions(-)

diff --git a/drivers/staging/xgifb/vb_setmode.c b/drivers/staging/xgifb/vb_setmode.c
index 5b2c35a..53135c5 100644
--- a/drivers/staging/xgifb/vb_setmode.c
+++ b/drivers/staging/xgifb/vb_setmode.c
@@ -6472,32 +6472,24 @@ static void XGI_EnableBridge(struct xgifb_video_info *xgifb_info,
 		if (!(pVBInfo->VBInfo & DisableCRT2Display)) {
 			tempah = 0xc0;
 
-			if (!(pVBInfo->VBInfo & SetSimuScanMode)) {
-				if (pVBInfo->VBInfo & XGI_SetCRT2ToLCDA) {
-					if (pVBInfo->VBInfo &
-					    SetCRT2ToDualEdge) {
-						tempah = tempah & 0x40;
-						if (pVBInfo->VBInfo &
-						    XGI_SetCRT2ToLCDA)
-							tempah = tempah ^ 0xC0;
-
-						if (pVBInfo->SetFlag &
-						    DisableChB)
-							tempah &= 0xBF;
-
-						if (pVBInfo->SetFlag &
-						    DisableChA)
-							tempah &= 0x7F;
-
-						if (pVBInfo->SetFlag &
-						    EnableChB)
-							tempah |= 0x40;
-
-						if (pVBInfo->SetFlag &
-						    EnableChA)
-							tempah |= 0x80;
-					}
-				}
+			if (!(pVBInfo->VBInfo & SetSimuScanMode) &&
+			    (pVBInfo->VBInfo & XGI_SetCRT2ToLCDA) &&
+			    (pVBInfo->VBInfo & SetCRT2ToDualEdge)) {
+				tempah = tempah & 0x40;
+				if (pVBInfo->VBInfo & XGI_SetCRT2ToLCDA)
+					tempah = tempah ^ 0xC0;
+
+				if (pVBInfo->SetFlag & DisableChB)
+					tempah &= 0xBF;
+
+				if (pVBInfo->SetFlag &  DisableChA)
+					tempah &= 0x7F;
+
+				if (pVBInfo->SetFlag &  EnableChB)
+					tempah |= 0x40;
+
+				if (pVBInfo->SetFlag &  EnableChA)
+					tempah |= 0x80;
 			}
 		}
 
-- 
1.7.9.5

