Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932977Ab0HEBrQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 21:47:16 -0400
Received: from gate.crashing.org ([63.228.1.57]:42522 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759277Ab0HEBrM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 21:47:12 -0400
Subject: [git pull] Please pull powerpc.git next branch
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linuxppc-dev list <linuxppc-dev@ozlabs.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 05 Aug 2010 11:46:57 +1000
Message-ID: <1280972817.1902.159.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus !

Here's the batch of powerpc stuff for this merge window. Not major highlight,
some work on 64-bit Book3E (embedded) by myself, and the powerpc part of the
HW breakpoint stuff by Mohan Kumar and Paulus, and the usual batch of embedded
bits and pieces.

This does -not- include my memblock rework, which is in a separate branch
that I'm still sorting out due to clashes with ARM and some typos breaking
sh and microblaze. I'm not sure whether I'll send that this merge window
or just stick it into -next as soon as it's over. Peter Anvin also has some
interesting ideas to rewrite the memblock core into something more suitable
for handling allocations and take over the world :-)

Cheers,
Ben.

The following changes since commit 3a09b1be53d23df780a0cd0e4087a05e2ca4a00c:
  Linus Torvalds (1):
        Merge git://git.kernel.org/.../steve/gfs2-2.6-nmw

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/benh/powerpc.git next

Adrian Alonso (1):
      of/xilinxfb: update tft compatible versions

Albrecht Dreß (2):
      powerpc/5200: improve uart baud rate calculation (reach high baud rates, better accuracy)
      powerpc/5200/i2c: improve i2c bus error recovery

Anatolij Gustschin (8):
      powerpc/512x: Group mpc512x board's selection menu
      powerpc/5121: add initial support for PDM360NG board
      powerpc/512x: add clock structure for Video-IN (VIU) unit
      powerpc/5121: fsl-diu-fb: fix issue with re-enabling DIU area descriptor
      powerpc/5121: move fsl-diu-fb.h to include/linux
      powerpc/5121: shared DIU framebuffer support
      powerpc/5121: doc/dts-bindings: update doc of FSL DIU bindings
      powerpc/fsl-diu-fb: Support setting display mode using EDID

Anton Blanchard (2):
      powerpc: Optimise per cpu accesses on 64bit
      powerpc/numa: Use form 1 affinity to setup node distance

Anton Vorontsov (4):
      powerpc: Fix GENERIC_ISA_DMA dependency
      powerpc/85xx: Fix SWIOTLB initalization for MPC85xxMDS boards
      powerpc/85xx: Fix booting for P1021MDS boards
      powerpc/85xx: Cleanup QE initialization for MPC85xxMDS boards

Becky Bruce (1):
      powerpc/fsl-booke: Fix comments in mmu code that mention BATS

Benjamin Herrenschmidt (17):
      Merge commit 'paulus-perf/master' into next
      powerpc/book3e: mtmsr should not be mtmsrd on book3e 64-bit
      powerpc/book3e: Hack to get gdb moving along on Book3E 64-bit
      powerpc/book3e: Move doorbell_exception from traps.c to dbell.c
      powerpc/book3e: More doorbell cleanups. Sample the PIR register
      powerpc/book3e: Don't re-trigger decrementer on lazy irq restore
      powerpc/book3e: Hookup doorbells exceptions on 64-bit Book3E
      powerpc/book3e: Add generic 64-bit idle powersave support
      powerpc/book3e: Fix single step when using HW page tables
      powerpc/book3e: Add TLB dump in xmon for Book3E
      powerpc/book3e: Adjust the page sizes list based on MMU config
      powerpc/oprofile: Don't build server oprofile drivers on 64-bit BookE
      Merge commit 'jwb/next' into next
      powerpc/pseries: Increase cpu die timeout
      powerpc/powermac: Add PowerMac10,2 machine descriptor
      Merge commit 'gcl/next' into next
      Merge commit 'kumar/next' into next

