Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750867Ab1GZESS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jul 2011 00:18:18 -0400
Received: from gate.crashing.org ([63.228.1.57]:38396 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750746Ab1GZESP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jul 2011 00:18:15 -0400
Subject: [git pull] Please pull powerpc.git next branch
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linuxppc-dev list <linuxppc-dev@ozlabs.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 26 Jul 2011 14:17:33 +1000
Message-ID: <1311653853.25044.639.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus !

Here's the powerpc batch for this merge window (there might still be a
handful of small fixes coming later this week depending on my mood but
here's the bulk at least). There's a couple of trivial merge conflicts
with your tree, let me know if you prefer that I fix them myself.

No big highlights, mostly a random collection of bug fixes and
improvements (the big highlight is the base KVM support for P7 and
970 which has been merged via Avi's tree).

Cheers,
Ben.


The following changes since commit 750e06992d49666a7589aac555eb3bb68e4dbb88:

  Merge branch 'hwmon-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/jdelvare/staging (2011-07-25 14:10:34 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/benh/powerpc.git next

Akinobu Mita (2):
      powerpc/pseries: Introduce pSeries_reconfig_notify()
      powerpc/pseries: Improve error code on reconfiguration notifier failure

Andrew Gabbasov (1):
      powerpc: Exporting boot_cpuid_phys

Anton Blanchard (9):
      powerpc: Use -mtraceback=no
      powerpc/pseries/hvconsole: Fix dropped console output
      powerpc: Sync pseries and ppc64 defconfigs
      powerpc: Disable IRQs off tracer in ppc64 defconfig
      powerpc: Add mpt2sas driver to pseries and ppc64 defconfig
      powerpc: Enable lockup and hung task detectors in pseries and ppc64 defeconfigs
      powerpc/irq: Quieten irq mapping printks
      powerpc/pseries: Fix hvterm_raw_get_chars to accept < 16 chars, fixing xmon
      hvc_console: Add kdb support

Ashish Kalra (2):
      powerpc/85xx: Save scratch registers to thread info instead of using SPRGs.
      powerpc: introduce the ePAPR embedded hypervisor vmpic driver

Baruch Siach (1):
      MAINTAINERS: add arch/powerpc/platforms/85xx/ to the 85xx entry

Becky Bruce (3):
      powerpc: Whitespace fix to include/asm/pgtable-ppc64.h
      powerpc: mem_init should call memblock_is_reserved with phys_addr_t
      powerpc: Create next_tlbcam_idx percpu variable for FSL_BOOKE

Benjamin Herrenschmidt (12):
      Merge remote branch 'jwb/next' into next
      powerpc/hvsi: Move HVSI protocol definitions to a header file
      powerpc/pseries: Factor HVSI header struct in packet definitions
      powerpc/udbg: Register udbg console generically
      powerpc/pseries: Re-implement HVSI as part of hvc_vio
      powerpc/pseries: Move hvsi support into a library
      Merge remote branch 'origin/master' into next
      powerpc: Fix build problem with default ppc_md.progress commit
      powerpc/hvsi: Fix conflict with old HVSI driver
      powerpc/pseries: Fix hvc_vio.c build due to recent changes
      Merge remote-tracking branch 'jwb/next' into next
      powerpc: Copy back TIF flags on return from softirq stack

Christian Kujau (1):
      Document powerpc udbg-immortal

Dave Carroll (2):
      powerpc: Move free_initmem to common code
      powerpc: Add printk companion for ppc_md.progress

Dave Kleikamp (3):
      powerpc/44x: don't use tlbivax on AMP systems
      powerpc/44x: boot wrapper: allow kernel to load into non-zero address
      powerpc/47x: allow kernel to be loaded in higher physical memory

Dmitry Eremin-Solenikov (7):
      powerpc/mpic: Support compiling with DEBUG enabled
      powerpc/85xx: tqm8540 - add description for onboard flash
      powerpc/85xx: specify interrupt for pq3-localbus devices
      powerpc/maple: Enable scom access functions on Maple
      powerpc/maple: Register CPC925 EDAC device on all boards with CPC925
      powerpc: Correct annotations of pmu registration functions
      powerpc/cpufreq: Add cpufreq driver for Momentum Maple boards

Fabio Baltieri (1):
      powerpc/85xx: fix mpic configuration in CAMP mode

Felix Radensky (1):
      powerpc/p1022ds: Remove fixed-link property from ethernet nodes.

Hendrik Brueckner (1):
      hvc_console: Improve tty/console put_chars handling

Josh Boyer (3):
      ppc4xx: Add crypto and RNG entries to Sequoia DTS
      MAINTAINERS: Update PowerPC 4xx entry
      powerpc/4xx: Move PCIE printk to proper function

Kumar Gala (18):
      powerpc/book3e: Clarify HW table walk enable/disable message
      powerpc: Rename e55xx_smp_defconfig to corenet64_smp_defconfig
      powerpc: Add a defconfig for 'corenet' 32-bit platforms
      powerpc/85xx: Add P5020DS device tree
      powerpc/85xx: Add P3041DS device tree
      powerpc/85xx: Updates to P4080DS device tree
      powerpc/85xx: Cleanup PCIe support on corenet_ds boards
      powerpc/fsl_pci: Simplify matching logic for PCI_FIXUP_HEADER
      powerpc/pci: Move FSL fixup from 32-bit to common
      powerpc/85xx: Add PCI support in 64-bit mode on P5020DS
      powerpc/qe: Limit QE support to ppc32
      powerpc/85xx: Add P4080 SoC device tree include stub
      powerpc/85xx: Add P3041 SoC device tree include stub
      powerpc/85xx: Add P5020 SoC device tree include stub
      driver core: Add ability for arch code to setup pdev_archdata
      powerpc: implement arch_setup_pdev_archdata
      powerpc: Dont require a dma_ops struct to set dma mask
      powerpc/64: Make server perfmon only built on ppc64 server devices

Laurentiu TUDOR (1):
      powerpc/85xx: Remove stale BUG_ON in mpc85xx_smp_init

Lei Xu (2):
      powerpc/85xx: Update device tree to add nand info for p5020ds
      powerpc/85xx: Update device tree to add nand info for p3041ds

Mathias Krause (1):
      powerpc: Remove redundant set_fs(USER_DS)

Matt Evans (1):
      powerpc: Fix early boot accounting of CPUs

Michael Ellerman (1):
      powerpc: Add jump label support

Michael Neuling (3):
      powerpc: Fix doorbell type shift
      powerpc/kdump: Fix timeout in crash_kexec_wait_realmode
      powerpc: Add CFAR to oops output

Mike Williams (1):
      powerpc/4xx: Update Canyonlands and Glacier boards DTS to add HW RNG support

Mingkai Hu (1):
      powerpc/85xx: Add p2040 RDB board support

Paul Mackerras (1):
      powerpc: Avoid extra indirect function call in sending IPIs

Prabhakar Kushwaha (2):
      powerpc/85xx: Add host-pci(e) bridge only for RC
      powerpc/85xx: Add P1010RDB board support

Roy Zang (1):
      powerpc/85xx: Add basic P1023RDS board support

Scott Wood (4):
      powerpc/85xx: Set up doorbells even with no mpic
      powerpc/e500mc: Add support for the wait instruction in e500_idle
      powerpc/book3e-64: Reraise doorbell when masked by soft-irq-disable
      powerpc/book3e-64: use a separate TLB handler when linear map is bolted

Stefan Roese (1):
      powerpc/44x: Use correct phy-address dt nodes on taishan.dts

Stuart Yoder (1):
      powerpc: make irq_choose_cpu() available to all PIC drivers

Timur Tabi (12):
      powerpc: introduce ePAPR embedded hypervisor hcall interface
      powerpc: add Freescale hypervisor partition control functions
      powerpc/85xx: add board support for the Freescale hypervisor
      powerpc/p1022ds: add missing iounmap calls to platform file
      powerpc/85xx: clamp the P1022DS DIU pixel clock to allowed values
      powerpc/85xx: enable the framebuffer console for the defconfigs
      powerpc/86xx: improve calculation of DIU pixel clock on the MPC8610 HPCD
      powerpc/86xx: enable the framebuffer console on the MPC8610 HPCD
      powerpc/85xx: disable timebase synchronization under the hypervisor
      drivers/virt: introduce Freescale hypervisor management driver
      powerpc/85xx: add hypervisor config entries to corenet_smp_defconfig
      drivers/virt: add missing linux/interrupt.h to fsl_hypervisor.c

Tony Breeds (2):
      powerpc/4xx: Add check_link to struct ppc4xx_pciex_hwops
      powerpc/mm: Fix output of total_ram.

 Documentation/ioctl/ioctl-number.txt               |    1 +
 Documentation/kernel-parameters.txt                |    5 +
 MAINTAINERS                                        |    3 +-
 arch/powerpc/Kconfig                               |    3 +-
 arch/powerpc/Kconfig.debug                         |   15 +
 arch/powerpc/Makefile                              |    2 +-
 arch/powerpc/boot/dts/canyonlands.dts              |    5 +
 arch/powerpc/boot/dts/glacier.dts                  |    8 +-
 arch/powerpc/boot/dts/mpc8568mds.dts               |    2 +
 arch/powerpc/boot/dts/p1010rdb.dts                 |  280 ++++++
 arch/powerpc/boot/dts/p1010si.dtsi                 |  376 ++++++++
 arch/powerpc/boot/dts/p1022ds.dts                  |    2 -
 arch/powerpc/boot/dts/p1023rds.dts                 |  546 ++++++++++++
 arch/powerpc/boot/dts/p2040rdb.dts                 |  166 ++++
 arch/powerpc/boot/dts/p2040si.dtsi                 |  623 +++++++++++++
 arch/powerpc/boot/dts/p3041ds.dts                  |  214 +++++
 arch/powerpc/boot/dts/p3041si.dtsi                 |  660 ++++++++++++++
 arch/powerpc/boot/dts/p4080ds.dts                  |  533 +-----------
 arch/powerpc/boot/dts/p4080si.dtsi                 |  661 ++++++++++++++
 arch/powerpc/boot/dts/p5020ds.dts                  |  215 +++++
 arch/powerpc/boot/dts/p5020si.dtsi                 |  652 ++++++++++++++
 arch/powerpc/boot/dts/sequoia.dts                  |   12 +
 arch/powerpc/boot/dts/socrates.dts                 |    2 +
 arch/powerpc/boot/dts/taishan.dts                  |    4 +-
 arch/powerpc/boot/dts/tqm8540.dts                  |   42 +
 arch/powerpc/boot/dts/tqm8548-bigflash.dts         |    2 +
 arch/powerpc/boot/dts/tqm8548.dts                  |    2 +
 arch/powerpc/boot/dts/tqm8560.dts                  |    2 +
 arch/powerpc/boot/dts/xpedite5200.dts              |    2 +
 arch/powerpc/boot/dts/xpedite5200_xmon.dts         |    2 +
 arch/powerpc/boot/treeboot-iss4xx.c                |   23 +-
 arch/powerpc/configs/44x/iss476-smp_defconfig      |    6 +-
 arch/powerpc/configs/85xx/p1023rds_defconfig       |  173 ++++
 arch/powerpc/configs/86xx/mpc8610_hpcd_defconfig   |    5 +
 arch/powerpc/configs/corenet32_smp_defconfig       |  187 ++++
 ...e55xx_smp_defconfig => corenet64_smp_defconfig} |    0
 arch/powerpc/configs/mpc85xx_defconfig             |   12 +-
 arch/powerpc/configs/mpc85xx_smp_defconfig         |   10 +-
 arch/powerpc/configs/ppc64_defconfig               |   16 +-
 arch/powerpc/configs/pseries_defconfig             |    3 +
 arch/powerpc/include/asm/dbell.h                   |    2 +-
 arch/powerpc/include/asm/ehv_pic.h                 |   40 +
 arch/powerpc/include/asm/epapr_hcalls.h            |  502 +++++++++++
 arch/powerpc/include/asm/exception-64e.h           |   52 +-
 arch/powerpc/include/asm/fsl_hcalls.h              |  655 ++++++++++++++
 arch/powerpc/include/asm/hvsi.h                    |   94 ++
 arch/powerpc/include/asm/irq.h                     |    2 +
 arch/powerpc/include/asm/jump_label.h              |   47 +
 arch/powerpc/include/asm/mmu.h                     |   12 +-
 arch/powerpc/include/asm/pSeries_reconfig.h        |    2 +-
 arch/powerpc/include/asm/paca.h                    |    7 +-
 arch/powerpc/include/asm/pgtable-ppc64.h           |    3 +-
 arch/powerpc/include/asm/processor.h               |    5 +
 arch/powerpc/include/asm/reg.h                     |    4 +-
 arch/powerpc/include/asm/setup.h                   |    4 +
 arch/powerpc/include/asm/smp.h                     |    3 +-
 arch/powerpc/include/asm/udbg.h                    |    1 +
 arch/powerpc/kernel/Makefile                       |    1 +
 arch/powerpc/kernel/asm-offsets.c                  |    3 +
 arch/powerpc/kernel/crash.c                        |    6 +-
 arch/powerpc/kernel/dma.c                          |    4 +-
 arch/powerpc/kernel/exceptions-64e.S               |   22 +-
 arch/powerpc/kernel/head_44x.S                     |   42 +-
 arch/powerpc/kernel/head_64.S                      |    2 +-
 arch/powerpc/kernel/head_booke.h                   |   42 +-
 arch/powerpc/kernel/head_fsl_booke.S               |   49 +-
 arch/powerpc/kernel/idle_e500.S                    |   12 +
 arch/powerpc/kernel/irq.c                          |   50 +-
 arch/powerpc/kernel/jump_label.c                   |   23 +
 arch/powerpc/kernel/misc_64.S                      |    4 +-
 arch/powerpc/kernel/mpc7450-pmu.c                  |    2 +-
 arch/powerpc/kernel/pci-common.c                   |   18 +
 arch/powerpc/kernel/pci_32.c                       |   19 -
 arch/powerpc/kernel/perf_event.c                   |    2 +-
 arch/powerpc/kernel/power4-pmu.c                   |    2 +-
 arch/powerpc/kernel/power5+-pmu.c                  |    2 +-
 arch/powerpc/kernel/power5-pmu.c                   |    2 +-
 arch/powerpc/kernel/power6-pmu.c                   |    2 +-
 arch/powerpc/kernel/power7-pmu.c                   |    2 +-
 arch/powerpc/kernel/ppc970-pmu.c                   |    2 +-
 arch/powerpc/kernel/process.c                      |    4 +-
 arch/powerpc/kernel/prom.c                         |   16 +-
 arch/powerpc/kernel/setup-common.c                 |   27 +-
 arch/powerpc/kernel/setup_32.c                     |    4 +-
 arch/powerpc/kernel/setup_64.c                     |    6 +-
 arch/powerpc/kernel/smp.c                          |   30 +-
 arch/powerpc/kernel/udbg.c                         |    5 +
 arch/powerpc/mm/44x_mmu.c                          |   13 +-
 arch/powerpc/mm/init_32.c                          |   32 -
 arch/powerpc/mm/init_64.c                          |   16 -
 arch/powerpc/mm/mem.c                              |   35 +-
 arch/powerpc/mm/tlb_hash32.c                       |    4 +
 arch/powerpc/mm/tlb_low_64e.S                      |  206 +++++
 arch/powerpc/mm/tlb_nohash.c                       |   64 +-
 arch/powerpc/platforms/85xx/Kconfig                |   31 +
 arch/powerpc/platforms/85xx/Makefile               |    3 +
 arch/powerpc/platforms/85xx/corenet_ds.c           |   41 +-
 arch/powerpc/platforms/85xx/mpc85xx_ds.c           |    3 +-
 arch/powerpc/platforms/85xx/mpc85xx_rdb.c          |    5 +-
 arch/powerpc/platforms/85xx/p1010rdb.c             |  122 +++
 arch/powerpc/platforms/85xx/p1022_ds.c             |   18 +-
 arch/powerpc/platforms/85xx/p1023_rds.c            |  162 ++++
 arch/powerpc/platforms/85xx/p2040_rdb.c            |   88 ++
 arch/powerpc/platforms/85xx/p3041_ds.c             |   28 +-
 arch/powerpc/platforms/85xx/p4080_ds.c             |   38 +-
 arch/powerpc/platforms/85xx/p5020_ds.c             |   32 +-
 arch/powerpc/platforms/85xx/smp.c                  |   30 +-
 arch/powerpc/platforms/86xx/mpc8610_hpcd.c         |  107 +--
 arch/powerpc/platforms/Kconfig                     |    6 +-
 arch/powerpc/platforms/Kconfig.cputype             |    2 +-
 arch/powerpc/platforms/iseries/smp.c               |    2 +-
 arch/powerpc/platforms/maple/setup.c               |   41 +-
 arch/powerpc/platforms/powermac/setup.c            |    3 -
 arch/powerpc/platforms/powermac/smp.c              |    2 +-
 arch/powerpc/platforms/pseries/dlpar.c             |   10 +-
 arch/powerpc/platforms/pseries/hotplug-cpu.c       |   10 +-
 arch/powerpc/platforms/pseries/hotplug-memory.c    |   16 +-
 arch/powerpc/platforms/pseries/hvconsole.c         |    2 +-
 arch/powerpc/platforms/pseries/lpar.c              |  191 ----
 arch/powerpc/platforms/pseries/pseries.h           |    3 +-
 arch/powerpc/platforms/pseries/reconfig.c          |   28 +-
 arch/powerpc/platforms/pseries/setup.c             |    5 +-
 arch/powerpc/platforms/pseries/smp.c               |    2 +-
 arch/powerpc/platforms/wsp/smp.c                   |    2 +-
 arch/powerpc/sysdev/Makefile                       |    1 +
 arch/powerpc/sysdev/ehv_pic.c                      |  302 +++++++
 arch/powerpc/sysdev/fsl_pci.c                      |   83 +--
 arch/powerpc/sysdev/fsl_soc.c                      |   27 +
 arch/powerpc/sysdev/fsl_soc.h                      |    3 +
 arch/powerpc/sysdev/mpic.c                         |   38 +-
 arch/powerpc/sysdev/ppc4xx_pci.c                   |  147 ++--
 drivers/Kconfig                                    |    2 +
 drivers/Makefile                                   |    3 +
 drivers/base/platform.c                            |   21 +
 drivers/cpufreq/Kconfig                            |    5 +
 drivers/cpufreq/Kconfig.powerpc                    |    7 +
 drivers/cpufreq/Makefile                           |    5 +
 drivers/cpufreq/maple-cpufreq.c                    |  309 +++++++
 drivers/of/platform.c                              |    4 +-
 drivers/tty/hvc/Kconfig                            |    5 +
 drivers/tty/hvc/Makefile                           |    3 +-
 drivers/tty/hvc/hvc_console.c                      |   70 ++-
 drivers/tty/hvc/hvc_console.h                      |    4 +
 drivers/tty/hvc/hvc_vio.c                          |  408 ++++++++-
 drivers/tty/hvc/hvsi.c                             |  129 +--
 drivers/tty/hvc/hvsi_lib.c                         |  426 +++++++++
 drivers/virt/Kconfig                               |   32 +
 drivers/virt/Makefile                              |    5 +
 drivers/virt/fsl_hypervisor.c                      |  938 ++++++++++++++++++++
 include/linux/Kbuild                               |    1 +
 include/linux/fsl_hypervisor.h                     |  241 +++++
 include/linux/platform_device.h                    |    1 +
 152 files changed, 10499 insertions(+), 1441 deletions(-)
 create mode 100644 arch/powerpc/boot/dts/p1010rdb.dts
 create mode 100644 arch/powerpc/boot/dts/p1010si.dtsi
 create mode 100644 arch/powerpc/boot/dts/p1023rds.dts
 create mode 100644 arch/powerpc/boot/dts/p2040rdb.dts
 create mode 100644 arch/powerpc/boot/dts/p2040si.dtsi
 create mode 100644 arch/powerpc/boot/dts/p3041ds.dts
 create mode 100644 arch/powerpc/boot/dts/p3041si.dtsi
 create mode 100644 arch/powerpc/boot/dts/p4080si.dtsi
 create mode 100644 arch/powerpc/boot/dts/p5020ds.dts
 create mode 100644 arch/powerpc/boot/dts/p5020si.dtsi
 create mode 100644 arch/powerpc/configs/85xx/p1023rds_defconfig
 create mode 100644 arch/powerpc/configs/corenet32_smp_defconfig
 rename arch/powerpc/configs/{e55xx_smp_defconfig => corenet64_smp_defconfig} (100%)
 create mode 100644 arch/powerpc/include/asm/ehv_pic.h
 create mode 100644 arch/powerpc/include/asm/epapr_hcalls.h
 create mode 100644 arch/powerpc/include/asm/fsl_hcalls.h
 create mode 100644 arch/powerpc/include/asm/hvsi.h
 create mode 100644 arch/powerpc/include/asm/jump_label.h
 create mode 100644 arch/powerpc/kernel/jump_label.c
 create mode 100644 arch/powerpc/platforms/85xx/p1010rdb.c
 create mode 100644 arch/powerpc/platforms/85xx/p1023_rds.c
 create mode 100644 arch/powerpc/platforms/85xx/p2040_rdb.c
 create mode 100644 arch/powerpc/sysdev/ehv_pic.c
 create mode 100644 drivers/cpufreq/Kconfig.powerpc
 create mode 100644 drivers/cpufreq/maple-cpufreq.c
 create mode 100644 drivers/tty/hvc/hvsi_lib.c
 create mode 100644 drivers/virt/Kconfig
 create mode 100644 drivers/virt/Makefile
 create mode 100644 drivers/virt/fsl_hypervisor.c
 create mode 100644 include/linux/fsl_hypervisor.h


