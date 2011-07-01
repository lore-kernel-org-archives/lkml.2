Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754645Ab1GABJG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jun 2011 21:09:06 -0400
Received: from mail.perches.com ([173.55.12.10]:3387 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754615Ab1GABJE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jun 2011 21:09:04 -0400
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: WANG Cong <amwang@redhat.com>, "David S. Miller" <davem@davemloft.net>,
        netdev@vger.kernel.org
Subject: [PATCH 2/2] netpoll: Remove wrapper function netpoll_poll
Date: Thu, 30 Jun 2011 18:08:58 -0700
Message-Id: <6d0de0ce0430d29d1808ecba1ce306ccca52247e.1309482314.git.joe@perches.com>
X-Mailer: git-send-email 1.7.6.rc1
In-Reply-To: <cover.1309482314.git.joe@perches.com>
References: <cover.1309482314.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Too trivial to live.

cc: WANG Cong <amwang@redhat.com>
Signed-off-by: Joe Perches <joe@perches.com>
---
 net/core/netpoll.c |    9 ++-------
 1 files changed, 2 insertions(+), 7 deletions(-)

diff --git a/net/core/netpoll.c b/net/core/netpoll.c
index 4ce595e..adf84dd 100644
--- a/net/core/netpoll.c
+++ b/net/core/netpoll.c
@@ -209,11 +209,6 @@ static void netpoll_poll_dev(struct net_device *dev)
 	zap_completion_queue();
 }
 
-static void netpoll_poll(struct netpoll *np)
-{
-	netpoll_poll_dev(np->dev);
-}
-
 static void refill_skbs(void)
 {
 	struct sk_buff *skb;
@@ -273,7 +268,7 @@ repeat:
 
 	if (!skb) {
 		if (++count < 10) {
-			netpoll_poll(np);
+			netpoll_poll_dev(np->dev);
 			goto repeat;
 		}
 		return NULL;
@@ -334,7 +329,7 @@ void netpoll_send_skb_on_dev(struct netpoll *np, struct sk_buff *skb,
 			}
 
 			/* tickle device maybe there is some cleanup */
-			netpoll_poll(np);
+			netpoll_poll_dev(np->dev);
 
 			udelay(USEC_PER_POLL);
 		}
-- 
1.7.6.rc1

