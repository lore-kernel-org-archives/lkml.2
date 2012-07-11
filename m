Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758220Ab2GKS0y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 14:26:54 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:47918 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754612Ab2GKS0v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 14:26:51 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Alessio Igor Bogani <abogani@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, Avi Kivity <avi@redhat.com>,
        Chris Metcalf <cmetcalf@tilera.com>, Christoph Lameter <cl@linux.com>,
        Geoff Levand <geoff@infradead.org>,
        Gilad Ben Yossef <gilad@benyossef.com>,
        Hakan Akkan <hakanakkan@gmail.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@kernel.org>, Josh Triplett <josh@joshtriplett.org>,
        Kevin Hilman <khilman@ti.com>, Max Krasnyansky <maxk@qualcomm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Sven-Thorsten Dietrich <thebigcorporation@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [RFC PATCH 00/11] rcu: Userspace RCU extended quiescent state v2
Date: Wed, 11 Jul 2012 20:26:29 +0200
Message-Id: <1342031200-22731-1-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

There are significant changes this time. I reverted back to using
a TIF flag to hook on syscalls slow path and put the hooks on
high level exception handlers instead of low level ones.

It makes the code more portable between x86-32 and x86-64, it
makes the hooks clearer and easier to review and the overhead
is lowered in the off-case. This can be even better if we use
jump labels later.

Thanks.

git://github.com/fweisbec/linux-dynticks.git
	rcu/user-2

Frederic Weisbecker (11):
  rcu: Settle config for userspace extended quiescent state
  rcu: Allow rcu_user_enter()/exit() to nest
  rcu: Ignore userspace extended quiescent state by default
  rcu: Switch task's syscall hooks on context switch
  x86: Syscall hooks for userspace RCU extended QS
  x86: Exception hooks for userspace RCU extended QS
  rcu: Exit RCU extended QS on kernel preemption after irq/exception
  rcu: Exit RCU extended QS on user preemption
  x86: Use the new schedule_user API on userspace preemption
  x86: Exit RCU extended QS on notify resume
  rcu: Userspace RCU extended QS selftest

 arch/Kconfig                       |   10 ++++++
 arch/um/drivers/mconsole_kern.c    |    2 +-
 arch/x86/Kconfig                   |    1 +
 arch/x86/include/asm/rcu.h         |   20 +++++++++++
 arch/x86/include/asm/thread_info.h |   10 ++++--
 arch/x86/kernel/entry_64.S         |    8 ++--
 arch/x86/kernel/ptrace.c           |    5 +++
 arch/x86/kernel/signal.c           |    4 ++
 arch/x86/kernel/traps.c            |   30 ++++++++++++----
 arch/x86/mm/fault.c                |   13 ++++++-
 include/linux/rcupdate.h           |   10 ++++++
 include/linux/sched.h              |   20 ++++++-----
 init/Kconfig                       |   18 ++++++++++
 kernel/rcutree.c                   |   64 +++++++++++++++++++++++++++++++-----
 kernel/rcutree.h                   |    4 ++
 kernel/sched/core.c                |   10 +++++-
 16 files changed, 192 insertions(+), 37 deletions(-)
 create mode 100644 arch/x86/include/asm/rcu.h

-- 
1.7.5.4

