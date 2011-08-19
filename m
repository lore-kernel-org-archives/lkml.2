Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755837Ab1HSNd5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Aug 2011 09:33:57 -0400
Received: from smtp.citrix.com ([66.165.176.89]:64883 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755379Ab1HSN3w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Aug 2011 09:29:52 -0400
X-IronPort-AV: E=Sophos;i="4.68,251,1312171200"; 
   d="scan'208";a="16158338"
From: Ian Campbell <ian.campbell@citrix.com>
To: netdev@vger.kernel.org
CC: linux-kernel@vger.kernel.org, Ian Campbell <ian.campbell@citrix.com>,
        Jon Mason <jdmason@kudzu.us>
Subject: [PATCH 61/75] vxge: convert to SKB paged frag API.
Date: Fri, 19 Aug 2011 14:27:33 +0100
Message-ID: <1313760467-8598-61-git-send-email-ian.campbell@citrix.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1313760393.5010.356.camel@zakaz.uk.xensource.com>
References: <1313760393.5010.356.camel@zakaz.uk.xensource.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Ian Campbell <ian.campbell@citrix.com>
Cc: Jon Mason <jdmason@kudzu.us>
Cc: netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---
 drivers/net/vxge/vxge-main.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/vxge/vxge-main.c b/drivers/net/vxge/vxge-main.c
index 178348a2..4baec97 100644
--- a/drivers/net/vxge/vxge-main.c
+++ b/drivers/net/vxge/vxge-main.c
@@ -923,9 +923,9 @@ vxge_xmit(struct sk_buff *skb, struct net_device *dev)
 		if (!frag->size)
 			continue;
 
-		dma_pointer = (u64) pci_map_page(fifo->pdev, frag->page,
-				frag->page_offset, frag->size,
-				PCI_DMA_TODEVICE);
+		dma_pointer = (u64)skb_frag_dma_map(&fifo->pdev->dev, frag,
+						    0, frag->size,
+						    PCI_DMA_TODEVICE);
 
 		if (unlikely(pci_dma_mapping_error(fifo->pdev, dma_pointer)))
 			goto _exit2;
-- 
1.7.2.5

