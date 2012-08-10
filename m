Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758316Ab2HJONT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2012 10:13:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:24408 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757932Ab2HJONQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2012 10:13:16 -0400
Date: Fri, 10 Aug 2012 23:13:14 +0900 (JST)
Message-Id: <20120810.231314.666635800158178501.yamato@redhat.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 15/15] Declaring ipx protocols has its own proc entry
From: Masatake YAMATO <yamato@redhat.com>
Organization: Red Hat Japan, Inc.
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Declaring ipx protocols has its own proc entry.

Signed-off-by: Masatake YAMATO <yamato@redhat.com>
---
 net/ipx/af_ipx.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/ipx/af_ipx.c b/net/ipx/af_ipx.c
index dfd6faa..b20290d 100644
--- a/net/ipx/af_ipx.c
+++ b/net/ipx/af_ipx.c
@@ -1345,6 +1345,9 @@ static struct proto ipx_proto = {
 	.name	  = "IPX",
 	.owner	  = THIS_MODULE,
 	.obj_size = sizeof(struct ipx_sock),
+#ifdef CONFIG_PROC_FS
+	.has_own_proc_entry= 1,
+#endif
 };
 
 static int ipx_create(struct net *net, struct socket *sock, int protocol,
-- 
1.7.11.2

