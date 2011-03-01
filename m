Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756968Ab1CARGO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Mar 2011 12:06:14 -0500
Received: from mail.perches.com ([173.55.12.10]:4025 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752466Ab1CARGN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Mar 2011 12:06:13 -0500
Subject: [net-next PATCH] netdevice: Convert printk to pr_info in
 netif_tx_stop_queue
From: Joe Perches <joe@perches.com>
To: "David S. Miller" <davem@davemloft.net>
Cc: netdev@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 01 Mar 2011 09:06:12 -0800
Message-ID: <1298999172.4367.56.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This allows any caller to be prefaced by any specific
pr_fmt to better identify which device driver is using
this function inappropriately.

Add terminating newline.

Signed-off-by: Joe Perches <joe@perches.com>
---
 include/linux/netdevice.h |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index ffe56c1..c778992 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -1765,8 +1765,7 @@ static inline void netif_tx_wake_all_queues(struct net_device *dev)
 static inline void netif_tx_stop_queue(struct netdev_queue *dev_queue)
 {
 	if (WARN_ON(!dev_queue)) {
-		printk(KERN_INFO "netif_stop_queue() cannot be called before "
-		       "register_netdev()");
+		pr_info("netif_stop_queue() cannot be called before register_netdev()\n");
 		return;
 	}
 	set_bit(__QUEUE_STATE_XOFF, &dev_queue->state);


