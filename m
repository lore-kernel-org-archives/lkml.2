Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753892Ab1LACXN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Nov 2011 21:23:13 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:42230 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753377Ab1LACXM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Nov 2011 21:23:12 -0500
From: Marcos Paulo de Souza <marcos.mage@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Marcos Paulo de Souza <marcos.mage@gmail.com>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Forest Bond <forest@alittletooquiet.net>, devel@driverdev.osuosl.org
Subject: [PATCH 1/4] staging: vt6656: channel.c: Remove dead code
Date: Thu,  1 Dec 2011 00:22:49 +0000
Message-Id: <1322698969-19285-1-git-send-email-marcos.mage@gmail.com>
X-Mailer: git-send-email 1.7.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch remove some unneeded code. Some comments, for loop doing
nothing, debug messages and unneeded variables was removed.

Signed-off-by: Marcos Paulo de Souza <marcos.mage@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de> 
Cc: Forest Bond <forest@alittletooquiet.net>
Cc: devel@driverdev.osuosl.org
---
 drivers/staging/vt6656/channel.c |   81 ++++++++------------------------------
 1 files changed, 17 insertions(+), 64 deletions(-)

diff --git a/drivers/staging/vt6656/channel.c b/drivers/staging/vt6656/channel.c
index 99e054d..172e017 100644
--- a/drivers/staging/vt6656/channel.c
+++ b/drivers/staging/vt6656/channel.c
@@ -39,15 +39,6 @@
 #include "channel.h"
 #include "rf.h"
 
-/*---------------------  Static Definitions -------------------------*/
-static int          msglevel                = MSG_LEVEL_INFO;
-//static int          msglevel                =MSG_LEVEL_DEBUG;
-
-/*---------------------  Static Classes  ----------------------------*/
-
-/*---------------------  Export Definitions -------------------------*/
-
-
 static SChannelTblElement sChannelTbl[CB_MAX_CHANNEL+1] =
 {
   {0,   0,    FALSE},
@@ -392,25 +383,15 @@ static  struct
 BOOL
 ChannelValid(unsigned int CountryCode, unsigned int ChannelIndex)
 {
-    BOOL    bValid;
-
-    bValid = FALSE;
-    /*
-     * If Channel Index is invalid, return invalid
-     */
-    if ((ChannelIndex > CB_MAX_CHANNEL) ||
-        (ChannelIndex == 0))
-    {
-        bValid = FALSE;
-        goto exit;
-    }
-
-    bValid = sChannelTbl[ChannelIndex].bValid;
-
-exit:
-    return (bValid);
+	/*
+	 * If Channel Index is invalid, return invalid
+	 */
+	if ((ChannelIndex > CB_MAX_CHANNEL) ||
+	    (ChannelIndex == 0))
+		return FALSE;
 
-} /* end ChannelValid */
+	return sChannelTbl[ChannelIndex].bValid;
+}
 
 /************************************************************************
  * CHvChannelGetList
@@ -463,51 +444,23 @@ void CHvInitChannelTable(void *pDeviceHandler)
 
     if ((pDevice->dwDiagRefCount != 0) ||
         (pDevice->b11hEable == TRUE)) {
-        if (bMultiBand == TRUE) {
-		for (ii = 0; ii < CB_MAX_CHANNEL; ii++) {
+	if (bMultiBand == TRUE)
+		for (ii = 0; ii < CB_MAX_CHANNEL; ii++)
 			sChannelTbl[ii+1].bValid = TRUE;
-                //pDevice->abyRegPwr[ii+1] = pDevice->abyOFDMDefaultPwr[ii+1];
-                //pDevice->abyLocalPwr[ii+1] = pDevice->abyOFDMDefaultPwr[ii+1];
-		}
-		for (ii = 0; ii < CB_MAX_CHANNEL_24G; ii++) {
-                //pDevice->abyRegPwr[ii+1] = pDevice->abyCCKDefaultPwr[ii+1];
-                //pDevice->abyLocalPwr[ii+1] = pDevice->abyCCKDefaultPwr[ii+1];
-		}
-        } else {
-		for (ii = 0; ii < CB_MAX_CHANNEL_24G; ii++) {
+	else
+		for (ii = 0; ii < CB_MAX_CHANNEL_24G; ii++)
 			sChannelTbl[ii+1].bValid = TRUE;
-                //pDevice->abyRegPwr[ii+1] = pDevice->abyCCKDefaultPwr[ii+1];
-                //pDevice->abyLocalPwr[ii+1] = pDevice->abyCCKDefaultPwr[ii+1];
-		}
-        }
+
     } else if (pDevice->byZoneType <= CCODE_MAX) {
         if (bMultiBand == TRUE) {
-		for (ii = 0; ii < CB_MAX_CHANNEL; ii++) {
-			if (ChannelRuleTab[pDevice->byZoneType].bChannelIdxList[ii] != 0) {
+		for (ii = 0; ii < CB_MAX_CHANNEL; ii++)
+			if (ChannelRuleTab[pDevice->byZoneType].bChannelIdxList[ii] != 0)
 				sChannelTbl[ii+1].bValid = TRUE;
-                    //pDevice->abyRegPwr[ii+1] = ChannelRuleTab[pDevice->byZoneType].byPower[ii];
-                    //pDevice->abyLocalPwr[ii+1] = ChannelRuleTab[pDevice->byZoneType].byPower[ii];
-			}
-		}
         } else {
-		for (ii = 0; ii < CB_MAX_CHANNEL_24G; ii++) {
-			if (ChannelRuleTab[pDevice->byZoneType].bChannelIdxList[ii] != 0) {
+		for (ii = 0; ii < CB_MAX_CHANNEL_24G; ii++)
+			if (ChannelRuleTab[pDevice->byZoneType].bChannelIdxList[ii] != 0)
 				sChannelTbl[ii+1].bValid = TRUE;
-                    //pDevice->abyRegPwr[ii+1] = ChannelRuleTab[pDevice->byZoneType].byPower[ii];
-                    //pDevice->abyLocalPwr[ii+1] = ChannelRuleTab[pDevice->byZoneType].byPower[ii];
-			}
-		}
-        }
-    }
-    DBG_PRT(MSG_LEVEL_NOTICE, KERN_INFO"Zone=[%d][%c][%c]!!\n",pDevice->byZoneType,ChannelRuleTab[pDevice->byZoneType].chCountryCode[0],ChannelRuleTab[pDevice->byZoneType].chCountryCode[1]);
-    for (ii = 0; ii < CB_MAX_CHANNEL; ii++) {
-        DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"Channel[%d] is [%d]\n",sChannelTbl[ii].byChannelNumber,sChannelTbl[ii+1].bValid);
-        /*if (pDevice->abyRegPwr[ii+1] == 0) {
-            pDevice->abyRegPwr[ii+1] = pDevice->abyOFDMDefaultPwr[ii+1];
         }
-        if (pDevice->abyLocalPwr[ii+1] == 0) {
-            pDevice->abyLocalPwr[ii+1] = pDevice->abyOFDMDefaultPwr[ii+1];
-        }*/
     }
 }
 
-- 
1.7.4.4

