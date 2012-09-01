Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755436Ab2IAJSR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Sep 2012 05:18:17 -0400
Received: from gn237.zone.eu ([217.146.67.237]:54743 "EHLO gn237.zone.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753378Ab2IAJRL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Sep 2012 05:17:11 -0400
From: Priit Laes <plaes@plaes.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Priit Laes <plaes@plaes.org>
Subject: [PATCH 01/14] staging: csr: netdev.c: Clean up KERNEL_VERSION checks: <=2.6.25
Date: Sat,  1 Sep 2012 12:05:57 +0300
Message-Id: <1346490370-32438-2-git-send-email-plaes@plaes.org>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <1346490370-32438-1-git-send-email-plaes@plaes.org>
References: <1346490370-32438-1-git-send-email-plaes@plaes.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Priit Laes <plaes@plaes.org>
---
 drivers/staging/csr/netdev.c | 21 ---------------------
 1 file changed, 21 deletions(-)

diff --git a/drivers/staging/csr/netdev.c b/drivers/staging/csr/netdev.c
index 1e6e111..7b7d3fd 100644
--- a/drivers/staging/csr/netdev.c
+++ b/drivers/staging/csr/netdev.c
@@ -53,9 +53,6 @@
 #include "csr_wifi_hip_unifi.h"
 #include "csr_wifi_hip_conversions.h"
 #include "unifi_priv.h"
-#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,13)
-#include <net/iw_handler.h>
-#endif
 #include <net/pkt_sched.h>
 
 
@@ -189,13 +186,8 @@ static struct sk_buff *uf_qdiscop_dequeue(struct Qdisc* qd);
 static void uf_qdiscop_reset(struct Qdisc* qd);
 static void uf_qdiscop_destroy(struct Qdisc* qd);
 static int uf_qdiscop_dump(struct Qdisc *qd, struct sk_buff *skb);
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,25)
 static int uf_qdiscop_tune(struct Qdisc *qd, struct nlattr *opt);
 static int uf_qdiscop_init(struct Qdisc *qd, struct nlattr *opt);
-#else
-static int uf_qdiscop_tune(struct Qdisc *qd, struct rtattr *opt);
-static int uf_qdiscop_init(struct Qdisc *qd, struct rtattr *opt);
-#endif
 #endif
 
 
@@ -227,9 +219,6 @@ static struct Qdisc_ops uf_qdisc_ops =
 #elif LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,27)
 #define UF_QDISC_CREATE_DFLT(_dev, _ops, _root)         \
     qdisc_create_dflt(dev, netdev_get_tx_queue(_dev, 0), _ops, _root)
-#elif LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,20)
-#define UF_QDISC_CREATE_DFLT(_dev, _ops, _root)         \
-    qdisc_create_dflt(dev, _ops, _root)
 #else
 #define UF_QDISC_CREATE_DFLT(_dev, _ops, _root)         \
     qdisc_create_dflt(dev, _ops)
@@ -700,10 +689,8 @@ uf_free_netdevice(unifi_priv_t *priv)
 
 #ifdef CSR_SUPPORT_SME
     /* Cancel work items and destroy the workqueue */
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,23)
     cancel_work_sync(&priv->multicast_list_task);
 #endif
-#endif
 /* Destroy the workqueues. */
     flush_workqueue(priv->unifi_workqueue);
     destroy_workqueue(priv->unifi_workqueue);
@@ -3480,11 +3467,7 @@ static void uf_qdiscop_destroy(struct Qdisc* qd)
 
 
 /* called whenever parameters are updated on existing qdisc */
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,25)
 static int uf_qdiscop_tune(struct Qdisc *qd, struct nlattr *opt)
-#else
-static int uf_qdiscop_tune(struct Qdisc *qd, struct rtattr *opt)
-#endif
 {
     func_enter();
     func_exit();
@@ -3493,11 +3476,7 @@ static int uf_qdiscop_tune(struct Qdisc *qd, struct rtattr *opt)
 
 
 /* called during initial creation of qdisc on device */
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,25)
 static int uf_qdiscop_init(struct Qdisc *qd, struct nlattr *opt)
-#else
-static int uf_qdiscop_init(struct Qdisc *qd, struct rtattr *opt)
-#endif
 {
 #if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,27)
     struct net_device *dev = qd->dev_queue->dev;
-- 
1.7.12

