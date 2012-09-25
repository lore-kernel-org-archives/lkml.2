Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756678Ab2IYPG2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 11:06:28 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:56768 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756343Ab2IYPG0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 11:06:26 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghua.yu@intel.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: [GIT PULL] cputime: More cleanups v2
Date: Tue, 25 Sep 2012 17:06:01 +0200
Message-Id: <1348585567-2925-1-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo, Thomas,

Seconds take for these cleanups (and more are to come). I haven't got
reviews in two weeks so I'm resending with a pull request.

Changes in v2:

* Fix wrong condition when using is_idle_task() (patch 2/6)
* Remove unnecessary !S390 dependency for finegrained irqtime accounting
option (reported by Russell King)

Please pull from:

git://github.com/fweisbec/linux-dynticks.git
	cputime/cleanups-v2

It is based on tip:sched/core

Thanks.

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

