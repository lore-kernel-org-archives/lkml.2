Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755294Ab2IAJT3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Sep 2012 05:19:29 -0400
Received: from gn237.zone.eu ([217.146.67.237]:54733 "EHLO gn237.zone.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753102Ab2IAJRK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Sep 2012 05:17:10 -0400
From: Priit Laes <plaes@plaes.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Priit Laes <plaes@plaes.org>
Subject: [PATCH 05/14] staging: csr: netdev.c: Clean up KERNEL_VERSION checks: 2.6.32
Date: Sat,  1 Sep 2012 12:06:01 +0300
Message-Id: <1346490370-32438-6-git-send-email-plaes@plaes.org>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <1346490370-32438-1-git-send-email-plaes@plaes.org>
References: <1346490370-32438-1-git-send-email-plaes@plaes.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Priit Laes <plaes@plaes.org>
---
 drivers/staging/csr/netdev.c | 14 --------------
 1 file changed, 14 deletions(-)

diff --git a/drivers/staging/csr/netdev.c b/drivers/staging/csr/netdev.c
index 763edfc..52fd5ea 100644
--- a/drivers/staging/csr/netdev.c
+++ b/drivers/staging/csr/netdev.c
@@ -101,17 +101,7 @@ static int uf_net_ioctl(struct net_device *dev, struct ifreq *rq, int cmd);
 static int uf_net_stop(struct net_device *dev);
 static struct net_device_stats *uf_net_get_stats(struct net_device *dev);
 static u16 uf_net_select_queue(struct net_device *dev, struct sk_buff *skb);
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,32)
 static netdev_tx_t uf_net_xmit(struct sk_buff *skb, struct net_device *dev);
-#else
-static int uf_net_xmit(struct sk_buff *skb, struct net_device *dev);
-#ifndef NETDEV_TX_OK
-#define NETDEV_TX_OK        0
-#endif
-#ifndef NETDEV_TX_BUSY
-#define NETDEV_TX_BUSY      1
-#endif
-#endif
 static void uf_set_multicast_list(struct net_device *dev);
 
 
@@ -1793,11 +1783,7 @@ send_ma_pkt_request(unifi_priv_t *priv, struct sk_buff *skb, const struct ethhdr
  *      The controlled port is handled in the qdisc dequeue handler.
  * ---------------------------------------------------------------------------
  */
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,32)
 static netdev_tx_t
-#else
-static int
-#endif
 uf_net_xmit(struct sk_buff *skb, struct net_device *dev)
 {
     netInterface_priv_t *interfacePriv = (netInterface_priv_t *)netdev_priv(dev);
-- 
1.7.12

