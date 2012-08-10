Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758133Ab2HJOKj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2012 10:10:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55730 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756127Ab2HJOKh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2012 10:10:37 -0400
Date: Fri, 10 Aug 2012 23:10:35 +0900 (JST)
Message-Id: <20120810.231035.1228408194963415124.yamato@redhat.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 12/15] Declaring udplitev6 protocols has its own proc entry
From: Masatake YAMATO <yamato@redhat.com>
Organization: Red Hat Japan, Inc.
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Declaring udplitev6 protocols has its own proc entry.

Signed-off-by: Masatake YAMATO <yamato@redhat.com>
---
 net/ipv6/udplite.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/ipv6/udplite.c b/net/ipv6/udplite.c
index 1d08e21..0d6e713 100644
--- a/net/ipv6/udplite.c
+++ b/net/ipv6/udplite.c
@@ -57,6 +57,9 @@ struct proto udplitev6_prot = {
 	.compat_getsockopt = compat_udpv6_getsockopt,
 #endif
 	.clear_sk	   = sk_prot_clear_portaddr_nulls,
+#ifdef CONFIG_PROC_FS
+	.has_own_proc_entry= 1,
+#endif
 };
 
 static struct inet_protosw udplite6_protosw = {
-- 
1.7.11.2

