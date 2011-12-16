Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759190Ab1LPKxM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Dec 2011 05:53:12 -0500
Received: from mailhub.sw.ru ([195.214.232.25]:40012 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751161Ab1LPKxF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Dec 2011 05:53:05 -0500
From: Glauber Costa <glommer@parallels.com>
To: davem@davemloft.net
Cc: linux-kernel@vger.kernel.org, kamezawa.hiroyu@jp.fujitsu.com,
        netdev@vger.kernel.org, eric.dumazet@gmail.com,
        cgroups@vger.kernel.org, Glauber Costa <glommer@parallels.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Subject: [PATCH 2/2] net: fix compilation with !CONFIG_NET
Date: Fri, 16 Dec 2011 14:52:00 +0400
Message-Id: <1324032720-13752-2-git-send-email-glommer@parallels.com>
X-Mailer: git-send-email 1.7.6.4
In-Reply-To: <1324032720-13752-1-git-send-email-glommer@parallels.com>
References: <1324032720-13752-1-git-send-email-glommer@parallels.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reported-by: Randy Dunlap <rdunlap@xenotime.net>
Signed-off-by: Glauber Costa <glommer@parallels.com>
CC: Hiroyouki Kamezawa <kamezawa.hiroyu@jp.fujitsu.com>
CC: David S. Miller <davem@davemloft.net>
CC: Eric Dumazet <eric.dumazet@gmail.com>
CC: Stephen Rothwell <sfr@canb.auug.org.au>
---
 include/net/sock.h |   12 ++++++++++++
 1 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/include/net/sock.h b/include/net/sock.h
index 6fe0dae..3144c79 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -66,8 +66,20 @@
 
 struct cgroup;
 struct cgroup_subsys;
+#ifdef CONFIG_NET
 int mem_cgroup_sockets_init(struct cgroup *cgrp, struct cgroup_subsys *ss);
 void mem_cgroup_sockets_destroy(struct cgroup *cgrp, struct cgroup_subsys *ss);
+#else
+static inline
+int mem_cgroup_sockets_init(struct cgroup *cgrp, struct cgroup_subsys *ss)
+{
+	return 0;
+}
+static inline
+void mem_cgroup_sockets_destroy(struct cgroup *cgrp, struct cgroup_subsys *ss)
+{
+}
+#endif
 /*
  * This structure really needs to be cleaned up.
  * Most of it is for TCP, and not used by any of
-- 
1.7.6.4

