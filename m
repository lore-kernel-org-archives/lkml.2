Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932527Ab1BYOoX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Feb 2011 09:44:23 -0500
Received: from hera.kernel.org ([140.211.167.34]:51224 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754361Ab1BYOoW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Feb 2011 09:44:22 -0500
Date: Fri, 25 Feb 2011 14:43:38 GMT
From: tip-bot for Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        a.p.zijlstra@chello.nl, heiko.carstens@de.ibm.com, tglx@linutronix.de,
        venki@google.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, heiko.carstens@de.ibm.com, tglx@linutronix.de,
        venki@google.com, mingo@elte.hu
In-Reply-To: <20110225133228.GD7469@osiris.boeblingen.de.ibm.com>
References: <20110225133228.GD7469@osiris.boeblingen.de.ibm.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Add #ifdef around irq time accounting functions
Message-ID: <tip-7e9498705e810404ecf29bb2d6fa632b9484c609@git.kernel.org>
Git-Commit-ID: 7e9498705e810404ecf29bb2d6fa632b9484c609
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 25 Feb 2011 14:43:39 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  7e9498705e810404ecf29bb2d6fa632b9484c609
Gitweb:     http://git.kernel.org/tip/7e9498705e810404ecf29bb2d6fa632b9484c609
Author:     Heiko Carstens <heiko.carstens@de.ibm.com>
AuthorDate: Fri, 25 Feb 2011 14:32:28 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 25 Feb 2011 14:39:48 +0100

sched: Add #ifdef around irq time accounting functions

Get rid of this:

 kernel/sched.c:3731:13: warning: 'irqtime_account_idle_ticks' defined but not used
 kernel/sched.c:3732:13: warning: 'irqtime_account_process_tick' defined but not used

Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Venkatesh Pallipadi <venki@google.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <20110225133228.GD7469@osiris.boeblingen.de.ibm.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/sched.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 2effcb7..79bca16 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -3687,6 +3687,7 @@ void account_system_time(struct task_struct *p, int hardirq_offset,
 	__account_system_time(p, cputime, cputime_scaled, target_cputime64);
 }
 
+#ifndef CONFIG_VIRT_CPU_ACCOUNTING
 #ifdef CONFIG_IRQ_TIME_ACCOUNTING
 /*
  * Account a tick to a process and cpustat
@@ -3753,6 +3754,7 @@ static void irqtime_account_idle_ticks(int ticks) {}
 static void irqtime_account_process_tick(struct task_struct *p, int user_tick,
 						struct rq *rq) {}
 #endif
+#endif /* !CONFIG_VIRT_CPU_ACCOUNTING */
 
 /*
  * Account for involuntary wait time.
