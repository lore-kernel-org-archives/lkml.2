Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932476Ab1LOJgg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Dec 2011 04:36:36 -0500
Received: from mailhub.sw.ru ([195.214.232.25]:10990 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758741Ab1LOJgd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Dec 2011 04:36:33 -0500
From: Glauber Costa <glommer@parallels.com>
To: davem@davemloft.net
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        cgroups@vger.kernel.org, Glauber Costa <glommer@parallels.com>,
        Hiroyouki Kamezawa <kamezawa.hiroyu@jp.fujitsu.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Subject: [PATCH 1/2] Move limit definitions outside CONFIG_INET
Date: Thu, 15 Dec 2011 13:34:31 +0400
Message-Id: <1323941672-14324-2-git-send-email-glommer@parallels.com>
X-Mailer: git-send-email 1.7.6.4
In-Reply-To: <1323941672-14324-1-git-send-email-glommer@parallels.com>
References: <1323941672-14324-1-git-send-email-glommer@parallels.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

They need to be available for other protocols as well, since
they are used in sock.c openly

Signed-off-by: Glauber Costa <glommer@parallels.com>
CC: Hiroyouki Kamezawa <kamezawa.hiroyu@jp.fujitsu.com>
CC: David S. Miller <davem@davemloft.net>
CC: Eric Dumazet <eric.dumazet@gmail.com>
CC: Stephen Rothwell <sfr@canb.auug.org.au>
---
 include/linux/memcontrol.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 1513994..9b296ea 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -384,13 +384,13 @@ mem_cgroup_print_bad_page(struct page *page)
 }
 #endif
 
-#ifdef CONFIG_INET
 enum {
 	UNDER_LIMIT,
 	SOFT_LIMIT,
 	OVER_LIMIT,
 };
 
+#ifdef CONFIG_INET
 struct sock;
 #ifdef CONFIG_CGROUP_MEM_RES_CTLR_KMEM
 void sock_update_memcg(struct sock *sk);
-- 
1.7.6.4

