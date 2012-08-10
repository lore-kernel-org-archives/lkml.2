Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757858Ab2HJOJX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2012 10:09:23 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36486 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757296Ab2HJOJT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2012 10:09:19 -0400
Date: Fri, 10 Aug 2012 23:09:17 +0900 (JST)
Message-Id: <20120810.230917.2063393401537694311.yamato@redhat.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 09/15] Declaring netlink protocols has its own proc entry
From: Masatake YAMATO <yamato@redhat.com>
Organization: Red Hat Japan, Inc.
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Declaring netlink protocols has its own proc entry.

Signed-off-by: Masatake YAMATO <yamato@redhat.com>
---
 net/netlink/af_netlink.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/netlink/af_netlink.c b/net/netlink/af_netlink.c
index 5463969..c97b553 100644
--- a/net/netlink/af_netlink.c
+++ b/net/netlink/af_netlink.c
@@ -410,6 +410,9 @@ static struct proto netlink_proto = {
 	.name	  = "NETLINK",
 	.owner	  = THIS_MODULE,
 	.obj_size = sizeof(struct netlink_sock),
+#ifdef CONFIG_PROC_FS
+	.has_own_proc_entry= 1,
+#endif
 };
 
 static int __netlink_create(struct net *net, struct socket *sock,
-- 
1.7.11.2

