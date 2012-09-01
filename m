Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755324Ab2IAJSQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Sep 2012 05:18:16 -0400
Received: from gn237.zone.eu ([217.146.67.237]:54742 "EHLO gn237.zone.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753396Ab2IAJRL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Sep 2012 05:17:11 -0400
From: Priit Laes <plaes@plaes.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Priit Laes <plaes@plaes.org>
Subject: [PATCH 04/14] staging: csr: netdev.c: Clean up KERNEL_VERSION checks: 2.6.29
Date: Sat,  1 Sep 2012 12:06:00 +0300
Message-Id: <1346490370-32438-5-git-send-email-plaes@plaes.org>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <1346490370-32438-1-git-send-email-plaes@plaes.org>
References: <1346490370-32438-1-git-send-email-plaes@plaes.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Priit Laes <plaes@plaes.org>
---
 drivers/staging/csr/netdev.c | 27 ---------------------------
 1 file changed, 27 deletions(-)

diff --git a/drivers/staging/csr/netdev.c b/drivers/staging/csr/netdev.c
index 6a5a483..763edfc 100644
--- a/drivers/staging/csr/netdev.c
+++ b/drivers/staging/csr/netdev.c
@@ -163,7 +163,6 @@ struct uf_tx_packet_data {
 
 #endif /* CONFIG_NET_SCHED */
 
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,29)
 static const struct net_device_ops uf_netdev_ops =
 {
     .ndo_open = uf_net_open,
@@ -174,7 +173,6 @@ static const struct net_device_ops uf_netdev_ops =
     .ndo_set_rx_mode = uf_set_multicast_list,
     .ndo_select_queue = uf_net_select_queue,
 };
-#endif
 
 static u8 oui_rfc1042[P80211_OUI_LEN] = { 0x00, 0x00, 0x00 };
 static u8 oui_8021h[P80211_OUI_LEN]   = { 0x00, 0x00, 0xf8 };
@@ -258,20 +256,7 @@ uf_alloc_netdevice(CsrSdioFunction *sdio_dev, int bus_id)
     priv->interfacePriv[0] = interfacePriv;
 
     /* Setup / override net_device fields */
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,29)
     dev->netdev_ops = &uf_netdev_ops;
-#else
-    dev->open             = uf_net_open;
-    dev->stop             = uf_net_stop;
-    dev->hard_start_xmit  = uf_net_xmit;
-    dev->do_ioctl         = uf_net_ioctl;
-
-    /* called by /proc/net/dev */
-    dev->get_stats = uf_net_get_stats;
-
-    dev->set_multicast_list = uf_set_multicast_list;
-    dev->select_queue       = uf_net_select_queue;
-#endif
 
 #ifdef CSR_SUPPORT_WEXT
     dev->wireless_handlers = &unifi_iw_handler_def;
@@ -505,19 +490,7 @@ uf_alloc_netdevice_for_other_interfaces(unifi_priv_t *priv, u16 interfaceTag)
     INIT_LIST_HEAD(&interfacePriv->rx_controlled_list);
 
     /* Setup / override net_device fields */
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,29)
     dev->netdev_ops = &uf_netdev_ops;
-#else
-    dev->open             = uf_net_open;
-    dev->stop             = uf_net_stop;
-    dev->hard_start_xmit  = uf_net_xmit;
-    dev->do_ioctl         = uf_net_ioctl;
-
-    /* called by /proc/net/dev */
-    dev->get_stats = uf_net_get_stats;
-
-    dev->set_multicast_list = uf_set_multicast_list;
-#endif
 
 #ifdef CSR_SUPPORT_WEXT
     dev->wireless_handlers = &unifi_iw_handler_def;
-- 
1.7.12

