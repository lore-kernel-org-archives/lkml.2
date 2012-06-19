Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752618Ab2FSNnW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2012 09:43:22 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:40043 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752260Ab2FSNnV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2012 09:43:21 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghua.yu@intel.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH 0/4] cputime: Virtual cputime accounting small cleanups and consolidation
Date: Tue, 19 Jun 2012 15:43:07 +0200
Message-Id: <1340113391-1896-1-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Not sure to which tree this should go. The scheduler one may be.
Anyway if you're fine with it, it is pullable at:

git://github.com/fweisbec/linux-dynticks.git
	virt-cputime

This is only built tested on the relevant archs.

I wish we could do more vtime cputime accounting consolidation
but archs do the things pretty differently although I bet the
behaviour could be more unified.


Frederic Weisbecker (4):
  cputime: Generalize CONFIG_VIRT_CPU_ACCOUNTING
  sched: Move cputime code to its own file
  cputime: Consolidate vtime handling on context switch
  s390: Remove leftover account_tick_vtime() header

 arch/Kconfig                           |    3 +
 arch/ia64/Kconfig                      |   12 +-
 arch/ia64/include/asm/switch_to.h      |    8 -
 arch/ia64/kernel/time.c                |    4 +-
 arch/powerpc/include/asm/time.h        |    6 -
 arch/powerpc/kernel/process.c          |    3 -
 arch/powerpc/kernel/time.c             |    6 +
 arch/powerpc/platforms/Kconfig.cputype |   16 +-
 arch/s390/Kconfig                      |    5 +-
 arch/s390/include/asm/switch_to.h      |    4 -
 arch/s390/kernel/vtime.c               |    4 +-
 include/linux/kernel_stat.h            |    6 +
 init/Kconfig                           |   13 +
 kernel/sched/Makefile                  |    2 +-
 kernel/sched/core.c                    |  552 +-------------------------------
 kernel/sched/cputime.c                 |  497 ++++++++++++++++++++++++++++
 kernel/sched/sched.h                   |   63 ++++
 17 files changed, 600 insertions(+), 604 deletions(-)
 create mode 100644 kernel/sched/cputime.c

-- 
1.7.5.4

