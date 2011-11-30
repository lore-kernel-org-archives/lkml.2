Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757638Ab1K3CUh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Nov 2011 21:20:37 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:40947 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932092Ab1K3CUd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Nov 2011 21:20:33 -0500
From: Marcos Paulo de Souza <marcos.mage@gmail.com>
To: gregkh@suse.de
Cc: forest@alittletooquiet.net, driver@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org,
        Marcos Paulo de Souza <marcos.mage@gmail.com>
Subject: [PATCH 5/5] staging: vt6656: card.c: Change return of CARDbAddBasicRate to void
Date: Wed, 30 Nov 2011 00:19:44 -0200
Message-Id: <1322619584-10218-1-git-send-email-marcos.mage@gmail.com>
X-Mailer: git-send-email 1.7.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In all locations that call this function ignore your returna, so remove
it.

Signed-off-by: Marcos Paulo de Souza <marcos.mage@gmail.com>

Cc: Greg kroah-Hartman <gregkh@suse.de>
Cc: Forest Bond <forest@alittletooquiet.net>
Cc: driver@driverdev.osuosl.org
---
 drivers/staging/vt6656/card.c |    4 +---
 drivers/staging/vt6656/card.h |    2 +-
 2 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/vt6656/card.c b/drivers/staging/vt6656/card.c
index a49053b..1574e8e 100644
--- a/drivers/staging/vt6656/card.c
+++ b/drivers/staging/vt6656/card.c
@@ -607,7 +607,7 @@ BYTE ii;
  * Return Value: TRUE if succeeded; FALSE if failed.
  *
  */
-BOOL CARDbAddBasicRate(void *pDeviceHandler, WORD wRateIdx)
+void CARDbAddBasicRate(void *pDeviceHandler, WORD wRateIdx)
 {
 PSDevice    pDevice = (PSDevice) pDeviceHandler;
 WORD wRate = (WORD)(1<<wRateIdx);
@@ -616,8 +616,6 @@ WORD wRate = (WORD)(1<<wRateIdx);
 
     //Determines the highest basic rate.
     CARDvUpdateBasicTopRate(pDevice);
-
-    return(TRUE);
 }
 
 BOOL CARDbIsOFDMinBasicRate(void *pDeviceHandler)
diff --git a/drivers/staging/vt6656/card.h b/drivers/staging/vt6656/card.h
index 6c91343..c579570 100644
--- a/drivers/staging/vt6656/card.h
+++ b/drivers/staging/vt6656/card.h
@@ -65,7 +65,7 @@ BOOL CARDbSetMediaChannel(void *pDeviceHandler,
 void CARDvSetRSPINF(void *pDeviceHandler, BYTE byBBType);
 void vUpdateIFS(void *pDeviceHandler);
 void CARDvUpdateBasicTopRate(void *pDeviceHandler);
-BOOL CARDbAddBasicRate(void *pDeviceHandler, WORD wRateIdx);
+void CARDbAddBasicRate(void *pDeviceHandler, WORD wRateIdx);
 BOOL CARDbIsOFDMinBasicRate(void *pDeviceHandler);
 void CARDvAdjustTSF(void *pDeviceHandler, BYTE byRxRate,
 		    QWORD qwBSSTimestamp, QWORD qwLocalTSF);
-- 
1.7.4.4

