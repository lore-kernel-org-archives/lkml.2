Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933307Ab2GEPWC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 11:22:02 -0400
Received: from smtp3.mundo-r.com ([212.51.32.191]:36348 "EHLO
	smtp4.mundo-r.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756694Ab2GEPUk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 11:20:40 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Av4EAJGv9U9bdWOb/2dsb2JhbABFhV+xSIEHghkBBSMECwFGECUCJgICVwcSiA+mdZJSgSCBIY4kgRIDlTeJJoZdgmE
X-IronPort-AV: E=Sophos;i="4.77,531,1336341600"; 
   d="scan'208";a="939596344"
From: =?UTF-8?q?Miguel=20G=C3=B3mez?= <magomez@igalia.com>
To: arnaud.patard@rtp-net.org, gregkh@linuxfoundation.org,
        aaro.koskinen@iki.fi, dan.carpenter@oracle.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        =?UTF-8?q?Miguel=20G=C3=B3mez?= <magomez@igalia.com>
Subject: [PATCH 15/19] Staging: xgifb: Rework conditions in XGI_SetLockRegs().
Date: Thu,  5 Jul 2012 16:45:58 +0200
Message-Id: <59ae53c03975f8e81587077aa8b0221b356896b9.1341498466.git.magomez@igalia.com>
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
 drivers/staging/xgifb/vb_setmode.c |   29 ++++++++++++-----------------
 1 file changed, 12 insertions(+), 17 deletions(-)

diff --git a/drivers/staging/xgifb/vb_setmode.c b/drivers/staging/xgifb/vb_setmode.c
index a7ba99f..b439f59 100644
--- a/drivers/staging/xgifb/vb_setmode.c
+++ b/drivers/staging/xgifb/vb_setmode.c
@@ -4039,23 +4039,18 @@ static void XGI_SetLockRegs(unsigned short ModeNo, unsigned short ModeIdIndex,
 	}
 
 	if (pVBInfo->VBInfo & SetCRT2ToHiVision) {
-		if (pVBInfo->VBType & VB_SIS301LV) {
-			if (pVBInfo->TVInfo & TVSetHiVision) {
-				tempbx -= 10;
-			} else {
-				if (pVBInfo->TVInfo & TVSimuMode) {
-					if (pVBInfo->TVInfo & TVSetPAL) {
-						if (pVBInfo->VBType &
-						    VB_SIS301LV) {
-							if (!(pVBInfo->TVInfo &
-							    (TVSetYPbPr525p |
-							    TVSetYPbPr750p |
-							    TVSetHiVision)))
-								tempbx += 40;
-						} else {
-							tempbx += 40;
-						}
-					}
+		if ((pVBInfo->VBType & VB_SIS301LV) &&
+		    !(pVBInfo->TVInfo & TVSetHiVision)) {
+			if ((pVBInfo->TVInfo & TVSimuMode) &&
+			    (pVBInfo->TVInfo & TVSetPAL)) {
+				if (pVBInfo->VBType & VB_SIS301LV) {
+					if (!(pVBInfo->TVInfo &
+					      (TVSetYPbPr525p |
+					       TVSetYPbPr750p |
+					       TVSetHiVision)))
+						tempbx += 40;
+				} else {
+					tempbx += 40;
 				}
 			}
 		} else {
-- 
1.7.9.5

