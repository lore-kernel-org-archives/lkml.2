Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755701Ab1FFDLI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jun 2011 23:11:08 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:62855 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755057Ab1FFDLE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jun 2011 23:11:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=lgkh4XEMiVtPZY7V+6YkPYAOAE2MjLdLxlI6sMp+/nGSC01lCADsGY41jOn6VfAjrh
         IEuJSaNifVmIsfccPyzuQgxWzkHIk5U0P5ALqcEn+SvYIUfWTy7YSFJeO3Rllqj7Crvu
         EU8KJ7feoxcurVLOIkv6R90MTV17f2gqvuyzw=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>
Subject: [PATCH 0/4] rcu: Detect rcu uses under extended quiescent state, and fix some
Date: Mon,  6 Jun 2011 05:10:53 +0200
Message-Id: <1307329858-14999-1-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I found two examples with the last two patches but I suspect there are more bugs
waiting to be detected under other configs and/or archs.

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
 include/linux/lockdep.h                  |    8 ++++++-
 include/linux/rcupdate.h                 |   20 ++++++++++++-----
 include/linux/tick.h                     |   10 ++++++--
 kernel/lockdep.c                         |   12 ++++++++--
 kernel/pid.c                             |    2 +-
 kernel/rcutree.c                         |   14 ++++++++++++
 kernel/time/tick-sched.c                 |   34 ++++++++++++++++++++++++++++-
 28 files changed, 129 insertions(+), 56 deletions(-)

-- 
1.7.5.2

