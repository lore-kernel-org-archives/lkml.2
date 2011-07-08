Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752951Ab1GHFWO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jul 2011 01:22:14 -0400
Received: from cantor2.suse.de ([195.135.220.15]:41498 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751846Ab1GHFAO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jul 2011 01:00:14 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Thu Jul  7 17:16:53 2011
Message-Id: <20110708001653.060434668@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Thu, 07 Jul 2011 17:15:35 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [003/107] netfilter: ipset: remove unused variable from type_pf_tdel()
In-Reply-To: <20110708001740.GA14031@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.39-stable review patch.  If anyone has any objections, please let us know.

------------------


From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>

[ Upstream commit b141c242ff978b63cdf0f3d1a767a5152750166b ]

Variable 'ret' is set in type_pf_tdel() but not used, remove.

Signed-off-by: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 include/linux/netfilter/ipset/ip_set_ahash.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/include/linux/netfilter/ipset/ip_set_ahash.h
+++ b/include/linux/netfilter/ipset/ip_set_ahash.h
@@ -839,7 +839,7 @@ type_pf_tdel(struct ip_set *set, void *v
 	struct htable *t = h->table;
 	const struct type_pf_elem *d = value;
 	struct hbucket *n;
-	int i, ret = 0;
+	int i;
 	struct type_pf_elem *data;
 	u32 key;
 
@@ -850,7 +850,7 @@ type_pf_tdel(struct ip_set *set, void *v
 		if (!type_pf_data_equal(data, d))
 			continue;
 		if (type_pf_data_expired(data))
-			ret = -IPSET_ERR_EXIST;
+			return -IPSET_ERR_EXIST;
 		if (i != n->pos - 1)
 			/* Not last one */
 			type_pf_data_copy(data, ahash_tdata(n, n->pos - 1));


