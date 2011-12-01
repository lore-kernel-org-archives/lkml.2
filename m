Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756408Ab1LBB7Y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Dec 2011 20:59:24 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:62198 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756335Ab1LBB7X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Dec 2011 20:59:23 -0500
From: Marcos Paulo de Souza <marcos.mage@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Marcos Paulo de Souza <marcos.mage@gmail.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Greg Kroah-Hartman <gregkh@susse.de>,
        Forest Bond <forest@alittletooquiet.net>, devel@driverdev.osuosl.org
Subject: [PATCH 1/5] staging: vt6656: datarate.c: Use memset instead a for loop
Date: Thu,  1 Dec 2011 23:58:35 +0000
Message-Id: <1322783915-19570-1-git-send-email-marcos.mage@gmail.com>
X-Mailer: git-send-email 1.7.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As Dan Carpenteder suggested, this makes the atribution more simple.

Signed-off-by: Marcos Paulo de Souza <marcos.mage@gmail.com>
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Greg Kroah-Hartman <gregkh@susse.de>
Cc: Forest Bond <forest@alittletooquiet.net>
Cc: devel@driverdev.osuosl.org
---
 drivers/staging/vt6656/datarate.c |    9 ++-------
 1 files changed, 2 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/vt6656/datarate.c b/drivers/staging/vt6656/datarate.c
index 5c2719f..58ca0d4 100644
--- a/drivers/staging/vt6656/datarate.c
+++ b/drivers/staging/vt6656/datarate.c
@@ -69,13 +69,8 @@ void s_vResetCounter(PKnownNodeDB psNodeDBTable);
 
 void s_vResetCounter(PKnownNodeDB psNodeDBTable)
 {
-    BYTE            ii;
-
-    // clear statistic counter for auto_rate
-    for (ii = 0; ii <= MAX_RATE; ii++) {
-        psNodeDBTable->uTxOk[ii] = 0;
-        psNodeDBTable->uTxFail[ii] = 0;
-    }
+	memset(psNodeDBTable->uTxOk, 0, sizeof(psNodeDBTable->uTxOk));
+	memset(psNodeDBTable->uTxFail, 0, sizeof(psNodeDBTable->uTxFail));
 }
 
 /*---------------------  Export Variables  --------------------------*/
-- 
1.7.4.4

