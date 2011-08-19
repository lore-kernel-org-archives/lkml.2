Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755861Ab1HSNgY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Aug 2011 09:36:24 -0400
Received: from smtp.citrix.com ([66.165.176.89]:1160 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755041Ab1HSN3h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Aug 2011 09:29:37 -0400
X-IronPort-AV: E=Sophos;i="4.68,251,1312171200"; 
   d="scan'208";a="16158325"
From: Ian Campbell <ian.campbell@citrix.com>
To: netdev@vger.kernel.org
CC: linux-kernel@vger.kernel.org, Ian Campbell <ian.campbell@citrix.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        "David S. Miller" <davem@davemloft.net>, Jiri Kosina <jkosina@suse.cz>,
        Joe Perches <joe@perches.com>, David Decotigny <decot@google.com>,
        =?UTF-8?q?Micha=C5=82=20Miros=C5=82aw?= <mirq-linux@rere.qmqm.pl>,
        devicetree-discuss@lists.ozlabs.org
Subject: [PATCH 52/75] sungem: convert to SKB paged frag API.
Date: Fri, 19 Aug 2011 14:27:24 +0100
Message-ID: <1313760467-8598-52-git-send-email-ian.campbell@citrix.com>
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
Cc: Jiri Kosina <jkosina@suse.cz>
Cc: Joe Perches <joe@perches.com>
Cc: David Decotigny <decot@google.com>
Cc: "Michał Mirosław" <mirq-linux@rere.qmqm.pl>
Cc: netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: devicetree-discuss@lists.ozlabs.org
---
 drivers/net/sungem.c |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/net/sungem.c b/drivers/net/sungem.c
index ade35dd..39189bf 100644
--- a/drivers/net/sungem.c
+++ b/drivers/net/sungem.c
@@ -1071,10 +1071,8 @@ static netdev_tx_t gem_start_xmit(struct sk_buff *skb,
 			u64 this_ctrl;
 
 			len = this_frag->size;
-			mapping = pci_map_page(gp->pdev,
-					       this_frag->page,
-					       this_frag->page_offset,
-					       len, PCI_DMA_TODEVICE);
+			mapping = skb_frag_dma_map(&gp->pdev->dev, this_frag,
+						   0, len, PCI_DMA_TODEVICE);
 			this_ctrl = ctrl;
 			if (frag == skb_shinfo(skb)->nr_frags - 1)
 				this_ctrl |= TXDCTRL_EOF;
-- 
1.7.2.5

