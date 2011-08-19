Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755607Ab1HSNlh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Aug 2011 09:41:37 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:58695 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754845Ab1HSN3C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Aug 2011 09:29:02 -0400
X-IronPort-AV: E=Sophos;i="4.68,251,1312171200"; 
   d="scan'208";a="159732361"
From: Ian Campbell <ian.campbell@citrix.com>
To: netdev@vger.kernel.org
CC: linux-kernel@vger.kernel.org, Ian Campbell <ian.campbell@citrix.com>,
        Lennert Buytenhek <buytenh@wantstofly.org>
Subject: [PATCH 35/75] mv643xx: convert to SKB paged frag API.
Date: Fri, 19 Aug 2011 14:27:07 +0100
Message-ID: <1313760467-8598-35-git-send-email-ian.campbell@citrix.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1313760393.5010.356.camel@zakaz.uk.xensource.com>
References: <1313760393.5010.356.camel@zakaz.uk.xensource.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Ian Campbell <ian.campbell@citrix.com>
Cc: Lennert Buytenhek <buytenh@wantstofly.org>
Cc: netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---
 drivers/net/mv643xx_eth.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/mv643xx_eth.c b/drivers/net/mv643xx_eth.c
index 2596999..0da6643 100644
--- a/drivers/net/mv643xx_eth.c
+++ b/drivers/net/mv643xx_eth.c
@@ -752,10 +752,10 @@ static void txq_submit_frag_skb(struct tx_queue *txq, struct sk_buff *skb)
 
 		desc->l4i_chk = 0;
 		desc->byte_cnt = this_frag->size;
-		desc->buf_ptr = dma_map_page(mp->dev->dev.parent,
-					     this_frag->page,
-					     this_frag->page_offset,
-					     this_frag->size, DMA_TO_DEVICE);
+		desc->buf_ptr = skb_frag_dma_map(mp->dev->dev.parent,
+						 this_frag, 0,
+						 this_frag->size,
+						 DMA_TO_DEVICE);
 	}
 }
 
-- 
1.7.2.5

