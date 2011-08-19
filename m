Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755597Ab1HSNfV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Aug 2011 09:35:21 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:58759 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754971Ab1HSN3o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Aug 2011 09:29:44 -0400
X-IronPort-AV: E=Sophos;i="4.68,251,1312171200"; 
   d="scan'208";a="159732442"
From: Ian Campbell <ian.campbell@citrix.com>
To: netdev@vger.kernel.org
CC: linux-kernel@vger.kernel.org, Ian Campbell <ian.campbell@citrix.com>,
        David Dillow <dave@thedillows.org>
Subject: [PATCH 57/75] typhoon: convert to SKB paged frag API.
Date: Fri, 19 Aug 2011 14:27:29 +0100
Message-ID: <1313760467-8598-57-git-send-email-ian.campbell@citrix.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1313760393.5010.356.camel@zakaz.uk.xensource.com>
References: <1313760393.5010.356.camel@zakaz.uk.xensource.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Ian Campbell <ian.campbell@citrix.com>
Cc: David Dillow <dave@thedillows.org>
Cc: netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---
 drivers/net/typhoon.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/net/typhoon.c b/drivers/net/typhoon.c
index 1d5091a..21f69ca 100644
--- a/drivers/net/typhoon.c
+++ b/drivers/net/typhoon.c
@@ -819,8 +819,7 @@ typhoon_start_tx(struct sk_buff *skb, struct net_device *dev)
 			typhoon_inc_tx_index(&txRing->lastWrite, 1);
 
 			len = frag->size;
-			frag_addr = (void *) page_address(frag->page) +
-						frag->page_offset;
+			frag_addr = skb_frag_address(frag);
 			skb_dma = pci_map_single(tp->tx_pdev, frag_addr, len,
 					 PCI_DMA_TODEVICE);
 			txd->flags = TYPHOON_FRAG_DESC | TYPHOON_DESC_VALID;
-- 
1.7.2.5

