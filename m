Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758083Ab2HQOim (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2012 10:38:42 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:62603 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758008Ab2HQOiG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2012 10:38:06 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghua.yu@intel.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH 0/4] cputime: Virtual cputime accounting small cleanups and consolidation v3
Date: Fri, 17 Aug 2012 16:37:54 +0200
Message-Id: <1345214278-6245-1-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

In this v3:

- Rebase against latest tip:sched/core
- Added acks from Martin
- Refined help text for the consolidated CONFIG_VIRT_CPU_ACCOUNTING option
in the 1st patch.

You can pull from:

git://github.com/fweisbec/linux-dynticks.git
	virt-cputime-v3

Thanks.

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
 kernel/sched/core.c                    |  558 +-------------------------------
 kernel/sched/cputime.c                 |  503 ++++++++++++++++++++++++++++
 kernel/sched/sched.h                   |   63 ++++
 17 files changed, 606 insertions(+), 610 deletions(-)
 create mode 100644 kernel/sched/cputime.c

-- 
1.7.5.4

