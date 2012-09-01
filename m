Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755292Ab2IAJTp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Sep 2012 05:19:45 -0400
Received: from gn237.zone.eu ([217.146.67.237]:54732 "EHLO gn237.zone.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753067Ab2IAJRJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Sep 2012 05:17:09 -0400
From: Priit Laes <plaes@plaes.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Priit Laes <plaes@plaes.org>
Subject: [PATCH 08/14] staging: csr: remove unused define ALLOW_Q_PAUSE
Date: Sat,  1 Sep 2012 12:06:04 +0300
Message-Id: <1346490370-32438-9-git-send-email-plaes@plaes.org>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <1346490370-32438-1-git-send-email-plaes@plaes.org>
References: <1346490370-32438-1-git-send-email-plaes@plaes.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Priit Laes <plaes@plaes.org>
---
 drivers/staging/csr/netdev.c     | 11 -----------
 drivers/staging/csr/unifi_priv.h |  8 --------
 2 files changed, 19 deletions(-)

diff --git a/drivers/staging/csr/netdev.c b/drivers/staging/csr/netdev.c
index 4f6f48c..e304083 100644
--- a/drivers/staging/csr/netdev.c
+++ b/drivers/staging/csr/netdev.c
@@ -56,17 +56,6 @@
 #include <net/pkt_sched.h>
 
 
-/* ALLOW_Q_PAUSE: Pre 2.6.28 kernels do not support multiple driver queues (required for QoS).
- * In order to support QoS in these kernels, multiple queues are implemented in the driver. But since
- * there is only a single queue in the kernel (leading to multiple queues in the driver) there is no possibility
- * of stopping a particular queue in the kernel. Stopping the single kernel queue leads to undesirable starvation
- * of driver queues. One of the proposals is to not stop the kernel queue but to prevent dequeuing from the
- * 'stopped' driver queue. Allow q pause is an experimental implementation of this scheme for pre 2.6.28 kernels.
- * When NOT defined, queues are paused locally in the driver and packets are dequeued for transmission only from the
- * unpaused queues. When Allow q pause is defined the kernel queue is stopped whenever any driver queue is paused.
- */
-#define ALLOW_Q_PAUSE
-
 #ifdef UNIFI_NET_NAME
 #define UF_ALLOC_NETDEV(_dev, _size, _name, _setup, _num_of_queues)     \
     do {                                                                \
diff --git a/drivers/staging/csr/unifi_priv.h b/drivers/staging/csr/unifi_priv.h
index 6d6b461..1dee840 100644
--- a/drivers/staging/csr/unifi_priv.h
+++ b/drivers/staging/csr/unifi_priv.h
@@ -634,12 +634,10 @@ struct unifi_priv {
     spinlock_t wapi_lock;
 #endif
 
-#ifndef ALLOW_Q_PAUSE
     /* Array to indicate if a particular Tx queue is paused, this may not be
      * required in a multiqueue implementation since we can directly stop kernel
      * queues */
     u8 tx_q_paused_flag[UNIFI_TRAFFIC_Q_MAX];
-#endif
 
 #ifdef CSR_WIFI_RX_PATH_SPLIT
     struct workqueue_struct *rx_workqueue;
@@ -798,12 +796,6 @@ typedef struct netInterface_priv
     u8 bcTimSetReqQueued;
 } netInterface_priv_t;
 
-#ifndef ALLOW_Q_PAUSE
-#define net_is_tx_q_paused(priv, q)   (priv->tx_q_paused_flag[q])
-#define net_tx_q_unpause(priv, q)   (priv->tx_q_paused_flag[q] = 0)
-#define net_tx_q_pause(priv, q)   (priv->tx_q_paused_flag[q] = 1)
-#endif
-
 #ifdef CSR_SUPPORT_SME
 #define routerStartBuffering(priv,queue) priv->routerBufferEnable[(queue)] = TRUE;
 #define routerStopBuffering(priv,queue) priv->routerBufferEnable[(queue)]  = FALSE;
-- 
1.7.12

