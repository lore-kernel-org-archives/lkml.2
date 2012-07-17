Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753347Ab2GQJnM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2012 05:43:12 -0400
Received: from e28smtp02.in.ibm.com ([122.248.162.2]:40291 "EHLO
	e28smtp02.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752890Ab2GQJnG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2012 05:43:06 -0400
From: Wanpeng Li <liwanp@linux.vnet.ibm.com>
To: linux-mm@kvack.org
Cc: Michal Hocko <mhocko@suse.cz>, Johannes Weiner <hannes@cmpxchg.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
        Gavin Shan <shangw@linux.vnet.ibm.com>,
        Wanpeng Li <liwanp@linux.vnet.ibm.com>
Subject: [PATCH] mm/memcg: remove redundant checking on root memcg
Date: Tue, 17 Jul 2012 17:42:27 +0800
Message-Id: <1342518147-10406-1-git-send-email-liwanp@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.5.4
x-cbid: 12071709-5816-0000-0000-0000039F052A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Function __mem_cgroup_cancel_local_charge is only called by
mem_cgroup_move_parent. For this case, root memcg has been
checked by mem_cgroup_move_parent. So we needn't check that
again in function __mem_cgroup_cancel_local_charge and just
remove the check in function __mem_cgroup_cancel_local_charge.

Signed-off-by: Wanpeng Li <liwanp@linux.vnet.ibm.com>
---
 mm/memcontrol.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 6392c0a..d346347 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2404,9 +2404,6 @@ static void __mem_cgroup_cancel_local_charge(struct mem_cgroup *memcg,
 {
 	unsigned long bytes = nr_pages * PAGE_SIZE;
 
-	if (mem_cgroup_is_root(memcg))
-		return;
-
 	res_counter_uncharge_until(&memcg->res, memcg->res.parent, bytes);
 	if (do_swap_account)
 		res_counter_uncharge_until(&memcg->memsw,
-- 
1.7.5.4

