Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752049Ab1LRXLy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Dec 2011 18:11:54 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:39332 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751763Ab1LRXLw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Dec 2011 18:11:52 -0500
From: Marcos Paulo de Souza <marcos.mage@gmail.com>
To: gregkh@suse.de
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Marcos Paulo de Souza <marcos.mage@gmail.com>
Subject: [PATCH 2/3] drivers: staging: vt6656: card.c: Remove useless return statement
Date: Sun, 18 Dec 2011 21:12:15 +0000
Message-Id: <1324242735-17975-1-git-send-email-marcos.mage@gmail.com>
X-Mailer: git-send-email 1.7.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes the return of the function CARDbSetMediaChannel, that
always return TRUE value.

Signed-off-by: Marcos Paulo de Souza <marcos.mage@gmail.com>
---
 drivers/staging/vt6656/card.c |   10 ++--------
 drivers/staging/vt6656/card.h |    2 +-
 2 files changed, 3 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/vt6656/card.c b/drivers/staging/vt6656/card.c
index a49053b..6f2adfe 100644
--- a/drivers/staging/vt6656/card.c
+++ b/drivers/staging/vt6656/card.c
@@ -91,15 +91,10 @@ const WORD cwRXBCNTSFOff[MAX_RATE] =
  *      uConnectionChannel  - Channel to be set
  *  Out:
  *      none
- *
- * Return Value: TRUE if succeeded; FALSE if failed.
- *
  */
-BOOL CARDbSetMediaChannel(void *pDeviceHandler, unsigned int uConnectionChannel)
+void CARDbSetMediaChannel(void *pDeviceHandler, unsigned int uConnectionChannel)
 {
 PSDevice            pDevice = (PSDevice) pDeviceHandler;
-BOOL                bResult = TRUE;
-
 
     if (pDevice->byBBType == BB_TYPE_11A) { // 15 ~ 38
         if ((uConnectionChannel < (CB_MAX_CHANNEL_24G+1)) || (uConnectionChannel > CB_MAX_CHANNEL))
@@ -140,7 +135,6 @@ BOOL                bResult = TRUE;
         RFbRawSetPower(pDevice, pDevice->abyCCKPwrTbl[uConnectionChannel-1], RATE_1M);
     }
     ControlvWriteByte(pDevice,MESSAGE_REQUEST_MACREG,MAC_REG_CHANNEL,(BYTE)(uConnectionChannel|0x80));
-    return(bResult);
 }
 
 /*
@@ -1090,7 +1084,7 @@ CARDbChannelSwitch (
 
     if (byCount == 0) {
         pDevice->sMgmtObj.uCurrChannel = byNewChannel;
-        bResult = CARDbSetMediaChannel(pDevice, byNewChannel);
+	CARDbSetMediaChannel(pDevice, byNewChannel);
 
 	return bResult;
     }
diff --git a/drivers/staging/vt6656/card.h b/drivers/staging/vt6656/card.h
index 6c91343..0668a2d 100644
--- a/drivers/staging/vt6656/card.h
+++ b/drivers/staging/vt6656/card.h
@@ -60,7 +60,7 @@ typedef enum _CARD_OP_MODE {
 
 /*---------------------  Export Functions  --------------------------*/
 
-BOOL CARDbSetMediaChannel(void *pDeviceHandler,
+void CARDbSetMediaChannel(void *pDeviceHandler,
 			  unsigned int uConnectionChannel);
 void CARDvSetRSPINF(void *pDeviceHandler, BYTE byBBType);
 void vUpdateIFS(void *pDeviceHandler);
-- 
1.7.4.4

