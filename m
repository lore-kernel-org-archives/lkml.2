Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755467Ab2IAJSr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Sep 2012 05:18:47 -0400
Received: from gn237.zone.eu ([217.146.67.237]:54734 "EHLO gn237.zone.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753074Ab2IAJRK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Sep 2012 05:17:10 -0400
From: Priit Laes <plaes@plaes.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Priit Laes <plaes@plaes.org>
Subject: [PATCH 13/14] staging: csr: Remove unneeded UF_NETIF_TX_* macros
Date: Sat,  1 Sep 2012 12:06:09 +0300
Message-Id: <1346490370-32438-14-git-send-email-plaes@plaes.org>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <1346490370-32438-1-git-send-email-plaes@plaes.org>
References: <1346490370-32438-1-git-send-email-plaes@plaes.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Priit Laes <plaes@plaes.org>
---
 drivers/staging/csr/io.c          | 2 +-
 drivers/staging/csr/netdev.c      | 6 +++---
 drivers/staging/csr/sdio_events.c | 4 ++--
 drivers/staging/csr/sme_sys.c     | 6 +++---
 drivers/staging/csr/unifi_priv.h  | 5 -----
 5 files changed, 9 insertions(+), 14 deletions(-)

diff --git a/drivers/staging/csr/io.c b/drivers/staging/csr/io.c
index e6503d96..75b4671 100644
--- a/drivers/staging/csr/io.c
+++ b/drivers/staging/csr/io.c
@@ -669,7 +669,7 @@ unregister_unifi_sdio(int bus_id)
         if(interfacePriv->netdev_registered)
         {
             netif_carrier_off(priv->netdev[interfaceTag]);
-            UF_NETIF_TX_STOP_ALL_QUEUES(priv->netdev[interfaceTag]);
+            netif_tx_stop_all_queues(priv->netdev[interfaceTag]);
         }
     }
 
diff --git a/drivers/staging/csr/netdev.c b/drivers/staging/csr/netdev.c
index 2548813..a1abda1 100644
--- a/drivers/staging/csr/netdev.c
+++ b/drivers/staging/csr/netdev.c
@@ -614,7 +614,7 @@ uf_net_open(struct net_device *dev)
     }
 #endif
 
-    UF_NETIF_TX_START_ALL_QUEUES(dev);
+    netif_tx_start_all_queues(dev);
 
     func_exit();
     return 0;
@@ -644,7 +644,7 @@ uf_net_stop(struct net_device *dev)
     func_enter();
 #endif
 
-    UF_NETIF_TX_STOP_ALL_QUEUES(dev);
+    netif_tx_stop_all_queues(dev);
 
     func_exit();
     return 0;
@@ -2978,7 +2978,7 @@ uf_netdev_event(struct notifier_block *notif, unsigned long event, void* ptr) {
                     interfacePriv->wait_netdev_change ? "" : "not");
 
         if (interfacePriv->wait_netdev_change) {
-            UF_NETIF_TX_WAKE_ALL_QUEUES(priv->netdev[interfacePriv->InterfaceTag]);
+            netif_tx_wake_all_queues(priv->netdev[interfacePriv->InterfaceTag]);
             interfacePriv->connected = UnifiConnected;
             interfacePriv->wait_netdev_change = FALSE;
             /* Note: passing the broadcast address here will allow anyone to attempt to join our adhoc network */
diff --git a/drivers/staging/csr/sdio_events.c b/drivers/staging/csr/sdio_events.c
index 6892c2e..2a80b9e 100644
--- a/drivers/staging/csr/sdio_events.c
+++ b/drivers/staging/csr/sdio_events.c
@@ -66,7 +66,7 @@ void unifi_suspend(void *ospriv)
                 unifi_trace(priv, UDBG1, "unifi_suspend: netif_carrier_off");
                 netif_carrier_off(priv->netdev[interfaceTag]);
             }
