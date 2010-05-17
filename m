Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756310Ab0EQWeY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 18:34:24 -0400
Received: from hera.kernel.org ([140.211.167.34]:56028 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756225Ab0EQWeW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 18:34:22 -0400
Date: Mon, 17 May 2010 22:33:56 GMT
From: tip-bot for Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       a.p.zijlstra@chello.nl, tj@kernel.org, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, tj@kernel.org, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <tip-3fc1f1e27a5b807791d72e5d992aa33b668a6626@git.kernel.org>
References: <tip-3fc1f1e27a5b807791d72e5d992aa33b668a6626@git.kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] stop_machine: Move local variable closer to the usage site in cpu_stop_cpu_callback()
Message-ID: <tip-9c6f7e43b4e02c161b53e97ba913855246876c61@git.kernel.org>
Git-Commit-ID: 9c6f7e43b4e02c161b53e97ba913855246876c61
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 17 May 2010 22:33:58 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  9c6f7e43b4e02c161b53e97ba913855246876c61
Gitweb:     http://git.kernel.org/tip/9c6f7e43b4e02c161b53e97ba913855246876c61
Author:     Ingo Molnar <mingo@elte.hu>
AuthorDate: Tue, 18 May 2010 00:17:44 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 18 May 2010 00:17:44 +0200

stop_machine: Move local variable closer to the usage site in cpu_stop_cpu_callback()

This addresses the following compiler warning:

 kernel/stop_machine.c: In function 'cpu_stop_cpu_callback':
 kernel/stop_machine.c:297: warning: unused variable 'work'

Cc: Tejun Heo <tj@kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <tip-3fc1f1e27a5b807791d72e5d992aa33b668a6626@git.kernel.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/stop_machine.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/kernel/stop_machine.c b/kernel/stop_machine.c
index ef51d1f..b4e7431 100644
--- a/kernel/stop_machine.c
+++ b/kernel/stop_machine.c
@@ -294,7 +294,6 @@ static int __cpuinit cpu_stop_cpu_callback(struct notifier_block *nfb,
 	struct sched_param param = { .sched_priority = MAX_RT_PRIO - 1 };
 	unsigned int cpu = (unsigned long)hcpu;
 	struct cpu_stopper *stopper = &per_cpu(cpu_stopper, cpu);
-	struct cpu_stop_work *work;
 	struct task_struct *p;
 
 	switch (action & ~CPU_TASKS_FROZEN) {
@@ -323,6 +322,9 @@ static int __cpuinit cpu_stop_cpu_callback(struct notifier_block *nfb,
 #ifdef CONFIG_HOTPLUG_CPU
 	case CPU_UP_CANCELED:
 	case CPU_DEAD:
+	{
+		struct cpu_stop_work *work;
+
 		/* kill the stopper */
 		kthread_stop(stopper->thread);
 		/* drain remaining works */
@@ -335,6 +337,7 @@ static int __cpuinit cpu_stop_cpu_callback(struct notifier_block *nfb,
 		put_task_struct(stopper->thread);
 		stopper->thread = NULL;
 		break;
+	}
 #endif
 	}
 
