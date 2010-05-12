Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752215Ab0ELC45 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 May 2010 22:56:57 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:60431 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751373Ab0ELC4z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 May 2010 22:56:55 -0400
Date: Wed, 12 May 2010 12:56:53 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: David Miller <davem@davemloft.net>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Patrick McHardy <kaber@trash.net>,
       Andreas Meissner <andreas.meissner@sphairon.com>
Subject: linux-next: build failure after merge of the net tree
Message-Id: <20100512125653.38f442c5.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dave,

After merging the net tree, today's linux-next build (x86_64
allmodconfig) failed like this:

net/ipv4/ipmr.c: In function 'ipmr_cache_unresolved':
net/ipv4/ipmr.c:1001: error: 'net' undeclared (first use in this function)

Caused by commit 0c12295a741d3186987f96f518cfbdaf01abb087 ("ipv4: ipmr:
move mroute data into seperate structure") from the net tree interacting
with commit bbd725435ddb1cac732f7a8c23c21ff67f24c60f ("IPv4: unresolved
multicast route cleanup") from Linus' tree.

I applied this fix patch for today:

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Wed, 12 May 2010 12:51:02 +1000
Subject: [PATCH] net: merge fix for ipmr.c

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 net/ipv4/ipmr.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/ipv4/ipmr.c b/net/ipv4/ipmr.c
index db1e77a..7a7ee1c 100644
--- a/net/ipv4/ipmr.c
+++ b/net/ipv4/ipmr.c
@@ -998,7 +998,7 @@ ipmr_cache_unresolved(struct mr_table *mrt, vifi_t vifi, struct sk_buff *skb)
 		atomic_inc(&mrt->cache_resolve_queue_len);
 		list_add(&c->list, &mrt->mfc_unres_queue);
 
-		if (atomic_read(&net->ipv4.cache_resolve_queue_len) == 1)
+		if (atomic_read(&mrt->cache_resolve_queue_len) == 1)
 			mod_timer(&mrt->ipmr_expire_timer, c->mfc_un.unres.expires);
 	}
 
-- 
1.7.1


-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/
