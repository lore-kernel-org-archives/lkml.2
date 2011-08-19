Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755936Ab1HSNnE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Aug 2011 09:43:04 -0400
Received: from smtp.citrix.com ([66.165.176.89]:22325 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754702Ab1HSN2w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Aug 2011 09:28:52 -0400
X-IronPort-AV: E=Sophos;i="4.68,251,1312171200"; 
   d="scan'208";a="16158292"
From: Ian Campbell <ian.campbell@citrix.com>
To: netdev@vger.kernel.org
CC: linux-kernel@vger.kernel.org, Ian Campbell <ian.campbell@citrix.com>,
        Guo-Fu Tseng <cooldavid@cooldavid.org>
Subject: [PATCH 31/75] jme: convert to SKB paged frag API.
Date: Fri, 19 Aug 2011 14:27:03 +0100
Message-ID: <1313760467-8598-31-git-send-email-ian.campbell@citrix.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1313760393.5010.356.camel@zakaz.uk.xensource.com>
References: <1313760393.5010.356.camel@zakaz.uk.xensource.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Ian Campbell <ian.campbell@citrix.com>
Cc: Guo-Fu Tseng <cooldavid@cooldavid.org>
Cc: netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---
 drivers/net/jme.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/jme.c b/drivers/net/jme.c
index 3ac262f..610b837 100644
--- a/drivers/net/jme.c
+++ b/drivers/net/jme.c
@@ -1928,8 +1928,9 @@ jme_map_tx_skb(struct jme_adapter *jme, struct sk_buff *skb, int idx)
 		ctxdesc = txdesc + ((idx + i + 2) & (mask));
 		ctxbi = txbi + ((idx + i + 2) & (mask));
 
-		jme_fill_tx_map(jme->pdev, ctxdesc, ctxbi, frag->page,
-				 frag->page_offset, frag->size, hidma);
+		jme_fill_tx_map(jme->pdev, ctxdesc, ctxbi,
+				skb_frag_page(frag),
+				frag->page_offset, frag->size, hidma);
 	}
 
 	len = skb_is_nonlinear(skb) ? skb_headlen(skb) : skb->len;
-- 
1.7.2.5

