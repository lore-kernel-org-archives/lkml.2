Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757144Ab0LIUEU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 15:04:20 -0500
Received: from mail.perches.com ([173.55.12.10]:2397 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757045Ab0LIUEM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Dec 2010 15:04:12 -0500
From: Joe Perches <joe@perches.com>
To: Giuseppe Cavallaro <peppe.cavallaro@st.com>
Cc: Jiri Kosina <trivial@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 02/15] stmmac: Remove duplicate unlikely from IS_ERR
Date: Thu,  9 Dec 2010 12:03:55 -0800
Message-Id: <6ab3aedcd80e5c5b3c67194975082183b6c9bda3.1291923889.git.joe@perches.com>
X-Mailer: git-send-email 1.7.3.3.464.gf80b6
In-Reply-To: <1291906801-1389-2-git-send-email-tklauser@distanz.ch>
References: <1291906801-1389-2-git-send-email-tklauser@distanz.ch>
In-Reply-To: <cover.1291923888.git.joe@perches.com>
References: <cover.1291923888.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

IS_ERR already uses unlikely, remove unlikely from the call sites.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/net/stmmac/stmmac_main.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/stmmac/stmmac_main.c b/drivers/net/stmmac/stmmac_main.c
index c0dc785..20f803d 100644
--- a/drivers/net/stmmac/stmmac_main.c
+++ b/drivers/net/stmmac/stmmac_main.c
@@ -949,7 +949,7 @@ static int stmmac_sw_tso(struct stmmac_priv *priv, struct sk_buff *skb)
 	       skb, skb->len);
 
 	segs = skb_gso_segment(skb, priv->dev->features & ~NETIF_F_TSO);
-	if (unlikely(IS_ERR(segs)))
+	if (IS_ERR(segs))
 		goto sw_tso_end;
 
 	do {
-- 
1.7.3.3.464.gf80b6

