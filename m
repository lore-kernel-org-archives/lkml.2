Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933690Ab1EXVwf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 17:52:35 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:53763 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932559Ab1EXVwe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 17:52:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=s07csw2McnkpIZtOBayFdzeaiQNOLuMiMqF6CMV/RMZOiPLqp+RuBgsjqqTqb48bN7
         G/HcokeFgshEwDk5s5IB8m1qe2QWXmBs9anoTBbjmSe5q9IP1WlYu3JudDiaAi7lxwgk
         p0ELg6mGVz2yOOQ990Js8xKhXdAfuGwww0oUE=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Will Deacon <will.deacon@arm.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Prasad <prasad@linux.vnet.ibm.com>, Paul Mundt <lethal@linux-sh.org>,
        Jason Wessel <jason.wessel@windriver.com>,
        "H . Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH v2] hw_breakpoint: Let the user choose not to build it (and perf too)
Date: Tue, 24 May 2011 23:52:21 +0200
Message-Id: <1306273947-8410-1-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mostly just a rebase against latest upstream
updates and acks from Will Deacon added In this second version.

Please tell me if you are ok with this set.

Thanks.

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
