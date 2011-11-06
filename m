Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754770Ab1KFXfd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Nov 2011 18:35:33 -0500
Received: from gate.crashing.org ([63.228.1.57]:58912 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754747Ab1KFXfa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Nov 2011 18:35:30 -0500
Message-ID: <1320622519.2779.11.camel@pasglop>
Subject: [git pull] Please pull powerpc.git next branch
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linuxppc-dev list <linuxppc-dev@ozlabs.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel list <linux-kernel@vger.kernel.org>
Date: Mon, 07 Nov 2011 10:35:19 +1100
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.0- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus !

Here's (finally) the powerpc stuff for this merge window. It's late, as
I warned you during KS, I was on vacation & travelling around and really
couldn't get to do it earlier than today. Everything in there has been
in linux-next for a while anyway, the only difference from what was in
github a month ago is that I merged a bit more freescale bits from
Kumar.

As for the highlights, you get the new "powernv" platform which allows
booting under the new "OPAL" firmware. This will allow booting without a
hypervisor on future IBM POWER machines, in order to be able to run KVM.
There's still one missing component to support the latest PCI Express
bridges, but it's a drop-in addition, so I might still merge it after
-rc1 (or not .. I haven't decided yet, I held on to it for a bit as it
was depending on some PCI changes that went upstream separately via
Jesse and dealing with the dependency while travelling was deemed too
annoying).

We also have a bunch of Numa fixes from Anton, some DMA code cleanup
from Milton and the usual batch of embedded bits and pieces.

Cheers,
Ben.
 
The following changes since commit d6748066ad0e8b2514545998f8367ebb3906f299:

  Merge branch 'upstream' of git://git.linux-mips.org/pub/scm/ralf/upstream-linus (2011-11-03 13:28:14 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/benh/powerpc.git next

Anatolij Gustschin (5):
      powerpc/5200: mpc5200b.dtsi: add spi node address- and size-cells properties
      powerpc/5200: dts: digsy_mtc.dts: update to add can, pci, serial and spi
      powerpc/5200: dts: digsy_mtc.dts: add timer0 and timer1 gpio properties
      powerpc/5200: dts: digsy_mtc.dts: enable both MSCAN nodes
      powerpc/85xx: fix PHYS_64BIT selection for P1022DS

Anshuman Khandual (1):
      perf events, powerpc: Add POWER7 stalled-cycles-frontend/backend events

Anton Blanchard (11):
      powerpc/pseries: Avoid spurious error during hotplug CPU add
      powerpc/numa: Enable SD_WAKE_AFFINE in node definition
      sched: Allow SD_NODES_PER_DOMAIN to be overridden
      powerpc/numa: Increase SD_NODES_PER_DOMAIN to 32.
      powerpc/numa: Disable NEWIDLE balancing at node level
      powerpc/numa: Remove duplicate RECLAIM_DISTANCE definition
      powerpc/numa: Remove double of_node_put in hot_add_node_scn_to_nid
      powerpc: Use for_each_node_by_type instead of open coding it
      powerpc: Coding style cleanups
      powerpc: Fix oops when echoing bad values to /sys/devices/system/memory/probe
      powerpc: Fix deadlock in icswx code

Arnaud Lacombe (1):
      powerpc/xics: Add __init to marker icp_native_init()

Arnd Bergmann (1):
      serial/8250: Move UPIO_TSI to powerpc

Ayman El-Khashab (1):
      powerpc/4xx: enable and fix pcie gen1/gen2 on the 460sx

Becky Bruce (4):
      powerpc: Hugetlb for BookE
      powerpc: Update mpc85xx/corenet 32-bit defconfigs
      powerpc: Update corenet64_smp_defconfig
      powerpc/fsl-booke: Fix settlbcam for 64-bit

Benjamin Herrenschmidt (27):
      Merge remote-tracking branch 'jwb/next' into next
      Merge remote-tracking branch 'origin/master' into next
      powerpc/wsp: Add PCIe Root support to PowerEN/WSP
      Merge remote-tracking branch 'origin/master' into next
      powerpc/udbg: Fix Kconfig entry for avoiding 44x early debug with KVM
      powerpc/smp: More generic support for "soft hotplug"
      powerpc/pci: Call pcie_bus_configure_settings()
      powerpc/powernv: Don't clobber r9 in relative_toc()
      powerpc: Add skeleton PowerNV platform
      of: Change logic to overwrite cmd_line with CONFIG_CMDLINE
      powerpc/powernv: Add CPU hotplug support
      powerpc/powernv: Add OPAL takeover from PowerVM
      powerpc/powernv: Get kernel command line accross OPAL takeover
      powerpc/powernv: Basic support for OPAL
      powerpc/powernv: Add support for instanciating OPAL v2 from Open Firmware
      powerpc/powernv: Support for OPAL console
      powerpc/powernv: Hookup reboot and poweroff functions
      powerpc/powernv: Add RTC and NVRAM support plus RTAS fallbacks
      powerpc/powernv: Add OPAL ICS backend
      powerpc/powernv: Register and handle OPAL interrupts
      powerpc/powernv: Machine check and other system interrupts
      powerpc/powernv: Add support for p5ioc2 PCI-X and PCIe
      powerpc/powernv: Implement MSI support for p5ioc2 PCIe
      powerpc/powernv: Handle PCI-X/PCIe reset delay
      powerpc/pci: Don't configure PCIe settings when PCI_PROBE_ONLY is set
      powerpc/ptrace: Fix build with gcc 4.6
      powerpc: Don't try OPAL takeover on old 970 blades

Bharat Bhushan (1):
      powerpc: e500mc: Fix: use CONFIG_PPC_E500MC in idle_e500.S

Brian King (1):
      hvcs: Ensure page aligned partner info buffer

Carl E. Love (1):
      powerpc/perf_event: Fix Power6 L1 cache read & write event codes]

