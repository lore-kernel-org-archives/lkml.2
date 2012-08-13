Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752149Ab2HMOnt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 10:43:49 -0400
Received: from smtp.ispras.ru ([83.149.198.202]:53789 "EHLO smtp.ispras.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751144Ab2HMOns (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 10:43:48 -0400
From: Ilya Shchepetkov <shchepetkov@ispras.ru>
To: "David S. Miller" <davem@davemloft.net>
Cc: Ilya Shchepetkov <shchepetkov@ispras.ru>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, ldv-project@ispras.ru
Subject: [PATCH] net: Fix incorrect comment in netif_tx_stop_queue()
Date: Mon, 13 Aug 2012 18:43:34 +0400
Message-Id: <1344869014-7110-1-git-send-email-shchepetkov@ispras.ru>
X-Mailer: git-send-email 1.7.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

netif_stop_queue() can be called before register_netdev() because now
TX queues are allocated inside alloc_netdev_mqs().

(since ed9af2e839c06c18f721da2c768fbb444c4a10e5 commit)

Found by Linux Driver Verification project (linuxtesting.org).

Signed-off-by: Ilya Shchepetkov <shchepetkov@ispras.ru>
---
 include/linux/netdevice.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index a9db4f3..a94fbbd 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -1860,7 +1860,7 @@ static inline void netif_tx_wake_all_queues(struct net_device *dev)
 static inline void netif_tx_stop_queue(struct netdev_queue *dev_queue)
 {
 	if (WARN_ON(!dev_queue)) {
-		pr_info("netif_stop_queue() cannot be called before register_netdev()\n");
+		pr_info("dev_queue is null\n");
 		return;
 	}
 	set_bit(__QUEUE_STATE_DRV_XOFF, &dev_queue->state);
-- 
1.7.7

