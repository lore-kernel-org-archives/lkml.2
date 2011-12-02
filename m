Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756227Ab1LBV7Z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Dec 2011 16:59:25 -0500
Received: from mailhub.sw.ru ([195.214.232.25]:17128 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756141Ab1LBV7X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Dec 2011 16:59:23 -0500
From: Glauber Costa <glommer@parallels.com>
To: linux-kernel@vger.kernel.org
Cc: a.p.zijlstra@chello.nl, Glauber Costa <glommer@parallels.com>
Subject: [PATCH 2/2] fix parameter passing in task_group_account_field
Date: Fri,  2 Dec 2011 19:58:39 -0200
Message-Id: <1322863119-14225-3-git-send-email-glommer@parallels.com>
X-Mailer: git-send-email 1.7.6.4
In-Reply-To: <1322863119-14225-1-git-send-email-glommer@parallels.com>
References: <1322863119-14225-1-git-send-email-glommer@parallels.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The order of parameters is inverted. The index parameter
should come first.

Signed-off-by: Glauber Costa <glommer@parallels.com>
---
 kernel/sched/core.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index b908df3..9fd0038 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -2585,8 +2585,8 @@ struct cgroup_subsys cpuacct_subsys;
 struct cpuacct root_cpuacct;
 #endif
 
-static inline void task_group_account_field(struct task_struct *p,
-					     u64 tmp, int index)
+static inline void task_group_account_field(struct task_struct *p, int index,
+					    u64 tmp)
 {
 #ifdef CONFIG_CGROUP_CPUACCT
 	struct kernel_cpustat *kcpustat;
-- 
1.7.6.4

