Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752740Ab2LKGzv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2012 01:55:51 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:56894 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750877Ab2LKGzt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2012 01:55:49 -0500
MIME-Version: 1.0
Date: Tue, 11 Dec 2012 07:55:47 +0100
Message-ID: <CACRpkdYpzJkfAccQtkmMFLrjf0x34jb6NYiOQfVZ+KiejbtT9A@mail.gmail.com>
Subject: [GIT PULL] pinctrl changes for v3.8
From: Linus Walleij <linus.walleij@linaro.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, arm@kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

these are the first and major pinctrl changes for the v3.8 merge cycle.
Some of this is used as merge base for other trees so I better be early
on the trigger.

The major changes are described in the signed tag. All has been in
linux-next for a while.

This is the first time I've had to pull in external branches and use
some parallel topics for pinctrl so if I've done it wrong somehow
just tell me.

Anyway, please pull it in!

Yours,
Linus Walleij

The following changes since commit 77b67063bb6bce6d475e910d3b886a606d0d91f7:

  Linux 3.7-rc5 (2012-11-11 13:44:33 +0100)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/linusw/linux-pinctrl.git
tags/pinctrl-for-v3.8

for you to fetch changes up to 7c8f86a451fe8c010eb93c62d4d69727ccdbe435:

  ARM: mmp: select PINCTRL for ARCH_MMP (2012-12-02 00:09:09 +0100)

----------------------------------------------------------------
This is the pinctrl big pull request for v3.8.

As can be seen from the diffstat the major changes
are:

- A big conversion of the AT91 pinctrl driver and
  the associated ACKed platform changes under
  arch/arm/max-at91 and its device trees. This
  has been coordinated with the AT91 maintainers
  to go in through the pinctrl tree.

- A larger chunk of changes to the SPEAr drivers
  and the addition of the "plgpio" driver for the
  SPEAr as well.

- The removal of the remnants of the Nomadik driver
  from the arch/arm tree and fusion of that into
  the Nomadik driver and platform data header files.

- Some local movement in the Marvell MVEBU drivers,
  these now have their own subdirectory.

- The addition of a chunk of code to gpiolib under
  drivers/gpio to register gpio-to-pin range mappings
  from the GPIO side of things. This has been
  requested by Grant Likely and is now implemented,
  it is particularly useful for device tree work.

Then we have incremental updates all over the place,
many of these are cleanups and fixes from Axel Lin
who has done a great job of removing minor mistakes
and compilation annoyances.

----------------------------------------------------------------
Axel Lin (25):
      pinctrl: nomadik: Add terminating entry for platform_device_id table
      pinctrl: at91: Staticize non-exported symbols
      pinctrl: exynos: Add terminating entry for of_device_id table
      pinctrl: u300: Staticize non-exported symbols
      pinctrl: sirf: Staticize non-exported symbol
      pinctrl: Staticize pinconf_ops
      pinctrl: lantiq: Remove ltq_pmx_disable() function
      pinctrl: lantiq: Staticize non-exported symbols
      pinctrl: pinmux: Release all taken pins in pinmux_enable_setting
error paths
      pinctrl: spear: Staticize non-exported symbols
      pinctrl: mxs: Make PINCTRL_MXS select PINMUX && PINCONF
      pinctrl: tegra: Make PINCTRL_TEGRA select PINMUX && PINCONF
      pinctrl: pxa3xx: Use devm_request_and_ioremap
      pinctrl: pxa3xx: Remove phy_base and phy_size from struct
pxa3xx_pinmux_info
      pinctrl: tegra: Staticize non-exported symbols
      pinctrl: imx: Fix the logic checking if not able to find pin reg map
      pinctrl: spear: Fix the logic of setting reg in
pmx_init_gpio_pingroup_addr
      pinctrl: coh901: Return proper error if irq_domain_add_linear() fails
      pinctrl: spear: Make get_gpio_pingroup return NULL when no
gpio_pingroup found
      pinctrl: plgpio: Call clk_disable_unprepare only if
clk_prepare_enable is called
      pinctrl: nomadik: Prevent NULL dereference if of_match_device returns NULL
      pinctrl: nomadik: Staticize non-exported symbols
      gpiolib: Fix use after free in gpiochip_add_pin_range
      pinctrl: Drop selecting PINCONF for MMP2, PXA168 and PXA910
      ARM: mmp: select PINCTRL for ARCH_MMP

Barry Song (1):
      pinctrl: sirf: enable the driver support new SiRFmarco SoC

Haojian Zhuang (3):
      pinctrl: single: dump pinmux register value
      pinctrl: generic: add input schmitt disable parameter
      pinctrl: single: support gpio request and free

