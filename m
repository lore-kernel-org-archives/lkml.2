Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964847Ab2GFKlg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 06:41:36 -0400
Received: from smtp3.mundo-r.com ([212.51.32.191]:46829 "EHLO
	smtp4.mundo-r.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933200Ab2GFKl2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 06:41:28 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Av4EAHC/9k9bdWOb/2dsb2JhbABFhWSxVIEHghkBBSMECwFGECUCJgICVwcSiA+nOZMDgSCBIY4MgRIDlTeJJoZdgmE
X-IronPort-AV: E=Sophos;i="4.77,537,1336341600"; 
   d="scan'208";a="940130703"
From: =?UTF-8?q?Miguel=20G=C3=B3mez?= <magomez@igalia.com>
To: arnaud.patard@rtp-net.org, gregkh@linuxfoundation.org,
        aaro.koskinen@iki.fi, dan.carpenter@oracle.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        =?UTF-8?q?Miguel=20G=C3=B3mez?= <magomez@igalia.com>
Subject: [PATCH 14/19 v2] Staging: xgifb: Refactor XGI_GetCRT2ResInfo().
Date: Fri,  6 Jul 2012 12:40:49 +0200
Message-Id: <8ff09fea3c7192a27251aac43eafd5c16d1d6f55.1341569486.git.magomez@igalia.com>
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

Use a goto to remove one level of indentation, fixing style warnings.

Signed-off-by: Miguel Gómez <magomez@igalia.com>
---
 drivers/staging/xgifb/vb_setmode.c |   61 ++++++++++++++++++------------------
 1 file changed, 31 insertions(+), 30 deletions(-)

diff --git a/drivers/staging/xgifb/vb_setmode.c b/drivers/staging/xgifb/vb_setmode.c
index 9dfc2de..a7ba99f 100644
--- a/drivers/staging/xgifb/vb_setmode.c
+++ b/drivers/staging/xgifb/vb_setmode.c
@@ -3263,46 +3263,47 @@ static void XGI_GetCRT2ResInfo(unsigned short ModeNo,
 	if (modeflag & DoubleScanMode)
 		yres *= 2;
 
-	if (pVBInfo->VBInfo & SetCRT2ToLCD) {
-		if (pVBInfo->IF_DEF_LVDS == 0) {
-			if (pVBInfo->LCDResInfo == Panel_1600x1200) {
-				if (!(pVBInfo->LCDInfo & XGI_LCDVESATiming)) {
-					if (yres == 1024)
-						yres = 1056;
-				}
+	if (!(pVBInfo->VBInfo & SetCRT2ToLCD))
+		goto exit;
+
+	if (pVBInfo->IF_DEF_LVDS == 0) {
+		if (pVBInfo->LCDResInfo == Panel_1600x1200) {
+			if (!(pVBInfo->LCDInfo & XGI_LCDVESATiming)) {
+				if (yres == 1024)
+					yres = 1056;
 			}
+		}
 
-			if (pVBInfo->LCDResInfo == Panel_1280x1024) {
-				if (yres == 400)
-					yres = 405;
-				else if (yres == 350)
-					yres = 360;
+		if (pVBInfo->LCDResInfo == Panel_1280x1024) {
+			if (yres == 400)
+				yres = 405;
+			else if (yres == 350)
+				yres = 360;
 
-				if (pVBInfo->LCDInfo & XGI_LCDVESATiming) {
-					if (yres == 360)
-						yres = 375;
-				}
+			if (pVBInfo->LCDInfo & XGI_LCDVESATiming) {
+				if (yres == 360)
+					yres = 375;
 			}
+		}
 
-			if (pVBInfo->LCDResInfo == Panel_1024x768) {
-				if (!(pVBInfo->LCDInfo & XGI_LCDVESATiming)) {
-					if (!(pVBInfo->LCDInfo
-							& LCDNonExpanding)) {
-						if (yres == 350)
-							yres = 357;
-						else if (yres == 400)
-							yres = 420;
-						else if (yres == 480)
-							yres = 525;
-					}
+		if (pVBInfo->LCDResInfo == Panel_1024x768) {
+			if (!(pVBInfo->LCDInfo & XGI_LCDVESATiming)) {
+				if (!(pVBInfo->LCDInfo & LCDNonExpanding)) {
+					if (yres == 350)
+						yres = 357;
+					else if (yres == 400)
+						yres = 420;
+					else if (yres == 480)
+						yres = 525;
 				}
 			}
 		}
-
-		if (xres == 720)
-			xres = 640;
 	}
 
+	if (xres == 720)
+		xres = 640;
+
+exit:
 	pVBInfo->VGAHDE = xres;
 	pVBInfo->HDE = xres;
 	pVBInfo->VGAVDE = yres;
-- 
1.7.9.5

