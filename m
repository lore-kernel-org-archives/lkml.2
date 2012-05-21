Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759464Ab2EUW3k (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 18:29:40 -0400
Received: from www.linutronix.de ([62.245.132.108]:33870 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751061Ab2EUW3j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 18:29:39 -0400
Date: Tue, 22 May 2012 00:29:35 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>
Subject: [GIT pull] smp hotplug cleanups for 3.5
Message-ID: <alpine.LFD.2.02.1205220020200.3231@ionos>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

please pull the latest smp-hotplug-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git smp-hotplug-for-linus

This series is merily a cleanup of code copied around in arch/* and
not changing any of the real cpu hotplug horrors yet. I wish I'd had
something more substantial for 3.5, but I underestimated the lurking
horror....

Changelog and diffstat below, but full patch omitted due to size
reasons.

Thanks,

	tglx

------------------>
Suresh Siddha (1):
      smp, idle: Allocate idle thread for each possible cpu during boot

Thomas Gleixner (78):
      m32r: Remove pointless function prototypes
      smp: Add task_struct argument to __cpu_up()
      smp: Add generic smpboot facility
      smp: Provide generic idle thread allocation
      x86: Add task_struct argument to smp_ops.cpu_up
      x86: Use generic idle thread allocation
      powerpc: Use generic idle thread allocation
      ia64: Use generic idle thread allocation
      arm: Use generic idle thread allocation
      mips: Use generic idle thread allocation
      hexagon: Use generic idle thread allocation
      s390: Use generic idle thread allocation
      cris: Use generic idle thread allocation
      blackfin: Use generic idle thread allocation
      sh: Use generic idle thread allocation
      alpha: Use generic idle thread allocation
      sparc: Use generic idle thread allocation
      parisc: Use generic idle thread allocation
      smp: Fix idle_thread_init() inline stub
      frv: Use correct size for task_struct allocation
      frv: Use core allocator for task_struct
      init_task: Create generic init_task instance
      alpha: Use generic init_task
      arm: Use generic init_task
      avr32: Use generic init_task
      blackfin: Use generic init_task
      c6x: Use generic init_task
      cris: Use generic init_task
      frv: Use generic init_task
      h8300-use-generic-init_task
      hexagon: Use generic idle_task
      m32r: Use generic init_task
      m68k: Use generic init_task
      microblaze: Use generic init_task
      mips: Use generic init_task
      mn10300: Use generic init_task
      openrisc: Use generic init_task
      parisc: Use generic init_task
      powerpc: Use generic init_task
      s390: Use generic init_task
      score: Use generic init_task
      sh: Use generic init_task
      sparc: Use generic init_task
      tile: Use generic init_task
      unicore32: Use generic init_task
      um: Use generic init_task
      x86: Use generic init_task
      xtensa: Use generic init_task
      init_task: Replace CONFIG_HAVE_GENERIC_INIT_TASK
      parisc: Fix init_task fallout
      mips: Use PAGE_SIZE for INIT_TASK_DATA alignment again
      powerpc: Fix broken cpu_idle_wait() implementation
      smp: Implement kick_all_cpus_sync()
      cpuidle: Use kick_all_cpus_sync()
      x86: Use kick_all_cpus_sync()
      arm: Remove unused cpu_idle_wait()
      ia64: Remove unused cpu_idle_wait()
      powerpc: Remove unused cpu_idle_wait()
      sh: Remove cpu_idle_wait()
      fork: Remove the weak insanity
      fork: Move thread info gfp flags to header
      fork: Provide weak arch_release_[task_struct|thread_info] functions
      tile: Use common threadinfo allocator
      fork: Provide kmemcache based thread_info allocator
      c6x: Use common threadinfo allocator
      x86: Use common threadinfo allocator
      cris: Use common threadinfo allocator
      frv: Use common threadinfo allocator
      m32r: Use common threadinfo allocator
      hexagon: Use common threadinfo allocator
      mips: Use common threadinfo allocator
      powerpc: Use common threadinfo allocator
      mn10300: Use common threadinfo allocator
      sh-use-common-threadinfo-allocator
      score: Use common threadinfo allocator
      sparc: Use common threadinfo allocator
      task_allocator: Use config switches instead of magic defines
      um: Remove leftover declaration of alloc_task_struct_node()


 arch/Kconfig                            |   15 ++++++
 arch/alpha/Kconfig                      |    1 +
 arch/alpha/kernel/Makefile              |    2 +-
 arch/alpha/kernel/smp.c                 |   20 +------
 arch/arm/Kconfig                        |    4 +-
 arch/arm/Makefile                       |    2 +-
 arch/arm/include/asm/cpu.h              |    1 -
 arch/arm/include/asm/processor.h        |    2 -
 arch/arm/kernel/Makefile                |    2 +-
 arch/arm/kernel/init_task.c             |   37 --------------
 arch/arm/kernel/process.c               |   20 -------
 arch/arm/kernel/smp.c                   |   26 +---------
 arch/avr32/kernel/Makefile              |    2 +-
 arch/avr32/kernel/init_task.c           |   31 -----------
 arch/blackfin/Kconfig                   |    1 +
 arch/blackfin/Makefile                  |    2 -
 arch/blackfin/kernel/Makefile           |    2 +-
 arch/blackfin/kernel/init_task.c        |   32 ------------
 arch/blackfin/mach-common/smp.c         |   19 +-------
 arch/c6x/include/asm/thread_info.h      |   17 +------
 arch/c6x/kernel/process.c               |   16 ------
 arch/cris/Kconfig                       |    1 +
 arch/cris/arch-v32/kernel/smp.c         |   14 +----
 arch/cris/include/asm/processor.h       |    5 +-
 arch/cris/include/asm/thread_info.h     |    6 --
 arch/cris/kernel/process.c              |   28 ----------
 arch/frv/Makefile                       |    2 +-
 arch/frv/include/asm/thread_info.h      |   15 ------
 arch/frv/kernel/Makefile                |    2 +-
 arch/frv/kernel/init_task.c             |   32 ------------
 arch/frv/kernel/process.c               |   15 ------
 arch/h8300/kernel/Makefile              |    2 +-
 arch/h8300/kernel/init_task.c           |   36 -------------
 arch/hexagon/Kconfig                    |    1 +
 arch/hexagon/Makefile                   |    3 +-
 arch/hexagon/include/asm/thread_info.h  |    8 ---
 arch/hexagon/kernel/Makefile            |    2 +-
 arch/hexagon/kernel/init_task.c         |   54 --------------------
 arch/hexagon/kernel/process.c           |   37 --------------
 arch/hexagon/kernel/smp.c               |   11 +---
 arch/ia64/Kconfig                       |    4 ++
 arch/ia64/include/asm/processor.h       |    1 -
 arch/ia64/include/asm/thread_info.h     |    3 -
 arch/ia64/kernel/process.c              |   20 -------
 arch/ia64/kernel/smpboot.c              |   63 ++----------------------
 arch/m32r/Makefile                      |    2 +-
 arch/m32r/include/asm/thread_info.h     |   17 +------
 arch/m32r/kernel/Makefile               |    2 +-
 arch/m32r/kernel/init_task.c            |   34 -------------
 arch/m32r/kernel/smpboot.c              |    6 +--
 arch/m68k/kernel/Makefile               |    2 +-
 arch/m68k/kernel/init_task.c            |   35 -------------
 arch/microblaze/kernel/Makefile         |    2 +-
 arch/microblaze/kernel/init_task.c      |   26 ----------
 arch/mips/Kconfig                       |    1 +
 arch/mips/Makefile                      |    2 +-
 arch/mips/include/asm/thread_info.h     |   12 -----
 arch/mips/kernel/Makefile               |    2 +-
 arch/mips/kernel/init_task.c            |   35 -------------
 arch/mips/kernel/smp.c                  |   56 +--------------------
 arch/mn10300/Makefile                   |    2 +-
 arch/mn10300/include/asm/thread_info.h  |   17 +-----
 arch/mn10300/kernel/Makefile            |    2 +-
 arch/mn10300/kernel/init_task.c         |   39 --------------
 arch/mn10300/kernel/kgdb.c              |    3 +-
 arch/mn10300/kernel/smp.c               |    2 +-
 arch/openrisc/Makefile                  |    2 +-
 arch/openrisc/kernel/Makefile           |    2 +-
 arch/openrisc/kernel/init_task.c        |   42 ----------------
 arch/parisc/Kconfig                     |    1 +
 arch/parisc/Makefile                    |    2 +-
 arch/parisc/kernel/Makefile             |    2 +-
 arch/parisc/kernel/init_task.c          |   70 --------------------------
 arch/parisc/kernel/smp.c                |   25 +--------
 arch/parisc/mm/init.c                   |   12 +++++
 arch/powerpc/Kconfig                    |    5 +--
 arch/powerpc/include/asm/processor.h    |    1 -
 arch/powerpc/include/asm/thread_info.h  |   13 -----
 arch/powerpc/kernel/Makefile            |    2 +-
 arch/powerpc/kernel/idle.c              |   23 ---------
 arch/powerpc/kernel/init_task.c         |   29 -----------
 arch/powerpc/kernel/process.c           |   31 -----------
 arch/powerpc/kernel/smp.c               |   76 ++--------------------------
 arch/s390/Kconfig                       |    1 +
 arch/s390/Makefile                      |    1 -
 arch/s390/include/asm/smp.h             |    2 +-
 arch/s390/kernel/Makefile               |    2 +-
 arch/s390/kernel/init_task.c            |   38 --------------
 arch/s390/kernel/smp.c                  |   35 +------------
 arch/score/include/asm/thread_info.h    |   10 +---
 arch/score/kernel/Makefile              |    2 +-
 arch/score/kernel/init_task.c           |   46 -----------------
 arch/sh/Kconfig                         |    4 +-
 arch/sh/Makefile                        |    2 +-
 arch/sh/include/asm/processor.h         |    5 --
 arch/sh/include/asm/thread_info.h       |   11 +----
 arch/sh/kernel/Makefile                 |    2 +-
 arch/sh/kernel/idle.c                   |   20 -------
 arch/sh/kernel/init_task.c              |   30 -----------
 arch/sh/kernel/process.c                |   46 +----------------
 arch/sh/kernel/smp.c                    |   14 +-----
 arch/sparc/Kconfig                      |    2 +
 arch/sparc/Makefile                     |    1 -
 arch/sparc/include/asm/leon.h           |    5 +-
 arch/sparc/include/asm/thread_info_32.h |    2 -
 arch/sparc/include/asm/thread_info_64.h |   25 +---------
 arch/sparc/kernel/Makefile              |    1 -
 arch/sparc/kernel/init_task.c           |   22 --------
 arch/sparc/kernel/leon_smp.c            |    9 +---
 arch/sparc/kernel/smp_32.c              |   12 ++--
 arch/sparc/kernel/smp_64.c              |   12 ++---
 arch/sparc/kernel/sun4d_smp.c           |    8 +--
 arch/sparc/kernel/sun4m_smp.c           |    7 +--
 arch/tile/include/asm/thread_info.h     |    6 +--
 arch/tile/kernel/Makefile               |    2 +-
 arch/tile/kernel/init_task.c            |   59 ----------------------
 arch/tile/kernel/process.c              |   23 +--------
 arch/tile/kernel/setup.c                |   16 ++++++
 arch/tile/kernel/smpboot.c              |    2 +-
 arch/um/include/asm/processor-generic.h |    2 -
 arch/um/kernel/Makefile                 |    2 +-
 arch/um/kernel/init_task.c              |   38 --------------
 arch/um/kernel/smp.c                    |    2 +-
 arch/um/kernel/um_arch.c                |    5 ++
 arch/unicore32/Makefile                 |    1 -
 arch/unicore32/kernel/Makefile          |    2 +-
 arch/unicore32/kernel/init_task.c       |   44 ----------------
 arch/x86/Kconfig                        |    4 +-
 arch/x86/Makefile                       |    1 -
 arch/x86/include/asm/boot.h             |    2 +-
 arch/x86/include/asm/page_32_types.h    |    4 +-
 arch/x86/include/asm/page_64_types.h    |    4 +-
 arch/x86/include/asm/processor.h        |    2 -
 arch/x86/include/asm/smp.h              |   11 +++--
 arch/x86/include/asm/thread_info.h      |   21 +-------
 arch/x86/kernel/Makefile                |    2 +-
 arch/x86/kernel/apm_32.c                |    2 +-
 arch/x86/kernel/init_task.c             |   42 ----------------
 arch/x86/kernel/irq_32.c                |    8 ++--
 arch/x86/kernel/process.c               |   34 ++++---------
 arch/x86/kernel/smpboot.c               |   83 ++++--------------------------
 arch/x86/xen/smp.c                      |   19 ++------
 arch/xtensa/kernel/Makefile             |    2 +-
 arch/xtensa/kernel/init_task.c          |   31 -----------
 drivers/cpuidle/cpuidle.c               |   13 +-----
 include/linux/smp.h                     |    6 ++-
 include/linux/thread_info.h             |    6 ++
 init/Makefile                           |    4 ++
 {arch/alpha/kernel => init}/init_task.c |   17 +++++--
 kernel/Makefile                         |    1 +
 kernel/cpu.c                            |   13 +++++-
 kernel/fork.c                           |   69 ++++++++++++++++++-------
 kernel/sched/Makefile                   |    2 -
 kernel/sched/core.c                     |    2 +
 kernel/smp.c                            |   27 ++++++++++
 kernel/smpboot.c                        |   62 +++++++++++++++++++++++
 kernel/smpboot.h                        |   18 +++++++
 157 files changed, 415 insertions(+), 1934 deletions(-)
 delete mode 100644 arch/arm/kernel/init_task.c
 delete mode 100644 arch/avr32/kernel/init_task.c
 delete mode 100644 arch/blackfin/kernel/init_task.c
 delete mode 100644 arch/frv/kernel/init_task.c
 delete mode 100644 arch/h8300/kernel/init_task.c
 delete mode 100644 arch/hexagon/kernel/init_task.c
 delete mode 100644 arch/m32r/kernel/init_task.c
 delete mode 100644 arch/m68k/kernel/init_task.c
 delete mode 100644 arch/microblaze/kernel/init_task.c
 delete mode 100644 arch/mips/kernel/init_task.c
 delete mode 100644 arch/mn10300/kernel/init_task.c
 delete mode 100644 arch/openrisc/kernel/init_task.c
 delete mode 100644 arch/parisc/kernel/init_task.c
 delete mode 100644 arch/powerpc/kernel/init_task.c
 delete mode 100644 arch/s390/kernel/init_task.c
 delete mode 100644 arch/score/kernel/init_task.c
 delete mode 100644 arch/sh/kernel/init_task.c
 delete mode 100644 arch/sparc/kernel/init_task.c
 delete mode 100644 arch/tile/kernel/init_task.c
 delete mode 100644 arch/um/kernel/init_task.c
 delete mode 100644 arch/unicore32/kernel/init_task.c
 delete mode 100644 arch/x86/kernel/init_task.c
 delete mode 100644 arch/xtensa/kernel/init_task.c
 rename {arch/alpha/kernel => init}/init_task.c (73%)
 create mode 100644 kernel/smpboot.c
 create mode 100644 kernel/smpboot.h
