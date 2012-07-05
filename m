Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933257Ab2GEOsr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 10:48:47 -0400
Received: from smtp3.mundo-r.com ([212.51.32.191]:34422 "EHLO
	smtp4.mundo-r.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933135Ab2GEOqY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 10:46:24 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Av4EANqn9U9bdWOb/2dsb2JhbABFhV+xR4EHghkBBSMECwFGECUCJgICVwcSiA+mepJWgSCPRYESA5U3iSaGXYJh
X-IronPort-AV: E=Sophos;i="4.77,531,1336341600"; 
   d="scan'208";a="926562641"
From: =?UTF-8?q?Miguel=20G=C3=B3mez?= <magomez@igalia.com>
To: arnaud.patard@rtp-net.org, gregkh@linuxfoundation.org,
        aaro.koskinen@iki.fi, dan.carpenter@oracle.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        =?UTF-8?q?Miguel=20G=C3=B3mez?= <magomez@igalia.com>
Subject: [PATCH 11/19] Staging: xgifb: Refactor XGI_AjustCRT2Rate().
Date: Thu,  5 Jul 2012 16:45:54 +0200
Message-Id: <d357bae990983b8dfb1b6ad09a55fdb294b62a27.1341498466.git.magomez@igalia.com>
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

Refactor some conditions to reduce indentation and fix style warnings.

Signed-off-by: Miguel Gómez <magomez@igalia.com>
---
 drivers/staging/xgifb/vb_setmode.c |   73 ++++++++++++------------------------
 1 file changed, 25 insertions(+), 48 deletions(-)

diff --git a/drivers/staging/xgifb/vb_setmode.c b/drivers/staging/xgifb/vb_setmode.c
index 4b49705..03edf36 100644
--- a/drivers/staging/xgifb/vb_setmode.c
+++ b/drivers/staging/xgifb/vb_setmode.c
@@ -250,48 +250,30 @@ static unsigned char XGI_AjustCRT2Rate(unsigned short ModeNo,
 		if (pVBInfo->VBInfo & (SetCRT2ToLCD | XGI_SetCRT2ToLCDA)) {
 			tempax |= SupportLCD;
 
-			if (pVBInfo->LCDResInfo != Panel_1280x1024) {
-				if (pVBInfo->LCDResInfo != Panel_1280x960) {
-					if (pVBInfo->LCDInfo &
-					    LCDNonExpanding) {
-						if (resinfo >= 9) {
-							tempax = 0;
-							return 0;
-						}
-					}
-				}
-			}
+			if (pVBInfo->LCDResInfo != Panel_1280x1024 &&
+			    pVBInfo->LCDResInfo != Panel_1280x960 &&
+			    (pVBInfo->LCDInfo & LCDNonExpanding) &&
+			    resinfo >= 9)
+				return 0;
 		}
 
 		if (pVBInfo->VBInfo & SetCRT2ToHiVision) { /* for HiTV */
 			if ((pVBInfo->VBType & VB_SIS301LV) &&
 			    (pVBInfo->VBExtInfo == VB_YPbPr1080i)) {
 				tempax |= SupportYPbPr750p;
-				if (pVBInfo->VBInfo & SetInSlaveMode) {
-					if (resinfo == 4)
-						return 0;
-
-					if (resinfo == 3)
-						return 0;
-
-					if (resinfo > 7)
-						return 0;
-				}
+				if ((pVBInfo->VBInfo & SetInSlaveMode) &&
+				    ((resinfo == 3) ||
+				     (resinfo == 4) ||
+				     (resinfo > 7)))
+					return 0;
 			} else {
 				tempax |= SupportHiVision;
-				if (pVBInfo->VBInfo & SetInSlaveMode) {
-					if (resinfo == 4)
+				if ((pVBInfo->VBInfo & SetInSlaveMode) &&
+				    ((resinfo == 4) ||
+				     (resinfo == 3 &&
+				      (pVBInfo->SetFlag & TVSimuMode)) ||
+				     (resinfo > 7)))
 						return 0;
-
-					if (resinfo == 3) {
-						if (pVBInfo->SetFlag
-								& TVSimuMode)
-							return 0;
-					}
-
-					if (resinfo > 7)
-						return 0;
-				}
 			}
 		} else {
 			if (pVBInfo->VBInfo & (SetCRT2ToAVIDEO |
@@ -301,23 +283,18 @@ static unsigned char XGI_AjustCRT2Rate(unsigned short ModeNo,
 					       SetCRT2ToHiVision)) {
 				tempax |= SupportTV;
 
-				if (pVBInfo->VBType & (VB_SIS301B | VB_SIS302B
-						| VB_SIS301LV | VB_SIS302LV
-						| VB_XGI301C)) {
+				if (pVBInfo->VBType & (VB_SIS301B |
+						       VB_SIS302B |
+						       VB_SIS301LV |
+						       VB_SIS302LV |
+						       VB_XGI301C))
 					tempax |= SupportTV1024;
-				}
 
-				if (!(pVBInfo->VBInfo & TVSetPAL)) {
-					if (modeflag & NoSupportSimuTV) {
-						if (pVBInfo->VBInfo &
-						    SetInSlaveMode) {
-							if (!(pVBInfo->VBInfo &
-							      SetNotSimuMode)) {
-								return 0;
-							}
-						}
-					}
-				}
+				if (!(pVBInfo->VBInfo & TVSetPAL) &&
+				    (modeflag & NoSupportSimuTV) &&
+				    (pVBInfo->VBInfo & SetInSlaveMode) &&
+				    (!(pVBInfo->VBInfo & SetNotSimuMode)))
+					return 0;
 			}
 		}
 	} else { /* for LVDS */
-- 
1.7.9.5

