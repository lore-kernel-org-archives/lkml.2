Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758024Ab2HJOGu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2012 10:06:50 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45387 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757932Ab2HJOGr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2012 10:06:47 -0400
Date: Fri, 10 Aug 2012 23:06:45 +0900 (JST)
Message-Id: <20120810.230645.732660170719385986.yamato@redhat.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 04/15] Declaring udplite protocols has its own proc entry
From: Masatake YAMATO <yamato@redhat.com>
Organization: Red Hat Japan, Inc.
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Declaring udplite protocols has its own proc entry.

Signed-off-by: Masatake YAMATO <yamato@redhat.com>
---
 net/ipv4/udplite.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/ipv4/udplite.c b/net/ipv4/udplite.c
index 2c46acd..0b398b5 100644
--- a/net/ipv4/udplite.c
+++ b/net/ipv4/udplite.c
@@ -62,6 +62,9 @@ struct proto 	udplite_prot = {
 	.compat_getsockopt = compat_udp_getsockopt,
 #endif
 	.clear_sk	   = sk_prot_clear_portaddr_nulls,
+#ifdef CONFIG_PROC_FS
+	.has_own_proc_entry= 1,
+#endif
 };
 EXPORT_SYMBOL(udplite_prot);
 
-- 
1.7.11.2

