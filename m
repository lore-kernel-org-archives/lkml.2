Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752077Ab1LRXMV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Dec 2011 18:12:21 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:37479 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751990Ab1LRXMT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Dec 2011 18:12:19 -0500
From: Marcos Paulo de Souza <marcos.mage@gmail.com>
To: gregkh@suse.de
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Marcos Paulo de Souza <marcos.mage@gmail.com>
Subject: [PATCH 3/3] drivers: staging: vt6656: card.c, card.h: Remove useless function
Date: Sun, 18 Dec 2011 21:12:41 +0000
Message-Id: <1324242761-18026-1-git-send-email-marcos.mage@gmail.com>
X-Mailer: git-send-email 1.7.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes a function who is not used by anybody.

Signed-off-by: Marcos Paulo de Souza <marcos.mage@gmail.com>
---
 drivers/staging/vt6656/card.c |   48 -----------------------------------------
 drivers/staging/vt6656/card.h |    5 ----
 2 files changed, 0 insertions(+), 53 deletions(-)

diff --git a/drivers/staging/vt6656/card.c b/drivers/staging/vt6656/card.c
index 6f2adfe..0cdde6c 100644
--- a/drivers/staging/vt6656/card.c
+++ b/drivers/staging/vt6656/card.c
@@ -1056,51 +1056,3 @@ void CARDvSetBSSMode(void *pDeviceHandler)
         pDevice->abyBBVGA[3] = 0x0;
     }
 }
-
-/*
- *
- * Description:
- *    Do Channel Switch defined in 802.11h
- *
- * Parameters:
- *  In:
- *      hDeviceContext - device structure point
- *  Out:
- *      none
- *
- * Return Value: none.
- *
--*/
-BOOL
-CARDbChannelSwitch (
-     void *pDeviceHandler,
-     BYTE             byMode,
-     BYTE             byNewChannel,
-     BYTE             byCount
-    )
-{
-    PSDevice    pDevice = (PSDevice) pDeviceHandler;
-    BOOL        bResult = TRUE;
-
-    if (byCount == 0) {
-        pDevice->sMgmtObj.uCurrChannel = byNewChannel;
-        CARDbSetMediaChannel(pDevice, byNewChannel);
-
-	return bResult;
-    }
-    pDevice->byChannelSwitchCount = byCount;
-    pDevice->byNewChannel = byNewChannel;
-    pDevice->bChannelSwitch = TRUE;
-
-    if (byMode == 1) {
-        //bResult=CARDbStopTxPacket(pDevice, PKT_TYPE_802_11_ALL);
-        pDevice->bStopDataPkt = TRUE;
-    }
-	return bResult;
-}
-
-
-
-
-
-
diff --git a/drivers/staging/vt6656/card.h b/drivers/staging/vt6656/card.h
index 0668a2d..2959308 100644
--- a/drivers/staging/vt6656/card.h
+++ b/drivers/staging/vt6656/card.h
@@ -81,9 +81,4 @@ BOOL CARDbRadioPowerOn(void *pDeviceHandler);
 BYTE CARDbyGetPktType(void *pDeviceHandler);
 void CARDvSetBSSMode(void *pDeviceHandler);
 
-BOOL CARDbChannelSwitch(void *pDeviceHandler,
-			BYTE byMode,
-			BYTE byNewChannel,
-			BYTE byCount);
-
 #endif /* __CARD_H__ */
-- 
1.7.4.4

