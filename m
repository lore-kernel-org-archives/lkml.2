Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755442Ab2KNUhy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 15:37:54 -0500
Received: from mail-vb0-f46.google.com ([209.85.212.46]:33046 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753480Ab2KNUhx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 15:37:53 -0500
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Anish Kumar <anish198519851985@gmail.com>
Subject: [GIT PULL] printk: Make it usable on nohz cpus
Date: Wed, 14 Nov 2012 21:37:30 +0100
Message-Id: <1352925457-15700-1-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo,

Please pull the printk support in dynticks mode patches that can
be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/frederic/linux-dynticks.git tags/printk-dynticks-for-mingo

This branch is based on top of v3.7-rc4
Head is 2fb933986dcef2db1344712162a1feb8d5736ff8:

  printk: Wake up klogd using irq_work (2012-11-14 17:45:37 +0100)

Since last version, very few things have changed:

* Added acks from Steve on patches 1/7 and 2/7
* Fixed an arch_needs_cpu() redefinition due to misordered headers (reported
by Wu Fengguang).

If you get further acks from Peterz or anybody, feel free to cherry pick
the patches instead. Or I can rebase my patches to add them, either way.

Thanks.

----------------------------------------------------------------
Support for printk in dynticks mode:

* Fix two races in irq work claiming

* Generalize irq_work support to all archs

* Don't stop tick with irq works pending. This
fix is generally useful and concerns archs that
can't raise self IPIs.

* Introduce "lazy" irq works that can wait for the
next tick to be executed, unless it's stopped.

* Implement klogd wake up using irq work. This
removes the ad-hoc printk_tick()/printk_needs_cpu()
hooks and make it working even in dynticks mode.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>

----------------------------------------------------------------
Frederic Weisbecker (7):
      irq_work: Fix racy IRQ_WORK_BUSY flag setting
      irq_work: Fix racy check on work pending flag
      irq_work: Remove CONFIG_HAVE_IRQ_WORK
      nohz: Add API to check tick state
      irq_work: Don't stop the tick with pending works
      irq_work: Make self-IPIs optable
      printk: Wake up klogd using irq_work

 arch/alpha/Kconfig                  |    1 -
 arch/arm/Kconfig                    |    1 -
 arch/arm64/Kconfig                  |    1 -
 arch/blackfin/Kconfig               |    1 -
 arch/frv/Kconfig                    |    1 -
 arch/hexagon/Kconfig                |    1 -
 arch/mips/Kconfig                   |    1 -
 arch/parisc/Kconfig                 |    1 -
 arch/powerpc/Kconfig                |    1 -
 arch/s390/Kconfig                   |    1 -
 arch/sh/Kconfig                     |    1 -
 arch/sparc/Kconfig                  |    1 -
 arch/x86/Kconfig                    |    1 -
 drivers/staging/iio/trigger/Kconfig |    1 -
 include/linux/irq_work.h            |   20 +++++++++
 include/linux/printk.h              |    3 --
 include/linux/tick.h                |   17 +++++++-
 init/Kconfig                        |    5 +--
 kernel/irq_work.c                   |   76 +++++++++++++++++++++++------------
 kernel/printk.c                     |   36 +++++++++--------
 kernel/time/tick-sched.c            |    7 ++--
 kernel/timer.c                      |    1 -
 22 files changed, 112 insertions(+), 67 deletions(-)
