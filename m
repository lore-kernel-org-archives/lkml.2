Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755139Ab1HSN3T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Aug 2011 09:29:19 -0400
Received: from smtp.citrix.com ([66.165.176.89]:37564 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754971Ab1HSN3K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Aug 2011 09:29:10 -0400
X-IronPort-AV: E=Sophos;i="4.68,251,1312171200"; 
   d="scan'208";a="16158311"
From: Ian Campbell <ian.campbell@citrix.com>
To: netdev@vger.kernel.org
CC: linux-kernel@vger.kernel.org, Ian Campbell <ian.campbell@citrix.com>,
        "David S. Miller" <davem@davemloft.net>,
        Denis Kirjanov <dkirjanov@kernel.org>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Benjamin LaHaise <bcrl@kvack.org>,
        Lucas De Marchi <lucas.demarchi@profusion.mobi>
Subject: [PATCH 39/75] ns83820: convert to SKB paged frag API.
Date: Fri, 19 Aug 2011 14:27:11 +0100
Message-ID: <1313760467-8598-39-git-send-email-ian.campbell@citrix.com>
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
Cc: Denis Kirjanov <dkirjanov@kernel.org>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Benjamin LaHaise <bcrl@kvack.org>
Cc: Lucas De Marchi <lucas.demarchi@profusion.mobi>
Cc: netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---
 drivers/net/ns83820.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ns83820.c b/drivers/net/ns83820.c
index e736aec..d318e4b 100644
--- a/drivers/net/ns83820.c
+++ b/drivers/net/ns83820.c
@@ -1160,9 +1160,8 @@ again:
 		if (!nr_frags)
 			break;
 
-		buf = pci_map_page(dev->pci_dev, frag->page,
-				   frag->page_offset,
-				   frag->size, PCI_DMA_TODEVICE);
+		buf = skb_frag_dma_map(&dev->pci_dev->dev, frag, 0,
+				       frag->size, PCI_DMA_TODEVICE);
 		dprintk("frag: buf=%08Lx  page=%08lx offset=%08lx\n",
 			(long long)buf, (long) page_to_pfn(frag->page),
 			frag->page_offset);
-- 
1.7.2.5

