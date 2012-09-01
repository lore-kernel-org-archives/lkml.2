Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755456Ab2IAJTq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Sep 2012 05:19:46 -0400
Received: from gn237.zone.eu ([217.146.67.237]:54731 "EHLO gn237.zone.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753050Ab2IAJRJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Sep 2012 05:17:09 -0400
From: Priit Laes <plaes@plaes.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Priit Laes <plaes@plaes.org>
Subject: [PATCH 09/14] staging: csr: Drop unused UNIFI_NET_NAME configuration option
Date: Sat,  1 Sep 2012 12:06:05 +0300
Message-Id: <1346490370-32438-10-git-send-email-plaes@plaes.org>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <1346490370-32438-1-git-send-email-plaes@plaes.org>
References: <1346490370-32438-1-git-send-email-plaes@plaes.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Priit Laes <plaes@plaes.org>
---
 drivers/staging/csr/netdev.c | 19 ++-----------------
 1 file changed, 2 insertions(+), 17 deletions(-)

diff --git a/drivers/staging/csr/netdev.c b/drivers/staging/csr/netdev.c
index e304083..2548813 100644
--- a/drivers/staging/csr/netdev.c
+++ b/drivers/staging/csr/netdev.c
@@ -56,21 +56,6 @@
 #include <net/pkt_sched.h>
 
 
-#ifdef UNIFI_NET_NAME
-#define UF_ALLOC_NETDEV(_dev, _size, _name, _setup, _num_of_queues)     \
-    do {                                                                \
-        static char name[8];                                           \
-        sprintf(name, "%s%s", UNIFI_NET_NAME, _name);                   \
-        _dev = alloc_netdev_mq(_size, name, _setup, _num_of_queues);    \
-    } while (0);
-#else
-#define UF_ALLOC_NETDEV(_dev, _size, _name, _setup, _num_of_queues)     \
-    do {                                                                \
-        _dev = alloc_etherdev_mq(_size, _num_of_queues);                \
-    } while (0);
-#endif /* UNIFI_NET_NAME */
-
-
 /* Wext handler is suported only if CSR_SUPPORT_WEXT is defined */
 #ifdef CSR_SUPPORT_WEXT
 extern struct iw_handler_def unifi_iw_handler_def;
@@ -213,7 +198,7 @@ uf_alloc_netdevice(CsrSdioFunction *sdio_dev, int bus_id)
      * The RedHat 9 redhat-config-network tool doesn't recognise wlan* devices,
      * so use "eth*" (like other wireless extns drivers).
      */
-    UF_ALLOC_NETDEV(dev, sizeof(unifi_priv_t)+sizeof(netInterface_priv_t), "%d", ether_setup, UNIFI_TRAFFIC_Q_MAX);
+    dev = alloc_etherdev_mq(sizeof(unifi_priv_t) + sizeof(netInterface_priv_t), UNIFI_TRAFFIC_Q_MAX);
 
     if (dev == NULL) {
         return NULL;
@@ -438,7 +423,7 @@ uf_alloc_netdevice_for_other_interfaces(unifi_priv_t *priv, u16 interfaceTag)
      * The RedHat 9 redhat-config-network tool doesn't recognise wlan* devices,
      * so use "eth*" (like other wireless extns drivers).
      */
-    UF_ALLOC_NETDEV(dev, sizeof(netInterface_priv_t), "%d", ether_setup, 1);
+    dev = alloc_etherdev_mq(sizeof(netInterface_priv_t), 1);
     if (dev == NULL) {
         return FALSE;
     }
-- 
1.7.12

