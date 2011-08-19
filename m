Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756044Ab1HSNty (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Aug 2011 09:49:54 -0400
Received: from smtp.citrix.com ([66.165.176.89]:25529 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751378Ab1HSN2G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Aug 2011 09:28:06 -0400
X-IronPort-AV: E=Sophos;i="4.68,251,1312171200"; 
   d="scan'208";a="16158215"
From: Ian Campbell <ian.campbell@citrix.com>
To: netdev@vger.kernel.org
CC: linux-kernel@vger.kernel.org, Ian Campbell <ian.campbell@citrix.com>,
        Tom Tucker <tom@opengridcomputing.com>,
        Steve Wise <swise@opengridcomputing.com>,
        Roland Dreier <roland@kernel.org>, Sean Hefty <sean.hefty@intel.com>,
        Hal Rosenstock <hal.rosenstock@gmail.com>, linux-rdma@vger.kernel.org
Subject: [PATCH 07/75] IB: amso1100: convert to SKB paged frag API.
Date: Fri, 19 Aug 2011 14:26:39 +0100
Message-ID: <1313760467-8598-7-git-send-email-ian.campbell@citrix.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1313760393.5010.356.camel@zakaz.uk.xensource.com>
References: <1313760393.5010.356.camel@zakaz.uk.xensource.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Ian Campbell <ian.campbell@citrix.com>
Cc: Tom Tucker <tom@opengridcomputing.com>
Cc: Steve Wise <swise@opengridcomputing.com>
Cc: Roland Dreier <roland@kernel.org>
Cc: Sean Hefty <sean.hefty@intel.com>
Cc: Hal Rosenstock <hal.rosenstock@gmail.com>
Cc: linux-rdma@vger.kernel.org
---
 drivers/infiniband/hw/amso1100/c2.c |    8 +++-----
 1 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/infiniband/hw/amso1100/c2.c b/drivers/infiniband/hw/amso1100/c2.c
index 444470a..6a8f36e 100644
--- a/drivers/infiniband/hw/amso1100/c2.c
+++ b/drivers/infiniband/hw/amso1100/c2.c
@@ -802,11 +802,9 @@ static int c2_xmit_frame(struct sk_buff *skb, struct net_device *netdev)
 		for (i = 0; i < skb_shinfo(skb)->nr_frags; i++) {
 			skb_frag_t *frag = &skb_shinfo(skb)->frags[i];
 			maplen = frag->size;
-			mapaddr =
-			    pci_map_page(c2dev->pcidev, frag->page,
-					 frag->page_offset, maplen,
-					 PCI_DMA_TODEVICE);
-
+			mapaddr = skb_frag_dma_map(&c2dev->pcidev->dev, frag,
+						   0, maplen,
+						   PCI_DMA_TODEVICE);
 			elem = elem->next;
 			elem->skb = NULL;
 			elem->mapaddr = mapaddr;
-- 
1.7.2.5

