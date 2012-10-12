Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760012Ab2JLSJo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2012 14:09:44 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:37825 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753896Ab2JLSJn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2012 14:09:43 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: [RFC PATCH 0/5] printk: Make it usable on nohz CPUs
Date: Fri, 12 Oct 2012 20:09:31 +0200
Message-Id: <1350065376-23353-1-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

So here is a proposition on what we can do to make printk
correctly working on a tickless CPU.

Although it's targeted to be part of the adaptive tickmess
implemetation, it's pretty standalone and generic and also
works for printk() calls in idle.

It is based on latest linus tree.

Waiting for your comments.

Thanks.

PS: only built-tested for now.

Frederic Weisbecker (5):
  irq_work: Move irq_work_raise() declaration/default definition to
    arch headers
  irq_work: Only run irq_work from tick if arch needs it
  x86: Implement arch_irq_work_use_tick
  nohz: Add API to check tick state
  printk: Wake up klogd with irq_work on nohz CPU

 arch/alpha/include/asm/irq_work.h    |    9 +++++++
 arch/alpha/kernel/time.c             |    2 +-
 arch/arm/include/asm/irq_work.h      |    1 +
 arch/arm64/include/asm/irq_work.h    |    1 +
 arch/blackfin/include/asm/irq_work.h |    1 +
 arch/frv/include/asm/irq_work.h      |    1 +
 arch/hexagon/include/asm/irq_work.h  |    1 +
 arch/mips/include/asm/irq_work.h     |    1 +
 arch/parisc/include/asm/irq_work.h   |    1 +
 arch/powerpc/include/asm/irq_work.h  |    8 ++++++
 arch/powerpc/kernel/time.c           |    2 +-
 arch/s390/include/asm/irq_work.h     |    1 +
 arch/sh/include/asm/irq_work.h       |    1 +
 arch/sparc/include/asm/irq_work.h    |    8 ++++++
 arch/sparc/kernel/pcr.c              |    2 +-
 arch/x86/include/asm/irq_work.h      |   15 ++++++++++++
 arch/x86/kernel/irq_work.c           |    6 ++--
 include/asm-generic/irq_work.h       |   22 +++++++++++++++++
 include/linux/irq_work.h             |    1 +
 include/linux/tick.h                 |   16 ++++++++++++-
 kernel/irq_work.c                    |    7 -----
 kernel/printk.c                      |   42 ++++++++++++++++++++++++++++++++++
 kernel/time/tick-sched.c             |    2 +-
 kernel/timer.c                       |    2 +-
 24 files changed, 137 insertions(+), 16 deletions(-)
 create mode 100644 arch/alpha/include/asm/irq_work.h
 create mode 100644 arch/arm/include/asm/irq_work.h
 create mode 100644 arch/arm64/include/asm/irq_work.h
 create mode 100644 arch/blackfin/include/asm/irq_work.h
 create mode 100644 arch/frv/include/asm/irq_work.h
 create mode 100644 arch/hexagon/include/asm/irq_work.h
 create mode 100644 arch/mips/include/asm/irq_work.h
 create mode 100644 arch/parisc/include/asm/irq_work.h
 create mode 100644 arch/powerpc/include/asm/irq_work.h
 create mode 100644 arch/s390/include/asm/irq_work.h
 create mode 100644 arch/sh/include/asm/irq_work.h
 create mode 100644 arch/sparc/include/asm/irq_work.h
 create mode 100644 arch/x86/include/asm/irq_work.h
 create mode 100644 include/asm-generic/irq_work.h

-- 
1.7.5.4

