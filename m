Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755879Ab1HSNj6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Aug 2011 09:39:58 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:58735 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754994Ab1HSN3M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Aug 2011 09:29:12 -0400
X-IronPort-AV: E=Sophos;i="4.68,251,1312171200"; 
   d="scan'208";a="159732376"
From: Ian Campbell <ian.campbell@citrix.com>
To: netdev@vger.kernel.org
CC: linux-kernel@vger.kernel.org, Ian Campbell <ian.campbell@citrix.com>,
        Olof Johansson <olof@lixom.net>,
        Grant Likely <grant.likely@secretlab.ca>,
        linuxppc-dev@lists.ozlabs.org, devicetree-discuss@lists.ozlabs.org
Subject: [PATCH 40/75] pasemi: convert to SKB paged frag API.
Date: Fri, 19 Aug 2011 14:27:12 +0100
Message-ID: <1313760467-8598-40-git-send-email-ian.campbell@citrix.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1313760393.5010.356.camel@zakaz.uk.xensource.com>
References: <1313760393.5010.356.camel@zakaz.uk.xensource.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Ian Campbell <ian.campbell@citrix.com>
Cc: Olof Johansson <olof@lixom.net>
Cc: Grant Likely <grant.likely@secretlab.ca>
Cc: netdev@vger.kernel.org
Cc: linuxppc-dev@lists.ozlabs.org
Cc: linux-kernel@vger.kernel.org
Cc: devicetree-discuss@lists.ozlabs.org
---
 drivers/net/pasemi_mac.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/net/pasemi_mac.c b/drivers/net/pasemi_mac.c
index 9ec112c..3cd2cd3 100644
--- a/drivers/net/pasemi_mac.c
+++ b/drivers/net/pasemi_mac.c
@@ -1505,9 +1505,8 @@ static int pasemi_mac_start_tx(struct sk_buff *skb, struct net_device *dev)
 	for (i = 0; i < nfrags; i++) {
 		skb_frag_t *frag = &skb_shinfo(skb)->frags[i];
 
-		map[i+1] = pci_map_page(mac->dma_pdev, frag->page,
-					frag->page_offset, frag->size,
-					PCI_DMA_TODEVICE);
+		map[i + 1] = skb_frag_dma_map(&mac->dma_pdev->dev, frag, 0,
+					      frag->size, PCI_DMA_TODEVICE);
 		map_size[i+1] = frag->size;
 		if (pci_dma_mapping_error(mac->dma_pdev, map[i+1])) {
 			nfrags = i;
-- 
1.7.2.5

