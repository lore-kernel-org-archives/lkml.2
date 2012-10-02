Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753618Ab2JBNEB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 09:04:01 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:49132 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753509Ab2JBND7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 09:03:59 -0400
MIME-Version: 1.0
Date: Tue, 2 Oct 2012 15:03:58 +0200
Message-ID: <CACRpkdayTbMgRbQ7HeJJ6Ktib34eaYxs8uSriyDJdnZUA7YKbw@mail.gmail.com>
Subject: [GIT PULL] pinctrl changes for v3.7
From: Linus Walleij <linus.walleij@linaro.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

here is the pinctrl patch queue for v3.7. The details are in the signed
tag as always.

Some of this stuff is hitting arch/arm/* and have been ACKed by
the ARM SoC folks, or it's device tree bindings pertaining to the
specific driver. There may even be some funny conflict that
Stephen fixed up in linux-next.

Please pull it in!

Yours,
Linus Walleij


The following changes since commit 4cbe5a555fa58a79b6ecbb6c531b8bab0650778d:

  Linux 3.6-rc4 (2012-09-01 10:39:58 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/linusw/linux-pinctrl.git
tags/pinctrl-for-v3.7

for you to fetch changes up to e1b2dc70cd5b00e17c703163a463d82354b1cc76:

  pinctrl: add bcm2835 driver (2012-10-01 08:05:22 +0200)

----------------------------------------------------------------
These are the bulk pinctrl changes for kernel v3.7:
- Add subdrivers for the DB8540 and NHK8815 Nomadik-type ASICs,
  provide platform config for the Nomadik.
- Add a driver for the i.MX35.
- Add a driver for the BCM2835, an advanced GPIO expander.
- Various fixes and clean-ups and minor improvements for the core,
  Nomadik, pinctr-single, sirf drivers.
- Some platform config for the ux500.

----------------------------------------------------------------
Barry Song (5):
      pinctrl: sirf: fix a typo in sirfsoc_gpio_probe
      pinctrl: sirf: add missing pins to pinctrl list
      pinctrl: sirf: fix spinlock deadlock in sirfsoc_gpio_set_input
      pinctrl: sirf: initialize the irq_chip pointer of pinctrl_gpio_range
      pinctrl: sirf: add lost chained_irq_enter and exit in
sirfsoc_gpio_handle_irq

Etienne Carriere (1):
      pinctrl/nomadik: MASK_ON_SUSPEND

Linus Walleij (6):
      pinctrl/nomadik: add STn8815 ASIC support
      ARM: nomadik: configure Nomadik for pin control
      pinctrl: document semantics vs GPIO
      ARM: ux500: tidy up pin sleep modes
      pinctrl/nomadik: use irq_find_mapping()
      pinctrl: clarify idle vs sleep states

Matt Porter (1):
      pinctrl: pinctrl-single: add debugfs pin h/w state info

Patrice Chotard (5):
      pinctrl/nomadik: add ASIC DB8450 pinctrl driver
      pinctrl/nomadik : add MC1_a_2 pin MC1 function group list
      ARM: ux500: 8500: use hsit_a_2 group for HSI
      ARM: ux500: fix spi2 pin group
      ARM: ux500: 8500: update I2C sleep states pinctrl

Peter Ujfalusi (2):
      pinctrl: pinctrl-single: Make sure we do not change bits outside of mask
      pinctrl: pinctrl-single: Add pinctrl-single,bits type of mux

Richard Zhao (1):
      pinctrl: imx: remove duplicated const

Sachin Kamat (1):
      pinctrl: Fix potential memory leak in pinctrl_register_one_pin()

Shawn Guo (1):
      pinctrl: imx5: start numbering pad from 0

Simon Arlott (1):
      pinctrl: add bcm2835 driver

Thomas Petazzoni (1):
      pinctrl: use kasprintf() in pinmux_request_gpio()

Uwe Kleine-König (2):
      pinctrl: use ERR_CAST instead of ERR_PTR(PTR_ERR(...))
      pinctrl: pinctrl-imx: add imx35 pinctrl driver

 .../bindings/pinctrl/brcm,bcm2835-gpio.txt         |   74 +
 .../bindings/pinctrl/fsl,imx35-pinctrl.txt         |  984 ++++++++++++
 .../devicetree/bindings/pinctrl/pinctrl-single.txt |   41 +-
 Documentation/pinctrl.txt                          |   60 +-
 arch/arm/Kconfig                                   |    1 +
 arch/arm/mach-nomadik/board-nhk8815.c              |   36 +
 arch/arm/mach-nomadik/cpu-8815.c                   |   13 +
 arch/arm/mach-ux500/board-mop500-pins.c            |   83 +-
 drivers/pinctrl/Kconfig                            |   21 +
 drivers/pinctrl/Makefile                           |    4 +
 drivers/pinctrl/core.c                             |    4 +-
 drivers/pinctrl/pinctrl-bcm2835.c                  | 1075 +++++++++++++
 drivers/pinctrl/pinctrl-imx.c                      |    2 +-
 drivers/pinctrl/pinctrl-imx35.c                    | 1595 ++++++++++++++++++++
 drivers/pinctrl/pinctrl-imx51.c                    |  490 +++---
 drivers/pinctrl/pinctrl-imx53.c                    |  402 ++---
 drivers/pinctrl/pinctrl-nomadik-db8500.c           |    5 +-
 drivers/pinctrl/pinctrl-nomadik-db8540.c           |  999 ++++++++++++
 drivers/pinctrl/pinctrl-nomadik-stn8815.c          |  357 +++++
 drivers/pinctrl/pinctrl-nomadik.c                  |   10 +-
 drivers/pinctrl/pinctrl-nomadik.h                  |   27 +
 drivers/pinctrl/pinctrl-single.c                   |   56 +-
 drivers/pinctrl/pinctrl-sirf.c                     |   23 +-
 drivers/pinctrl/pinmux.c                           |    5 +-
 include/linux/pinctrl/consumer.h                   |    2 +-
 include/linux/pinctrl/pinctrl-state.h              |   15 +-
 26 files changed, 5868 insertions(+), 516 deletions(-)
 create mode 100644
Documentation/devicetree/bindings/pinctrl/brcm,bcm2835-gpio.txt
 create mode 100644
Documentation/devicetree/bindings/pinctrl/fsl,imx35-pinctrl.txt
 create mode 100644 drivers/pinctrl/pinctrl-bcm2835.c
 create mode 100644 drivers/pinctrl/pinctrl-imx35.c
 create mode 100644 drivers/pinctrl/pinctrl-nomadik-db8540.c
 create mode 100644 drivers/pinctrl/pinctrl-nomadik-stn8815.c
