Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755773Ab1HSNfl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Aug 2011 09:35:41 -0400
Received: from smtp.citrix.com ([66.165.176.89]:44487 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755325Ab1HSN3n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Aug 2011 09:29:43 -0400
X-IronPort-AV: E=Sophos;i="4.68,251,1312171200"; 
   d="scan'208";a="16158330"
From: Ian Campbell <ian.campbell@citrix.com>
To: netdev@vger.kernel.org
CC: linux-kernel@vger.kernel.org, Ian Campbell <ian.campbell@citrix.com>,
        Matt Carlson <mcarlson@broadcom.com>,
        Michael Chan <mchan@broadcom.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        devicetree-discuss@lists.ozlabs.org
Subject: [PATCH 55/75] tg3: convert to SKB paged frag API.
Date: Fri, 19 Aug 2011 14:27:27 +0100
Message-ID: <1313760467-8598-55-git-send-email-ian.campbell@citrix.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1313760393.5010.356.camel@zakaz.uk.xensource.com>
References: <1313760393.5010.356.camel@zakaz.uk.xensource.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Ian Campbell <ian.campbell@citrix.com>
Cc: Matt Carlson <mcarlson@broadcom.com>
Cc: Michael Chan <mchan@broadcom.com>
Cc: Grant Likely <grant.likely@secretlab.ca>
Cc: netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: devicetree-discuss@lists.ozlabs.org
---
 drivers/net/tg3.c |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/net/tg3.c b/drivers/net/tg3.c
index dc3fbf6..68a1a2c 100644
--- a/drivers/net/tg3.c
+++ b/drivers/net/tg3.c
@@ -6280,10 +6280,8 @@ static netdev_tx_t tg3_start_xmit(struct sk_buff *skb, struct net_device *dev)
 			skb_frag_t *frag = &skb_shinfo(skb)->frags[i];
 
 			len = frag->size;
-			mapping = pci_map_page(tp->pdev,
-					       frag->page,
-					       frag->page_offset,
-					       len, PCI_DMA_TODEVICE);
+			mapping = skb_frag_dma_map(&tp->pdev->dev, frag, 0,
+						   len, PCI_DMA_TODEVICE);
 
 			tnapi->tx_buffers[entry].skb = NULL;
 			dma_unmap_addr_set(&tnapi->tx_buffers[entry], mapping,
-- 
1.7.2.5

