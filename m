Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754636Ab2FYGGd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2012 02:06:33 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:39993 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753632Ab2FYGGb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2012 02:06:31 -0400
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
Subject: [PATCH 3/5 v2] memcg: change mem_control_xxx to mem_cgroup_xxx
Date: Mon, 25 Jun 2012 14:06:22 +0800
Message-Id: <1340604382-8091-1-git-send-email-liwp.linux@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wanpeng Li <liwp@linux.vnet.ibm.com>

Unify memcg functions to mem_cgroup_xxx.

Signed-off-by: Wanpeng Li <liwp.linux@gmail.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
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
+static int mem_cgroup_numa_stat_show(struct cgroup *cont, struct cftype *cft,
 				      struct seq_file *m)
 {
 	int nid;
@@ -4058,7 +4058,7 @@ static inline void mem_cgroup_lru_names_not_uptodate(void)
 	BUILD_BUG_ON(ARRAY_SIZE(mem_cgroup_lru_names) != NR_LRU_LISTS);
 }
 
-static int mem_control_stat_show(struct cgroup *cont, struct cftype *cft,
+static int mem_cgroup_stat_show(struct cgroup *cont, struct cftype *cft,
 				 struct seq_file *m)
 {
 	struct mem_cgroup *memcg = mem_cgroup_from_cont(cont);
@@ -4572,7 +4572,7 @@ static struct cftype mem_cgroup_files[] = {
 	},
 	{
 		.name = "stat",
-		.read_seq_string = mem_control_stat_show,
+		.read_seq_string = mem_cgroup_stat_show,
 	},
 	{
 		.name = "force_empty",
@@ -4604,7 +4604,7 @@ static struct cftype mem_cgroup_files[] = {
 #ifdef CONFIG_NUMA
 	{
 		.name = "numa_stat",
-		.read_seq_string = mem_control_numa_stat_show,
+		.read_seq_string = mem_cgroup_numa_stat_show,
 	},
 #endif
 #ifdef CONFIG_CGROUP_MEM_RES_CTLR_SWAP
-- 
1.7.9.5

