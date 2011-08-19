Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755015Ab1HSN3N (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Aug 2011 09:29:13 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:58729 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754894Ab1HSN3F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Aug 2011 09:29:05 -0400
X-IronPort-AV: E=Sophos;i="4.68,251,1312171200"; 
   d="scan'208";a="159732364"
From: Ian Campbell <ian.campbell@citrix.com>
To: netdev@vger.kernel.org
CC: linux-kernel@vger.kernel.org, Ian Campbell <ian.campbell@citrix.com>,
        Amit Kumar Salecha <amit.salecha@qlogic.com>
Subject: [PATCH 37/75] netxen: convert to SKB paged frag API.
Date: Fri, 19 Aug 2011 14:27:09 +0100
Message-ID: <1313760467-8598-37-git-send-email-ian.campbell@citrix.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1313760393.5010.356.camel@zakaz.uk.xensource.com>
References: <1313760393.5010.356.camel@zakaz.uk.xensource.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Ian Campbell <ian.campbell@citrix.com>
Cc: Amit Kumar Salecha <amit.salecha@qlogic.com>
Cc: netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---
 drivers/net/netxen/netxen_nic_main.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/netxen/netxen_nic_main.c b/drivers/net/netxen/netxen_nic_main.c
index f574edf..f6fcde3 100644
--- a/drivers/net/netxen/netxen_nic_main.c
+++ b/drivers/net/netxen/netxen_nic_main.c
@@ -1841,8 +1841,8 @@ netxen_map_tx_skb(struct pci_dev *pdev,
 		frag = &skb_shinfo(skb)->frags[i];
 		nf = &pbuf->frag_array[i+1];
 
-		map = pci_map_page(pdev, frag->page, frag->page_offset,
-				frag->size, PCI_DMA_TODEVICE);
+		map = skb_frag_dma_map(&pdev->dev, frag, 0, frag->size,
+				       PCI_DMA_TODEVICE);
 		if (pci_dma_mapping_error(pdev, map))
 			goto unwind;
 
-- 
1.7.2.5

