Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934653Ab1ETIHL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 May 2011 04:07:11 -0400
Received: from gate.crashing.org ([63.228.1.57]:59341 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934415Ab1ETIHA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 May 2011 04:07:00 -0400
Subject: [git pull] Please pull powerpc.git merge branch
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linuxppc-dev list <linuxppc-dev@ozlabs.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 20 May 2011 18:06:10 +1000
Message-ID: <1305878770.7481.157.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus

Here's the bulk of powerpc changes for this merge window. 

Some of the highlights are:

 - Basic support for the new PowerEN processor (Power Edge of Network, I
didn't come up with that name), and known in the linux code by one of
it's former code names "wsp" (aka Wirespeed Processor). This adds among
other support for the A2i core contained in that SoC which is an
embedded multithreaded 64-bit core with an in-order pipeline using the
"embedded" variant of the PowerPC architecture.

 - Some work for running on Power7 without an underlying hypervisor
(running in hypervisor mode), which will enable the KVM code that Paulus
and Alex are getting ready for the next merge window

 - A whole pile of cleanups and bugs fixes mostly to our interrupt
handling from Milton, which should make Thomas and Grant life easier in
moving some of the irq domain facility to generic code

And the usual pile of small bits & pieces, fixes, new boards, etc...

I have done a manual merge with your tree today to fixup a non-trivial
clash with Peter's scheduler_ipi() changes (the obvious fixup would have
missed a couple of places where that call needs to be added) and I've
added a pair of fixes on top of it to work around immediate breakage I
found after testing the result.

Note: At the time of sending this, it hadn't hit the mirrors yet.

Cheers,
Ben. 

The following changes since commit 39ab05c8e0b519ff0a04a869f065746e6e8c3d95:

  Merge branch 'driver-core-next' of git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/driver-core-2.6 (2011-05-19 18:24:11 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/benh/powerpc.git merge

Alexey Kardashevskiy (1):
      powerpc: Per process DSCR + some fixes (try#4)

Anton Blanchard (10):
      powerpc: Replace open coded instruction patching with patch_instruction/patch_branch
      powerpc/rtas: Only sleep in rtas_busy_delay if we have useful work to do
      powerpc/pseries: Enable Emulex and Qlogic 10Gbit cards
      powerpc/pseries: Enable iSCSI support for a number of cards
      powerpc: Simplify 4k/64k copy_page logic
      powerpc: Remove static branch hint in giveup_altivec
      powerpc: Improve scheduling of system call entry instructions
      powerpc: Add ioremap_wc
      powerpc: Remove ioremap_flags
      powerpc/pseries: Print corrupt r3 in FWNMI code

Ben Hutchings (2):
      powerpc/kexec: Fix build failure on 32-bit SMP
      powerpc/kexec: Fix build failure on 32-bit SMP

Benjamin Herrenschmidt (29):
      powerpc/xics: Rewrite XICS driver
      powerpc: Add more Power7 specific definitions
      powerpc/xics: Make sure we have a sensible default distribution server
      powerpc: Define CPU feature for Architected 2.06 HV mode
      powerpc: In HV mode, use HSPRG0 for PACA
      powerpc: Base support for exceptions using HSRR0/1
      powerpc: More work to support HV exceptions
      powerpc: Initialize LPCR:DPFD on power7 to a sane default
      powerpc: Initialize TLB and LPID register on HV mode Power7
      powerpc: Call CPU ->restore callback earlier on secondary CPUs
      powerpc: Properly handshake CPUs going out of boot spin loop
      powerpc: Add NAP mode support on Power7 in HV mode
      powerpc: Perform an isync to synchronize CPUs coming out of secondary_hold
      powerpc: Improve prom_printf()
      powerpc/a2: Add some #defines for A2 specific instructions
      powerpc: Add SCOM infrastructure
      powerpc/nvram: Search for nvram using compatible
      powerpc: Add A2 cpu support
      powerpc: Add TLB size detection for TYPE_3E MMUs
      powerpc/book3e: Use way 3 for linear mapping bolted entry
      powerpc: Rename slb0_limit() to safe_stack_limit() and add Book3E support
      powerpc/smp: Make start_secondary_resume available to all CPU variants
      powerpc: Remove unused/obsolete CONFIG_XICS
      Merge branch 'merge' into next
      powerpc: Make early memory scan more resilient to out of order nodes
      Merge remote branch 'kumar/next' into next
      Merge remote branch 'origin/master' into merge
      powerpc/pmac: Update via-pmu to new syscore_ops
      powerpc: Fix hard CPU IDs detection

Bhaskar Upadhaya (1):
      powerpc: Adding bindings for flexcan controller

Brian King (1):
      powerpc/pseries: Add page coalescing support

David Gibson (2):
      powerpc/boot: Add an ePAPR compliant boot wrapper
      powerpc: Add WSP platform

Dipen Dudhat (1):
      powerpc: Integrated Flash controller device tree bindings

Gabriel Paubert (1):
      powerpc: Fix for Pegasos keyboard and mouse

Geert Uytterhoeven (2):
      powerpc/ps3: Update debug message for irq_set_chip_data()
      powerpc/mpc8610_hpcd: Do not use "/" in interrupt names

Grant Likely (1):
      powerpc/irq: Stop exporting irq_map

Ira Snyder (2):
      misc: Add CARMA DATA-FPGA Access Driver
      misc: Add CARMA DATA-FPGA Programmer support

Jack Miller (2):
      powerpc/book3e: Flush IPROT protected TLB entries leftover by firmware
      powerpc: Add early debug for WSP platforms

Justin Mattock (1):
      powerpc: Remove unused config in the Makefile

KOSAKI Motohiro (1):
      powerpc: Convert old cpumask API into new one

Kumar Gala (2):
      Merge remote branch 'benh/merge' into benh-next
      powerpc/fsl-booke64: Add support for Debug Level exception handler

Matt Evans (1):
      powerpc: Free up some CPU feature bits by moving out MMU-related features

Michael Ellerman (19):
      powerpc/mm: Standardise on MMU_NO_CONTEXT
      powerpc/mm: Fix slice state initialization for Book3E
      powerpc/boot: Allow building the zImage wrapper as a relocatable ET_DYN
      powerpc/smp: smp_ops->kick_cpu() should be able to fail
      powerpc/nohash: Allocate stale_map[cpu] on CPU_UP_PREPARE not CPU_ONLINE
      of: Export of_irq_find_parent()
      powerpc/xics: xics.h relies on linux/interrupt.h
      powerpc/xics: Move irq_host matching into the ics backend
      powerpc: Index crit/dbg/mcheck stacks using cpu number on 64bit
      powerpc/pci: Split IO vs MMIO indirect access hooks
      powerpc/pci: Move IO workarounds to the common kernel dir
      powerpc/pci: Make IO workarounds init implicit when first bus is registered
      powerpc/pci: Properly initialize IO workaround "private"
      powerpc/numa: Look for ibm, associativity-reference-points at the root
      powerpc/irq: Dump chip data pointer in virq_mapping
      powerpc: Add MSR_64BIT
      powerpc: Use MSR_64BIT in places
      powerpc: Use MSR_64BIT in sstep.c, fix kprobes on BOOK3E
      powerpc/book3e: Fix extlb size

Michael Neuling (1):
      powerpc: Use new CPU feature bit to select 2.06 tlbie

Michal Marek (2):
      powerpc: Call gzip with -n
      powerpc: Use the deterministic mode of ar

Milton Miller (39):
      powerpc/kexec: Fix memory corruption from unallocated slaves
      powerpc: Don't search for paca in freed memory
      powerpc/kdump64: Don't reference freed memory as pacas
      powerpc/iseries: Cleanup and fix secondary startup
      powerpc: Respect nr_cpu_ids when calling set_cpu_possible and set_cpu_present
      powerpc: Use nr_cpu_ids in initial paca allocation
      powerpc: Call no-longer static setup_nr_cpu_ids instead of replicating it
      powerpc/mpic: Limit NR_CPUS loop to 32 bit
      powerpc/mpic: Break cpumask abstraction earlier
      powerpc: Remove call sites of MSG_ALL_BUT_SELF
      powerpc: Remove checks for MSG_ALL and MSG_ALL_BUT_SELF
      powerpc/mpic: Simplify ipi cpu mask handling
      powerpc: Remove powermac/pic.h
      powerpc: Remove alloc_maybe_bootmem for zalloc version
      powerpc: Remove stubbed beat smp support
      powerpc: Move smp_ops_t from machdep.h to smp.h
      powerpc: Consolidate ipi message mux and demux
      powerpc: Add kconfig for muxed smp ipi support
      powerpc: Use bytes instead of bitops in smp ipi multiplexing
      powerpc/xics: Cleanup xics_host_map and ipi
      powerpc: Radix trees are available before init_IRQ
      powerpc: Return early if irq_host lookup type is wrong
      powerpc: Remove trival irq_host_ops.unmap
      powerpc: Remove i8259 irq_host_ops->unmap
      powerpc/fsl_msi: Don't abuse platform_data for driver_data
      powerpc/fsl_msi: Use chip_data not handler_data
      powerpc/mpc5121_ads_cpld: Remove use of NO_IRQ_IGNORE
      powerpc/mpc62xx_pic: Fix get_irq handling of NO_IRQ
      powerpc/psurge: Create a irq_host for secondary cpus
      powerpc: Remove irq_host_ops->remap hook
      powerpc/spider-pic: Get pic from chip_data instead of irq_map
      powerpc/axon_msi: Validate msi irq via chip_data
      powerpc: Add virq_is_host to reduce virq_to_host usage
      powerpc: Remove virq_to_host
      powerpc: Make IRQ_NOREQUEST last to clear, first to set
      powerpc/pseries/iommu: Add additional checks when changing iommu mask
      powerpc/pseries/iommu: Remove ddw property when destroying window
      powerpc/pseries/iommu: Find windows after kexec during boot
      powerpc/pseries/iommu: Cleanup ddw naming

Nishanth Aravamudan (5):
      cxgb4: use pgprot_writecombine() on powerpc
      powerpc: Fix kexec with dynamic dma windows
      powerpc: Ensure dtl buffers do not cross 4k boundary
      pseries/iommu: Restore iommu table pointer when restoring iommu ops
      powerpc/pseries/iommu: Use correct return type in dupe_ddw_if_already_created

Paul Mackerras (5):
      powerpc: Always use SPRN_SPRG_HSCRATCH0 when running in HV mode
      powerpc: Save register r9-r13 values accurately on interrupt with bad stack
      powerpc: Save Come-From Address Register (CFAR) in exception frame
      powerpc/kvm: Fix kvmppc_core_pending_dec
      powerpc/kvm: Fix the build for 32-bit Book 3S (classic) processors

Prabhakar Kushwaha (4):
      powerpc/85xx: P1020 DTS : re-organize dts files
      powerpc/85xx: P2020 DTS: re-organize dts files
      powerpc/85xx: Fix PCIe IDSEL for Px020RDB
      powerpc/85xx: Create dts of each core in CAMP mode for P1020RDB

Richard A Lary (3):
      powerpc/pseries/eeh: Propagate needs_freset flag to device at PE
      powerpc/pseries/eeh: Handle functional reset on non-PCIe device
      powerpc/eeh: Display eeh error location for bus and device

Richard A. Lary (1):
      powerpc/eeh: Add support for ibm,configure-pe RTAS call

Robert P. J. Day (1):
      powerpc/pseries/bsr: Remove redundant initialization of bsr dev_t declaration.

Scott Wood (7):
      powerpc/e5500: set non-base IVORs
      powerpc: Add fsl mpic timer binding
      powerpc/p1022ds: fix broken mpic timer node
      powerpc/mpic: parse 4-cell intspec types other than zero
      powerpc/mpic: add the mpic global timer support
      powerpc/e5500: add networking to defconfig
      powerpc/fsl: enable verbose bug output

Sebastian Siewior (1):
      powerpc: Remove last piece of GEMINI

Stephen Rothwell (1):
      powerpc: Fix compile with icwsx support

Stratos Psomadakis (1):
      powerpc/mm: Fix compiler warning in pgtable-ppc64.h [-Wunused-but-set-variable]

Timur Tabi (1):
      powerpc/86xx: don't pretend that we support 8-bit pixels on the MPC8610 HPCD

Tseng-Hui (Frank) Lin (3):
      powerpc: Add Initiate Coprocessor Store Word (icswx) support
      powerpc/pseries: Add RTAS event log v6 definition
      powerpc/pseries: Add support for IO event interrupts

Wanlong Gao (1):
      powerpc: Fix build warning of the defconfigs

kerstin jonsson (1):
      powerpc/4xx: Fix regression in SMP on 476

 .../devicetree/bindings/net/can/fsl-flexcan.txt    |   61 +
 .../devicetree/bindings/powerpc/fsl/ifc.txt        |   76 +
 .../devicetree/bindings/powerpc/fsl/mpic-timer.txt |   38 +
 .../devicetree/bindings/powerpc/fsl/mpic.txt       |    2 +-
 arch/powerpc/Kconfig                               |    6 +
 arch/powerpc/Kconfig.debug                         |    5 +
 arch/powerpc/boot/Makefile                         |    6 +-
 arch/powerpc/boot/crt0.S                           |  116 +-
 arch/powerpc/boot/dts/p1020rdb.dts                 |  332 +-----
 arch/powerpc/boot/dts/p1020rdb_camp_core0.dts      |  213 +++
 arch/powerpc/boot/dts/p1020rdb_camp_core1.dts      |  148 ++
 arch/powerpc/boot/dts/p1020si.dtsi                 |  377 +++++
 arch/powerpc/boot/dts/p1022ds.dts                  |  106 +-
 arch/powerpc/boot/dts/p2020ds.dts                  |  374 +-----
 arch/powerpc/boot/dts/p2020rdb.dts                 |  378 +-----
 arch/powerpc/boot/dts/p2020rdb_camp_core0.dts      |  245 +---
 arch/powerpc/boot/dts/p2020rdb_camp_core1.dts      |  150 ++-
 arch/powerpc/boot/dts/p2020si.dtsi                 |  382 ++++++
 arch/powerpc/boot/epapr.c                          |   66 +
 arch/powerpc/boot/wrapper                          |   19 +-
 arch/powerpc/boot/zImage.coff.lds.S                |    6 +-
 arch/powerpc/boot/zImage.lds.S                     |   57 +-
 arch/powerpc/configs/83xx/mpc8313_rdb_defconfig    |    1 -
 arch/powerpc/configs/83xx/mpc8315_rdb_defconfig    |    1 -
 arch/powerpc/configs/85xx/mpc8540_ads_defconfig    |    1 -
 arch/powerpc/configs/85xx/mpc8560_ads_defconfig    |    1 -
 arch/powerpc/configs/85xx/mpc85xx_cds_defconfig    |    1 -
 arch/powerpc/configs/86xx/mpc8641_hpcn_defconfig   |    1 -
 arch/powerpc/configs/c2k_defconfig                 |    4 +-
 arch/powerpc/configs/e55xx_smp_defconfig           |   39 +-
 arch/powerpc/configs/mpc85xx_defconfig             |    1 -
 arch/powerpc/configs/mpc85xx_smp_defconfig         |    1 -
 arch/powerpc/configs/mpc86xx_defconfig             |    1 -
 arch/powerpc/configs/pmac32_defconfig              |    4 +-
 arch/powerpc/configs/ppc6xx_defconfig              |    4 +-
 arch/powerpc/configs/ps3_defconfig                 |    4 +-
 arch/powerpc/configs/pseries_defconfig             |    8 +
 arch/powerpc/include/asm/cputable.h                |   55 +-
 arch/powerpc/include/asm/cputhreads.h              |   12 +-
 arch/powerpc/include/asm/dbell.h                   |    3 +-
 arch/powerpc/include/asm/emulated_ops.h            |    4 +
 arch/powerpc/include/asm/exception-64s.h           |  113 +-
 arch/powerpc/include/asm/feature-fixups.h          |   15 +-
 arch/powerpc/include/asm/firmware.h                |    3 +-
 arch/powerpc/include/asm/hvcall.h                  |   12 +
 .../cell => include/asm}/io-workarounds.h          |    1 -
 arch/powerpc/include/asm/io.h                      |   33 +-
 arch/powerpc/include/asm/io_event_irq.h            |   54 +
 arch/powerpc/include/asm/irq.h                     |   18 +-
 arch/powerpc/include/asm/kexec.h                   |    2 +-
 arch/powerpc/include/asm/kvm_asm.h                 |    1 +
 arch/powerpc/include/asm/kvm_book3s_asm.h          |    1 +
 arch/powerpc/include/asm/lppaca.h                  |    2 +
 arch/powerpc/include/asm/machdep.h                 |   22 +-
 arch/powerpc/include/asm/mmu-book3e.h              |   20 +
 arch/powerpc/include/asm/mmu-hash64.h              |    6 +
 arch/powerpc/include/asm/mmu.h                     |   52 +-
 arch/powerpc/include/asm/mmu_context.h             |   12 +-
 arch/powerpc/include/asm/mpic.h                    |    5 +-
 arch/powerpc/include/asm/pSeries_reconfig.h        |    5 +
 arch/powerpc/include/asm/paca.h                    |   11 +-
 arch/powerpc/include/asm/page_64.h                 |   21 +-
 arch/powerpc/include/asm/pgtable-ppc64.h           |   13 +-
 arch/powerpc/include/asm/ppc-opcode.h              |   35 +
 arch/powerpc/include/asm/ppc_asm.h                 |    1 +
 arch/powerpc/include/asm/processor.h               |    4 +
 arch/powerpc/include/asm/reg.h                     |  104 ++-
 arch/powerpc/include/asm/reg_a2.h                  |  165 +++
 arch/powerpc/include/asm/reg_booke.h               |   10 +-
 arch/powerpc/include/asm/rtas.h                    |   45 +-
 arch/powerpc/include/asm/scom.h                    |  156 +++
 arch/powerpc/include/asm/smp.h                     |   38 +-
 arch/powerpc/include/asm/system.h                  |    2 -
 arch/powerpc/include/asm/tlbflush.h                |    2 +
 arch/powerpc/include/asm/udbg.h                    |    1 +
 arch/powerpc/include/asm/wsp.h                     |   14 +
 arch/powerpc/include/asm/xics.h                    |  142 ++
 arch/powerpc/kernel/Makefile                       |    6 +-
 arch/powerpc/kernel/asm-offsets.c                  |    1 +
 arch/powerpc/kernel/cpu_setup_a2.S                 |  114 ++
 arch/powerpc/kernel/cpu_setup_fsl_booke.S          |    3 +
 arch/powerpc/kernel/cpu_setup_power7.S             |   91 ++
 arch/powerpc/kernel/cputable.c                     |   66 +-
 arch/powerpc/kernel/crash.c                        |   91 +-
 arch/powerpc/kernel/dbell.c                        |   65 +-
 arch/powerpc/kernel/entry_64.S                     |   27 +-
 arch/powerpc/kernel/exceptions-64e.S               |  202 +++-
 arch/powerpc/kernel/exceptions-64s.S               |  216 +++-
 arch/powerpc/kernel/head_32.S                      |   22 -
 arch/powerpc/kernel/head_64.S                      |   49 +-
 arch/powerpc/kernel/idle_power7.S                  |   97 ++
 .../{platforms/cell => kernel}/io-workarounds.c    |   31 +-
 arch/powerpc/kernel/irq.c                          |  166 +--
 arch/powerpc/kernel/kgdb.c                         |    2 +-
 arch/powerpc/kernel/lparcfg.c                      |   53 +-
 arch/powerpc/kernel/misc_32.S                      |   11 +
 arch/powerpc/kernel/misc_64.S                      |   13 +-
 arch/powerpc/kernel/paca.c                         |   30 +-
 arch/powerpc/kernel/pci_dn.c                       |    3 +-
 arch/powerpc/kernel/ppc_ksyms.c                    |    5 +-
 arch/powerpc/kernel/process.c                      |   20 +-
 arch/powerpc/kernel/prom.c                         |   64 +-
 arch/powerpc/kernel/prom_init.c                    |   30 +-
 arch/powerpc/kernel/rtas.c                         |    4 +-
 arch/powerpc/kernel/setup-common.c                 |   22 +-
 arch/powerpc/kernel/setup_32.c                     |    1 +
 arch/powerpc/kernel/setup_64.c                     |   44 +-
 arch/powerpc/kernel/signal_64.c                    |    4 +-
 arch/powerpc/kernel/smp.c                          |  138 ++-
 arch/powerpc/kernel/sysfs.c                        |   38 +
 arch/powerpc/kernel/traps.c                        |   28 +-
 arch/powerpc/kernel/udbg.c                         |    2 +
 arch/powerpc/kernel/udbg_16550.c                   |   51 +
 arch/powerpc/kernel/vector.S                       |    2 +-
 arch/powerpc/kvm/book3s.c                          |    2 +-
 arch/powerpc/kvm/book3s_rmhandlers.S               |   13 +-
 arch/powerpc/kvm/book3s_segment.S                  |   12 +-
 arch/powerpc/lib/alloc.c                           |    8 -
 arch/powerpc/lib/copypage_64.S                     |    7 +-
 arch/powerpc/lib/devres.c                          |    6 +-
 arch/powerpc/lib/sstep.c                           |   61 +-
 arch/powerpc/mm/hash_low_64.S                      |    8 +-
 arch/powerpc/mm/hash_native_64.c                   |   18 +-
 arch/powerpc/mm/hash_utils_64.c                    |   62 +-
 arch/powerpc/mm/hugetlbpage.c                      |    2 +-
 arch/powerpc/mm/mmu_context_hash64.c               |  214 +++-
 arch/powerpc/mm/mmu_context_nohash.c               |   18 +-
 arch/powerpc/mm/numa.c                             |   17 +-
 arch/powerpc/mm/pgtable_32.c                       |   12 +-
 arch/powerpc/mm/pgtable_64.c                       |   15 +-
 arch/powerpc/mm/slb.c                              |   10 +-
 arch/powerpc/mm/slb_low.S                          |    8 +-
 arch/powerpc/mm/stab.c                             |    2 +-
 arch/powerpc/platforms/44x/iss4xx.c                |    6 +-
 arch/powerpc/platforms/512x/mpc5121_ads_cpld.c     |   10 +-
 arch/powerpc/platforms/52xx/media5200.c            |    4 +-
 arch/powerpc/platforms/52xx/mpc52xx_pic.c          |   83 +-
 arch/powerpc/platforms/82xx/pq2ads-pci-pic.c       |   12 +-
 arch/powerpc/platforms/85xx/smp.c                  |   12 +-
 arch/powerpc/platforms/85xx/socrates_fpga_pic.c    |   26 +-
 arch/powerpc/platforms/86xx/gef_pic.c              |   10 +-
 arch/powerpc/platforms/86xx/mpc8610_hpcd.c         |   99 +-
 arch/powerpc/platforms/86xx/mpc86xx_smp.c          |    6 +-
 arch/powerpc/platforms/8xx/m8xx_setup.c            |    2 +-
 arch/powerpc/platforms/Kconfig                     |   31 +-
 arch/powerpc/platforms/Kconfig.cputype             |   24 +
 arch/powerpc/platforms/Makefile                    |    1 +
 arch/powerpc/platforms/cell/Kconfig                |    4 +-
 arch/powerpc/platforms/cell/Makefile               |    9 +-
 arch/powerpc/platforms/cell/axon_msi.c             |    3 +-
 arch/powerpc/platforms/cell/beat_interrupt.c       |   27 -
 arch/powerpc/platforms/cell/beat_interrupt.h       |    3 -
 arch/powerpc/platforms/cell/beat_smp.c             |  124 --
 arch/powerpc/platforms/cell/cbe_regs.c             |   11 +-
 arch/powerpc/platforms/cell/celleb_pci.c           |   25 +-
 arch/powerpc/platforms/cell/celleb_pci.h           |    3 +-
 arch/powerpc/platforms/cell/celleb_setup.c         |    4 -
 arch/powerpc/platforms/cell/interrupt.c            |   16 +-
 arch/powerpc/platforms/cell/qpace_setup.c          |    1 -
 arch/powerpc/platforms/cell/setup.c                |    4 +-
 arch/powerpc/platforms/cell/smp.c                  |   37 +-
 arch/powerpc/platforms/cell/spider-pci.c           |    3 +-
 arch/powerpc/platforms/cell/spider-pic.c           |   21 +-
 arch/powerpc/platforms/cell/spufs/sched.c          |    2 +-
 arch/powerpc/platforms/chrp/smp.c                  |    4 +-
 arch/powerpc/platforms/embedded6xx/flipper-pic.c   |   15 +-
 arch/powerpc/platforms/embedded6xx/hlwd-pic.c      |   15 +-
 arch/powerpc/platforms/iseries/Kconfig             |    4 +-
 arch/powerpc/platforms/iseries/exception.S         |   62 +-
 arch/powerpc/platforms/iseries/irq.c               |   13 +-
 arch/powerpc/platforms/iseries/setup.c             |    9 +-
 arch/powerpc/platforms/iseries/smp.c               |   45 +-
 arch/powerpc/platforms/iseries/smp.h               |    6 -
 arch/powerpc/platforms/powermac/Kconfig            |   11 +-
 arch/powerpc/platforms/powermac/pic.c              |   25 +-
 arch/powerpc/platforms/powermac/pic.h              |   11 -
 arch/powerpc/platforms/powermac/pmac.h             |    1 +
 arch/powerpc/platforms/powermac/smp.c              |   97 +-
 arch/powerpc/platforms/ps3/interrupt.c             |    8 +-
 arch/powerpc/platforms/ps3/smp.c                   |   22 +-
 arch/powerpc/platforms/ps3/spu.c                   |    4 +-
 arch/powerpc/platforms/pseries/Kconfig             |   23 +-
 arch/powerpc/platforms/pseries/Makefile            |    2 +-
 arch/powerpc/platforms/pseries/dtl.c               |   20 +-
 arch/powerpc/platforms/pseries/eeh.c               |   82 +-
 arch/powerpc/platforms/pseries/eeh_driver.c        |   22 +-
 arch/powerpc/platforms/pseries/hotplug-cpu.c       |    5 +-
 arch/powerpc/platforms/pseries/io_event_irq.c      |  231 ++++
 arch/powerpc/platforms/pseries/iommu.c             |  117 +-
 arch/powerpc/platforms/pseries/kexec.c             |    5 +-
 arch/powerpc/platforms/pseries/lpar.c              |   48 +-
 arch/powerpc/platforms/pseries/plpar_wrappers.h    |   27 -
 arch/powerpc/platforms/pseries/ras.c               |    6 +-
 arch/powerpc/platforms/pseries/setup.c             |   50 +-
 arch/powerpc/platforms/pseries/smp.c               |   24 +-
 arch/powerpc/platforms/pseries/xics.c              |  949 -------------
 arch/powerpc/platforms/pseries/xics.h              |   23 -
 arch/powerpc/platforms/wsp/Kconfig                 |   28 +
 arch/powerpc/platforms/wsp/Makefile                |    6 +
 arch/powerpc/platforms/wsp/ics.c                   |  712 ++++++++++
 arch/powerpc/platforms/wsp/ics.h                   |   20 +
 arch/powerpc/platforms/wsp/opb_pic.c               |  332 +++++
 arch/powerpc/platforms/wsp/psr2.c                  |   95 ++
 arch/powerpc/platforms/wsp/scom_smp.c              |  427 ++++++
 arch/powerpc/platforms/wsp/scom_wsp.c              |   77 ++
 arch/powerpc/platforms/wsp/setup.c                 |   36 +
 arch/powerpc/platforms/wsp/smp.c                   |   88 ++
 arch/powerpc/platforms/wsp/wsp.h                   |   17 +
 arch/powerpc/sysdev/Kconfig                        |   10 +
 arch/powerpc/sysdev/Makefile                       |    6 +
 arch/powerpc/sysdev/axonram.c                      |    2 +-
 arch/powerpc/sysdev/cpm1.c                         |    8 +-
 arch/powerpc/sysdev/cpm2_pic.c                     |   10 +-
 arch/powerpc/sysdev/fsl_85xx_cache_sram.c          |    4 +-
 arch/powerpc/sysdev/fsl_msi.c                      |   10 +-
 arch/powerpc/sysdev/i8259.c                        |   13 -
 arch/powerpc/sysdev/ipic.c                         |   16 +-
 arch/powerpc/sysdev/mmio_nvram.c                   |    2 +
 arch/powerpc/sysdev/mpc8xx_pic.c                   |   10 +-
 arch/powerpc/sysdev/mpc8xxx_gpio.c                 |   12 +-
 arch/powerpc/sysdev/mpic.c                         |  209 ++-
 arch/powerpc/sysdev/mv64x60_pic.c                  |   14 +-
 arch/powerpc/sysdev/qe_lib/qe_ic.c                 |    6 +-
 arch/powerpc/sysdev/scom.c                         |  192 +++
 arch/powerpc/sysdev/uic.c                          |   12 +-
 arch/powerpc/sysdev/xics/Kconfig                   |   13 +
 arch/powerpc/sysdev/xics/Makefile                  |    6 +
 arch/powerpc/sysdev/xics/icp-hv.c                  |  164 +++
 arch/powerpc/sysdev/xics/icp-native.c              |  293 ++++
 arch/powerpc/sysdev/xics/ics-rtas.c                |  240 ++++
 arch/powerpc/sysdev/xics/xics-common.c             |  443 ++++++
 arch/powerpc/sysdev/xilinx_intc.c                  |    8 +-
 arch/powerpc/xmon/xmon.c                           |   38 +-
 drivers/char/bsr.c                                 |    2 +-
 drivers/infiniband/hw/cxgb4/t4.h                   |    5 +-
 drivers/macintosh/via-pmu.c                        |   56 +-
 drivers/misc/Kconfig                               |    1 +
 drivers/misc/Makefile                              |    1 +
 drivers/misc/carma/Kconfig                         |   17 +
 drivers/misc/carma/Makefile                        |    2 +
 drivers/misc/carma/carma-fpga-program.c            | 1141 ++++++++++++++++
 drivers/misc/carma/carma-fpga.c                    | 1433 ++++++++++++++++++++
 drivers/of/irq.c                                   |    2 +-
 include/linux/of_irq.h                             |    1 +
 244 files changed, 11490 insertions(+), 4116 deletions(-)
 create mode 100755 Documentation/devicetree/bindings/net/can/fsl-flexcan.txt
 create mode 100644 Documentation/devicetree/bindings/powerpc/fsl/ifc.txt
 create mode 100644 Documentation/devicetree/bindings/powerpc/fsl/mpic-timer.txt
 create mode 100644 arch/powerpc/boot/dts/p1020rdb_camp_core0.dts
 create mode 100644 arch/powerpc/boot/dts/p1020rdb_camp_core1.dts
 create mode 100644 arch/powerpc/boot/dts/p1020si.dtsi
 create mode 100644 arch/powerpc/boot/dts/p2020si.dtsi
 create mode 100644 arch/powerpc/boot/epapr.c
 rename arch/powerpc/{platforms/cell => include/asm}/io-workarounds.h (97%)
 create mode 100644 arch/powerpc/include/asm/io_event_irq.h
 create mode 100644 arch/powerpc/include/asm/reg_a2.h
 create mode 100644 arch/powerpc/include/asm/scom.h
 create mode 100644 arch/powerpc/include/asm/wsp.h
 create mode 100644 arch/powerpc/include/asm/xics.h
 create mode 100644 arch/powerpc/kernel/cpu_setup_a2.S
 create mode 100644 arch/powerpc/kernel/cpu_setup_power7.S
 create mode 100644 arch/powerpc/kernel/idle_power7.S
 rename arch/powerpc/{platforms/cell => kernel}/io-workarounds.c (95%)
 delete mode 100644 arch/powerpc/platforms/cell/beat_smp.c
 delete mode 100644 arch/powerpc/platforms/iseries/smp.h
 delete mode 100644 arch/powerpc/platforms/powermac/pic.h
 create mode 100644 arch/powerpc/platforms/pseries/io_event_irq.c
 delete mode 100644 arch/powerpc/platforms/pseries/xics.c
 delete mode 100644 arch/powerpc/platforms/pseries/xics.h
 create mode 100644 arch/powerpc/platforms/wsp/Kconfig
 create mode 100644 arch/powerpc/platforms/wsp/Makefile
 create mode 100644 arch/powerpc/platforms/wsp/ics.c
 create mode 100644 arch/powerpc/platforms/wsp/ics.h
 create mode 100644 arch/powerpc/platforms/wsp/opb_pic.c
 create mode 100644 arch/powerpc/platforms/wsp/psr2.c
 create mode 100644 arch/powerpc/platforms/wsp/scom_smp.c
 create mode 100644 arch/powerpc/platforms/wsp/scom_wsp.c
 create mode 100644 arch/powerpc/platforms/wsp/setup.c
 create mode 100644 arch/powerpc/platforms/wsp/smp.c
 create mode 100644 arch/powerpc/platforms/wsp/wsp.h
 create mode 100644 arch/powerpc/sysdev/scom.c
 create mode 100644 arch/powerpc/sysdev/xics/Kconfig
 create mode 100644 arch/powerpc/sysdev/xics/Makefile
 create mode 100644 arch/powerpc/sysdev/xics/icp-hv.c
 create mode 100644 arch/powerpc/sysdev/xics/icp-native.c
 create mode 100644 arch/powerpc/sysdev/xics/ics-rtas.c
 create mode 100644 arch/powerpc/sysdev/xics/xics-common.c
 create mode 100644 drivers/misc/carma/Kconfig
 create mode 100644 drivers/misc/carma/Makefile
 create mode 100644 drivers/misc/carma/carma-fpga-program.c
 create mode 100644 drivers/misc/carma/carma-fpga.c


