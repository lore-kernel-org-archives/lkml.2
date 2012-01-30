Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754084Ab2A3BvP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jan 2012 20:51:15 -0500
Received: from [206.117.179.246] ([206.117.179.246]:52818 "EHLO labridge.com"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752410Ab2A3BvM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jan 2012 20:51:12 -0500
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: [PATCH net-next 2/2] netpoll: Neaten MAX_SKB_SIZE macro
Date: Sun, 29 Jan 2012 17:50:44 -0800
Message-Id: <c3a95a1d04d11f3741114ca206d37aea5609e504.1327888082.git.joe@perches.com>
X-Mailer: git-send-email 1.7.8.111.gad25c.dirty
In-Reply-To: <8a61df72a4eb6caaeaa8b5be644be227da61512b.1327888082.git.joe@perches.com>
References: <8a61df72a4eb6caaeaa8b5be644be227da61512b.1327888082.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add the types in the packet layout order.

Signed-off-by: Joe Perches <joe@perches.com>
---
 net/core/netpoll.c |    8 +++++---
 1 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/net/core/netpoll.c b/net/core/netpoll.c
index b523274..4ce473e 100644
--- a/net/core/netpoll.c
+++ b/net/core/netpoll.c
@@ -47,9 +47,11 @@ static atomic_t trapped;
 #define NETPOLL_RX_ENABLED  1
 #define NETPOLL_RX_DROP     2
 
-#define MAX_SKB_SIZE \
-		(MAX_UDP_CHUNK + sizeof(struct udphdr) + \
-				sizeof(struct iphdr) + sizeof(struct ethhdr))
+#define MAX_SKB_SIZE							\
+	(sizeof(struct ethhdr) +					\
+	 sizeof(struct iphdr) +						\
+	 sizeof(struct udphdr) +					\
+	 MAX_UDP_CHUNK)
 
 static void zap_completion_queue(void);
 static void arp_reply(struct sk_buff *skb);
-- 
1.7.8.111.gad25c.dirty

