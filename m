Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753601Ab0ISJ3k (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Sep 2010 05:29:40 -0400
Received: from filtteri2.pp.htv.fi ([213.243.153.185]:58098 "EHLO
	filtteri2.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752343Ab0ISJ2q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Sep 2010 05:28:46 -0400
From: Pekka Enberg <penberg@kernel.org>
To: gregkh@suse.de
Cc: linux-kernel@vger.kernel.org, Pekka Enberg <penberg@kernel.org>,
        Lars Lindley <lindley@coyote.org>, Pavel Machek <pavel@ucw.cz>,
        Ruslan Pisarev <ruslan@rpisarev.org.ua>
Subject: [PATCH 6/7] w35und: Remove unused spinlocks
Date: Sun, 19 Sep 2010 12:28:42 +0300
Message-Id: <1284888523-9625-6-git-send-email-penberg@kernel.org>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1284888523-9625-5-git-send-email-penberg@kernel.org>
References: <1284888523-9625-1-git-send-email-penberg@kernel.org>
 <1284888523-9625-2-git-send-email-penberg@kernel.org>
 <1284888523-9625-3-git-send-email-penberg@kernel.org>
 <1284888523-9625-4-git-send-email-penberg@kernel.org>
 <1284888523-9625-5-git-send-email-penberg@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes unused spinlocks from "struct mlme_frame" and "struct
wbsoft_priv".

Cc: Lars Lindley <lindley@coyote.org>
Cc: Pavel Machek <pavel@ucw.cz>
Cc: Ruslan Pisarev <ruslan@rpisarev.org.ua>
Signed-off-by: Pekka Enberg <penberg@kernel.org>
---
 drivers/staging/winbond/core.h  |    5 -----
 drivers/staging/winbond/wbusb.c |    2 --
 2 files changed, 0 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/winbond/core.h b/drivers/staging/winbond/core.h
index 294d371..333b197 100644
--- a/drivers/staging/winbond/core.h
+++ b/drivers/staging/winbond/core.h
@@ -1,7 +1,6 @@
 #ifndef __WINBOND_CORE_H
 #define __WINBOND_CORE_H
 
-#include <linux/spinlock.h>
 #include <linux/wireless.h>
 #include <linux/types.h>
 
@@ -21,8 +20,6 @@ struct mlme_frame {
 	u8		DataType;
 	u8		IsInUsed;
 
-	spinlock_t	MLMESpinLock;
-
 	u8		TxMMPDU[MAX_NUM_TX_MMPDU][MAX_MMPDU_SIZE];
 	u8		TxMMPDUInUse[(MAX_NUM_TX_MMPDU + 3) & ~0x03];
 
@@ -57,8 +54,6 @@ struct wbsoft_priv {
 	struct hw_data sHwData;	/*For HAL */
 	struct wb35_mds Mds;
 
-	spinlock_t SpinLock;
-
 	atomic_t ThreadCount;
 
 	u32 RxByteCount;
diff --git a/drivers/staging/winbond/wbusb.c b/drivers/staging/winbond/wbusb.c
index abaa05a..5419f4f 100644
--- a/drivers/staging/winbond/wbusb.c
+++ b/drivers/staging/winbond/wbusb.c
@@ -783,8 +783,6 @@ static int wb35_probe(struct usb_interface *intf,
 
 	priv = dev->priv;
 
-	spin_lock_init(&priv->SpinLock);
-
 	pWbUsb = &priv->sHwData.WbUsb;
 	pWbUsb->udev = udev;
 
-- 
1.6.3.3

