Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755427Ab1JSXFN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Oct 2011 19:05:13 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:38448 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755361Ab1JSXFI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Oct 2011 19:05:08 -0400
From: Mark Einon <mark.einon@gmail.com>
To: gregkh@suse.de
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Mark Einon <mark.einon@gmail.com>
Subject: staging: et131x: Match dma_alloc_ calls with dma_free_ calls
Date: Thu, 20 Oct 2011 00:01:04 +0100
Message-Id: <1319065268-2863-14-git-send-email-mark.einon@gmail.com>
X-Mailer: git-send-email 1.7.6.4
In-Reply-To: <1319065268-2863-1-git-send-email-mark.einon@gmail.com>
References: <1319065268-2863-1-git-send-email-mark.einon@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Previous update was to replace pci_alloc with dma_alloc calls. I missed
replacing the corresponding pci_free_ calls with the dma versions. Now
done. Thanks to Denis Kirjanov <kirjanov@gmail.com> for pointing this
out.

Signed-off-by: Mark Einon <mark.einon@gmail.com>
---
 drivers/staging/et131x/et131x.c |   16 ++++++++--------
 1 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/et131x/et131x.c b/drivers/staging/et131x/et131x.c
index 06ba4a9..28d54b3 100644
--- a/drivers/staging/et131x/et131x.c
+++ b/drivers/staging/et131x/et131x.c
@@ -2238,7 +2238,7 @@ void et131x_rx_dma_memory_free(struct et131x_adapter *adapter)
 				    (rx_ring->fbr[0]->buffsize * FBR_CHUNKS) +
 				    fbr1_align - 1;
 
-				pci_free_consistent(adapter->pdev,
+				dma_free_coherent(&adapter->pdev->dev,
 					bufsize,
 					rx_ring->fbr[0]->mem_virtaddrs[index],
 					rx_ring->fbr[0]->mem_physaddrs[index]);
@@ -2254,7 +2254,7 @@ void et131x_rx_dma_memory_free(struct et131x_adapter *adapter)
 		bufsize = (sizeof(struct fbr_desc) * rx_ring->fbr[0]->num_entries)
 							    + 0xfff;
 
-		pci_free_consistent(adapter->pdev, bufsize,
+		dma_free_coherent(&adapter->pdev->dev, bufsize,
 				    rx_ring->fbr[0]->ring_virtaddr,
 				    rx_ring->fbr[0]->ring_physaddr);
 
@@ -2272,7 +2272,7 @@ void et131x_rx_dma_memory_free(struct et131x_adapter *adapter)
 				    (rx_ring->fbr[1]->buffsize *
 				     (FBR_CHUNKS + 1)) - 1;
 
-				pci_free_consistent(adapter->pdev,
+				dma_free_coherent(&adapter->pdev->dev,
 					bufsize,
 					rx_ring->fbr[1]->mem_virtaddrs[index],
 					rx_ring->fbr[1]->mem_physaddrs[index]);
@@ -2288,7 +2288,7 @@ void et131x_rx_dma_memory_free(struct et131x_adapter *adapter)
 		bufsize = (sizeof(struct fbr_desc) * rx_ring->fbr[1]->num_entries)
 							    + 0xfff;
 
-		pci_free_consistent(adapter->pdev,
+		dma_free_coherent(&adapter->pdev->dev,
 				    bufsize,
 				    rx_ring->fbr[1]->ring_virtaddr,
 				    rx_ring->fbr[1]->ring_physaddr);
@@ -2303,7 +2303,7 @@ void et131x_rx_dma_memory_free(struct et131x_adapter *adapter)
 		    sizeof(struct pkt_stat_desc) *
 		    adapter->rx_ring.psr_num_entries;
 
-		pci_free_consistent(adapter->pdev, pktstat_ringsize,
+		dma_free_coherent(&adapter->pdev->dev, pktstat_ringsize,
 				    rx_ring->ps_ring_virtaddr,
 				    rx_ring->ps_ring_physaddr);
 
@@ -2312,7 +2312,7 @@ void et131x_rx_dma_memory_free(struct et131x_adapter *adapter)
 
 	/* Free area of memory for the writeback of status information */
 	if (rx_ring->rx_status_block) {
-		pci_free_consistent(adapter->pdev,
+		dma_free_coherent(&adapter->pdev->dev,
 			sizeof(struct rx_status_block),
 			rx_ring->rx_status_block, rx_ring->rx_status_bus);
 		rx_ring->rx_status_block = NULL;
@@ -3038,7 +3038,7 @@ void et131x_tx_dma_memory_free(struct et131x_adapter *adapter)
 		/* Free memory relating to Tx rings here */
 		desc_size = (sizeof(struct tx_desc) * NUM_DESC_PER_RING_TX)
 								+ 4096 - 1;
-		pci_free_consistent(adapter->pdev,
+		dma_free_coherent(&adapter->pdev->dev,
 				    desc_size,
 				    adapter->tx_ring.tx_desc_ring,
 				    adapter->tx_ring.tx_desc_ring_pa);
@@ -3047,7 +3047,7 @@ void et131x_tx_dma_memory_free(struct et131x_adapter *adapter)
 
 	/* Free memory for the Tx status block */
 	if (adapter->tx_ring.tx_status) {
-		pci_free_consistent(adapter->pdev,
+		dma_free_coherent(&adapter->pdev->dev,
 				    sizeof(u32),
 				    adapter->tx_ring.tx_status,
 				    adapter->tx_ring.tx_status_pa);
-- 
1.7.6.4

