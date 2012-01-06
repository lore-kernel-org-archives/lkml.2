Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758592Ab2AFDmu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jan 2012 22:42:50 -0500
Received: from gate.crashing.org ([63.228.1.57]:35722 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758144Ab2AFDmr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jan 2012 22:42:47 -0500
Message-ID: <1325821347.23910.28.camel@pasglop>
Subject: [git pull] Please pull powerpc.git next branch
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linuxppc-dev list <linuxppc-dev@ozlabs.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel list <linux-kernel@vger.kernel.org>
Date: Fri, 06 Jan 2012 14:42:27 +1100
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus !

Here's my powerpc batch for this merge window. In addition to the usual
mixed bag of small fixes & improvements, the bigger highlights are:

 - Reworked the freescale .dts (device-tree) files to use the new
".dtsi" include mechanism so board files just include the SoC definition
rather than duplicating it
 - cpuidle framework support on pseries
 - Various time management fixes & cleanups
 - hugetlb support for FSL BookE embedded chips
 - p7ioc IO chip support for powernv platform
 - Cleanup of MPIC init code

And I'm probably forgetting some...

Cheers,
Ben.


The following changes since commit caca6a03d365883564885f2c1da3e88dcf65d139:

  Linux 3.2-rc3 (2011-11-23 20:20:28 -0800)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/benh/powerpc.git next

Alexandre Rusev (1):
      powerpc/fsl-lbc: Fix for fsl_upm

Ananth N Mavinakayanahalli (1):
      powerpc: Export PIR data through sysfs

Andreas Schwab (1):
      powerpc: Fix wrong divisor in usecs_to_cputime

Andy Fleming (1):
      powerpc: Add TBI PHY node to first MDIO bus

Anton Blanchard (22):
      powerpc/time: Handle wrapping of decrementer
      powerpc/time: Use clockevents_calc_mult_shift
      powerpc/time: Use clocksource_register_hz
      powerpc/time: Remove unnecessary sanity check of decrementer expiration
      powerpc/time: Fix some style issues
      powerpc/time: Optimise decrementer_check_overflow
      powerpc: Decode correct MSR bits in oops output
      powerpc/xics: Harden xics hypervisor backend
      powerpc: Give us time to get all oopses out before panicking
      powerpc: Remove broken and complicated kdump system reset code
      powerpc/kdump: Use setjmp/longjmp to handle kdump and system reset recursion
      powerpc: Cleanup crash/kexec code
      powerpc: Rework die()
      powerpc: Reduce pseries panic timeout from 180s to 10s
      powerpc/xics: Reset the CPPR if H_EOI fails
      powerpc/kdump: Delay before sending IPI on a system reset
      powerpc/kdump: Only save CPU state first time through the secondary CPU capture code
      powerpc/pseries: Increase minimum RMO size from 64MB to 256MB
      powerpc/nvram: Add spinlock to oops_to_nvram to prevent oops in compression code.
      powerpc: Enable squashfs as a module
      powerpc: POWER7 optimised copy_to_user/copy_from_user using VMX
      powerpc: Fix comment explaining our VSID layout

Becky Bruce (13):
      powerpc: Only define HAVE_ARCH_HUGETLB_UNMAPPED_AREA if PPC_MM_SLICES
      powerpc: hugetlb: fix huge_ptep_set_access_flags return value
      powerpc: Fix booke hugetlb preload code for PPC_MM_SLICES and 64-bit
      powerpc: Update hugetlb huge_pte_alloc and tablewalk code for FSL BOOKE
      powerpc: hugetlb: modify include usage for FSL BookE code
      powerpc: Whitespace/comment changes to tlb_low_64e.S
      powerpc: Add hugepage support to 64-bit tablewalk code for FSL_BOOK3E
      powerpc: Add gpages reservation code for 64-bit FSL BOOKE
      powerpc: Kconfig updates for FSL BookE HUGETLB 64-bit
      powerpc: Enable Hugetlb by default for 32-bit 85xx/corenet
      powerpc: Enable hugetlb by default for corenet64 platforms
      powerpc/book3e: Change hugetlb preload to take vma argument
      powerpc: Define/use HUGETLB_NEED_PRELOAD insead of complicated #if

Benjamin Herrenschmidt (24):
      powerpc/pci: Add a platform hook after probe and before resource survey
      powerpc/pci: Change how re-assigning resouces work
      powerpc/powernv: Add TCE SW invalidation support
      powerpc/powernv: Fixup p7ioc PCIe root complex class code
      powerpc/powernv: PCI support for p7IOC under OPAL v2
      Merge remote-tracking branch 'kumar/next' into next
      powerpc/powernv: Update OPAL interfaces
      powerpc/powernv: Display diag data on p7ioc EEH errors
      powerpc/powernv: Workaround OFW issues in prom_init.c
      powerpc/pci: Make pci_read_irq_line() static
      Merge branch 'mpic' into next
      Merge branch 'booke-hugetlb' into next
      powerpc: Add support for OpenBlockS 600
      Merge branch 'cpuidle' into next
      Merge branch 'ps3' into next
      Merge branch 'kexec' into next
      tty/serial/pmac_zilog: Fix suspend & resume
      powerpc/pmac: Simplify old pmac PIC interrupt handling
      powerpc/pmac: Fix SMP kernels on pre-core99 UP machines
      Merge remote-tracking branch 'jwb/next' into next
      powerpc: Fix old bug in prom_init setting of the color
      offb: Fix bug in calculating requested vram size
      offb: Add palette hack for qemu "standard vga" framebuffer
      offb: Fix setting of the pseudo-palette for >8bpp
po
Christoph Egger (1):
      powerpc/44x: Removing dead CONFIG_PPC47x

Chuck Meade (1):
      drivers/serial/ucc_uart.c: Add missing call to init UCC UART port timeout

Dan McGee (1):
      powerpc+sparc64/mm: Remove hack in mmap randomize layout

David Rientjes (2):
      powerpc/mm: Fix section mismatch for mark_reserved_regions_for_nid
      powerpc/mm: Fix section mismatch for read_n_cells

Deepthi Dharwar (4):
      powerpc/cpuidle: Add cpu_idle_wait() to allow switching of idle routines
      powerpc/cpuidle: cpuidle driver for pSeries
      powerpc/cpuidle: Enable cpuidle and directly call cpuidle_idle_call() for pSeries
      powerpc/cpuidle: Handle power_save=off

Dmitry Eremin-Solenikov (7):
      powerpc/83xx: consolidate init_IRQ functions
      powerpc/83xx: consolidate of_platform_bus_probe calls
      powerpc/83xx: merge PCI bridge additions
      powerpc/83xx: make mpc830x_rdb use mpc83xx_setup_pci
      powerpc/85xx: separate cpm2 pic init
      powerpc/85xx: consolidate of_platform_bus_probe calls
      powerpc/maple: Enable access to HT Host-Bridge on Maple

Finn Thain (1):
      pmac_zilog: Fix unexpected irq

Florian Fainelli (1):
      perf/powerpc: Fix build for PowerPC with uclibc toolchains

Geoff Levand (8):
      powerpc/ps3: Interrupt code cleanup
      powerpc/ps3: Fix hcall lv1_net_stop_rx_dma
      powerpc/ps3: Fix hcall lv1_get_virtual_address_space_id_of_ppe
      powerpc/ps3: Fix hcall lv1_get_version_info
      powerpc/ps3: Fix hcall lv1_read_repository_node
      powerpc/ps3: Fix PS3 repository build warnings
      powerpc/ps3: Add __init to ps3_smp_probe
      powerpc/ps3: Update ps3_defconfig

Geoff Thorpe (1):
      powerpc: Add pgprot_cached_noncoherent()

Jason Jin (1):
      powerpc/fsl-pci: Don't hide resource for pci/e when configured as Agent/EP

Jia Hongtao (1):
      powerpc/85xx: Add lbc suspend support for PM

Jimi Xenidis (6):
      powerpc: Split ICSWX ACOP and PID processing
      powerpc/book3e: Add ICSWX/ACOP support to Book3e cores like A2
      powerpc/icswx: Simple ACOP fault handler
      powerpc/xmon: Fix the 'u' command description
      powerpc/xmon: Fix #if typo for systems without MSR[RI]
      powerpc/book3e: Add Chroma as a new WSP/PowerEN platform.

Joakim Tjernlund (1):
      powerpc/qe: Fixup QE_General4 errata

Josh Boyer (2):
      MAINTAINERS: Update PowerPC 4xx git tree
      powerpc/44x: Fix build error on currituck platform

Julia Lawall (4):
      arch/powerpc/sysdev/ehv_pic.c: add missing kfree
      powerpc/cell/iommu: Add missing of_node_put
      powerpc/powermac: Add missing of_node_put
      arch/powerpc/sysdev/fsl_rmu.c: introduce missing kfree

Justin P. Mattock (1):
      powerpc/mpic: Remove extra semicolon.

Kai Jiang (1):
      powerpc/8xxx: Update device tree bus probe for new RapidIO node binding

Kumar Gala (36):
      powerpc/85xx: Fix compile error on p3060_qds.c
      powerpc/85xx: Simplify P1020RDB CAMP dts using includes
      powerpc/85xx: Rework PCI nodes on P1020RDB
      powerpc/85xx: Update SPI binding to match binding spec for P1020RDB
      powerpc/85xx: Update P1020 SEC3.3 node to match actual SoC HW
      powerpc/85xx: Add ethernet magic packet property to P1020 device tree
      powerpc/85xx: p1020si.dtsi update interrupt handling
      powerpc/85xx: create dts components to build up an SoC
      powerpc/85xx: Rework MPC8536DS device trees
      powerpc/85xx: Rework MPC8544DS device tree
      powerpc/85xx: Rework MPC8548CDS device trees
      powerpc/85xx: Rework MPC8568MDS device tree
      powerpc/85xx: Rework MPC8569MDS device tree
      powerpc/85xx: Rework MPC8572DS device tree
      powerpc/85xx: Rework P1010RDB and P1010 device tree
      powerpc/85xx: Add RTC to P1010RDB device tree
      powerpc/85xx: Add crypto engine to P1010 SoC device tree
      powerpc/85xx: Add a P1010RDB 36-bit address map device tree
      powerpc/85xx: Rework P1020RDB device tree
      powerpc/85xx: Add P1020RDB 36-bit address map device tree
      powerpc/85xx: Rework P1021MDS device tree
      powerpc/85xx: Rework P1022DS device tree
      powerpc/85xx: Rework P1023RDS device tree
      powerpc/85xx: Rework P2020DS device tree
      powerpc/85xx: Rework P2020RDB device tree
      powerpc/85xx: Rework P2041RDB device tree
      powerpc/85xx: Rework P3041DS device tree
      powerpc/85xx: Rework P3060QDS device tree
      powerpc/85xx: Rework P4080DS device trees
      powerpc/85xx: Rework P5020DS device tree
      powerpc/85xx: Update SRIO device tree nodes
      powerpc/85xx: Additional consolidate of_platform_bus_probe calls
      powerpc/85xx: Renamed mpc85xx_common.c to common.c
      powerpc/fsl-pci: Allow 64-bit PCIe devices to DMA to any memory address
      powerpc/fsl: Update defconfigs to enable some standard FSL HW features
      powerpc/fsl: update compatiable on fsl 16550 uart nodes

Kyle Moffett (10):
      powerpc/85xx: Move mpc85xx_smp_init() decl to a new "smp.h"
      powerpc: Consolidate mpic_alloc() OF address translation
      powerpc/mpic: Assume a device-node was passed in mpic_alloc()
      powerpc/mpic: Save computed phys_addr for board-specific code
      powerpc/mpic: Search for open-pic device-tree node if NULL
      powerpc/mpic: Invert the meaning of MPIC_PRIMARY
      powerpc/mpic: Don't open-code dcr_resource_start
      powerpc/mpic: Put "pic-no-reset" test back into the MPIC code
      powerpc/mpic: Cache the device-tree node in "struct mpic"
      powerpc/mpic: Add in-core support for cascaded MPICs

Li Zhong (1):
      powerpc: Fix unpaired probe_hcall_entry and probe_hcall_exit

Liu Gang (3):
      powerpc/fsl: Document rapidio node binding-information
      fsl-rio: Split rio driver into two parts, RapidIO endpoint and message unit
      fsl-rio: Add two ports and rapidio message units support

Matt Evans (1):
      powerpc: Add __SANE_USERSPACE_TYPES__ to asm/types.h for LL64

Matthew McClintock (1):
      arch/powerpc: Remove duplicate/redundant Altivec entries

Michael Neuling (1):
      powerpc: fix compile error with 85xx/p1023_rds.c

Milton Miller (1):
      powerpc/pseries: Software invalidatation of TCEs

Paul Bolle (1):
      powerpc/p3060qds: Fix select of 'MPC8xxx_GPIO'

Paul Gortmaker (1):
      sbc834x: put full compat string in board match check

Paul Mackerras (3):
      powerpc/powernv: Fix problems in onlining CPUs
      powerpc: Provide a way for KVM to indicate that NV GPR values are lost
      powerpc: Only use initrd_end as the limit for alloc_bottom if it's inside the RMO.

Prabhakar Kushwaha (1):
      powerpc/fsl: Add support for Integrated Flash Controller

Ravi K. Nittala (1):
      powerpc/pseries: Cancel RTAS event scan before firmware flash

Richard Kuo (1):
      powerpc: Use rwsem.h from generic location

Roy Zang (1):
      powerpc/p1023: set IRQ[4:6,11] to active-high level sensitive for PCIe

Shaohui Xie (1):
      drivers/edac/mpc85xx_edac.c: fix memory controller compatible for edac

Suzuki Poulose (8):
      powerpc: Rename mapping based RELOCATABLE to DYNAMIC_MEMSTART for BookE
      powerpc/44x: Enable DYNAMIC_MEMSTART for 440x
      powerpc: Process dynamic relocations for kernel
      powerpc: Define virtual-physical translations for RELOCATABLE
      powerpc/44x: Enable CONFIG_RELOCATABLE for PPC44x
      powerpc/44x: Enable CRASH_DUMP for 440x
      powerpc/boot: Change the load address for the wrapper to fit the kernel
      powerpc/boot: Change the WARN to INFO for boot wrapper overlap message

Tanmay Inamdar (1):
      powerpc/40x: Add APM8018X SOC support

Thomas Gleixner (4):
      powerpc/85xx: Mark cascade irq IRQF_NO_THREAD
      powerpc/wsp: Mark opb cascade handler IRQF_NO_THREAD
      powerpc: Mark IPI interrupts IRQF_NO_THREAD
      powerpc: Allow irq threading

Timur Tabi (5):
      powerpc/85xx: add pixis indirect mode device tree node
      powerpc/fsl_msi: add support for the fsl, msi property in PCI nodes
      powerpc/85xx: re-enable ePAPR byte channel driver in corenet32_smp_defconfig
      powerpc/85xx: fix PCI and localbus properties in p1022ds.dts
      powerpc/fsl: add MSI support for the Freescale hypervisor

Tony Breeds (8):
      powerpc/44x: pci: Use PCI_BASE_ADDRESS_MEM_PREFETCH rather than magic value.
      powerpc/44x: pci: Add a want_sdr flag into ppc4xx_pciex_hwops
      powerpc/44x: pci: Setup the dma_window properties for each pci_controller
      powerpc/boot: Add extended precision shifts to the boot wrapper.
      powerpc/boot: Add mfdcrx
      powerpc/476fpe: Add 476fpe SoC code
      powerpc/47x: Add support for the new IBM currituck platform
      powerpc: fix compile error with 85xx/p1010rdb.c

sukadev@linux.vnet.ibm.com (2):
      powerpc: Implement CONFIG_STRICT_DEVMEM
      powerpc: Punch a hole in /dev/mem for librtas

 .../devicetree/bindings/powerpc/fsl/srio-rmu.txt   |  163 +++
 .../devicetree/bindings/powerpc/fsl/srio.txt       |  103 ++
 MAINTAINERS                                        |    2 +-
 arch/powerpc/Kconfig                               |   54 +-
 arch/powerpc/Kconfig.debug                         |   12 +
 arch/powerpc/Makefile                              |   11 +-
 arch/powerpc/boot/Makefile                         |   12 +-
 arch/powerpc/boot/dcr.h                            |    6 +
 arch/powerpc/boot/div64.S                          |   52 +
 arch/powerpc/boot/dts/asp834x-redboot.dts          |    4 +-
 arch/powerpc/boot/dts/currituck.dts                |  237 +++
 arch/powerpc/boot/dts/fsl/mpc8536si-post.dtsi      |  248 ++++
 arch/powerpc/boot/dts/fsl/mpc8536si-pre.dtsi       |   63 +
 arch/powerpc/boot/dts/fsl/mpc8544si-post.dtsi      |  191 +++
 arch/powerpc/boot/dts/fsl/mpc8544si-pre.dtsi       |   63 +
 arch/powerpc/boot/dts/fsl/mpc8548si-post.dtsi      |  143 ++
 arch/powerpc/boot/dts/fsl/mpc8548si-pre.dtsi       |   62 +
 arch/powerpc/boot/dts/fsl/mpc8568si-post.dtsi      |  270 ++++
 arch/powerpc/boot/dts/fsl/mpc8568si-pre.dtsi       |   65 +
 arch/powerpc/boot/dts/fsl/mpc8569si-post.dtsi      |  304 ++++
 arch/powerpc/boot/dts/fsl/mpc8569si-pre.dtsi       |   64 +
 arch/powerpc/boot/dts/fsl/mpc8572si-post.dtsi      |  196 +++
 arch/powerpc/boot/dts/fsl/mpc8572si-pre.dtsi       |   70 +
 arch/powerpc/boot/dts/fsl/p1010si-post.dtsi        |  198 +++
 arch/powerpc/boot/dts/fsl/p1010si-pre.dtsi         |   64 +
 arch/powerpc/boot/dts/fsl/p1020si-post.dtsi        |  174 +++
 arch/powerpc/boot/dts/fsl/p1020si-pre.dtsi         |   68 +
 arch/powerpc/boot/dts/fsl/p1021si-post.dtsi        |  225 +++
 arch/powerpc/boot/dts/fsl/p1021si-pre.dtsi         |   68 +
 arch/powerpc/boot/dts/fsl/p1022si-post.dtsi        |  235 +++
 arch/powerpc/boot/dts/fsl/p1022si-pre.dtsi         |   68 +
 arch/powerpc/boot/dts/fsl/p1023si-post.dtsi        |  224 +++
 arch/powerpc/boot/dts/fsl/p1023si-pre.dtsi         |   76 +
 arch/powerpc/boot/dts/fsl/p2020si-post.dtsi        |  194 +++
 arch/powerpc/boot/dts/fsl/p2020si-pre.dtsi         |   69 +
 arch/powerpc/boot/dts/fsl/p2041si-post.dtsi        |  325 +++++
 arch/powerpc/boot/dts/fsl/p2041si-pre.dtsi         |  111 ++
 arch/powerpc/boot/dts/fsl/p3041si-post.dtsi        |  352 +++++
 arch/powerpc/boot/dts/fsl/p3041si-pre.dtsi         |  112 ++
 arch/powerpc/boot/dts/fsl/p3060si-post.dtsi        |  296 ++++
 arch/powerpc/boot/dts/fsl/p3060si-pre.dtsi         |  125 ++
 arch/powerpc/boot/dts/fsl/p4080si-post.dtsi        |  350 +++++
 arch/powerpc/boot/dts/fsl/p4080si-pre.dtsi         |  143 ++
 arch/powerpc/boot/dts/fsl/p5020si-post.dtsi        |  355 +++++
 arch/powerpc/boot/dts/fsl/p5020si-pre.dtsi         |   96 ++
 arch/powerpc/boot/dts/fsl/pq3-dma-0.dtsi           |   66 +
 arch/powerpc/boot/dts/fsl/pq3-dma-1.dtsi           |   66 +
 arch/powerpc/boot/dts/fsl/pq3-duart-0.dtsi         |   51 +
 arch/powerpc/boot/dts/fsl/pq3-esdhc-0.dtsi         |   41 +
 arch/powerpc/boot/dts/fsl/pq3-espi-0.dtsi          |   41 +
 arch/powerpc/boot/dts/fsl/pq3-etsec1-0.dtsi        |   53 +
 arch/powerpc/boot/dts/fsl/pq3-etsec1-1.dtsi        |   53 +
 arch/powerpc/boot/dts/fsl/pq3-etsec1-2.dtsi        |   53 +
 arch/powerpc/boot/dts/fsl/pq3-etsec1-3.dtsi        |   53 +
 arch/powerpc/boot/dts/fsl/pq3-etsec1-timer-0.dtsi  |   39 +
 arch/powerpc/boot/dts/fsl/pq3-etsec2-0.dtsi        |   60 +
 arch/powerpc/boot/dts/fsl/pq3-etsec2-1.dtsi        |   60 +
 arch/powerpc/boot/dts/fsl/pq3-etsec2-2.dtsi        |   59 +
 arch/powerpc/boot/dts/fsl/pq3-etsec2-grp2-0.dtsi   |   42 +
 arch/powerpc/boot/dts/fsl/pq3-etsec2-grp2-1.dtsi   |   42 +
 arch/powerpc/boot/dts/fsl/pq3-etsec2-grp2-2.dtsi   |   42 +
 arch/powerpc/boot/dts/fsl/pq3-gpio-0.dtsi          |   41 +
 arch/powerpc/boot/dts/fsl/pq3-i2c-0.dtsi           |   43 +
 arch/powerpc/boot/dts/fsl/pq3-i2c-1.dtsi           |   43 +
 arch/powerpc/boot/dts/fsl/pq3-mpic-timer-B.dtsi    |   42 +
 arch/powerpc/boot/dts/fsl/pq3-mpic.dtsi            |   66 +
 arch/powerpc/boot/dts/fsl/pq3-rmu-0.dtsi           |   68 +
 arch/powerpc/boot/dts/fsl/pq3-sata2-0.dtsi         |   40 +
 arch/powerpc/boot/dts/fsl/pq3-sata2-1.dtsi         |   40 +
 arch/powerpc/boot/dts/fsl/pq3-sec2.1-0.dtsi        |   43 +
 arch/powerpc/boot/dts/fsl/pq3-sec3.0-0.dtsi        |   45 +
 arch/powerpc/boot/dts/fsl/pq3-sec3.1-0.dtsi        |   45 +
 arch/powerpc/boot/dts/fsl/pq3-sec3.3-0.dtsi        |   45 +
 arch/powerpc/boot/dts/fsl/pq3-sec4.4-0.dtsi        |   65 +
 arch/powerpc/boot/dts/fsl/pq3-usb2-dr-0.dtsi       |   41 +
 arch/powerpc/boot/dts/fsl/pq3-usb2-dr-1.dtsi       |   41 +
 arch/powerpc/boot/dts/fsl/qoriq-dma-0.dtsi         |   66 +
 arch/powerpc/boot/dts/fsl/qoriq-dma-1.dtsi         |   66 +
 arch/powerpc/boot/dts/fsl/qoriq-duart-0.dtsi       |   51 +
 arch/powerpc/boot/dts/fsl/qoriq-duart-1.dtsi       |   51 +
 arch/powerpc/boot/dts/fsl/qoriq-esdhc-0.dtsi       |   40 +
 arch/powerpc/boot/dts/fsl/qoriq-espi-0.dtsi        |   41 +
 arch/powerpc/boot/dts/fsl/qoriq-gpio-0.dtsi        |   41 +
 arch/powerpc/boot/dts/fsl/qoriq-i2c-0.dtsi         |   53 +
 arch/powerpc/boot/dts/fsl/qoriq-i2c-1.dtsi         |   53 +
 arch/powerpc/boot/dts/fsl/qoriq-mpic.dtsi          |  106 ++
 arch/powerpc/boot/dts/fsl/qoriq-rmu-0.dtsi         |   68 +
 arch/powerpc/boot/dts/fsl/qoriq-sata2-0.dtsi       |   39 +
 arch/powerpc/boot/dts/fsl/qoriq-sata2-1.dtsi       |   39 +
 arch/powerpc/boot/dts/fsl/qoriq-sec4.0-0.dtsi      |  100 ++
 arch/powerpc/boot/dts/fsl/qoriq-sec4.1-0.dtsi      |  109 ++
 arch/powerpc/boot/dts/fsl/qoriq-sec4.2-0.dtsi      |  109 ++
 arch/powerpc/boot/dts/fsl/qoriq-usb2-dr-0.dtsi     |   41 +
 arch/powerpc/boot/dts/fsl/qoriq-usb2-mph-0.dtsi    |   41 +
 arch/powerpc/boot/dts/gef_ppc9a.dts                |    4 +-
 arch/powerpc/boot/dts/gef_sbc310.dts               |    4 +-
 arch/powerpc/boot/dts/gef_sbc610.dts               |    4 +-
 arch/powerpc/boot/dts/klondike.dts                 |  227 +++
 arch/powerpc/boot/dts/kmeter1.dts                  |    2 +-
 arch/powerpc/boot/dts/kuroboxHD.dts                |    4 +-
 arch/powerpc/boot/dts/kuroboxHG.dts                |    4 +-
 arch/powerpc/boot/dts/mpc8308_p1m.dts              |    4 +-
 arch/powerpc/boot/dts/mpc8308rdb.dts               |    4 +-
 arch/powerpc/boot/dts/mpc8313erdb.dts              |    4 +-
 arch/powerpc/boot/dts/mpc8315erdb.dts              |    4 +-
 arch/powerpc/boot/dts/mpc832x_mds.dts              |    4 +-
 arch/powerpc/boot/dts/mpc832x_rdb.dts              |    4 +-
 arch/powerpc/boot/dts/mpc8349emitx.dts             |    4 +-
 arch/powerpc/boot/dts/mpc8349emitxgp.dts           |    4 +-
 arch/powerpc/boot/dts/mpc834x_mds.dts              |    4 +-
 arch/powerpc/boot/dts/mpc836x_mds.dts              |    4 +-
 arch/powerpc/boot/dts/mpc836x_rdk.dts              |    4 +-
 arch/powerpc/boot/dts/mpc8377_mds.dts              |    4 +-
 arch/powerpc/boot/dts/mpc8377_rdb.dts              |    4 +-
 arch/powerpc/boot/dts/mpc8377_wlan.dts             |    4 +-
 arch/powerpc/boot/dts/mpc8378_mds.dts              |    4 +-
 arch/powerpc/boot/dts/mpc8378_rdb.dts              |    4 +-
 arch/powerpc/boot/dts/mpc8379_mds.dts              |    4 +-
 arch/powerpc/boot/dts/mpc8379_rdb.dts              |    4 +-
 arch/powerpc/boot/dts/mpc8536ds.dts                |  456 +------
 arch/powerpc/boot/dts/mpc8536ds.dtsi               |  141 ++
 arch/powerpc/boot/dts/mpc8536ds_36b.dts            |  410 +-----
 arch/powerpc/boot/dts/mpc8540ads.dts               |    4 +-
 arch/powerpc/boot/dts/mpc8541cds.dts               |    4 +-
 arch/powerpc/boot/dts/mpc8544ds.dts                |  473 +------
 arch/powerpc/boot/dts/mpc8544ds.dtsi               |  161 +++
 arch/powerpc/boot/dts/mpc8548cds.dts               |  505 ++-----
 arch/powerpc/boot/dts/mpc8555cds.dts               |    4 +-
 arch/powerpc/boot/dts/mpc8568mds.dts               |  482 +------
 arch/powerpc/boot/dts/mpc8569mds.dts               |  414 +-----
 arch/powerpc/boot/dts/mpc8572ds.dts                |  757 +----------
 arch/powerpc/boot/dts/mpc8572ds.dtsi               |  397 +++++
 arch/powerpc/boot/dts/mpc8572ds_36b.dts            |  746 +----------
 arch/powerpc/boot/dts/mpc8572ds_camp_core0.dts     |  487 +------
 arch/powerpc/boot/dts/mpc8572ds_camp_core1.dts     |  245 +---
 arch/powerpc/boot/dts/mpc8610_hpcd.dts             |    4 +-
 arch/powerpc/boot/dts/mpc8641_hpcn.dts             |   73 +-
 arch/powerpc/boot/dts/mpc8641_hpcn_36b.dts         |    4 +-
 arch/powerpc/boot/dts/obs600.dts                   |  314 ++++
 arch/powerpc/boot/dts/p1010rdb.dts                 |  228 +---
 arch/powerpc/boot/dts/p1010rdb.dtsi                |  234 +++
 arch/powerpc/boot/dts/p1010rdb_36b.dts             |   89 ++
 arch/powerpc/boot/dts/p1010si.dtsi                 |  374 -----
 arch/powerpc/boot/dts/p1020rdb.dts                 |  262 +----
 arch/powerpc/boot/dts/p1020rdb.dtsi                |  247 ++++
 arch/powerpc/boot/dts/p1020rdb_36b.dts             |   66 +
 arch/powerpc/boot/dts/p1020rdb_camp_core0.dts      |  154 +--
 arch/powerpc/boot/dts/p1020rdb_camp_core1.dts      |   11 +-
 arch/powerpc/boot/dts/p1020si.dtsi                 |  377 -----
 arch/powerpc/boot/dts/p1021mds.dts                 |  425 +-----
 arch/powerpc/boot/dts/p1022ds.dts                  |  459 +------
 arch/powerpc/boot/dts/p1023rds.dts                 |  383 +-----
 arch/powerpc/boot/dts/p2020ds.dts                  |  353 +-----
 arch/powerpc/boot/dts/p2020ds.dtsi                 |  316 ++++
 arch/powerpc/boot/dts/p2020rdb.dts                 |   71 +-
 arch/powerpc/boot/dts/p2020rdb_camp_core0.dts      |  141 +--
 arch/powerpc/boot/dts/p2020rdb_camp_core1.dts      |  107 +--
 arch/powerpc/boot/dts/p2020si.dtsi                 |  382 -----
 arch/powerpc/boot/dts/p2041rdb.dts                 |   22 +-
 arch/powerpc/boot/dts/p2041si.dtsi                 |  692 ---------
 arch/powerpc/boot/dts/p3041ds.dts                  |   23 +-
 arch/powerpc/boot/dts/p3041si.dtsi                 |  729 ----------
 arch/powerpc/boot/dts/p3060qds.dts                 |   12 +-
 arch/powerpc/boot/dts/p3060si.dtsi                 |  719 ---------
 arch/powerpc/boot/dts/p4080ds.dts                  |   24 +-
 arch/powerpc/boot/dts/p4080si.dtsi                 |  755 ----------
 arch/powerpc/boot/dts/p5020ds.dts                  |   24 +-
 arch/powerpc/boot/dts/p5020si.dtsi                 |  716 ---------
 arch/powerpc/boot/dts/sbc8349.dts                  |    4 +-
 arch/powerpc/boot/dts/sbc8548.dts                  |    4 +-
 arch/powerpc/boot/dts/sbc8641d.dts                 |    4 +-
 arch/powerpc/boot/dts/socrates.dts                 |    4 +-
 arch/powerpc/boot/dts/storcenter.dts               |    4 +-
 arch/powerpc/boot/dts/stxssa8555.dts               |    4 +-
 arch/powerpc/boot/dts/tqm8540.dts                  |    4 +-
 arch/powerpc/boot/dts/tqm8541.dts                  |    4 +-
 arch/powerpc/boot/dts/tqm8548-bigflash.dts         |    4 +-
 arch/powerpc/boot/dts/tqm8548.dts                  |    4 +-
 arch/powerpc/boot/dts/tqm8555.dts                  |    4 +-
 arch/powerpc/boot/dts/xcalibur1501.dts             |    4 +-
 arch/powerpc/boot/dts/xpedite5200.dts              |    4 +-
 arch/powerpc/boot/dts/xpedite5200_xmon.dts         |    4 +-
 arch/powerpc/boot/dts/xpedite5301.dts              |    4 +-
 arch/powerpc/boot/dts/xpedite5330.dts              |    4 +-
 arch/powerpc/boot/dts/xpedite5370.dts              |    4 +-
 arch/powerpc/boot/treeboot-currituck.c             |  119 ++
 arch/powerpc/boot/wrapper                          |   45 +-
 arch/powerpc/configs/40x/klondike_defconfig        |   55 +
 arch/powerpc/configs/40x/obs600_defconfig          |   83 ++
 arch/powerpc/configs/44x/currituck_defconfig       |  110 ++
 arch/powerpc/configs/44x/iss476-smp_defconfig      |    3 +-
 arch/powerpc/configs/chroma_defconfig              |  307 ++++
 arch/powerpc/configs/corenet32_smp_defconfig       |   11 +-
 arch/powerpc/configs/corenet64_smp_defconfig       |    4 +-
 arch/powerpc/configs/mpc85xx_defconfig             |   17 +-
 arch/powerpc/configs/mpc85xx_smp_defconfig         |   18 +-
 arch/powerpc/configs/ppc64_defconfig               |    5 +
 arch/powerpc/configs/ps3_defconfig                 |   39 +-
 arch/powerpc/configs/pseries_defconfig             |    5 +
 arch/powerpc/include/asm/Kbuild                    |    2 +
 arch/powerpc/include/asm/cputable.h                |    5 +-
 arch/powerpc/include/asm/cputime.h                 |    6 +-
 arch/powerpc/include/asm/fsl_ifc.h                 |  834 +++++++++++
 arch/powerpc/include/asm/fsl_lbc.h                 |    7 +-
 arch/powerpc/include/asm/hugetlb.h                 |   38 +-
 arch/powerpc/include/asm/kdump.h                   |    4 +-
 arch/powerpc/include/asm/kexec.h                   |    7 -
 arch/powerpc/include/asm/lv1call.h                 |   10 +-
 arch/powerpc/include/asm/machdep.h                 |    3 +
 arch/powerpc/include/asm/mmu-book3e.h              |   11 +
 arch/powerpc/include/asm/mmu-hash64.h              |    7 +-
 arch/powerpc/include/asm/mpic.h                    |   14 +-
 arch/powerpc/include/asm/opal.h                    |  131 ++-
 arch/powerpc/include/asm/paca.h                    |    1 +
 arch/powerpc/include/asm/page.h                    |   90 ++-
 arch/powerpc/include/asm/page_64.h                 |    2 +
 arch/powerpc/include/asm/pci-bridge.h              |    6 +-
 arch/powerpc/include/asm/pci.h                     |    2 -
 arch/powerpc/include/asm/pgtable.h                 |    3 +
 arch/powerpc/include/asm/processor.h               |    3 +
 arch/powerpc/include/asm/reg.h                     |    1 +
 arch/powerpc/include/asm/reg_booke.h               |    4 +
 arch/powerpc/include/asm/rtas.h                    |   18 +
 arch/powerpc/include/asm/rwsem.h                   |  132 --
 arch/powerpc/include/asm/system.h                  |   11 +-
 arch/powerpc/include/asm/tce.h                     |   10 +-
 arch/powerpc/include/asm/time.h                    |    2 +
 arch/powerpc/include/asm/types.h                   |    5 +-
 arch/powerpc/kernel/Makefile                       |    2 +
 arch/powerpc/kernel/asm-offsets.c                  |    1 +
 arch/powerpc/kernel/cpu_setup_a2.S                 |   10 +-
 arch/powerpc/kernel/cputable.c                     |   27 +
 arch/powerpc/kernel/crash.c                        |  220 ++--
 arch/powerpc/kernel/crash_dump.c                   |    4 +-
 arch/powerpc/kernel/exceptions-64s.S               |    2 +-
 arch/powerpc/kernel/head_44x.S                     |  107 ++
 arch/powerpc/kernel/head_fsl_booke.S               |    2 +-
 arch/powerpc/kernel/idle.c                         |   27 +
 arch/powerpc/kernel/idle_power7.S                  |    4 +
 arch/powerpc/kernel/irq.c                          |   28 +-
 arch/powerpc/kernel/machine_kexec.c                |    2 +-
 arch/powerpc/kernel/pci-common.c                   |   78 +-
 arch/powerpc/kernel/pci_dn.c                       |    3 +
 arch/powerpc/kernel/process.c                      |   22 +-
 arch/powerpc/kernel/prom_init.c                    |   37 +-
 arch/powerpc/kernel/reloc_32.S                     |  208 +++
 arch/powerpc/kernel/rtas_flash.c                   |    6 +
 arch/powerpc/kernel/rtasd.c                        |    7 +
 arch/powerpc/kernel/setup_64.c                     |   10 +
 arch/powerpc/kernel/smp.c                          |    3 +-
 arch/powerpc/kernel/sysfs.c                        |   10 +
 arch/powerpc/kernel/time.c                         |  105 +-
 arch/powerpc/kernel/traps.c                        |  173 ++-
 arch/powerpc/kernel/vmlinux.lds.S                  |    8 +-
 arch/powerpc/kvm/book3s_hv_rmhandlers.S            |    3 +
 arch/powerpc/lib/Makefile                          |    4 +-
 arch/powerpc/lib/copyuser_64.S                     |    6 +
 arch/powerpc/lib/copyuser_power7.S                 |  683 +++++++++
 arch/powerpc/lib/copyuser_power7_vmx.c             |   50 +
 arch/powerpc/mm/44x_mmu.c                          |    6 +-
 arch/powerpc/mm/Makefile                           |    2 +
 arch/powerpc/mm/fault.c                            |   17 +
 arch/powerpc/mm/hugetlbpage-book3e.c               |   21 +-
 arch/powerpc/mm/hugetlbpage.c                      |  116 +-
 arch/powerpc/mm/icswx.c                            |  273 ++++
 arch/powerpc/mm/icswx.h                            |   62 +
 arch/powerpc/mm/icswx_pid.c                        |   87 ++
 arch/powerpc/mm/init_32.c                          |    7 +
 arch/powerpc/mm/mem.c                              |   23 +-
 arch/powerpc/mm/mmap_64.c                          |   14 +-
 arch/powerpc/mm/mmu_context_hash64.c               |  195 +---
 arch/powerpc/mm/numa.c                             |    4 +-
 arch/powerpc/mm/tlb_low_64e.S                      |   36 +-
 arch/powerpc/mm/tlb_nohash.c                       |    2 +-
 arch/powerpc/platforms/40x/Kconfig                 |   21 +
 arch/powerpc/platforms/40x/ppc40x_simple.c         |    4 +-
 arch/powerpc/platforms/44x/Kconfig                 |   14 +
 arch/powerpc/platforms/44x/Makefile                |    1 +
 arch/powerpc/platforms/44x/currituck.c             |  204 +++
 arch/powerpc/platforms/44x/iss4xx.c                |    2 +-
 arch/powerpc/platforms/83xx/asp834x.c              |   35 +-
 arch/powerpc/platforms/83xx/km83xx.c               |   58 +-
 arch/powerpc/platforms/83xx/misc.c                 |   77 +
 arch/powerpc/platforms/83xx/mpc830x_rdb.c          |   40 +-
 arch/powerpc/platforms/83xx/mpc831x_rdb.c          |   43 +-
 arch/powerpc/platforms/83xx/mpc832x_mds.c          |   53 +-
 arch/powerpc/platforms/83xx/mpc832x_rdb.c          |   56 +-
 arch/powerpc/platforms/83xx/mpc834x_itx.c          |   30 +-
 arch/powerpc/platforms/83xx/mpc834x_mds.c          |   42 +-
 arch/powerpc/platforms/83xx/mpc836x_mds.c          |   53 +-
 arch/powerpc/platforms/83xx/mpc836x_rdk.c          |   48 +-
 arch/powerpc/platforms/83xx/mpc837x_mds.c          |   46 +-
 arch/powerpc/platforms/83xx/mpc837x_rdb.c          |   47 +-
 arch/powerpc/platforms/83xx/mpc83xx.h              |   16 +
 arch/powerpc/platforms/83xx/sbc834x.c              |   49 +-
 arch/powerpc/platforms/85xx/Kconfig                |    2 +-
 arch/powerpc/platforms/85xx/Makefile               |    2 +
 arch/powerpc/platforms/85xx/common.c               |   66 +
 arch/powerpc/platforms/85xx/corenet_ds.c           |   28 +-
 arch/powerpc/platforms/85xx/ksi8560.c              |   69 +-
 arch/powerpc/platforms/85xx/mpc8536_ds.c           |   38 +-
 arch/powerpc/platforms/85xx/mpc85xx.h              |   11 +
 arch/powerpc/platforms/85xx/mpc85xx_ads.c          |   74 +-
 arch/powerpc/platforms/85xx/mpc85xx_cds.c          |   42 +-
 arch/powerpc/platforms/85xx/mpc85xx_ds.c           |   50 +-
 arch/powerpc/platforms/85xx/mpc85xx_mds.c          |   73 +-
 arch/powerpc/platforms/85xx/mpc85xx_rdb.c          |   49 +-
 arch/powerpc/platforms/85xx/p1010rdb.c             |   38 +-
 arch/powerpc/platforms/85xx/p1022_ds.c             |   37 +-
 arch/powerpc/platforms/85xx/p1023_rds.c            |   47 +-
 arch/powerpc/platforms/85xx/p3060_qds.c            |    2 +-
 arch/powerpc/platforms/85xx/sbc8548.c              |   43 +-
 arch/powerpc/platforms/85xx/sbc8560.c              |   74 +-
 arch/powerpc/platforms/85xx/smp.c                  |    1 +
 arch/powerpc/platforms/85xx/smp.h                  |   15 +
 arch/powerpc/platforms/85xx/socrates.c             |   33 +-
 arch/powerpc/platforms/85xx/stx_gp3.c              |   73 +-
 arch/powerpc/platforms/85xx/tqm85xx.c              |   73 +-
 arch/powerpc/platforms/85xx/xes_mpc85xx.c          |   48 +-
 arch/powerpc/platforms/86xx/mpc86xx_hpcn.c         |    2 +-
 arch/powerpc/platforms/86xx/pic.c                  |   18 +-
 arch/powerpc/platforms/Kconfig                     |    6 +
 arch/powerpc/platforms/Kconfig.cputype             |   25 +-
 arch/powerpc/platforms/cell/iommu.c                |    2 +
 arch/powerpc/platforms/cell/setup.c                |   25 +-
 arch/powerpc/platforms/chrp/setup.c                |    3 +-
 arch/powerpc/platforms/embedded6xx/holly.c         |   23 +-
 arch/powerpc/platforms/embedded6xx/linkstation.c   |   20 +-
 arch/powerpc/platforms/embedded6xx/mpc7448_hpc2.c  |   24 +-
 arch/powerpc/platforms/embedded6xx/storcenter.c    |   26 +-
 arch/powerpc/platforms/maple/pci.c                 |   55 +
 arch/powerpc/platforms/maple/setup.c               |    2 +-
 arch/powerpc/platforms/pasemi/setup.c              |    4 +-
 arch/powerpc/platforms/powermac/pic.c              |   80 +-
 arch/powerpc/platforms/powermac/setup.c            |    8 +-
 arch/powerpc/platforms/powermac/smp.c              |    6 +-
 arch/powerpc/platforms/powernv/Makefile            |    2 +-
 arch/powerpc/platforms/powernv/opal-wrappers.S     |    8 +
 arch/powerpc/platforms/powernv/pci-ioda.c          | 1330 +++++++++++++++++
 arch/powerpc/platforms/powernv/pci-p5ioc2.c        |    1 +
 arch/powerpc/platforms/powernv/pci.c               |  228 +++-
 arch/powerpc/platforms/powernv/pci.h               |  100 ++
 arch/powerpc/platforms/powernv/smp.c               |    2 +-
 arch/powerpc/platforms/ps3/interrupt.c             |  103 +-
 arch/powerpc/platforms/ps3/repository.c            |  137 +-
 arch/powerpc/platforms/ps3/setup.c                 |    4 +-
 arch/powerpc/platforms/ps3/smp.c                   |    2 +-
 arch/powerpc/platforms/ps3/spu.c                   |    2 +-
 arch/powerpc/platforms/pseries/Kconfig             |    9 +
 arch/powerpc/platforms/pseries/Makefile            |    1 +
 arch/powerpc/platforms/pseries/hvCall_inst.c       |    4 +-
 arch/powerpc/platforms/pseries/iommu.c             |   61 +-
 arch/powerpc/platforms/pseries/lpar.c              |    2 +
 arch/powerpc/platforms/pseries/nvram.c             |    7 +
 arch/powerpc/platforms/pseries/processor_idle.c    |  329 +++++
 arch/powerpc/platforms/pseries/pseries.h           |    3 +
 arch/powerpc/platforms/pseries/setup.c             |  109 +--
 arch/powerpc/platforms/pseries/smp.c               |    1 +
 arch/powerpc/platforms/wsp/Kconfig                 |   12 +-
 arch/powerpc/platforms/wsp/Makefile                |    8 +-
 arch/powerpc/platforms/wsp/chroma.c                |   56 +
 arch/powerpc/platforms/wsp/h8.c                    |  134 ++
 arch/powerpc/platforms/wsp/opb_pic.c               |    3 +-
 arch/powerpc/platforms/wsp/psr2.c                  |   56 +-
 arch/powerpc/platforms/wsp/wsp.c                   |  115 ++
 arch/powerpc/platforms/wsp/wsp.h                   |   16 +-
 arch/powerpc/relocs_check.pl                       |   14 +-
 arch/powerpc/sysdev/Makefile                       |    3 +-
 arch/powerpc/sysdev/ehv_pic.c                      |    1 +
 arch/powerpc/sysdev/fsl_ifc.c                      |  310 ++++
 arch/powerpc/sysdev/fsl_lbc.c                      |   37 +
 arch/powerpc/sysdev/fsl_msi.c                      |   99 ++-
 arch/powerpc/sysdev/fsl_msi.h                      |   10 +-
 arch/powerpc/sysdev/fsl_pci.c                      |   84 ++
 arch/powerpc/sysdev/fsl_rio.c                      | 1519 ++++----------------
 arch/powerpc/sysdev/fsl_rio.h                      |  135 ++
 arch/powerpc/sysdev/fsl_rmu.c                      | 1104 ++++++++++++++
 arch/powerpc/sysdev/mpic.c                         |  201 ++-
 arch/powerpc/sysdev/ppc4xx_pci.c                   |   85 +-
 arch/powerpc/sysdev/ppc4xx_pci.h                   |    7 +
 arch/powerpc/sysdev/qe_lib/qe.c                    |    2 +-
 arch/powerpc/sysdev/xics/icp-hv.c                  |   47 +-
 arch/powerpc/sysdev/xics/xics-common.c             |    2 +-
 arch/powerpc/xmon/xmon.c                           |   16 +-
 arch/sparc/kernel/sys_sparc_64.c                   |    6 +-
 drivers/edac/mpc85xx_edac.c                        |    2 +-
 drivers/net/ethernet/toshiba/ps3_gelic_net.c       |    4 +-
 drivers/tty/serial/pmac_zilog.c                    |  423 ++----
 drivers/tty/serial/pmac_zilog.h                    |   19 +-
 drivers/tty/serial/ucc_uart.c                      |    3 +
 drivers/video/offb.c                               |   71 +-
 include/linux/cpuidle.h                            |    2 -
 tools/perf/arch/powerpc/util/dwarf-regs.c          |    3 +
 393 files changed, 21769 insertions(+), 16279 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/powerpc/fsl/srio-rmu.txt
 create mode 100644 Documentation/devicetree/bindings/powerpc/fsl/srio.txt
 create mode 100644 arch/powerpc/boot/dts/currituck.dts
 create mode 100644 arch/powerpc/boot/dts/fsl/mpc8536si-post.dtsi
 create mode 100644 arch/powerpc/boot/dts/fsl/mpc8536si-pre.dtsi
 create mode 100644 arch/powerpc/boot/dts/fsl/mpc8544si-post.dtsi
 create mode 100644 arch/powerpc/boot/dts/fsl/mpc8544si-pre.dtsi
 create mode 100644 arch/powerpc/boot/dts/fsl/mpc8548si-post.dtsi
 create mode 100644 arch/powerpc/boot/dts/fsl/mpc8548si-pre.dtsi
 create mode 100644 arch/powerpc/boot/dts/fsl/mpc8568si-post.dtsi
 create mode 100644 arch/powerpc/boot/dts/fsl/mpc8568si-pre.dtsi
 create mode 100644 arch/powerpc/boot/dts/fsl/mpc8569si-post.dtsi
 create mode 100644 arch/powerpc/boot/dts/fsl/mpc8569si-pre.dtsi
 create mode 100644 arch/powerpc/boot/dts/fsl/mpc8572si-post.dtsi
 create mode 100644 arch/powerpc/boot/dts/fsl/mpc8572si-pre.dtsi
 create mode 100644 arch/powerpc/boot/dts/fsl/p1010si-post.dtsi
 create mode 100644 arch/powerpc/boot/dts/fsl/p1010si-pre.dtsi
 create mode 100644 arch/powerpc/boot/dts/fsl/p1020si-post.dtsi
 create mode 100644 arch/powerpc/boot/dts/fsl/p1020si-pre.dtsi
 create mode 100644 arch/powerpc/boot/dts/fsl/p1021si-post.dtsi
 create mode 100644 arch/powerpc/boot/dts/fsl/p1021si-pre.dtsi
 create mode 100644 arch/powerpc/boot/dts/fsl/p1022si-post.dtsi
 create mode 100644 arch/powerpc/boot/dts/fsl/p1022si-pre.dtsi
 create mode 100644 arch/powerpc/boot/dts/fsl/p1023si-post.dtsi
 create mode 100644 arch/powerpc/boot/dts/fsl/p1023si-pre.dtsi
 create mode 100644 arch/powerpc/boot/dts/fsl/p2020si-post.dtsi
 create mode 100644 arch/powerpc/boot/dts/fsl/p2020si-pre.dtsi
 create mode 100644 arch/powerpc/boot/dts/fsl/p2041si-post.dtsi
 create mode 100644 arch/powerpc/boot/dts/fsl/p2041si-pre.dtsi
 create mode 100644 arch/powerpc/boot/dts/fsl/p3041si-post.dtsi
 create mode 100644 arch/powerpc/boot/dts/fsl/p3041si-pre.dtsi
 create mode 100644 arch/powerpc/boot/dts/fsl/p3060si-post.dtsi
 create mode 100644 arch/powerpc/boot/dts/fsl/p3060si-pre.dtsi
 create mode 100644 arch/powerpc/boot/dts/fsl/p4080si-post.dtsi
 create mode 100644 arch/powerpc/boot/dts/fsl/p4080si-pre.dtsi
 create mode 100644 arch/powerpc/boot/dts/fsl/p5020si-post.dtsi
 create mode 100644 arch/powerpc/boot/dts/fsl/p5020si-pre.dtsi
 create mode 100644 arch/powerpc/boot/dts/fsl/pq3-dma-0.dtsi
 create mode 100644 arch/powerpc/boot/dts/fsl/pq3-dma-1.dtsi
 create mode 100644 arch/powerpc/boot/dts/fsl/pq3-duart-0.dtsi
 create mode 100644 arch/powerpc/boot/dts/fsl/pq3-esdhc-0.dtsi
 create mode 100644 arch/powerpc/boot/dts/fsl/pq3-espi-0.dtsi
 create mode 100644 arch/powerpc/boot/dts/fsl/pq3-etsec1-0.dtsi
 create mode 100644 arch/powerpc/boot/dts/fsl/pq3-etsec1-1.dtsi
 create mode 100644 arch/powerpc/boot/dts/fsl/pq3-etsec1-2.dtsi
 create mode 100644 arch/powerpc/boot/dts/fsl/pq3-etsec1-3.dtsi
 create mode 100644 arch/powerpc/boot/dts/fsl/pq3-etsec1-timer-0.dtsi
 create mode 100644 arch/powerpc/boot/dts/fsl/pq3-etsec2-0.dtsi
 create mode 100644 arch/powerpc/boot/dts/fsl/pq3-etsec2-1.dtsi
 create mode 100644 arch/powerpc/boot/dts/fsl/pq3-etsec2-2.dtsi
 create mode 100644 arch/powerpc/boot/dts/fsl/pq3-etsec2-grp2-0.dtsi
 create mode 100644 arch/powerpc/boot/dts/fsl/pq3-etsec2-grp2-1.dtsi
 create mode 100644 arch/powerpc/boot/dts/fsl/pq3-etsec2-grp2-2.dtsi
 create mode 100644 arch/powerpc/boot/dts/fsl/pq3-gpio-0.dtsi
 create mode 100644 arch/powerpc/boot/dts/fsl/pq3-i2c-0.dtsi
 create mode 100644 arch/powerpc/boot/dts/fsl/pq3-i2c-1.dtsi
 create mode 100644 arch/powerpc/boot/dts/fsl/pq3-mpic-timer-B.dtsi
 create mode 100644 arch/powerpc/boot/dts/fsl/pq3-mpic.dtsi
 create mode 100644 arch/powerpc/boot/dts/fsl/pq3-rmu-0.dtsi
 create mode 100644 arch/powerpc/boot/dts/fsl/pq3-sata2-0.dtsi
 create mode 100644 arch/powerpc/boot/dts/fsl/pq3-sata2-1.dtsi
 create mode 100644 arch/powerpc/boot/dts/fsl/pq3-sec2.1-0.dtsi
 create mode 100644 arch/powerpc/boot/dts/fsl/pq3-sec3.0-0.dtsi
 create mode 100644 arch/powerpc/boot/dts/fsl/pq3-sec3.1-0.dtsi
 create mode 100644 arch/powerpc/boot/dts/fsl/pq3-sec3.3-0.dtsi
 create mode 100644 arch/powerpc/boot/dts/fsl/pq3-sec4.4-0.dtsi
 create mode 100644 arch/powerpc/boot/dts/fsl/pq3-usb2-dr-0.dtsi
 create mode 100644 arch/powerpc/boot/dts/fsl/pq3-usb2-dr-1.dtsi
 create mode 100644 arch/powerpc/boot/dts/fsl/qoriq-dma-0.dtsi
 create mode 100644 arch/powerpc/boot/dts/fsl/qoriq-dma-1.dtsi
 create mode 100644 arch/powerpc/boot/dts/fsl/qoriq-duart-0.dtsi
 create mode 100644 arch/powerpc/boot/dts/fsl/qoriq-duart-1.dtsi
 create mode 100644 arch/powerpc/boot/dts/fsl/qoriq-esdhc-0.dtsi
 create mode 100644 arch/powerpc/boot/dts/fsl/qoriq-espi-0.dtsi
 create mode 100644 arch/powerpc/boot/dts/fsl/qoriq-gpio-0.dtsi
 create mode 100644 arch/powerpc/boot/dts/fsl/qoriq-i2c-0.dtsi
 create mode 100644 arch/powerpc/boot/dts/fsl/qoriq-i2c-1.dtsi
 create mode 100644 arch/powerpc/boot/dts/fsl/qoriq-mpic.dtsi
 create mode 100644 arch/powerpc/boot/dts/fsl/qoriq-rmu-0.dtsi
 create mode 100644 arch/powerpc/boot/dts/fsl/qoriq-sata2-0.dtsi
 create mode 100644 arch/powerpc/boot/dts/fsl/qoriq-sata2-1.dtsi
 create mode 100644 arch/powerpc/boot/dts/fsl/qoriq-sec4.0-0.dtsi
 create mode 100644 arch/powerpc/boot/dts/fsl/qoriq-sec4.1-0.dtsi
 create mode 100644 arch/powerpc/boot/dts/fsl/qoriq-sec4.2-0.dtsi
 create mode 100644 arch/powerpc/boot/dts/fsl/qoriq-usb2-dr-0.dtsi
 create mode 100644 arch/powerpc/boot/dts/fsl/qoriq-usb2-mph-0.dtsi
 create mode 100644 arch/powerpc/boot/dts/klondike.dts
 create mode 100644 arch/powerpc/boot/dts/mpc8536ds.dtsi
 create mode 100644 arch/powerpc/boot/dts/mpc8544ds.dtsi
 create mode 100644 arch/powerpc/boot/dts/mpc8572ds.dtsi
 create mode 100644 arch/powerpc/boot/dts/obs600.dts
 create mode 100644 arch/powerpc/boot/dts/p1010rdb.dtsi
 create mode 100644 arch/powerpc/boot/dts/p1010rdb_36b.dts
 delete mode 100644 arch/powerpc/boot/dts/p1010si.dtsi
 create mode 100644 arch/powerpc/boot/dts/p1020rdb.dtsi
 create mode 100644 arch/powerpc/boot/dts/p1020rdb_36b.dts
 delete mode 100644 arch/powerpc/boot/dts/p1020si.dtsi
 create mode 100644 arch/powerpc/boot/dts/p2020ds.dtsi
 delete mode 100644 arch/powerpc/boot/dts/p2020si.dtsi
 delete mode 100644 arch/powerpc/boot/dts/p2041si.dtsi
 delete mode 100644 arch/powerpc/boot/dts/p3041si.dtsi
 delete mode 100644 arch/powerpc/boot/dts/p3060si.dtsi
 delete mode 100644 arch/powerpc/boot/dts/p4080si.dtsi
 delete mode 100644 arch/powerpc/boot/dts/p5020si.dtsi
 create mode 100644 arch/powerpc/boot/treeboot-currituck.c
 create mode 100644 arch/powerpc/configs/40x/klondike_defconfig
 create mode 100644 arch/powerpc/configs/40x/obs600_defconfig
 create mode 100644 arch/powerpc/configs/44x/currituck_defconfig
 create mode 100644 arch/powerpc/configs/chroma_defconfig
 create mode 100644 arch/powerpc/include/asm/fsl_ifc.h
 delete mode 100644 arch/powerpc/include/asm/rwsem.h
 create mode 100644 arch/powerpc/kernel/reloc_32.S
 create mode 100644 arch/powerpc/lib/copyuser_power7.S
 create mode 100644 arch/powerpc/lib/copyuser_power7_vmx.c
 create mode 100644 arch/powerpc/mm/icswx.c
 create mode 100644 arch/powerpc/mm/icswx.h
 create mode 100644 arch/powerpc/mm/icswx_pid.c
 create mode 100644 arch/powerpc/platforms/44x/currituck.c
 create mode 100644 arch/powerpc/platforms/85xx/common.c
 create mode 100644 arch/powerpc/platforms/85xx/mpc85xx.h
 create mode 100644 arch/powerpc/platforms/85xx/smp.h
 create mode 100644 arch/powerpc/platforms/powernv/pci-ioda.c
 create mode 100644 arch/powerpc/platforms/pseries/processor_idle.c
 create mode 100644 arch/powerpc/platforms/wsp/chroma.c
 create mode 100644 arch/powerpc/platforms/wsp/h8.c
 create mode 100644 arch/powerpc/platforms/wsp/wsp.c
 create mode 100644 arch/powerpc/sysdev/fsl_ifc.c
 create mode 100644 arch/powerpc/sysdev/fsl_rio.h
 create mode 100644 arch/powerpc/sysdev/fsl_rmu.c