Jean-Christophe PLAGNIOL-VILLARD (29):
      arm: at91: use macro to declare soc boot data
      ARM: at91: gpio: implement request
      at91: regroup gpio and pinctrl under the same ranges
      arm: at91: at91sam9x5: fix gpio number per bank
      ARM: at91: add dummies pinctrl for non dt platform
      ARM: at91: add pinctrl support
      arm: at91: dt: at91sam9 add pinctrl support
      arm: at91: dt: at91sam9 add serial pinctrl support
      tty: atmel_serial: add pinctrl support
      arm: at91: dt: sam9m10g45ek: use rts/cts pinctrl group for uart1
      arm: at91: dt: sam9263ek: use rts/cts pinctrl group for uart0
      arm: at91: dt: sam9g20ek: use rts/cts/dtr/dsr/dcd/ri pinctrl
group for uart0
      arm: at91: dt: at91sam9 add nand pinctrl support
      MTD: atmel_nand: add pinctrl consumer support
      pinctrl: at91: fix typo on PULL_UP
      gpio/at91: auto request and configure the pio as input when the
interrupt is used via DT
      pinctrl/: at91: fix warnings
      MAINTAINERS: add pinctrl atmel at91 entry
      pinctrl: at91: provide gpio names
      pinctrl: at91 add deglitch, debounce, pull down and schmitt
trigger mux option support
      ARM: at91sam9: add macb pinctrl support
      ARM: at91: fix usart/uart namimg in pinctrl
      ARM: at91: dt: at91sam9260: split rts and cts pinctrl not
      ARM: at91: add Ronetix pm9g45 board support
      ARM: at91: add Somfy Animeo IP board support
      ARM: at91: dt: at91sam9: add mmc pinctrl support
      ARM: at91: dt: add mmc pinctrl for Atmel reference boards
      ARM: at91: Animeo IP: add mmc support
      ARM: at91: pm9g45: add mmc support

Jean-Nicolas Graux (3):
      pinctrl/nomadik: update other alternate-C functions on DB8500
      pinctrl/nomadik: debugfs display of other alternate-C functions
      pinctrl/nomadik: db8540: fix moduartstmmux_oc4_1 pin group definition.

Joachim Eastwood (6):
      ARM: AT91: Fix build failure on board-dt
      ARM: AT91: Add DT support to AT91RM9200 System Timer
      ARM: AT91: Add usart/tc/pio/ohci DT clock lookup to AT91RM9200
      ARM: AT91: Add AT91RM9200 DT board
      ARM: AT91: Add AT91RM9200 device tree
      ARM: AT91: Add AT91RM9200EK board device tree

Jonas Aaberg (2):
      ARM: ux500: add PRCM register base for pinctrl
      pinctrl/nomadik: make independent of prcmu driver

Linus Walleij (26):
      Merge branch 'j/pinctrl' of
http://github.com/at91linux/linux-at91 into at91
      pinctrl/nomadik: move the platform data header
      pinctrl/nomadik: merge old pincfg header
      pinctrl: reserve pins when states are activated
      ARM: U300: bump IRQs to offset 32
      pinctrl/coh901: use irqdomain, allocate irqdescs
      pinctrl/coh901: convert to use managed resources
      pinctrl/u300: use managed resources
      gpiolib: fix up function prototypes etc
      gpiolib-of: staticize the pin range calls
      gpiolib: remove duplicate pin range code
      gpiolib: call pin removal in chip removal function
      gpiolib: separation of pin concerns
      gpiolib: iron out include ladder mistakes
      Merge branch 'at91' into devel
      Merge branch 'nomadik' into devel
      Merge branch 'delivery/pinctrl-at91-3.8' of
http://github.com/at91linux/linux-at91 into at91
      gpiolib: let gpiochip_add_pin_range() specify offset
      gpiolib: rename find_pinctrl_*
      pinctrl: make range registration defer properly
      gpiolib: return any error code from range creation
      pinctrl: add function to retrieve range from pin
      pinctrl/u300/coh901: let the gpio_chip register the range
      pinctrl/u300/coh901: stop spawning pinctrl from GPIO
      gpiolib: rename pin range arguments
      Merge branch 'at91' into devel

Ludovic Desroches (3):
      ARM: at91: add clocks for DT entries
      ARM: at91/dts: add nodes for atmel hsmci controllers for atmel SOCs
      ARM: at91/dts: add nodes for atmel hsmci controllers for atmel boards

Maxime Coquelin (1):
      ARM: plat-nomadik: Introduce new DB8540 GPIO registers

