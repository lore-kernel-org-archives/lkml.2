Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752158Ab2GYWtG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2012 18:49:06 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:64575 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751206Ab2GYWs6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2012 18:48:58 -0400
MIME-Version: 1.0
Date: Thu, 26 Jul 2012 00:48:57 +0200
Message-ID: <CACRpkdZnRiZpKuQ6krJFa8TAfmvYYLB-n79ztzaUOV32p6ZY1Q@mail.gmail.com>
Subject: [GIT PULL] GPIO changes for v3.6
From: Linus Walleij <linus.walleij@linaro.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Grant Likely <grant.likely@secretlab.ca>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

in Grants absence, these are my queued and -next-tested changes
for v3.6, please pull them in. Grants "merge" branch prior to his
absence was merged in as a base for this patch series.

The following is the same information as found in the tag:

GPIO changes for v3.6:
- New driver for AMD-8111 southbridge GPIOs
- New driver for Wolfson Micro Arizona devices
- Propagate device tree parse errors
- Probe deferral finalizations - all expected calls to
  GPIO will now hopefully request deferral where apropriate
- Misc updates to TCA6424, WM8994, LPC32xx, PCF857x, Samsung
  MXC, OMAP and PCA953X drivers.

Please pull it in!

The following changes since commit 6887a4131da3adaab011613776d865f4bcfb5678:

  Linux 3.5-rc5 (2012-06-30 16:08:57 -0700)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/linusw/linux-gpio.git
tags/gpio-for-v3.6

Alexandre Courbot (1):
      gpio: propagate of_parse_phandle_with_args errors

Andreas Schallenberg (1):
      gpio/tca6424: merge I2C transactions, remove cast

Benoît Thébaudeau (1):
      gpio/mxc: use the edge_sel feature if available

Chandrabhanu Mahapatra (1):
      GPIO: PCA953X: Increase size of invert variable to support 24 bit

Dmitry Eremin-Solenikov (1):
      gpio: add a driver for GPIO pins found on AMD-8111 south bridge chips

Dong Aisheng (1):
      gpio/of: fix a typo of comment message

Kevin Hilman (1):
      MAINTAINERS: add entry OMAP GPIO driver

Kuninori Morimoto (1):
      gpio: pcf857x: share 8/16 bit access functions

Leed Aguilar (1):
      gpio/pca953x: increase variables size to support 24 bit of data

Linus Walleij (1):
      Merge branch 'gpio/merge' of
git://git.secretlab.ca/git/linux-2.6 into grant

Mark Brown (5):
      gpiolib: wm8994: Use irq_domain mappings for gpios
      gpiolib: wm8994: Convert to devm_kzalloc()
      MAINTAINERS: Add Wolfson gpiolib drivers to the Wolfson entry
      gpiolib: Add support for Wolfson Microelectronics Arizona class devices
      gpiolib: Defer failed gpio requests by default

Olof Johansson (1):
      gpio: samsung: add flags specifier to device-tree binding

Roland Stigge (3):
      gpio: LPC32xx: Driver cleanup
      gpio: gpio-lpc32xx: Add gpio_to_irq mapping
      gpio: of_get_named_gpio_flags() return -EPROBE_DEFER if GPIO not
yet available

Tarun Kanti DebBarma (1):
      gpio/omap: move bank->dbck initialization to omap_gpio_mod_init()

 .../devicetree/bindings/gpio/fsl-imx-gpio.txt      |    2 +-
 .../devicetree/bindings/gpio/gpio-samsung.txt      |    9 +-
 MAINTAINERS                                        |    8 +
 arch/arm/boot/dts/imx51.dtsi                       |    8 +-
 arch/arm/boot/dts/imx53.dtsi                       |   14 +-
 arch/arm/boot/dts/imx6q.dtsi                       |   14 +-
 arch/arm/mach-imx/mm-imx25.c                       |   10 +-
 arch/arm/mach-imx/mm-imx3.c                        |    7 +-
 arch/arm/mach-imx/mm-imx5.c                        |   40 ++--
 drivers/gpio/Kconfig                               |   18 ++
 drivers/gpio/Makefile                              |    2 +
 drivers/gpio/gpio-amd8111.c                        |  246 ++++++++++++++++++++
 drivers/gpio/gpio-arizona.c                        |  163 +++++++++++++
 drivers/gpio/gpio-lpc32xx.c                        |   74 ++++++-
 drivers/gpio/gpio-mxc.c                            |   71 +++++--
 drivers/gpio/gpio-omap.c                           |   10 +-
 drivers/gpio/gpio-pca953x.c                        |   67 +++---
 drivers/gpio/gpio-pcf857x.c                        |   93 +++-----
 drivers/gpio/gpio-samsung.c                        |    5 +-
 drivers/gpio/gpio-wm8994.c                         |   17 +-
 drivers/gpio/gpiolib-of.c                          |    9 +-
 drivers/gpio/gpiolib.c                             |    2 +-
 include/linux/i2c/pca953x.h                        |    2 +-
 23 files changed, 700 insertions(+), 191 deletions(-)
 create mode 100644 drivers/gpio/gpio-amd8111.c
 create mode 100644 drivers/gpio/gpio-arizona.c

Yours,
Linus Walleij
