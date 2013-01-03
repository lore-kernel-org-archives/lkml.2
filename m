Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753547Ab3ACMUb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2013 07:20:31 -0500
Received: from mail-pb0-f51.google.com ([209.85.160.51]:37503 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753059Ab3ACMUZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2013 07:20:25 -0500
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org,
        netfilter@vger.kernel.org, coreteam@netfilter.org,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: [PATCH -v2 22/26] net/netfilter: rename random32() to prandom_u32()
Date: Thu,  3 Jan 2013 21:19:18 +0900
Message-Id: <1357215562-6288-23-git-send-email-akinobu.mita@gmail.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1357215562-6288-1-git-send-email-akinobu.mita@gmail.com>
References: <1357215562-6288-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use more preferable function name which implies using a pseudo-random
number generator.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Patrick McHardy <kaber@trash.net>
Cc: netfilter-devel@vger.kernel.org
Cc: netfilter@vger.kernel.org
Cc: coreteam@netfilter.org
Cc: "David S. Miller" <davem@davemloft.net>
Cc: netdev@vger.kernel.org
---

* Change from v1
- leave net_random() callers as-is because that is a useful indirection

 net/netfilter/nf_conntrack_core.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 08cdc71..a8f5c7a 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -263,7 +263,7 @@ static void death_by_event(unsigned long ul_conntrack)
 	if (nf_conntrack_event(IPCT_DESTROY, ct) < 0) {
 		/* bad luck, let's retry again */
 		ecache->timeout.expires = jiffies +
-			(random32() % net->ct.sysctl_events_retry_timeout);
+			(prandom_u32() % net->ct.sysctl_events_retry_timeout);
 		add_timer(&ecache->timeout);
 		return;
 	}
@@ -282,7 +282,7 @@ void nf_ct_dying_timeout(struct nf_conn *ct)
 	/* set a new timer to retry event delivery */
 	setup_timer(&ecache->timeout, death_by_event, (unsigned long)ct);
 	ecache->timeout.expires = jiffies +
-		(random32() % net->ct.sysctl_events_retry_timeout);
+		(prandom_u32() % net->ct.sysctl_events_retry_timeout);
 	add_timer(&ecache->timeout);
 }
 EXPORT_SYMBOL_GPL(nf_ct_dying_timeout);
-- 
1.7.11.7

