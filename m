Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755374Ab1HSN3p (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Aug 2011 09:29:45 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:58759 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755304Ab1HSN3i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Aug 2011 09:29:38 -0400
X-IronPort-AV: E=Sophos;i="4.68,251,1312171200"; 
   d="scan'208";a="159732428"
From: Ian Campbell <ian.campbell@citrix.com>
To: netdev@vger.kernel.org
CC: linux-kernel@vger.kernel.org, Ian Campbell <ian.campbell@citrix.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        "David S. Miller" <davem@davemloft.net>,
        Tobias Klauser <tklauser@distanz.ch>,
        David Decotigny <decot@google.com>,
        =?UTF-8?q?Micha=C5=82=20Miros=C5=82aw?= <mirq-linux@rere.qmqm.pl>,
        devicetree-discuss@lists.ozlabs.org
Subject: [PATCH 53/75] sunhme: convert to SKB paged frag API.
Date: Fri, 19 Aug 2011 14:27:25 +0100
Message-ID: <1313760467-8598-53-git-send-email-ian.campbell@citrix.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1313760393.5010.356.camel@zakaz.uk.xensource.com>
References: <1313760393.5010.356.camel@zakaz.uk.xensource.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Ian Campbell <ian.campbell@citrix.com>
Cc: Grant Likely <grant.likely@secretlab.ca>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Tobias Klauser <tklauser@distanz.ch>
Cc: David Decotigny <decot@google.com>
Cc: "Michał Mirosław" <mirq-linux@rere.qmqm.pl>
Cc: netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: devicetree-discuss@lists.ozlabs.org
---
 drivers/net/sunhme.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/net/sunhme.c b/drivers/net/sunhme.c
index 856e05b..0f897a0 100644
--- a/drivers/net/sunhme.c
+++ b/drivers/net/sunhme.c
@@ -2309,9 +2309,8 @@ static netdev_tx_t happy_meal_start_xmit(struct sk_buff *skb,
 			u32 len, mapping, this_txflags;
 
 			len = this_frag->size;
-			mapping = dma_map_page(hp->dma_dev, this_frag->page,
-					       this_frag->page_offset, len,
-					       DMA_TO_DEVICE);
+			mapping = skb_frag_dma_map(hp->dma_dev, this_frag,
+						   0, len, DMA_TO_DEVICE);
 			this_txflags = tx_flags;
 			if (frag == skb_shinfo(skb)->nr_frags - 1)
 				this_txflags |= TXFLAG_EOP;
-- 
1.7.2.5

