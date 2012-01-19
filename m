Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757132Ab2ASWll (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jan 2012 17:41:41 -0500
Received: from terminus.zytor.com ([198.137.202.10]:38449 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756547Ab2ASWlk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jan 2012 17:41:40 -0500
Date: Thu, 19 Jan 2012 14:40:53 -0800
Message-Id: <201201192240.q0JMer4j003534@tazenda.hos.anvin.org>
From: "H. Peter Anvin" <hpa@zytor.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [GIT PULL] sched fixes for v3.3-rc1
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Glauber Costa <glommer@parallels.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Paul Tuner <pjt@google.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>, Tony Luck <tony.luck@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

The following changes since commit bced76aeaca03b45e3b4bdb868cada328e497847:

  sched: Fix lockup by limiting load-balance retries on lock-break (2012-01-11 17:15:12 +0100)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git sched-urgent-for-linus

The head of this tree is f7e6746ebae984ea67b0a1a1e23c7e6698240631.

Russell King (1):
      sched/accounting, proc: Fix /proc/stat interrupts sum

 fs/proc/stat.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/fs/proc/stat.c b/fs/proc/stat.c
index d76ca6a..121f77c 100644
--- a/fs/proc/stat.c
+++ b/fs/proc/stat.c
@@ -77,6 +77,8 @@ static int show_stat(struct seq_file *p, void *v)
 		steal += kcpustat_cpu(i).cpustat[CPUTIME_STEAL];
 		guest += kcpustat_cpu(i).cpustat[CPUTIME_GUEST];
 		guest_nice += kcpustat_cpu(i).cpustat[CPUTIME_GUEST_NICE];
+		sum += kstat_cpu_irqs_sum(i);
+		sum += arch_irq_stat_cpu(i);
 
 		for (j = 0; j < NR_SOFTIRQS; j++) {
 			unsigned int softirq_stat = kstat_softirqs_cpu(j, i);
