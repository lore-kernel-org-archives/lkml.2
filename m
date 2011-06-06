Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755897Ab1FFDLL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jun 2011 23:11:11 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:32919 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755191Ab1FFDLG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jun 2011 23:11:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=eJYBKznHUslxv89eAwcgxT0xhVNqGiGU3DMcaRngvnU74cw9QGWGSkbF5GZ32G3ddc
         0R3doWtnJ+9uCiIPGrZiXWIxwfo5g9mshNNOdMnC/Q3eUedxPO9symPOkQ5vIb6tI1MT
         FJIBztauYE6fYWFGpZ8ro0k5Jo1Fd8N3IdH4k=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>
Subject: [PATCH 0/4] rcu: Detect rcu uses under extended quiescent state, and fix some
Date: Mon,  6 Jun 2011 05:10:54 +0200
Message-Id: <1307329858-14999-2-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1307329858-14999-1-git-send-email-fweisbec@gmail.com>
References: <1307329858-14999-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I found two examples with the last two patches but I suspect there are more bugs
waiting to be detected under other configs or archs.

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