Bradley Hughes (2):
      powerpc/85xx: Change deprecated binding for 85xx-based boards
      powerpc/85xx: Adding DTS for the STx GP3-SSA MPC8555 board

Brian King (3):
      powerpc/pseries: Migration code reorganization / hibernation prep
      powerpc/pseries: Partition hibernation support
      powerpc: Remove redundant xics badness warning

Chris Metcalf (1):
      hvc_console: use "*_console" nomenclature to avoid modpost warning.

Christian Dietrich (1):
      Remove REDWOOD_[456] config options and conditional code

Christoph Egger (1):
      powerpc: Removing dead CONFIG_SMP_750

David Gibson (1):
      powerpc/book3e: Use set_irq_regs() in the msgsnd/msgrcv IPI path

Denis Kirjanov (1):
      powerpc/iseries: Fix constant warning

Dmitry Eremin-Solenikov (2):
      powerpc/tqm85xx: update PCI interrupt-map attribute
      powerpc/tqm85xx: add a quirk for ti1520 PCMCIA bridge

Heiko Schocher (1):
      powerpc/8xx: Add support for the MPC8xx based boards from TQC

Ilya Yanok (2):
      powerpc/fsl_pci: add quirk for mpc8308 pcie bridge
      powerpc/mpc8308rdb: support for MPC8308RDB board from Freescale

Joe Perches (1):
      powerpc: Remove unnecessary casts of private_data

Julia Lawall (2):
      powerpc/iseries: Use kstrdup
      powerpc/pseries: Use kstrdup

K.Prasad (5):
      hw_breakpoints: Allow arch-specific cleanup before breakpoint unregistration
      powerpc, hw_breakpoints: Implement hw_breakpoints for 64-bit server processors
      powerpc, hw_breakpoint: Handle concurrent alignment interrupts
      powerpc, hw_breakpoint: Enable hw-breakpoints while handling intervening signals
      powerpc, hw_breakpoint: Discard extraneous interrupt due to accesses outside symbol length

Kulikov Vasiliy (1):
      powerpc/pseries/eeh: Use for_each_pci_dev()

Lee Nipper (1):
      powerpc/40x: Distinguish AMCC PowerPC 405EX and 405EXr correctly

Mark Nelson (2):
      powerpc/pseries: Rename RAS_VECTOR_OFFSET to RTAS_VECTOR_EXTERNAL_INTERRUPT and move to rtas.h
      powerpc/pseries: Add WARN_ON() to request_event_sources_irqs() on irq allocation/request failure

Martyn Welch (1):
      powerpc: Add i8042 keyboard and mouse irq parsing

Matt Evans (3):
      powerpc/kexec: Switch to a static PACA on the way out
      powerpc/kexec: Add to and tidy debug/comments in machine_kexec64.c
      powerpc/kexec: Fix orphaned offline CPUs across kexec

Matthew McClintock (3):
      powerpc/mpic: Add ability to reset a core via MPIC
      powerpc/crashdump: Fix issues with kexec and 36bit physical addr
      powerpc/85xx: kexec for SMP 85xx BookE systems

Michael Ellerman (1):
      powerpc/book3e: Resend doorbell exceptions to ourself

Michael Neuling (1):
      powerpc: Print decimal values in prom_init.c

Neil Horman (1):
      powerpc: Add vmcoreinfo symbols to allow makdumpfile to filter core files properly

Paul E. McKenney (1):
      powerpc: Remove all rcu head initializations

Paul Mackerras (6):
      powerpc: Emulate most Book I instructions in emulate_step()
      powerpc, hw_breakpoint: Fix off-by-one in checking access address
      powerpc, hw_breakpoint: Cooperate better with other single-steppers
      powerpc, hw_breakpoint: Tell generic code we have no instruction breakpoints
      powerpc: Rework VDSO gettimeofday to prevent time going backwards
      powerpc: Clean up obsolete code relating to decrementer and timebase

Robert Jennings (1):
      powerpc: ONLINE to OFFLINE CPU state transition during removal

