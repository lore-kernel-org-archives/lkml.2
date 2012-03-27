Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757718Ab2C0HVL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2012 03:21:11 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:40693 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754651Ab2C0HVD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2012 03:21:03 -0400
MIME-Version: 1.0
From: Grant Likely <grant.likely@secretlab.ca>
Date: Tue, 27 Mar 2012 00:20:41 -0700
X-Google-Sender-Auth: g6hUfZBgoeEDW0objQ36D51l4HM
Message-ID: <CACxGe6s1GFkqgxsbKQWQxcoJZjTkkFHbAv3tqK2cPn6tho502w@mail.gmail.com>
Subject: [GIT PULL] GPIO changes for v3.4
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Here are the GPIO changes for v3.4.  I held of sending these because
the irq_domain rework broke the new sodaville driver in this branch.
However, the fixup is nontrivial and don't have a patch ready for
merging yet, but I definitely didn't want to respin the gpio branch to
pull the sodaville driver back out.  In the end I marked the sodaville
driver as broken. I think is the best solution for now since it is new
driver code and so there isn't any fear of regression by doing that.
I expect to have a proper fixup patch in place and sent to you before
-rc2 is released.

The diffstat below shows more changes that are actually present here
compared with your tree.  It looks much smaller after merging.  I
don't know enough about git to know how to filter that out, but I
suspect it is due to this branch having several different dependent
branches that have already been merged into your tree.

Please pull.

g.

The following changes since commit fde7d9049e55ab85a390be7f415d74c9f62dd0f9:

  Linux 3.3-rc7 (2012-03-10 13:49:52 -0800)

are available in the git repository at:

  git://git.secretlab.ca/git/linux-2.6 tags/gpio-for-linus

for you to fetch changes up to c77c8a6fd3d57b586ff5ecb5ab5b32ca4f54fe75:

  gpio/ep93xx: Remove unused inline function and useless pr_err
message (2012-03-25 21:25:56 -0700)

----------------------------------------------------------------
GPIO changes for v3.4

Primarily gpio device driver changes with some minor side effects
under arch/arm and arch/x86.  Also includes a few core changes such as
explicitly supporting (electrical) open source and open drain outputs
and some help for parsing gpio devicetree properties.

----------------------------------------------------------------
Arnd Bergmann (1):
      ARM: tegra: export tegra_gpio_{en,dis}able

Benoit Cousson (4):
      gpio/omap: Remove bank->id information and misc cleanup
      gpio/omap: Use devm_ API and add request_mem_region
      gpio/omap: Add DT support to GPIO driver
      gpio/omap: Fix IRQ handling for SPARSE_IRQ

Bhupesh Sharma (1):
      gpio/gpio-stmpe: Fix the value returned by _get_value routine

Charulatha V (8):
      gpio/omap: remove dependency on gpio_bank_count
      gpio/omap: use flag to identify wakeup domain
      gpio/omap: make gpio_context part of gpio_bank structure
      gpio/omap: make non-wakeup GPIO part of pdata
      gpio/omap: avoid cpu checks during module ena/disable
      gpio/omap: use pinctrl offset instead of macro
      gpio/omap: remove bank->method & METHOD_* macros
      gpio/omap: fix bankwidth for OMAP7xx MPUIO

Grant Likely (6):
      Merge branch 'for_3.4/gpio/runtime-pm-cleanup' of
git://git.kernel.org/.../khilman/linux-omap-pm into gpio/next
      Merge branch 'irqdomain/next' into gpio/next
      gpio: constify the data parameter to gpiochip_find()
      Merge tag 'v3.3-rc7' into gpio/next
      Merge branch 'for_3.4/fixes/gpio-2' of
git://git.kernel.org/.../khilman/linux-omap-pm into gpio/next
      gpio/sodaville: Mark broken due to core irqdomain migration

H Hartley Sweeten (1):
      gpio/ep93xx: Remove unused inline function and useless pr_err message

