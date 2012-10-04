Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965568Ab2JDIiw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 04:38:52 -0400
Received: from gate.crashing.org ([63.228.1.57]:46988 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755477Ab2JDIij (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 04:38:39 -0400
Message-ID: <1349339900.4260.10.camel@pasglop>
Subject: [git pull] Please pull powerpc.git merge branch
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linuxppc-dev list <linuxppc-dev@ozlabs.org>,
        Linux Kernel list <linux-kernel@vger.kernel.org>
Date: Thu, 04 Oct 2012 18:38:20 +1000
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus !

A couple of days late on my expectations due to chasing a nasty regression,
and here is the powerpc batch for 3.7.

First, however, a note about the pull request details ... the diffstat looks
completely on crack, any idea what's up ? It sees piles of files modified
in various other archs & generic code but I see no patch in that branch
that touches any of them.

Example:

 arch/alpha/Kconfig                                 |    2 +

But if I do:

git log linus/master..next arch/alpha/Kconfig

I get (as expected) and empty output.

It could be an artifact of me including a branch from Bjorn with some PCI
work on which I had a dependency and which you already merged earlier that
is confusing git request-pull, not sure, I don't have time to investigate that now :-)

Now some highlights in addition to the usual batch of fixes:

 - 64TB address space support for 64-bit processes by Aneesh Kumar

 - Gavin Shan did a major cleanup & re-organization of our EEH support code
(IBM fancy PCI error handling & recovery infrastructure) which paves the way
for supporting different platform backends, along with some rework of the
PCIe code for the PowerNV platform in order to remove home made resource
allocations and instead use the generic code (which is possible after some
small improvements to it done by Gavin).

 - Uprobes support by Ananth N Mavinakayanahalli 

 - A pile of embedded updates from Freescale folks, including new SoC and
board supports, more KVM stuff including preparing for 64-bit BookE KVM
support, ePAPR 1.1 updates, etc...

Cheers,
Ben.

The following changes since commit 271fd03a3013b106ccc178d54219c1be0c9759b7:

  powerpc/powernv: I/O and memory alignment for P2P bridges (2012-09-11 16:59:47 -0600)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/benh/powerpc.git 

for you to fetch changes up to d900bd7366463fd96a907b2c212242e2b68b27d8:

  powerpc/iommu: Fix multiple issues with IOMMU pools code (2012-10-04 18:03:20 +1000)

----------------------------------------------------------------
Alexey Kardashevskiy (1):
      powerpc/iommu: Add ppc_md.tce_get() callback for use by VFIO

Ananth N Mavinakayanahalli (4):
      powerpc: Consolidate {k,u}probe definitions
      powerpc: Add trap_nr to thread_struct
      powerpc: Uprobes port to powerpc
      powerpc/kprobes: Rename opcode_t in probes.h to ppc_opcode_t

Anatolij Gustschin (3):
      powerpc/mpc5200: add dts files for ifm camera machines
      dt/misc: add bindings documentation for ifm camera sensor interface
      powerpc/mpc52xx_lpbfifo: optionally defer fifo transfer start

Aneesh Kumar K.V (12):
      powerpc/mm: Replace open coded CONTEXT_BITS value
      powerpc/mm: Use hpt_va to compute virtual address
      powerpc/mm: Simplify hpte_decode
      powerpc/mm: Convert virtual address to vpn
      powerpc/mm: Make KERN_VIRT_SIZE not dependend on PGTABLE_RANGE
      powerpc/mm: Increase the slice range to 64TB
      powerpc/mm: Use the required number of VSID bits in slbmte
      powerpc/mm: Use 32bit array for slb cache
      powerpc/mm: Add 64TB support
      powerpc/mm: Update VSID allocation documentation
      powerpc/mm: Make some of the PGTABLE_RANGE dependency explicit
      powerpc/eeh: Don't release eeh_mutex in eeh_phb_pe_get

Anton Blanchard (2):
      powerpc/pseries: Round up MSI-X requests
      powerpc/iommu: Fix multiple issues with IOMMU pools code

Benjamin Herrenschmidt (7):
      hvc_console: Better kernel console support
      hvc_vio: Improve registration of udbg backend
      Merge branch 'merge' into next
      Merge remote-tracking branch 'pci/pci/gavin-window-alignment' into next
      Merge remote-tracking branch 'kumar/next' into next
      Merge remote-tracking branch 'agust/next' into next
      Merge remote-tracking branch 'kumar/next' into next

Bharat Bhushan (1):
      powerpc: Remove unused __get_user64() and __put_user64()

Bjorn Helgaas (1):
      Merge commit 'v3.6-rc5' into pci/gavin-window-alignment

Carl E. Love (1):
      powerpc/oprofile: Fix marked events support on Power7+ not set.

Chunhe Lan (1):
      powerpc/85xx: Enable USB support in p1023rds_defconfig

Gavin Shan (36):
      powerpc/pci: Save P2P bridge resource if possible
      powerpc/eeh: Move EEH initialization around
      powerpc/eeh: Use slab to allocate eeh devices
      powerpc/eeh: More logs for EEH initialization
      powerpc/eeh: Introduce eeh_pe struct
      powerpc/eeh: Introduce global mutex
      powerpc/eeh: Create PEs for PHBs
      powerpc/eeh: Search PE based on requirement
      powerpc/eeh: Create PEs duing EEH initialization
      powerpc/eeh: Remove PE at appropriate time
      powerpc/eeh: Build EEH event based on PE
      powerpc/eeh: Trace EEH state based on PE
      powerpc/eeh: Trace error based on PE from beginning
      powerpc/eeh: Make EEH operations based on PE
      powerpc/eeh: Device bars restore based on PE
      powerpc/eeh: I/O enable and log retrival based on PE
      powerpc/eeh: Do reset based on PE
      powerpc/eeh: Make EEH handler PE sensitive
      powerpc/eeh: Handle EEH error based on PE
      powerpc/eeh: Move stats to PE
      powerpc/eeh: Probe mode support
      powerpc/eeh: Trace eeh device from I/O cache
      powerpc/eeh: Cleanup on EEH PCI address cache
      powerpc/powernv: Create bus sensitive PEs
      powerpc/powernv: PE list based on creation order
      powerpc/powernv: I/O and MMIO resource assignment for PEs
      powerpc/powernv: Initialize DMA for PEs
      powerpc/powernv: Skip check on PE if necessary
      powerpc/powernv: Fix overrunning segment tracing array
      powerpc/powernv: Using PCI core to do resource assignment
      powerpc/powernv: Remove unused functions
      powerpc/eeh: Introduce EEH_PE_INVALID type PE
      powerpc/eeh: Remove EEH PE for normal PCI hotplug
      powerpc/eeh: Global mutex to protect PE tree
      powerpc/eeh: Lock module while handling EEH event
      powerpc/eeh: Fix crash on converting OF node to edev

Jia Hongtao (4):
      powerpc/swiotlb: Enable at early stage and disable if not necessary
      powerpc: add adt7461 thermal monitor support to applicable boards
      powerpc/fsl-pci: Unify pci/pcie initialization code
      powerpc/fsl-pci: fix warning when CONFIG_SWIOTLB is disabled

Joe MacDonald (1):
      powerpc/mm: Match variable types to API

Kim Phillips (1):
      powerpc/85xx: add Freescale P5040 SOC and SEC v5.2 device trees

Li Zhong (1):
      powerpc/trace: Fix interrupt tracepoints vs. RCU

Matthew McClintock (1):
      powerpc: Fix build dependencies for c files requiring libfdt.h

Michael Ellerman (23):
      powerpc: Remove remaining iSeries chunks
      powerpc/crypto: Remove users of virt_to_abs() and phys_to_abs() in nx crypto driver
      IB/ehca: Don't use phys_to_abs(), it's a nop
      powerpc/mm: Replace abs_to_virt() with __va()
      powerpc/pasemi: Remove uses of virt_to_abs() and abs_to_virt()
      powerpc/dart: Remove uses of virt_to_abs() and abs_to_virt()
      IB/ehca: Remove uses of virt_to_abs() and abs_to_virt()
      drivers/macintosh/smu.c: Replace abs_to_virt() with __va()
      ehea: Remove uses of virt_to_abs() and abs_to_virt()
      powerpc/kernel: Remove uses of abs_to_virt() and virt_to_abs()
      powerpc/pseries: Remove uses of abs_to_virt() and virt_to_abs()
      powerpc/mm: Remove uses of abs_to_virt() and virt_to_abs()
      powerpc/ps3: Replace virt_to_abs() with __pa()
      powerpc: Remove phys_to_abs() now all users have been removed
      powerpc: Remove abs_to_virt() now all users have been fixed
      powerpc: Remove virt_to_abs() now all users have been fixed
      powerpc: Remove all includes of <asm/abs_addr.h>
      powerpc: Remove <asm/abs_addr.h>
      powerpc: Rename 64-bit PVR constants to PVR_foo
      powerpc: Initialise paca.data_offset with poison
      powerpc: Add an xmon command to dump one or all pacas
      powerpc: Set paca->data_offset = 0 for boot cpu
      powerpc: Remove tlb batching hack for nighthawk

Michael Neuling (7):
      powerpc: Pack arch_hw_breakpoint to avoid holes in struct
      powerpc: Use consistent name info for arch_hw_breakpoint
      powerpc: Use the XDABR hcall
      powerpc: Rework set_dabr so it can take a DABRX value as well
      powerpc: Dynamically calculate the dabrx based on kernel/user/hypervisor
      powerpc: cleanup old DABRX #defines
      powerpc: Add denormalisation exception handling for POWER6/7

Mihai Caraman (6):
      powerpc/booke64: Fix machine check handler to use the right prolog
      powerpc/booke64: Use GSRR registers in Guest Doorbell interrupts
      powerpc/booke64: Add DO_KVM kernel hooks
      powerpc/booke64: Eemove mfspr srr1 duplicate in exception prolog
      powerpc/booke64: Use SPRG0/3 scratch for bolted TLB miss & crit int
      powerpc: Restore VDSO information on critical exception om BookE

Minghuan Lian (1):
      powerpc/fsl-pci: use 'Header Type' to identify PCIE mode

Nishanth Aravamudan (1):
      powerpc: Fix VMX fix for memcpy case

Olivia Yin (3):
      powerpc/e500v2: Add Power ISA properties to comply with ePAPR 1.1
      powerpc/e500mc: Add Power ISA properties to comply with ePAPR 1.1
      powerpc/e5500: Add Power ISA properties to comply with ePAPR 1.1

Paul Gortmaker (1):
      powerpc: Option FB_FSL_DIU is not really optional for mpc512x

Prabhakar Kushwaha (4):
      powerpc: Update Integrated Flash controller device tree bindings
      powerpc/mpc85xx: Add new ext fields to Integrated FLash Controller
      powerpc/mpc85xx: Update interrupt handling for IFC controller
      driver/mtd:IFC NAND:Initialise internal SRAM before any write

Richard Weinberger (1):
      powerpc: 512x: Fix mpc5121_clk_get()

Roy Zang (2):
      powerpc/pci: Add IP revision register define for Freescale PCIe controller
      powerpc/pci: Use PCIe IP block revision register instead of compatible

Scott Wood (1):
      powerpc/mm: Fix typo in PTRS_PER_PUD

Shaohui Xie (1):
      powerpc/p5040: fix dtb build warning of p5040ds.dtb

Suzuki Poulose (2):
      powerpc: Change memory_limit from phys_addr_t to unsigned long long
      powerpc: Export memory limit via device tree

Tang Yuantian (1):
      powerpc/85xx: L2sram - Add compatible string to the device id list

Tiejun Chen (3):
      powerpc/kprobe: Introduce a new thread flag
      powerpc/kprobe: Complete kprobe and migrate exception frame
      powerpc/kprobe: Don't emulate store when kprobe stwu r1

Timur Tabi (4):
      powerpc/85xx: remove P1020RDB and P2020RDB CAMP device trees
      powerpc/fsl-pci: add fsl,qoriq-pcie-v2.4 compatible string
      powerpc/85xx: Add support for P5040DS board
      powerpc/85xx: introduce support for the Freescale / iVeia P1022RDK

Varun Sethi (6):
      powerpc/mpic: finish supporting timer group B on Freescale chips
      powepc/booke: Separate out E.HV check and ivor setup code.
      powerpc/booke: Merge the 32 bit e5500/e500mc cpu setup code.
      powerpc/booke: Separate out restore_e5500/setup_e5500 routines.
      powerpc/booke: Add CPU_FTR_EMB_HV check for e5500.
      powerpc/mpic: FSL MPIC error interrupt support.

Wang Dongsheng (1):
      powerpc/8544ds: add partition table for norflash

Zhao Chenhui (5):
      powerpc/85xx: Replace epapr spin table macros/defines with a struct
      powerpc/smp: add generic_set_cpu_up() to set cpu_state as CPU_UP_PREPARE
      powerpc/85xx: implement hardware timebase sync
      powerpc/85xx: add HOTPLUG_CPU support
      powerpc/smp: Do not disable IPI interrupts during suspend

sukadev@linux.vnet.ibm.com (2):
      powerpc: Define Power7+ PV constant PV_POWER7p
      powerpc/perf: Sample only if SIAR-Valid bit is set in P7+

 Documentation/ABI/testing/sysfs-bus-pci            |   12 +
 .../ABI/testing/sysfs-platform-ideapad-laptop      |   11 +
 Documentation/DocBook/filesystems.tmpl             |    4 +-
 Documentation/DocBook/media/v4l/vidioc-g-tuner.xml |    2 +-
 Documentation/block/00-INDEX                       |   10 +-
 Documentation/block/cfq-iosched.txt                |   77 +
 Documentation/block/queue-sysfs.txt                |   64 +
 Documentation/devicetree/bindings/misc/ifm-csi.txt |   41 +
 .../devicetree/bindings/mmc/fsl-imx-esdhc.txt      |    8 +-
 .../devicetree/bindings/powerpc/fsl/ifc.txt        |    9 +-
 .../devicetree/bindings/regulator/tps6586x.txt     |   12 +-
 Documentation/feature-removal-schedule.txt         |    2 +-
 Documentation/filesystems/Locking                  |    2 -
 Documentation/filesystems/porting                  |    5 +-
 Documentation/filesystems/vfat.txt                 |   11 +
 Documentation/filesystems/vfs.txt                  |    4 -
 Documentation/laptops/laptop-mode.txt              |   12 +-
 Documentation/networking/netconsole.txt            |   19 +-
 Documentation/pinctrl.txt                          |    6 +-
 Documentation/security/Yama.txt                    |   14 +-
 Documentation/sysctl/vm.txt                        |   14 +-
 Documentation/vm/hugetlbpage.txt                   |   10 +-
 Documentation/w1/slaves/w1_therm                   |    2 +
 Documentation/watchdog/src/watchdog-test.c         |    2 +-
 MAINTAINERS                                        |   70 +-
 Makefile                                           |    2 +-
 arch/alpha/Kconfig                                 |    2 +
 arch/alpha/include/asm/atomic.h                    |    4 +-
 arch/alpha/include/asm/fpu.h                       |    2 +
 arch/alpha/include/asm/ptrace.h                    |    5 +-
 arch/alpha/include/asm/socket.h                    |    2 +
 arch/alpha/include/asm/uaccess.h                   |   34 +-
 arch/alpha/include/asm/unistd.h                    |    4 +-
 arch/alpha/include/asm/word-at-a-time.h            |   55 +
 arch/alpha/kernel/alpha_ksyms.c                    |    3 -
 arch/alpha/kernel/entry.S                          |  161 --
 arch/alpha/kernel/osf_sys.c                        |   49 +
 arch/alpha/kernel/process.c                        |   19 +
 arch/alpha/kernel/systbls.S                        |    4 +-
 arch/alpha/lib/Makefile                            |    2 -
 arch/alpha/lib/ev6-strncpy_from_user.S             |  424 -----
 arch/alpha/lib/ev67-strlen_user.S                  |  107 --
 arch/alpha/lib/strlen_user.S                       |   91 --
 arch/alpha/lib/strncpy_from_user.S                 |  339 ----
 arch/alpha/mm/fault.c                              |   36 +-
 arch/alpha/oprofile/common.c                       |    1 +
 arch/arm/Kconfig                                   |    9 +-
 arch/arm/boot/dts/am33xx.dtsi                      |    5 +
 arch/arm/boot/dts/at91sam9g25ek.dts                |    2 +-
 arch/arm/boot/dts/imx23.dtsi                       |   52 +-
 arch/arm/boot/dts/imx27-3ds.dts                    |    2 +-
 arch/arm/boot/dts/imx27.dtsi                       |    6 +
 arch/arm/boot/dts/imx28.dtsi                       |   74 +-
 arch/arm/boot/dts/imx51-babbage.dts                |    6 +-
 arch/arm/boot/dts/imx51.dtsi                       |    4 +
 arch/arm/boot/dts/imx53-ard.dts                    |   22 +-
 arch/arm/boot/dts/imx53.dtsi                       |    7 +
 arch/arm/boot/dts/imx6q-sabrelite.dts              |    1 +
 arch/arm/boot/dts/imx6q.dtsi                       |    7 +
 arch/arm/boot/dts/kirkwood-iconnect.dts            |    6 +-
 arch/arm/boot/dts/twl6030.dtsi                     |    3 +
 arch/arm/configs/armadillo800eva_defconfig         |    2 +-
 arch/arm/configs/imx_v6_v7_defconfig               |    1 +
 arch/arm/configs/mxs_defconfig                     |    1 -
 arch/arm/configs/tct_hammer_defconfig              |    2 +-
 arch/arm/configs/u8500_defconfig                   |    1 +
 arch/arm/include/asm/dma-mapping.h                 |    7 +
 arch/arm/include/asm/pgtable.h                     |   40 +-
 arch/arm/include/asm/sched_clock.h                 |    2 +
 arch/arm/kernel/sched_clock.c                      |   24 +
 arch/arm/kernel/topology.c                         |    2 +-
 arch/arm/lib/Makefile                              |   23 +-
 arch/arm/lib/io-readsw-armv3.S                     |  106 ++
 arch/arm/lib/io-writesw-armv3.S                    |  126 ++
 arch/arm/lib/uaccess.S                             |  564 +++++++
 arch/arm/mach-at91/at91rm9200_time.c               |    2 +-
 arch/arm/mach-at91/at91sam9260_devices.c           |    6 +-
 arch/arm/mach-at91/at91sam9261_devices.c           |    6 +-
 arch/arm/mach-at91/at91sam9263_devices.c           |   10 +-
 arch/arm/mach-at91/at91sam9g45_devices.c           |    6 +-
 arch/arm/mach-at91/at91sam9rl_devices.c            |    6 +-
 arch/arm/mach-at91/clock.c                         |   12 +
 arch/arm/mach-davinci/board-neuros-osd2.c          |   39 -
 arch/arm/mach-dove/common.c                        |    3 +-
 arch/arm/mach-exynos/mach-origen.c                 |    7 +
 arch/arm/mach-exynos/mach-smdkv310.c               |    7 +
 arch/arm/mach-exynos/pm_domains.c                  |    2 +-
 arch/arm/mach-gemini/irq.c                         |    1 +
 arch/arm/mach-imx/Makefile                         |   10 +-
 arch/arm/mach-imx/clk-imx27.c                      |    8 +-
 arch/arm/mach-imx/clk-imx31.c                      |    2 +-
 arch/arm/mach-imx/clk-imx51-imx53.c                |    1 +
 arch/arm/mach-imx/clk-imx6q.c                      |    8 +-
 arch/arm/mach-imx/{head-v7.S => headsmp.S}         |    0
 arch/arm/mach-imx/hotplug.c                        |   23 +-
 arch/arm/mach-imx/mach-imx6q.c                     |    4 +-
 arch/arm/mach-integrator/core.c                    |    1 +
 arch/arm/mach-integrator/integrator_ap.c           |    2 +-
 arch/arm/mach-kirkwood/Makefile.boot               |    7 +-
 arch/arm/mach-kirkwood/common.c                    |   11 +-
 arch/arm/mach-kirkwood/db88f6281-bp-setup.c        |    1 +
 arch/arm/mach-mmp/sram.c                           |    2 +-
 arch/arm/mach-mv78xx0/addr-map.c                   |    2 +-
 arch/arm/mach-mv78xx0/common.c                     |    6 +-
 arch/arm/mach-mxs/Kconfig                          |    6 -
 arch/arm/mach-mxs/Makefile                         |    3 +-
 arch/arm/mach-omap2/Kconfig                        |    3 +-
 arch/arm/mach-omap2/board-igep0020.c               |    2 +
 arch/arm/mach-omap2/board-omap3evm.c               |    1 +
 arch/arm/mach-omap2/common-board-devices.c         |   11 -
 arch/arm/mach-omap2/common-board-devices.h         |    1 -
 arch/arm/mach-omap2/cpuidle44xx.c                  |    3 +-
 arch/arm/mach-omap2/mux.h                          |    1 -
 arch/arm/mach-omap2/opp4xxx_data.c                 |    2 +-
 arch/arm/mach-omap2/pm34xx.c                       |   19 +-
 arch/arm/mach-omap2/sleep44xx.S                    |    8 +-
 arch/arm/mach-omap2/twl-common.c                   |    1 +
 arch/arm/mach-orion5x/common.c                     |    3 +-
 arch/arm/mach-pxa/raumfeld.c                       |    2 +-
 arch/arm/mach-s3c24xx/Kconfig                      |    4 +-
 arch/arm/mach-s3c24xx/include/mach/dma.h           |    3 +-
 arch/arm/mach-sa1100/leds-hackkit.c                |    1 +
 arch/arm/mach-shmobile/board-armadillo800eva.c     |   13 +-
 arch/arm/mach-shmobile/board-mackerel.c            |    3 +-
 arch/arm/mach-shmobile/board-marzen.c              |    2 +-
 arch/arm/mach-shmobile/intc-sh73a0.c               |    4 +-
 arch/arm/mach-tegra/board-harmony-power.c          |   32 +-
 arch/arm/mach-ux500/Kconfig                        |    1 -
 arch/arm/mach-ux500/board-mop500-msp.c             |   10 +-
 arch/arm/mach-ux500/board-mop500.c                 |    4 +
 arch/arm/mm/dma-mapping.c                          |  126 +-
 arch/arm/mm/flush.c                                |    2 -
 arch/arm/mm/tlb-v7.S                               |    6 +-
 arch/arm/plat-omap/dmtimer.c                       |    6 +-
 arch/arm/plat-omap/include/plat/cpu.h              |    3 +-
 arch/arm/plat-omap/include/plat/multi.h            |    9 +
 arch/arm/plat-omap/include/plat/uncompress.h       |    4 +-
 arch/arm/plat-orion/common.c                       |    8 +-
 arch/arm/plat-orion/include/plat/common.h          |    6 +-
 arch/arm/plat-s3c24xx/dma.c                        |    2 +-
 arch/arm/plat-samsung/Kconfig                      |    3 +-
 arch/arm/plat-samsung/devs.c                       |   29 +-
 arch/arm/plat-samsung/include/plat/hdmi.h          |   16 +
 arch/arm/plat-samsung/pm.c                         |    2 +-
 arch/arm/vfp/vfpmodule.c                           |    2 +
 arch/blackfin/kernel/setup.c                       |    1 -
 arch/c6x/Kconfig                                   |    1 +
 arch/c6x/include/asm/cache.h                       |   16 +-
 arch/ia64/configs/generic_defconfig                |    1 -
 arch/ia64/configs/gensparse_defconfig              |    1 -
 arch/ia64/kernel/acpi.c                            |    5 +-
 arch/m68k/Kconfig                                  |   13 +-
 arch/m68k/Kconfig.cpu                              |   19 +-
 arch/m68k/apollo/config.c                          |   16 +-
 arch/m68k/include/asm/Kbuild                       |   25 +
 arch/m68k/include/asm/MC68332.h                    |  152 --
 arch/m68k/include/asm/apollodma.h                  |  248 ---
 arch/m68k/include/asm/apollohw.h                   |    2 +-
 arch/m68k/include/asm/bitsperlong.h                |    1 -
 arch/m68k/include/asm/cputime.h                    |    6 -
 arch/m68k/include/asm/delay.h                      |    2 +-
 arch/m68k/include/asm/device.h                     |    7 -
 arch/m68k/include/asm/emergency-restart.h          |    6 -
 arch/m68k/include/asm/errno.h                      |    6 -
 arch/m68k/include/asm/futex.h                      |    6 -
 arch/m68k/include/asm/ioctl.h                      |    1 -
 arch/m68k/include/asm/ipcbuf.h                     |    1 -
 arch/m68k/include/asm/irq_regs.h                   |    1 -
 arch/m68k/include/asm/kdebug.h                     |    1 -
 arch/m68k/include/asm/kmap_types.h                 |    6 -
 arch/m68k/include/asm/kvm_para.h                   |    1 -
 arch/m68k/include/asm/local.h                      |    6 -
 arch/m68k/include/asm/local64.h                    |    1 -
 arch/m68k/include/asm/mac_mouse.h                  |   23 -
 arch/m68k/include/asm/mcfmbus.h                    |   77 -
 arch/m68k/include/asm/mman.h                       |    1 -
 arch/m68k/include/asm/mutex.h                      |    9 -
 arch/m68k/include/asm/percpu.h                     |    6 -
 arch/m68k/include/asm/resource.h                   |    6 -
 arch/m68k/include/asm/sbus.h                       |   45 -
 arch/m68k/include/asm/scatterlist.h                |    6 -
 arch/m68k/include/asm/sections.h                   |    8 -
 arch/m68k/include/asm/shm.h                        |   31 -
 arch/m68k/include/asm/siginfo.h                    |    6 -
 arch/m68k/include/asm/statfs.h                     |    6 -
 arch/m68k/include/asm/topology.h                   |    6 -
 arch/m68k/include/asm/types.h                      |   22 -
 arch/m68k/include/asm/unaligned.h                  |    4 +-
 arch/m68k/include/asm/xor.h                        |    1 -
 arch/m68k/kernel/setup_no.c                        |   11 +-
 arch/m68k/kernel/sys_m68k.c                        |    8 +-
 arch/m68k/kernel/vmlinux-nommu.lds                 |    2 -
 arch/m68k/kernel/vmlinux-std.lds                   |    2 -
 arch/m68k/kernel/vmlinux-sun3.lds                  |    2 -
 arch/m68k/lib/muldi3.c                             |    2 +-
 arch/m68k/mm/init_mm.c                             |    2 +-
 arch/m68k/mm/init_no.c                             |    2 +-
 arch/m68k/platform/68328/head-de2.S                |    8 +-
 arch/m68k/platform/68328/head-pilot.S              |   10 +-
 arch/m68k/platform/68328/head-ram.S                |    4 +-
 arch/m68k/platform/68328/head-rom.S                |    6 +-
 arch/m68k/platform/68360/head-ram.S                |    6 +-
 arch/m68k/platform/68360/head-rom.S                |    8 +-
 arch/m68k/platform/coldfire/head.S                 |   10 +-
 arch/m68k/sun3/prom/init.c                         |   48 +-
 arch/microblaze/include/asm/sections.h             |    4 -
 arch/microblaze/kernel/microblaze_ksyms.c          |    3 -
 arch/microblaze/kernel/setup.c                     |    4 +-
 arch/microblaze/kernel/vmlinux.lds.S               |    1 -
 arch/mips/Kconfig                                  |    1 +
 arch/mips/alchemy/board-mtx1.c                     |    2 +
 arch/mips/ath79/dev-usb.c                          |    2 +
 arch/mips/ath79/gpio.c                             |    6 +-
 arch/mips/bcm63xx/dev-spi.c                        |    4 +
 arch/mips/cavium-octeon/octeon-irq.c               |   89 +-
 arch/mips/include/asm/mach-ath79/ar71xx_regs.h     |    3 +-
 .../include/asm/mach-ath79/cpu-feature-overrides.h |    1 -
 .../include/asm/mach-bcm63xx/bcm63xx_dev_spi.h     |    2 +
 arch/mips/include/asm/mach-bcm63xx/bcm63xx_regs.h  |   13 +-
 arch/mips/include/asm/mach-cavium-octeon/irq.h     |   10 +-
 arch/mips/include/asm/module.h                     |    1 +
 arch/mips/include/asm/r4k-timer.h                  |    8 +-
 arch/mips/kernel/module.c                          |   43 +-
 arch/mips/kernel/smp.c                             |    4 +-
 arch/mips/kernel/sync-r4k.c                        |   26 +-
 arch/mips/mti-malta/malta-pci.c                    |   13 -
 arch/mips/pci/pci-ar724x.c                         |   22 +
 arch/parisc/include/asm/atomic.h                   |    4 +-
 arch/parisc/kernel/process.c                       |    2 +-
 arch/parisc/kernel/sys_parisc.c                    |    8 +-
 arch/powerpc/Kconfig                               |   17 +-
 arch/powerpc/boot/Makefile                         |    1 +
 arch/powerpc/boot/dts/fsl/e500mc_power_isa.dtsi    |   58 +
 arch/powerpc/boot/dts/fsl/e500v2_power_isa.dtsi    |   52 +
 arch/powerpc/boot/dts/fsl/e5500_power_isa.dtsi     |   59 +
 arch/powerpc/boot/dts/fsl/mpc8536si-pre.dtsi       |    3 +
 arch/powerpc/boot/dts/fsl/mpc8544si-pre.dtsi       |    3 +
 arch/powerpc/boot/dts/fsl/mpc8548si-pre.dtsi       |    3 +
 arch/powerpc/boot/dts/fsl/mpc8568si-pre.dtsi       |    3 +
 arch/powerpc/boot/dts/fsl/mpc8569si-pre.dtsi       |    3 +
 arch/powerpc/boot/dts/fsl/mpc8572si-pre.dtsi       |    3 +
 arch/powerpc/boot/dts/fsl/p1010si-pre.dtsi         |    3 +
 arch/powerpc/boot/dts/fsl/p1020si-pre.dtsi         |    3 +
 arch/powerpc/boot/dts/fsl/p1021si-pre.dtsi         |    3 +
 arch/powerpc/boot/dts/fsl/p1022si-pre.dtsi         |    3 +
 arch/powerpc/boot/dts/fsl/p1023si-pre.dtsi         |    3 +
 arch/powerpc/boot/dts/fsl/p2020si-pre.dtsi         |    3 +
 arch/powerpc/boot/dts/fsl/p2041si-pre.dtsi         |    3 +
 arch/powerpc/boot/dts/fsl/p3041si-pre.dtsi         |    3 +
 arch/powerpc/boot/dts/fsl/p4080si-post.dtsi        |    7 +
 arch/powerpc/boot/dts/fsl/p4080si-pre.dtsi         |    3 +
 arch/powerpc/boot/dts/fsl/p5020si-pre.dtsi         |    3 +
 arch/powerpc/boot/dts/fsl/p5040si-post.dtsi        |  320 ++++
 arch/powerpc/boot/dts/fsl/p5040si-pre.dtsi         |  114 ++
 arch/powerpc/boot/dts/fsl/qoriq-sec5.2-0.dtsi      |  118 ++
 arch/powerpc/boot/dts/mpc8536ds.dtsi               |    4 +
 arch/powerpc/boot/dts/mpc8540ads.dts               |    2 +
 arch/powerpc/boot/dts/mpc8541cds.dts               |    2 +
 arch/powerpc/boot/dts/mpc8544ds.dts                |    4 +-
 arch/powerpc/boot/dts/mpc8544ds.dtsi               |   39 +
 arch/powerpc/boot/dts/mpc8555cds.dts               |    2 +
 arch/powerpc/boot/dts/mpc8560ads.dts               |    2 +
 arch/powerpc/boot/dts/o2d.dts                      |   47 +
 arch/powerpc/boot/dts/o2d.dtsi                     |  139 ++
 arch/powerpc/boot/dts/o2d300.dts                   |   52 +
 arch/powerpc/boot/dts/o2dnt2.dts                   |   48 +
 arch/powerpc/boot/dts/o2i.dts                      |   33 +
 arch/powerpc/boot/dts/o2mnt.dts                    |   33 +
 arch/powerpc/boot/dts/o3dnt.dts                    |   48 +
 arch/powerpc/boot/dts/p1020rdb_camp_core0.dts      |   63 -
 arch/powerpc/boot/dts/p1020rdb_camp_core1.dts      |  141 --
 arch/powerpc/boot/dts/p1022ds.dtsi                 |    4 +
 arch/powerpc/boot/dts/p1022rdk.dts                 |  188 +++
 arch/powerpc/boot/dts/p2020rdb_camp_core0.dts      |   67 -
 arch/powerpc/boot/dts/p2020rdb_camp_core1.dts      |  125 --
 arch/powerpc/boot/dts/p2041rdb.dts                 |    4 +
 arch/powerpc/boot/dts/p3041ds.dts                  |    4 +
 arch/powerpc/boot/dts/p4080ds.dts                  |    4 +
 arch/powerpc/boot/dts/p5020ds.dts                  |    4 +
 arch/powerpc/boot/dts/p5040ds.dts                  |  207 +++
 arch/powerpc/configs/85xx/p1023rds_defconfig       |   37 +-
 arch/powerpc/configs/corenet32_smp_defconfig       |   30 +-
 arch/powerpc/configs/corenet64_smp_defconfig       |    2 +
 arch/powerpc/configs/g5_defconfig                  |  103 +-
 arch/powerpc/configs/mpc83xx_defconfig             |   18 +-
 arch/powerpc/configs/mpc85xx_defconfig             |   34 +-
 arch/powerpc/configs/mpc85xx_smp_defconfig         |   33 +-
 arch/powerpc/configs/ppc64_defconfig               |    1 +
 arch/powerpc/configs/pseries_defconfig             |    1 +
 arch/powerpc/include/asm/abs_addr.h                |   56 -
 arch/powerpc/include/asm/cacheflush.h              |    2 +
 arch/powerpc/include/asm/cputable.h                |    2 -
 arch/powerpc/include/asm/debug.h                   |    2 +-
 arch/powerpc/include/asm/eeh.h                     |  141 +-
 arch/powerpc/include/asm/eeh_event.h               |    6 +-
 arch/powerpc/include/asm/exception-64e.h           |    6 +-
 arch/powerpc/include/asm/fsl_guts.h                |    2 +
 arch/powerpc/include/asm/fsl_ifc.h                 |   14 +-
 arch/powerpc/include/asm/hvcall.h                  |    5 -
 arch/powerpc/include/asm/hw_breakpoint.h           |    9 +-
 arch/powerpc/include/asm/kprobes.h                 |   15 +-
 arch/powerpc/include/asm/kvm_book3s.h              |    2 +-
 arch/powerpc/include/asm/kvm_book3s_asm.h          |    1 -
 arch/powerpc/include/asm/kvm_host.h                |    1 +
 arch/powerpc/include/asm/kvm_ppc.h                 |   12 +
 arch/powerpc/include/asm/machdep.h                 |    9 +-
 arch/powerpc/include/asm/mmu-hash64.h              |  169 +-
 arch/powerpc/include/asm/mmu.h                     |    9 +
 arch/powerpc/include/asm/mpc52xx.h                 |    2 +
 arch/powerpc/include/asm/mpic.h                    |   19 +
 arch/powerpc/include/asm/mpic_msgr.h               |    1 +
 arch/powerpc/include/asm/paca.h                    |    3 +-
 arch/powerpc/include/asm/page_64.h                 |   10 +-
 arch/powerpc/include/asm/pci-bridge.h              |   11 +
 arch/powerpc/include/asm/perf_event_server.h       |    1 +
 arch/powerpc/include/asm/pgtable-ppc64-4k.h        |    4 +-
 arch/powerpc/include/asm/pgtable-ppc64-64k.h       |    2 +-
 arch/powerpc/include/asm/pgtable-ppc64.h           |   19 +-
 arch/powerpc/include/asm/pgtable.h                 |   10 +-
 arch/powerpc/include/asm/ppc-opcode.h              |    3 +
 arch/powerpc/include/asm/ppc-pci.h                 |   20 +-
 arch/powerpc/include/asm/probes.h                  |   42 +
 arch/powerpc/include/asm/processor.h               |    7 +-
 arch/powerpc/include/asm/pte-hash64-64k.h          |   18 +-
 arch/powerpc/include/asm/reg.h                     |   54 +-
 arch/powerpc/include/asm/setup.h                   |    2 +-
 arch/powerpc/include/asm/smp.h                     |    2 +
 arch/powerpc/include/asm/sparsemem.h               |    4 +-
 arch/powerpc/include/asm/swiotlb.h                 |    6 +
 arch/powerpc/include/asm/thread_info.h             |    7 +-
 arch/powerpc/include/asm/tlbflush.h                |    7 +-
 arch/powerpc/include/asm/uaccess.h                 |   11 -
 arch/powerpc/include/asm/uprobes.h                 |   54 +
 arch/powerpc/kernel/Makefile                       |    1 +
 arch/powerpc/kernel/asm-offsets.c                  |    3 +-
 arch/powerpc/kernel/cpu_setup_fsl_booke.S          |   74 +-
 arch/powerpc/kernel/cputable.c                     |    4 +
 arch/powerpc/kernel/dbell.c                        |    2 +
 arch/powerpc/kernel/dma-iommu.c                    |    9 +-
 arch/powerpc/kernel/dma-swiotlb.c                  |   22 +-
 arch/powerpc/kernel/dma.c                          |    3 +-
 arch/powerpc/kernel/entry_32.S                     |   47 +-
 arch/powerpc/kernel/entry_64.S                     |   58 +-
 arch/powerpc/kernel/exceptions-64e.S               |  212 ++-
 arch/powerpc/kernel/exceptions-64s.S               |  130 +-
 arch/powerpc/kernel/fadump.c                       |    3 +-
 arch/powerpc/kernel/head_fsl_booke.S               |   46 +-
 arch/powerpc/kernel/hw_breakpoint.c                |   27 +-
 arch/powerpc/kernel/ibmebus.c                      |    1 -
 arch/powerpc/kernel/idle_power7.S                  |    2 +
 arch/powerpc/kernel/iommu.c                        |    5 +-
 arch/powerpc/kernel/irq.c                          |    8 +-
 arch/powerpc/kernel/kgdb.c                         |   27 +-
 arch/powerpc/kernel/machine_kexec.c                |   14 +-
 arch/powerpc/kernel/paca.c                         |    1 +
 arch/powerpc/kernel/pci-common.c                   |   16 +-
 arch/powerpc/kernel/process.c                      |   28 +-
 arch/powerpc/kernel/prom.c                         |    4 +-
 arch/powerpc/kernel/prom_init.c                    |    2 +-
 arch/powerpc/kernel/ptrace.c                       |    3 +
 arch/powerpc/kernel/rtas_flash.c                   |    7 +-
 arch/powerpc/kernel/rtas_pci.c                     |    5 +-
 arch/powerpc/kernel/setup_64.c                     |    2 +
 arch/powerpc/kernel/signal.c                       |    8 +-
 arch/powerpc/kernel/smp.c                          |   25 +-
 arch/powerpc/kernel/syscalls.c                     |    8 +-
 arch/powerpc/kernel/sysfs.c                        |   10 +
 arch/powerpc/kernel/time.c                         |   15 +-
 arch/powerpc/kernel/traps.c                        |    4 +-
 arch/powerpc/kernel/uprobes.c                      |  184 +++
 arch/powerpc/kernel/vdso.c                         |    4 +-
 arch/powerpc/kernel/vio.c                          |    1 -
 arch/powerpc/kvm/book3s_32_mmu_host.c              |   11 +-
 arch/powerpc/kvm/book3s_64_mmu_host.c              |   19 +-
 arch/powerpc/kvm/book3s_hv_rmhandlers.S            |   14 +-
 arch/powerpc/kvm/e500_tlb.c                        |   11 +-
 arch/powerpc/kvm/trace.h                           |   14 +-
 arch/powerpc/lib/code-patching.c                   |    2 +-
 arch/powerpc/lib/copyuser_power7.S                 |   35 +-
 arch/powerpc/lib/memcpy_power7.S                   |    8 +-
 arch/powerpc/lib/sstep.c                           |   36 +-
 arch/powerpc/mm/fault.c                            |    1 +
 arch/powerpc/mm/hash_low_64.S                      |   97 +-
 arch/powerpc/mm/hash_native_64.c                   |  192 +--
 arch/powerpc/mm/hash_utils_64.c                    |   48 +-
 arch/powerpc/mm/hugetlbpage-hash64.c               |   15 +-
 arch/powerpc/mm/init_64.c                          |    1 -
 arch/powerpc/mm/mem.c                              |    6 +-
 arch/powerpc/mm/mmu_context_hash64.c               |   10 +-
 arch/powerpc/mm/numa.c                             |    7 +-
 arch/powerpc/mm/pgtable_64.c                       |   13 +-
 arch/powerpc/mm/slb_low.S                          |   62 +-
 arch/powerpc/mm/slice.c                            |  112 +-
 arch/powerpc/mm/stab.c                             |    3 +-
 arch/powerpc/mm/subpage-prot.c                     |    6 +-
 arch/powerpc/mm/tlb_hash64.c                       |   11 +-
 arch/powerpc/mm/tlb_low_64e.S                      |   18 +-
 arch/powerpc/oprofile/op_model_power4.c            |  116 +-
 arch/powerpc/perf/core-book3s.c                    |   48 +-
 arch/powerpc/perf/power7-pmu.c                     |    3 +
 arch/powerpc/platforms/44x/currituck.c             |   10 +-
 arch/powerpc/platforms/512x/Kconfig                |    1 +
 arch/powerpc/platforms/512x/clock.c                |    6 +-
 arch/powerpc/platforms/512x/mpc512x_shared.c       |    6 -
 arch/powerpc/platforms/52xx/mpc5200_simple.c       |    1 +
 arch/powerpc/platforms/52xx/mpc52xx_lpbfifo.c      |   35 +-
 arch/powerpc/platforms/85xx/Kconfig                |   21 +
 arch/powerpc/platforms/85xx/Makefile               |    2 +
 arch/powerpc/platforms/85xx/common.c               |   10 +
 arch/powerpc/platforms/85xx/corenet_ds.c           |   38 +-
 arch/powerpc/platforms/85xx/ge_imp3a.c             |   62 +-
 arch/powerpc/platforms/85xx/mpc8536_ds.c           |   36 +-
 arch/powerpc/platforms/85xx/mpc85xx_ads.c          |   11 +-
 arch/powerpc/platforms/85xx/mpc85xx_cds.c          |   44 +-
 arch/powerpc/platforms/85xx/mpc85xx_ds.c           |   15 +-
 arch/powerpc/platforms/85xx/mpc85xx_mds.c          |   40 +-
 arch/powerpc/platforms/85xx/mpc85xx_rdb.c          |   30 +-
 arch/powerpc/platforms/85xx/p1010rdb.c             |   14 +-
 arch/powerpc/platforms/85xx/p1022_ds.c             |   36 +-
 arch/powerpc/platforms/85xx/p1022_rdk.c            |  167 ++
 arch/powerpc/platforms/85xx/p1023_rds.c            |    9 +-
 arch/powerpc/platforms/85xx/p2041_rdb.c            |    2 +-
 arch/powerpc/platforms/85xx/p3041_ds.c             |    2 +-
 arch/powerpc/platforms/85xx/p4080_ds.c             |    2 +-
 arch/powerpc/platforms/85xx/p5020_ds.c             |    2 +-
 arch/powerpc/platforms/85xx/p5040_ds.c             |   89 ++
 arch/powerpc/platforms/85xx/qemu_e500.c            |    5 +-
 arch/powerpc/platforms/85xx/sbc8548.c              |   21 +-
 arch/powerpc/platforms/85xx/smp.c                  |  220 ++-
 arch/powerpc/platforms/85xx/socrates.c             |   11 +-
 arch/powerpc/platforms/85xx/stx_gp3.c              |   13 +-
 arch/powerpc/platforms/85xx/tqm85xx.c              |   21 +-
 arch/powerpc/platforms/85xx/xes_mpc85xx.c          |   56 +-
 arch/powerpc/platforms/86xx/gef_ppc9a.c            |   12 +-
 arch/powerpc/platforms/86xx/gef_sbc310.c           |   13 +-
 arch/powerpc/platforms/86xx/gef_sbc610.c           |   12 +-
 arch/powerpc/platforms/86xx/mpc8610_hpcd.c         |   21 +-
 arch/powerpc/platforms/86xx/mpc86xx_hpcn.c         |   42 +-
 arch/powerpc/platforms/86xx/sbc8641d.c             |   14 +-
 arch/powerpc/platforms/cell/beat.c                 |    4 +-
 arch/powerpc/platforms/cell/beat.h                 |    2 +-
 arch/powerpc/platforms/cell/beat_htab.c            |   45 +-
 arch/powerpc/platforms/pasemi/iommu.c              |    6 +-
 arch/powerpc/platforms/powernv/pci-ioda.c          |  695 +++------
 arch/powerpc/platforms/powernv/pci-p5ioc2.c        |    1 -
 arch/powerpc/platforms/powernv/pci.c               |    7 +-
 arch/powerpc/platforms/powernv/pci.h               |   21 +-
 arch/powerpc/platforms/powernv/smp.c               |   10 +-
 arch/powerpc/platforms/ps3/htab.c                  |   22 +-
 arch/powerpc/platforms/ps3/setup.c                 |   10 +-
 arch/powerpc/platforms/pseries/Makefile            |    5 +-
 arch/powerpc/platforms/pseries/eeh.c               |  543 ++-----
 arch/powerpc/platforms/pseries/eeh_cache.c         |   59 +-
 arch/powerpc/platforms/pseries/eeh_dev.c           |   14 +-
 arch/powerpc/platforms/pseries/eeh_driver.c        |  310 ++--
 arch/powerpc/platforms/pseries/eeh_event.c         |   54 +-
 arch/powerpc/platforms/pseries/eeh_pe.c            |  652 ++++++++
 arch/powerpc/platforms/pseries/eeh_pseries.c       |  247 ++-
 arch/powerpc/platforms/pseries/eeh_sysfs.c         |    9 -
 arch/powerpc/platforms/pseries/iommu.c             |   12 +-
 arch/powerpc/platforms/pseries/lpar.c              |   77 +-
 arch/powerpc/platforms/pseries/msi.c               |   26 +-
 arch/powerpc/platforms/pseries/pci.c               |    2 +-
 arch/powerpc/platforms/pseries/pci_dlpar.c         |   32 +-
 arch/powerpc/platforms/pseries/setup.c             |   22 +-
 arch/powerpc/sysdev/Makefile                       |    2 +-
 arch/powerpc/sysdev/dart_iommu.c                   |   19 +-
 arch/powerpc/sysdev/fsl_85xx_l2ctlr.c              |   10 +
 arch/powerpc/sysdev/fsl_ifc.c                      |   20 +-
 arch/powerpc/sysdev/fsl_mpic_err.c                 |  149 ++
 arch/powerpc/sysdev/fsl_pci.c                      |  154 +-
 arch/powerpc/sysdev/fsl_pci.h                      |   20 +-
 arch/powerpc/sysdev/mpic.c                         |  102 +-
 arch/powerpc/sysdev/mpic.h                         |   22 +
 arch/powerpc/sysdev/mpic_msgr.c                    |    3 +
 arch/powerpc/sysdev/xics/icp-hv.c                  |    6 +-
 arch/powerpc/xmon/xmon.c                           |  195 ++-
 arch/s390/Kconfig                                  |    1 +
 arch/s390/include/asm/elf.h                        |    3 +-
 arch/s390/include/asm/posix_types.h                |    3 +-
 arch/s390/include/asm/smp.h                        |    1 +
 arch/s390/include/asm/sparsemem.h                  |    2 -
 arch/s390/include/asm/syscall.h                    |   10 +
 arch/s390/kernel/compat_linux.c                    |    2 -
 arch/s390/kernel/compat_wrapper.S                  |    4 +-
 arch/s390/kernel/ptrace.c                          |    7 +-
 arch/s390/kernel/sys_s390.c                        |    9 +-
 arch/sh/drivers/dma/dma-sh.c                       |    2 +-
 arch/sh/include/asm/sections.h                     |    1 -
 arch/sh/include/cpu-sh2a/cpu/sh7269.h              |   36 +-
 arch/sh/kernel/cpu/sh2a/pinmux-sh7269.c            |  195 ++-
 arch/sh/kernel/setup.c                             |    2 +-
 arch/sh/kernel/sh_ksyms_32.c                       |    1 -
 arch/sh/kernel/vmlinux.lds.S                       |    1 -
 arch/sh/lib/mcount.S                               |    8 +-
 arch/sparc/kernel/sys_sparc_64.c                   |   10 +-
 arch/sparc/mm/init_64.c                            |   28 +-
 arch/um/os-Linux/time.c                            |    2 +-
 arch/x86/Kconfig                                   |    2 +-
 arch/x86/Makefile                                  |    4 +
 arch/x86/boot/Makefile                             |    2 +-
 arch/x86/include/asm/mce.h                         |    8 +
 arch/x86/include/asm/perf_event.h                  |   11 +-
 arch/x86/include/asm/spinlock.h                    |    3 +-
 arch/x86/kernel/acpi/sleep.c                       |    4 -
 arch/x86/kernel/acpi/sleep.h                       |    2 -
 arch/x86/kernel/acpi/wakeup_32.S                   |    4 +-
 arch/x86/kernel/acpi/wakeup_64.S                   |    4 +-
 arch/x86/kernel/alternative.c                      |    4 +-
 arch/x86/kernel/apic/io_apic.c                     |   14 +-
 arch/x86/kernel/cpu/common.c                       |    2 +
 arch/x86/kernel/cpu/mcheck/mce-severity.c          |    7 -
 arch/x86/kernel/cpu/mcheck/mce.c                   |   43 +-
 arch/x86/kernel/cpu/perf_event.c                   |   89 +-
 arch/x86/kernel/cpu/perf_event.h                   |   20 +
 arch/x86/kernel/cpu/perf_event_amd_ibs.c           |    4 +-
 arch/x86/kernel/cpu/perf_event_intel.c             |   10 +-
 arch/x86/kernel/cpu/perf_event_intel_ds.c          |    7 +-
 arch/x86/kernel/cpu/perf_event_intel_uncore.c      |  253 +--
 arch/x86/kernel/cpu/perf_event_intel_uncore.h      |   48 +-
 arch/x86/kernel/irq.c                              |    3 +-
 arch/x86/kernel/kdebugfs.c                         |    6 +-
 arch/x86/kernel/microcode_amd.c                    |    7 +-
 arch/x86/kvm/emulate.c                             |   30 +-
 arch/x86/kvm/i8259.c                               |   17 +
 arch/x86/kvm/mmu.c                                 |   13 +-
 arch/x86/kvm/vmx.c                                 |   20 +-
 arch/x86/kvm/x86.c                                 |    9 +-
 arch/x86/mm/hugetlbpage.c                          |   21 +-
 arch/x86/mm/pageattr.c                             |   10 +-
 arch/x86/mm/srat.c                                 |   15 +-
 arch/x86/platform/efi/efi.c                        |   30 +-
 arch/x86/realmode/rm/Makefile                      |    2 +-
 arch/x86/syscalls/syscall_64.tbl                   |    8 +-
 arch/x86/xen/enlighten.c                           |  118 +-
 arch/x86/xen/mmu.c                                 |    2 +-
 arch/x86/xen/p2m.c                                 |   94 ++
 arch/x86/xen/setup.c                               |    9 +-
 arch/x86/xen/suspend.c                             |    2 +-
 arch/x86/xen/xen-ops.h                             |    2 +-
 block/blk-lib.c                                    |   41 +-
 block/blk-merge.c                                  |  117 +-
 block/genhd.c                                      |    2 +-
 drivers/acpi/ac.c                                  |    4 +
 drivers/acpi/acpica/achware.h                      |   12 +-
 drivers/acpi/acpica/hwesleep.c                     |   19 +-
 drivers/acpi/acpica/hwsleep.c                      |   20 +-
 drivers/acpi/acpica/hwxfsleep.c                    |   22 +-
 drivers/acpi/acpica/tbxface.c                      |    1 +
 drivers/acpi/battery.c                             |    2 +
 drivers/acpi/button.c                              |    4 +
 drivers/acpi/fan.c                                 |    4 +
 drivers/acpi/numa.c                                |   12 +-
 drivers/acpi/pci_root.c                            |   11 +-
 drivers/acpi/power.c                               |    4 +
 drivers/acpi/processor_driver.c                    |    2 +-
 drivers/acpi/sbs.c                                 |    2 +
 drivers/acpi/sleep.c                               |   75 +-
 drivers/acpi/sysfs.c                               |    4 +-
 drivers/acpi/thermal.c                             |    4 +
 drivers/ata/Kconfig                                |    2 +-
 drivers/ata/ahci.c                                 |    8 +
 drivers/ata/ahci.h                                 |    1 +
 drivers/ata/ata_piix.c                             |    8 +
 drivers/ata/libahci.c                              |    3 +-
 drivers/ata/libata-acpi.c                          |   15 +-
 drivers/ata/libata-core.c                          |    3 +-
 drivers/ata/pata_atiixp.c                          |   16 +
 drivers/atm/iphase.c                               |    2 +-
 drivers/base/core.c                                |    9 +-
 drivers/base/dma-contiguous.c                      |    2 +-
 drivers/base/power/clock_ops.c                     |    3 +-
 drivers/base/power/common.c                        |    4 +-
 drivers/base/power/runtime.c                       |   13 +-
 drivers/bcma/host_pci.c                            |    1 +
 drivers/bcma/sprom.c                               |    4 +-
 drivers/block/cciss_scsi.c                         |   11 +-
 drivers/block/drbd/drbd_bitmap.c                   |   15 +-
 drivers/block/drbd/drbd_int.h                      |    1 +
 drivers/block/drbd/drbd_main.c                     |   32 +-
 drivers/block/drbd/drbd_nl.c                       |    4 +-
 drivers/block/drbd/drbd_req.c                      |   36 +-
 drivers/bluetooth/ath3k.c                          |    2 +
 drivers/bluetooth/btusb.c                          |    2 +
 drivers/char/agp/intel-agp.h                       |   40 +-
 drivers/char/agp/intel-gtt.c                       |  107 +-
 drivers/char/hw_random/omap-rng.c                  |    2 +-
 drivers/char/tpm/tpm_tis.c                         |    2 +
 drivers/clocksource/cs5535-clockevt.c              |    4 +-
 drivers/cpufreq/omap-cpufreq.c                     |    4 +-
 drivers/cpufreq/pcc-cpufreq.c                      |    1 +
 drivers/cpuidle/coupled.c                          |   14 +-
 drivers/crypto/caam/jr.c                           |   10 +-
 drivers/crypto/hifn_795x.c                         |    4 +-
 drivers/crypto/nx/nx.c                             |   17 +-
 drivers/dma/imx-dma.c                              |   36 +-
 drivers/dma/tegra20-apb-dma.c                      |   18 +-
 drivers/edac/mpc85xx_edac.c                        |   43 +-
 drivers/extcon/extcon_gpio.c                       |    3 +-
 drivers/gpio/Kconfig                               |    2 +-
 drivers/gpio/gpio-em.c                             |    6 +-
 drivers/gpio/gpio-langwell.c                       |    7 +-
 drivers/gpio/gpio-msic.c                           |    2 +-
 drivers/gpio/gpio-mxc.c                            |    5 +-
 drivers/gpio/gpio-pxa.c                            |   30 +-
 drivers/gpio/gpio-rdc321x.c                        |    1 +
 drivers/gpio/gpio-samsung.c                        |   14 +-
 drivers/gpio/gpio-sch.c                            |    3 +-
 drivers/gpio/gpiolib-of.c                          |    2 +-
 drivers/gpu/drm/Kconfig                            |    1 +
 drivers/gpu/drm/drm_crtc.c                         |    2 +-
 drivers/gpu/drm/drm_edid.c                         |    3 +
 drivers/gpu/drm/drm_edid_load.c                    |    8 +-
 drivers/gpu/drm/drm_modes.c                        |    3 -
 drivers/gpu/drm/drm_proc.c                         |    4 +-
 drivers/gpu/drm/gma500/psb_intel_display.c         |    3 +
 drivers/gpu/drm/i915/i915_drv.c                    |   31 +-
 drivers/gpu/drm/i915/i915_gem.c                    |    8 +-
 drivers/gpu/drm/i915/i915_gem_context.c            |    1 -
 drivers/gpu/drm/i915/i915_gem_execbuffer.c         |   20 +-
 drivers/gpu/drm/i915/i915_gem_gtt.c                |   10 +-
 drivers/gpu/drm/i915/i915_reg.h                    |    1 +
 drivers/gpu/drm/i915/i915_sysfs.c                  |   12 +
 drivers/gpu/drm/i915/intel_crt.c                   |   36 +-
 drivers/gpu/drm/i915/intel_display.c               |   24 +-
 drivers/gpu/drm/i915/intel_dp.c                    |   14 +-
 drivers/gpu/drm/i915/intel_drv.h                   |   22 +-
 drivers/gpu/drm/i915/intel_i2c.c                   |   10 +-
 drivers/gpu/drm/i915/intel_lvds.c                  |    8 +
 drivers/gpu/drm/i915/intel_modes.c                 |   31 +-
 drivers/gpu/drm/i915/intel_panel.c                 |   15 +-
 drivers/gpu/drm/i915/intel_pm.c                    |   21 +-
 drivers/gpu/drm/i915/intel_ringbuffer.c            |   48 +-
 drivers/gpu/drm/i915/intel_sdvo.c                  |    6 +-
 drivers/gpu/drm/i915/intel_sprite.c                |    4 +-
 drivers/gpu/drm/mgag200/mgag200_mode.c             |   12 +-
 drivers/gpu/drm/nouveau/nouveau_acpi.c             |    6 -
 drivers/gpu/drm/nouveau/nouveau_i2c.c              |    2 +-
 drivers/gpu/drm/nouveau/nouveau_state.c            |    7 +-
 drivers/gpu/drm/nouveau/nv84_fifo.c                |    9 +
 drivers/gpu/drm/nouveau/nvc0_pm.c                  |    2 +-
 drivers/gpu/drm/nouveau/nvd0_display.c             |    2 +-
 drivers/gpu/drm/nouveau/nve0_fifo.c                |   37 +-
 drivers/gpu/drm/radeon/atombios_crtc.c             |   81 +-
 drivers/gpu/drm/radeon/atombios_dp.c               |   29 +-
 drivers/gpu/drm/radeon/atombios_encoders.c         |  140 +-
 drivers/gpu/drm/radeon/evergreen.c                 |   71 +-
 drivers/gpu/drm/radeon/evergreen_cs.c              |   13 +-
 drivers/gpu/drm/radeon/evergreend.h                |    2 +
 drivers/gpu/drm/radeon/ni.c                        |   14 +-
 drivers/gpu/drm/radeon/r600.c                      |   20 +
 drivers/gpu/drm/radeon/r600_cs.c                   |  196 ++-
 drivers/gpu/drm/radeon/r600d.h                     |   28 +
 drivers/gpu/drm/radeon/radeon.h                    |   27 +-
 drivers/gpu/drm/radeon/radeon_asic.h               |   10 +-
 drivers/gpu/drm/radeon/radeon_atombios.c           |   51 +-
 drivers/gpu/drm/radeon/radeon_atpx_handler.c       |   56 +-
 drivers/gpu/drm/radeon/radeon_bios.c               |  138 +-
 drivers/gpu/drm/radeon/radeon_combios.c            |   57 +-
 drivers/gpu/drm/radeon/radeon_cs.c                 |   32 +-
 drivers/gpu/drm/radeon/radeon_cursor.c             |    6 +-
 drivers/gpu/drm/radeon/radeon_device.c             |    6 +-
 drivers/gpu/drm/radeon/radeon_drv.c                |    7 +-
 drivers/gpu/drm/radeon/radeon_gart.c               |   26 +-
 drivers/gpu/drm/radeon/radeon_gem.c                |   13 +-
 drivers/gpu/drm/radeon/radeon_kms.c                |   35 +-
 drivers/gpu/drm/radeon/radeon_legacy_crtc.c        |    4 +
 drivers/gpu/drm/radeon/radeon_mode.h               |    1 +
 drivers/gpu/drm/radeon/radeon_object.c             |    9 +-
 drivers/gpu/drm/radeon/radeon_ring.c               |    1 +
 drivers/gpu/drm/radeon/reg_srcs/r600               |    9 -
 drivers/gpu/drm/radeon/rv515.c                     |   13 -
 drivers/gpu/drm/radeon/si.c                        |   35 +-
 drivers/gpu/drm/radeon/sid.h                       |    3 +
 drivers/gpu/drm/udl/Kconfig                        |    1 +
 drivers/gpu/drm/udl/udl_gem.c                      |    2 +-
 drivers/gpu/drm/udl/udl_modeset.c                  |    3 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_kms.c                |    6 +-
 drivers/gpu/vga/vga_switcheroo.c                   |   61 +-
 drivers/hid/hid-core.c                             |    8 +-
 drivers/hid/hid-logitech-dj.c                      |    4 +-
 drivers/hid/usbhid/hid-quirks.c                    |    1 +
 drivers/hwmon/asus_atk0110.c                       |    6 +
 drivers/hwmon/coretemp.c                           |    2 +-
 drivers/hwmon/w83627hf.c                           |    2 +-
 drivers/i2c/busses/i2c-diolan-u2c.c                |    1 +
 drivers/i2c/busses/i2c-nomadik.c                   |   28 +-
 drivers/i2c/busses/i2c-omap.c                      |    2 +-
 drivers/i2c/busses/i2c-tegra.c                     |    2 +-
 drivers/ide/ide-pm.c                               |    4 +-
 drivers/idle/intel_idle.c                          |    3 +-
 drivers/iio/frequency/adf4350.c                    |   24 +-
 drivers/iio/light/adjd_s311.c                      |    7 +-
 drivers/iio/light/lm3533-als.c                     |    4 +-
 drivers/infiniband/core/ucma.c                     |    2 +-
 drivers/infiniband/hw/amso1100/c2_rnic.c           |    2 +-
 drivers/infiniband/hw/cxgb3/iwch_cm.c              |    2 +-
 drivers/infiniband/hw/ehca/ehca_cq.c               |    2 +-
 drivers/infiniband/hw/ehca/ehca_eq.c               |    2 +-
 drivers/infiniband/hw/ehca/ehca_mrmw.c             |   45 +-
 drivers/infiniband/hw/ehca/ehca_qp.c               |    6 +-
 drivers/infiniband/hw/ehca/ehca_reqs.c             |    2 +-
 drivers/infiniband/hw/ehca/ehca_tools.h            |    1 -
 drivers/infiniband/hw/ehca/hcp_if.c                |   12 +-
 drivers/infiniband/hw/ehca/ipz_pt_fn.c             |    2 +-
 drivers/infiniband/hw/mlx4/mad.c                   |   16 +-
 drivers/infiniband/hw/mlx4/main.c                  |    5 +-
 drivers/infiniband/hw/mlx4/qp.c                    |    6 +-
 drivers/infiniband/hw/ocrdma/ocrdma_main.c         |   16 +-
 drivers/infiniband/hw/qib/qib_iba7322.c            |    4 +-
 drivers/infiniband/hw/qib/qib_sd7220.c             |    2 +-
 drivers/infiniband/ulp/ipoib/ipoib_cm.c            |    3 +
 drivers/infiniband/ulp/ipoib/ipoib_main.c          |    2 +-
 drivers/infiniband/ulp/srp/ib_srp.c                |   87 +-
 drivers/infiniband/ulp/srpt/ib_srpt.c              |    2 +-
 drivers/input/keyboard/imx_keypad.c                |    3 +
 drivers/input/serio/i8042-x86ia64io.h              |   14 +
 drivers/input/tablet/wacom_wac.c                   |    6 +-
 drivers/input/touchscreen/edt-ft5x06.c             |    2 +-
 drivers/input/touchscreen/eeti_ts.c                |   21 +-
 drivers/iommu/amd_iommu.c                          |   25 +-
 drivers/iommu/amd_iommu_init.c                     |    8 +-
 drivers/iommu/exynos-iommu.c                       |    6 +-
 drivers/iommu/intel-iommu.c                        |   26 +-
 drivers/iommu/intel_irq_remapping.c                |   18 +-
 drivers/iommu/tegra-smmu.c                         |   17 +-
 drivers/isdn/isdnloop/isdnloop.c                   |   12 -
 drivers/isdn/mISDN/layer2.c                        |    2 +-
 drivers/leds/led-triggers.c                        |    2 +-
 drivers/leds/leds-lp8788.c                         |    2 +-
 drivers/leds/leds-renesas-tpu.c                    |    2 +-
 drivers/macintosh/smu.c                            |    3 +-
 drivers/md/md.c                                    |    9 +-
 drivers/md/raid10.c                                |   30 +-
 drivers/md/raid10.h                                |    2 +-
 drivers/media/dvb/siano/smsusb.c                   |    2 +-
 drivers/media/radio/radio-shark.c                  |  151 +-
 drivers/media/radio/radio-shark2.c                 |  137 +-
 drivers/media/radio/si470x/radio-si470x-common.c   |    3 +
 drivers/media/radio/si470x/radio-si470x-i2c.c      |    5 +-
 drivers/media/radio/si470x/radio-si470x-usb.c      |    2 +-
 drivers/media/rc/Kconfig                           |    1 +
 drivers/media/video/gspca/jl2005bcd.c              |    2 +-
 drivers/media/video/gspca/spca506.c                |    2 +-
 drivers/media/video/mem2mem_testdev.c              |    2 +-
 drivers/media/video/mx1_camera.c                   |    4 +-
 drivers/media/video/mx2_camera.c                   |   47 +-
 drivers/media/video/mx3_camera.c                   |   22 +-
 drivers/media/video/soc_camera.c                   |    3 +-
 drivers/media/video/soc_mediabus.c                 |    6 +
 drivers/media/video/uvc/uvc_queue.c                |    1 +
 drivers/media/video/v4l2-ioctl.c                   |   10 +-
 drivers/mfd/Kconfig                                |    3 +-
 drivers/mfd/asic3.c                                |    1 +
 drivers/mfd/ezx-pcap.c                             |    2 +-
 drivers/misc/mei/interrupt.c                       |    2 +-
 drivers/misc/mei/main.c                            |   27 +
 drivers/misc/sgi-xp/xpc_uv.c                       |   84 +-
 drivers/misc/ti-st/st_ll.c                         |    2 +-
 drivers/mmc/card/block.c                           |   26 +-
 drivers/mmc/host/atmel-mci.c                       |    6 +-
 drivers/mmc/host/bfin_sdh.c                        |    7 -
 drivers/mmc/host/dw_mmc.c                          |   85 +-
 drivers/mmc/host/mxs-mmc.c                         |   14 +-
 drivers/mmc/host/omap.c                            |   14 +-
 drivers/mmc/host/sdhci-esdhc.h                     |    6 +-
 drivers/mtd/maps/uclinux.c                         |    5 +-
 drivers/mtd/nand/Kconfig                           |    2 +-
 drivers/mtd/nand/fsl_ifc_nand.c                    |   56 +-
 drivers/mtd/nand/omap2.c                           |    7 +-
 drivers/mtd/ubi/vtbl.c                             |    4 +-
 drivers/net/appletalk/cops.c                       |    4 +-
 drivers/net/appletalk/ltpc.c                       |    4 +-
 drivers/net/bonding/bond_main.c                    |   12 +-
 drivers/net/can/sja1000/sja1000_platform.c         |    4 +-
 drivers/net/can/softing/softing_fw.c               |    7 +-
 drivers/net/cris/eth_v10.c                         |    2 +-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x.h        |    5 +-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c    |    4 +
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.h    |    4 +-
 .../net/ethernet/broadcom/bnx2x/bnx2x_ethtool.c    |    2 -
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c   |   85 +-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_sp.c     |    1 +
 drivers/net/ethernet/cirrus/cs89x0.c               |   10 +-
 drivers/net/ethernet/emulex/benet/be_cmds.c        |    6 +-
 drivers/net/ethernet/emulex/benet/be_main.c        |    4 +-
 .../net/ethernet/freescale/fs_enet/mii-bitbang.c   |    4 +-
 drivers/net/ethernet/freescale/fs_enet/mii-fec.c   |    8 +-
 drivers/net/ethernet/freescale/gianfar.c           |    2 +-
 drivers/net/ethernet/ibm/ehea/ehea.h               |    1 -
 drivers/net/ethernet/ibm/ehea/ehea_phyp.c          |   12 +-
 drivers/net/ethernet/ibm/ehea/ehea_qmr.c           |   14 +-
 drivers/net/ethernet/intel/e1000e/82571.c          |   10 +-
 drivers/net/ethernet/intel/e1000e/e1000.h          |    1 +
 drivers/net/ethernet/intel/e1000e/netdev.c         |   84 +-
 drivers/net/ethernet/intel/igb/e1000_82575.c       |   16 +-
 drivers/net/ethernet/intel/igb/e1000_regs.h        |    8 +-
 drivers/net/ethernet/intel/igb/igb_ethtool.c       |   28 +-
 drivers/net/ethernet/intel/igb/igb_main.c          |   19 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_82599.c     |    3 +-
 drivers/net/ethernet/mellanox/mlx4/en_rx.c         |    4 +-
 drivers/net/ethernet/mellanox/mlx4/en_tx.c         |   17 +-
 drivers/net/ethernet/mellanox/mlx4/icm.c           |    9 +-
 drivers/net/ethernet/mellanox/mlx4/icm.h           |    2 +-
 drivers/net/ethernet/mellanox/mlx4/main.c          |    3 -
 drivers/net/ethernet/mellanox/mlx4/mcg.c           |    4 +-
 drivers/net/ethernet/mellanox/mlx4/mlx4.h          |    4 +-
 drivers/net/ethernet/mellanox/mlx4/mlx4_en.h       |    1 -
 drivers/net/ethernet/mellanox/mlx4/mr.c            |   27 +-
 drivers/net/ethernet/mellanox/mlx4/profile.c       |    4 +-
 drivers/net/ethernet/mellanox/mlx4/sense.c         |   14 -
 drivers/net/ethernet/nxp/lpc_eth.c                 |   13 -
 drivers/net/ethernet/renesas/Kconfig               |    4 +-
 drivers/net/ethernet/renesas/sh_eth.c              |   11 +-
 drivers/net/ethernet/sfc/efx.c                     |    6 +
 drivers/net/ethernet/sfc/efx.h                     |   14 +-
 drivers/net/ethernet/sfc/ethtool.c                 |   20 +-
 drivers/net/ethernet/sfc/tx.c                      |   19 +
 drivers/net/ethernet/stmicro/stmmac/common.h       |    5 +
 drivers/net/ethernet/stmicro/stmmac/descs.h        |    6 +
 drivers/net/ethernet/stmicro/stmmac/descs_com.h    |    5 +
 drivers/net/ethernet/stmicro/stmmac/dwmac100.h     |    5 +
 drivers/net/ethernet/stmicro/stmmac/dwmac1000.h    |    5 +-
 drivers/net/ethernet/stmicro/stmmac/dwmac_dma.h    |    5 +
 drivers/net/ethernet/stmicro/stmmac/mmc.h          |    5 +
 drivers/net/ethernet/stmicro/stmmac/mmc_core.c     |    6 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac.h       |    5 +
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c  |    2 +-
 .../net/ethernet/stmicro/stmmac/stmmac_platform.c  |    2 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac_timer.h |    4 +
 drivers/net/ethernet/ti/davinci_cpdma.c            |    3 +-
 drivers/net/ethernet/ti/davinci_mdio.c             |    4 +-
 drivers/net/ethernet/xscale/ixp4xx_eth.c           |    1 +
 drivers/net/fddi/skfp/pmf.c                        |    2 +-
 drivers/net/hyperv/netvsc.c                        |    7 -
 drivers/net/hyperv/rndis_filter.c                  |   11 +
 drivers/net/irda/bfin_sir.c                        |    8 +-
 drivers/net/irda/ks959-sir.c                       |    1 +
 drivers/net/irda/ksdazzle-sir.c                    |    1 +
 drivers/net/macvtap.c                              |    3 +-
 drivers/net/netconsole.c                           |    6 -
 drivers/net/phy/mdio-mux-gpio.c                    |    1 -
 drivers/net/phy/mdio-mux.c                         |    2 +-
 drivers/net/ppp/pptp.c                             |    4 +-
 drivers/net/team/team.c                            |   16 +-
 drivers/net/tun.c                                  |    1 -
 drivers/net/usb/cdc-phonet.c                       |    1 +
 drivers/net/usb/cdc_ncm.c                          |   20 +
 drivers/net/usb/qmi_wwan.c                         |  255 +--
 drivers/net/usb/sierra_net.c                       |   52 +-
 drivers/net/usb/usbnet.c                           |    2 +-
 drivers/net/vmxnet3/vmxnet3_drv.c                  |    2 +-
 drivers/net/wan/dscc4.c                            |    5 +-
 drivers/net/wimax/i2400m/fw.c                      |    4 +-
 drivers/net/wireless/at76c50x-usb.c                |    2 +-
 drivers/net/wireless/ath/ath5k/base.c              |    6 +-
 drivers/net/wireless/ath/ath5k/eeprom.c            |    2 +-
 drivers/net/wireless/ath/ath5k/eeprom.h            |    1 +
 drivers/net/wireless/ath/ath5k/mac80211-ops.c      |    5 +-
 drivers/net/wireless/ath/ath9k/hw.c                |    1 +
 drivers/net/wireless/ath/ath9k/hw.h                |    1 +
 drivers/net/wireless/ath/ath9k/mac.c               |   18 +-
 drivers/net/wireless/ath/ath9k/mac.h               |    1 +
 drivers/net/wireless/ath/ath9k/main.c              |    4 +-
 drivers/net/wireless/ath/ath9k/pci.c               |    2 +
 drivers/net/wireless/ath/ath9k/recv.c              |    2 +-
 drivers/net/wireless/b43/main.c                    |   21 +-
 drivers/net/wireless/brcm80211/brcmsmac/channel.c  |    5 +-
 .../net/wireless/brcm80211/brcmsmac/mac80211_if.c  |    6 +-
 drivers/net/wireless/ipw2x00/ipw2100.c             |    3 +-
 drivers/net/wireless/iwlwifi/dvm/debugfs.c         |    3 +
 drivers/net/wireless/iwlwifi/dvm/rs.c              |   13 +-
 drivers/net/wireless/iwlwifi/pcie/internal.h       |    2 +-
 drivers/net/wireless/iwlwifi/pcie/rx.c             |    2 +-
 drivers/net/wireless/iwlwifi/pcie/trans.c          |   30 +-
 drivers/net/wireless/libertas/cfg.c                |    1 +
 drivers/net/wireless/libertas/if_sdio.c            |    1 +
 drivers/net/wireless/libertas/main.c               |    5 +-
 drivers/net/wireless/p54/p54usb.c                  |    2 +-
 drivers/net/wireless/rndis_wlan.c                  |    6 +-
 drivers/net/wireless/rt2x00/rt2800lib.c            |   68 +
 drivers/net/wireless/rt2x00/rt2800pci.c            |   71 -
 drivers/net/wireless/rt2x00/rt61pci.c              |    3 +-
 drivers/net/wireless/rtl818x/rtl8187/dev.c         |    2 +-
 drivers/net/xen-netfront.c                         |   39 +-
 drivers/of/base.c                                  |   27 +
 drivers/pci/hotplug/rpadlpar_core.c                |    2 +-
 drivers/pci/pci-acpi.c                             |    4 +-
 drivers/pci/pci-driver.c                           |   13 +
 drivers/pci/pci-sysfs.c                            |   42 +
 drivers/pci/pci.c                                  |    1 +
 drivers/pci/pcie/portdrv_pci.c                     |   14 +
 drivers/pci/probe.c                                |   31 +-
 drivers/pinctrl/core.c                             |   13 +-
 drivers/pinctrl/pinctrl-imx23.c                    |    2 +-
 drivers/pinctrl/pinctrl-imx28.c                    |    2 +-
 drivers/pinctrl/pinctrl-imx51.c                    |    2 +-
 drivers/pinctrl/pinctrl-nomadik-db8500.c           |    7 +-
 drivers/pinctrl/pinctrl-nomadik.c                  |    3 +-
 drivers/pinctrl/pinctrl-sirf.c                     |    1 -
 drivers/pinctrl/pinctrl-u300.c                     |    8 +-
 drivers/platform/x86/Kconfig                       |    6 +-
 drivers/platform/x86/apple-gmux.c                  |  426 ++++-
 drivers/platform/x86/asus-wmi.c                    |   21 +-
 drivers/platform/x86/asus-wmi.h                    |    1 +
 drivers/platform/x86/classmate-laptop.c            |   16 +-
 drivers/platform/x86/dell-laptop.c                 |   12 +-
 drivers/platform/x86/fujitsu-tablet.c              |    2 +
 drivers/platform/x86/hdaps.c                       |    2 +
 drivers/platform/x86/hp_accel.c                    |    2 +-
 drivers/platform/x86/ideapad-laptop.c              |  110 +-
 drivers/platform/x86/msi-laptop.c                  |    4 +
 drivers/platform/x86/panasonic-laptop.c            |    4 +
 drivers/platform/x86/sony-laptop.c                 |   12 +-
 drivers/platform/x86/thinkpad_acpi.c               |    9 +
 drivers/platform/x86/toshiba_acpi.c                |    2 +
 drivers/platform/x86/toshiba_bluetooth.c           |    4 +
 drivers/platform/x86/xo15-ebook.c                  |    2 +
 drivers/pwm/Kconfig                                |   31 +-
 drivers/pwm/core.c                                 |   12 +-
 drivers/pwm/pwm-samsung.c                          |    1 +
 drivers/pwm/pwm-tegra.c                            |    4 +-
 drivers/pwm/pwm-tiecap.c                           |    4 +-
 drivers/pwm/pwm-tiehrpwm.c                         |    4 +-
 drivers/pwm/pwm-vt8500.c                           |    2 +-
 drivers/rapidio/devices/tsi721.c                   |   11 +-
 drivers/regulator/ab3100.c                         |    1 +
 drivers/regulator/anatop-regulator.c               |    5 +-
 drivers/regulator/core.c                           |    2 +-
 drivers/regulator/gpio-regulator.c                 |   38 +-
 drivers/regulator/palmas-regulator.c               |   23 +-
 drivers/regulator/tps6586x-regulator.c             |    8 +-
 drivers/regulator/twl-regulator.c                  |    5 +-
 drivers/rtc/interface.c                            |    2 +
 drivers/rtc/rtc-at91sam9.c                         |   22 +-
 drivers/rtc/rtc-cmos.c                             |    1 -
 drivers/rtc/rtc-pcf2123.c                          |    2 +
 drivers/rtc/rtc-rs5c348.c                          |    7 +-
 drivers/s390/block/dasd_eckd.c                     |    2 +-
 drivers/s390/block/dasd_ioctl.c                    |    7 +-
 drivers/s390/char/sclp_sdias.c                     |    2 +
 drivers/scsi/ipr.c                                 |   18 +-
 drivers/sh/intc/core.c                             |   27 +-
 drivers/spi/spi-bcm63xx.c                          |   35 +-
 drivers/spi/spi-coldfire-qspi.c                    |    5 +-
 drivers/spi/spi-omap2-mcspi.c                      |    6 +-
 drivers/spi/spi-pl022.c                            |    1 -
 drivers/spi/spi-s3c64xx.c                          |   14 +-
 drivers/staging/comedi/drivers.c                   |    2 +-
 drivers/staging/comedi/drivers/adv_pci1710.c       |    3 -
 drivers/staging/comedi/drivers/adv_pci1723.c       |    2 -
 drivers/staging/comedi/drivers/adv_pci_dio.c       |    2 -
 drivers/staging/comedi/drivers/daqboard2000.c      |   17 +-
 drivers/staging/comedi/drivers/dt3000.c            |    6 +-
 drivers/staging/comedi/drivers/rtd520.c            |   26 +-
 drivers/staging/comedi/drivers/usbdux.c            |    4 +-
 drivers/staging/comedi/drivers/usbduxfast.c        |    4 +-
 drivers/staging/comedi/drivers/usbduxsigma.c       |    4 +-
 drivers/staging/csr/Kconfig                        |    2 +-
 drivers/staging/iio/adc/ad7192.c                   |   48 +-
 drivers/staging/iio/adc/ad7298_ring.c              |    2 +-
 drivers/staging/iio/adc/ad7780.c                   |   10 +-
 drivers/staging/iio/adc/ad7793.c                   |   99 +-
 drivers/staging/vt6656/main_usb.c                  |    2 +-
 drivers/staging/winbond/wbusb.c                    |    2 +-
 drivers/target/target_core_pscsi.c                 |    9 +-
 drivers/target/target_core_transport.c             |   15 +-
 drivers/target/tcm_fc/tcm_fc.h                     |    1 +
 drivers/target/tcm_fc/tfc_cmd.c                    |    8 +-
 drivers/target/tcm_fc/tfc_sess.c                   |    4 +-
 drivers/tty/hvc/hvc_console.c                      |   33 +-
 drivers/tty/hvc/hvc_vio.c                          |  123 +-
 drivers/tty/serial/Kconfig                         |   10 +-
 drivers/tty/serial/ifx6x60.c                       |    2 +-
 drivers/tty/serial/mxs-auart.c                     |   14 +-
 drivers/tty/serial/pmac_zilog.c                    |   12 +-
 drivers/usb/Kconfig                                |    2 +-
 drivers/usb/chipidea/Kconfig                       |    9 +-
 drivers/usb/class/cdc-acm.c                        |    3 +-
 drivers/usb/early/ehci-dbgp.c                      |    2 +-
 drivers/usb/gadget/u_ether.c                       |    6 +
 drivers/usb/host/ehci-omap.c                       |  167 +-
 drivers/usb/host/ehci-sead3.c                      |    2 +-
 drivers/usb/host/ehci-tegra.c                      |    3 +-
 drivers/usb/host/isp1362-hcd.c                     |    8 +-
 drivers/usb/host/ohci-omap.c                       |    2 -
 drivers/usb/host/pci-quirks.c                      |    7 +
 drivers/usb/host/pci-quirks.h                      |    1 +
 drivers/usb/host/xhci-pci.c                        |   10 +
 drivers/usb/host/xhci-ring.c                       |   40 +-
 drivers/usb/host/xhci.c                            |    8 +-
 drivers/usb/host/xhci.h                            |    3 +
 drivers/usb/misc/emi62.c                           |    2 +-
 drivers/usb/musb/Kconfig                           |    4 +-
 drivers/usb/musb/musb_dsps.c                       |   19 +-
 drivers/usb/renesas_usbhs/common.c                 |    6 +-
 drivers/usb/renesas_usbhs/mod_host.c               |    8 +
 drivers/usb/serial/bus.c                           |   15 +-
 drivers/usb/serial/ftdi_sio.c                      |    1 +
 drivers/usb/serial/ftdi_sio_ids.h                  |    7 +
 drivers/usb/serial/ipw.c                           |    3 +-
 drivers/usb/serial/mos7840.c                       |   16 +-
 drivers/usb/serial/option.c                        |  285 ++--
 drivers/usb/serial/qcserial.c                      |   47 +-
 drivers/usb/serial/usb-wwan.h                      |    3 +-
 drivers/usb/serial/usb_wwan.c                      |   68 +-
 drivers/vfio/vfio.c                                |   19 +-
 drivers/vhost/Kconfig                              |    3 +
 drivers/vhost/Kconfig.tcm                          |    6 +
 drivers/vhost/Makefile                             |    2 +
 drivers/vhost/tcm_vhost.c                          | 1649 ++++++++++++++++++++
 drivers/vhost/tcm_vhost.h                          |  103 ++
 drivers/video/auo_k190x.c                          |    2 -
 drivers/video/console/bitblit.c                    |    2 +-
 drivers/video/console/fbcon.c                      |   11 +-
 drivers/video/mb862xx/mb862xxfbdrv.c               |    2 +
 drivers/video/omap2/dss/sdi.c                      |   14 +
 drivers/video/omap2/omapfb/omapfb-main.c           |    2 +-
 drivers/video/ps3fb.c                              |    3 +-
 drivers/w1/slaves/w1_therm.c                       |    9 +
 drivers/w1/w1_family.h                             |    1 +
 drivers/watchdog/booke_wdt.c                       |    7 +-
 drivers/watchdog/da9052_wdt.c                      |    1 -
 drivers/xen/platform-pci.c                         |   15 -
 drivers/xen/swiotlb-xen.c                          |    2 +-
 drivers/xen/xen-pciback/pci_stub.c                 |    8 +-
 drivers/zorro/zorro.c                              |    2 -
 fs/autofs4/expire.c                                |   36 +-
 fs/bio.c                                           |   13 +-
 fs/block_dev.c                                     |    3 +
 fs/btrfs/backref.c                                 |    4 +-
 fs/btrfs/compression.c                             |    1 +
 fs/btrfs/ctree.c                                   |    9 +-
 fs/btrfs/ctree.h                                   |    3 +-
 fs/btrfs/delayed-inode.c                           |   12 +-
 fs/btrfs/delayed-ref.c                             |  163 +-
 fs/btrfs/delayed-ref.h                             |    4 +
 fs/btrfs/disk-io.c                                 |   53 +-
 fs/btrfs/disk-io.h                                 |    2 +-
 fs/btrfs/extent-tree.c                             |  123 +-
 fs/btrfs/extent_io.c                               |   17 +-
 fs/btrfs/file-item.c                               |    4 +-
 fs/btrfs/inode.c                                   |  329 ++--
 fs/btrfs/ioctl.c                                   |    7 +-
 fs/btrfs/locking.c                                 |    2 +-
 fs/btrfs/ordered-data.c                            |    2 +-
 fs/btrfs/qgroup.c                                  |   12 +-
 fs/btrfs/root-tree.c                               |    4 +-
 fs/btrfs/super.c                                   |   19 +-
 fs/btrfs/transaction.c                             |    3 +-
 fs/btrfs/volumes.c                                 |   37 +-
 fs/btrfs/volumes.h                                 |    2 -
 fs/buffer.c                                        |   66 +-
 fs/ceph/debugfs.c                                  |    1 +
 fs/ceph/inode.c                                    |   15 +-
 fs/ceph/ioctl.c                                    |    3 +-
 fs/cifs/cifssmb.c                                  |   11 +-
 fs/cifs/dir.c                                      |    9 +-
 fs/cifs/inode.c                                    |   24 +-
 fs/cifs/link.c                                     |    2 +
 fs/cifs/smb2misc.c                                 |   16 +-
 fs/cifs/smb2pdu.h                                  |   10 +-
 fs/cifs/transport.c                                |    9 +-
 fs/compat.c                                        |   10 +-
 fs/direct-io.c                                     |    5 +
 fs/eventpoll.c                                     |    2 +-
 fs/exofs/inode.c                                   |   27 +-
 fs/exofs/ore.c                                     |   14 +-
 fs/exofs/super.c                                   |   11 -
 fs/ext3/inode.c                                    |    8 -
 fs/ext3/super.c                                    |   11 -
 fs/ext4/balloc.c                                   |   62 +-
 fs/ext4/bitmap.c                                   |    1 -
 fs/ext4/extents.c                                  |    1 +
 fs/ext4/inode.c                                    |   10 +-
 fs/ext4/super.c                                    |   17 +-
 fs/fuse/dir.c                                      |    3 +
 fs/fuse/file.c                                     |   15 +-
 fs/fuse/fuse_i.h                                   |    3 +
 fs/fuse/inode.c                                    |   32 +-
 fs/gfs2/meta_io.c                                  |    2 +-
 fs/hfs/mdb.c                                       |    4 +-
 fs/jbd/journal.c                                   |    9 +-
 fs/jbd2/journal.c                                  |    7 +-
 fs/logfs/dev_bdev.c                                |   15 +-
 fs/logfs/inode.c                                   |   18 +-
 fs/logfs/journal.c                                 |    2 +-
 fs/logfs/readwrite.c                               |    1 -
 fs/logfs/segment.c                                 |    2 +-
 fs/namei.c                                         |   10 +-
 fs/nfs/Makefile                                    |   18 +-
 fs/nfs/client.c                                    |    2 +-
 fs/nfs/idmap.c                                     |   62 +-
 fs/nfs/nfs3proc.c                                  |    2 +-
 fs/nfs/nfs4_fs.h                                   |    3 +
 fs/nfs/nfs4client.c                                |    2 +-
 fs/nfs/nfs4proc.c                                  |   76 +-
 fs/nfs/nfs4super.c                                 |   15 -
 fs/nfs/nfs4xdr.c                                   |   26 +-
 fs/nfs/objlayout/objio_osd.c                       |   55 +-
 fs/nfs/pagelist.c                                  |    2 +
 fs/nfs/pnfs.c                                      |   39 +-
 fs/nfs/pnfs.h                                      |    2 +-
 fs/nfs/super.c                                     |   39 +-
 fs/nfs/write.c                                     |   15 +-
 fs/nfsd/nfs4callback.c                             |    4 +-
 fs/nfsd/state.h                                    |    1 -
 fs/nilfs2/super.c                                  |    4 -
 fs/nilfs2/the_nilfs.h                              |    2 -
 fs/open.c                                          |    9 +-
 fs/quota/dquot.c                                   |    2 +-
 fs/reiserfs/bitmap.c                               |    2 -
 fs/reiserfs/inode.c                                |    2 +-
 fs/super.c                                         |   40 -
 fs/ubifs/debug.h                                   |    2 +-
 fs/ubifs/file.c                                    |   10 +-
 fs/ubifs/lpt.c                                     |    5 +-
 fs/ubifs/recovery.c                                |    2 +-
 fs/ubifs/replay.c                                  |    3 +-
 fs/ubifs/super.c                                   |    5 +-
 fs/udf/inode.c                                     |    5 +-
 fs/udf/super.c                                     |    7 +-
 fs/xfs/xfs_discard.c                               |    6 +-
 fs/xfs/xfs_ialloc.c                                |   17 +-
 fs/xfs/xfs_rtalloc.c                               |    2 +-
 include/acpi/acpixf.h                              |    4 +-
 include/acpi/actypes.h                             |    2 +-
 include/asm-generic/mutex-xchg.h                   |   11 +-
 include/drm/drm_crtc.h                             |    5 +-
 include/drm/drm_mode.h                             |    5 +-
 include/drm/drm_pciids.h                           |    3 +
 include/drm/radeon_drm.h                           |    2 +
 include/linux/Kbuild                               |    1 +
 include/linux/acpi.h                               |    2 +-
 include/linux/backing-dev.h                        |    1 -
 include/linux/bcma/bcma_driver_chipcommon.h        |    6 +
 include/linux/blkdev.h                             |   14 +-
 include/linux/can.h                                |   25 +-
 include/linux/compaction.h                         |    4 +-
 include/linux/cpuidle.h                            |    4 +
 include/linux/efi.h                                |    2 +
 include/linux/fs.h                                 |    3 -
 include/linux/ftrace_event.h                       |    5 +-
 include/linux/fuse.h                               |   19 +-
 include/linux/hardirq.h                            |    2 +-
 include/linux/if_team.h                            |   30 +-
 include/linux/iio/frequency/adf4350.h              |    2 +
 include/linux/input/eeti_ts.h                      |    1 +
 include/linux/iommu.h                              |    2 +
 include/linux/ipv6.h                               |    1 +
 include/linux/irq.h                                |    1 +
 include/linux/jbd2.h                               |    1 +
 include/linux/jiffies.h                            |   29 +-
 include/linux/kdb.h                                |    2 -
 include/linux/kernel.h                             |   12 +-
 include/linux/kref.h                               |   18 +
 include/linux/ktime.h                              |    7 -
 include/linux/mfd/ezx-pcap.h                       |    1 +
 include/linux/mmc/card.h                           |    1 +
 include/linux/mv643xx_eth.h                        |    2 +
 include/linux/netdevice.h                          |    7 +-
 include/linux/netfilter/nf_conntrack_sip.h         |    2 +-
 include/linux/netpoll.h                            |   42 +-
 include/linux/nfs_page.h                           |    1 +
 include/linux/nfs_xdr.h                            |    1 +
 include/linux/of.h                                 |    7 +
 include/linux/pci_ids.h                            |    2 +-
 include/linux/perf_event.h                         |    3 +-
 include/linux/pinctrl/consumer.h                   |    1 +
 include/linux/sched.h                              |    8 -
 include/linux/security.h                           |    2 -
 include/linux/string.h                             |    2 +-
 include/linux/time.h                               |   29 +-
 include/linux/timex.h                              |    2 +-
 include/linux/topology.h                           |    1 +
 include/linux/writeback.h                          |    1 -
 include/net/cfg80211.h                             |    2 +
 include/net/codel.h                                |    8 +-
 include/net/dst.h                                  |    2 +-
 include/net/inet_connection_sock.h                 |    1 +
 include/net/inet_sock.h                            |    9 -
 include/net/ip.h                                   |    2 +-
 include/net/llc.h                                  |    2 +-
 include/net/netfilter/nf_conntrack_ecache.h        |    1 +
 include/net/scm.h                                  |    4 +-
 include/net/sock.h                                 |    2 +
 include/net/tcp.h                                  |    1 +
 include/net/xfrm.h                                 |    6 +
 include/sound/pcm.h                                |    3 +-
 include/target/target_core_base.h                  |    2 -
 include/trace/events/sched.h                       |    4 +
 include/trace/ftrace.h                             |    6 +-
 include/xen/events.h                               |    2 -
 init/main.c                                        |    8 +-
 ipc/mqueue.c                                       |   61 +-
 kernel/audit_tree.c                                |   19 +-
 kernel/debug/kdb/kdb_debugger.c                    |    4 +
 kernel/debug/kdb/kdb_io.c                          |   11 -
 kernel/debug/kdb/kdb_main.c                        |   15 +-
 kernel/events/callchain.c                          |    9 +-
 kernel/events/core.c                               |   30 +-
 kernel/events/internal.h                           |    3 +-
 kernel/fork.c                                      |    4 +-
 kernel/futex.c                                     |   17 +-
 kernel/irq/manage.c                                |   15 +-
 kernel/power/suspend.c                             |    3 -
 kernel/printk.c                                    |    2 +
 kernel/sched/core.c                                |   39 +-
 kernel/sched/cpupri.c                              |   10 +-
 kernel/sched/fair.c                                |   40 +-
 kernel/sched/rt.c                                  |   13 +
 kernel/sched/sched.h                               |    8 +-
 kernel/sched/stop_task.c                           |   22 +-
 kernel/task_work.c                                 |    1 +
 kernel/time/jiffies.c                              |    2 +-
 kernel/time/ntp.c                                  |    2 +-
 kernel/time/timekeeping.c                          |  442 +++---
 kernel/timer.c                                     |    9 -
 kernel/trace/trace_event_perf.c                    |    2 +-
 kernel/trace/trace_kprobe.c                        |    6 +-
 kernel/trace/trace_syscalls.c                      |    8 +-
 kernel/trace/trace_uprobe.c                        |    2 +-
 kernel/watchdog.c                                  |   21 +-
 mm/backing-dev.c                                   |   52 -
 mm/compaction.c                                    |  156 +-
 mm/filemap.c                                       |    7 -
 mm/internal.h                                      |    1 +
 mm/mempolicy.c                                     |    2 +-
 mm/mmap.c                                          |    7 +-
 mm/page-writeback.c                                |    1 -
 mm/page_alloc.c                                    |   38 +-
 mm/slab.c                                          |    1 +
 net/8021q/vlan_dev.c                               |   52 +-
 net/atm/common.c                                   |    1 +
 net/atm/pvc.c                                      |    1 +
 net/batman-adv/gateway_client.c                    |    6 +-
 net/batman-adv/translation-table.c                 |    1 +
 net/bluetooth/hci_event.c                          |   28 +-
 net/bluetooth/hci_sock.c                           |    2 +
 net/bluetooth/l2cap_core.c                         |    1 +
 net/bluetooth/l2cap_sock.c                         |    3 +-
 net/bluetooth/rfcomm/sock.c                        |    2 +
 net/bluetooth/rfcomm/tty.c                         |    2 +-
 net/bluetooth/sco.c                                |   19 +-
 net/bluetooth/smp.c                                |    5 +-
 net/bridge/br_device.c                             |   30 +-
 net/bridge/br_forward.c                            |    2 +-
 net/bridge/br_if.c                                 |    6 +-
 net/bridge/br_private.h                            |    4 +-
 net/caif/chnl_net.c                                |    4 +
 net/ceph/ceph_common.c                             |    1 -
 net/ceph/debugfs.c                                 |    4 +
 net/ceph/messenger.c                               |   11 +-
 net/ceph/mon_client.c                              |   51 +-
 net/core/dev.c                                     |   28 +-
 net/core/dst.c                                     |   10 +-
 net/core/netpoll.c                                 |   99 +-
 net/core/netprio_cgroup.c                          |   30 +-
 net/core/scm.c                                     |    4 +
 net/core/sock.c                                    |    1 +
 net/dccp/ccid.h                                    |    4 +-
 net/dccp/ccids/ccid3.c                             |    1 +
 net/ipv4/fib_trie.c                                |    2 +-
 net/ipv4/inet_connection_sock.c                    |    7 +-
 net/ipv4/ip_output.c                               |   10 +-
 net/ipv4/ipmr.c                                    |   14 +-
 net/ipv4/netfilter/nf_nat_sip.c                    |   14 +-
 net/ipv4/route.c                                   |   11 +-
 net/ipv4/tcp.c                                     |    4 +-
 net/ipv4/tcp_cong.c                                |    3 +-
 net/ipv4/tcp_input.c                               |   19 +-
 net/ipv4/tcp_ipv4.c                                |   23 +-
 net/ipv4/tcp_metrics.c                             |   12 +
 net/ipv4/tcp_minisocks.c                           |    2 -
 net/ipv4/tcp_output.c                              |   37 +-
 net/ipv4/tcp_timer.c                               |    6 +-
 net/ipv4/udp.c                                     |    2 +-
 net/ipv6/addrconf.c                                |    4 +-
 net/ipv6/esp6.c                                    |    6 +-
 net/ipv6/proc.c                                    |    4 +-
 net/ipv6/tcp_ipv6.c                                |   29 +-
 net/ipv6/xfrm6_policy.c                            |    8 +
 net/l2tp/l2tp_core.c                               |    3 +-
 net/l2tp/l2tp_core.h                               |    1 +
 net/l2tp/l2tp_ip6.c                                |    1 +
 net/llc/af_llc.c                                   |    8 +-
 net/llc/llc_input.c                                |   21 +-
 net/llc/llc_station.c                              |   29 +-
 net/mac80211/mesh.c                                |    3 +
 net/mac80211/mlme.c                                |    2 +
 net/mac80211/scan.c                                |    3 +-
 net/mac80211/tx.c                                  |   38 +-
 net/netfilter/ipvs/ip_vs_ctl.c                     |    5 +-
 net/netfilter/nf_conntrack_core.c                  |   16 +-
 net/netfilter/nf_conntrack_expect.c                |   29 +-
 net/netfilter/nf_conntrack_netlink.c               |   10 +-
 net/netfilter/nf_conntrack_sip.c                   |   92 +-
 net/netfilter/nfnetlink_log.c                      |    6 +-
 net/netlink/af_netlink.c                           |    6 +-
 net/packet/af_packet.c                             |   12 +-
 net/sched/act_gact.c                               |   14 +-
 net/sched/act_ipt.c                                |    7 +-
 net/sched/act_mirred.c                             |   11 +-
 net/sched/act_pedit.c                              |    5 +-
 net/sched/act_simple.c                             |    5 +-
 net/sched/sch_qfq.c                                |   95 +-
 net/socket.c                                       |    5 +-
 net/sunrpc/svc_xprt.c                              |   10 +-
 net/sunrpc/svcsock.c                               |    2 +-
 net/unix/af_unix.c                                 |    4 +-
 net/wireless/core.c                                |    5 +
 net/wireless/core.h                                |    1 +
 net/wireless/reg.c                                 |   19 +-
 net/wireless/util.c                                |    2 +-
 net/xfrm/xfrm_policy.c                             |    2 +
 net/xfrm/xfrm_state.c                              |   25 +-
 scripts/Makefile.fwinst                            |    2 +-
 scripts/checkpatch.pl                              |    3 +-
 scripts/decodecode                                 |    2 +-
 scripts/kernel-doc                                 |    1 +
 scripts/link-vmlinux.sh                            |    2 +-
 security/yama/yama_lsm.c                           |   43 +-
 sound/arm/pxa2xx-ac97.c                            |    4 +-
 sound/atmel/abdac.c                                |    3 +-
 sound/atmel/ac97c.c                                |   14 +-
 sound/core/sgbuf.c                                 |    2 +-
 sound/drivers/aloop.c                              |    2 +-
 sound/drivers/dummy.c                              |    2 +-
 sound/drivers/pcsp/pcsp.c                          |    4 +-
 sound/isa/als100.c                                 |    2 +-
 sound/oss/sb_audio.c                               |    4 +-
 sound/pci/cs46xx/cs46xx_lib.c                      |    2 +-
 sound/pci/ctxfi/ctatc.c                            |    4 +-
 sound/pci/emu10k1/memory.c                         |    5 +-
 sound/pci/hda/hda_auto_parser.c                    |    5 +-
 sound/pci/hda/hda_beep.c                           |   29 +-
 sound/pci/hda/hda_codec.c                          |   83 +-
 sound/pci/hda/hda_codec.h                          |    2 +
 sound/pci/hda/hda_intel.c                          |    9 +
 sound/pci/hda/hda_proc.c                           |    2 +-
 sound/pci/hda/patch_ca0132.c                       |  174 +--
 sound/pci/hda/patch_conexant.c                     |    6 -
 sound/pci/hda/patch_hdmi.c                         |   12 +-
 sound/pci/hda/patch_realtek.c                      |    8 +-
 sound/pci/hda/patch_sigmatel.c                     |   13 +-
 sound/pci/hda/patch_via.c                          |    8 +
 sound/pci/lx6464es/lx6464es.c                      |    2 +
 sound/pci/rme9652/hdspm.c                          |    2 +-
 sound/pci/sis7019.c                                |    5 +-
 sound/ppc/powermac.c                               |    2 +-
 sound/ppc/snd_ps3.c                                |    1 +
 sound/soc/blackfin/bf6xx-sport.c                   |    7 +
 sound/soc/codecs/ab8500-codec.c                    |    4 +
 sound/soc/codecs/ad1980.c                          |    1 +
 sound/soc/codecs/mc13783.c                         |    2 +
 sound/soc/codecs/sgtl5000.c                        |    3 +-
 sound/soc/codecs/stac9766.c                        |    1 +
 sound/soc/codecs/wm5102.c                          |   25 +-
 sound/soc/codecs/wm5110.c                          |   12 +
 sound/soc/codecs/wm8962.c                          |   18 +-
 sound/soc/codecs/wm8994.c                          |   17 +-
 sound/soc/codecs/wm9712.c                          |   22 +-
 sound/soc/codecs/wm9713.c                          |    1 +
 sound/soc/davinci/davinci-mcasp.c                  |   10 +-
 sound/soc/fsl/imx-ssi.c                            |    5 +-
 sound/soc/mxs/Kconfig                              |    2 +-
 sound/soc/mxs/mxs-saif.c                           |   24 +
 sound/soc/omap/mcbsp.c                             |    2 +-
 sound/soc/omap/omap-mcbsp.c                        |    1 +
 sound/soc/omap/omap-pcm.c                          |    1 +
 sound/soc/samsung/pcm.c                            |    2 +-
 sound/soc/soc-core.c                               |   12 +-
 sound/soc/soc-jack.c                               |    2 +-
 sound/soc/tegra/tegra_alc5632.c                    |    2 +-
 sound/soc/tegra/tegra_wm8903.c                     |   10 +-
 sound/soc/ux500/ux500_msp_dai.c                    |    2 +-
 sound/soc/ux500/ux500_msp_i2s.c                    |    2 +-
 sound/soc/ux500/ux500_msp_i2s.h                    |    2 +-
 sound/usb/card.c                                   |    4 +-
 sound/usb/endpoint.c                               |   24 +-
 sound/usb/endpoint.h                               |    3 +-
 sound/usb/pcm.c                                    |   61 +-
 tools/perf/Makefile                                |    7 +-
 tools/perf/builtin-record.c                        |    4 +-
 tools/perf/builtin-report.c                        |    5 +-
 tools/perf/builtin-test.c                          |   19 +-
 tools/perf/builtin-top.c                           |   23 +-
 tools/perf/util/event.h                            |    3 -
 tools/perf/util/evlist.c                           |    7 +
 tools/perf/util/evlist.h                           |    3 +
 tools/perf/util/evsel.c                            |   15 +-
 tools/perf/util/evsel.h                            |   10 +-
 tools/perf/util/header.c                           |    9 +
 tools/perf/util/intlist.c                          |  101 ++
 tools/perf/util/intlist.h                          |   75 +
 tools/perf/util/parse-events-test.c                |   12 +-
 tools/perf/util/parse-options.c                    |    3 +
 tools/perf/util/python-ext-sources                 |    2 +
 tools/perf/util/python.c                           |    6 +-
 tools/perf/util/rblist.c                           |  107 ++
 tools/perf/util/rblist.h                           |   47 +
 tools/perf/util/session.c                          |   48 +-
 tools/perf/util/session.h                          |   24 +-
 tools/perf/util/strlist.c                          |  130 +-
 tools/perf/util/strlist.h                          |   11 +-
 tools/perf/util/symbol.c                           |   14 +-
 tools/perf/util/target.c                           |    2 +-
 virt/kvm/kvm_main.c                                |    7 +-
 1408 files changed, 19410 insertions(+), 11578 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/misc/ifm-csi.txt
 create mode 100644 arch/alpha/include/asm/word-at-a-time.h
 delete mode 100644 arch/alpha/lib/ev6-strncpy_from_user.S
 delete mode 100644 arch/alpha/lib/ev67-strlen_user.S
 delete mode 100644 arch/alpha/lib/strlen_user.S
 delete mode 100644 arch/alpha/lib/strncpy_from_user.S
 create mode 100644 arch/arm/lib/io-readsw-armv3.S
 create mode 100644 arch/arm/lib/io-writesw-armv3.S
 create mode 100644 arch/arm/lib/uaccess.S
 rename arch/arm/mach-imx/{head-v7.S => headsmp.S} (100%)
 create mode 100644 arch/arm/plat-samsung/include/plat/hdmi.h
 delete mode 100644 arch/m68k/include/asm/MC68332.h
 delete mode 100644 arch/m68k/include/asm/apollodma.h
 delete mode 100644 arch/m68k/include/asm/bitsperlong.h
 delete mode 100644 arch/m68k/include/asm/cputime.h
 delete mode 100644 arch/m68k/include/asm/device.h
 delete mode 100644 arch/m68k/include/asm/emergency-restart.h
 delete mode 100644 arch/m68k/include/asm/errno.h
 delete mode 100644 arch/m68k/include/asm/futex.h
 delete mode 100644 arch/m68k/include/asm/ioctl.h
 delete mode 100644 arch/m68k/include/asm/ipcbuf.h
 delete mode 100644 arch/m68k/include/asm/irq_regs.h
 delete mode 100644 arch/m68k/include/asm/kdebug.h
 delete mode 100644 arch/m68k/include/asm/kmap_types.h
 delete mode 100644 arch/m68k/include/asm/kvm_para.h
 delete mode 100644 arch/m68k/include/asm/local.h
 delete mode 100644 arch/m68k/include/asm/local64.h
 delete mode 100644 arch/m68k/include/asm/mac_mouse.h
 delete mode 100644 arch/m68k/include/asm/mcfmbus.h
 delete mode 100644 arch/m68k/include/asm/mman.h
 delete mode 100644 arch/m68k/include/asm/mutex.h
 delete mode 100644 arch/m68k/include/asm/percpu.h
 delete mode 100644 arch/m68k/include/asm/resource.h
 delete mode 100644 arch/m68k/include/asm/sbus.h
 delete mode 100644 arch/m68k/include/asm/scatterlist.h
 delete mode 100644 arch/m68k/include/asm/sections.h
 delete mode 100644 arch/m68k/include/asm/shm.h
 delete mode 100644 arch/m68k/include/asm/siginfo.h
 delete mode 100644 arch/m68k/include/asm/statfs.h
 delete mode 100644 arch/m68k/include/asm/topology.h
 delete mode 100644 arch/m68k/include/asm/types.h
 delete mode 100644 arch/m68k/include/asm/xor.h
 create mode 100644 arch/powerpc/boot/dts/fsl/e500mc_power_isa.dtsi
 create mode 100644 arch/powerpc/boot/dts/fsl/e500v2_power_isa.dtsi
 create mode 100644 arch/powerpc/boot/dts/fsl/e5500_power_isa.dtsi
 create mode 100644 arch/powerpc/boot/dts/fsl/p5040si-post.dtsi
 create mode 100644 arch/powerpc/boot/dts/fsl/p5040si-pre.dtsi
 create mode 100644 arch/powerpc/boot/dts/fsl/qoriq-sec5.2-0.dtsi
 create mode 100644 arch/powerpc/boot/dts/o2d.dts
 create mode 100644 arch/powerpc/boot/dts/o2d.dtsi
 create mode 100644 arch/powerpc/boot/dts/o2d300.dts
 create mode 100644 arch/powerpc/boot/dts/o2dnt2.dts
 create mode 100644 arch/powerpc/boot/dts/o2i.dts
 create mode 100644 arch/powerpc/boot/dts/o2mnt.dts
 create mode 100644 arch/powerpc/boot/dts/o3dnt.dts
 delete mode 100644 arch/powerpc/boot/dts/p1020rdb_camp_core0.dts
 delete mode 100644 arch/powerpc/boot/dts/p1020rdb_camp_core1.dts
 create mode 100644 arch/powerpc/boot/dts/p1022rdk.dts
 delete mode 100644 arch/powerpc/boot/dts/p2020rdb_camp_core0.dts
 delete mode 100644 arch/powerpc/boot/dts/p2020rdb_camp_core1.dts
 create mode 100644 arch/powerpc/boot/dts/p5040ds.dts
 delete mode 100644 arch/powerpc/include/asm/abs_addr.h
 create mode 100644 arch/powerpc/include/asm/probes.h
 create mode 100644 arch/powerpc/include/asm/uprobes.h
 create mode 100644 arch/powerpc/kernel/uprobes.c
 create mode 100644 arch/powerpc/platforms/85xx/p1022_rdk.c
 create mode 100644 arch/powerpc/platforms/85xx/p5040_ds.c
 create mode 100644 arch/powerpc/platforms/pseries/eeh_pe.c
 create mode 100644 arch/powerpc/sysdev/fsl_mpic_err.c
 create mode 100644 drivers/vhost/Kconfig.tcm
 create mode 100644 drivers/vhost/tcm_vhost.c
 create mode 100644 drivers/vhost/tcm_vhost.h
 create mode 100644 tools/perf/util/intlist.c
 create mode 100644 tools/perf/util/intlist.h
 create mode 100644 tools/perf/util/rblist.c
 create mode 100644 tools/perf/util/rblist.h


