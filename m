Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751633Ab2FRL7l (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 07:59:41 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:51277 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751277Ab2FRL7k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 07:59:40 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.7.4
Message-ID: <4FDF17A3.9060202@jp.fujitsu.com>
Date: Mon, 18 Jun 2012 20:57:23 +0900
From: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 6.0; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: linux-mm <linux-mm@kvack.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        cgroups@vger.kernel.org, Michal Hocko <mhocko@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        Johannes Weiner <hannes@cmpxchg.org>
Subject: [PATCH 1/2] memcg: remove -EINTR at rmdir()
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2 follow-up patches for "memcg: move charges to root cgroup if use_hierarchy=0",
developped/tested onto memcg-devel tree. Maybe no HUNK with -next and -mm....
-Kame
==
memcg: remove -EINTR at rmdir()

By commit "memcg: move charges to root cgroup if use_hierarchy=0",
no memory reclaiming will occur at removing memory cgroup.

So, we don't need to take care of user interrupt by signal. This
patch removes it.
(*) If -EINTR is returned here, cgroup will show WARNING.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
---
 mm/memcontrol.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 0623300..cf8a0f6 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -3890,9 +3890,6 @@ move_account:
 		ret = -EBUSY;
 		if (cgroup_task_count(cgrp) || !list_empty(&cgrp->children))
 			goto out;
-		ret = -EINTR;
-		if (signal_pending(current))
-			goto out;
 		/* This is for making all *used* pages to be on LRU. */
 		lru_add_drain_all();
 		drain_all_stock_sync(memcg);
-- 
1.7.4.1


