Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932681Ab1ALAR3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jan 2011 19:17:29 -0500
Received: from gate.crashing.org ([63.228.1.57]:60028 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756405Ab1ALAR1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jan 2011 19:17:27 -0500
Subject: [git pull] Please pull powerpc.git merge branch
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linuxppc-dev list <linuxppc-dev@ozlabs.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 12 Jan 2011 11:16:44 +1100
Message-ID: <1294791404.9586.10.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus !

Here's the powerpc bunch for this merge window. Small this time, looks
like Kumar was too busy with holidays to send me anything from freescale
this time around.

There's some rework & cleanup of our nvram code, some support for the
POWER7+ processors, various iommu cleanups, etc... in terms of features,
we can note the support for some of IBM System P energy management and
VPHN feature which improves NUMA topology informations under our
hypervisor.

The following changes since commit 5b2eef966cb2ae307aa4ef1767f7307774bc96ca:

  Merge branch 'drm-core-next' of git://git.kernel.org/pub/scm/linux/kernel/git/airlied/drm-2.6 (2011-01-10 17:11:39 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/benh/powerpc.git next

Anatolij Gustschin (1):
      powerpc/5xxx: extend mpc8xxx_gpio driver to support mpc512x gpios

Andreas Schwab (2):
      powerpc: Fix PPC_PTRACE_SETHWDEBUG on PPC_BOOK3S
      powerpc: Update compat_arch_ptrace

Anton Blanchard (5):
      powerpc: Add support for popcnt instructions
      powerpc/kdump: Override crash_free_reserved_phys_range to avoid freeing RTAS
      powerpc: Hardcode popcnt instructions for old assemblers
      powerpc: Fix incorrect comment about interrupt stack allocation
      powerpc: iommu: Add device name to iommu error printks

Benjamin Herrenschmidt (16):
      powerpc/nvram: Move things out of asm/nvram.h
      powerpc/nvram: More flexible nvram_create_partition()
      powerpc/nvram: nvram_create_partitions() now uses bytes
      powerpc/nvram: Ensure that the partition header/block size is right
      powerpc/nvram: Completely clear a new partition
      powerpc/nvram: Shuffle code around in nvram_create_partition()
      powerpc/nvram: Improve partition removal
      powerpc/nvram: Add nvram_find_partition()
      powerpc/nvram: Change nvram_setup_partition() to use new helper
      powerpc/nvram: Move the log partition stuff to pseries
      powerpc/nvram: Rename ppc64,linux partition to ibm,rtas-log
      Merge branch 'nvram' into next
      Merge remote branch 'jwb/next' into next
      powerpc/pseries: Pass phb only to iommu_table_setparms_lpar
      Merge remote branch 'gcl/next' into next
      powerpc/pseries: Fix build of topology stuff without CONFIG_NUMA

Christian Dietrich (1):
      powerpc: Removing undead ifdef __KERNEL__

FUJITA Tomonori (1):
      powerpc: enable ARCH_DMA_ADDR_T_64BIT with ARCH_PHYS_ADDR_T_64BIT

Grant Likely (1):
      Merge v2.6.37-rc8 into powerpc/next

Heiko Schocher (1):
      powerpc/time: printk time stamp init not correct

Ilya Yanok (6):
      powerpc/512x: scatter/gather dma fix
      powerpc/512x: fix the hanged dma transfer issue
      powerpc/512x: add MPC8308 dma support
      powerpc/512x: try to free dma descriptors in case of allocation failure
      powerpc/83xx: add DMA controller to mpc8308 device-tree node
      powerpc/83xx: add mpc8308_p1m DMA controller device-tree node

Jesper Juhl (3):
      powerpc/cell: Use vzalloc rather than vmalloc and memset in spu_alloc_lscsa_std
      powerpc/iseries: Remove unused mf_getSrcHistory function and caller.
      powerpc: Remove unnecessary casts of void ptr

Jesse Larrew (4):
      powerpc: Add VPHN firmware feature
      powerpc/pseries: Poll VPA for topology changes and update NUMA maps
      powerpc: Disable VPHN polling during a suspend operation
      powerpc/pseries: Fix VPHN build errors on non-SMP systems

Jim Keniston (2):
      powerpc/nvram: Fix NVRAM partition list setup
      powerpc/nvram: Handle partition names >= 12 chars

Joe Perches (2):
      drivers/char/hvc_vio: Use static const char arrays
      powerpc/pci: Use printf extension %pR for struct resource

Lennert Buytenhek (1):
      powerpc: Fix two typos in Documentation/powerpc/booting-without-of.txt

Marc Zyngier (1):
      powerpc/powermac: Make auto-loading of therm_pm72 possible

Michael Ellerman (2):
      powerpc: Consolidate obj-y assignments
      powerpc: Record vma->phys_addr in ioremap()

Michael Neuling (4):
      powerpc: Remove unneeded cpu_setup/restore from POWER7 cputable entry
      powerpc: Remove POWER6 oprofile workarounds for POWER7
      powerpc: Add POWER7+ cputable entry
      powerpc/mm: Avoid avoidable void* pointer

Nishanth Aravamudan (11):
      powerpc/vio: Use dma ops helpers
      powerpc/pasemi: Clean up pasemi iommu table initializations
      powerpc/cell: Beat dma ops cleanup
      powerpc/dart: iommu table cleanup
      powerpc/pseries: iommu cleanup
      powerpc/macio: Ensure all dma routines get copied over
      powerpc: Add memory_hotplug_max()
      powerpc/iommu: Use coherent_dma_mask for alloc_coherent
      powerpc/pseries: Do not search for dma-window property on dlpar remove
      powerpc/pseries: Checking for pdn->parent is redundant
      powerpc/pseries: Do not need to check for dma_window == NULL

Sebastian Siewior (1):
      of/address: Use propper endianess in get_flags

Sonny Rao (2):
      Powerpc: separate CONFIG_RELOCATABLE from CONFIG_CRASHDUMP in boot code
      powerpc: Minor cleanups for machdep.h

Srikanth Krishnakar (1):
      rtc-cmos.c : Fix warning on PowerPC

Stephen Rothwell (1):
      powerpc: Remove second definition of STACK_FRAME_OVERHEAD

Tracey Dent (1):
      powerpc/ps3: Replace the use of <module>-objs with <module>-y

Vaidyanathan Srinivasan (2):
      powerpc: Cleanup APIs for cpu/thread/core mappings
      powerpc: Add support for new hcall H_BEST_ENERGY

Victor Gallardo (3):
      powerpc/4xx: Add suspend and idle support
      powerpc/4xx: Add Kilauea suspend and idle support
      powerpc/4xx: Add Canyonlands suspend and idle support

Will Schmidt (1):
      powerpc/pseries: Add kernel parameter to disable batched hcalls

 Documentation/kernel-parameters.txt             |    8 +
 Documentation/powerpc/booting-without-of.txt    |    4 +-
 Documentation/powerpc/dts-bindings/4xx/cpm.txt  |   52 +++
 arch/powerpc/Kconfig                            |   16 +-
 arch/powerpc/boot/dts/canyonlands.dts           |   31 +-
 arch/powerpc/boot/dts/kilauea.dts               |    9 +
 arch/powerpc/boot/dts/mpc8308_p1m.dts           |    8 +
 arch/powerpc/boot/dts/mpc8308rdb.dts            |    8 +
 arch/powerpc/configs/40x/kilauea_defconfig      |    5 +
 arch/powerpc/configs/44x/canyonlands_defconfig  |    3 +
 arch/powerpc/include/asm/bitops.h               |    9 +
 arch/powerpc/include/asm/cputable.h             |    9 +-
 arch/powerpc/include/asm/cputhreads.h           |   15 +-
 arch/powerpc/include/asm/device.h               |    6 +
 arch/powerpc/include/asm/firmware.h             |    3 +-
 arch/powerpc/include/asm/hvcall.h               |    4 +-
 arch/powerpc/include/asm/lppaca.h               |    5 +-
 arch/powerpc/include/asm/machdep.h              |    6 +-
 arch/powerpc/include/asm/mmzone.h               |    5 +
 arch/powerpc/include/asm/nvram.h                |   52 +--
 arch/powerpc/include/asm/ppc-opcode.h           |    8 +
 arch/powerpc/include/asm/processor.h            |    2 -
 arch/powerpc/include/asm/prom.h                 |    2 +-
 arch/powerpc/include/asm/topology.h             |   15 +-
 arch/powerpc/include/asm/vdso_datapage.h        |    2 -
 arch/powerpc/kernel/Makefile                    |    9 +-
 arch/powerpc/kernel/asm-offsets.c               |    1 -
 arch/powerpc/kernel/cputable.c                  |   22 +-
 arch/powerpc/kernel/crash_dump.c                |   33 ++
 arch/powerpc/kernel/dma-iommu.c                 |    2 +-
 arch/powerpc/kernel/entry_32.S                  |    1 +
 arch/powerpc/kernel/exceptions-64s.S            |    1 +
 arch/powerpc/kernel/fpu.S                       |    1 +
 arch/powerpc/kernel/head_40x.S                  |    1 +
 arch/powerpc/kernel/head_44x.S                  |    1 +
 arch/powerpc/kernel/head_64.S                   |    7 +-
 arch/powerpc/kernel/head_8xx.S                  |    1 +
 arch/powerpc/kernel/head_fsl_booke.S            |    1 +
 arch/powerpc/kernel/iommu.c                     |   14 +-
 arch/powerpc/kernel/misc.S                      |    5 -
 arch/powerpc/kernel/misc_32.S                   |    1 +
 arch/powerpc/kernel/misc_64.S                   |    1 +
 arch/powerpc/kernel/nvram_64.c                  |  481 ++++++++---------------
 arch/powerpc/kernel/pci_64.c                    |    3 +-
 arch/powerpc/kernel/ppc_ksyms.c                 |    7 +
 arch/powerpc/kernel/ppc_save_regs.S             |    1 +
 arch/powerpc/kernel/ptrace.c                    |   22 +-
 arch/powerpc/kernel/ptrace32.c                  |    7 +
 arch/powerpc/kernel/rtas.c                      |    3 +
 arch/powerpc/kernel/setup_64.c                  |    4 +-
 arch/powerpc/kernel/smp.c                       |   19 +-
 arch/powerpc/kernel/time.c                      |    2 +-
 arch/powerpc/kernel/vector.S                    |    1 +
 arch/powerpc/kernel/vio.c                       |   15 +-
 arch/powerpc/lib/Makefile                       |    2 +-
 arch/powerpc/lib/hweight_64.S                   |  110 +++++
 arch/powerpc/mm/hash_utils_64.c                 |    2 +-
 arch/powerpc/mm/mmu_context_nohash.c            |   12 +-
 arch/powerpc/mm/numa.c                          |  311 ++++++++++++++-
 arch/powerpc/mm/pgtable_32.c                    |    3 +-
 arch/powerpc/mm/pgtable_64.c                    |    2 +
 arch/powerpc/platforms/44x/Makefile             |    5 +-
 arch/powerpc/platforms/Kconfig                  |    7 +-
 arch/powerpc/platforms/cell/beat_iommu.c        |    3 +-
 arch/powerpc/platforms/cell/spufs/lscsa_alloc.c |    3 +-
 arch/powerpc/platforms/chrp/time.c              |    4 +
 arch/powerpc/platforms/iseries/mf.c             |   62 ---
 arch/powerpc/platforms/pasemi/iommu.c           |   19 +-
 arch/powerpc/platforms/powermac/setup.c         |    9 +
 arch/powerpc/platforms/pseries/Kconfig          |   10 +
 arch/powerpc/platforms/pseries/Makefile         |    1 +
 arch/powerpc/platforms/pseries/firmware.c       |    1 +
 arch/powerpc/platforms/pseries/hvCall.S         |    1 +
 arch/powerpc/platforms/pseries/iommu.c          |   49 +--
 arch/powerpc/platforms/pseries/lpar.c           |   12 +
 arch/powerpc/platforms/pseries/nvram.c          |  205 ++++++++++
 arch/powerpc/platforms/pseries/pseries_energy.c |  326 +++++++++++++++
 arch/powerpc/sysdev/Makefile                    |    1 +
 arch/powerpc/sysdev/dart_iommu.c                |    9 +-
 arch/powerpc/sysdev/mpc8xxx_gpio.c              |   75 ++++-
 arch/powerpc/sysdev/ppc4xx_cpm.c                |  346 ++++++++++++++++
 arch/powerpc/sysdev/tsi108_dev.c                |    8 +-
 drivers/char/hvc_vio.c                          |    2 +-
 drivers/dma/Kconfig                             |    2 +-
 drivers/dma/mpc512x_dma.c                       |  187 ++++++---
 drivers/macintosh/macio_asic.c                  |    7 +-
 drivers/macintosh/therm_pm72.c                  |   30 +--
 drivers/of/address.c                            |   54 ++--
 drivers/ps3/Makefile                            |    2 +-
 drivers/rtc/rtc-cmos.c                          |    3 +-
 include/linux/of_address.h                      |    6 +-
 91 files changed, 2103 insertions(+), 742 deletions(-)
 create mode 100644 Documentation/powerpc/dts-bindings/4xx/cpm.txt
 create mode 100644 arch/powerpc/lib/hweight_64.S
 create mode 100644 arch/powerpc/platforms/pseries/pseries_energy.c
 create mode 100644 arch/powerpc/sysdev/ppc4xx_cpm.c


