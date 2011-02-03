Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932226Ab1BCOLU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Feb 2011 09:11:20 -0500
Received: from zene.cmpxchg.org ([85.214.230.12]:56915 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932169Ab1BCOLS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Feb 2011 09:11:18 -0500
Date: Thu, 3 Feb 2011 15:11:10 +0100
From: Johannes Weiner <hannes@cmpxchg.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        Balbir Singh <balbir@linux.vnet.ibm.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: [patch] memcg: remove impossible conditional when committing
Message-ID: <20110203141110.GF2286@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No callsite ever passes a NULL pointer for a struct mem_cgroup * to
the committing function.  There is no need to check for it.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
---
 mm/memcontrol.c |    4 ----
 1 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 031ff07..a145c9e 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2092,10 +2092,6 @@ static void __mem_cgroup_commit_charge(struct mem_cgroup *mem,
 {
 	int nr_pages = page_size >> PAGE_SHIFT;
 
-	/* try_charge() can return NULL to *memcg, taking care of it. */
-	if (!mem)
-		return;
-
 	lock_page_cgroup(pc);
 	if (unlikely(PageCgroupUsed(pc))) {
 		unlock_page_cgroup(pc);
-- 
1.7.4

