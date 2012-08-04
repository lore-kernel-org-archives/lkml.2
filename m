Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753391Ab2HDPXF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Aug 2012 11:23:05 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:37835 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753053Ab2HDPW7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Aug 2012 11:22:59 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Alessio Igor Bogani <abogani@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, Avi Kivity <avi@redhat.com>,
        Chris Metcalf <cmetcalf@tilera.com>, Christoph Lameter <cl@linux.com>,
        Geoff Levand <geoff@infradead.org>,
        Gilad Ben Yossef <gilad@benyossef.com>,
        Hakan Akkan <hakanakkan@gmail.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@kernel.org>, Kevin Hilman <khilman@ti.com>,
        Max Krasnyansky <maxk@qualcomm.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Sven-Thorsten Dietrich <thebigcorporation@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 0/5] cputime: Generic virtual based cputime accounting v3
Date: Sat,  4 Aug 2012 17:22:44 +0200
Message-Id: <1344093769-30661-1-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Changes since v2 (https://lwn.net/Articles/509575/) are only about
converting the "code domain tracking" naming to "context tracking"
as per Ingo's suggestion. And the result indeed looks much better.

Ring 0 dark knights can pull from:

git://github.com/fweisbec/linux-dynticks.git
	vtime/generic-v3

Warning: this includes dependencies on rcu/idle and vtime
consolidation patchset.

Frederic Weisbecker (5):
  context_tracking: New context tracking susbsystem
  cputime: Don't allow virtual and irq finegrained cputime accounting
    simultaneously
  cputime: Allow dynamic switch between tick/virtual based cputime
    accounting
  cputime: Rename account_system_vtime to account_vtime
  cputime: Generic on-demand virtual cputime accounting

 arch/Kconfig                                       |   12 +-
 arch/ia64/include/asm/cputime.h                    |    5 +
 arch/ia64/kernel/time.c                            |    6 +-
 arch/powerpc/include/asm/cputime.h                 |    5 +
 arch/powerpc/kernel/time.c                         |   10 +-
 arch/s390/include/asm/cputime.h                    |    5 +
 arch/s390/kernel/vtime.c                           |    6 +-
 arch/x86/Kconfig                                   |    2 +-
 arch/x86/include/asm/{rcu.h => context_tracking.h} |   12 +-
 arch/x86/kernel/ptrace.c                           |    6 +-
 arch/x86/kernel/signal.c                           |    5 +-
 arch/x86/kernel/traps.c                            |    2 +-
 arch/x86/mm/fault.c                                |    2 +-
 include/asm-generic/cputime.h                      |    7 +
 include/linux/context_tracking.h                   |   44 ++++++
 include/linux/hardirq.h                            |    8 +-
 include/linux/kernel_stat.h                        |   13 ++
 include/linux/kvm_host.h                           |    4 +-
 include/linux/rcupdate.h                           |    2 -
 include/linux/sched.h                              |   13 +--
 init/Kconfig                                       |   35 +++--
 kernel/Makefile                                    |    1 +
 kernel/context_tracking.c                          |   46 ++++++
 kernel/fork.c                                      |    3 +-
 kernel/rcutree.c                                   |   42 +-----
 kernel/sched/core.c                                |    9 +-
 kernel/sched/cputime.c                             |  159 ++++++++++++++++----
 kernel/softirq.c                                   |    6 +-
 kernel/time/tick-sched.c                           |   28 ++--
 29 files changed, 347 insertions(+), 151 deletions(-)
 rename arch/x86/include/asm/{rcu.h => context_tracking.h} (52%)
 create mode 100644 include/linux/context_tracking.h
 create mode 100644 kernel/context_tracking.c

-- 
1.7.5.4

