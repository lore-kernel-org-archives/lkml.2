Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756023Ab1CRSLH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Mar 2011 14:11:07 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:38829 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753937Ab1CRSK7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Mar 2011 14:10:59 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: linux-kernel@vger.kernel.org
Cc: uclinux-dist-devel@blackfin.uclinux.org
Subject: [PATCH 00/32] Blackfin updates for 2.6.39-rc0
Date: Fri, 18 Mar 2011 14:11:17 -0400
Message-Id: <1300471877-3544-1-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Other than the normal random fixes, we've got a bunch of SMP updates,
IRQ cleanups, and ipipe updates.  Boring stuff.

Aaron Wu (1):
  Blackfin: bf548-ezkit: add CAN1 support

Andreas Schallenberg (1):
  Blackfin: dnp5370: drop MMC card detect support

Graf Yang (1):
  Blackfin: SMP: implement cpu_freq support

Michael Hennerich (1):
  Blackfin: cpufreq: fix typos

Mike Frysinger (9):
  Blackfin: add bfin_write_{or,and} helpers
  Blackfin: ADI boards: enable pseudo debug insns support
  Blackfin: SMP: use standard cache functions
  Blackfin: split optimization settings more
  Blackfin: optimize startup code
  Blackfin: SMP: convert to irq chip functions
  Blackfin: wire up new syscalls
  Blackfin: punt unused HDMA masks
  Blackfin: ip0x: fix unused variable warning

Philippe Gerum (3):
  Blackfin/ipipe: upgrade to I-pipe mainline
  Blackfin/ipipe: fix deferred pipeline sync for the root stage
  Blackfin/ipipe: restore pipeline bits in irqflags

Sonic Zhang (4):
  Blackfin: SMP: avoid section mismatch warnings
  Blackfin: kgdb: drop dead KGDB_THR_PROC_SWAP for SMP systems
  Blackfin: SMP: disable preempt with smp_processor_id to send messages
  Blackfin: SMP: work around anomaly 05000491

Thomas Gleixner (9):
  Blackfin: use proper wrappers for irq_desc
  Blackfin: convert core irq_chip to new functions
  Blackfin: convert internal irq_chip to new functions
  Blackfin: convert error irq_chip to new functions
  Blackfin: convert mac irq_chip to new functions
  Blackfin: convert gpio irq_chip to new functions
  Blackfin: use proper wrapper functions for modifying irq status
  Blackfin: use accessor functions in show_interrupts()
  Blackfin: enable GENERIC_HARDIRQS_NO_DEPRECATED

steven miao (3):
  Blackfin: bf54x: add kconfig for UART2/3 DMA channel assignments
  Blackfin: SMP: PERCPU section should be PAGE aligned
  Blackfin: SMP: delay enabling caches until CPU is initialized

 arch/blackfin/Kconfig                            |   42 +++-
 arch/blackfin/configs/BF518F-EZBRD_defconfig     |    1 +
 arch/blackfin/configs/BF526-EZBRD_defconfig      |    1 +
 arch/blackfin/configs/BF527-EZKIT-V2_defconfig   |    1 +
 arch/blackfin/configs/BF527-EZKIT_defconfig      |    1 +
 arch/blackfin/configs/BF533-EZKIT_defconfig      |    1 +
 arch/blackfin/configs/BF533-STAMP_defconfig      |    1 +
 arch/blackfin/configs/BF537-STAMP_defconfig      |    1 +
 arch/blackfin/configs/BF538-EZKIT_defconfig      |    1 +
 arch/blackfin/configs/BF548-EZKIT_defconfig      |    1 +
 arch/blackfin/configs/BF561-EZKIT-SMP_defconfig  |    1 +
 arch/blackfin/configs/BF561-EZKIT_defconfig      |    1 +
 arch/blackfin/include/asm/def_LPBlackfin.h       |   16 ++-
 arch/blackfin/include/asm/dpmc.h                 |    3 +
 arch/blackfin/include/asm/ipipe.h                |   95 +++------
 arch/blackfin/include/asm/ipipe_base.h           |   11 +-
 arch/blackfin/include/asm/irqflags.h             |   87 +++++++-
 arch/blackfin/include/asm/smp.h                  |    9 +-
 arch/blackfin/include/asm/unistd.h               |    5 +-
 arch/blackfin/kernel/bfin_dma_5xx.c              |   32 ++--
 arch/blackfin/kernel/ipipe.c                     |   84 ++++----
 arch/blackfin/kernel/irqchip.c                   |   10 +-
 arch/blackfin/kernel/kgdb.c                      |    4 -
 arch/blackfin/kernel/setup.c                     |   37 ++++
 arch/blackfin/kernel/vmlinux.lds.S               |    3 +-
 arch/blackfin/mach-bf518/include/mach/defBF512.h |   19 --
 arch/blackfin/mach-bf527/include/mach/defBF522.h |   19 --
 arch/blackfin/mach-bf533/boards/ip0x.c           |    2 -
 arch/blackfin/mach-bf537/boards/cm_bf537e.c      |    2 +-
 arch/blackfin/mach-bf537/boards/cm_bf537u.c      |    2 +-
 arch/blackfin/mach-bf537/boards/dnp5370.c        |   20 --
 arch/blackfin/mach-bf537/boards/tcm_bf537.c      |    2 +-
 arch/blackfin/mach-bf537/include/mach/defBF534.h |   18 --
 arch/blackfin/mach-bf548/Kconfig                 |   59 ++++++
 arch/blackfin/mach-bf548/boards/ezkit.c          |   55 +++++-
 arch/blackfin/mach-bf548/include/mach/defBF544.h |   18 --
 arch/blackfin/mach-bf548/include/mach/defBF547.h |   19 --
 arch/blackfin/mach-bf548/include/mach/dma.h      |   28 +++-
 arch/blackfin/mach-bf548/include/mach/irq.h      |    4 -
 arch/blackfin/mach-bf561/boards/cm_bf561.c       |    2 +-
 arch/blackfin/mach-bf561/hotplug.c               |   21 +-
 arch/blackfin/mach-bf561/secondary.S             |   35 ++--
 arch/blackfin/mach-bf561/smp.c                   |   15 +-
 arch/blackfin/mach-common/arch_checks.c          |    2 +-
 arch/blackfin/mach-common/cache.S                |   38 +++-
 arch/blackfin/mach-common/cpufreq.c              |    8 +-
 arch/blackfin/mach-common/dpmc.c                 |   50 +++++-
 arch/blackfin/mach-common/entry.S                |   14 ++
 arch/blackfin/mach-common/head.S                 |  110 ++++-------
 arch/blackfin/mach-common/interrupt.S            |    6 +-
 arch/blackfin/mach-common/ints-priority.c        |  236 +++++++++++++---------
 arch/blackfin/mach-common/smp.c                  |   28 ++-
 52 files changed, 762 insertions(+), 519 deletions(-)

-- 
1.7.4.1

