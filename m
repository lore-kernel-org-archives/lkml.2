Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752772Ab1GWOGJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jul 2011 10:06:09 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:42733 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751902Ab1GWOGC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jul 2011 10:06:02 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, uclinux-dist-devel@blackfin.uclinux.org
Subject: Pull request blackfin.git (for-linus branch)
Date: Sat, 23 Jul 2011 10:05:44 -0400
Message-Id: <1311429944-6463-1-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.7.6
In-Reply-To: <1311398997-24417-1-git-send-email-vapier@gentoo.org>
References: <1311398997-24417-1-git-send-email-vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 8e204874db000928e37199c2db82b7eb8966cc3c:

  Merge branch 'x86-vdso-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip (2011-07-22 17:05:15 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/vapier/blackfin.git for-linus

Mathias Krause (1):
      Blackfin: exec: remove redundant set_fs(USER_DS)

Mike Frysinger (39):
      Blackfin: convert to kbuild asm-generic support
      Blackfin: net2272: move pin setup to boards files
      Blackfin: boards: clean up redundant/dead spi resources
      Blackfin: SMP: optimize start up code a bit
      Blackfin: time: replace magic numbers with defines
      Blackfin: optimize double fault boot checking
      Blackfin: convert to asm-generic/mutex-dec.h for all systems
      Blackfin: debug-mmrs: fix typo in single dmac setup
      Blackfin: debug-mmrs: disable PERIPHERAL_MAP for IMDMA channels
      Blackfin: bf561-ezkit: change parallel flash from M to Y in defconfig
      Blackfin: update anomaly lists to latest public info
      Blackfin: gptimers: add group structure for hardware register layout
      Blackfin: debug-mmrs: prevent macro arg from expanding
      Blackfin: debug-mmrs: use new gptimer_group layout to simplify code
      Blackfin: gptimers: use register structs from common header
      Blackfin: gptimers: use bfin read/write helpers
      Blackfin: gptimers: add enable/disable by timer id
      Blackfin: pwm: implement linux/pwm.h API
      Blackfin: convert unicode space gremlins
      Blackfin: gpio: punt unused GPIO_# defines
      Blackfin: bf54x: constify pint register array
      Blackfin: bf54x: tweak MMR pint names
      Blackfin: bf54x: switch to common pint MMR struct
      Blackfin: debug-mmrs: generalize pint logic
      Blackfin: dpmc: bind to MMR names and not CPUs
      Blackfin: gpio/ints: generalize pint logic
      Blackfin: dpmc: optimize SIC_IWR programming a little
      Blackfin: dpmc: omit RETE/RETN when hibernating
      Blackfin: dpmc: relocate hibernate helper macros
      Blackfin: dpmc: do not save/restore EVT0/EVT1/EVT4 when hibernating
      Blackfin: dpmc: optimize hibernate/resume path
      Blackfin: bf538: pull gpio/port logic out of core hibernate paths
      Blackfin: dpmc: don't save/restore scratch registers
      Blackfin: dpmc: optimize SDRAM programming slightly
      Blackfin: bf54x: fix GPIO resume code
      Blackfin: bf51x: fix alternative portmux options
      Blackfin: bf526: restrict reboot workaround to 0.0 silicon
      Blackfin: SMP: punt unused atomic_test_mask helper
      Blackfin: spi-docs: further clarify GPIO CS behavior with various modes

Scott Jiang (1):
      Blackfin: boards: fix pcm device name

Steven Miao (1):
      Blackfin: make sure percpu section is aligned in XIP builds

