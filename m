Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754074Ab1LTDGk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Dec 2011 22:06:40 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:53057 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752152Ab1LTDGi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Dec 2011 22:06:38 -0500
From: Marcos Paulo de Souza <marcos.mage@gmail.com>
To: gregkh@suse.de
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Marcos Paulo de Souza <marcos.mage@gmail.com>
Subject: [PATCH 1/2] staging: vt6656: int.c, int.h: Change return of function to void
Date: Tue, 20 Dec 2011 01:07:00 +0000
Message-Id: <1324343220-28620-1-git-send-email-marcos.mage@gmail.com>
X-Mailer: git-send-email 1.7.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes the int return of function INTnsProcessData, because
nobody uses this return.

Signed-off-by: Marcos Paulo de Souza <marcos.mage@gmail.com>
---
 drivers/staging/vt6656/int.c |    5 +----
 drivers/staging/vt6656/int.h |    2 +-
 2 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/vt6656/int.c b/drivers/staging/vt6656/int.c
index c95833a..0a11423 100644
--- a/drivers/staging/vt6656/int.c
+++ b/drivers/staging/vt6656/int.c
@@ -92,9 +92,8 @@ void INTvWorkItem(void *Context)
 	spin_unlock_irq(&pDevice->lock);
 }
 
-int INTnsProcessData(PSDevice pDevice)
+void INTnsProcessData(PSDevice pDevice)
 {
-	int status = STATUS_SUCCESS;
 	PSINTData	pINTData;
 	PSMgmtObject	pMgmt = &(pDevice->sMgmtObj);
 	struct net_device_stats *pStats = &pDevice->stats;
@@ -218,6 +217,4 @@ int INTnsProcessData(PSDevice pDevice)
 			pDevice->scStatistic.ullTxBroadcastBytes;
 	pStats->tx_errors = pDevice->scStatistic.dwTsrErr;
 	pStats->tx_dropped = pDevice->scStatistic.dwTsrErr;
-
-	return status;
 }
diff --git a/drivers/staging/vt6656/int.h b/drivers/staging/vt6656/int.h
index 3176c8d..a5d96b9 100644
--- a/drivers/staging/vt6656/int.h
+++ b/drivers/staging/vt6656/int.h
@@ -68,6 +68,6 @@ SINTData, *PSINTData;
 /*---------------------  Export Functions  --------------------------*/
 
 void INTvWorkItem(void *Context);
-int INTnsProcessData(PSDevice pDevice);
+void INTnsProcessData(PSDevice pDevice);
 
 #endif /* __INT_H__ */
-- 
1.7.4.4

