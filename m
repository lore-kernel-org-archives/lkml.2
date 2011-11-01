Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932281Ab1KAVUL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Nov 2011 17:20:11 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:2153 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753931Ab1KAVUI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Nov 2011 17:20:08 -0400
From: Glauber Costa <glommer@parallels.com>
To: linux-kernel@vger.kernel.org
Cc: paul@paulmenage.org, lizf@cn.fujitsu.com, daniel.lezcano@free.fr,
        a.p.zijlstra@chello.nl, jbottomley@parallels.com, pjt@google.com,
        fweisbec@gmail.com, Glauber Costa <glommer@parallels.com>
Subject: [PATCH v2 01/14] trivial: initialize root cgroup's sibling list
Date: Tue,  1 Nov 2011 19:19:07 -0200
Message-Id: <1320182360-20043-2-git-send-email-glommer@parallels.com>
X-Mailer: git-send-email 1.7.6.4
In-Reply-To: <1320182360-20043-1-git-send-email-glommer@parallels.com>
References: <1320182360-20043-1-git-send-email-glommer@parallels.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Even though there are no siblings, the list should be
initialized not to contain bogus values.

Signed-off-by: Glauber Costa <glommer@parallels.com>
Acked-by: Paul Menage <paul@paulmenage.org>
---
 kernel/sched.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index d87c6e5..e327665 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -8234,6 +8234,7 @@ void __init sched_init(void)
 #ifdef CONFIG_CGROUP_SCHED
 	list_add(&root_task_group.list, &task_groups);
 	INIT_LIST_HEAD(&root_task_group.children);
+	INIT_LIST_HEAD(&root_task_group.siblings);
 	autogroup_init(&init_task);
 #endif /* CONFIG_CGROUP_SCHED */
 
-- 
1.7.6.4

