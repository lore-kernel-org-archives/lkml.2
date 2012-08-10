Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757492Ab2HJOGG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2012 10:06:06 -0400
Received: from mx1.redhat.com ([209.132.183.28]:20520 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756320Ab2HJOGB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2012 10:06:01 -0400
Date: Fri, 10 Aug 2012 23:05:59 +0900 (JST)
Message-Id: <20120810.230559.1897275934845172399.yamato@redhat.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 02/15] Declaring udp protocols has its own proc entry
From: Masatake YAMATO <yamato@redhat.com>
Organization: Red Hat Japan, Inc.
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Declaring udp protocols has its own proc entry.

Signed-off-by: Masatake YAMATO <yamato@redhat.com>
---
 net/ipv4/udp.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
index b4c3582..2b822ac 100644
--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -1963,6 +1963,9 @@ struct proto udp_prot = {
 	.compat_getsockopt = compat_udp_getsockopt,
 #endif
 	.clear_sk	   = sk_prot_clear_portaddr_nulls,
+#ifdef CONFIG_PROC_FS
+	.has_own_proc_entry= 1,
+#endif
 };
 EXPORT_SYMBOL(udp_prot);
 
-- 
1.7.11.2

