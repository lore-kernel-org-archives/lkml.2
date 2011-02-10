Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752131Ab1BJMYb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 07:24:31 -0500
Received: from cantor2.suse.de ([195.135.220.15]:37590 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751111Ab1BJMYa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 07:24:30 -0500
From: Mike Galbraith <efault@gmx.de>
Date: Thu, 10 Feb 2011 10:27:18 +0100
Subject: [PATCH 00/28] 2.6.32.stable scheduler backport series
To: stable@kernel.org
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@elte.hu>
Message-ID: <1297340643.5512.0.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.1.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alex Shi (1):
  sched: Fix volanomark performance regression

Dave Young (1):
  sched: Remove unused PF_ALIGNWARN flag

Dhaval Giani (1):
  sched: Remove USER_SCHED

Ingo Molnar (1):
  sched: Export account_system_vtime()

Li Zefan (1):
  sched: Remove remaining USER_SCHED code

Nikhil Rao (4):
  sched: Do not consider SCHED_IDLE tasks to be cache hot
  sched: Force balancing on newidle balance if local group has capacity
  sched: Drop group_capacity to 1 only if local group has extra capacity
  sched: Fix idle balancing

Paul E. McKenney (1):
  sched: suppress RCU lockdep splat in task_fork_fair

Peter Zijlstra (4):
  sched: fix RCU lockdep splat from task_group()
  sched, cgroup: Fixup broken cgroup movement
  sched: Fix cross-sched-class wakeup preemption
  sched: Fix wake_affine() vs RT tasks

Steven Rostedt (2):
  sched: Try not to migrate higher priority RT tasks
  sched: Give CPU bound RT tasks preference

Suresh Siddha (2):
  sched: Move sched_avg_update() to update_cpu_load()
  sched: Use group weight, idle cpu metrics to fix imbalances during idle

Venkatesh Pallipadi (9):
  sched: Increment cache_nice_tries only on periodic lb
  sched: Fix softirq time accounting
  sched: Consolidate account_system_vtime extern declaration
  sched: Add a PF flag for ksoftirqd identification
  sched: Add IRQ_TIME_ACCOUNTING, finer accounting of irq time
  x86: Add IRQ_TIME_ACCOUNTING
  sched: Do not account irq time to current task
  sched: Remove irq time from available CPU power
  sched: Call tick_check_idle before __irq_enter

Nikhil Rao (1):
  sched: Set group_imb only a task can be pulled from the busiest cpu

 Documentation/kernel-parameters.txt |    4 +
 arch/ia64/include/asm/system.h      |    4 -
 arch/powerpc/include/asm/system.h   |    4 -
 arch/s390/include/asm/system.h      |    1 -
 arch/x86/Kconfig                    |   11 +
 arch/x86/kernel/tsc.c               |    8 +
 include/linux/hardirq.h             |    9 +-
 include/linux/sched.h               |   39 ++--
 init/Kconfig                        |   80 +++-----
 kernel/capability.c                 |    1 -
 kernel/cred-internals.h             |   21 --
 kernel/cred.c                       |    3 -
 kernel/exit.c                       |    1 -
 kernel/ksysfs.c                     |    8 -
 kernel/sched.c                      |  392 ++++++++++++++++++++++-------------
 kernel/sched_debug.c                |    5 -
 kernel/sched_fair.c                 |   56 ++++--
 kernel/sched_features.h             |    5 +
 kernel/sched_rt.c                   |   34 ++--
 kernel/softirq.c                    |   64 ++++--
 kernel/sys.c                        |    5 -
 kernel/user.c                       |  315 +----------------------------
 net/sched/cls_cgroup.c              |    2 +-
 23 files changed, 438 insertions(+), 634 deletions(-)
 delete mode 100644 kernel/cred-internals.h

-- 
1.7.4