Jean-Christophe PLAGNIOL-VILLARD (1):
      of_gpio: add support of of_gpio_named_count to be able to count named gpio

Kevin Hilman (1):
      gpio/omap: fix wakeups on level-triggered GPIOs

Laxman Dewangan (4):
      gpio: tps65910: Add sleep control support
      Documentation: gpio: Add details of open-drain/source configuration
      gpio: gpiolib: Support for open drain/collector gpios
      gpio: gpiolib: Support for open source/emitter gpios

Mark Brown (1):
      gpiolib: Add comments explaining the _cansleep() WARN_ON()s

Ming Lei (1):
      Fix circular locking dependency (3.3-rc2)

Nishanth Menon (4):
      gpio/omap: save and restore debounce registers
      gpio/omap: enable irq at the end of all configuration in restore
      gpio/omap: restore OE only after setting the output level
      gpio/omap: handle set_dataout reg capable IP on restore

Roland Stigge (2):
      GPIO: LPC32xx: Fix missing bit selection mask
      GPIO: LPC32xx: Add output reading to GPO P3

Sebastian Andrzej Siewior (1):
      gpio: Add a driver for Sodaville GPIO controller

Sekhar Nori (2):
      gpio/davinci: fix oops on unbanked gpio irq request
      gpio/davinci: fix enabling unbanked GPIO IRQs

Stephen Warren (2):
      Documentation/gpio.txt: Explain expected pinctrl interaction
      gpio: tegra: tegra_gpio_config shouldn't be __init

Tarun Kanti DebBarma (20):
      gpio/omap: handle save/restore context in GPIO driver
      gpio/omap: further cleanup using wkup_en register
      gpio/omap: use level/edge detect reg offsets
      gpio/omap: remove hardcoded offsets in context save/restore
      gpio/omap: cleanup set_gpio_triggering function
      gpio/omap: cleanup omap_gpio_mod_init function
      gpio/omap: remove unnecessary bit-masking for read access
      gpio/omap: use pm-runtime framework
      gpio/omap: optimize suspend and resume functions
      gpio/omap: cleanup prepare_for_idle and resume_after_idle
      gpio/omap: fix debounce clock handling
      gpio/omap: fix incorrect access of debounce module
      gpio/omap: remove omap_gpio_save_context overhead
      gpio/omap: fix wakeup_en register update in _set_gpio_wakeup()
      gpio/omap: fix trigger type to unsigned
      gpio/omap: fix _set_gpio_irqenable implementation
      gpio/omap: fix missing dataout context save in _set_gpio_dataout_reg
      gpio/omap: fix incorrect context restore logic in omap_gpio_runtime_*
      gpio/omap: fix incorrect update to context.irqenable1
      gpio/omap: fix redundant decoding of gpio offset

Tony Lindgren (1):
      gpio/omap: Fix section warning for omap_mpuio_alloc_gc()

Viresh Kumar (1):
      gpio/gpio-pl061: No need of thaw and poweroff routines for hibernate

