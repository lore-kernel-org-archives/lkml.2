Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756877Ab2HRRdN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Aug 2012 13:33:13 -0400
Received: from mga02.intel.com ([134.134.136.20]:61057 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755064Ab2HRRae (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Aug 2012 13:30:34 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.77,791,1336374000"; 
   d="scan'208";a="182354053"
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, James.Bottomley@HansenPartnership.com,
        Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 29/31] sections: Fix section conflicts in net
Date: Sat, 18 Aug 2012 10:30:20 -0700
Message-Id: <1345311022-26328-30-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1345311022-26328-1-git-send-email-andi@firstfloor.org>
References: <1345311022-26328-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 include/net/net_namespace.h |    2 ++
 net/decnet/dn_rules.c       |    2 +-
 net/ipv4/fib_rules.c        |    2 +-
 net/ipv4/ipmr.c             |    2 +-
 net/ipv6/addrlabel.c        |    2 +-
 net/ipv6/fib6_rules.c       |    2 +-
 net/ipv6/ip6mr.c            |    2 +-
 7 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/include/net/net_namespace.h b/include/net/net_namespace.h
index ae1cd6c..857c95d 100644
--- a/include/net/net_namespace.h
+++ b/include/net/net_namespace.h
@@ -241,10 +241,12 @@ static inline struct net *read_pnet(struct net * const *pnet)
 #define __net_init
 #define __net_exit
 #define __net_initdata
+#define __net_initconst
 #else
 #define __net_init	__init
 #define __net_exit	__exit_refok
 #define __net_initdata	__initdata
+#define __net_initconst	__initconst
 #endif
 
 struct pernet_operations {
diff --git a/net/decnet/dn_rules.c b/net/decnet/dn_rules.c
index e65f2c8..faf7cc3 100644
--- a/net/decnet/dn_rules.c
+++ b/net/decnet/dn_rules.c
@@ -220,7 +220,7 @@ static void dn_fib_rule_flush_cache(struct fib_rules_ops *ops)
 	dn_rt_cache_flush(-1);
 }
 
-static const struct fib_rules_ops __net_initdata dn_fib_rules_ops_template = {
+static const struct fib_rules_ops __net_initconst dn_fib_rules_ops_template = {
 	.family		= AF_DECnet,
 	.rule_size	= sizeof(struct dn_fib_rule),
 	.addr_size	= sizeof(u16),
diff --git a/net/ipv4/fib_rules.c b/net/ipv4/fib_rules.c
index a83d74e..97b9fb9 100644
--- a/net/ipv4/fib_rules.c
+++ b/net/ipv4/fib_rules.c
@@ -262,7 +262,7 @@ static void fib4_rule_flush_cache(struct fib_rules_ops *ops)
 	rt_cache_flush(ops->fro_net, -1);
 }
 
-static const struct fib_rules_ops __net_initdata fib4_rules_ops_template = {
+static const struct fib_rules_ops __net_initconst fib4_rules_ops_template = {
 	.family		= AF_INET,
 	.rule_size	= sizeof(struct fib4_rule),
 	.addr_size	= sizeof(u32),
diff --git a/net/ipv4/ipmr.c b/net/ipv4/ipmr.c
index 8eec8f4..5f9ebb9 100644
--- a/net/ipv4/ipmr.c
+++ b/net/ipv4/ipmr.c
@@ -218,7 +218,7 @@ static int ipmr_rule_fill(struct fib_rule *rule, struct sk_buff *skb,
 	return 0;
 }
 
-static const struct fib_rules_ops __net_initdata ipmr_rules_ops_template = {
+static const struct fib_rules_ops __net_initconst ipmr_rules_ops_template = {
 	.family		= RTNL_FAMILY_IPMR,
 	.rule_size	= sizeof(struct ipmr_rule),
 	.addr_size	= sizeof(u32),
diff --git a/net/ipv6/addrlabel.c b/net/ipv6/addrlabel.c
index eb6a636..c66c38b 100644
--- a/net/ipv6/addrlabel.c
+++ b/net/ipv6/addrlabel.c
@@ -75,7 +75,7 @@ struct net *ip6addrlbl_net(const struct ip6addrlbl_entry *lbl)
 
 #define IPV6_ADDR_LABEL_DEFAULT	0xffffffffUL
 
-static const __net_initdata struct ip6addrlbl_init_table
+static const __net_initconst struct ip6addrlbl_init_table
 {
 	const struct in6_addr *prefix;
 	int prefixlen;
diff --git a/net/ipv6/fib6_rules.c b/net/ipv6/fib6_rules.c
index 0ff1cfd..d9fb911 100644
--- a/net/ipv6/fib6_rules.c
+++ b/net/ipv6/fib6_rules.c
@@ -238,7 +238,7 @@ static size_t fib6_rule_nlmsg_payload(struct fib_rule *rule)
 	       + nla_total_size(16); /* src */
 }
 
-static const struct fib_rules_ops __net_initdata fib6_rules_ops_template = {
+static const struct fib_rules_ops __net_initconst fib6_rules_ops_template = {
 	.family			= AF_INET6,
 	.rule_size		= sizeof(struct fib6_rule),
 	.addr_size		= sizeof(struct in6_addr),
diff --git a/net/ipv6/ip6mr.c b/net/ipv6/ip6mr.c
index 4532973..87ecc67 100644
--- a/net/ipv6/ip6mr.c
+++ b/net/ipv6/ip6mr.c
@@ -205,7 +205,7 @@ static int ip6mr_rule_fill(struct fib_rule *rule, struct sk_buff *skb,
 	return 0;
 }
 
-static const struct fib_rules_ops __net_initdata ip6mr_rules_ops_template = {
+static const struct fib_rules_ops __net_initconst ip6mr_rules_ops_template = {
 	.family		= RTNL_FAMILY_IP6MR,
 	.rule_size	= sizeof(struct ip6mr_rule),
 	.addr_size	= sizeof(struct in6_addr),
-- 
1.7.7.6

