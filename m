Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754387Ab1HSN22 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Aug 2011 09:28:28 -0400
Received: from smtp.citrix.com ([66.165.176.89]:27519 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753763Ab1HSN2P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Aug 2011 09:28:15 -0400
X-IronPort-AV: E=Sophos;i="4.68,251,1312171200"; 
   d="scan'208";a="16158227"
From: Ian Campbell <ian.campbell@citrix.com>
To: netdev@vger.kernel.org
CC: linux-kernel@vger.kernel.org, Ian Campbell <ian.campbell@citrix.com>,
        Jes Sorensen <jes@trained-monkey.org>, linux-acenic@sunsite.dk
Subject: [PATCH 12/75] acenic: convert to SKB paged frag API.
Date: Fri, 19 Aug 2011 14:26:44 +0100
Message-ID: <1313760467-8598-12-git-send-email-ian.campbell@citrix.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1313760393.5010.356.camel@zakaz.uk.xensource.com>
References: <1313760393.5010.356.camel@zakaz.uk.xensource.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Ian Campbell <ian.campbell@citrix.com>
Cc: Jes Sorensen <jes@trained-monkey.org>
Cc: linux-acenic@sunsite.dk
Cc: netdev@vger.kernel.org
---
 drivers/net/acenic.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/acenic.c b/drivers/net/acenic.c
index 31798f5..05df583 100644
--- a/drivers/net/acenic.c
+++ b/drivers/net/acenic.c
@@ -2485,9 +2485,9 @@ restart:
 			info = ap->skb->tx_skbuff + idx;
 			desc = ap->tx_ring + idx;
 
-			mapping = pci_map_page(ap->pdev, frag->page,
-					       frag->page_offset, frag->size,
-					       PCI_DMA_TODEVICE);
+			mapping = skb_frag_dma_map(&ap->pdev->dev, frag, 0,
+						   frag->size,
+						   PCI_DMA_TODEVICE);
 
 			flagsize = (frag->size << 16);
 			if (skb->ip_summed == CHECKSUM_PARTIAL)
-- 
1.7.2.5

