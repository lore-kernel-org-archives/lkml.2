Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751864Ab2FRNKo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 09:10:44 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:63022 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750992Ab2FRNKn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 09:10:43 -0400
From: Wanpeng Li <liwp.linux@gmail.com>
To: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.cz>,
        Balbir Singh <bsingharora@gmail.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Gavin Shan <shangw@linux.vnet.ibm.com>,
        Wanpeng Li <liwp.linux@gmail.com>
Subject: [PATCH] mm/memcg: add unlikely to mercg->move_charge_at_immigrate
Date: Mon, 18 Jun 2012 21:10:21 +0800
Message-Id: <1340025022-7272-1-git-send-email-liwp.linux@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wanpeng Li <liwp@linux.vnet.ibm.com>

move_charge_at_immigrate feature is disabled by default. Charges
are moved only when you move mm->owner and it also add additional
overhead.

Signed-off-by: Wanpeng Li <liwp.linux@gmail.com>
---
 mm/memcontrol.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index a9c3d01..795a00f 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -5316,7 +5316,7 @@ static int mem_cgroup_can_attach(struct cgroup *cgroup,
 	int ret = 0;
 	struct mem_cgroup *memcg = mem_cgroup_from_cont(cgroup);
 
-	if (memcg->move_charge_at_immigrate) {
+	if (unlikely(memcg->move_charge_at_immigrate)) {
 		struct mm_struct *mm;
 		struct mem_cgroup *from = mem_cgroup_from_task(p);
 
-- 
1.7.9.5

