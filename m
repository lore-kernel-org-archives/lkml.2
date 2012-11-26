Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755935Ab2KZRAv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 12:00:51 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:47058 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755569Ab2KZRAr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 12:00:47 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Patrick McHardy <kaber@trash.net>, Pablo Neira Ayuso <pablo@netfilter.org>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 016/270] netfilter: nfnetlink_log: fix NLA_PUT macro removal bug
Date: Mon, 26 Nov 2012 14:55:06 -0200
Message-Id: <1353949160-26803-17-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
References: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7u1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Patrick McHardy <kaber@trash.net>

commit 2dba62c30ec3040ef1b647a8976fd7e6854cc7a7 upstream.

Commit 1db20a52 (nfnetlink_log: Stop using NLA_PUT*().) incorrectly
converted a NLA_PUT_BE16 macro to nla_put_be32() in nfnetlink_log:

-               NLA_PUT_BE16(inst->skb, NFULA_HWTYPE, htons(skb->dev->type));
+               if (nla_put_be32(inst->skb, NFULA_HWTYPE, htons(skb->dev->type))

Signed-off-by: Patrick McHardy <kaber@trash.net>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Acked-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 net/netfilter/nfnetlink_log.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nfnetlink_log.c b/net/netfilter/nfnetlink_log.c
index 3c3cfc0..bbc1d91 100644
--- a/net/netfilter/nfnetlink_log.c
+++ b/net/netfilter/nfnetlink_log.c
@@ -476,7 +476,7 @@ __build_packet_message(struct nfulnl_instance *inst,
 	}
 
 	if (indev && skb_mac_header_was_set(skb)) {
-		if (nla_put_be32(inst->skb, NFULA_HWTYPE, htons(skb->dev->type)) ||
+		if (nla_put_be16(inst->skb, NFULA_HWTYPE, htons(skb->dev->type)) ||
 		    nla_put_be16(inst->skb, NFULA_HWLEN,
 				 htons(skb->dev->hard_header_len)) ||
 		    nla_put(inst->skb, NFULA_HWHEADER, skb->dev->hard_header_len,
-- 
1.7.9.5

