Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754553Ab1HSN2k (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Aug 2011 09:28:40 -0400
Received: from smtp.citrix.com ([66.165.176.89]:10440 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754516Ab1HSN2f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Aug 2011 09:28:35 -0400
X-IronPort-AV: E=Sophos;i="4.68,251,1312171200"; 
   d="scan'208";a="16158255"
From: Ian Campbell <ian.campbell@citrix.com>
To: netdev@vger.kernel.org
CC: linux-kernel@vger.kernel.org, Ian Campbell <ian.campbell@citrix.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Lucas De Marchi <lucas.demarchi@profusion.mobi>,
        Paul <paul.gortmaker@windriver.com>, Jesse Gross <jesse@nicira.com>
Subject: [PATCH 21/75] chelsio: convert to SKB paged frag API.
Date: Fri, 19 Aug 2011 14:26:53 +0100
Message-ID: <1313760467-8598-21-git-send-email-ian.campbell@citrix.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1313760393.5010.356.camel@zakaz.uk.xensource.com>
References: <1313760393.5010.356.camel@zakaz.uk.xensource.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Ian Campbell <ian.campbell@citrix.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Lucas De Marchi <lucas.demarchi@profusion.mobi>
Cc: Paul <paul.gortmaker@windriver.com>
Cc: Jesse Gross <jesse@nicira.com>
Cc: netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---
 drivers/net/chelsio/sge.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/net/chelsio/sge.c b/drivers/net/chelsio/sge.c
index e9a03ff..7cde425 100644
--- a/drivers/net/chelsio/sge.c
+++ b/drivers/net/chelsio/sge.c
@@ -1277,9 +1277,8 @@ static inline void write_tx_descs(struct adapter *adapter, struct sk_buff *skb,
 			ce = q->centries;
 		}
 
-		mapping = pci_map_page(adapter->pdev, frag->page,
-				       frag->page_offset, frag->size,
-				       PCI_DMA_TODEVICE);
+		mapping = skb_frag_dma_map(&adapter->pdev->dev, frag, 0,
+					   frag->size, PCI_DMA_TODEVICE);
 		desc_mapping = mapping;
 		desc_len = frag->size;
 
-- 
1.7.2.5

