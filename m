Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757427Ab2ENSA7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 14:00:59 -0400
Received: from zene.cmpxchg.org ([85.214.230.12]:58808 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756685Ab2ENSA6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 14:00:58 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Michal Hocko <mhocko@suse.cz>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        cgroups@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: [patch 1/6] mm: memcg: remove obsolete statistics array boundary enum item
Date: Mon, 14 May 2012 20:00:46 +0200
Message-Id: <1337018451-27359-2-git-send-email-hannes@cmpxchg.org>
X-Mailer: git-send-email 1.7.10.1
In-Reply-To: <1337018451-27359-1-git-send-email-hannes@cmpxchg.org>
References: <1337018451-27359-1-git-send-email-hannes@cmpxchg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

MEM_CGROUP_STAT_DATA is a leftover from when item counters were living
in the same array as ever-increasing event counters.  It's no longer
needed, use MEM_CGROUP_STAT_NSTATS to iterate over the stat array.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
---
 mm/memcontrol.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 9520ee9..aef89c1 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -99,7 +99,6 @@ enum mem_cgroup_stat_index {
 	MEM_CGROUP_STAT_FILE_MAPPED,  /* # of pages charged as file rss */
 	MEM_CGROUP_STAT_MLOCK, /* # of pages charged as mlock()ed */
 	MEM_CGROUP_STAT_SWAPOUT, /* # of pages, swapped out */
-	MEM_CGROUP_STAT_DATA, /* end of data requires synchronization */
 	MEM_CGROUP_STAT_NSTATS,
 };
 
@@ -2158,7 +2157,7 @@ static void mem_cgroup_drain_pcp_counter(struct mem_cgroup *memcg, int cpu)
 	int i;
 
 	spin_lock(&memcg->pcp_counter_lock);
-	for (i = 0; i < MEM_CGROUP_STAT_DATA; i++) {
+	for (i = 0; i < MEM_CGROUP_STAT_NSTATS; i++) {
 		long x = per_cpu(memcg->stat->count[i], cpu);
 
 		per_cpu(memcg->stat->count[i], cpu) = 0;
-- 
1.7.10.1

