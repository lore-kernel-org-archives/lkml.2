Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754428Ab1HTRbN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Aug 2011 13:31:13 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:54864 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752045Ab1HTRbJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Aug 2011 13:31:09 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        "H. Peter Anvin" <hpa@zytor.com>, David Miller <davem@davemloft.net>,
        Chris Metcalf <cmetcalf@tilera.com>, Guan Xuetao <gxt@mprc.pku.edu.cn>,
        Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com>,
        Mike Frysinger <vapier@gentoo.org>, Ralf Baechle <ralf@linux-mips.org>,
        Russell King <linux@arm.linux.org.uk>,
        Paul Mackerras <paulus@samba.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Paul Mundt <lethal@linux-sh.org>, Ingo Molnar <mingo@elte.hu>
Subject: [PATCH 0/4 v2] rcu: Fix some rcu uses in extended quiescent state
Date: Sat, 20 Aug 2011 19:30:48 +0200
Message-Id: <1313861452-24783-1-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have changed a bit the first patch by adding a "rcu_ext_qs"
parameter in tick_nohz_enter_idle() so we just need to toggle that
parameter to false when rcu_enter_nohz() is called separately.
That's less confusing and more consistant than calling
tick_nohz_stop_sched_tick() instead of tick_nohz_enter_idle()
when rcu dynticks idle mode is handled separately.

It's an important enough change that I thought I had to drop
all the acks in the first patch.

Also it adds a new fix for a new bug detected in patch 4.

The powerpc case is trickier so I prefer to get that pile
handled before.

Thanks.

Frederic Weisbecker (4):
  nohz: Split extended quiescent state handling from nohz switch
  x86: Enter rcu extended qs after idle notifier call
  x86: Call idle notifier after irq_enter()
  rcu: Fix early call to rcu_irq_exit()

 arch/arm/kernel/process.c                |    4 +-
 arch/avr32/kernel/process.c              |    4 +-
 arch/blackfin/kernel/process.c           |    4 +-
 arch/microblaze/kernel/process.c         |    4 +-
 arch/mips/kernel/process.c               |    4 +-
 arch/powerpc/kernel/idle.c               |    4 +-
 arch/powerpc/platforms/iseries/setup.c   |    8 +++---
 arch/s390/kernel/process.c               |    4 +-
 arch/sh/kernel/idle.c                    |    2 +-
 arch/sparc/kernel/process_64.c           |    4 +-
 arch/tile/kernel/process.c               |    4 +-
 arch/um/kernel/process.c                 |    4 +-
 arch/unicore32/kernel/process.c          |    4 +-
 arch/x86/kernel/apic/apic.c              |    6 ++--
 arch/x86/kernel/apic/io_apic.c           |    2 +-
 arch/x86/kernel/cpu/mcheck/mce.c         |    2 +-
 arch/x86/kernel/cpu/mcheck/therm_throt.c |    2 +-
 arch/x86/kernel/cpu/mcheck/threshold.c   |    2 +-
 arch/x86/kernel/irq.c                    |    6 ++--
 arch/x86/kernel/process_32.c             |    4 +-
 arch/x86/kernel/process_64.c             |    9 ++++++-
 include/linux/tick.h                     |    9 ++++---
 kernel/softirq.c                         |    2 +-
 kernel/time/tick-sched.c                 |   31 +++++++++++++++++++++++++----
 24 files changed, 78 insertions(+), 51 deletions(-)

-- 
1.7.5.4

