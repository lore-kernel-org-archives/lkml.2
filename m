Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756153Ab1LBCH3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Dec 2011 21:07:29 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:55375 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755764Ab1LBCH2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Dec 2011 21:07:28 -0500
From: Marcos Paulo de Souza <marcos.mage@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Marcos Paulo de Souza <marcos.mage@gmail.com>,
        Greg Kroah-Hartman <gregkh@suss.de>,
        Forest Bond <forest@alittletooquiet.net>, devel@driverdev.osuosl.org
Subject: [PATCH 5/5] staging: vt6656: channel.c: Restructure CHvInitChannelTable
Date: Fri,  2 Dec 2011 00:06:43 +0000
Message-Id: <1322784403-20086-1-git-send-email-marcos.mage@gmail.com>
X-Mailer: git-send-email 1.7.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This functions has some code that does nothing, so remove it. This patch
also fix some coding style issues.

Signed-off-by: Marcos Paulo de Souza <marcos.mage@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@suss.de>
Cc: Forest Bond <forest@alittletooquiet.net>
Cc: devel@driverdev.osuosl.org
---
 drivers/staging/vt6656/channel.c |   48 ++++++++++++++-----------------------
 1 files changed, 18 insertions(+), 30 deletions(-)

diff --git a/drivers/staging/vt6656/channel.c b/drivers/staging/vt6656/channel.c
index 16fbfcf..5cc23ba 100644
--- a/drivers/staging/vt6656/channel.c
+++ b/drivers/staging/vt6656/channel.c
@@ -39,8 +39,6 @@
 #include "channel.h"
 #include "rf.h"
 
-static int          msglevel                = MSG_LEVEL_INFO;
-
 static SChannelTblElement sChannelTbl[CB_MAX_CHANNEL+1] =
 {
   {0,   0,    FALSE},
@@ -444,38 +442,28 @@ void CHvInitChannelTable(void *pDeviceHandler)
             break;
     }
 
-    if ((pDevice->dwDiagRefCount != 0) ||
-        (pDevice->b11hEable == TRUE)) {
-        if (bMultiBand == TRUE) {
-		for (ii = 0; ii < CB_MAX_CHANNEL; ii++) {
-			sChannelTbl[ii+1].bValid = TRUE;
-		}
-		for (ii = 0; ii < CB_MAX_CHANNEL_24G; ii++) {
-		}
-        } else {
-		for (ii = 0; ii < CB_MAX_CHANNEL_24G; ii++) {
-			sChannelTbl[ii+1].bValid = TRUE;
-		}
-        }
-    } else if (pDevice->byZoneType <= CCODE_MAX) {
-        if (bMultiBand == TRUE) {
-		for (ii = 0; ii < CB_MAX_CHANNEL; ii++) {
-			if (ChannelRuleTab[pDevice->byZoneType].bChannelIdxList[ii] != 0) {
+	if ((pDevice->dwDiagRefCount != 0) ||
+	    (pDevice->b11hEable == TRUE)) {
+		if (bMultiBand == TRUE) {
+			for (ii = 0; ii < CB_MAX_CHANNEL; ii++)
 				sChannelTbl[ii+1].bValid = TRUE;
-			}
-		}
-        } else {
-		for (ii = 0; ii < CB_MAX_CHANNEL_24G; ii++) {
-			if (ChannelRuleTab[pDevice->byZoneType].bChannelIdxList[ii] != 0) {
+		} else {
+			for (ii = 0; ii < CB_MAX_CHANNEL_24G; ii++)
 				sChannelTbl[ii+1].bValid = TRUE;
+		}
+	} else if (pDevice->byZoneType <= CCODE_MAX) {
+		if (bMultiBand == TRUE) {
+			for (ii = 0; ii < CB_MAX_CHANNEL; ii++) {
+				if (ChannelRuleTab[pDevice->byZoneType].bChannelIdxList[ii] != 0)
+					sChannelTbl[ii+1].bValid = TRUE;
+			}
+		} else {
+			for (ii = 0; ii < CB_MAX_CHANNEL_24G; ii++) {
+				if (ChannelRuleTab[pDevice->byZoneType].bChannelIdxList[ii] != 0)
+					sChannelTbl[ii+1].bValid = TRUE;
 			}
 		}
-        }
-    }
-    DBG_PRT(MSG_LEVEL_NOTICE, KERN_INFO"Zone=[%d][%c][%c]!!\n",pDevice->byZoneType,ChannelRuleTab[pDevice->byZoneType].chCountryCode[0],ChannelRuleTab[pDevice->byZoneType].chCountryCode[1]);
-    for (ii = 0; ii < CB_MAX_CHANNEL; ii++) {
-        DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"Channel[%d] is [%d]\n",sChannelTbl[ii].byChannelNumber,sChannelTbl[ii+1].bValid);
-    }
+	}
 }
 
 BYTE CHbyGetChannelMapping(BYTE byChannelNumber)
-- 
1.7.4.4

