Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752681Ab1IWWWJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Sep 2011 18:22:09 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:32825 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751290Ab1IWWWI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Sep 2011 18:22:08 -0400
From: Glauber Costa <glommer@parallels.com>
To: linux-kernel@vger.kernel.org
Cc: paul@paulmenage.org, lizf@cn.fujitsu.com, daniel.lezcano@free.fr,
        a.p.zijlstra@chello.nl, jbottomley@parallels.com,
        Glauber Costa <glommer@parallels.com>
Subject: [PATCH] trivial: initialize root cgroup's sibling list
Date: Fri, 23 Sep 2011 19:19:49 -0300
Message-Id: <1316816389-9135-1-git-send-email-glommer@parallels.com>
X-Mailer: git-send-email 1.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Even though there are no siblings, the list should be
initialized not to contain bogus values.

Signed-off-by: Glauber Costa <glommer@parallels.com>
---
 kernel/sched.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index ccacdbd..3ed4107 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -8082,6 +8082,7 @@ void __init sched_init(void)
 #ifdef CONFIG_CGROUP_SCHED
 	list_add(&root_task_group.list, &task_groups);
 	INIT_LIST_HEAD(&root_task_group.children);
+	INIT_LIST_HEAD(&root_task_group.siblings);
 	autogroup_init(&init_task);
 #endif /* CONFIG_CGROUP_SCHED */
 
-- 
1.7.6

