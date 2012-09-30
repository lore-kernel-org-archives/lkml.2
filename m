Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751528Ab2I3XtH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Sep 2012 19:49:07 -0400
Received: from quartz.orcorp.ca ([184.70.90.242]:49229 "EHLO quartz.orcorp.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751132Ab2I3XtF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Sep 2012 19:49:05 -0400
X-Greylist: delayed 1886 seconds by postgrey-1.27 at vger.kernel.org; Sun, 30 Sep 2012 19:49:05 EDT
Date: Sun, 30 Sep 2012 17:17:37 -0600
From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
To: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH] Fix userspace compilation of ip_tables.h/ip6_tables.h in
 C++ mode
Message-ID: <20120930231737.GA30637@obsidianresearch.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The implicit cast from void * is not allowed for C++ compilers, and the
arithmetic on void * generates warnings in C++ mode.

$ g++ -c t.cc
ip_tables.h:221:24: warning: pointer of type 'void *' used in arithmetic
ip_tables.h:221:24: error: invalid conversion from 'void*' to 'xt_entry_target*'

Signed-off-by: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
---
 include/linux/netfilter_ipv4/ip_tables.h  |    2 +-
 include/linux/netfilter_ipv6/ip6_tables.h |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/netfilter_ipv4/ip_tables.h b/include/linux/netfilter_ipv4/ip_tables.h
index db79231..050ad8a 100644
--- a/include/linux/netfilter_ipv4/ip_tables.h
+++ b/include/linux/netfilter_ipv4/ip_tables.h
@@ -226,7 +226,7 @@ struct ipt_get_entries {
 static __inline__ struct xt_entry_target *
 ipt_get_target(struct ipt_entry *e)
 {
-	return (void *)e + e->target_offset;
+	return (struct xt_entry_target *)((__u8 *)e + e->target_offset);
 }
 
 /*
diff --git a/include/linux/netfilter_ipv6/ip6_tables.h b/include/linux/netfilter_ipv6/ip6_tables.h
index 08c2cbb..3349bf1 100644
--- a/include/linux/netfilter_ipv6/ip6_tables.h
+++ b/include/linux/netfilter_ipv6/ip6_tables.h
@@ -263,7 +263,7 @@ struct ip6t_get_entries {
 static __inline__ struct xt_entry_target *
 ip6t_get_target(struct ip6t_entry *e)
 {
-	return (void *)e + e->target_offset;
+	return (struct xt_entry_target *)((__u8 *)e + e->target_offset);
 }
 
 /*
-- 
1.7.4.1

