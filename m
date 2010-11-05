Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754145Ab0KEDOm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Nov 2010 23:14:42 -0400
Received: from mail.perches.com ([173.55.12.10]:4124 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753624Ab0KEDIx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Nov 2010 23:08:53 -0400
From: Joe Perches <joe@perches.com>
To: Jiri Kosina <trivial@kernel.org>
Cc: Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Bruce Allan <bruce.w.allan@intel.com>,
        Carolyn Wyborny <carolyn.wyborny@intel.com>,
        Don Skidmore <donald.c.skidmore@intel.com>,
        Greg Rose <gregory.v.rose@intel.com>,
        PJ Waskiewicz <peter.p.waskiewicz.jr@intel.com>,
        Alex Duyck <alexander.h.duyck@intel.com>,
        John Ronciak <john.ronciak@intel.com>,
        e1000-devel@lists.sourceforge.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 25/49] drivers/net/ixgbe: Use vzalloc
Date: Thu,  4 Nov 2010 20:07:49 -0700
Message-Id: <3ef4ca9d423bd0fc5dcc8dae9c8c04ce48c9c240.1288925424.git.joe@perches.com>
X-Mailer: git-send-email 1.7.3.1.g432b3.dirty
In-Reply-To: <alpine.DEB.2.00.1011031108260.11625@router.home>
References: <alpine.DEB.2.00.1011031108260.11625@router.home>
In-Reply-To: <cover.1288925424.git.joe@perches.com>
References: <cover.1288925424.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/net/ixgbe/ixgbe_main.c |   10 ++++------
 1 files changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ixgbe/ixgbe_main.c b/drivers/net/ixgbe/ixgbe_main.c
index 2bd3eb4..c10d179 100644
--- a/drivers/net/ixgbe/ixgbe_main.c
+++ b/drivers/net/ixgbe/ixgbe_main.c
@@ -4970,12 +4970,11 @@ int ixgbe_setup_tx_resources(struct ixgbe_adapter *adapter,
 	int size;
 
 	size = sizeof(struct ixgbe_tx_buffer) * tx_ring->count;
-	tx_ring->tx_buffer_info = vmalloc_node(size, tx_ring->numa_node);
+	tx_ring->tx_buffer_info = vzalloc_node(size, tx_ring->numa_node);
 	if (!tx_ring->tx_buffer_info)
-		tx_ring->tx_buffer_info = vmalloc(size);
+		tx_ring->tx_buffer_info = vzalloc(size);
 	if (!tx_ring->tx_buffer_info)
 		goto err;
-	memset(tx_ring->tx_buffer_info, 0, size);
 
 	/* round up to nearest 4K */
 	tx_ring->size = tx_ring->count * sizeof(union ixgbe_adv_tx_desc);
@@ -5037,15 +5036,14 @@ int ixgbe_setup_rx_resources(struct ixgbe_adapter *adapter,
 	int size;
 
 	size = sizeof(struct ixgbe_rx_buffer) * rx_ring->count;
-	rx_ring->rx_buffer_info = vmalloc_node(size, adapter->node);
+	rx_ring->rx_buffer_info = vzalloc_node(size, adapter->node);
 	if (!rx_ring->rx_buffer_info)
-		rx_ring->rx_buffer_info = vmalloc(size);
+		rx_ring->rx_buffer_info = vzalloc(size);
 	if (!rx_ring->rx_buffer_info) {
 		e_err(probe, "vmalloc allocation failed for the Rx "
 		      "descriptor ring\n");
 		goto alloc_failed;
 	}
-	memset(rx_ring->rx_buffer_info, 0, size);
 
 	/* Round up to nearest 4K */
 	rx_ring->size = rx_ring->count * sizeof(union ixgbe_adv_rx_desc);
-- 
1.7.3.1.g432b3.dirty

