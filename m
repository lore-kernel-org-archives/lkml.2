Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754194Ab2LKRSo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2012 12:18:44 -0500
Received: from mail-vc0-f174.google.com ([209.85.220.174]:62099 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753728Ab2LKRSn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2012 12:18:43 -0500
MIME-Version: 1.0
From: Grant Likely <grant.likely@secretlab.ca>
Date: Tue, 11 Dec 2012 17:18:21 +0000
X-Google-Sender-Auth: rpCKGALSVbqBGRDm5l8yu-8kR7U
Message-ID: <CACxGe6uWqXWjHO7hYaF0jonzNAN8Z_NtaA1gKFL3Htp28mFn5Q@mail.gmail.com>
Subject: [GIT PULL] GPIO support for v3.8
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus. Another merge window, another gpio pull request. Pretty
routine. Please pull.

The following changes since commit ddffeb8c4d0331609ef2581d84de4d763607bd37:

  Linux 3.7-rc1 (2012-10-14 14:41:04 -0700)

are available in the git repository at:

  git://git.secretlab.ca/git/linux-2.6 tags/gpio-for-linus

for you to fetch changes up to fc13d5a5b17c657b7682c145d367dcb859c507d9:

  gpio: Provide the STMPE GPIO driver with its own IRQ Domain
(2012-12-10 11:23:30 +0100)

----------------------------------------------------------------
GPIO follow up patch and type change for v3.8 merge window

Primarily device driver additions, features and bug fixes. Not much
touching gpio common subsystem support. Should not be scary.

----------------------------------------------------------------
Alessandro Rubini (1):
      gpio: pl061 depends on ARM

Alexander Shiyan (3):
      GPIO: Add support for GPIO on CLPS711X-target platform
      GPIO: clps711x: Fix return value for gpio_clps711x_get
      GPIO: clps711x: Fix direction logic for PORTD

Alexander Stein (1):
      gpio-pch: Set parent dev for gpio chip

Ashish Jangam (1):
      DA9055 GPIO driver

Axel Lin (4):
      gpio: em: Fix build errors
      gpio: tegra: Staticize non-exported symbols
      gpio: tegra: Drop exporting static functions
      gpio: mvebu: Set free callback for gpio_chip

Baruch Siach (1):
      gpio/pl061: remove old comment

Dan Carpenter (1):
      gpiolib: unlock on error in gpio_export()

Kuninori Morimoto (1):
      gpio: pcf857x: use client->irq for gpio_to_irq()

Laxman Dewangan (2):
      gpio: tegra: fix suspend/resume apis
      gpio: tegra: read output value when gpio is set in direction_out

Lee Jones (1):
      gpio: Provide the STMPE GPIO driver with its own IRQ Domain

Linus Walleij (5):
      gpio: clps711x: delete local <mach/gpio.h> header
      gpio/tegra: convert to use linear irqdomain
      gpio/mvebu: convert to use irq_domain_add_simple()
      gpio/em: convert to linear IRQ domain
      gpio/tc3589x: convert to use the simple irqdomain

Mathias Nyman (1):
      gpiolib: add gpio get direction callback support

Maxime Ripard (2):
      gpio: pca953x: Register an IRQ domain
      gpio: pca953x: Add compatible strings to gpio-pca953x driver

Peter Ujfalusi (1):
      gpio: twl4030: Use only TWL4030_MODULE_LED for LED configuration

Roland Stigge (1):
      gpio: gpio-max710x: Support device tree probing

Ryan Mallon (1):
      gpiolib: Refactor gpio_export

Shiraz Hashim (1):
      gpio: SPEAr: add spi chipselect control driver

Tobias Klauser (2):
      gpio/gpio-pl061: Covert to use devm_* functions
      gpio/gpio-omap: Use existing pointer to struct device

Tony Prisk (1):
      GPIO: vt8500: Add extended gpio bank for WM8505/WM8650

Vipul Kumar Samar (1):
      gpio: stmpe: Add DT support for stmpe gpio

Vivien Didelot (1):
      gpio: add TS-5500 DIO blocks support

Wei Yongjun (1):
      GPIO: clps711x: use platform_device_unregister in gpio_clps711x_init()

 .../devicetree/bindings/gpio/gpio-stmpe.txt        |   18 +
 .../devicetree/bindings/gpio/spear_spics.txt       |   50 +++
 arch/arm/Kconfig                                   |    1 +
 arch/arm/mach-shmobile/board-kzm9g.c               |    2 +-
 arch/arm/plat-spear/Kconfig                        |    1 +
 drivers/gpio/Kconfig                               |   32 +-
 drivers/gpio/Makefile                              |    4 +
 drivers/gpio/gpio-clps711x.c                       |  199 +++++++++
 drivers/gpio/gpio-da9055.c                         |  204 +++++++++
 drivers/gpio/gpio-em.c                             |   48 +-
 drivers/gpio/gpio-max730x.c                        |   12 +-
 drivers/gpio/gpio-mvebu.c                          |    9 +-
 drivers/gpio/gpio-omap.c                           |    2 +-
 drivers/gpio/gpio-pca953x.c                        |   55 ++-
 drivers/gpio/gpio-pcf857x.c                        |   29 +-
 drivers/gpio/gpio-pch.c                            |    1 +
 drivers/gpio/gpio-pl061.c                          |   66 +--
 drivers/gpio/gpio-spear-spics.c                    |  217 +++++++++
 drivers/gpio/gpio-stmpe.c                          |   88 ++--
 drivers/gpio/gpio-tc3589x.c                        |   20 +-
 drivers/gpio/gpio-tegra.c                          |   43 +-
 drivers/gpio/gpio-ts5500.c                         |  466 ++++++++++++++++++++
 drivers/gpio/gpio-twl4030.c                        |   35 +-
 drivers/gpio/gpio-vt8500.c                         |    2 +
 drivers/gpio/gpiolib.c                             |  124 ++++--
 drivers/mfd/stmpe.c                                |    2 +
 include/asm-generic/gpio.h                         |    5 +-
 include/linux/i2c/pcf857x.h                        |    3 -
 include/linux/platform_data/gpio-ts5500.h          |   27 ++
 29 files changed, 1522 insertions(+), 243 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/gpio/gpio-stmpe.txt
 create mode 100644 Documentation/devicetree/bindings/gpio/spear_spics.txt
 create mode 100644 drivers/gpio/gpio-clps711x.c
 create mode 100644 drivers/gpio/gpio-da9055.c
 create mode 100644 drivers/gpio/gpio-spear-spics.c
 create mode 100644 drivers/gpio/gpio-ts5500.c
 create mode 100644 include/linux/platform_data/gpio-ts5500.h
