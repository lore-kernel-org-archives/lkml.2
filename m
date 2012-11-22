Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755458Ab2KVSn2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 13:43:28 -0500
Received: from mail-ea0-f174.google.com ([209.85.215.174]:36325 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755411Ab2KVSnZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 13:43:25 -0500
MIME-Version: 1.0
Date: Thu, 22 Nov 2012 10:30:27 +0100
Message-ID: <CACRpkdYDbfJO+RxbRpBmMi=mCj2L8a1rNgJgFW9EsxTPw2ivsA@mail.gmail.com>
Subject: [GIT PULL] GPIO patch stack for v3.8
From: Linus Walleij <linus.walleij@linaro.org>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        arm@kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Grant,

to avoid any mess during the v3.8 merge window, could you please pull
this patch stack to your GPIO branch for v3.8?

All these patches have been resting in linux-next and are reviewed and
ACKed by maintainers. A more verbose description is in the signed
tag.

Some confusion stems from the fact that I applied my own patches
without replying to myself that I applied them ... split personality/role
problem. If you pull this in, things should be more clear on what's
queued and not - everything is in your tree.

Note that ARM SoC is already using parts of this tree as baseline
for stuff in their tree so rebasing this patch trail is *not*
recommended.

Please pull it in!

Apart from this there are a few gpiolib patches in the pinctrl tree as
well. Those are about adding the GPIOchip local GPIO numberspace
to pinctrl local numberspace ranges as we discussed with Dong
Aisheng in Hong Kong, I'd be happy to brief you on the implementation
if need be. It's also detailed here:
https://blueprints.launchpad.net/linux-linaro/+spec/pinctrl-gpiorange-makeover

Yours,
Linus Walleij


The following changes since commit ddffeb8c4d0331609ef2581d84de4d763607bd37:

  Linux 3.7-rc1 (2012-10-14 14:41:04 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/linusw/linux-gpio.git
tags/gpio-for-grant-v3.8

for you to fetch changes up to b53bc2819a71099ecfc3d61ba0796b3dcc6be321:

  gpio: SPEAr: add spi chipselect control driver (2012-11-18 00:01:27 +0100)

----------------------------------------------------------------
This is my GPIO patch stack for the v3.8 merge window:

Major changes:
- A refactoring of gpio_export from Ryan Mallon
- A gpio get direction callback in gpio_chip from Mattias
  Nyman, bringing that state closer to the real hardware
  state if the driver can support this

Minor changes:
- A new driver for the DA9055 PMIC
- A new driver form the SPEAr SPI chipselect controller
- A moved and refactored CLPS711X driver from the ARM tree
  with some fixes on top (fallout from linux-next)
- A number of IRQdomain cleanups + fallout fixes from myself
- Converted PCA953x to IRQdomain and finalize DT support
- A number of devm_* managed resources type of fixes
- Extended banks for WM8505/WM8650
- Set parent pointer for the PCH driver
- Tegra suspend/resume API fixes and other fixes
- Updates to TWL4030 from Peter Ujfalusi
- Various cleanups from Axel Lin

----------------------------------------------------------------
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

Dan Carpenter (1):
      gpiolib: unlock on error in gpio_export()

Laxman Dewangan (2):
      gpio: tegra: fix suspend/resume apis
      gpio: tegra: read output value when gpio is set in direction_out

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

Wei Yongjun (1):
      GPIO: clps711x: use platform_device_unregister in gpio_clps711x_init()

 .../devicetree/bindings/gpio/spear_spics.txt       |  50 +++++
 arch/arm/Kconfig                                   |   1 +
 arch/arm/plat-spear/Kconfig                        |   1 +
 drivers/gpio/Kconfig                               |  22 +++
 drivers/gpio/Makefile                              |   3 +
 drivers/gpio/gpio-clps711x.c                       | 199 +++++++++++++++++++
 drivers/gpio/gpio-da9055.c                         | 204 +++++++++++++++++++
 drivers/gpio/gpio-em.c                             |  48 +----
 drivers/gpio/gpio-max730x.c                        |  12 +-
 drivers/gpio/gpio-mvebu.c                          |   9 +-
 drivers/gpio/gpio-omap.c                           |   2 +-
 drivers/gpio/gpio-pca953x.c                        |  55 +++++-
 drivers/gpio/gpio-pch.c                            |   1 +
 drivers/gpio/gpio-pl061.c                          |  59 +++---
 drivers/gpio/gpio-spear-spics.c                    | 217 +++++++++++++++++++++
 drivers/gpio/gpio-tc3589x.c                        |  20 +-
 drivers/gpio/gpio-tegra.c                          |  43 ++--
 drivers/gpio/gpio-twl4030.c                        |  35 ++--
 drivers/gpio/gpio-vt8500.c                         |   2 +
 drivers/gpio/gpiolib.c                             | 124 ++++++++----
 include/asm-generic/gpio.h                         |   5 +-
 21 files changed, 931 insertions(+), 181 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/gpio/spear_spics.txt
 create mode 100644 drivers/gpio/gpio-clps711x.c
 create mode 100644 drivers/gpio/gpio-da9055.c
 create mode 100644 drivers/gpio/gpio-spear-spics.c
