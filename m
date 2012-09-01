Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755240Ab2IAJRR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Sep 2012 05:17:17 -0400
Received: from gn237.zone.eu ([217.146.67.237]:54748 "EHLO gn237.zone.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753548Ab2IAJRM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Sep 2012 05:17:12 -0400
From: Priit Laes <plaes@plaes.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Priit Laes <plaes@plaes.org>
Subject: [PATCH 06/14] staging: csr: netdev.c: Clean up KERNEL_VERSION checks: 2.6.34
Date: Sat,  1 Sep 2012 12:06:02 +0300
Message-Id: <1346490370-32438-7-git-send-email-plaes@plaes.org>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <1346490370-32438-1-git-send-email-plaes@plaes.org>
References: <1346490370-32438-1-git-send-email-plaes@plaes.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Priit Laes <plaes@plaes.org>
---
 drivers/staging/csr/netdev.c | 25 -------------------------
 1 file changed, 25 deletions(-)

diff --git a/drivers/staging/csr/netdev.c b/drivers/staging/csr/netdev.c
index 52fd5ea..e41d516 100644
--- a/drivers/staging/csr/netdev.c
+++ b/drivers/staging/csr/netdev.c
@@ -2809,19 +2809,13 @@ uf_set_multicast_list(struct net_device *dev)
 #else
 
     u8 *mc_list = interfacePriv->mc_list;
-#if LINUX_VERSION_CODE > KERNEL_VERSION(2,6,34)
     struct netdev_hw_addr *mc_addr;
     int mc_addr_count;
-#else
-    struct dev_mc_list *p;      /* Pointer to the addresses structure. */
-    int i;
-#endif
 
     if (priv->init_progress != UNIFI_INIT_COMPLETED) {
         return;
     }
 
-#if LINUX_VERSION_CODE > KERNEL_VERSION(2,6,34)
     mc_addr_count = netdev_mc_count(dev);
 
     unifi_trace(priv, UDBG3,
@@ -2840,25 +2834,6 @@ uf_set_multicast_list(struct net_device *dev)
         mc_list += ETH_ALEN;
     }
 
-#else
-    unifi_trace(priv, UDBG3,
-            "uf_set_multicast_list (count=%d)\n", dev->mc_count);
-
-    /* Not enough space? */
-    if (dev->mc_count > UNIFI_MAX_MULTICAST_ADDRESSES) {
-        return;
-    }
-
-    /* Store the list to be processed by the work item. */
-    interfacePriv->mc_list_count = dev->mc_count;
-    p = dev->mc_list;
-    for (i = 0; i < dev->mc_count; i++) {
-        memcpy(mc_list, p->dmi_addr, ETH_ALEN);
-        p = p->next;
-        mc_list += ETH_ALEN;
-    }
-#endif
-
     /* Send a message to the workqueue */
     queue_work(priv->unifi_workqueue, &priv->multicast_list_task);
 #endif
-- 
1.7.12

