Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932164Ab2IJTnZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 15:43:25 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:58064 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932107Ab2IJTnX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 15:43:23 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Tony Luck <tony.luck@intel.com>,
        Fenghua Yu <fenghua.yu@intel.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH 0/6] cputime: More cleanups
Date: Mon, 10 Sep 2012 21:43:07 +0200
Message-Id: <1347306193-21080-1-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

More cleanups for the cputime code.

Tested on x86 and built-tested only on ia64, powerpc and s390.

This is pullable from:

git://github.com/fweisbec/linux-dynticks.git
	cputime/cleanups (based on tip:sched/core)
	

Frederic Weisbecker (6):
  cputime: Use a proper subsystem naming for vtime related APIs
  vtime: Consolidate system/idle context detection
  ia64: Consolidate user vtime accounting
  ia64: Reuse system and user vtime accounting functions on task switch
  cputime: Gather time/stats accounting config options into a single
    menu
  cputime: Make finegrained irqtime accounting generally available

 arch/Kconfig                    |    6 ++
 arch/ia64/kernel/time.c         |   64 +++++++++---------
 arch/powerpc/kernel/time.c      |   53 ++++++++------
 arch/s390/include/asm/cputime.h |    3 +
 arch/s390/kernel/vtime.c        |    6 +-
 arch/x86/Kconfig                |   12 +---
 include/linux/hardirq.h         |    8 +-
 include/linux/kernel_stat.h     |    6 +-
 include/linux/kvm_host.h        |    4 +-
 init/Kconfig                    |  146 ++++++++++++++++++++++++---------------
 kernel/sched/core.c             |    2 +-
 kernel/sched/cputime.c          |   34 ++++++++-
 kernel/softirq.c                |    6 +-
 13 files changed, 209 insertions(+), 141 deletions(-)

-- 
1.7.5.4

