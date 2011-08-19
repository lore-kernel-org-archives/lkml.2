Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754315Ab1HSN2Y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Aug 2011 09:28:24 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:27676 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753969Ab1HSN2M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Aug 2011 09:28:12 -0400
X-IronPort-AV: E=Sophos;i="4.68,251,1312171200"; 
   d="scan'208";a="159732218"
From: Ian Campbell <ian.campbell@citrix.com>
To: netdev@vger.kernel.org
CC: linux-kernel@vger.kernel.org, Ian Campbell <ian.campbell@citrix.com>,
        Steffen Klassert <klassert@mathematik.tu-chemnitz.de>
Subject: [PATCH 10/75] 3c59x: convert to SKB paged frag API.
Date: Fri, 19 Aug 2011 14:26:42 +0100
Message-ID: <1313760467-8598-10-git-send-email-ian.campbell@citrix.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1313760393.5010.356.camel@zakaz.uk.xensource.com>
References: <1313760393.5010.356.camel@zakaz.uk.xensource.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Ian Campbell <ian.campbell@citrix.com>
Cc: Steffen Klassert <klassert@mathematik.tu-chemnitz.de>
Cc: netdev@vger.kernel.org
---
 drivers/net/3c59x.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/net/3c59x.c b/drivers/net/3c59x.c
index 8cc2256..f83a96a 100644
--- a/drivers/net/3c59x.c
+++ b/drivers/net/3c59x.c
@@ -2179,9 +2179,10 @@ boomerang_start_xmit(struct sk_buff *skb, struct net_device *dev)
 			skb_frag_t *frag = &skb_shinfo(skb)->frags[i];
 
 			vp->tx_ring[entry].frag[i+1].addr =
-					cpu_to_le32(pci_map_single(VORTEX_PCI(vp),
-											   (void*)page_address(frag->page) + frag->page_offset,
-											   frag->size, PCI_DMA_TODEVICE));
+					cpu_to_le32(pci_map_single(
+						VORTEX_PCI(vp),
+						(void *)skb_frag_address(frag),
+						frag->size, PCI_DMA_TODEVICE));
 
 			if (i == skb_shinfo(skb)->nr_frags-1)
 					vp->tx_ring[entry].frag[i+1].length = cpu_to_le32(frag->size|LAST_FRAG);
-- 
1.7.2.5

