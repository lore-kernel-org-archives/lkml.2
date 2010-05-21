Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755240Ab0EUJMU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 May 2010 05:12:20 -0400
Received: from gate.crashing.org ([63.228.1.57]:46254 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754690Ab0EUJMN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 May 2010 05:12:13 -0400
Subject: [git pull] Please pull powerpc.git next branch
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linuxppc-dev list <linuxppc-dev@ozlabs.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 21 May 2010 19:11:28 +1000
Message-ID: <1274433088.1931.63.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus !

Here's the powerpc batch for this merge window.

Most of it is in arch/powerpc, a few powerpc specific drivers are hit
too, including removing one that has been unused (and unselectable in
Kconfig) for a long time (hdpuftrs), probably remains of a long dead
platform.

This time around, there's a lot of bits and pieces left and right, no
huge highlight. Some notable fixes to kexec/kdump that might make this
thing finally somewhat reliable from Mikey and Anton and a big cpumask
conversion from Anton as well.

Cheers,
Ben.

The following changes since commit 7a9b149212f3716c598afe973b6261fd58453b7a:
  Linus Torvalds (1):
        Merge git://git.kernel.org/.../gregkh/usb-2.6

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/benh/powerpc.git next

Akinobu Mita (1):
      powerpc/iseries/pci: Use __ratelimit

Andreas Schwab (1):
      powerpc: Fix string library functions

Anton Blanchard (25):
      powerpc/numa: Set a smaller value for RECLAIM_DISTANCE to enable zone reclaim
      powerpc/pseries: Call ibm,os-term if the ibm,extended-os-term is present
      powerpc/mm: Bump SECTION_SIZE_BITS from 16MB to 256MB
      powerpc/cpumask: Use cpu_online_mask
      powerpc/cpumask: Convert rtasd to new cpumask API
      powerpc/cpumask: Convert smp_cpus_done to new cpumask API
      powerpc/cpumask: Convert fixup_irqs to new cpumask API
      powerpc/cpumask: Convert iseries SMP code to new cpumask API
      powerpc/cpumask: Convert pseries SMP code to new cpumask API
      powerpc/cpumask: Convert xics driver to new cpumask API
      powerpc/cpumask: Refactor /proc/cpuinfo code
      powerpc/cpumask: Convert /proc/cpuinfo to new cpumask API
      powerpc/cpumask: Dynamically allocate cpu_sibling_map and cpu_core_map cpumasks
      powerpc/cpumask: Convert hotplug-cpu code to new cpumask API
      powerpc/cpumask: Convert NUMA code to new cpumask API
      powerpc/cpumask: Update some comments
      powerpc/cpumask: Add DEBUG_PER_CPU_MAPS option
      powerpc/eeh: Fix oops when probing in early boot
      powerpc/kdump: CPUs assume the context of the oopsing CPU
      powerpc/kdump: Use chip->shutdown to disable IRQs
      powerpc: Use more accurate limit for first segment memory allocations
      powerpc: Remove check of ibm,smt-snooze-delay OF property
      powerpc: Use smt_snooze_delay=-1 to always busy loop
      powerpc/numa: Set a smaller value for RECLAIM_DISTANCE to enable zone reclaim
      powerpc/numa: Use ibm,architecture-vec-5 to detect form 1 affinity

Anton Vorontsov (3):
      powerpc/85xx: Add eTSEC 2.0 support for P1020RDB boards
      powerpc/85xx: Fix P1020RDB boot hang due USB2
      powerpc/83xx: Add MCU LEDs support for MPC837xRDB and MPC8315RDB boards

Benjamin Herrenschmidt (9):
      Remove unused HDPU driver
      powerpc: Fix ioremap_flags() with book3e pte definition
      powerpc/vio: Add modalias support
      powerpc/vio: Add power management support
      Revert "powerpc/mm: Bump SECTION_SIZE_BITS from 16MB to 256MB"
      powerpc: Fix CONFIG_DEBUG_PAGEALLOC on 603/e300
      powerpc: Invoke oom-killer from page fault
      powerpc/cpumask: Convert mpic driver to new cpumask API
      Merge commit 'origin/master' into next

Brian King (1):
      powerpc/vio: Switch VIO Bus PM to use generic helpers

Corey Minyard (2):
      powerpc: Add a new zImage for maple using a different link address
      powerpc/mpsc: Set the port device in the mpsc serial driver

Dave Kleikamp (5):
      powerpc/44x: break out cpu init code into stand-alone function
      powerpc/47x: Base ppc476 support
      powerpc/476: add machine check handler for 47x core
      powerpc/476: Add isync after loading mmu and debug spr's
      powerpc/47x: defconfig for 476 on the iss 4xx simulator

FUJITA Tomonori (1):
      powerpc: Remove unused 'protect4gb' boot parameter

Jason Gunthorpe (1):
      powerpc/ppc32: Fixup pmd_page to work when ARCH_PFN_OFFSET is non-zero

Jeff Mahoney (1):
      powerpc: Fix handling of strncmp with zero len

Joakim Tjernlund (4):
      powerpc/8xx: Optimze TLB Miss handlers
      powerpc/8xx: Avoid testing for kernel space in ITLB Miss.
      powerpc/8xx: Don't touch ACCESSED when no SWAP.
      powerpc/8xx: Use SPRG2 and DAR registers to stash r11 and cr.

Julia Lawall (6):
      powerpc/pmac/windfarm: Correct potential double free
      powerpc/pseries/dlpar: Eliminate use after free
      powerpc/pseries/dlpar: Use kasprintf
      powerpc/vio: Add missing unlock in error path
      powerpc/pmac: Add missing unlocks in error path
      powerpc: Use set_cpus_allowed_ptr

K.Prasad (1):
      powerpc: Disable interrupts for data breakpoint exceptions

Kim Phillips (1):
      powerpc: remove tls_ssl_stream descriptor type capability in sec3.3 node

Kumar Gala (1):
      powerpc/fsl-booke: Move loadcam_entry back to asm code to fix SMP ftrace

Li Yang (1):
      powerpc/fsl-booke: Fix InstructionTLBError execute permission check

Mahesh Salgaonkar (1):
      powerpc: Add kprobe-based event tracer

Mark Nelson (2):
      powerpc/mm: Track backing pages allocated by vmemmap_populate()
      powerpc/pseries: Make request_ras_irqs() available to other pseries code

Martyn Welch (1):
      powerpc: Correct parport interrupt parsing

Maxim Uvarov (1):
      powerpc/crashdump: Do not fail on NULL pointer dereferencing

Michael Ellerman (1):
      powerpc/rtasd: Don't start event scan if scan rate is zero

Michael Neuling (7):
      powerpc/pseries: Make query_cpu_stopped callable outside hotplug cpu
      powerpc/pseries: Only call start-cpu when a CPU is stopped
      powerpc/pseries: Add hcall to read 4 ptes at a time in real mode
      powerpc/kexec: Speedup kexec hash PTE tear down
      powerpc/kexec: Fix race in kexec shutdown
      powerpc/kdump: Fix race in kdump shutdown
      powerpc: Build-in e1000e for pseries & ppc64_defconfig

Milton Miller (1):
      powerpc: Use common cpu_die (fixes SMP+SUSPEND build)

Paul Mackerras (1):
      powerpc: Avoid bad relocations in iSeries code

Peter Korsgaard (1):
      powerpc: Add interrupt support to mpc8xxx_gpio

Sonny Rao (1):
      powerpc/pci: Check devices status property when scanning OF tree

Stefan Roese (1):
      powerpc/4xx: Add optional "reset_type" property to control reboot via dts

Timur Tabi (1):
      powerpc/8610: add probing for individual DMA channels, not just DMA controllers

Torez Smith (2):
      powerpc/booke: Add Stack Marking support to Booke Exception Prolog
      powerpc/4xx: Simple platform for the ISS 4xx simulator

Vaidyanathan Srinivasan (1):
      powerpc/pseries: Export data from new hcall H_EM_GET_PARMS

Wolfram Sang (4):
      powerpc/pmac: Fix dangling pointers
      i2c/mpc: Drop NO_IRQ
      i2c/cpm: Drop NO_IRQ
      i2c/ibm-iic: Drop NO_IRQ

d binderman (3):
      powerpc/aoa: gpio-pmf.c: 3 * redundant code
      powerpc/pmac/low_i2c.c: three minor problems
      powerpc/pmac/windfarm: Don't test pointers before kfree()

 Documentation/powerpc/dts-bindings/4xx/reboot.txt  |   18 +
 .../powerpc/dts-bindings/fsl/8xxx_gpio.txt         |   22 +-
 arch/powerpc/Kconfig                               |    1 +
 arch/powerpc/Kconfig.debug                         |   12 +
 arch/powerpc/boot/Makefile                         |    9 +-
 arch/powerpc/boot/dts/iss4xx-mpic.dts              |  155 +++
 arch/powerpc/boot/dts/iss4xx.dts                   |  116 +++
 arch/powerpc/boot/dts/mpc8315erdb.dts              |   16 +-
 arch/powerpc/boot/dts/mpc8377_rdb.dts              |   14 +
 arch/powerpc/boot/dts/mpc8378_rdb.dts              |   14 +
 arch/powerpc/boot/dts/mpc8379_rdb.dts              |   14 +
 arch/powerpc/boot/dts/p1020rdb.dts                 |  125 +++
 arch/powerpc/boot/treeboot-iss4xx.c                |   56 ++
 arch/powerpc/boot/wrapper                          |    9 +-
 arch/powerpc/configs/44x/iss476-smp_defconfig      | 1026 ++++++++++++++++++++
 arch/powerpc/configs/ppc64_defconfig               |    2 +-
 arch/powerpc/configs/pseries_defconfig             |    2 +-
 arch/powerpc/include/asm/cache.h                   |    6 +-
 arch/powerpc/include/asm/cputable.h                |    5 +
 arch/powerpc/include/asm/hvcall.h                  |    2 +
 arch/powerpc/include/asm/kexec.h                   |    4 +
 arch/powerpc/include/asm/mmu-44x.h                 |   51 +-
 arch/powerpc/include/asm/mmu.h                     |    1 +
 arch/powerpc/include/asm/mmzone.h                  |    2 +-
 arch/powerpc/include/asm/mpic.h                    |    3 -
 arch/powerpc/include/asm/paca.h                    |    1 +
 arch/powerpc/include/asm/parport.h                 |   11 +-
 arch/powerpc/include/asm/pgalloc-64.h              |    6 +
 arch/powerpc/include/asm/pgtable-ppc32.h           |    2 +-
 arch/powerpc/include/asm/ptrace.h                  |   64 ++
 arch/powerpc/include/asm/reg.h                     |    4 +
 arch/powerpc/include/asm/reg_booke.h               |   24 +
 arch/powerpc/include/asm/smp.h                     |   18 +-
 arch/powerpc/include/asm/topology.h                |   26 +-
 arch/powerpc/kernel/asm-offsets.c                  |    9 +
 arch/powerpc/kernel/cputable.c                     |   29 +
 arch/powerpc/kernel/crash.c                        |   38 +-
 arch/powerpc/kernel/entry_32.S                     |    5 +
 arch/powerpc/kernel/exceptions-64s.S               |   13 +-
 arch/powerpc/kernel/head_44x.S                     |  828 +++++++++++++----
 arch/powerpc/kernel/head_8xx.S                     |   70 +-
 arch/powerpc/kernel/head_booke.h                   |    4 +
 arch/powerpc/kernel/head_fsl_booke.S               |   13 +-
 arch/powerpc/kernel/iommu.c                        |   12 -
 arch/powerpc/kernel/irq.c                          |   17 +-
 arch/powerpc/kernel/kprobes.c                      |    3 +
 arch/powerpc/kernel/lparcfg.c                      |   12 +-
 arch/powerpc/kernel/machine_kexec_64.c             |   48 +-
 arch/powerpc/kernel/misc_32.S                      |    9 +-
 arch/powerpc/kernel/misc_64.S                      |    8 +-
 arch/powerpc/kernel/paca.c                         |    2 +
 arch/powerpc/kernel/pci_of_scan.c                  |    2 +
 arch/powerpc/kernel/process.c                      |    3 +
 arch/powerpc/kernel/ptrace.c                       |  103 ++
 arch/powerpc/kernel/rtas.c                         |   15 +-
 arch/powerpc/kernel/rtasd.c                        |   16 +-
 arch/powerpc/kernel/setup-common.c                 |   86 +-
 arch/powerpc/kernel/setup_64.c                     |   23 +-
 arch/powerpc/kernel/smp.c                          |   73 +-
 arch/powerpc/kernel/sysfs.c                        |   46 +-
 arch/powerpc/kernel/traps.c                        |   40 +
 arch/powerpc/kernel/vio.c                          |   26 +-
 arch/powerpc/lib/string.S                          |   18 +-
 arch/powerpc/mm/44x_mmu.c                          |  144 +++-
 arch/powerpc/mm/fault.c                            |   19 +-
 arch/powerpc/mm/fsl_booke_mmu.c                    |   25 +-
 arch/powerpc/mm/init_64.c                          |   43 +
 arch/powerpc/mm/mmu_context_nohash.c               |    8 +
 arch/powerpc/mm/mmu_decl.h                         |   17 +-
 arch/powerpc/mm/numa.c                             |   78 ++-
 arch/powerpc/mm/pgtable_32.c                       |   12 +-
 arch/powerpc/mm/pgtable_64.c                       |    8 +
 arch/powerpc/mm/tlb_nohash_low.S                   |  146 +++-
 arch/powerpc/platforms/44x/Kconfig                 |   20 +
 arch/powerpc/platforms/44x/Makefile                |    1 +
 arch/powerpc/platforms/44x/iss4xx.c                |  167 ++++
 arch/powerpc/platforms/83xx/mpc831x_rdb.c          |    1 +
 arch/powerpc/platforms/83xx/mpc837x_rdb.c          |    1 +
 arch/powerpc/platforms/86xx/mpc8610_hpcd.c         |    3 +-
 arch/powerpc/platforms/Kconfig.cputype             |    5 +-
 arch/powerpc/platforms/cell/cbe_cpufreq.c          |    2 +-
 arch/powerpc/platforms/iseries/exception.S         |    4 +-
 arch/powerpc/platforms/iseries/pci.c               |   10 +-
 arch/powerpc/platforms/iseries/smp.c               |    2 +-
 arch/powerpc/platforms/pasemi/cpufreq.c            |    2 +-
 arch/powerpc/platforms/powermac/cpufreq_64.c       |    2 +-
 arch/powerpc/platforms/powermac/low_i2c.c          |    7 +-
 arch/powerpc/platforms/powermac/pmac.h             |    2 +
 arch/powerpc/platforms/powermac/setup.c            |   13 +-
 arch/powerpc/platforms/powermac/smp.c              |    9 +-
 arch/powerpc/platforms/pseries/Makefile            |    2 +-
 arch/powerpc/platforms/pseries/dlpar.c             |    8 +-
 arch/powerpc/platforms/pseries/eeh.c               |    2 +-
 arch/powerpc/platforms/pseries/event_sources.c     |   79 ++
 arch/powerpc/platforms/pseries/hotplug-cpu.c       |   67 +-
 arch/powerpc/platforms/pseries/hvCall.S            |   38 +
 arch/powerpc/platforms/pseries/lpar.c              |   35 +-
 arch/powerpc/platforms/pseries/plpar_wrappers.h    |   26 +
 arch/powerpc/platforms/pseries/pseries.h           |    7 +
 arch/powerpc/platforms/pseries/ras.c               |   62 +--
 arch/powerpc/platforms/pseries/setup.c             |   10 +-
 arch/powerpc/platforms/pseries/smp.c               |   42 +-
 arch/powerpc/platforms/pseries/xics.c              |   38 +-
 arch/powerpc/sysdev/mpc8xxx_gpio.c                 |  147 +++
 arch/powerpc/sysdev/mpic.c                         |   72 +-
 arch/powerpc/sysdev/ppc4xx_soc.c                   |   24 +-
 drivers/i2c/busses/i2c-cpm.c                       |    2 +-
 drivers/i2c/busses/i2c-ibm_iic.c                   |   14 +-
 drivers/i2c/busses/i2c-mpc.c                       |    6 +-
 drivers/macintosh/macio-adb.c                      |    1 +
 drivers/macintosh/smu.c                            |    4 +-
 drivers/macintosh/therm_adt746x.c                  |    2 +
 drivers/macintosh/windfarm_pm81.c                  |    6 +-
 drivers/macintosh/windfarm_pm91.c                  |    9 +-
 drivers/misc/Makefile                              |    1 -
 drivers/misc/hdpuftrs/Makefile                     |    1 -
 drivers/misc/hdpuftrs/hdpu_cpustate.c              |  256 -----
 drivers/misc/hdpuftrs/hdpu_nexus.c                 |  149 ---
 drivers/serial/mpsc.c                              |    1 +
 include/linux/hdpu_features.h                      |   26 -
 sound/aoa/core/gpio-pmf.c                          |    9 +-
 121 files changed, 4157 insertions(+), 1152 deletions(-)
 create mode 100644 Documentation/powerpc/dts-bindings/4xx/reboot.txt
 create mode 100644 arch/powerpc/boot/dts/iss4xx-mpic.dts
 create mode 100644 arch/powerpc/boot/dts/iss4xx.dts
 create mode 100644 arch/powerpc/boot/treeboot-iss4xx.c
 create mode 100644 arch/powerpc/configs/44x/iss476-smp_defconfig
 create mode 100644 arch/powerpc/platforms/44x/iss4xx.c
 create mode 100644 arch/powerpc/platforms/pseries/event_sources.c
 delete mode 100644 drivers/misc/hdpuftrs/Makefile
 delete mode 100644 drivers/misc/hdpuftrs/hdpu_cpustate.c
 delete mode 100644 drivers/misc/hdpuftrs/hdpu_nexus.c
 delete mode 100644 include/linux/hdpu_features.h