Dmitry Eremin-Solenikov (5):
      cpc925_edac: Support single-processor configurations
      powerpc/85xx: sbc8560 - correct compilation if CONFIG_PHYS_ADDR_T_64BIT is set
      powerpc/85xx: ksi8560 - declare that localbus is compatbile with simple-bus
      powerpc/85xx: sbc8560 - declare that localbus is compatbile with simple-bus
      powerpc/mpc8349emitx: mark localbus as compatible with simple-bus

Fabio Baltieri (1):
      powerpc/83xx: Add shutdown request support to MCU handling on MPC8349 MITX

Felix Radensky (1):
      powerpc/8xxx: Fix interrupt handling in MPC8xxx GPIO driver

Hector Martin (1):
      powerpc/ps3: Add gelic udbg driver

Holger Brunck (1):
      powerpc/82xx: updates for mgcoge

Hongjun Chen (1):
      powerpc/cpm: Clear muram before it is in use.

Jim Keniston (1):
      powerpc/nvram: Add compression to fit more oops output into NVRAM

Jimi Xenidis (2):
      powerpc/wsp: Fix Wire Speed Processor platform configs
      powerpc: Fix xmon for systems without MSR[RI]

Josh Boyer (1):
      powerpc/40x: Remove obsolete HCU4 board

Julia Lawall (1):
      pseries/iommu: Add missing kfree

Kumar Gala (6):
      powerpc/85xx: Rename PowerPC core nodes to match other e500mc based .dts
      powerpc/fsl-booke: Handle L1 D-cache parity error correctly on e500mc
      powerpc: respect mem= setting for early memory limit setup
      powerpc/fsl-booke: Fix setup_initial_memory_limit to not blindly map
      powerpc/85xx: Setup secondary cores PIR with hard SMP id
      powerpc/85xx: Add 'fsl,pq3-gpio' compatiable for GPIO driver

