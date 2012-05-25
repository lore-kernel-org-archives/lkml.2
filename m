Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933430Ab2EYQMY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2012 12:12:24 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:35174 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756530Ab2EYQMW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2012 12:12:22 -0400
From: Chen Baozi <baozich@gmail.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Chen Baozi <baozich@gmail.com>
Subject: [PATCH] memcg: remove the unnecessary MEM_CGROUP_STAT_DATA
Date: Fri, 25 May 2012 16:11:41 +0800
Message-Id: <1337933501-3985-1-git-send-email-baozich@gmail.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since MEM_CGROUP_ON_MOVE has been removed, it comes to be redudant
to hold MEM_CGROUP_STAT_DATA to mark the end of data requires
synchronization.

Signed-off-by: Chen Baozi <baozich@gmail.com>
---
 mm/memcontrol.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index f342778..446ca94 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -88,7 +88,6 @@ enum mem_cgroup_stat_index {
 	MEM_CGROUP_STAT_RSS,	   /* # of pages charged as anon rss */
 	MEM_CGROUP_STAT_FILE_MAPPED,  /* # of pages charged as file rss */
 	MEM_CGROUP_STAT_SWAPOUT, /* # of pages, swapped out */
-	MEM_CGROUP_STAT_DATA, /* end of data requires synchronization */
 	MEM_CGROUP_STAT_NSTATS,
 };
 
@@ -2139,7 +2138,7 @@ static void mem_cgroup_drain_pcp_counter(struct mem_cgroup *memcg, int cpu)
 	int i;
 
 	spin_lock(&memcg->pcp_counter_lock);
-	for (i = 0; i < MEM_CGROUP_STAT_DATA; i++) {
+	for (i = 0; i < MEM_CGROUP_STAT_NSTATS; i++) {
 		long x = per_cpu(memcg->stat->count[i], cpu);
 
 		per_cpu(memcg->stat->count[i], cpu) = 0;
-- 
1.7.1

