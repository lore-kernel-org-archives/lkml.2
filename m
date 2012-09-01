Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755333Ab2IAJRS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Sep 2012 05:17:18 -0400
Received: from gn237.zone.eu ([217.146.67.237]:54749 "EHLO gn237.zone.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753522Ab2IAJRM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Sep 2012 05:17:12 -0400
From: Priit Laes <plaes@plaes.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Priit Laes <plaes@plaes.org>
Subject: [PATCH 12/14] staging: csr: unifi_priv.h: Remove KERNEL_VERSION checks
Date: Sat,  1 Sep 2012 12:06:08 +0300
Message-Id: <1346490370-32438-13-git-send-email-plaes@plaes.org>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <1346490370-32438-1-git-send-email-plaes@plaes.org>
References: <1346490370-32438-1-git-send-email-plaes@plaes.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Priit Laes <plaes@plaes.org>
---
 drivers/staging/csr/unifi_priv.h | 27 ---------------------------
 1 file changed, 27 deletions(-)

diff --git a/drivers/staging/csr/unifi_priv.h b/drivers/staging/csr/unifi_priv.h
index 1dee840..f634b31 100644
--- a/drivers/staging/csr/unifi_priv.h
+++ b/drivers/staging/csr/unifi_priv.h
@@ -29,9 +29,7 @@
 #include <linux/wireless.h>
 #include <linux/cdev.h>
 #include <linux/kthread.h>
-#if LINUX_VERSION_CODE > KERNEL_VERSION(2,6,19)
 #include <linux/freezer.h>
-#endif
 
 #ifdef CSR_WIFI_SUPPORT_MMC_DRIVER
 #include <linux/mmc/core.h>
@@ -73,31 +71,9 @@ extern struct wake_lock unifi_sdio_wake_lock;
 
 #include "unifi_clients.h"
 
-
-#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,20)
-#include <linux/workqueue.h>
-
-#undef INIT_WORK
-#define INIT_WORK(_work, _func)                                         \
-    do {                                                                \
-        INIT_LIST_HEAD(&(_work)->entry);                                \
-        (_work)->pending = 0;                                           \
-        PREPARE_WORK((_work), (_func), (_work));                        \
-        init_timer(&(_work)->timer);                                    \
-    } while(0)
-
-#endif  /* Linux kernel < 2.6.20 */
-
-
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,27)
 #define UF_NETIF_TX_WAKE_ALL_QUEUES(_netdev)    netif_tx_wake_all_queues(_netdev)
 #define UF_NETIF_TX_START_ALL_QUEUES(_netdev)   netif_tx_start_all_queues(_netdev)
 #define UF_NETIF_TX_STOP_ALL_QUEUES(_netdev)    netif_tx_stop_all_queues(_netdev)
-#else
-#define UF_NETIF_TX_WAKE_ALL_QUEUES(_netdev)    netif_wake_queue(_netdev)
-#define UF_NETIF_TX_START_ALL_QUEUES(_netdev)   netif_start_queue(_netdev)
-#define UF_NETIF_TX_STOP_ALL_QUEUES(_netdev)    netif_stop_queue(_netdev)
-#endif  /* Linux kernel >= 2.6.27 */
 
 
 #ifdef CSR_NATIVE_LINUX
@@ -1080,9 +1056,6 @@ CsrWifiRouterCtrlStaInfo_t * CsrWifiRouterCtrlGetStationRecordFromHandle(unifi_p
 void uf_update_sta_activity(unifi_priv_t *priv, u16 interfaceTag, const u8 *peerMacAddress);
 void uf_process_ma_pkt_cfm_for_ap(unifi_priv_t *priv,u16 interfaceTag, const CSR_MA_PACKET_CONFIRM *pkt_cfm);
 #endif
-#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,28)
-int uf_install_qdisc(struct net_device *dev);
-#endif
 
 void uf_resume_data_plane(unifi_priv_t *priv, int queue,
                           CsrWifiMacAddress peer_address,
-- 
1.7.12

