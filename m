Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753500Ab1FLO5D (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jun 2011 10:57:03 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:42462 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751892Ab1FLO47 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jun 2011 10:56:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer;
        b=XyHD3reSpocs7BxKcRchmGKcVV9k/pSSJchSc0m/C9j6BBEGSaZ4igKureR1l4+BFD
         Yj6Rxe7l0Fb+3L/zKUjvoddY+nYEqQNfWX9XzBaMZonBVNqdslB3Wv4YcSFGGpoZLEH/
         Ly4US3Zbmh9+K4GE0DLZdF6W9u4YL/C+/YDiY=
From: Vasiliy Kulikov <segoon@openwall.com>
To: linux-kernel@vger.kernel.org
Cc: kernel-hardening@lists.openwall.com,
        Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <eric.dumazet@gmail.com>, netdev@vger.kernel.org
Subject: [RFC v2 01/04] net: make net_create() globally visible
Date: Sun, 12 Jun 2011 18:43:43 +0400
Message-Id: <1307889823-6169-1-git-send-email-segoon@openwall.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make net_create() visible outside of net/core/net_namespace.c to be able
to create additional network namespaces inside of fs/proc/proc_net.c.

Signed-off-by: Vasiliy Kulikov <segoon@openwall.com>
---
 include/net/net_namespace.h |    2 ++
 net/core/net_namespace.c    |    2 +-
 2 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/include/net/net_namespace.h b/include/net/net_namespace.h
index 1bf812b..d40c61c 100644
--- a/include/net/net_namespace.h
+++ b/include/net/net_namespace.h
@@ -113,6 +113,8 @@ static inline struct net *copy_net_ns(unsigned long flags, struct net *net_ns)
 }
 #endif /* CONFIG_NET */
 
+extern struct net *net_create(void);
+
 
 extern struct list_head net_namespace_list;
 
diff --git a/net/core/net_namespace.c b/net/core/net_namespace.c
index 3f86026..c7c7310 100644
--- a/net/core/net_namespace.c
+++ b/net/core/net_namespace.c
@@ -216,7 +216,7 @@ static void net_free(struct net *net)
 	kmem_cache_free(net_cachep, net);
 }
 
-static struct net *net_create(void)
+struct net *net_create(void)
 {
 	struct net *net;
 	int rv;
