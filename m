Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754120Ab0KEDOT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Nov 2010 23:14:19 -0400
Received: from mail.perches.com ([173.55.12.10]:4127 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753761Ab0KEDIy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Nov 2010 23:08:54 -0400
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
Subject: [PATCH 26/49] drivers/net/ixgbevf: Use vzalloc
Date: Thu,  4 Nov 2010 20:07:50 -0700
Message-Id: <79b773f5012cba15686c4048d48cbbef6a13b049.1288925425.git.joe@perches.com>
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
 drivers/net/ixgbevf/ixgbevf_main.c |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ixgbevf/ixgbevf_main.c b/drivers/net/ixgbevf/ixgbevf_main.c
index dc03c96..6aeaf54 100644
--- a/drivers/net/ixgbevf/ixgbevf_main.c
+++ b/drivers/net/ixgbevf/ixgbevf_main.c
@@ -2488,10 +2488,9 @@ int ixgbevf_setup_tx_resources(struct ixgbevf_adapter *adapter,
 	int size;
 
 	size = sizeof(struct ixgbevf_tx_buffer) * tx_ring->count;
-	tx_ring->tx_buffer_info = vmalloc(size);
+	tx_ring->tx_buffer_info = vzalloc(size);
 	if (!tx_ring->tx_buffer_info)
 		goto err;
-	memset(tx_ring->tx_buffer_info, 0, size);
 
 	/* round up to nearest 4K */
 	tx_ring->size = tx_ring->count * sizeof(union ixgbe_adv_tx_desc);
@@ -2555,14 +2554,13 @@ int ixgbevf_setup_rx_resources(struct ixgbevf_adapter *adapter,
 	int size;
 
 	size = sizeof(struct ixgbevf_rx_buffer) * rx_ring->count;
-	rx_ring->rx_buffer_info = vmalloc(size);
+	rx_ring->rx_buffer_info = vzalloc(size);
 	if (!rx_ring->rx_buffer_info) {
 		hw_dbg(&adapter->hw,
 		       "Unable to vmalloc buffer memory for "
 		       "the receive descriptor ring\n");
 		goto alloc_failed;
 	}
-	memset(rx_ring->rx_buffer_info, 0, size);
 
 	/* Round up to nearest 4K */
 	rx_ring->size = rx_ring->count * sizeof(union ixgbe_adv_rx_desc);
-- 
1.7.3.1.g432b3.dirty

