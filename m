Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754773Ab2FWGQp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jun 2012 02:16:45 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:34922 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751799Ab2FWGQn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jun 2012 02:16:43 -0400
From: Wanpeng Li <liwp.linux@gmail.com>
To: linux-mm@kvack.org
Cc: Michal Hocko <mhocko@suse.cz>, Johannes Weiner <hannes@cmpxchg.org>,
        Balbir Singh <bsingharora@gmail.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>,
        Minchan Kim <minchan@kernel.org>, linux-kernel@vger.kernel.org,
        cgroups@vger.kernel.org, Gavin Shan <shangw@linux.vnet.ibm.com>,
        Wanpeng Li <liwp.linux@gmail.com>
Subject: [PATCH 2/6] memcg: cleanup useless LRU_ALL_EVICTABLE
Date: Sat, 23 Jun 2012 14:16:19 +0800
Message-Id: <1340432179-5219-1-git-send-email-liwp.linux@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wanpeng Li <liwp@linux.vnet.ibm.com>

Since LRU_ALL_EVICTABLE is useless, just remove it.
Add LRU_ALL_UNEVICTABLE to mask unevictable pages.

Signed-off-by: Wanpeng Li <liwp.linux@gmail.com>
---
 include/linux/mmzone.h |    2 +-
 mm/memcontrol.c        |    4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index 68c569f..5873620 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -209,7 +209,7 @@ struct lruvec {
 /* Mask used at gathering information at once (see memcontrol.c) */
 #define LRU_ALL_FILE (BIT(LRU_INACTIVE_FILE) | BIT(LRU_ACTIVE_FILE))
 #define LRU_ALL_ANON (BIT(LRU_INACTIVE_ANON) | BIT(LRU_ACTIVE_ANON))
-#define LRU_ALL_EVICTABLE (LRU_ALL_FILE | LRU_ALL_ANON)
+#define LRU_ALL_UNEVICTABLE (BIT(LRU_UNEVICTABLE))
 #define LRU_ALL	     ((1 << NR_LRU_LISTS) - 1)
 
 /* Isolate clean file */
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 724bd02..ccda728 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -4033,11 +4033,11 @@ static int mem_control_numa_stat_show(struct cgroup *cont, struct cftype *cft,
 	}
 	seq_putc(m, '\n');
 
-	unevictable_nr = mem_cgroup_nr_lru_pages(memcg, BIT(LRU_UNEVICTABLE));
+	unevictable_nr = mem_cgroup_nr_lru_pages(memcg, LRU_ALL_UNEVICTABLE);
 	seq_printf(m, "unevictable=%lu", unevictable_nr);
 	for_each_node_state(nid, N_HIGH_MEMORY) {
 		node_nr = mem_cgroup_node_nr_lru_pages(memcg, nid,
-				BIT(LRU_UNEVICTABLE));
+				LRU_ALL_UNEVICTABLE);
 		seq_printf(m, " N%d=%lu", nid, node_nr);
 	}
 	seq_putc(m, '\n');
-- 
1.7.9.5

