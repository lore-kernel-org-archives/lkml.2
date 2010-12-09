Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757172Ab0LIUFu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 15:05:50 -0500
Received: from mail.perches.com ([173.55.12.10]:2404 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757095Ab0LIUEQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Dec 2010 15:04:16 -0500
From: Joe Perches <joe@perches.com>
To: "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        "Pekka Savola (ipv6)" <pekkas@netcore.fi>,
        James Morris <jmorris@namei.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Patrick McHardy <kaber@trash.net>
Cc: Jiri Kosina <trivial@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 15/15] ipv6: Remove duplicate unlikely from IS_ERR
Date: Thu,  9 Dec 2010 12:04:08 -0800
Message-Id: <ee5d2f9776ec2076b41c2abb23cdde76248602b2.1291923889.git.joe@perches.com>
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
 net/ipv6/af_inet6.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/ipv6/af_inet6.c b/net/ipv6/af_inet6.c
index 54e8e42..059a3de 100644
--- a/net/ipv6/af_inet6.c
+++ b/net/ipv6/af_inet6.c
@@ -810,7 +810,7 @@ static struct sk_buff *ipv6_gso_segment(struct sk_buff *skb, int features)
 	}
 	rcu_read_unlock();
 
-	if (unlikely(IS_ERR(segs)))
+	if (IS_ERR(segs))
 		goto out;
 
 	for (skb = segs; skb; skb = skb->next) {
-- 
1.7.3.3.464.gf80b6

