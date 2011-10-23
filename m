Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755368Ab1JWJY7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Oct 2011 05:24:59 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:33009 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755306Ab1JWJYg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Oct 2011 05:24:36 -0400
From: Mark Einon <mark.einon@gmail.com>
To: gregkh@suse.de
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Mark Einon <mark.einon@gmail.com>
Subject: [PATCH 11/12] staging: et131x: Mainly whitespace changes to appease checkpatch
Date: Sun, 23 Oct 2011 10:22:53 +0100
Message-Id: <1319361774-3148-12-git-send-email-mark.einon@gmail.com>
X-Mailer: git-send-email 1.7.6.4
In-Reply-To: <1319361774-3148-1-git-send-email-mark.einon@gmail.com>
References: <1319361774-3148-1-git-send-email-mark.einon@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

- Whitespace changes to appease checkpatch warnings
- Removed unneeded braces around single line if/else

Signed-off-by: Mark Einon <mark.einon@gmail.com>
---
 drivers/staging/et131x/et131x.c |   81 ++++++++++++++++++++++-----------------
 1 files changed, 46 insertions(+), 35 deletions(-)

diff --git a/drivers/staging/et131x/et131x.c b/drivers/staging/et131x/et131x.c
index 8d36da0..98c6974 100644
--- a/drivers/staging/et131x/et131x.c
+++ b/drivers/staging/et131x/et131x.c
@@ -1935,8 +1935,8 @@ void et131x_config_rx_dma_regs(struct et131x_adapter *adapter)
 	 */
 	rx_local->fbr[0]->local_full = ET_DMA10_WRAP;
 	writel(
-	    ((rx_local->fbr[0]->num_entries * LO_MARK_PERCENT_FOR_RX) / 100) - 1,
-	    &rx_dma->fbr1_min_des);
+	   ((rx_local->fbr[0]->num_entries * LO_MARK_PERCENT_FOR_RX) / 100) - 1,
+	   &rx_dma->fbr1_min_des);
 
 #ifdef USE_FBR0
 	/* Now's the best time to initialize FBR0 contents */
@@ -1959,8 +1959,8 @@ void et131x_config_rx_dma_regs(struct et131x_adapter *adapter)
 	 */
 	rx_local->fbr[1]->local_full = ET_DMA10_WRAP;
 	writel(
-	    ((rx_local->fbr[1]->num_entries * LO_MARK_PERCENT_FOR_RX) / 100) - 1,
-	    &rx_dma->fbr0_min_des);
+	   ((rx_local->fbr[1]->num_entries * LO_MARK_PERCENT_FOR_RX) / 100) - 1,
+	   &rx_dma->fbr0_min_des);
 #endif
 
 	/* Program the number of packets we will receive before generating an
@@ -2383,14 +2383,16 @@ int et131x_rx_dma_memory_alloc(struct et131x_adapter *adapter)
 	}
 
 #ifdef USE_FBR0
-	adapter->rx_ring.psr_num_entries = adapter->rx_ring.fbr[1]->num_entries +
-	    adapter->rx_ring.fbr[0]->num_entries;
+	adapter->rx_ring.psr_num_entries =
+				adapter->rx_ring.fbr[1]->num_entries +
+				adapter->rx_ring.fbr[0]->num_entries;
 #else
 	adapter->rx_ring.psr_num_entries = adapter->rx_ring.fbr[0]->num_entries;
 #endif
 
 	/* Allocate an area of memory for Free Buffer Ring 1 */
