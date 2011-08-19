Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755288Ab1HSNiS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Aug 2011 09:38:18 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:58735 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754989Ab1HSN3V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Aug 2011 09:29:21 -0400
X-IronPort-AV: E=Sophos;i="4.68,251,1312171200"; 
   d="scan'208";a="159732399"
From: Ian Campbell <ian.campbell@citrix.com>
To: netdev@vger.kernel.org
CC: linux-kernel@vger.kernel.org, Ian Campbell <ian.campbell@citrix.com>,
        Realtek linux nic maintainers <nic_swsd@realtek.com>,
        Francois Romieu <romieu@fr.zoreil.com>
Subject: [PATCH 45/75] r8169: convert to SKB paged frag API.
Date: Fri, 19 Aug 2011 14:27:17 +0100
Message-ID: <1313760467-8598-45-git-send-email-ian.campbell@citrix.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1313760393.5010.356.camel@zakaz.uk.xensource.com>
References: <1313760393.5010.356.camel@zakaz.uk.xensource.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Ian Campbell <ian.campbell@citrix.com>
Cc: Realtek linux nic maintainers <nic_swsd@realtek.com>
Cc: Francois Romieu <romieu@fr.zoreil.com>
Cc: netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---
 drivers/net/r8169.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/r8169.c b/drivers/net/r8169.c
index 02339b3..2ca6900 100644
--- a/drivers/net/r8169.c
+++ b/drivers/net/r8169.c
@@ -5027,7 +5027,7 @@ static int rtl8169_xmit_frags(struct rtl8169_private *tp, struct sk_buff *skb,
 
 		txd = tp->TxDescArray + entry;
 		len = frag->size;
-		addr = ((void *) page_address(frag->page)) + frag->page_offset;
+		addr = skb_frag_address(frag);
 		mapping = dma_map_single(d, addr, len, DMA_TO_DEVICE);
 		if (unlikely(dma_mapping_error(d, mapping))) {
 			if (net_ratelimit())
-- 
1.7.2.5