Patrice Chotard (5):
      ARM: plat-nomadik: move NMK_GPIO_PER_CHIP into gpio-nomadik.h
      pinctrl/nomadik: allow to support several ranges per GPIO bank
      pinctrl/nomadik: db8500: fix kp pin group
      pinctrl/nomadik: db8500: split clkout group
      pinctrl/nomadik: db8540: split clkout group

Sachin Kamat (1):
      pinctrl: pinctrl-single: Fix error check condition

Shiraz Hashim (2):
      gpiolib: provide provision to register pin ranges
      pinctrl: SPEAr: Add SoC specific gpio configuration routines

Thomas Petazzoni (3):
      pinctrl: mvebu: allow plat-orion architectures to use pinctrl-mvebu
      pinctrl: mvebu: remove useless include
      pinctrl: mvebu: move to its own directory

Tushar Behera (1):
      pinctrl: SPEAr: Update error check for unsigned variables

Viresh Kumar (5):
      Revert "pinctrl: remove pinctrl_remove_gpio_range"
      pinctrl: SPEAr: Add plgpio driver
      pinctrl: SPEAr: Add gpio ranges support
      ARM: SPEAr: Add plgpio node in device tree dtsi files
      Pinctrl/spear: plgpio: don't call prepare/unprepare

Wei Yongjun (3):
      pinctrl/at91: remove duplicated include from pinctrl-at91.c
      pinctrl/at91: using for_each_set_bit to simplify the code
      pinctrl/at91: remove unused variable in at91_dt_node_to_map()

 .../devicetree/bindings/arm/atmel-at91.txt         |    6 +
 Documentation/devicetree/bindings/gpio/gpio.txt    |   36 +
 .../devicetree/bindings/gpio/gpio_atmel.txt        |    5 +
 .../bindings/pinctrl/atmel,at91-pinctrl.txt        |  141 ++
 Documentation/gpio.txt                             |   42 +
 Documentation/pinctrl.txt                          |    7 +-
 MAINTAINERS                                        |    6 +
 arch/arm/Kconfig                                   |    3 +
 arch/arm/boot/dts/Makefile                         |   48 +-
 arch/arm/boot/dts/animeo_ip.dts                    |  178 +++
 arch/arm/boot/dts/at91rm9200.dtsi                  |  349 +++++
 arch/arm/boot/dts/at91rm9200ek.dts                 |   79 +
 arch/arm/boot/dts/at91sam9260.dtsi                 |  295 +++-
 arch/arm/boot/dts/at91sam9263.dtsi                 |  299 +++-
 arch/arm/boot/dts/at91sam9263ek.dts                |   29 +
 arch/arm/boot/dts/at91sam9g15.dtsi                 |   28 +
 arch/arm/boot/dts/at91sam9g15ek.dts                |   16 +
 arch/arm/boot/dts/at91sam9g20ek_2mmc.dts           |   26 +
 arch/arm/boot/dts/at91sam9g20ek_common.dtsi        |   30 +
 arch/arm/boot/dts/at91sam9g25.dtsi                 |   28 +
 arch/arm/boot/dts/at91sam9g25ek.dts                |   49 +-
 arch/arm/boot/dts/at91sam9g35.dtsi                 |   28 +
 arch/arm/boot/dts/at91sam9g35ek.dts                |   16 +
 arch/arm/boot/dts/at91sam9g45.dtsi                 |  301 +++-
 arch/arm/boot/dts/at91sam9m10g45ek.dts             |   48 +
 arch/arm/boot/dts/at91sam9n12.dtsi                 |  225 ++-
 arch/arm/boot/dts/at91sam9n12ek.dts                |   22 +
 arch/arm/boot/dts/at91sam9x25.dtsi                 |   49 +
 arch/arm/boot/dts/at91sam9x25ek.dts                |   16 +
 arch/arm/boot/dts/at91sam9x35.dtsi                 |   28 +
 arch/arm/boot/dts/at91sam9x35ek.dts                |   16 +
 arch/arm/boot/dts/at91sam9x5.dtsi                  |  270 +++-
 arch/arm/boot/dts/at91sam9x5ek.dtsi                |  101 ++
 arch/arm/boot/dts/pm9g45.dts                       |  165 ++
 arch/arm/boot/dts/spear1310-evb.dts                |    4 +
 arch/arm/boot/dts/spear1310.dtsi                   |   27 +
 arch/arm/boot/dts/spear1340-evb.dts                |    4 +
 arch/arm/boot/dts/spear1340.dtsi                   |   26 +
 arch/arm/boot/dts/spear310.dtsi                    |   22 +-
 arch/arm/boot/dts/spear320-evb.dts                 |    4 +
 arch/arm/boot/dts/spear320.dtsi                    |   23 +-
 arch/arm/configs/at91_dt_defconfig                 |    1 +
 arch/arm/mach-at91/Kconfig                         |    9 +
 arch/arm/mach-at91/Makefile                        |    1 +
 arch/arm/mach-at91/at91rm9200.c                    |   22 +-
 arch/arm/mach-at91/at91rm9200_time.c               |   63 +-
 arch/arm/mach-at91/at91sam9260.c                   |    8 +-
 arch/arm/mach-at91/at91sam9261.c                   |    4 +-
 arch/arm/mach-at91/at91sam9263.c                   |   11 +-
 arch/arm/mach-at91/at91sam9g45.c                   |   12 +-
 arch/arm/mach-at91/at91sam9n12.c                   |   16 +-
 arch/arm/mach-at91/at91sam9rl.c                    |    4 +-
 arch/arm/mach-at91/at91sam9x5.c                    |   21 +-
 arch/arm/mach-at91/board-dt.c                      |    2 -
 arch/arm/mach-at91/board-rm9200-dt.c               |   57 +
 arch/arm/mach-at91/generic.h                       |    1 +
 arch/arm/mach-at91/gpio.c                          |  190 +--
 arch/arm/mach-at91/setup.c                         |   20 +-
 arch/arm/mach-at91/soc.h                           |   12 +-
 arch/arm/mach-nomadik/board-nhk8815.c              |    3 +-
 arch/arm/mach-nomadik/cpu-8815.c                   |    2 +-
 arch/arm/mach-nomadik/i2c-8815nhk.c                |    3 +-
 arch/arm/mach-u300/core.c                          |    5 +-
 arch/arm/mach-u300/include/mach/irqs.h             |  126 +-
 arch/arm/mach-ux500/board-mop500-audio.c           |    3 +-
 arch/arm/mach-ux500/board-mop500-pins.c            |    3 +-
 arch/arm/mach-ux500/board-mop500.c                 |    2 +-
 arch/arm/mach-ux500/cpu-db8500.c                   |    6 +-
 arch/arm/mach-ux500/devices-common.c               |    3 +-
 arch/arm/mach-ux500/devices-common.h               |    8 +-
 arch/arm/plat-nomadik/include/plat/gpio-nomadik.h  |  102 --
 drivers/gpio/gpiolib-of.c                          |   52 +
 drivers/gpio/gpiolib.c                             |   76 +
 drivers/mtd/nand/atmel_nand.c                      |    9 +
 drivers/pinctrl/Kconfig                            |   50 +-
 drivers/pinctrl/Makefile                           |    7 +-
 drivers/pinctrl/core.c                             |   58 +
 drivers/pinctrl/core.h                             |    2 +
 drivers/pinctrl/devicetree.c                       |   11 +
 drivers/pinctrl/mvebu/Kconfig                      |   24 +
 drivers/pinctrl/mvebu/Makefile                     |    5 +
 drivers/pinctrl/{ => mvebu}/pinctrl-armada-370.c   |    0
 drivers/pinctrl/{ => mvebu}/pinctrl-armada-xp.c    |    0
 drivers/pinctrl/{ => mvebu}/pinctrl-dove.c         |    0
 drivers/pinctrl/{ => mvebu}/pinctrl-kirkwood.c     |    0
 drivers/pinctrl/{ => mvebu}/pinctrl-mvebu.c        |    1 -
 drivers/pinctrl/{ => mvebu}/pinctrl-mvebu.h        |    0
 drivers/pinctrl/pinconf-generic.c                  |    1 +
 drivers/pinctrl/pinctrl-at91.c                     | 1634 ++++++++++++++++++++
 drivers/pinctrl/pinctrl-bcm2835.c                  |    2 +-
 drivers/pinctrl/pinctrl-coh901.c                   |  175 ++-
 drivers/pinctrl/pinctrl-exynos.c                   |    1 +
 drivers/pinctrl/pinctrl-falcon.c                   |    2 +-
 drivers/pinctrl/pinctrl-imx.c                      |    4 +-
 drivers/pinctrl/pinctrl-lantiq.c                   |   23 +-
 drivers/pinctrl/pinctrl-mxs.c                      |    2 +-
 drivers/pinctrl/pinctrl-nomadik-db8500.c           |  125 +-
 drivers/pinctrl/pinctrl-nomadik-db8540.c           |   16 +-
 drivers/pinctrl/pinctrl-nomadik.c                  |  152 +-
 drivers/pinctrl/pinctrl-nomadik.h                  |    2 +-
 drivers/pinctrl/pinctrl-pxa3xx.c                   |   12 +-
 drivers/pinctrl/pinctrl-pxa3xx.h                   |    2 -
 drivers/pinctrl/pinctrl-single.c                   |   90 +-
 drivers/pinctrl/pinctrl-sirf.c                     |   52 +-
 drivers/pinctrl/pinctrl-tegra.c                    |   24 +-
 drivers/pinctrl/pinctrl-u300.c                     |   97 +-
 drivers/pinctrl/pinctrl-xway.c                     |    2 +-
 drivers/pinctrl/pinmux.c                           |   85 +-
 drivers/pinctrl/spear/Kconfig                      |   11 +
 drivers/pinctrl/spear/Makefile                     |    1 +
 drivers/pinctrl/spear/pinctrl-plgpio.c             |  758 +++++++++
 drivers/pinctrl/spear/pinctrl-spear.c              |  131 +-
 drivers/pinctrl/spear/pinctrl-spear.h              |   60 +
 drivers/pinctrl/spear/pinctrl-spear1310.c          |  264 ++++
 drivers/pinctrl/spear/pinctrl-spear1340.c          |   27 +
 drivers/pinctrl/spear/pinctrl-spear300.c           |    2 +
 drivers/pinctrl/spear/pinctrl-spear310.c           |    2 +
 drivers/pinctrl/spear/pinctrl-spear320.c           |    2 +
 drivers/pinctrl/spear/pinctrl-spear3xx.c           |   37 +
 drivers/tty/serial/atmel_serial.c                  |    8 +
 include/asm-generic/gpio.h                         |   47 +
 include/linux/gpio.h                               |   21 +-
 include/linux/pinctrl/pinconf-generic.h            |    5 +-
 include/linux/pinctrl/pinctrl.h                    |   19 +
 include/linux/platform_data/pinctrl-coh901.h       |    4 -
 .../linux/platform_data/pinctrl-nomadik.h          |  111 +-
 126 files changed, 7065 insertions(+), 1058 deletions(-)
 create mode 100644
