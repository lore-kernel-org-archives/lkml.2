Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753382Ab2GWO2p (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2012 10:28:45 -0400
Received: from mail-qa0-f53.google.com ([209.85.216.53]:51418 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752292Ab2GWO2o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2012 10:28:44 -0400
MIME-Version: 1.0
Date: Mon, 23 Jul 2012 16:28:43 +0200
Message-ID: <CACRpkdbF5YG_CgY1K7x+-85B6Vbu5QWiaLtcKE94HBGxdhkobw@mail.gmail.com>
Subject: [GIT PULL] pinctrl changes for v3.6
From: Linus Walleij <linus.walleij@linaro.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, ext Tony Lindgren <tony@atomide.com>,
        Hui Wang <jason77.wang@gmail.com>,
        Patrice CHOTARD <patrice.chotard@stericsson.com>,
        Dong Aisheng <B29396@freescale.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

these are the accumulated pin control patches for v3.6, this description
matches the one in the tag:

- Various cleanups to the U300 driver
- Refactor the pin control core to automatically remove
  any GPIO ranges when the drivers are removed, instead of
  having the drivers do this explicitly.
- Add a function for registering a batch of GPIO ranges.
- Fix a number of incorrect but non-regressive error checks.
- Incremental improvements to the COH901, i.MX and Nomadik drivers
- Add a one-register-per-pin entirely Device Tree-based pin
  control driver from Tony Lindgren.

Please pull it in!

The following changes since commit 6887a4131da3adaab011613776d865f4bcfb5678:

  Linux 3.5-rc5 (2012-06-30 16:08:57 -0700)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/linusw/linux-pinctrl.git
tags/pinctrl-for-v3.6

Devendra Naga (4):
      pinctrl/pinctrl-u300: remove devm_kfree at driver unload
      pinctrl/pinctrl-core: cleanup pinctrl_register
      pinctrl/pinctrl-spear: remove IS_ERR checking of pmx->pctl
      pinctrl/pinctrl-tegra: remove IS_ERR checking of pmx->pctl

Dong Aisheng (2):
      pinctrl: remove pinctrl_remove_gpio_range
      pinctrl: add pinctrl_add_gpio_ranges function

Hui Wang (1):
      pinctrl: pinctrl-imx: fix map setting problem if NO_PAD_CTL is set

Linus Walleij (6):
      pinctrl/u300: delete pointless debug print
      pinctrl: select the proper symbol
      pinctrl/u300: drop unused variable
      pinctrl/coh901: use clk_prepare_[en|dis]able()
      pinctrl/nomadik: use devm_* allocators for gpio probe
      pinctrl/nomadik: kerneldoc fix

Patrice Chotard (5):
      pinctrl/nomadik: fix hsir_a_1_pins pin list
      pinctrl/nomadik: add pin group smcs1 and smps0
      pinctrl/nomadik: add hsit_a_2 pin group
      pinctrl/nomadik: add pin group to mco function
      pinctrl/nomadik: add spi2_oc1_2 pin group

Tony Lindgren (1):
      pinctrl: Add one-register-per-pin type device tree based pinctrl driver

 .../devicetree/bindings/pinctrl/pinctrl-single.txt |   93 ++
 drivers/pinctrl/Kconfig                            |   10 +-
 drivers/pinctrl/Makefile                           |    1 +
 drivers/pinctrl/core.c                             |   41 +-
 drivers/pinctrl/pinctrl-coh901.c                   |    6 +-
 drivers/pinctrl/pinctrl-imx.c                      |   13 +-
 drivers/pinctrl/pinctrl-nomadik-db8500.c           |   33 +-
 drivers/pinctrl/pinctrl-nomadik.c                  |   37 +-
 drivers/pinctrl/pinctrl-single.c                   |  987 ++++++++++++++++++++
 drivers/pinctrl/pinctrl-tegra.c                    |    5 +-
 drivers/pinctrl/pinctrl-u300.c                     |    6 -
 drivers/pinctrl/spear/pinctrl-spear.c              |    4 +-
 include/linux/pinctrl/pinctrl.h                    |    5 +-
 13 files changed, 1160 insertions(+), 81 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/pinctrl/pinctrl-single.txt
 create mode 100644 drivers/pinctrl/pinctrl-single.c

Yours,
Linus Walleij
