Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933222Ab2GEOsI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 10:48:08 -0400
Received: from smtp3.mundo-r.com ([212.51.32.191]:34422 "EHLO
	smtp4.mundo-r.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933140Ab2GEOqZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 10:46:25 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Av4EANqn9U9bdWOb/2dsb2JhbABFhV+xR4EHghkBBSMECwFGECUCJgICVwcSiA+mepJWgSCPRYESA5U3iSaGXYJh
X-IronPort-AV: E=Sophos;i="4.77,531,1336341600"; 
   d="scan'208";a="926562643"
From: =?UTF-8?q?Miguel=20G=C3=B3mez?= <magomez@igalia.com>
To: arnaud.patard@rtp-net.org, gregkh@linuxfoundation.org,
        aaro.koskinen@iki.fi, dan.carpenter@oracle.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        =?UTF-8?q?Miguel=20G=C3=B3mez?= <magomez@igalia.com>
Subject: [PATCH 12/19] Staging: xgifb: Refactor XGI_GetVBType().
Date: Thu,  5 Jul 2012 16:45:55 +0200
Message-Id: <0303d364f64e6af0730046ccdcea8d00bb2bc430.1341498466.git.magomez@igalia.com>
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

Refactor XGI_GetVBType() to reduce indentation and fix style warnings.

Signed-off-by: Miguel Gómez <magomez@igalia.com>
---
 drivers/staging/xgifb/vb_setmode.c |   69 +++++++++++++++++++-----------------
 1 file changed, 36 insertions(+), 33 deletions(-)

diff --git a/drivers/staging/xgifb/vb_setmode.c b/drivers/staging/xgifb/vb_setmode.c
index 03edf36..251145e 100644
--- a/drivers/staging/xgifb/vb_setmode.c
+++ b/drivers/staging/xgifb/vb_setmode.c
@@ -2559,42 +2559,45 @@ void XGI_GetVBType(struct vb_device_info *pVBInfo)
 {
 	unsigned short flag, tempbx, tempah;
 
-	if (pVBInfo->IF_DEF_LVDS == 0) {
-		tempbx = VB_SIS302B;
-		flag = xgifb_reg_get(pVBInfo->Part4Port, 0x00);
-		if (flag != 0x02) {
-			tempbx = VB_SIS301;
-			flag = xgifb_reg_get(pVBInfo->Part4Port, 0x01);
-			if (flag >= 0xB0) {
-				tempbx = VB_SIS301B;
-				if (flag >= 0xC0) {
-					tempbx = VB_XGI301C;
-					if (flag >= 0xD0) {
-						tempbx = VB_SIS301LV;
-						if (flag >= 0xE0) {
-							tempbx = VB_SIS302LV;
-							tempah = xgifb_reg_get(
-							    pVBInfo->Part4Port,
-							    0x39);
-							if (tempah != 0xFF)
-								tempbx =
-								    VB_XGI301C;
-						}
-					}
-				}
+	if (pVBInfo->IF_DEF_LVDS != 0)
+		return;
 
-				if (tempbx & (VB_SIS301B | VB_SIS302B)) {
-					flag = xgifb_reg_get(
-							pVBInfo->Part4Port,
-							0x23);
+	tempbx = VB_SIS302B;
+	flag = xgifb_reg_get(pVBInfo->Part4Port, 0x00);
+	if (flag == 0x02)
+		goto finish;
 
-					if (!(flag & 0x02))
-						tempbx = tempbx | VB_NoLCD;
-				}
-			}
-		}
-		pVBInfo->VBType = tempbx;
+	tempbx = VB_SIS301;
+	flag = xgifb_reg_get(pVBInfo->Part4Port, 0x01);
+	if (flag < 0xB0)
+		goto finish;
+
+	tempbx = VB_SIS301B;
+	if (flag < 0xC0)
+		goto bigger_than_0xB0;
+
+	tempbx = VB_XGI301C;
+	if (flag < 0xD0)
+		goto bigger_than_0xB0;
+
+	tempbx = VB_SIS301LV;
+	if (flag < 0xE0)
+		goto bigger_than_0xB0;
+
+	tempbx = VB_SIS302LV;
+	tempah = xgifb_reg_get(pVBInfo->Part4Port, 0x39);
+	if (tempah != 0xFF)
+		tempbx = VB_XGI301C;
+
+bigger_than_0xB0:
+	if (tempbx & (VB_SIS301B | VB_SIS302B)) {
+		flag = xgifb_reg_get(pVBInfo->Part4Port, 0x23);
+		if (!(flag & 0x02))
+			tempbx = tempbx | VB_NoLCD;
 	}
+
+finish:
+	pVBInfo->VBType = tempbx;
 }
 
 static void XGI_GetVBInfo(unsigned short ModeNo, unsigned short ModeIdIndex,
-- 
1.7.9.5

