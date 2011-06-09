Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757393Ab1FIXrx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 19:47:53 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:56445 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754825Ab1FIXru (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 19:47:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=Wb0O0ZKGSq5p4FtmCNXIQkiiTvIxfcNeWHEE/xS3x+17/QY1ZPbhgG4XddLpAC8R+x
         bNI1DNjCJMbodoKc6hPrs97OQbcfaJfhxjpDJhMjrdpvoGpowGtkRrKmO7EE5pblyL4V
         Lpm2Xp03gVjP+XLh9PvgvX9q5IE7ppXpZlixw=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        David Miller <davem@davemloft.net>,
        Chris Metcalf <cmetcalf@tilera.com>, Guan Xuetao <gxt@mprc.pku.edu.cn>,
        Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com>,
        Mike Frysinger <vapier@gentoo.org>, Ralf Baechle <ralf@linux-mips.org>,
        Russell King <linux@arm.linux.org.uk>,
        Paul Mackerras <paulus@samba.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Paul Mundt <lethal@linux-sh.org>, Milton Miller <miltonm@bga.com>
Subject: [PATCH 0/4 v2] rcu: Detect rcu uses under extended quiescent state, and fix some
Date: Fri, 10 Jun 2011 01:47:23 +0200
Message-Id: <1307663247-5397-1-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In this second version:

- rebase against latest rcu/dev branch of Paul's tree
- handle tiny RCU
- put acks

Frederic Weisbecker (4):
  rcu: Detect uses of rcu read side in extended quiescent states
  nohz: Split extended quiescent state handling from nohz switch
  x86: Don't call idle notifier inside rcu extended QS
  x86: Call idle_exit() after irq_enter()

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
 arch/x86/kernel/apic/io_apic.c           |    3 +-
 arch/x86/kernel/cpu/mcheck/mce.c         |    2 +-
 arch/x86/kernel/cpu/mcheck/therm_throt.c |    2 +-
 arch/x86/kernel/cpu/mcheck/threshold.c   |    2 +-
 arch/x86/kernel/irq.c                    |    5 +--
 arch/x86/kernel/process_32.c             |    4 +-
 arch/x86/kernel/process_64.c             |    7 +++++-
 include/linux/rcupdate.h                 |    9 +++++++
 include/linux/tick.h                     |   10 +++++--
 kernel/rcutiny.c                         |   13 ++++++++++
 kernel/rcutree.c                         |   14 +++++++++++
 kernel/time/tick-sched.c                 |   36 ++++++++++++++++++++++++++---
 26 files changed, 120 insertions(+), 47 deletions(-)

-- 
1.7.5.4