Documentation/devicetree/bindings/pinctrl/atmel,at91-pinctrl.txt
 create mode 100644 arch/arm/boot/dts/animeo_ip.dts
 create mode 100644 arch/arm/boot/dts/at91rm9200.dtsi
 create mode 100644 arch/arm/boot/dts/at91rm9200ek.dts
 create mode 100644 arch/arm/boot/dts/at91sam9g15.dtsi
 create mode 100644 arch/arm/boot/dts/at91sam9g15ek.dts
 create mode 100644 arch/arm/boot/dts/at91sam9g25.dtsi
 create mode 100644 arch/arm/boot/dts/at91sam9g35.dtsi
 create mode 100644 arch/arm/boot/dts/at91sam9g35ek.dts
 create mode 100644 arch/arm/boot/dts/at91sam9x25.dtsi
 create mode 100644 arch/arm/boot/dts/at91sam9x25ek.dts
 create mode 100644 arch/arm/boot/dts/at91sam9x35.dtsi
 create mode 100644 arch/arm/boot/dts/at91sam9x35ek.dts
 create mode 100644 arch/arm/boot/dts/at91sam9x5ek.dtsi
 create mode 100644 arch/arm/boot/dts/pm9g45.dts
 create mode 100644 arch/arm/mach-at91/board-rm9200-dt.c
 delete mode 100644 arch/arm/plat-nomadik/include/plat/gpio-nomadik.h
 create mode 100644 drivers/pinctrl/mvebu/Kconfig
 create mode 100644 drivers/pinctrl/mvebu/Makefile
 rename drivers/pinctrl/{ => mvebu}/pinctrl-armada-370.c (100%)
 rename drivers/pinctrl/{ => mvebu}/pinctrl-armada-xp.c (100%)
 rename drivers/pinctrl/{ => mvebu}/pinctrl-dove.c (100%)
 rename drivers/pinctrl/{ => mvebu}/pinctrl-kirkwood.c (100%)
 rename drivers/pinctrl/{ => mvebu}/pinctrl-mvebu.c (99%)
 rename drivers/pinctrl/{ => mvebu}/pinctrl-mvebu.h (100%)
 create mode 100644 drivers/pinctrl/pinctrl-at91.c
 create mode 100644 drivers/pinctrl/spear/pinctrl-plgpio.c
 rename arch/arm/plat-nomadik/include/plat/pincfg.h =>
include/linux/platform_data/pinctrl-nomadik.h (66%)
