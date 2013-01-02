Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752638Ab3ABIsk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2013 03:48:40 -0500
Received: from mail-ie0-f174.google.com ([209.85.223.174]:51123 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751834Ab3ABIsh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2013 03:48:37 -0500
MIME-Version: 1.0
Date: Wed, 2 Jan 2013 09:40:58 +0100
Message-ID: <CACRpkdYryuV=+iuZ8URvkw-cWMvNREuhC_pWdQwbt0mZUH9DQQ@mail.gmail.com>
Subject: [GIT PULL] pinctrl fixes for v3.8
From: Linus Walleij <linus.walleij@linaro.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

these are the first few pinctrl fixes for the v3.8 cycle, the information
is in the signed tag as usual.

Please pull it in!

Yours,
Linus Walleij

The following changes since commit a49f0d1ea3ec94fc7cf33a7c36a16343b74bd565:

  Linux 3.8-rc1 (2012-12-21 17:19:00 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/linusw/linux-pinctrl.git
tags/pinctrl-fixes

for you to fetch changes up to 9fcb4cc2d7dd192ae718f0e7484c6f5c08b8af23:

  ARM: ux500: add pinctrl address resources (2012-12-26 01:59:54 +0100)

----------------------------------------------------------------
A first round of pinctrl fixes for v3.8:
- i.MX5 register configuration
- Swap a kfree to devm_kfree() to avoid memory
  corruption in the at91 driver
- Add the missing device tree binding doc for the
  SIRF pin controller
- Enable the SIRF GPIO pull up/down configuration
  from the device tree, it was previously retired
  from the hard-coded approach.
- NULL check for the prcm_base in the Nomadik pin
  controller.
- Provide the prcm_base from the device tree in the
  DT boot path for the Nomadik pin controller.

----------------------------------------------------------------
Barry Song (2):
      pinctrl: sirf: add missing DT-binding document
      pinctrl: sirf: enable GPIO pullup/down configuration from dts

Fabio Baltieri (2):
      pinctrl: nomadik: return if prcm_base is NULL
      ARM: ux500: add pinctrl address resources

Julia Lawall (1):
      drivers/pinctrl/pinctrl-at91.c: convert kfree to devm_kfree

Linus Walleij (1):
      pinctrl: fix comment mistake

Philipp Zabel (1):
      pinctrl: imx5: fix GPIO_8 pad CAN1_RXCAN configuration

 .../devicetree/bindings/pinctrl/pinctrl-sirf.txt   | 47 +++++++++++++++++++++
 arch/arm/boot/dts/dbx5x0.dtsi                      |  4 +-
 arch/arm/mach-ux500/cpu-db8500.c                   |  3 +-
 drivers/pinctrl/core.c                             |  2 +-
 drivers/pinctrl/pinctrl-at91.c                     |  2 +-
 drivers/pinctrl/pinctrl-imx53.c                    |  2 +-
 drivers/pinctrl/pinctrl-nomadik.c                  | 11 ++++-
 drivers/pinctrl/pinctrl-sirf.c                     | 48 ++++++++++++++++++++++
 8 files changed, 113 insertions(+), 6 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/pinctrl/pinctrl-sirf.txt
