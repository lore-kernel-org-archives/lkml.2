Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753262Ab1IZKTX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Sep 2011 06:19:23 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:49679 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752282Ab1IZKTW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Sep 2011 06:19:22 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andy Henroid <andrew.d.henroid@intel.com>,
        Mike Frysinger <vapier@gentoo.org>, Guan Xuetao <gxt@mprc.pku.edu.cn>,
        David Miller <davem@davemloft.net>,
        Chris Metcalf <cmetcalf@tilera.com>,
        Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com>,
        Ralf Baechle <ralf@linux-mips.org>,
        Russell King <linux@arm.linux.org.uk>,
        Paul Mackerras <paulus@samba.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Paul Mundt <lethal@linux-sh.org>, Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: [PATCH 0/7 v4] rcu: Fix some rcu uses in extended quiescent state  
Date: Mon, 26 Sep 2011 12:19:05 +0200
Message-Id: <1317032352-25571-1-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Paul,

Two fixes added in that set, the first two patches:

- The check on uses under extended quiescent states was buggy
- One more illegal use of RCU fixed, from inside tick_nohz_stop_sched_tick()

It has survived one day and one night of rcutorture in x86-64
with periodic cpu hotplug onlining/offlining...

No test in powerpc yet though... So I don't know yet why
you got an rcutorture failure.

Frederic Weisbecker (7):
  rcu: Fix preempt-unsafe debug check of rcu extended quiescent state
  rcu: Fix early call to rcu_enter_nohz() on tick stopping
  nohz: Separate out irq exit and idle loop dyntick logic
  nohz: Allow rcu extended quiescent state handling seperately from
    tick stop
  x86: Enter rcu extended qs after idle notifier call
  x86: Call idle notifier after irq_enter()
  rcu: Fix early call to rcu_irq_exit()

 arch/arm/kernel/process.c                |    4 +-
 arch/avr32/kernel/process.c              |    4 +-
 arch/blackfin/kernel/process.c           |    4 +-
 arch/microblaze/kernel/process.c         |    4 +-
 arch/mips/kernel/process.c               |    4 +-
 arch/powerpc/kernel/idle.c               |    4 +-
 arch/powerpc/platforms/iseries/setup.c   |    8 +-
 arch/s390/kernel/process.c               |    4 +-
 arch/sh/kernel/idle.c                    |    4 +-
 arch/sparc/kernel/process_64.c           |    4 +-
 arch/tile/kernel/process.c               |    4 +-
 arch/um/kernel/process.c                 |    4 +-
 arch/unicore32/kernel/process.c          |    4 +-
 arch/x86/kernel/apic/apic.c              |    6 +-
 arch/x86/kernel/apic/io_apic.c           |    2 +-
 arch/x86/kernel/cpu/mcheck/mce.c         |    2 +-
 arch/x86/kernel/cpu/mcheck/therm_throt.c |    2 +-
 arch/x86/kernel/cpu/mcheck/threshold.c   |    2 +-
 arch/x86/kernel/irq.c                    |    6 +-
 arch/x86/kernel/process_32.c             |    4 +-
 arch/x86/kernel/process_64.c             |    9 ++-
 include/linux/tick.h                     |   12 ++-
 kernel/rcutree.c                         |   10 ++-
 kernel/softirq.c                         |    4 +-
 kernel/time/tick-sched.c                 |  120 +++++++++++++++++++++---------
 25 files changed, 147 insertions(+), 88 deletions(-)

-- 
1.7.5.4

