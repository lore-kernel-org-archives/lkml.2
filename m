Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933214Ab2GEOqz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 10:46:55 -0400
Received: from smtp3.mundo-r.com ([212.51.32.191]:44523 "EHLO
	smtp4.mundo-r.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933143Ab2GEOqZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 10:46:25 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Av4EANqn9U9bdWOb/2dsb2JhbABFhV+xR4EHghkBBSMECwFGECUCJgICVwcSiA+mepJWgSCPRYESA5U3iSaGXYJh
X-IronPort-AV: E=Sophos;i="4.77,531,1336341600"; 
   d="scan'208";a="926562645"
From: =?UTF-8?q?Miguel=20G=C3=B3mez?= <magomez@igalia.com>
To: arnaud.patard@rtp-net.org, gregkh@linuxfoundation.org,
        aaro.koskinen@iki.fi, dan.carpenter@oracle.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        =?UTF-8?q?Miguel=20G=C3=B3mez?= <magomez@igalia.com>
Subject: [PATCH 10/19] Staging: xgifb: Rework conditions in XGI_SetATTRegs().
Date: Thu,  5 Jul 2012 16:45:53 +0200
Message-Id: <4d7f549c19ccf6bad194f189ed3a902795ffdba2.1341498466.git.magomez@igalia.com>
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
 drivers/staging/xgifb/vb_setmode.c |   19 ++++++++-----------
 1 file changed, 8 insertions(+), 11 deletions(-)

diff --git a/drivers/staging/xgifb/vb_setmode.c b/drivers/staging/xgifb/vb_setmode.c
index 3ba3c48..4b49705 100644
--- a/drivers/staging/xgifb/vb_setmode.c
+++ b/drivers/staging/xgifb/vb_setmode.c
@@ -161,18 +161,15 @@ static void XGI_SetATTRegs(unsigned short ModeNo,
 
 	for (i = 0; i <= 0x13; i++) {
 		ARdata = pVBInfo->StandTable->ATTR[i];
-		if (modeflag & Charx8Dot) { /* ifndef Dot9 */
-			if (i == 0x13) {
-				if (pVBInfo->VBInfo & XGI_SetCRT2ToLCDA) {
+
+		if ((modeflag & Charx8Dot) && i == 0x13) { /* ifndef Dot9 */
+			if (pVBInfo->VBInfo & XGI_SetCRT2ToLCDA) {
+				ARdata = 0;
+			} else {
+				if ((pVBInfo->VBInfo &
+				     (SetCRT2ToTV | SetCRT2ToLCD)) &&
+				    (pVBInfo->VBInfo & SetInSlaveMode))
 					ARdata = 0;
-				} else {
-					if (pVBInfo->VBInfo & (SetCRT2ToTV
-							| SetCRT2ToLCD)) {
-						if (pVBInfo->VBInfo &
-						    SetInSlaveMode)
-							ARdata = 0;
-					}
-				}
 			}
 		}
 
-- 
1.7.9.5