Steven Rostedt (1):
      Blackfin: irqs: do not trace arch_local_{*,irq_*} functions

 Documentation/blackfin/bfin-spi-notes.txt       |    2 +
 arch/blackfin/Kconfig                           |   10 +
 arch/blackfin/configs/BF561-EZKIT_defconfig     |    8 +-
 arch/blackfin/include/asm/Kbuild                |   43 +
 arch/blackfin/include/asm/atomic.h              |   13 +-
 arch/blackfin/include/asm/auxvec.h              |    1 -
 arch/blackfin/include/asm/bitsperlong.h         |    1 -
 arch/blackfin/include/asm/blackfin.h            |    6 +-
 arch/blackfin/include/asm/bugs.h                |    1 -
 arch/blackfin/include/asm/cputime.h             |    1 -
 arch/blackfin/include/asm/current.h             |    1 -
 arch/blackfin/include/asm/device.h              |    1 -
 arch/blackfin/include/asm/div64.h               |    1 -
 arch/blackfin/include/asm/dpmc.h                |   27 -
 arch/blackfin/include/asm/emergency-restart.h   |    1 -
 arch/blackfin/include/asm/errno.h               |    1 -
 arch/blackfin/include/asm/fb.h                  |    1 -
 arch/blackfin/include/asm/futex.h               |    1 -
 arch/blackfin/include/asm/gpio.h                |   64 +--
 arch/blackfin/include/asm/gptimers.h            |   19 +
 arch/blackfin/include/asm/hw_irq.h              |    1 -
 arch/blackfin/include/asm/ioctl.h               |    1 -
 arch/blackfin/include/asm/ipcbuf.h              |    1 -
 arch/blackfin/include/asm/irq_regs.h            |    1 -
 arch/blackfin/include/asm/irqflags.h            |   42 +-
 arch/blackfin/include/asm/kdebug.h              |    1 -
 arch/blackfin/include/asm/kmap_types.h          |    1 -
 arch/blackfin/include/asm/local.h               |    1 -
 arch/blackfin/include/asm/local64.h             |    1 -
 arch/blackfin/include/asm/mman.h                |    1 -
 arch/blackfin/include/asm/module.h              |    8 +-
 arch/blackfin/include/asm/msgbuf.h              |    1 -
 arch/blackfin/include/asm/mutex.h               |   77 +--
 arch/blackfin/include/asm/page.h                |    8 +-
 arch/blackfin/include/asm/param.h               |    1 -
 arch/blackfin/include/asm/pda.h                 |   10 +
 arch/blackfin/include/asm/percpu.h              |    1 -
 arch/blackfin/include/asm/pgalloc.h             |    1 -
 arch/blackfin/include/asm/resource.h            |    1 -
 arch/blackfin/include/asm/scatterlist.h         |    6 -
 arch/blackfin/include/asm/sections.h            |    8 +-
 arch/blackfin/include/asm/sembuf.h              |    1 -
 arch/blackfin/include/asm/serial.h              |    1 -
 arch/blackfin/include/asm/setup.h               |    1 -
 arch/blackfin/include/asm/shmbuf.h              |    1 -
 arch/blackfin/include/asm/shmparam.h            |    1 -
 arch/blackfin/include/asm/sigcontext.h          |    8 +-
 arch/blackfin/include/asm/socket.h              |    1 -
 arch/blackfin/include/asm/sockios.h             |    1 -
 arch/blackfin/include/asm/spinlock.h            |    8 +-
 arch/blackfin/include/asm/statfs.h              |    1 -
 arch/blackfin/include/asm/termbits.h            |    1 -
 arch/blackfin/include/asm/termios.h             |    1 -
 arch/blackfin/include/asm/topology.h            |    1 -
 arch/blackfin/include/asm/types.h               |    1 -
 arch/blackfin/include/asm/ucontext.h            |    1 -
 arch/blackfin/include/asm/unaligned.h           |    1 -
 arch/blackfin/include/asm/user.h                |    1 -
 arch/blackfin/include/asm/xor.h                 |    1 -
 arch/blackfin/kernel/Makefile                   |    1 +
 arch/blackfin/kernel/asm-offsets.c              |   10 +
 arch/blackfin/kernel/bfin_gpio.c                |   26 +-
 arch/blackfin/kernel/debug-mmrs.c               |  109 ++-
 arch/blackfin/kernel/gptimers.c                 |   93 +--
 arch/blackfin/kernel/process.c                  |    1 -
 arch/blackfin/kernel/pwm.c                      |  100 +++
 arch/blackfin/kernel/reboot.c                   |    4 +-
 arch/blackfin/kernel/setup.c                    |   16 +-
 arch/blackfin/kernel/time.c                     |    4 +-
 arch/blackfin/kernel/vmlinux.lds.S              |    1 +
 arch/blackfin/mach-bf518/Kconfig                |   78 ++-
 arch/blackfin/mach-bf518/boards/ezbrd.c         |   59 --
 arch/blackfin/mach-bf518/boards/tcm-bf518.c     |   47 -
 arch/blackfin/mach-bf518/include/mach/anomaly.h |   24 +-
 arch/blackfin/mach-bf518/include/mach/portmux.h |   54 +-
 arch/blackfin/mach-bf527/boards/ad7160eval.c    |   19 -
 arch/blackfin/mach-bf527/boards/cm_bf527.c      |   55 --
 arch/blackfin/mach-bf527/boards/ezbrd.c         |   62 --
 arch/blackfin/mach-bf527/boards/ezkit.c         |   98 +--
 arch/blackfin/mach-bf527/boards/tll6527m.c      |   70 --
 arch/blackfin/mach-bf527/include/mach/anomaly.h |   34 +-
 arch/blackfin/mach-bf533/boards/H8606.c         |   28 -
 arch/blackfin/mach-bf533/boards/blackstamp.c    |   10 -
 arch/blackfin/mach-bf533/boards/cm_bf533.c      |   29 -
 arch/blackfin/mach-bf533/boards/ezkit.c         |   36 -
 arch/blackfin/mach-bf533/boards/ip0x.c          |    1 -
 arch/blackfin/mach-bf533/boards/stamp.c         |   78 +-
 arch/blackfin/mach-bf533/include/mach/anomaly.h |   19 +-
 arch/blackfin/mach-bf537/boards/cm_bf537e.c     |   51 +-
 arch/blackfin/mach-bf537/boards/cm_bf537u.c     |   63 +-
 arch/blackfin/mach-bf537/boards/dnp5370.c       |    2 -
 arch/blackfin/mach-bf537/boards/minotaur.c      |    2 -
 arch/blackfin/mach-bf537/boards/pnav10.c        |   38 -
 arch/blackfin/mach-bf537/boards/stamp.c         |  176 ++---
 arch/blackfin/mach-bf537/boards/tcm_bf537.c     |   51 +-
 arch/blackfin/mach-bf537/include/mach/anomaly.h |   34 +-
 arch/blackfin/mach-bf538/boards/ezkit.c         |   25 -
 arch/blackfin/mach-bf538/ext-gpio.c             |   37 +-
 arch/blackfin/mach-bf538/include/mach/anomaly.h |   38 +-
 arch/blackfin/mach-bf538/include/mach/gpio.h    |    3 +
 arch/blackfin/mach-bf548/boards/cm_bf548.c      |   15 -
 arch/blackfin/mach-bf548/boards/ezkit.c         |   32 -
 arch/blackfin/mach-bf548/include/mach/anomaly.h |  220 +++---
 arch/blackfin/mach-bf548/include/mach/gpio.h    |    2 +
 arch/blackfin/mach-bf548/include/mach/irq.h     |    2 +-
 arch/blackfin/mach-bf561/boards/acvilon.c       |    9 -
 arch/blackfin/mach-bf561/boards/cm_bf561.c      |   58 +-
 arch/blackfin/mach-bf561/boards/ezkit.c         |   41 +-
 arch/blackfin/mach-bf561/include/mach/anomaly.h |  132 ++--
 arch/blackfin/mach-bf561/include/mach/gpio.h    |    6 +-
 arch/blackfin/mach-bf561/secondary.S            |  152 ++---
 arch/blackfin/mach-common/dpmc_modes.S          | 1016 +++++++++++++----------
 arch/blackfin/mach-common/head.S                |   36 +-
 arch/blackfin/mach-common/ints-priority.c       |   41 +-
 arch/blackfin/mach-common/smp.c                 |   17 +-
 115 files changed, 1735 insertions(+), 2138 deletions(-)
 delete mode 100644 arch/blackfin/include/asm/auxvec.h
 delete mode 100644 arch/blackfin/include/asm/bitsperlong.h
 delete mode 100644 arch/blackfin/include/asm/bugs.h
 delete mode 100644 arch/blackfin/include/asm/cputime.h
 delete mode 100644 arch/blackfin/include/asm/current.h
 delete mode 100644 arch/blackfin/include/asm/device.h
 delete mode 100644 arch/blackfin/include/asm/div64.h
 delete mode 100644 arch/blackfin/include/asm/emergency-restart.h
 delete mode 100644 arch/blackfin/include/asm/errno.h
 delete mode 100644 arch/blackfin/include/asm/fb.h
 delete mode 100644 arch/blackfin/include/asm/futex.h
 delete mode 100644 arch/blackfin/include/asm/hw_irq.h
 delete mode 100644 arch/blackfin/include/asm/ioctl.h
 delete mode 100644 arch/blackfin/include/asm/ipcbuf.h
 delete mode 100644 arch/blackfin/include/asm/irq_regs.h
 delete mode 100644 arch/blackfin/include/asm/kdebug.h
 delete mode 100644 arch/blackfin/include/asm/kmap_types.h
 delete mode 100644 arch/blackfin/include/asm/local.h
 delete mode 100644 arch/blackfin/include/asm/local64.h
 delete mode 100644 arch/blackfin/include/asm/mman.h
 delete mode 100644 arch/blackfin/include/asm/msgbuf.h
 delete mode 100644 arch/blackfin/include/asm/param.h
 delete mode 100644 arch/blackfin/include/asm/percpu.h
 delete mode 100644 arch/blackfin/include/asm/pgalloc.h
 delete mode 100644 arch/blackfin/include/asm/resource.h
 delete mode 100644 arch/blackfin/include/asm/scatterlist.h
 delete mode 100644 arch/blackfin/include/asm/sembuf.h
 delete mode 100644 arch/blackfin/include/asm/serial.h
 delete mode 100644 arch/blackfin/include/asm/setup.h
 delete mode 100644 arch/blackfin/include/asm/shmbuf.h
 delete mode 100644 arch/blackfin/include/asm/shmparam.h
 delete mode 100644 arch/blackfin/include/asm/socket.h
 delete mode 100644 arch/blackfin/include/asm/sockios.h
 delete mode 100644 arch/blackfin/include/asm/statfs.h
 delete mode 100644 arch/blackfin/include/asm/termbits.h
 delete mode 100644 arch/blackfin/include/asm/termios.h
 delete mode 100644 arch/blackfin/include/asm/topology.h
 delete mode 100644 arch/blackfin/include/asm/types.h
 delete mode 100644 arch/blackfin/include/asm/ucontext.h
 delete mode 100644 arch/blackfin/include/asm/unaligned.h
 delete mode 100644 arch/blackfin/include/asm/user.h
 delete mode 100644 arch/blackfin/include/asm/xor.h
 create mode 100644 arch/blackfin/kernel/pwm.c
