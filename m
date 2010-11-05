Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754136Ab0KEDPr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Nov 2010 23:15:47 -0400
Received: from mail.perches.com ([173.55.12.10]:4106 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753691Ab0KEDIv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Nov 2010 23:08:51 -0400
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
Subject: [PATCH 22/49] drivers/net/igb: Use vzalloc
Date: Thu,  4 Nov 2010 20:07:46 -0700
Message-Id: <e84a7e92e3fefb39e4870d5930ea04c8990f8e14.1288925424.git.joe@perches.com>
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
 drivers/net/igb/igb_main.c |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/net/igb/igb_main.c b/drivers/net/igb/igb_main.c
index 892d196..67ea262 100644
--- a/drivers/net/igb/igb_main.c
+++ b/drivers/net/igb/igb_main.c
@@ -2436,10 +2436,9 @@ int igb_setup_tx_resources(struct igb_ring *tx_ring)
 	int size;
 
 	size = sizeof(struct igb_buffer) * tx_ring->count;
-	tx_ring->buffer_info = vmalloc(size);
+	tx_ring->buffer_info = vzalloc(size);
 	if (!tx_ring->buffer_info)
 		goto err;
-	memset(tx_ring->buffer_info, 0, size);
 
 	/* round up to nearest 4K */
 	tx_ring->size = tx_ring->count * sizeof(union e1000_adv_tx_desc);
@@ -2587,10 +2586,9 @@ int igb_setup_rx_resources(struct igb_ring *rx_ring)
 	int size, desc_len;
 
 	size = sizeof(struct igb_buffer) * rx_ring->count;
-	rx_ring->buffer_info = vmalloc(size);
+	rx_ring->buffer_info = vzalloc(size);
 	if (!rx_ring->buffer_info)
 		goto err;
-	memset(rx_ring->buffer_info, 0, size);
 
 	desc_len = sizeof(union e1000_adv_rx_desc);
 
-- 
1.7.3.1.g432b3.dirty

