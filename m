Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757098Ab2BXBWb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Feb 2012 20:22:31 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:49985 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757045Ab2BXBWa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Feb 2012 20:22:30 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of anton.vorontsov@linaro.org designates 10.205.117.141 as permitted sender) smtp.mail=anton.vorontsov@linaro.org
Date: Fri, 24 Feb 2012 05:22:27 +0400
From: Anton Vorontsov <anton.vorontsov@linaro.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Michal Hocko <mhocko@suse.cz>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        cgroups@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] mm: memcg: Remove redundant BUG_ON() in
 mem_cgroup_usage_unregister_event
Message-ID: <20120224012227.GA32689@oksana.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the following code:

	if (type == _MEM)
		thresholds = &memcg->thresholds;
	else if (type == _MEMSWAP)
		thresholds = &memcg->memsw_thresholds;
	else
		BUG();

	BUG_ON(!thresholds);

The BUG_ON() seems redundant.

Signed-off-by: Anton Vorontsov <anton.vorontsov@linaro.org>
---
 mm/memcontrol.c |    6 ------
 1 files changed, 0 insertions(+), 6 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 6728a7a..b423577 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -4404,20 +4404,14 @@ static void mem_cgroup_usage_unregister_event(struct cgroup *cgrp,
 	if (type == _MEM)
 		thresholds = &memcg->thresholds;
 	else if (type == _MEMSWAP)
 		thresholds = &memcg->memsw_thresholds;
 	else
 		BUG();
 
-	/*
-	 * Something went wrong if we trying to unregister a threshold
-	 * if we don't have thresholds
-	 */
-	BUG_ON(!thresholds);
-
 	usage = mem_cgroup_usage(memcg, type == _MEMSWAP);
 
 	/* Check if a threshold crossed before removing */
 	__mem_cgroup_threshold(memcg, type == _MEMSWAP);
 
 	/* Calculate new number of threshold */
 	size = 0;
-- 
1.7.9