Stefan Roese (1):
      powerpc/44x: Fix UART2/3 interrupt assignment in PPC460EX/GT dts files

Tiejun Chen (1):
      powerpc/smp: remove the incorrect decrementer initial codes for AP

Timur Tabi (1):
      powerpc/85xx: Introduce support for the Freescale P1022DS reference board

 Documentation/powerpc/dts-bindings/fsl/diu.txt |   20 +-
 Documentation/powerpc/dts-bindings/fsl/i2c.txt |    2 +
 arch/powerpc/Kconfig                           |   15 +-
 arch/powerpc/boot/dts/canyonlands.dts          |    4 +-
 arch/powerpc/boot/dts/glacier.dts              |    4 +-
 arch/powerpc/boot/dts/mpc8308rdb.dts           |  303 +++++
 arch/powerpc/boot/dts/mpc8540ads.dts           |    4 +-
 arch/powerpc/boot/dts/mpc8541cds.dts           |    4 +-
 arch/powerpc/boot/dts/mpc8544ds.dts            |    4 +-
 arch/powerpc/boot/dts/mpc8548cds.dts           |    4 +-
 arch/powerpc/boot/dts/mpc8555cds.dts           |    4 +-
 arch/powerpc/boot/dts/mpc8560ads.dts           |    4 +-
 arch/powerpc/boot/dts/mpc8568mds.dts           |    4 +-
 arch/powerpc/boot/dts/p1021mds.dts             |    1 +
 arch/powerpc/boot/dts/p1022ds.dts              |  633 ++++++++++
 arch/powerpc/boot/dts/pdm360ng.dts             |  410 +++++++
 arch/powerpc/boot/dts/stxssa8555.dts           |  380 ++++++
 arch/powerpc/boot/dts/tqm8540.dts              |    9 +-
 arch/powerpc/boot/dts/tqm8541.dts              |    9 +-
 arch/powerpc/boot/dts/tqm8548-bigflash.dts     |    9 +-
 arch/powerpc/boot/dts/tqm8548.dts              |    9 +-
 arch/powerpc/boot/dts/tqm8555.dts              |    9 +-
 arch/powerpc/boot/dts/tqm8560.dts              |    9 +-
 arch/powerpc/boot/dts/tqm8xx.dts               |  172 +++
 arch/powerpc/configs/mpc85xx_defconfig         |   34 +-
 arch/powerpc/configs/mpc85xx_smp_defconfig     |   34 +-
 arch/powerpc/configs/tqm8xx_defconfig          |  934 +++++++++++++++
 arch/powerpc/include/asm/abs_addr.h            |    2 +-
 arch/powerpc/include/asm/asm-compat.h          |    2 +
 arch/powerpc/include/asm/cputable.h            |    4 +
 arch/powerpc/include/asm/dbell.h               |    8 +-
 arch/powerpc/include/asm/hvcall.h              |    1 +
 arch/powerpc/include/asm/hw_breakpoint.h       |   74 ++
 arch/powerpc/include/asm/machdep.h             |    5 +-
 arch/powerpc/include/asm/mmu-book3e.h          |    4 +
 arch/powerpc/include/asm/mpc5121.h             |   32 +
 arch/powerpc/include/asm/paca.h                |    2 +-
 arch/powerpc/include/asm/percpu.h              |    3 -
 arch/powerpc/include/asm/ppc-opcode.h          |    7 +
 arch/powerpc/include/asm/processor.h           |    8 +
 arch/powerpc/include/asm/reg.h                 |    2 +-
 arch/powerpc/include/asm/reg_booke.h           |    5 +-
 arch/powerpc/include/asm/rtas.h                |   13 +
 arch/powerpc/include/asm/time.h                |    7 -
 arch/powerpc/include/asm/topology.h            |    3 +
 arch/powerpc/include/asm/vdso_datapage.h       |    2 +
 arch/powerpc/kernel/Makefile                   |    4 +-
 arch/powerpc/kernel/asm-offsets.c              |    2 +-
 arch/powerpc/kernel/cputable.c                 |  118 ++-
 arch/powerpc/kernel/crash_dump.c               |    4 +-
 arch/powerpc/kernel/dbell.c                    |   78 ++-
 arch/powerpc/kernel/exceptions-64e.S           |   50 +-
 arch/powerpc/kernel/exceptions-64s.S           |    1 +
 arch/powerpc/kernel/hw_breakpoint.c            |  364 ++++++
 arch/powerpc/kernel/idle_book3e.S              |   86 ++
 arch/powerpc/kernel/irq.c                      |   16 +
 arch/powerpc/kernel/machine_kexec.c            |   22 +-
 arch/powerpc/kernel/machine_kexec_64.c         |   78 ++-
 arch/powerpc/kernel/paca.c                     |   10 +
 arch/powerpc/kernel/process.c                  |   36 +
 arch/powerpc/kernel/prom_init.c                |   44 +-
 arch/powerpc/kernel/ptrace.c                   |   64 +
 arch/powerpc/kernel/rtas.c                     |  105 ++-
 arch/powerpc/kernel/setup-common.c             |   13 +
 arch/powerpc/kernel/setup_64.c                 |   19 +-
 arch/powerpc/kernel/signal.c                   |    3 +
 arch/powerpc/kernel/smp.c                      |   10 -
 arch/powerpc/kernel/time.c                     |  197 +---
 arch/powerpc/kernel/traps.c                    |   29 +-
 arch/powerpc/kernel/vdso32/gettimeofday.S      |  184 +---
 arch/powerpc/kernel/vdso64/gettimeofday.S      |   88 +--
 arch/powerpc/kvm/timing.c                      |    2 +-
 arch/powerpc/lib/Makefile                      |    5 +-
 arch/powerpc/lib/ldstfp.S                      |  375 ++++++
 arch/powerpc/lib/sstep.c                       | 1514 +++++++++++++++++++++++-
 arch/powerpc/mm/fsl_booke_mmu.c                |    7 +-
 arch/powerpc/mm/numa.c                         |  122 ++-
 arch/powerpc/mm/pgtable.c                      |    1 -
 arch/powerpc/mm/tlb_hash32.c                   |   15 -
 arch/powerpc/mm/tlb_nohash.c                   |  129 ++-
 arch/powerpc/oprofile/Makefile                 |    2 +-
 arch/powerpc/oprofile/common.c                 |    2 +-
 arch/powerpc/platforms/40x/Kconfig             |   16 -
 arch/powerpc/platforms/512x/Kconfig            |   20 +-
 arch/powerpc/platforms/512x/Makefile           |    1 +
 arch/powerpc/platforms/512x/clock.c            |   18 +
 arch/powerpc/platforms/512x/mpc5121_ads.c      |    2 +
 arch/powerpc/platforms/512x/mpc5121_generic.c  |    2 +
 arch/powerpc/platforms/512x/mpc512x.h          |    2 +
 arch/powerpc/platforms/512x/mpc512x_shared.c   |  284 +++++
 arch/powerpc/platforms/512x/pdm360ng.c         |  129 ++
 arch/powerpc/platforms/52xx/lite5200_pm.c      |    3 -
 arch/powerpc/platforms/52xx/mpc52xx_pm.c       |    3 -
 arch/powerpc/platforms/83xx/Kconfig            |    8 +
 arch/powerpc/platforms/83xx/Makefile           |    1 +
 arch/powerpc/platforms/83xx/mpc830x_rdb.c      |   94 ++
 arch/powerpc/platforms/85xx/Kconfig            |    8 +
 arch/powerpc/platforms/85xx/Makefile           |    1 +
 arch/powerpc/platforms/85xx/mpc85xx_mds.c      |  279 +++--
 arch/powerpc/platforms/85xx/p1022_ds.c         |  148 +++
 arch/powerpc/platforms/85xx/smp.c              |   67 +-
 arch/powerpc/platforms/85xx/tqm85xx.c          |   21 +
 arch/powerpc/platforms/8xx/Kconfig             |    6 +
 arch/powerpc/platforms/8xx/Makefile            |    1 +
 arch/powerpc/platforms/8xx/tqm8xx_setup.c      |  156 +++
 arch/powerpc/platforms/iseries/vio.c           |    3 +-
 arch/powerpc/platforms/powermac/cpufreq_32.c   |    8 +-
 arch/powerpc/platforms/powermac/feature.c      |    6 +-
 arch/powerpc/platforms/pseries/Makefile        |    4 +
 arch/powerpc/platforms/pseries/dlpar.c         |    1 +
 arch/powerpc/platforms/pseries/eeh_cache.c     |    3 +-
 arch/powerpc/platforms/pseries/event_sources.c |   23 +-
 arch/powerpc/platforms/pseries/hotplug-cpu.c   |    7 +-
 arch/powerpc/platforms/pseries/ras.c           |    5 +-
 arch/powerpc/platforms/pseries/reconfig.c      |    4 +-
 arch/powerpc/platforms/pseries/suspend.c       |  214 ++++
 arch/powerpc/platforms/pseries/xics.c          |    2 -
 arch/powerpc/sysdev/fsl_pci.c                  |    1 +
 arch/powerpc/sysdev/fsl_soc.h                  |    1 +
 arch/powerpc/sysdev/mpic.c                     |   18 +
 arch/powerpc/sysdev/mpic.h                     |    1 +
 arch/powerpc/xmon/xmon.c                       |  152 +++
 drivers/char/hvc_console.c                     |   12 +-
 drivers/char/hvsi.c                            |    4 +-
 drivers/i2c/busses/i2c-mpc.c                   |   69 +-
 drivers/input/serio/i8042-io.h                 |    5 +
 drivers/mtd/maps/Kconfig                       |    2 +-
 drivers/mtd/maps/redwood.c                     |   43 -
 drivers/net/Kconfig                            |    2 +-
 drivers/net/smc91x.h                           |   37 -
 drivers/serial/mpc52xx_uart.c                  |  145 ++-
 drivers/video/Kconfig                          |    1 +
 drivers/video/fsl-diu-fb.c                     |  137 ++-
 drivers/video/xilinxfb.c                       |    2 +
 {drivers/video => include/linux}/fsl-diu-fb.h  |    0
 include/linux/pci_ids.h                        |    1 +
 kernel/hw_breakpoint.c                         |   12 +
 137 files changed, 8141 insertions(+), 1065 deletions(-)
 create mode 100644 arch/powerpc/boot/dts/mpc8308rdb.dts
 create mode 100644 arch/powerpc/boot/dts/p1022ds.dts
 create mode 100644 arch/powerpc/boot/dts/pdm360ng.dts
 create mode 100644 arch/powerpc/boot/dts/stxssa8555.dts
 create mode 100644 arch/powerpc/boot/dts/tqm8xx.dts
 create mode 100644 arch/powerpc/configs/tqm8xx_defconfig
 create mode 100644 arch/powerpc/include/asm/hw_breakpoint.h
 create mode 100644 arch/powerpc/kernel/hw_breakpoint.c
 create mode 100644 arch/powerpc/kernel/idle_book3e.S
 create mode 100644 arch/powerpc/lib/ldstfp.S
 create mode 100644 arch/powerpc/platforms/512x/pdm360ng.c
 create mode 100644 arch/powerpc/platforms/83xx/mpc830x_rdb.c
 create mode 100644 arch/powerpc/platforms/85xx/p1022_ds.c
 create mode 100644 arch/powerpc/platforms/8xx/tqm8xx_setup.c
 create mode 100644 arch/powerpc/platforms/pseries/suspend.c
 rename {drivers/video => include/linux}/fsl-diu-fb.h (100%)