wu guoxing (1):
      ARM/mx35/3ds: gpio: add mc9s08dz60 gpio function

 Documentation/IRQ-domain.txt                       |  117 ++
 .../devicetree/bindings/gpio/gpio-omap.txt         |   36 +
 .../devicetree/bindings/gpio/sodaville.txt         |   48 +
 Documentation/gpio.txt                             |   40 +-
 MAINTAINERS                                        |    9 +
 arch/arm/common/gic.c                              |   95 +-
 arch/arm/common/vic.c                              |   16 +-
 arch/arm/include/asm/hardware/gic.h                |    4 +-
 arch/arm/include/asm/hardware/vic.h                |    2 +
 arch/arm/mach-exynos/common.c                      |    2 +-
 arch/arm/mach-imx/imx51-dt.c                       |    4 +-
 arch/arm/mach-imx/imx53-dt.c                       |    4 +-
 arch/arm/mach-imx/mach-imx6q.c                     |    3 +-
 arch/arm/mach-msm/board-msm8x60.c                  |    8 +-
 arch/arm/mach-omap1/gpio15xx.c                     |    7 +-
 arch/arm/mach-omap1/gpio16xx.c                     |   47 +-
 arch/arm/mach-omap1/gpio7xx.c                      |   14 +-
 arch/arm/mach-omap2/board-generic.c                |    2 +-
 arch/arm/mach-omap2/gpio.c                         |   36 +-
 arch/arm/mach-omap2/pm34xx.c                       |   14 -
 arch/arm/mach-prima2/irq.c                         |    2 +-
 arch/arm/mach-versatile/core.c                     |    7 +-
 arch/arm/plat-omap/include/plat/gpio.h             |   51 +-
 arch/c6x/Kconfig                                   |    1 +
 arch/c6x/include/asm/irq.h                         |  245 +----
 arch/c6x/kernel/irq.c                              |  612 +---------
 arch/c6x/platforms/megamod-pic.c                   |   25 +-
 arch/microblaze/Kconfig                            |    1 +
 arch/microblaze/include/asm/hardirq.h              |   16 -
 arch/microblaze/include/asm/irq.h                  |   42 +-
 arch/microblaze/kernel/intc.c                      |   61 +-
 arch/microblaze/kernel/irq.c                       |   24 +-
 arch/microblaze/kernel/setup.c                     |    2 -
 arch/mips/Kconfig                                  |    1 +
 arch/mips/include/asm/irq.h                        |    5 +-
 arch/mips/kernel/prom.c                            |   14 -
 arch/openrisc/include/asm/prom.h                   |   10 +-
 arch/powerpc/Kconfig                               |    1 +
 arch/powerpc/include/asm/ehv_pic.h                 |    2 +-
 arch/powerpc/include/asm/i8259.h                   |    2 +-
 arch/powerpc/include/asm/irq.h                     |  247 +----
 arch/powerpc/include/asm/mpic.h                    |    2 +-
 arch/powerpc/include/asm/xics.h                    |    2 +-
 arch/powerpc/kernel/irq.c                          |  617 +---------
 arch/powerpc/platforms/512x/mpc5121_ads_cpld.c     |   12 +-
 arch/powerpc/platforms/52xx/media5200.c            |   15 +-
 arch/powerpc/platforms/52xx/mpc52xx_gpt.c          |   16 +-
 arch/powerpc/platforms/52xx/mpc52xx_pic.c          |   12 +-
 arch/powerpc/platforms/82xx/pq2ads-pci-pic.c       |   14 +-
 arch/powerpc/platforms/85xx/socrates_fpga_pic.c    |   15 +-
 arch/powerpc/platforms/86xx/gef_pic.c              |   15 +-
 arch/powerpc/platforms/cell/axon_msi.c             |   29 +-
 arch/powerpc/platforms/cell/beat_interrupt.c       |   16 +-
 arch/powerpc/platforms/cell/interrupt.c            |   16 +-
 arch/powerpc/platforms/cell/spider-pic.c           |   14 +-
 arch/powerpc/platforms/embedded6xx/flipper-pic.c   |   24 +-
 arch/powerpc/platforms/embedded6xx/hlwd-pic.c      |   29 +-
 arch/powerpc/platforms/iseries/irq.c               |   11 +-
 arch/powerpc/platforms/powermac/pic.c              |   26 +-
 arch/powerpc/platforms/powermac/smp.c              |    9 +-
 arch/powerpc/platforms/ps3/interrupt.c             |   11 +-
 arch/powerpc/platforms/wsp/opb_pic.c               |   26 +-
 arch/powerpc/sysdev/cpm1.c                         |    9 +-
 arch/powerpc/sysdev/cpm2_pic.c                     |   23 +-
 arch/powerpc/sysdev/ehv_pic.c                      |   14 +-
 arch/powerpc/sysdev/fsl_msi.c                      |   10 +-
 arch/powerpc/sysdev/fsl_msi.h                      |    2 +-
 arch/powerpc/sysdev/i8259.c                        |   15 +-
 arch/powerpc/sysdev/ipic.c                         |   31 +-
 arch/powerpc/sysdev/ipic.h                         |    2 +-
 arch/powerpc/sysdev/mpc8xx_pic.c                   |   11 +-
 arch/powerpc/sysdev/mpic.c                         |   17 +-
 arch/powerpc/sysdev/mpic_msi.c                     |    2 +-
 arch/powerpc/sysdev/mv64x60_pic.c                  |   11 +-
 arch/powerpc/sysdev/qe_lib/qe_ic.c                 |   26 +-
 arch/powerpc/sysdev/qe_lib/qe_ic.h                 |    2 +-
 arch/powerpc/sysdev/tsi108_pci.c                   |   13 +-
 arch/powerpc/sysdev/uic.c                          |   26 +-
 arch/powerpc/sysdev/xics/xics-common.c             |   25 +-
 arch/powerpc/sysdev/xilinx_intc.c                  |   19 +-
 arch/sparc/include/asm/prom.h                      |   10 +-
 arch/x86/Kconfig                                   |    2 +
 arch/x86/include/asm/irq_controller.h              |   12 -
 arch/x86/include/asm/prom.h                        |   10 -
 arch/x86/kernel/devicetree.c                       |  101 +--
 arch/x86/platform/ce4100/falconfalls.dts           |    7 +-
 drivers/gpio/Kconfig                               |   14 +
 drivers/gpio/Makefile                              |    2 +
 drivers/gpio/gpio-davinci.c                        |   26 +-
 drivers/gpio/gpio-ep93xx.c                         |    8 -
 drivers/gpio/gpio-lpc32xx.c                        |   19 +-
 drivers/gpio/gpio-mc9s08dz60.c                     |  161 +++
 drivers/gpio/gpio-mpc8xxx.c                        |   30 +-
 drivers/gpio/gpio-omap.c                           | 1313 ++++++++++----------
 drivers/gpio/gpio-pl061.c                          |    7 +-
 drivers/gpio/gpio-sodaville.c                      |  302 +++++
 drivers/gpio/gpio-stmpe.c                          |    2 +-
 drivers/gpio/gpio-tegra.c                          |    4 +-
 drivers/gpio/gpio-tps65910.c                       |   20 +-
 drivers/gpio/gpiolib.c                             |   98 ++-
 drivers/mfd/Kconfig                                |    1 +
 drivers/mfd/twl-core.c                             |   21 +-
 drivers/net/phy/mdio-gpio.c                        |    4 +-
 drivers/of/gpio.c                                  |   11 +-
 drivers/of/platform.c                              |    4 +-
 include/asm-generic/gpio.h                         |    4 +-
 include/linux/gpio.h                               |    6 +
 include/linux/irqdomain.h                          |  191 ++-
 include/linux/mfd/tps65910.h                       |    8 +
 include/linux/of_address.h                         |   33 +-
 include/linux/of_gpio.h                            |   27 +-
 include/linux/of_irq.h                             |    4 +-
 include/linux/of_platform.h                        |   12 +-
 kernel/irq/irqdomain.c                             |  828 +++++++++++--
 114 files changed, 2965 insertions(+), 3405 deletions(-)
 create mode 100644 Documentation/IRQ-domain.txt
 create mode 100644 Documentation/devicetree/bindings/gpio/gpio-omap.txt
 create mode 100644 Documentation/devicetree/bindings/gpio/sodaville.txt
 delete mode 100644 arch/x86/include/asm/irq_controller.h
 create mode 100644 drivers/gpio/gpio-mc9s08dz60.c
 create mode 100644 drivers/gpio/gpio-sodaville.c
