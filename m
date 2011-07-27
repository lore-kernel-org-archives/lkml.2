Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754483Ab1G0J5D (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jul 2011 05:57:03 -0400
Received: from narfation.org ([79.140.41.39]:43167 "EHLO v3-1039.vlinux.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754042Ab1G0Jzt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jul 2011 05:55:49 -0400
From: Sven Eckelmann <sven@narfation.org>
To: linux-arch@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Sven Eckelmann <sven@narfation.org>,
        Remi Denis-Courmont <remi.denis-courmont@nokia.com>
Subject: [PATCHv4 11/11] Phonet: Use *_dec_not_zero instead of *_add_unless
Date: Wed, 27 Jul 2011 11:47:50 +0200
Message-Id: <1311760070-21532-11-git-send-email-sven@narfation.org>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1311760070-21532-1-git-send-email-sven@narfation.org>
References: <1311760070-21532-1-git-send-email-sven@narfation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

atomic_dec_not_zero is defined for each architecture through
<linux/atomic.h> to provide the functionality of
atomic_add_unless(x, -1, 0).

Signed-off-by: Sven Eckelmann <sven@narfation.org>
Cc: Remi Denis-Courmont <remi.denis-courmont@nokia.com>
---
 net/phonet/pep.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/phonet/pep.c b/net/phonet/pep.c
index f17fd84..b192c83 100644
--- a/net/phonet/pep.c
+++ b/net/phonet/pep.c
@@ -1013,7 +1013,7 @@ static int pipe_skb_send(struct sock *sk, struct sk_buff *skb)
 	int err;
 
 	if (pn_flow_safe(pn->tx_fc) &&
-	    !atomic_add_unless(&pn->tx_credits, -1, 0)) {
+	    !atomic_dec_not_zero(&pn->tx_credits)) {
 		kfree_skb(skb);
 		return -ENOBUFS;
 	}
-- 
1.7.5.4

