Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754467Ab1HSN24 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Aug 2011 09:28:56 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:25060 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754320Ab1HSN2t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Aug 2011 09:28:49 -0400
X-IronPort-AV: E=Sophos;i="4.68,251,1312171200"; 
   d="scan'208";a="159732279"
From: Ian Campbell <ian.campbell@citrix.com>
To: netdev@vger.kernel.org
CC: linux-kernel@vger.kernel.org, Ian Campbell <ian.campbell@citrix.com>,
        Eilon Greenstein <eilong@broadcom.com>
Subject: [PATCH 19/75] bnx2x: convert to SKB paged frag API.
Date: Fri, 19 Aug 2011 14:26:51 +0100
Message-ID: <1313760467-8598-19-git-send-email-ian.campbell@citrix.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1313760393.5010.356.camel@zakaz.uk.xensource.com>
References: <1313760393.5010.356.camel@zakaz.uk.xensource.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Ian Campbell <ian.campbell@citrix.com>
Cc: Eilon Greenstein <eilong@broadcom.com>
Cc: netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---
 drivers/net/bnx2x/bnx2x_cmn.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/net/bnx2x/bnx2x_cmn.c b/drivers/net/bnx2x/bnx2x_cmn.c
index 37e5790..c6689f6 100644
--- a/drivers/net/bnx2x/bnx2x_cmn.c
+++ b/drivers/net/bnx2x/bnx2x_cmn.c
@@ -2794,9 +2794,8 @@ netdev_tx_t bnx2x_start_xmit(struct sk_buff *skb, struct net_device *dev)
 	for (i = 0; i < skb_shinfo(skb)->nr_frags; i++) {
 		skb_frag_t *frag = &skb_shinfo(skb)->frags[i];
 
-		mapping = dma_map_page(&bp->pdev->dev, frag->page,
-				       frag->page_offset, frag->size,
-				       DMA_TO_DEVICE);
+		mapping = skb_frag_dma_map(&bp->pdev->dev, frag, 0, frag->size,
+					   DMA_TO_DEVICE);
 		if (unlikely(dma_mapping_error(&bp->pdev->dev, mapping))) {
 
 			DP(NETIF_MSG_TX_QUEUED, "Unable to map page - "
-- 
1.7.2.5

