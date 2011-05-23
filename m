Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751947Ab1EWExC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 00:53:02 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:44978 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750857Ab1EWExA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 00:53:00 -0400
Date: Mon, 23 May 2011 00:52:24 -0400 (EDT)
Message-Id: <20110523.005224.414763201716030727.davem@davemloft.net>
To: torvalds@linux-foundation.org
CC: akpm@linux-foundation.org, sparclinux@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT] Sparc
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Sun, 22 May 2011 21:52:29 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Sparc32 enters the modern age thanks to Sam Ravnborg and
Daniel Hellstrom.

Sparc32 now supports genirq, and it now properly generates
IPIs.

Plus some LEON updates from Daniel Hellstrom as well.

Please pull, thanks a lot!

The following changes since commit 71a8638480eb8fb6cfabe2ee9ca3fbc6e3453a14:

  Merge branch 'viafb-next' of git://github.com/schandinat/linux-2.6 (2011-05-22 12:39:58 -0700)

are available in the git repository at:

  master.kernel.org:/pub/scm/linux/kernel/git/davem/sparc-next-2.6.git master

Daniel Hellstrom (17):
      sparc32, leon: must protect IRQ controller register with spinlock
      sparc32,leon: add support for extended interrupt controller
      sparc32,leon: per-cpu ticker use genirq per-cpu handler
      sparc32,leon: cleaned away code from the LEON2 days
      sparc32, leon: code cleanup of timer/IRQ controller initialization
      sparc32,leon: implement genirq CPU affinity
      sparc32: removed unused code, implemented by generic code
      sparc32: always define boot_cpu_id
      sparc32,leon: operate on boot-cpu IRQ controller registers
      sparc32,leon: don't rely on bootloader to mask IRQs
      sparc32,leon: added some SMP comments
      sparc32,leon: SMP power down implementation
      sparc32: implement SMP IPIs using the generic functions
      sparc32,leon: Implemented SMP IPIs for LEON CPU
      sparc32, sun4m: Implemented SMP IPIs support for SUN4M machines
      sparc32, sun4d: Implemented SMP IPIs support for SUN4D machines
      SCHED_TTWU_QUEUE is not longer needed since sparc32 now implements IPI

David S. Miller (2):
      Merge branch 'master' of master.kernel.org:/.../davem/sparc-2.6
      Merge commit '317f394160e9beb97d19a84c39b7e5eb3d7815a8'

Jan Andersson (1):
      sparc: add {read,write}*_be routines

KOSAKI Motohiro (1):
      sparc: convert old cpumask API into new one

Kristoffer Glembo (1):
      sparc32,leon: Remove unnecessary page_address calls in LEON DMA API.

