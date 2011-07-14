Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754748Ab1GNPEH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jul 2011 11:04:07 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:38328 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754355Ab1GNPEF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jul 2011 11:04:05 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Will Deacon <will.deacon@arm.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Prasad <prasad@linux.vnet.ibm.com>, Paul Mundt <lethal@linux-sh.org>,
        Jason Wessel <jason.wessel@windriver.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: [GIT PULL] hw_breakpoints updates
Date: Thu, 14 Jul 2011 17:03:51 +0200
Message-Id: <1310655837-328-1-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo,

Please pull the perf/breakpoint-v2 branch that can be found at:

git://git.kernel.org/pub/scm/linux/kernel/git/frederic/random-tracing.git
	perf/breakpoint-v2

This makes the breakpoints config optable and thus let users
be able to build x86 and sh without perf.

In that takes: more acks added and rebase against latest perf/core
and upstream changes.

Thanks,
	Frederic
---

Frederic Weisbecker (6):
      hw_breakpoints: Split hardware breakpoints config
      hw_breakpoints: Migrate breakpoint conditional build under new config
      x86: Allow the user not to build hw_breakpoints
      hw_breakpoints: Breakpoints arch ability don't need perf events
      hw_breakpoints: Only force perf events if breakpoints are selected
      hw_breakpoints: Drop remaining misplaced dependency on perf


 arch/Kconfig                             |    1 -
 arch/arm/Kconfig                         |    2 +-
 arch/arm/include/asm/hw_breakpoint.h     |    4 +-
 arch/arm/include/asm/processor.h         |    2 +-
 arch/arm/kernel/Makefile                 |    2 +-
 arch/arm/kernel/entry-header.S           |    2 +-
 arch/arm/kernel/ptrace.c                 |    4 +-
 arch/powerpc/Kconfig                     |    2 +-
 arch/powerpc/include/asm/cputable.h      |    4 +-
 arch/powerpc/include/asm/hw_breakpoint.h |    6 ++--
 arch/powerpc/include/asm/processor.h     |    4 +-
 arch/powerpc/kernel/Makefile             |    2 +-
 arch/powerpc/kernel/process.c            |   18 ++++++++--------
 arch/powerpc/kernel/ptrace.c             |   13 ++++++-----
 arch/powerpc/lib/Makefile                |    2 +-
 arch/sh/Kconfig                          |    2 +-
 arch/sh/kernel/Makefile                  |    2 +-
 arch/sh/kernel/cpu/sh4a/Makefile         |    2 +-
 arch/x86/Kconfig                         |    3 +-
 arch/x86/include/asm/debugreg.h          |   33 ++++++++++++++++++++++++++++-
 arch/x86/kernel/Makefile                 |    3 +-
 arch/x86/kernel/process.c                |    1 +
 arch/x86/kernel/ptrace.c                 |   17 +++++++++++++++
 include/linux/hw_breakpoint.h            |    6 ++--
 include/linux/perf_event.h               |    4 +-
 include/linux/ptrace.h                   |    6 ++--
 include/linux/sched.h                    |    2 +-
 init/Kconfig                             |   11 ++++++++++
 kernel/events/Makefile                   |    2 +-
 kernel/events/core.c                     |    4 +-
 kernel/ptrace.c                          |    4 +-
 samples/Kconfig                          |    2 +-
 32 files changed, 115 insertions(+), 57 deletions(-)
