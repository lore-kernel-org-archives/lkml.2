Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757111Ab1CaMk4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Mar 2011 08:40:56 -0400
Received: from hera.kernel.org ([140.211.167.34]:56744 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750795Ab1CaMky (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Mar 2011 08:40:54 -0400
Date: Thu, 31 Mar 2011 12:40:39 GMT
From: tip-bot for Sisir Koppaka <sisir.koppaka@gmail.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu,
        sisir.koppaka@gmail.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, tglx@linutronix.de, sisir.koppaka@gmail.com,
        mingo@elte.hu
In-Reply-To: <AANLkTikqHWid2Q93F5U5Qw5snJH8C5PXoa7J6=6hYO94@mail.gmail.com>
References: <AANLkTikqHWid2Q93F5U5Qw5snJH8C5PXoa7J6=6hYO94@mail.gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/urgent] sched: Fix rebalance interval calculation
Message-ID: <tip-3436ae1298cb22d722a6520fc97f112dd767a9e1@git.kernel.org>
Git-Commit-ID: 3436ae1298cb22d722a6520fc97f112dd767a9e1
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 31 Mar 2011 12:40:39 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  3436ae1298cb22d722a6520fc97f112dd767a9e1
Gitweb:     http://git.kernel.org/tip/3436ae1298cb22d722a6520fc97f112dd767a9e1
Author:     Sisir Koppaka <sisir.koppaka@gmail.com>
AuthorDate: Sat, 26 Mar 2011 18:22:55 +0530
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 31 Mar 2011 13:00:37 +0200

sched: Fix rebalance interval calculation

The interval for checking scheduling domains if they are due to be
balanced currently depends on boot state NR_CPUS, which may not
accurately reflect the number of online CPUs at the time of check.

Thus replace NR_CPUS with num_online_cpus().

 (ed: Should only affect those who set NR_CPUS really high, such as 4096
      or so :-)

Signed-off-by: Sisir Koppaka <sisir.koppaka@gmail.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <AANLkTikqHWid2Q93F5U5Qw5snJH8C5PXoa7J6=6hYO94@mail.gmail.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/sched_fair.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index 3f7ec9e..c7ec5c8 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -22,6 +22,7 @@
 
 #include <linux/latencytop.h>
 #include <linux/sched.h>
+#include <linux/cpumask.h>
 
 /*
  * Targeted preemption latency for CPU-bound tasks:
@@ -3850,8 +3851,8 @@ static void rebalance_domains(int cpu, enum cpu_idle_type idle)
 		interval = msecs_to_jiffies(interval);
 		if (unlikely(!interval))
 			interval = 1;
-		if (interval > HZ*NR_CPUS/10)
-			interval = HZ*NR_CPUS/10;
+		if (interval > HZ*num_online_cpus()/10)
+			interval = HZ*num_online_cpus()/10;
 
 		need_serialize = sd->flags & SD_SERIALIZE;
 