-            UF_NETIF_TX_STOP_ALL_QUEUES(priv->netdev[interfaceTag]);
+            netif_tx_stop_all_queues(priv->netdev[interfaceTag]);
         }
     }
 
@@ -119,7 +119,7 @@ void unifi_resume(void *ospriv)
             if (interfacePriv->netdev_registered == 1)
             {
                 netif_carrier_on(priv->netdev[interfaceTag]);
-                UF_NETIF_TX_START_ALL_QUEUES(priv->netdev[interfaceTag]);
+                netif_tx_start_all_queues(priv->netdev[interfaceTag]);
             }
         }
 
diff --git a/drivers/staging/csr/sme_sys.c b/drivers/staging/csr/sme_sys.c
index 99de27e..f701ce3 100644
--- a/drivers/staging/csr/sme_sys.c
+++ b/drivers/staging/csr/sme_sys.c
@@ -192,7 +192,7 @@ void CsrWifiRouterCtrlMediaStatusReqHandler(void* drvpriv, CsrWifiFsmEvent* msg)
 #endif
                     unifi_trace(priv, UDBG1,
                                 "CsrWifiRouterCtrlMediaStatusReqHandler: AP/P2PGO setting netif_carrier_on\n");
-                    UF_NETIF_TX_WAKE_ALL_QUEUES(priv->netdev[req->interfaceTag]);
+                    netif_tx_wake_all_queues(priv->netdev[req->interfaceTag]);
                     break;
 
                 default:
@@ -226,7 +226,7 @@ void CsrWifiRouterCtrlMediaStatusReqHandler(void* drvpriv, CsrWifiFsmEvent* msg)
                     unifi_trace(priv, UDBG1,
                                 "CsrWifiRouterMediaStatusReqHandler: UnifiConnected && netif_carrier_on\n");
                     netif_carrier_on(priv->netdev[req->interfaceTag]);
-                    UF_NETIF_TX_WAKE_ALL_QUEUES(priv->netdev[req->interfaceTag]);
+                    netif_tx_wake_all_queues(priv->netdev[req->interfaceTag]);
                     uf_process_rx_pending_queue(priv, UF_UNCONTROLLED_PORT_Q, broadcast_address, 1, interfacePriv->InterfaceTag);
                     uf_process_rx_pending_queue(priv, UF_CONTROLLED_PORT_Q, broadcast_address, 1, interfacePriv->InterfaceTag);
                 }
@@ -955,7 +955,7 @@ void CsrWifiRouterCtrlWifiOffReqHandler(void* drvpriv, CsrWifiFsmEvent* msg)
         netInterface_priv_t *interfacePriv = priv->interfacePriv[i];
         if (interfacePriv->netdev_registered == 1) {
             netif_carrier_off(priv->netdev[i]);
-            UF_NETIF_TX_STOP_ALL_QUEUES(priv->netdev[i]);
+            netif_tx_stop_all_queues(priv->netdev[i]);
             interfacePriv->connected = UnifiConnectedUnknown;
         }
         interfacePriv->interfaceMode = 0;
diff --git a/drivers/staging/csr/unifi_priv.h b/drivers/staging/csr/unifi_priv.h
index f634b31..aec8e28 100644
--- a/drivers/staging/csr/unifi_priv.h
+++ b/drivers/staging/csr/unifi_priv.h
@@ -71,11 +71,6 @@ extern struct wake_lock unifi_sdio_wake_lock;
 
 #include "unifi_clients.h"
 
-#define UF_NETIF_TX_WAKE_ALL_QUEUES(_netdev)    netif_tx_wake_all_queues(_netdev)
-#define UF_NETIF_TX_START_ALL_QUEUES(_netdev)   netif_tx_start_all_queues(_netdev)
-#define UF_NETIF_TX_STOP_ALL_QUEUES(_netdev)    netif_tx_stop_all_queues(_netdev)
-
-
 #ifdef CSR_NATIVE_LINUX
 #include "sme_native/unifi_native.h"
 #else
-- 
1.7.12

