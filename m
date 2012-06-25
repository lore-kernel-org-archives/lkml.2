Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754486Ab2FYGEm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2012 02:04:42 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:49763 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750820Ab2FYGEl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2012 02:04:41 -0400
From: Wanpeng Li <liwp.linux@gmail.com>
To: Michal Hocko <mhocko@suse.cz>
Cc: Johannes Weiner <hannes@cmpxchg.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Balbir Singh <bsingharora@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Mike Frysinger <vapier@gentoo.org>, Arun Sharma <asharma@fb.com>,
        linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
        Wanpeng Li <liwp.linux@gmail.com>
Subject: [PATCH 1/5 v2] memcg: replace unsigned long by u64 to avoid overflow
Date: Mon, 25 Jun 2012 14:04:20 +0800
Message-Id: <1340604266-7937-1-git-send-email-liwp.linux@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changlog:

V2 -> V1:
* fix zone_page_state()::/include/linux/vmstat.h returns 'unsigned long'

From: Wanpeng Li <liwp@linux.vnet.ibm.com>

Since the return value variable in mem_cgroup_zone_nr_lru_pages and
mem_cgroup_node_nr_lru_pages functions are u64, so replace the return
value of funtions by u64 to avoid overflow.

Signed-off-by: Wanpeng Li <liwp.linux@gmail.com>
---
 include/linux/vmstat.h |    2 +-
 mm/memcontrol.c        |    5 ++---
 2 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/include/linux/vmstat.h b/include/linux/vmstat.h
index 65efb92..6a14291 100644
--- a/include/linux/vmstat.h
+++ b/include/linux/vmstat.h
@@ -106,7 +106,7 @@ static inline unsigned long global_page_state(enum zone_stat_item item)
 	return x;
 }
 
-static inline unsigned long zone_page_state(struct zone *zone,
+static inline u64 zone_page_state(struct zone *zone,
 					enum zone_stat_item item)
 {
 	long x = atomic_long_read(&zone->vm_stat[item]);
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index a2677e0..724bd02 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -776,8 +776,7 @@ mem_cgroup_zone_nr_lru_pages(struct mem_cgroup *memcg, int nid, int zid,
 	return ret;
 }
 
-static unsigned long
-mem_cgroup_node_nr_lru_pages(struct mem_cgroup *memcg,
+static u64 mem_cgroup_node_nr_lru_pages(struct mem_cgroup *memcg,
 			int nid, unsigned int lru_mask)
 {
 	u64 total = 0;
@@ -790,7 +789,7 @@ mem_cgroup_node_nr_lru_pages(struct mem_cgroup *memcg,
 	return total;
 }
 
-static unsigned long mem_cgroup_nr_lru_pages(struct mem_cgroup *memcg,
+static u64 mem_cgroup_nr_lru_pages(struct mem_cgroup *memcg,
 			unsigned int lru_mask)
 {
 	int nid;
-- 
1.7.9.5

