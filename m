Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752808Ab2GFEwa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 00:52:30 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:63205 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751956Ab2GFEwT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 00:52:19 -0400
From: Wanpeng Li <liwp.linux@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.cz>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        cgroups@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Wanpeng Li <liwp.linux@gmail.com>
Subject: [PATCH] mm/memcg: swappiness should between 0 and 100
Date: Fri,  6 Jul 2012 12:51:52 +0800
Message-Id: <1341550312-6815-1-git-send-email-liwp.linux@gmail.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wanpeng Li <liwp@linux.vnet.ibm.com>

Signed-off-by: Wanpeng Li <liwp.linux@gmail.com>
---
 mm/memcontrol.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 5e4d1ab..69a7d45 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -4176,7 +4176,7 @@ static int mem_cgroup_swappiness_write(struct cgroup *cgrp, struct cftype *cft,
 	struct mem_cgroup *memcg = mem_cgroup_from_cont(cgrp);
 	struct mem_cgroup *parent;
 
-	if (val > 100)
+	if (val > 100 || val < 0)
 		return -EINVAL;
 
 	if (cgrp->parent == NULL)
-- 
1.7.5.4

