Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751353Ab2KPCVl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 21:21:41 -0500
Received: from mail-vc0-f174.google.com ([209.85.220.174]:61094 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751024Ab2KPCVk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 21:21:40 -0500
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Anish Kumar <anish198519851985@gmail.com>
Subject: [PATCH 0/9] printk: Make it usable on nohz cpus v6
Date: Fri, 16 Nov 2012 03:21:22 +0100
Message-Id: <1353032491-16462-1-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Previous patches haven't changed. This pile just adds two patches from
Steven Rostedt to ensure all pending irq works are executed before we
offline a CPU.

The branch can be found at:

git://git.kernel.org/pub/scm/linux/kernel/git/frederic/linux-dynticks.git
	nohz/printk-v6

Thanks.

Frederic Weisbecker (7):
  irq_work: Fix racy IRQ_WORK_BUSY flag setting
  irq_work: Fix racy check on work pending flag
  irq_work: Remove CONFIG_HAVE_IRQ_WORK
  nohz: Add API to check tick state
  irq_work: Don't stop the tick with pending works
  irq_work: Make self-IPIs optable
  printk: Wake up klogd using irq_work

Steven Rostedt (2):
  irq_work: Flush work on CPU_DYING
  irq_work: Warn if there's still work on cpu_down

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
 include/linux/irq_work.h            |   20 ++++++
 include/linux/printk.h              |    3 -
 include/linux/tick.h                |   17 ++++-
 init/Kconfig                        |    5 +-
 kernel/irq_work.c                   |  129 ++++++++++++++++++++++++++--------
 kernel/printk.c                     |   36 ++++++----
 kernel/time/tick-sched.c            |    7 +-
 kernel/timer.c                      |    1 -
 22 files changed, 159 insertions(+), 73 deletions(-)

-- 
1.7.5.4

