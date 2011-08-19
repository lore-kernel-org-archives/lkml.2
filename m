Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754827Ab1HSN26 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Aug 2011 09:28:58 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:25060 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754625Ab1HSN2r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Aug 2011 09:28:47 -0400
X-IronPort-AV: E=Sophos;i="4.68,251,1312171200"; 
   d="scan'208";a="159732274"
From: Ian Campbell <ian.campbell@citrix.com>
To: netdev@vger.kernel.org
CC: linux-kernel@vger.kernel.org, Ian Campbell <ian.campbell@citrix.com>,
        Rasesh Mody <rmody@brocade.com>, Debashis Dutt <ddutt@brocade.com>
Subject: [PATCH 17/75] bna: convert to SKB paged frag API.
Date: Fri, 19 Aug 2011 14:26:49 +0100
Message-ID: <1313760467-8598-17-git-send-email-ian.campbell@citrix.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1313760393.5010.356.camel@zakaz.uk.xensource.com>
References: <1313760393.5010.356.camel@zakaz.uk.xensource.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Ian Campbell <ian.campbell@citrix.com>
Cc: Rasesh Mody <rmody@brocade.com>
Cc: Debashis Dutt <ddutt@brocade.com>
Cc: netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---
 drivers/net/bna/bnad.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/bna/bnad.c b/drivers/net/bna/bnad.c
index 8e35b25..7b8c21f 100644
--- a/drivers/net/bna/bnad.c
+++ b/drivers/net/bna/bnad.c
@@ -2622,8 +2622,8 @@ bnad_start_xmit(struct sk_buff *skb, struct net_device *netdev)
 
 		BUG_ON(!(size <= BFI_TX_MAX_DATA_PER_VECTOR));
 		txqent->vector[vect_id].length = htons(size);
-		dma_addr = dma_map_page(&bnad->pcidev->dev, frag->page,
-					frag->page_offset, size, DMA_TO_DEVICE);
+		dma_addr = skb_frag_dma_map(&bnad->pcidev->dev, frag,
+					    0, size, DMA_TO_DEVICE);
 		dma_unmap_addr_set(&unmap_q->unmap_array[unmap_prod], dma_addr,
 				   dma_addr);
 		BNA_SET_DMA_ADDR(dma_addr, &txqent->vector[vect_id].host_addr);
-- 
1.7.2.5