Sam Ravnborg (8):
      sparc32,sun4d: rename sbus_tid to board_to_cpu in irq support
      sparc32: cleanup code for pci init
      sparc32: genirq support
      sparc: consolidate show_cpuinfo in cpu.c
      sparc32: probe for cpu info only during startup
      sparc32: always register a PROM based early console
      sparc32: avoid build warning at mm/percpu.c:1647
      sparc32: fix build, fix missing cpu_relax declaration

 arch/alpha/kernel/smp.c              |    3 +-
 arch/arm/kernel/smp.c                |    5 +-
 arch/blackfin/mach-common/smp.c      |    3 +
 arch/cris/arch-v32/kernel/smp.c      |   13 +-
 arch/ia64/kernel/irq_ia64.c          |    2 +
 arch/ia64/xen/irq_xen.c              |   10 +-
 arch/m32r/kernel/smp.c               |    4 +-
 arch/mips/cavium-octeon/smp.c        |    2 +
 arch/mips/kernel/smtc.c              |    2 +-
 arch/mips/mti-malta/malta-int.c      |    2 +
 arch/mips/pmc-sierra/yosemite/smp.c  |    4 +
 arch/mips/sgi-ip27/ip27-irq.c        |    2 +
 arch/mips/sibyte/bcm1480/smp.c       |    7 +-
 arch/mips/sibyte/sb1250/smp.c        |    7 +-
 arch/mn10300/kernel/smp.c            |    5 +-
 arch/parisc/kernel/smp.c             |    5 +-
 arch/powerpc/kernel/smp.c            |    4 +-
 arch/s390/kernel/smp.c               |    6 +-
 arch/sh/kernel/smp.c                 |    2 +
 arch/sparc/Kconfig                   |    7 +-
 arch/sparc/include/asm/cpudata_32.h  |    5 +
 arch/sparc/include/asm/floppy_32.h   |   40 ++-
 arch/sparc/include/asm/io.h          |   13 +
 arch/sparc/include/asm/irq_32.h      |    6 +-
 arch/sparc/include/asm/leon.h        |   41 +--
 arch/sparc/include/asm/pcic.h        |   12 +-
 arch/sparc/include/asm/pgtable_32.h  |    6 +-
 arch/sparc/include/asm/pgtable_64.h  |    3 +
 arch/sparc/include/asm/setup.h       |   12 +
 arch/sparc/include/asm/smp_32.h      |   37 +-
 arch/sparc/include/asm/smp_64.h      |    4 +
 arch/sparc/include/asm/spinlock_32.h |    1 +
 arch/sparc/include/asm/system_32.h   |    5 -
 arch/sparc/include/asm/system_64.h   |    4 -
 arch/sparc/include/asm/winmacro.h    |    9 +
 arch/sparc/kernel/Makefile           |    4 -
 arch/sparc/kernel/cpu.c              |  139 +++++++-
 arch/sparc/kernel/cpumap.c           |    4 +-
 arch/sparc/kernel/devices.c          |    4 +-
 arch/sparc/kernel/ds.c               |   14 +-
 arch/sparc/kernel/entry.S            |   41 ++-
 arch/sparc/kernel/head_32.S          |   51 ++--
 arch/sparc/kernel/ioport.c           |   42 +--
 arch/sparc/kernel/irq.h              |   51 ++--
 arch/sparc/kernel/irq_32.c           |  513 +++++++---------------------
 arch/sparc/kernel/irq_64.c           |    6 +-
 arch/sparc/kernel/kernel.h           |    5 +-
 arch/sparc/kernel/leon_kernel.c      |  365 +++++++++++++-------
 arch/sparc/kernel/leon_smp.c         |  148 +++++++--
 arch/sparc/kernel/mdesc.c            |    2 +-
 arch/sparc/kernel/of_device_64.c     |    3 +-
 arch/sparc/kernel/pci_msi.c          |    3 +-
 arch/sparc/kernel/pcic.c             |   83 +++--
 arch/sparc/kernel/perf_event.c       |    1 +
 arch/sparc/kernel/process_32.c       |   12 +-
 arch/sparc/kernel/prom_32.c          |    1 -
 arch/sparc/kernel/setup_32.c         |   87 +----
 arch/sparc/kernel/setup_64.c         |   78 -----
 arch/sparc/kernel/smp_32.c           |  105 ++++--
 arch/sparc/kernel/smp_64.c           |   59 ++--
 arch/sparc/kernel/sun4c_irq.c        |  150 +++++----
 arch/sparc/kernel/sun4d_irq.c        |  494 ++++++++++-----------------
 arch/sparc/kernel/sun4d_smp.c        |   93 +++++-
 arch/sparc/kernel/sun4m_irq.c        |  179 ++++++-----
 arch/sparc/kernel/sun4m_smp.c        |   51 ++-
 arch/sparc/kernel/sysfs.c            |    3 +-
 arch/sparc/kernel/time_32.c          |   10 +-
 arch/sparc/kernel/us2e_cpufreq.c     |    4 +-
 arch/sparc/kernel/us3_cpufreq.c      |    4 +-
 arch/sparc/lib/Makefile              |    1 -
 arch/sparc/lib/rwsem_32.S            |  204 -----------
 arch/sparc/mm/init_64.c              |   14 +-
 arch/tile/kernel/smp.c               |    6 +-
 arch/um/kernel/smp.c                 |    2 +-
 arch/x86/kernel/smp.c                |    5 +-
 arch/x86/xen/smp.c                   |    5 +-
 include/linux/mutex.h                |    2 +-
 include/linux/sched.h                |   24 +-
 kernel/mutex-debug.c                 |    2 +-
 kernel/mutex-debug.h                 |    2 +-
 kernel/mutex.c                       |    2 +-
 kernel/mutex.h                       |    2 +-
 kernel/sched.c                       |  627 +++++++++++++++++++---------------
 kernel/sched_debug.c                 |    2 +-
 kernel/sched_fair.c                  |   28 ++-
 kernel/sched_features.h              |    6 +
 kernel/sched_idletask.c              |    2 +-
 kernel/sched_rt.c                    |   54 ++--
 kernel/sched_stoptask.c              |    5 +-
 89 files changed, 2046 insertions(+), 2051 deletions(-)
 delete mode 100644 arch/sparc/lib/rwsem_32.S
