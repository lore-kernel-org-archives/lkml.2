Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755264Ab2F0AQd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2012 20:16:33 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:56748 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754368Ab2F0AQc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2012 20:16:32 -0400
From: Wanpeng Li <liwp.linux@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Michal Hocko <mhocko@suse.cz>, Johannes Weiner <hannes@cmpxchg.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Balbir Singh <bsingharora@gmail.com>, linux-kernel@vger.kernel.org,
        cgroups@vger.kernel.org, Wanpeng Li <liwp.linux@gmail.com>
Subject: [PATCH v2] memcg: unify mem_control_xxx to memcg_xxx
Date: Wed, 27 Jun 2012 08:16:15 +0800
Message-Id: <1340756175-3420-1-git-send-email-liwp.linux@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wanpeng Li <liwp@linux.vnet.ibm.com>

Changelog:

V2 -> V1:

* replace memory_cgroup_xxx by memcg_xxx

Unify memcg functions to memcg_xxx.

Signed-off-by: Wanpeng Li <liwp.linux@gmail.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Michal Hocko <mhocko@suse.cz>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
---
 mm/memcontrol.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index ccda728..2e81328 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -3999,7 +3999,7 @@ static int mem_cgroup_move_charge_write(struct cgroup *cgrp,
 #endif
 
 #ifdef CONFIG_NUMA
-static int mem_control_numa_stat_show(struct cgroup *cont, struct cftype *cft,
+static int memcg_numa_stat_show(struct cgroup *cont, struct cftype *cft,
 				      struct seq_file *m)
 {
 	int nid;
@@ -4058,7 +4058,7 @@ static inline void mem_cgroup_lru_names_not_uptodate(void)
 	BUILD_BUG_ON(ARRAY_SIZE(mem_cgroup_lru_names) != NR_LRU_LISTS);
 }
 
-static int mem_control_stat_show(struct cgroup *cont, struct cftype *cft,
+static int memcg_stat_show(struct cgroup *cont, struct cftype *cft,
 				 struct seq_file *m)
 {
 	struct mem_cgroup *memcg = mem_cgroup_from_cont(cont);
@@ -4572,7 +4572,7 @@ static struct cftype mem_cgroup_files[] = {
 	},
 	{
 		.name = "stat",
-		.read_seq_string = mem_control_stat_show,
+		.read_seq_string = memcg_stat_show,
 	},
 	{
 		.name = "force_empty",
@@ -4604,7 +4604,7 @@ static struct cftype mem_cgroup_files[] = {
 #ifdef CONFIG_NUMA
 	{
 		.name = "numa_stat",
-		.read_seq_string = mem_control_numa_stat_show,
+		.read_seq_string = memcg_numa_stat_show,
 	},
 #endif
 #ifdef CONFIG_CGROUP_MEM_RES_CTLR_SWAP
-- 
1.7.9.5

