Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755091Ab1HSNni (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Aug 2011 09:43:38 -0400
Received: from smtp.citrix.com ([66.165.176.89]:14613 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754647Ab1HSN2v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Aug 2011 09:28:51 -0400
X-IronPort-AV: E=Sophos;i="4.68,251,1312171200"; 
   d="scan'208";a="16158291"
From: Ian Campbell <ian.campbell@citrix.com>
To: netdev@vger.kernel.org
CC: linux-kernel@vger.kernel.org, Ian Campbell <ian.campbell@citrix.com>,
        Santiago Leon <santil@linux.vnet.ibm.com>
Subject: [PATCH 30/75] ibmveth: convert to SKB paged frag API.
Date: Fri, 19 Aug 2011 14:27:02 +0100
Message-ID: <1313760467-8598-30-git-send-email-ian.campbell@citrix.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1313760393.5010.356.camel@zakaz.uk.xensource.com>
References: <1313760393.5010.356.camel@zakaz.uk.xensource.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Ian Campbell <ian.campbell@citrix.com>
Cc: Santiago Leon <santil@linux.vnet.ibm.com>
Cc: netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---
 drivers/net/ibmveth.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ibmveth.c b/drivers/net/ibmveth.c
index ba99af0..b7895d7 100644
--- a/drivers/net/ibmveth.c
+++ b/drivers/net/ibmveth.c
@@ -1002,9 +1002,8 @@ retry_bounce:
 		unsigned long dma_addr;
 		skb_frag_t *frag = &skb_shinfo(skb)->frags[i];
 
-		dma_addr = dma_map_page(&adapter->vdev->dev, frag->page,
-					frag->page_offset, frag->size,
-					DMA_TO_DEVICE);
+		dma_addr = skb_frag_dma_map(&adapter->vdev->dev, frag, 0,
+					    frag->size, DMA_TO_DEVICE);
 
 		if (dma_mapping_error(&adapter->vdev->dev, dma_addr))
 			goto map_failed_frags;
-- 
1.7.2.5

