Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754037Ab0KAU3k (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Nov 2010 16:29:40 -0400
Received: from filtteri1.pp.htv.fi ([213.243.153.184]:36548 "EHLO
	filtteri1.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753436Ab0KAU3d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Nov 2010 16:29:33 -0400
From: Pekka Enberg <penberg@kernel.org>
To: gregkh@suse.de
Cc: linux-kernel@vger.kernel.org, Pekka Enberg <penberg@kernel.org>,
        Pavel Machek <pavel@ucw.cz>
Subject: [PATCH 1/4] w35und: Kill empty Mds_Destroy function
Date: Mon,  1 Nov 2010 22:29:28 +0200
Message-Id: <1288643371-10310-1-git-send-email-penberg@kernel.org>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Mds_Destroy() function doesn't do anything so kill it.

Cc: Pavel Machek <pavel@ucw.cz>
Signed-off-by: Pekka Enberg <penberg@kernel.org>
---
 drivers/staging/winbond/mds.c   |    5 -----
 drivers/staging/winbond/mds_f.h |    1 -
 drivers/staging/winbond/wbusb.c |    2 --
 3 files changed, 0 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/winbond/mds.c b/drivers/staging/winbond/mds.c
index 9ac2c87..90f2cc0 100644
--- a/drivers/staging/winbond/mds.c
+++ b/drivers/staging/winbond/mds.c
@@ -18,11 +18,6 @@ Mds_initial(struct wbsoft_priv *adapter)
 	return hal_get_tx_buffer(&adapter->sHwData, &pMds->pTxBuffer);
 }
 
-void
-Mds_Destroy(struct wbsoft_priv *adapter)
-{
-}
-
 static void Mds_DurationSet(struct wbsoft_priv *adapter,  struct wb35_descriptor *pDes,  u8 *buffer)
 {
 	struct T00_descriptor *pT00;
diff --git a/drivers/staging/winbond/mds_f.h b/drivers/staging/winbond/mds_f.h
index d902843..ce8be07 100644
--- a/drivers/staging/winbond/mds_f.h
+++ b/drivers/staging/winbond/mds_f.h
@@ -5,7 +5,6 @@
 #include "core.h"
 
 unsigned char Mds_initial(struct wbsoft_priv *adapter);
-void Mds_Destroy(struct wbsoft_priv *adapter);
 void Mds_Tx(struct wbsoft_priv *adapter);
 void Mds_SendComplete(struct wbsoft_priv *adapter, struct T02_descriptor *pt02);
 void Mds_MpduProcess(struct wbsoft_priv *adapter, struct wb35_descriptor *prxdes);
diff --git a/drivers/staging/winbond/wbusb.c b/drivers/staging/winbond/wbusb.c
index df055ab..82040f4 100644
--- a/drivers/staging/winbond/wbusb.c
+++ b/drivers/staging/winbond/wbusb.c
@@ -863,8 +863,6 @@ static void hal_halt(struct hw_data *pHwData)
 
 static void wb35_hw_halt(struct wbsoft_priv *adapter)
 {
-	Mds_Destroy(adapter);
-
 	/* Turn off Rx and Tx hardware ability */
 	hal_stop(&adapter->sHwData);
 #ifdef _PE_USB_INI_DUMP_
-- 
1.7.0.4