Liu Yu (3):
      powerpc/math_emu/efp: Use pr_debug instead of printk
      powerpc/math_emu/efp: No need to round if the result is exact
      powerpc/math_emu/efp: Look for errata handler when type mismatches

Martyn Welch (1):
      powerpc/86xx: Correct Gianfar support for GE boards

Matthew McClintock (5):
      powerpc: Fix build dependencies for epapr.c which needs libfdt.h
      powerpc/85xx: Fix support for enabling doorbells for IPIs
      powerpc/85xx: issue 15 EOI after core reset for FSL CoreNet devices
      powerpc/fsl_booke: Fix comment in head_fsl_booke.S
      powerpc/85xx: Make kexec to interate over online cpus

Michael Ellerman (1):
      powerpc/wsp: Add MSI support for PCI on PowerEN

Mihai Caraman (1):
      drivers/virt: add ioctl for 32-bit compat on 64-bit to fsl-hv-manager

Mike Williams (1):
      powerpc/4xx: edac: Add comma to fix build error

Milton Miller (4):
      powerpc: Override dma_get_required_mask by platform hook and ops
      dma-mapping: Add get_required_mask if arch overrides default
      powerpc: Use the newly added get_required_mask dma_map_ops hook
      powerpc: Tidy up dma_map_ops after adding new hook

Mingkai Hu (1):
      powerpc/85xx: Rename p2040_rdb.c to p2041_rdb.c

Paul Mackerras (1):
      powerpc: Fix hugetlb with CONFIG_PPC_MM_SLICES=y

Scott Wood (1):
      powerpc/32: Pass device tree address as u64 to machine_init

Shengzhou Liu (1):
      powerpc/p3060qds: Add support for P3060QDS board

Stefan Roese (1):
      powerpc/44x: Add NOR flash device to Yosemite dts

Stephen George (1):
      powerpc/85xx: Adding DCSR node to dtsi device trees

Suzuki Poulose (1):
      powerpc/44x: Kexec support for PPC440X chipsets

Tang Yuantian (1):
      powerpc/mm: Fix the call trace when resumed from hibernation

Thadeu Lima de Souza Cascardo (2):
      powerpc/eeh: Fix /proc/ppc64/eeh creation
      powerpc: Reserve iommu page 0

Timur Tabi (5):
      powerpc/mpic: Add support for discontiguous cores
      powerpc/5200: enable audio in the defconfig
      powerpc/fsl_msi: fix support for multiple MSI ranges
      powerpc/85xx: clean up FPGA device tree nodes for Freecsale QorIQ boards
      powerpc/fsl_msi: add support for "msi-address-64" property

Tony Breeds (1):
      powerpc/4xx/pci: Add __init annotations for *init_port_hw() functions.

