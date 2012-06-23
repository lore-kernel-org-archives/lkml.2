Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754349Ab2FWGPy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jun 2012 02:15:54 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:61241 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751875Ab2FWGPx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jun 2012 02:15:53 -0400
From: Wanpeng Li <liwp.linux@gmail.com>
To: linux-mm@kvack.org
Cc: Michal Hocko <mhocko@suse.cz>, Johannes Weiner <hannes@cmpxchg.org>,
        Balbir Singh <bsingharora@gmail.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>,
        Minchan Kim <minchan@kernel.org>, linux-kernel@vger.kernel.org,
        cgroups@vger.kernel.org, Gavin Shan <shangw@linux.vnet.ibm.com>,
        Wanpeng Li <liwp.linux@gmail.com>
Subject: [PATCH 1/6] memcg: replace unsigned long by u64 to avoid overflow
Date: Sat, 23 Jun 2012 14:15:34 +0800
Message-Id: <1340432134-5178-1-git-send-email-liwp.linux@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wanpeng Li <liwp@linux.vnet.ibm.com>

Since the return value variable in mem_cgroup_zone_nr_lru_pages and
mem_cgroup_node_nr_lru_pages functions are u64, so replace the return
value of funtions by u64 to avoid overflow.

Signed-off-by: Wanpeng Li <liwp.linux@gmail.com>
---
 mm/memcontrol.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

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

