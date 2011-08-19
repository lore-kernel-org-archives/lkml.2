Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754433Ab1HSN2b (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Aug 2011 09:28:31 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:26037 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754181Ab1HSN2U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Aug 2011 09:28:20 -0400
X-IronPort-AV: E=Sophos;i="4.68,251,1312171200"; 
   d="scan'208";a="159732256"
From: Ian Campbell <ian.campbell@citrix.com>
To: netdev@vger.kernel.org
CC: linux-kernel@vger.kernel.org, Ian Campbell <ian.campbell@citrix.com>,
        "David S. Miller" <davem@davemloft.net>, Joe Perches <joe@perches.com>,
        =?UTF-8?q?Micha=C5=82=20Miros=C5=82aw?= <mirq-linux@rere.qmqm.pl>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Jon Mason <jdmason@kudzu.us>
Subject: [PATCH 14/75] atl1e: convert to SKB paged frag API.
Date: Fri, 19 Aug 2011 14:26:46 +0100
Message-ID: <1313760467-8598-14-git-send-email-ian.campbell@citrix.com>
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
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Joe Perches <joe@perches.com>
Cc: "Michał Mirosław" <mirq-linux@rere.qmqm.pl>
Cc: Stephen Hemminger <shemminger@vyatta.com>
Cc: Jon Mason <jdmason@kudzu.us>
Cc: netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---
 drivers/net/atl1e/atl1e_main.c |   11 +++++------
 1 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/net/atl1e/atl1e_main.c b/drivers/net/atl1e/atl1e_main.c
index d8d4119..637134d 100644
--- a/drivers/net/atl1e/atl1e_main.c
+++ b/drivers/net/atl1e/atl1e_main.c
@@ -1765,12 +1765,11 @@ static void atl1e_tx_map(struct atl1e_adapter *adapter,
 				MAX_TX_BUF_LEN : buf_len;
 			buf_len -= tx_buffer->length;
 
-			tx_buffer->dma =
-				pci_map_page(adapter->pdev, frag->page,
-						frag->page_offset +
-						(i * MAX_TX_BUF_LEN),
-						tx_buffer->length,
-						PCI_DMA_TODEVICE);
+			tx_buffer->dma = skb_frag_dma_map(&adapter->pdev->dev,
+							  frag,
+							  (i * MAX_TX_BUF_LEN),
+							  tx_buffer->length,
+							  PCI_DMA_TODEVICE);
 			ATL1E_SET_PCIMAP_TYPE(tx_buffer, ATL1E_TX_PCIMAP_PAGE);
 			use_tpd->buffer_addr = cpu_to_le64(tx_buffer->dma);
 			use_tpd->word2 = (use_tpd->word2 & (~TPD_BUFLEN_MASK)) |
-- 
1.7.2.5

