Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756892Ab2KCQJx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Nov 2012 12:09:53 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:39540 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756206Ab2KCQJw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Nov 2012 12:09:52 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 0/3] cputime: Generic virtual based cputime accounting v4
Date: Sat,  3 Nov 2012 17:09:40 +0100
Message-Id: <1351958983-31355-1-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I'm back on this patchset now that the necessary cputime cleanups are
merged, although more cputime consolidation as in the ctx switch and tick
path should also be done in the future, when I'll get time to cleanup
the s390 part.

So this version of the generic vtime is essentially a rebase against
latest changes (tip:sched/core). Once we get that thing in, we'll need
to handle the cputime read side when the write side is in nohz mode. Probably
no big deal but let's move step by step, as usual.

Comments?

This can be fetched from:

git://git.kernel.org/pub/scm/linux/kernel/git/frederic/linux-dynticks.git
	vtime/generic-v4


Frederic Weisbecker (3):
  context_tracking: New context tracking susbsystem
  cputime: Allow dynamic switch between tick/virtual based cputime
    accounting
  cputime: Generic on-demand virtual cputime accounting

 arch/Kconfig                                       |   12 +-
 arch/ia64/include/asm/cputime.h                    |    5 +
 arch/ia64/kernel/time.c                            |    2 +-
 arch/powerpc/include/asm/cputime.h                 |    5 +
 arch/powerpc/kernel/time.c                         |    2 +-
 arch/s390/include/asm/cputime.h                    |    5 +
 arch/s390/kernel/vtime.c                           |    2 +-
 arch/x86/Kconfig                                   |    2 +-
 arch/x86/include/asm/{rcu.h => context_tracking.h} |   13 +-
 arch/x86/kernel/entry_64.S                         |    2 +-
 arch/x86/kernel/ptrace.c                           |    8 +-
 arch/x86/kernel/signal.c                           |    5 +-
 arch/x86/kernel/traps.c                            |    2 +-
 arch/x86/mm/fault.c                                |    2 +-
 include/linux/context_tracking.h                   |   46 ++++++
 include/linux/rcupdate.h                           |    2 -
 include/linux/sched.h                              |   13 +--
 include/linux/vtime.h                              |   14 ++
 init/Kconfig                                       |   41 ++++--
 kernel/Makefile                                    |    1 +
 kernel/context_tracking.c                          |   71 +++++++++
 kernel/fork.c                                      |    3 +-
 kernel/rcutree.c                                   |   64 +--------
 kernel/sched/core.c                                |    9 +-
 kernel/sched/cputime.c                             |  152 ++++++++++++++++----
 kernel/time/tick-sched.c                           |    5 +-
 26 files changed, 335 insertions(+), 153 deletions(-)
 rename arch/x86/include/asm/{rcu.h => context_tracking.h} (69%)
 create mode 100644 include/linux/context_tracking.h
 create mode 100644 kernel/context_tracking.c

-- 
1.7.5.4

