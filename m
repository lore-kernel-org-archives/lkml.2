Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755857Ab1GKUek (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jul 2011 16:34:40 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:57709 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753876Ab1GKUei (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jul 2011 16:34:38 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        David Miller <davem@davemloft.net>,
        Chris Metcalf <cmetcalf@tilera.com>, Guan Xuetao <gxt@mprc.pku.edu.cn>,
        Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com>,
        Mike Frysinger <vapier@gentoo.org>, Ralf Baechle <ralf@linux-mips.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Russell King <linux@arm.linux.org.uk>,
        Paul Mackerras <paulus@samba.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Paul Mundt <lethal@linux-sh.org>
Subject: [PATCH 0/3] rcu: Fix some rcu uses in extended quiescent state
Date: Mon, 11 Jul 2011 22:34:29 +0200
Message-Id: <1310416472-2554-1-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

First patch lays the ground to fix rcu uses in dyntick idle mode
by splitting rcu extended qs state logic from tick nohz one.

The rest fixes the misuses that RCU has detected for me in x86.

I'll try to fix those Paul has detected in PowerPc.

Frederic Weisbecker (3):
  nohz: Split extended quiescent state handling from nohz switch
  x86: Enter rcu extended qs after idle notifier call
  x86: Call idle notifier after irq_enter()

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
 arch/x86/kernel/process_64.c             |    5 ++++
 include/linux/tick.h                     |   10 +++++--
 kernel/time/tick-sched.c                 |   36 ++++++++++++++++++++++++++---
 23 files changed, 83 insertions(+), 46 deletions(-)

-- 
1.7.5.4

