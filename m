Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754239Ab1LFUXF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 15:23:05 -0500
Received: from terminus.zytor.com ([198.137.202.10]:38268 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753413Ab1LFUXD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 15:23:03 -0500
Date: Tue, 6 Dec 2011 12:22:36 -0800
From: tip-bot for Glauber Costa <glommer@parallels.com>
Message-ID: <tip-be726ffd1ef291c04c4d6632ac277afa1c281712@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        a.p.zijlstra@chello.nl, glommer@parallels.com, tglx@linutronix.de,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        glommer@parallels.com, a.p.zijlstra@chello.nl, tglx@linutronix.de,
        mingo@elte.hu
In-Reply-To: <1322863119-14225-3-git-send-email-glommer@parallels.com>
References: <1322863119-14225-3-git-send-email-glommer@parallels.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched/accounting: Fix parameter passing in task_group_account_field
Git-Commit-ID: be726ffd1ef291c04c4d6632ac277afa1c281712
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 06 Dec 2011 12:22:42 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  be726ffd1ef291c04c4d6632ac277afa1c281712
Gitweb:     http://git.kernel.org/tip/be726ffd1ef291c04c4d6632ac277afa1c281712
Author:     Glauber Costa <glommer@parallels.com>
AuthorDate: Fri, 2 Dec 2011 19:58:39 -0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 6 Dec 2011 20:51:24 +0100

sched/accounting: Fix parameter passing in task_group_account_field

The order of parameters is inverted. The index parameter
should come first.

Signed-off-by: Glauber Costa <glommer@parallels.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1322863119-14225-3-git-send-email-glommer@parallels.com
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/sched/core.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 6e86010..9ac22d2 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -2561,8 +2561,8 @@ struct cgroup_subsys cpuacct_subsys;
 struct cpuacct root_cpuacct;
 #endif
 
-static inline void task_group_account_field(struct task_struct *p,
-					     u64 tmp, int index)
+static inline void task_group_account_field(struct task_struct *p, int index,
+					    u64 tmp)
 {
 #ifdef CONFIG_CGROUP_CPUACCT
 	struct kernel_cpustat *kcpustat;