-	bufsize = (sizeof(struct fbr_desc) * rx_ring->fbr[0]->num_entries) + 0xfff;
+	bufsize = (sizeof(struct fbr_desc) * rx_ring->fbr[0]->num_entries) +
+									0xfff;
 	rx_ring->fbr[0]->ring_virtaddr = dma_alloc_coherent(&adapter->pdev->dev,
 					bufsize,
 					&rx_ring->fbr[0]->ring_physaddr,
@@ -2421,7 +2423,8 @@ int et131x_rx_dma_memory_alloc(struct et131x_adapter *adapter)
 
 #ifdef USE_FBR0
 	/* Allocate an area of memory for Free Buffer Ring 0 */
-	bufsize = (sizeof(struct fbr_desc) * rx_ring->fbr[1]->num_entries) + 0xfff;
+	bufsize = (sizeof(struct fbr_desc) * rx_ring->fbr[1]->num_entries) +
+									0xfff;
 	rx_ring->fbr[1]->ring_virtaddr = dma_alloc_coherent(&adapter->pdev->dev,
 						bufsize,
 						&rx_ring->fbr[1]->ring_physaddr,
@@ -2471,7 +2474,8 @@ int et131x_rx_dma_memory_alloc(struct et131x_adapter *adapter)
 		    (FBR_CHUNKS * rx_ring->fbr[0]->buffsize) + fbr1_align - 1;
 		rx_ring->fbr[0]->mem_virtaddrs[i] =
 		    dma_alloc_coherent(&adapter->pdev->dev, fbr_chunksize,
-					 &rx_ring->fbr[0]->mem_physaddrs[i], GFP_KERNEL);
+				       &rx_ring->fbr[0]->mem_physaddrs[i],
+				       GFP_KERNEL);
 
 		if (!rx_ring->fbr[0]->mem_virtaddrs[i]) {
 			dev_err(&adapter->pdev->dev,
@@ -2523,7 +2527,8 @@ int et131x_rx_dma_memory_alloc(struct et131x_adapter *adapter)
 		    ((FBR_CHUNKS + 1) * rx_ring->fbr[1]->buffsize) - 1;
 		rx_ring->fbr[1]->mem_virtaddrs[i] =
 		    dma_alloc_coherent(&adapter->pdev->dev, fbr_chunksize,
-					 &rx_ring->fbr[1]->mem_physaddrs[i], GFP_KERNEL);
+				       &rx_ring->fbr[1]->mem_physaddrs[i],
+				       GFP_KERNEL);
 
 		if (!rx_ring->fbr[1]->mem_virtaddrs[i]) {
 			dev_err(&adapter->pdev->dev,
@@ -2675,10 +2680,11 @@ void et131x_rx_dma_memory_free(struct et131x_adapter *adapter)
 
 		/* Now the FIFO itself */
 		rx_ring->fbr[0]->ring_virtaddr = (void *)((u8 *)
-			rx_ring->fbr[0]->ring_virtaddr - rx_ring->fbr[0]->offset);
+		    rx_ring->fbr[0]->ring_virtaddr - rx_ring->fbr[0]->offset);
 
-		bufsize = (sizeof(struct fbr_desc) * rx_ring->fbr[0]->num_entries)
-							    + 0xfff;
+		bufsize =
+		    (sizeof(struct fbr_desc) * rx_ring->fbr[0]->num_entries) +
+									0xfff;
 
 		dma_free_coherent(&adapter->pdev->dev, bufsize,
 				    rx_ring->fbr[0]->ring_virtaddr,
@@ -2709,15 +2715,16 @@ void et131x_rx_dma_memory_free(struct et131x_adapter *adapter)
 
 		/* Now the FIFO itself */
 		rx_ring->fbr[1]->ring_virtaddr = (void *)((u8 *)
-			rx_ring->fbr[1]->ring_virtaddr - rx_ring->fbr[1]->offset);
+		    rx_ring->fbr[1]->ring_virtaddr - rx_ring->fbr[1]->offset);
 
-		bufsize = (sizeof(struct fbr_desc) * rx_ring->fbr[1]->num_entries)
-							    + 0xfff;
+		bufsize =
+		    (sizeof(struct fbr_desc) * rx_ring->fbr[1]->num_entries) +
+									0xfff;
 
 		dma_free_coherent(&adapter->pdev->dev,
-				    bufsize,
-				    rx_ring->fbr[1]->ring_virtaddr,
-				    rx_ring->fbr[1]->ring_physaddr);
+				  bufsize,
+				  rx_ring->fbr[1]->ring_virtaddr,
+				  rx_ring->fbr[1]->ring_physaddr);
 
 		rx_ring->fbr[1]->ring_virtaddr = NULL;
 	}
@@ -2857,9 +2864,9 @@ static void nic_return_rfd(struct et131x_adapter *adapter, struct rfd *rfd)
 		spin_lock_irqsave(&adapter->fbr_lock, flags);
 
 		if (ring_index == 1) {
-			struct fbr_desc *next =
-			    (struct fbr_desc *) (rx_local->fbr[0]->ring_virtaddr) +
-					 INDEX10(rx_local->fbr[0]->local_full);
+			struct fbr_desc *next = (struct fbr_desc *)
+					(rx_local->fbr[0]->ring_virtaddr) +
+					INDEX10(rx_local->fbr[0]->local_full);
 
 			/* Handle the Free Buffer Ring advancement here. Write
 			 * the PA / Buffer Index for the returned buffer into
@@ -2869,9 +2876,10 @@ static void nic_return_rfd(struct et131x_adapter *adapter, struct rfd *rfd)
 			next->addr_lo = rx_local->fbr[0]->bus_low[buff_index];
 			next->word2 = buff_index;
 
-			writel(bump_free_buff_ring(&rx_local->fbr[0]->local_full,
-				rx_local->fbr[0]->num_entries - 1),
-				&rx_dma->fbr1_full_offset);
+			writel(bump_free_buff_ring(
+					&rx_local->fbr[0]->local_full,
+					rx_local->fbr[0]->num_entries - 1),
+					&rx_dma->fbr1_full_offset);
 		}
 #ifdef USE_FBR0
 		else {
@@ -3109,8 +3117,8 @@ static struct rfd *nic_rx_pkts(struct et131x_adapter *adapter)
 		 * 1 for FBR0 etc
 		 */
 		memcpy(skb_put(skb, rfd->len),
-		       rx_local->fbr[(ring_index == 0 ? 1 : 0)]->virt[buff_index],
-		       rfd->len);
+		    rx_local->fbr[(ring_index == 0 ? 1 : 0)]->virt[buff_index],
+		    rfd->len);
 
 		skb->dev = adapter->netdev;
 		skb->protocol = eth_type_trans(skb, adapter->netdev);
@@ -3212,11 +3220,13 @@ int et131x_tx_dma_memory_alloc(struct et131x_adapter *adapter)
 	 */
 	desc_size = (sizeof(struct tx_desc) * NUM_DESC_PER_RING_TX) + 4096 - 1;
 	tx_ring->tx_desc_ring =
-	    (struct tx_desc *) dma_alloc_coherent(&adapter->pdev->dev, desc_size,
-						    &tx_ring->tx_desc_ring_pa, GFP_KERNEL);
+	    (struct tx_desc *) dma_alloc_coherent(&adapter->pdev->dev,
+						  desc_size,
+						  &tx_ring->tx_desc_ring_pa,
+						  GFP_KERNEL);
 	if (!adapter->tx_ring.tx_desc_ring) {
 		dev_err(&adapter->pdev->dev,
-					"Cannot alloc memory for Tx Ring\n");
+			"Cannot alloc memory for Tx Ring\n");
 		return -ENOMEM;
 	}
 
