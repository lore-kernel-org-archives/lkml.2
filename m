Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752853Ab2JBGC3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 02:02:29 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:50535 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751432Ab2JBGC1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 02:02:27 -0400
MIME-Version: 1.0
Date: Tue, 2 Oct 2012 08:02:26 +0200
Message-ID: <CACRpkdYbkLs=mSy37dE_tQGkeGBCmwu_Ajg3L4ezYeoU8gTYFQ@mail.gmail.com>
Subject: [GIT PULL] GPIO changes for v3.7
From: Linus Walleij <linus.walleij@linaro.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Grant Likely <grant.likely@secretlab.ca>,
        arm@kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

this is my major GPIO pull request for the v3.7 merge window.
The description of what's going on is in the tag (see below).
I think some of it is prerequisites for the ARM SoC tree so better
send this pull early.

All has boiled in -next for some time except the 4 topmost
commits, which are oneline fixes (would else be -rc material)
and a documentation fix.

Please pull it in!
Yours,
Linus Walleij


The following changes since commit d9875690d9b89a866022ff49e3fcea892345ad92:

  Linux 3.6-rc2 (2012-08-16 14:51:24 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/linusw/linux-gpio.git
tags/gpio-for-v3.7

for you to fetch changes up to 901acf5b2910434501c221a363bb3486b647b5c4:

  gpio: pcf857x: select IRQ_DOMAIN (2012-09-30 23:38:53 +0200)

----------------------------------------------------------------
So this is the LW GPIO patch stack for v3.7:
- refactoring from Thierry Redding at Arnd Bergmann's request to use
  the seq_file iterator interface in gpiolib.
- A new driver for Avionic Design's N-bit GPIO expander.
- Two instances of mutexes replaced by spinlocks from Axel Lin to
  code that is supposed to be fastpath compliant.
- IRQ demuxer and gpio_to_irq() support for pcf857x by Kuninori
  Morimoto.
- Dynamic GPIO numbers, device tree support, daisy chaining and some
  other fixes for the 74x164 driver by Maxime Ripard.
- IRQ domain and device tree support for the tc3589x driver by
  Lee Jones.
- Some conversion to use managed resources devm_* code.
- Some instances of clk_prepare() or clk_prepare_enable() added to
  support the new, stricter common clock framework.
- Some for_each_set_bit() simplifications.
- Then a lot of fixes as we fixed up all of the above tripping over
  our own shoelaces and that kind of thing.

----------------------------------------------------------------
Arnd Bergmann (1):
      gpio: pcf857x: select IRQ_DOMAIN

Axel Lin (12):
      gpio: gpio-ml-ioh: Use spinlock for register access protection
      gpio: gpio-pch: Use spinlock for register access protection
      gpio: mc9s08dz60: Use devm_kzalloc API
      gpio: Remove broken mark for da9052 gpio driver
      gpio: da9052: Convert to use devm_kzalloc API
      gpio: tps65912: Convert to use devm_kzalloc API
      gpio: Use DEFINE_PCI_DEVICE_TABLE macro
      gpio: adp5588: Use module_i2c_driver
      gpio: wm831x: Convert to use devm_kzalloc API
      gpio: wm8350: Convert to use devm_kzalloc API
      gpio: em: Use irq_data_get_irq_chip_data() at appropriate places
      gpio: sx150x: Use irq_data_get_irq_chip_data() at appropriate places

Julia Lawall (1):
      drivers/gpio/gpio-pxa.c: use clk_prepare_enable and clk_disable_unprepare

Kuninori Morimoto (3):
      gpio: pcf857x: enable gpio_to_irq() support
      gpio: pcf857x: fixup smatch WARNING
      ARM: shmobile: kzm9g: use gpio-keys instead of gpio-keys-polled

Lee Jones (2):
      gpio: Provide the tc3589x GPIO expander driver with an IRQ domain
      gpio: Enable the tc3298x GPIO expander driver for Device Tree

Maxime Ripard (6):
      gpio: 74x164: Use module_spi_driver boiler plate function
      gpio: 74x164: Use devm_kzalloc
      gpio: 74x164: Use dynamic gpio number assignment if no pdata is present
      gpio: 74x164: Add device tree support
      gpio: 74x164: dts: Add documentation for the dt binding
      gpio: 74x164: Add support for the daisy-chaining

Murali Karicheri (1):
      gpio: davinci: preparation for switch to common clock framework

Roland Stigge (2):
      gpio-lpc32xx: Add GPI_28
      gpio: Document device_node's det_debounce

Sachin Kamat (1):
      dt: Fix incorrect reference in gpio-led documentation

Thierry Reding (3):
      gpiolib: Use seq_file's iterator interface
      gpio: Add Avionic Design N-bit GPIO expander support
      gpio: adnp: dt: Reference generic interrupt binding

Wei Yongjun (2):
      gpio_msm: using for_each_set_bit to simplify the code
      gpio: pxa: using for_each_set_bit to simplify the code

 .../devicetree/bindings/gpio/gpio-74x164.txt       |  22 +
 .../devicetree/bindings/gpio/gpio-adnp.txt         |  34 ++
 Documentation/devicetree/bindings/gpio/led.txt     |   2 +-
 arch/arm/configs/kzm9g_defconfig                   |   2 +-
 arch/arm/mach-shmobile/board-kzm9g.c               |   5 +-
 drivers/gpio/Kconfig                               |  14 +-
 drivers/gpio/Makefile                              |   1 +
 drivers/gpio/gpio-74x164.c                         | 103 +++-
 drivers/gpio/gpio-adnp.c                           | 611 +++++++++++++++++++++
 drivers/gpio/gpio-adp5588.c                        |  14 +-
 drivers/gpio/gpio-bt8xx.c                          |   2 +-
 drivers/gpio/gpio-da9052.c                         |  15 +-
 drivers/gpio/gpio-davinci.c                        |   2 +-
 drivers/gpio/gpio-em.c                             |  12 +-
 drivers/gpio/gpio-lpc32xx.c                        |   3 +-
 drivers/gpio/gpio-mc9s08dz60.c                     |  21 +-
 drivers/gpio/gpio-ml-ioh.c                         |  20 +-
 drivers/gpio/gpio-msm-v2.c                         |   4 +-
 drivers/gpio/gpio-pcf857x.c                        | 122 ++++
 drivers/gpio/gpio-pch.c                            |  22 +-
 drivers/gpio/gpio-pxa.c                            |  13 +-
 drivers/gpio/gpio-sodaville.c                      |   2 +-
 drivers/gpio/gpio-sx150x.c                         |  24 +-
 drivers/gpio/gpio-tc3589x.c                        | 120 ++--
 drivers/gpio/gpio-tps65912.c                       |  17 +-
 drivers/gpio/gpio-wm831x.c                         |  19 +-
 drivers/gpio/gpio-wm8350.c                         |  19 +-
 drivers/gpio/gpiolib.c                             | 102 +++-
 include/asm-generic/gpio.h                         |   2 +
 include/linux/i2c/pcf857x.h                        |   3 +
 30 files changed, 1104 insertions(+), 248 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/gpio/gpio-74x164.txt
 create mode 100644 Documentation/devicetree/bindings/gpio/gpio-adnp.txt
 create mode 100644 drivers/gpio/gpio-adnp.c
