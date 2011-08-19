Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755390Ab1HSNgI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Aug 2011 09:36:08 -0400
Received: from smtp.citrix.com ([66.165.176.89]:1160 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755310Ab1HSN3k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Aug 2011 09:29:40 -0400
X-IronPort-AV: E=Sophos;i="4.68,251,1312171200"; 
   d="scan'208";a="16158327"
From: Ian Campbell <ian.campbell@citrix.com>
To: netdev@vger.kernel.org
CC: linux-kernel@vger.kernel.org, Ian Campbell <ian.campbell@citrix.com>,
        Alexander Indenbaum <baum@tehutinetworks.net>,
        Andy Gospodarek <andy@greyhouse.net>
Subject: [PATCH 54/75] tehuti: convert to SKB paged frag API.
Date: Fri, 19 Aug 2011 14:27:26 +0100
Message-ID: <1313760467-8598-54-git-send-email-ian.campbell@citrix.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1313760393.5010.356.camel@zakaz.uk.xensource.com>
References: <1313760393.5010.356.camel@zakaz.uk.xensource.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Ian Campbell <ian.campbell@citrix.com>
Cc: Alexander Indenbaum <baum@tehutinetworks.net>
Cc: Andy Gospodarek <andy@greyhouse.net>
Cc: netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---
 drivers/net/tehuti.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/tehuti.c b/drivers/net/tehuti.c
index 749bbf1..b2c11db 100644
--- a/drivers/net/tehuti.c
+++ b/drivers/net/tehuti.c
@@ -1497,9 +1497,9 @@ bdx_tx_map_skb(struct bdx_priv *priv, struct sk_buff *skb,
 
 		frag = &skb_shinfo(skb)->frags[i];
 		db->wptr->len = frag->size;
-		db->wptr->addr.dma =
-		    pci_map_page(priv->pdev, frag->page, frag->page_offset,
-				 frag->size, PCI_DMA_TODEVICE);
+		db->wptr->addr.dma = skb_frag_dma_map(&priv->pdev->dev, frag,
+						      0, frag->size,
+						      PCI_DMA_TODEVICE);
 
 		pbl++;
 		pbl->len = CPU_CHIP_SWAP32(db->wptr->len);
-- 
1.7.2.5