Wolfram Sang (2):
      gpio: move mpc8xxx/512x gpio driver to drivers/gpio
      powerpc: update 512x-defconfig

 .../devicetree/bindings/powerpc/fsl/board.txt      |   30 +-
 .../devicetree/bindings/powerpc/fsl/dcsr.txt       |  395 +++++++
 .../devicetree/bindings/powerpc/fsl/msi-pic.txt    |   42 +
 arch/powerpc/Kconfig                               |    7 +-
 arch/powerpc/Kconfig.debug                         |   46 +-
 arch/powerpc/boot/Makefile                         |    3 +-
 arch/powerpc/boot/dts/digsy_mtc.dts                |   59 +-
 arch/powerpc/boot/dts/gef_ppc9a.dts                |   33 +-
 arch/powerpc/boot/dts/gef_sbc310.dts               |   33 +-
 arch/powerpc/boot/dts/gef_sbc610.dts               |   33 +-
 arch/powerpc/boot/dts/hcu4.dts                     |  168 ---
 arch/powerpc/boot/dts/ksi8560.dts                  |    2 +-
 arch/powerpc/boot/dts/mgcoge.dts                   |    9 +
 arch/powerpc/boot/dts/mpc5200b.dtsi                |    2 +
 arch/powerpc/boot/dts/mpc8349emitx.dts             |    3 +-
 arch/powerpc/boot/dts/p1022ds.dts                  |    2 +-
 arch/powerpc/boot/dts/p2020ds.dts                  |    5 +
 .../boot/dts/{p2040rdb.dts => p2041rdb.dts}        |   17 +-
 .../boot/dts/{p2040si.dtsi => p2041si.dtsi}        |  135 ++-
 arch/powerpc/boot/dts/p3041ds.dts                  |    8 +-
 arch/powerpc/boot/dts/p3041si.dtsi                 |   71 ++-
 arch/powerpc/boot/dts/p3060qds.dts                 |  238 ++++
 arch/powerpc/boot/dts/p3060si.dtsi                 |  719 +++++++++++++
 arch/powerpc/boot/dts/p4080ds.dts                  |   12 +-
 arch/powerpc/boot/dts/p4080si.dtsi                 |  114 ++-
 arch/powerpc/boot/dts/p5020ds.dts                  |    8 +-
 arch/powerpc/boot/dts/p5020si.dtsi                 |   68 ++-
 arch/powerpc/boot/dts/sbc8560.dts                  |    2 +-
 arch/powerpc/boot/dts/yosemite.dts                 |   36 +
 arch/powerpc/configs/40x/hcu4_defconfig            |   80 --
 arch/powerpc/configs/85xx/p1023rds_defconfig       |    2 +-
 arch/powerpc/configs/85xx/xes_mpc85xx_defconfig    |    2 +-
 arch/powerpc/configs/corenet32_smp_defconfig       |   11 +-
 arch/powerpc/configs/corenet64_smp_defconfig       |    5 -
 arch/powerpc/configs/mgcoge_defconfig              |   27 +-
 arch/powerpc/configs/mpc512x_defconfig             |   19 +-
 arch/powerpc/configs/mpc5200_defconfig             |   12 +
 arch/powerpc/configs/mpc85xx_defconfig             |    5 +-
 arch/powerpc/configs/mpc85xx_smp_defconfig         |    6 +-
 arch/powerpc/configs/ppc40x_defconfig              |    1 -
 arch/powerpc/configs/ppc6xx_defconfig              |    2 +-
 arch/powerpc/include/asm/device.h                  |    2 +
 arch/powerpc/include/asm/firmware.h                |   10 +
 arch/powerpc/include/asm/hugetlb.h                 |   63 ++-
 arch/powerpc/include/asm/kexec.h                   |    2 +-
 arch/powerpc/include/asm/machdep.h                 |    3 +-
 arch/powerpc/include/asm/mmu-book3e.h              |    7 +
 arch/powerpc/include/asm/mmu-hash64.h              |    3 +-
 arch/powerpc/include/asm/mmu.h                     |   18 +-
 arch/powerpc/include/asm/mpic.h                    |    2 -
 arch/powerpc/include/asm/opal.h                    |  443 ++++++++
 arch/powerpc/include/asm/paca.h                    |    8 +
 arch/powerpc/include/asm/page.h                    |   31 +-
 arch/powerpc/include/asm/page_64.h                 |   11 -
 arch/powerpc/include/asm/pte-book3e.h              |    3 +
 arch/powerpc/include/asm/reg_booke.h               |    3 +
 arch/powerpc/include/asm/rtas.h                    |    6 +-
 arch/powerpc/include/asm/smp.h                     |    1 +
 arch/powerpc/include/asm/sparsemem.h               |    2 +-
 arch/powerpc/include/asm/topology.h                |   14 +-
 arch/powerpc/include/asm/udbg.h                    |    3 +
 arch/powerpc/include/asm/xics.h                    |   19 +
 arch/powerpc/kernel/asm-offsets.c                  |   10 +
 arch/powerpc/kernel/dma-iommu.c                    |   28 +-
 arch/powerpc/kernel/dma-swiotlb.c                  |   16 +
 arch/powerpc/kernel/dma.c                          |   44 +-
 arch/powerpc/kernel/exceptions-64s.S               |   27 +-
 arch/powerpc/kernel/head_32.S                      |    7 +-
 arch/powerpc/kernel/head_40x.S                     |   15 +-
 arch/powerpc/kernel/head_44x.S                     |   16 +-
 arch/powerpc/kernel/head_64.S                      |   22 +-
 arch/powerpc/kernel/head_8xx.S                     |   13 +-
 arch/powerpc/kernel/head_fsl_booke.S               |  175 +++-
 arch/powerpc/kernel/ibmebus.c                      |   22 +-
 arch/powerpc/kernel/idle_e500.S                    |    2 +-
 arch/powerpc/kernel/iommu.c                        |    8 +
 arch/powerpc/kernel/legacy_serial.c                |   25 +
 arch/powerpc/kernel/machine_kexec_64.c             |    3 +-
 arch/powerpc/kernel/misc_32.S                      |  171 +++
 arch/powerpc/kernel/pci-common.c                   |   11 +
 arch/powerpc/kernel/power6-pmu.c                   |    4 +-
 arch/powerpc/kernel/power7-pmu.c                   |    2 +
 arch/powerpc/kernel/prom.c                         |   19 +-
 arch/powerpc/kernel/prom_init.c                    |  383 ++++++-
 arch/powerpc/kernel/prom_init_check.sh             |    4 +-
 arch/powerpc/kernel/ptrace.c                       |   18 +-
 arch/powerpc/kernel/setup_32.c                     |    2 +-
 arch/powerpc/kernel/setup_64.c                     |   22 +-
 arch/powerpc/kernel/smp.c                          |   30 +-
 arch/powerpc/kernel/swsusp.c                       |    2 +-
 arch/powerpc/kernel/traps.c                        |    9 +-
 arch/powerpc/kernel/udbg.c                         |    6 +
 arch/powerpc/kernel/vio.c                          |   21 +-
 arch/powerpc/math-emu/math_efp.c                   |  100 +-
 arch/powerpc/mm/Makefile                           |    1 +
 arch/powerpc/mm/fsl_booke_mmu.c                    |   43 +-
 arch/powerpc/mm/hash_utils_64.c                    |    9 +-
 arch/powerpc/mm/hugetlbpage-book3e.c               |  121 +++
 arch/powerpc/mm/hugetlbpage.c                      |  379 ++++++-
 arch/powerpc/mm/init_32.c                          |    9 +
 arch/powerpc/mm/mem.c                              |    8 +-
 arch/powerpc/mm/mmu_context_hash64.c               |   12 +-
 arch/powerpc/mm/mmu_context_nohash.c               |    5 +
 arch/powerpc/mm/mmu_decl.h                         |    2 +
 arch/powerpc/mm/numa.c                             |   20 +-
 arch/powerpc/mm/pgtable.c                          |    3 +-
 arch/powerpc/mm/tlb_low_64e.S                      |   24 +-
 arch/powerpc/mm/tlb_nohash.c                       |   67 ++-
 arch/powerpc/platforms/40x/Kconfig                 |    8 -
 arch/powerpc/platforms/40x/Makefile                |    1 -
 arch/powerpc/platforms/40x/hcu4.c                  |   61 --
 arch/powerpc/platforms/512x/Kconfig                |    1 +
 arch/powerpc/platforms/82xx/km82xx.c               |    4 +
 arch/powerpc/platforms/83xx/Kconfig                |    9 +-
 arch/powerpc/platforms/83xx/mcu_mpc8349emitx.c     |   58 +-
 arch/powerpc/platforms/85xx/Kconfig                |   32 +-
 arch/powerpc/platforms/85xx/Makefile               |    3 +-
 arch/powerpc/platforms/85xx/p1022_ds.c             |   11 +-
 .../platforms/85xx/{p2040_rdb.c => p2041_rdb.c}    |   18 +-
 arch/powerpc/platforms/85xx/p3060_qds.c            |   77 ++
 arch/powerpc/platforms/85xx/sbc8560.c              |    2 +-
 arch/powerpc/platforms/85xx/smp.c                  |   12 +-
 arch/powerpc/platforms/86xx/Kconfig                |    1 +
 arch/powerpc/platforms/Kconfig                     |   13 +-
 arch/powerpc/platforms/Kconfig.cputype             |    4 +-
 arch/powerpc/platforms/Makefile                    |    1 +
 arch/powerpc/platforms/cell/iommu.c                |   21 +
 arch/powerpc/platforms/powernv/Kconfig             |   16 +
 arch/powerpc/platforms/powernv/Makefile            |    5 +
 arch/powerpc/platforms/powernv/opal-nvram.c        |   88 ++
 arch/powerpc/platforms/powernv/opal-rtc.c          |   97 ++
 arch/powerpc/platforms/powernv/opal-takeover.S     |  140 +++
 arch/powerpc/platforms/powernv/opal-wrappers.S     |  101 ++
 arch/powerpc/platforms/powernv/opal.c              |  322 ++++++
 arch/powerpc/platforms/powernv/pci-p5ioc2.c        |  234 ++++
 arch/powerpc/platforms/powernv/pci.c               |  427 ++++++++
 arch/powerpc/platforms/powernv/pci.h               |   48 +
 arch/powerpc/platforms/powernv/powernv.h           |   16 +
 arch/powerpc/platforms/powernv/setup.c             |  196 ++++
 arch/powerpc/platforms/powernv/smp.c               |  182 ++++
 arch/powerpc/platforms/ps3/Kconfig                 |   12 +
 arch/powerpc/platforms/ps3/Makefile                |    1 +
 arch/powerpc/platforms/ps3/gelic_udbg.c            |  273 +++++
 arch/powerpc/platforms/ps3/system-bus.c            |    7 +
 arch/powerpc/platforms/pseries/Kconfig             |    1 +
 arch/powerpc/platforms/pseries/dlpar.c             |    4 +
 arch/powerpc/platforms/pseries/eeh.c               |    2 +-
 arch/powerpc/platforms/pseries/iommu.c             |   34 +-
 arch/powerpc/platforms/pseries/nvram.c             |  171 +++-
 arch/powerpc/platforms/wsp/Kconfig                 |   11 +-
 arch/powerpc/platforms/wsp/Makefile                |    2 +
 arch/powerpc/platforms/wsp/ics.c                   |   48 +
 arch/powerpc/platforms/wsp/ics.h                   |    5 +
 arch/powerpc/platforms/wsp/msi.c                   |  102 ++
 arch/powerpc/platforms/wsp/msi.h                   |   19 +
 arch/powerpc/platforms/wsp/psr2.c                  |    4 +
 arch/powerpc/platforms/wsp/wsp.h                   |    3 +
 arch/powerpc/platforms/wsp/wsp_pci.c               | 1133 ++++++++++++++++++++
 arch/powerpc/platforms/wsp/wsp_pci.h               |  268 +++++
 arch/powerpc/sysdev/Makefile                       |    1 -
 arch/powerpc/sysdev/cpm_common.c                   |    3 +-
 arch/powerpc/sysdev/fsl_msi.c                      |   28 +-
 arch/powerpc/sysdev/fsl_msi.h                      |    3 +-
 arch/powerpc/sysdev/mpic.c                         |   34 +-
 arch/powerpc/sysdev/ppc4xx_pci.c                   |  101 ++-
 arch/powerpc/sysdev/ppc4xx_pci.h                   |   12 +
 arch/powerpc/sysdev/xics/Makefile                  |    1 +
 arch/powerpc/sysdev/xics/icp-native.c              |    2 +-
 arch/powerpc/sysdev/xics/ics-opal.c                |  244 +++++
 arch/powerpc/sysdev/xics/xics-common.c             |    8 +-
 arch/powerpc/xmon/xmon.c                           |    4 +-
 drivers/edac/cpc925_edac.c                         |   67 ++-
 drivers/edac/ppc4xx_edac.c                         |    2 +-
 drivers/gpio/Kconfig                               |    8 +
 drivers/gpio/Makefile                              |    1 +
 .../mpc8xxx_gpio.c => drivers/gpio/gpio-mpc8xxx.c  |    3 +
 drivers/net/ps3_gelic_net.c                        |    3 +
 drivers/net/ps3_gelic_net.h                        |    6 +
 drivers/of/fdt.c                                   |    7 +-
 drivers/tty/hvc/Kconfig                            |    9 +
 drivers/tty/hvc/Makefile                           |    1 +
 drivers/tty/hvc/hvc_opal.c                         |  424 ++++++++
 drivers/tty/hvc/hvcs.c                             |    6 +-
 drivers/tty/hvc/hvsi_lib.c                         |    4 +-
 drivers/tty/serial/8250.c                          |   23 -
 drivers/virt/fsl_hypervisor.c                      |    1 +
 include/linux/dma-mapping.h                        |    3 +
 include/linux/topology.h                           |    4 +
 kernel/sched.c                                     |    2 -
 189 files changed, 9411 insertions(+), 979 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/powerpc/fsl/dcsr.txt
 delete mode 100644 arch/powerpc/boot/dts/hcu4.dts
 rename arch/powerpc/boot/dts/{p2040rdb.dts => p2041rdb.dts} (95%)
 rename arch/powerpc/boot/dts/{p2040si.dtsi => p2041si.dtsi} (80%)
 create mode 100644 arch/powerpc/boot/dts/p3060qds.dts
 create mode 100644 arch/powerpc/boot/dts/p3060si.dtsi
 delete mode 100644 arch/powerpc/configs/40x/hcu4_defconfig
 create mode 100644 arch/powerpc/include/asm/opal.h
 create mode 100644 arch/powerpc/mm/hugetlbpage-book3e.c
 delete mode 100644 arch/powerpc/platforms/40x/hcu4.c
 rename arch/powerpc/platforms/85xx/{p2040_rdb.c => p2041_rdb.c} (82%)
 create mode 100644 arch/powerpc/platforms/85xx/p3060_qds.c
 create mode 100644 arch/powerpc/platforms/powernv/Kconfig
 create mode 100644 arch/powerpc/platforms/powernv/Makefile
 create mode 100644 arch/powerpc/platforms/powernv/opal-nvram.c
 create mode 100644 arch/powerpc/platforms/powernv/opal-rtc.c
 create mode 100644 arch/powerpc/platforms/powernv/opal-takeover.S
 create mode 100644 arch/powerpc/platforms/powernv/opal-wrappers.S
 create mode 100644 arch/powerpc/platforms/powernv/opal.c
 create mode 100644 arch/powerpc/platforms/powernv/pci-p5ioc2.c
 create mode 100644 arch/powerpc/platforms/powernv/pci.c
 create mode 100644 arch/powerpc/platforms/powernv/pci.h
 create mode 100644 arch/powerpc/platforms/powernv/powernv.h
 create mode 100644 arch/powerpc/platforms/powernv/setup.c
 create mode 100644 arch/powerpc/platforms/powernv/smp.c
 create mode 100644 arch/powerpc/platforms/ps3/gelic_udbg.c
 create mode 100644 arch/powerpc/platforms/wsp/msi.c
 create mode 100644 arch/powerpc/platforms/wsp/msi.h
 create mode 100644 arch/powerpc/platforms/wsp/wsp_pci.c
 create mode 100644 arch/powerpc/platforms/wsp/wsp_pci.h
 create mode 100644 arch/powerpc/sysdev/xics/ics-opal.c
 rename arch/powerpc/sysdev/mpc8xxx_gpio.c => drivers/gpio/gpio-mpc8xxx.c (98%)
 create mode 100644 drivers/tty/hvc/hvc_opal.c


