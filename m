Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755152Ab2ACXeH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jan 2012 18:34:07 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:58365 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754585Ab2ACXeD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jan 2012 18:34:03 -0500
From: kosaki.motohiro@gmail.com
To: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.cz>,
        cgroups@vger.kernel.org
Subject: [PATCH 2/2] memcg: mark rcu protected member as __rcu
Date: Tue,  3 Jan 2012 18:33:52 -0500
Message-Id: <1325633632-9978-2-git-send-email-kosaki.motohiro@gmail.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1325633632-9978-1-git-send-email-kosaki.motohiro@gmail.com>
References: <1325633632-9978-1-git-send-email-kosaki.motohiro@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

Currently "make C=2 mm/memcontrol.o" makes following warnings. fix it.

mm/memcontrol.c:4243:21: error: incompatible types in comparison expression (different address spaces)
mm/memcontrol.c:4245:21: error: incompatible types in comparison expression (different address spaces)

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: cgroups@vger.kernel.org
---
 mm/memcontrol.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 6adeeec..138be2b 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -195,7 +195,7 @@ struct mem_cgroup_threshold_ary {
 
 struct mem_cgroup_thresholds {
 	/* Primary thresholds array */
-	struct mem_cgroup_threshold_ary *primary;
+	struct mem_cgroup_threshold_ary __rcu *primary;
 	/*
 	 * Spare threshold array.
 	 * This is needed to make mem_cgroup_unregister_event() "never fail".
-- 
1.7.1

