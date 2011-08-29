Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755244Ab1H2VUL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Aug 2011 17:20:11 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:48792 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755089Ab1H2VUI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Aug 2011 17:20:08 -0400
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: [PATCH 10/24] econet: Remove unnecessary OOM logging messages
Date: Mon, 29 Aug 2011 14:17:29 -0700
Message-Id: <05e147e61f40f97fadd63ce51ae1fcf3138fc109.1314650069.git.joe@perches.com>
X-Mailer: git-send-email 1.7.6.405.gc1be0
In-Reply-To: <cover.1314650069.git.joe@perches.com>
References: <cover.1314650069.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removing unnecessary messages saves code and text.

Site specific OOM messages are duplications of a generic MM
out of memory message and aren't really useful, so just
delete them.

Signed-off-by: Joe Perches <joe@perches.com>
---
 net/econet/af_econet.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/net/econet/af_econet.c b/net/econet/af_econet.c
index 1c1f26c..6ab525d 100644
--- a/net/econet/af_econet.c
+++ b/net/econet/af_econet.c
@@ -865,11 +865,9 @@ static void aun_incoming(struct sk_buff *skb, struct aunhdr *ah, size_t len)
 
 	newskb = alloc_skb((len - sizeof(struct aunhdr) + 15) & ~15,
 			   GFP_ATOMIC);
-	if (newskb == NULL) {
-		pr_debug("AUN: memory squeeze, dropping packet\n");
+	if (newskb == NULL)
 		/* Send nack and hope sender tries again */
 		goto bad;
-	}
 
 	memcpy(skb_put(newskb, len - sizeof(struct aunhdr)), (void *)(ah + 1),
 	       len - sizeof(struct aunhdr));
-- 
1.7.6.405.gc1be0

