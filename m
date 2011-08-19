Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754225Ab1HSN2U (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Aug 2011 09:28:20 -0400
Received: from smtp.citrix.com ([66.165.176.89]:27519 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754006Ab1HSN2N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Aug 2011 09:28:13 -0400
X-IronPort-AV: E=Sophos;i="4.68,251,1312171200"; 
   d="scan'208";a="16158223"
From: Ian Campbell <ian.campbell@citrix.com>
To: netdev@vger.kernel.org
CC: linux-kernel@vger.kernel.org, Ian Campbell <ian.campbell@citrix.com>
Subject: [PATCH 11/75] 8139cp: convert to SKB paged frag API.
Date: Fri, 19 Aug 2011 14:26:43 +0100
Message-ID: <1313760467-8598-11-git-send-email-ian.campbell@citrix.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1313760393.5010.356.camel@zakaz.uk.xensource.com>
References: <1313760393.5010.356.camel@zakaz.uk.xensource.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Ian Campbell <ian.campbell@citrix.com>
Cc: netdev@vger.kernel.org
---
 drivers/net/8139cp.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/net/8139cp.c b/drivers/net/8139cp.c
index cc4c210..abefdce 100644
--- a/drivers/net/8139cp.c
+++ b/drivers/net/8139cp.c
@@ -784,8 +784,7 @@ static netdev_tx_t cp_start_xmit (struct sk_buff *skb,
 
 			len = this_frag->size;
 			mapping = dma_map_single(&cp->pdev->dev,
-						 ((void *) page_address(this_frag->page) +
-						  this_frag->page_offset),
+						 skb_frag_address(this_frag),
 						 len, PCI_DMA_TODEVICE);
 			eor = (entry == (CP_TX_RING_SIZE - 1)) ? RingEnd : 0;
 
-- 
1.7.2.5

