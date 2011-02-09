Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754121Ab1BIKou (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Feb 2011 05:44:50 -0500
Received: from zene.cmpxchg.org ([85.214.230.12]:41034 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752817Ab1BIKot (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Feb 2011 05:44:49 -0500
From: Johannes Weiner <hannes@cmpxchg.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        Balbir Singh <balbir@linux.vnet.ibm.com>, <linux-mm@kvack.org>,
        <linux-kernel@vger.kernel.org>
Subject: [patch] memcg: charged pages always have valid per-memcg zone info
Date: Wed,  9 Feb 2011 11:44:35 +0100
Message-Id: <1297248275-23521-1-git-send-email-hannes@cmpxchg.org>
X-Mailer: git-send-email 1.7.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

page_cgroup_zoneinfo() will never return NULL for a charged page,
remove the check for it in mem_cgroup_get_reclaim_stat_from_page().

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
---
 mm/memcontrol.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

Andrew, this is a follow-up to 'memcg: no uncharged pages reach
page_cgroup_zoneinfo'.

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 686f1ce..6d007d6 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -1017,9 +1017,6 @@ mem_cgroup_get_reclaim_stat_from_page(struct page *page)
 	/* Ensure pc->mem_cgroup is visible after reading PCG_USED. */
 	smp_rmb();
 	mz = page_cgroup_zoneinfo(pc->mem_cgroup, page);
-	if (!mz)
-		return NULL;
-
 	return &mz->reclaim_stat;
 }
 
-- 
1.7.4

