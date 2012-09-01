Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753471Ab2IAJRL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Sep 2012 05:17:11 -0400
Received: from gn237.zone.eu ([217.146.67.237]:54698 "EHLO gn237.zone.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752855Ab2IAJRI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Sep 2012 05:17:08 -0400
From: Priit Laes <plaes@plaes.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Priit Laes <plaes@plaes.org>
Subject: [PATCH 07/14] staging: csr: netdev.c: Clean up KERNEL_VERSION checks: 2.6.37
Date: Sat,  1 Sep 2012 12:06:03 +0300
Message-Id: <1346490370-32438-8-git-send-email-plaes@plaes.org>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <1346490370-32438-1-git-send-email-plaes@plaes.org>
References: <1346490370-32438-1-git-send-email-plaes@plaes.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Priit Laes <plaes@plaes.org>
---
 drivers/staging/csr/netdev.c | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/drivers/staging/csr/netdev.c b/drivers/staging/csr/netdev.c
index e41d516..4f6f48c 100644
--- a/drivers/staging/csr/netdev.c
+++ b/drivers/staging/csr/netdev.c
@@ -339,21 +339,13 @@ uf_alloc_netdevice(CsrSdioFunction *sdio_dev, int bus_id)
     interfacePriv->connected = UnifiConnectedUnknown;  /* -1 unknown, 0 no, 1 yes */
 
 #ifdef USE_DRIVER_LOCK
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2, 6, 37)
     sema_init(&priv->lock, 1);
-#else
-    init_MUTEX(&priv->lock);
-#endif
 #endif /* USE_DRIVER_LOCK */
 
     spin_lock_init(&priv->send_signal_lock);
 
     spin_lock_init(&priv->m4_lock);
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2, 6, 37)
     sema_init(&priv->ba_mutex, 1);
-#else
-    init_MUTEX(&priv->ba_mutex);
-#endif
 
 #if (defined(CSR_WIFI_SECURITY_WAPI_ENABLE) && defined(CSR_WIFI_SECURITY_WAPI_SW_ENCRYPTION))
     spin_lock_init(&priv->wapi_lock);
-- 
1.7.12

