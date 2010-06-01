Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755402Ab0FADZL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 May 2010 23:25:11 -0400
Received: from mail.perches.com ([173.55.12.10]:2484 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753232Ab0FADXb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 May 2010 23:23:31 -0400
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Zhu Yi <yi.zhu@intel.com>, Reinette Chatre <reinette.chatre@intel.com>,
       Intel Linux Wireless <ilw@linux.intel.com>,
       linux-wireless@vger.kernel.org
Subject: [PATCH 13/21] drivers/net/wireless/ipw2x00/ipw2100.c: Remove unnecessary kmalloc casts
Date: Mon, 31 May 2010 20:23:15 -0700
Message-Id: <0542180516aae715912f619f18d4cdc6b3908c48.1275360951.git.joe@perches.com>
X-Mailer: git-send-email 1.7.0.3.311.g6a6955
In-Reply-To: <cover.1275360951.git.joe@perches.com>
References: <cover.1275360951.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/net/wireless/ipw2x00/ipw2100.c |   18 +++++++-----------
 1 files changed, 7 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/ipw2x00/ipw2100.c b/drivers/net/wireless/ipw2x00/ipw2100.c
index 0bd4dfa..18ebd60 100644
--- a/drivers/net/wireless/ipw2x00/ipw2100.c
+++ b/drivers/net/wireless/ipw2x00/ipw2100.c
@@ -3467,10 +3467,8 @@ static int ipw2100_msg_allocate(struct ipw2100_priv *priv)
 	dma_addr_t p;
 
 	priv->msg_buffers =
-	    (struct ipw2100_tx_packet *)kmalloc(IPW_COMMAND_POOL_SIZE *
-						sizeof(struct
-						       ipw2100_tx_packet),
-						GFP_KERNEL);
+	    kmalloc(IPW_COMMAND_POOL_SIZE * sizeof(struct ipw2100_tx_packet),
+		    GFP_KERNEL);
 	if (!priv->msg_buffers) {
 		printk(KERN_ERR DRV_NAME ": %s: PCI alloc failed for msg "
 		       "buffers.\n", priv->net_dev->name);
@@ -4499,10 +4497,8 @@ static int ipw2100_tx_allocate(struct ipw2100_priv *priv)
 	}
 
 	priv->tx_buffers =
-	    (struct ipw2100_tx_packet *)kmalloc(TX_PENDED_QUEUE_LENGTH *
-						sizeof(struct
-						       ipw2100_tx_packet),
-						GFP_ATOMIC);
+	    kmalloc(TX_PENDED_QUEUE_LENGTH * sizeof(struct ipw2100_tx_packet),
+		    GFP_ATOMIC);
 	if (!priv->tx_buffers) {
 		printk(KERN_ERR DRV_NAME
 		       ": %s: alloc failed form tx buffers.\n",
@@ -4651,9 +4647,9 @@ static int ipw2100_rx_allocate(struct ipw2100_priv *priv)
 	/*
 	 * allocate packets
 	 */
-	priv->rx_buffers = (struct ipw2100_rx_packet *)
-	    kmalloc(RX_QUEUE_LENGTH * sizeof(struct ipw2100_rx_packet),
-		    GFP_KERNEL);
+	priv->rx_buffers = kmalloc(RX_QUEUE_LENGTH *
+				   sizeof(struct ipw2100_rx_packet),
+				   GFP_KERNEL);
 	if (!priv->rx_buffers) {
 		IPW_DEBUG_INFO("can't allocate rx packet buffer table\n");
 
-- 
1.7.0.3.311.g6a6955

