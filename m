Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755419Ab1HSN3u (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Aug 2011 09:29:50 -0400
Received: from smtp.citrix.com ([66.165.176.89]:64883 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755379Ab1HSN3q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Aug 2011 09:29:46 -0400
X-IronPort-AV: E=Sophos;i="4.68,251,1312171200"; 
   d="scan'208";a="16158333"
From: Ian Campbell <ian.campbell@citrix.com>
To: netdev@vger.kernel.org
CC: linux-kernel@vger.kernel.org, Ian Campbell <ian.campbell@citrix.com>,
        Francois Romieu <romieu@fr.zoreil.com>
Subject: [PATCH 58/75] via-velocity: convert to SKB paged frag API.
Date: Fri, 19 Aug 2011 14:27:30 +0100
Message-ID: <1313760467-8598-58-git-send-email-ian.campbell@citrix.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1313760393.5010.356.camel@zakaz.uk.xensource.com>
References: <1313760393.5010.356.camel@zakaz.uk.xensource.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Ian Campbell <ian.campbell@citrix.com>
Cc: Francois Romieu <romieu@fr.zoreil.com>
Cc: netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---
 drivers/net/via-velocity.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/net/via-velocity.c b/drivers/net/via-velocity.c
index deb1eca..af9fb0a 100644
--- a/drivers/net/via-velocity.c
+++ b/drivers/net/via-velocity.c
@@ -2571,9 +2571,10 @@ static netdev_tx_t velocity_xmit(struct sk_buff *skb,
 	for (i = 0; i < skb_shinfo(skb)->nr_frags; i++) {
 		skb_frag_t *frag = &skb_shinfo(skb)->frags[i];
 
-		tdinfo->skb_dma[i + 1] = pci_map_page(vptr->pdev, frag->page,
-				frag->page_offset, frag->size,
-				PCI_DMA_TODEVICE);
+		tdinfo->skb_dma[i + 1] = skb_frag_dma_map(&vptr->pdev->dev,
+							  frag, 0,
+							  frag->size,
+							  PCI_DMA_TODEVICE);
 
 		td_ptr->td_buf[i + 1].pa_low = cpu_to_le32(tdinfo->skb_dma[i + 1]);
 		td_ptr->td_buf[i + 1].pa_high = 0;
-- 
1.7.2.5

