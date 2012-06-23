Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755706Ab2FWGTX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jun 2012 02:19:23 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:49137 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754834Ab2FWGTW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jun 2012 02:19:22 -0400
From: Wanpeng Li <liwp.linux@gmail.com>
To: linux-mm@kvack.org
Cc: Michal Hocko <mhocko@suse.cz>, Johannes Weiner <hannes@cmpxchg.org>,
        Balbir Singh <bsingharora@gmail.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>,
        Minchan Kim <minchan@kernel.org>, linux-kernel@vger.kernel.org,
        cgroups@vger.kernel.org, Gavin Shan <shangw@linux.vnet.ibm.com>,
        Wanpeng Li <liwp.linux@gmail.com>
Subject: [PATCH 5/6] memcg: optimize memcg_get_hierarchical_limit
Date: Sat, 23 Jun 2012 14:18:17 +0800
Message-Id: <1340432297-5362-1-git-send-email-liwp.linux@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wanpeng Li <liwp@linux.vnet.ibm.com>

Optimize memcg_get_hierarchical_limit to save cpu cycle.

Signed-off-by: Wanpeng Li <liwp.linux@gmail.com>
---
 mm/memcontrol.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index c821e36..1ca79e2 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -3917,9 +3917,9 @@ static void memcg_get_hierarchical_limit(struct mem_cgroup *memcg,
 
 	min_limit = res_counter_read_u64(&memcg->res, RES_LIMIT);
 	min_memsw_limit = res_counter_read_u64(&memcg->memsw, RES_LIMIT);
-	cgroup = memcg->css.cgroup;
 	if (!memcg->use_hierarchy)
 		goto out;
+	cgroup = memcg->css.cgroup;
 
 	while (cgroup->parent) {
 		cgroup = cgroup->parent;
-- 
1.7.9.5