@@ -4871,7 +4881,8 @@ int et131x_close(struct net_device *netdev)
  *
  * Returns 0 on success, errno on failure (as defined in errno.h)
  */
-static int et131x_ioctl(struct net_device *netdev, struct ifreq *reqbuf, int cmd)
+static int et131x_ioctl(struct net_device *netdev, struct ifreq *reqbuf,
+			int cmd)
 {
 	struct et131x_adapter *adapter = netdev_priv(netdev);
 
@@ -5030,7 +5041,8 @@ static int et131x_tx(struct sk_buff *skb, struct net_device *netdev)
 	struct et131x_adapter *adapter = netdev_priv(netdev);
 
 	/* stop the queue if it's getting full */
-	if(adapter->tx_ring.used >= NUM_TCB - 1 && !netif_queue_stopped(netdev))
+	if (adapter->tx_ring.used >= NUM_TCB - 1 &&
+	    !netif_queue_stopped(netdev))
 		netif_stop_queue(netdev);
 
 	/* Save the timestamp for the TX timeout watchdog */
@@ -5041,11 +5053,10 @@ static int et131x_tx(struct sk_buff *skb, struct net_device *netdev)
 
 	/* Check status and manage the netif queue if necessary */
 	if (status != 0) {
-		if (status == -ENOMEM) {
+		if (status == -ENOMEM)
 			status = NETDEV_TX_BUSY;
-		} else {
+		else
 			status = NETDEV_TX_OK;
-		}
 	}
 	return status;
 }
-- 
1.7.6.4

