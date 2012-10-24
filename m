Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758179Ab2JXL6E (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 07:58:04 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:41422 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754426Ab2JXL6B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 07:58:01 -0400
MIME-Version: 1.0
Date: Wed, 24 Oct 2012 13:57:59 +0200
Message-ID: <CACRpkdbwUMbTeKnGX3u4KNQbGdY0wY518=tAm5MocwyVPZbBfQ@mail.gmail.com>
Subject: [GIT PULL] pinctrl patches for v3.7-rc3+
From: Linus Walleij <linus.walleij@linaro.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        Pritesh Raithatha <praithatha@nvidia.com>,
        Tobias Klauser <tklauser@distanz.ch>,
        Wei Yongjun <yongjun_wei@trendmicro.com.cn>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

here are some accumulated pinctrl patches since -rc1, with a
verboser description in the (signed) tag.

Please pull them in!

Yours,
Linus Walleij

The following changes since commit ddffeb8c4d0331609ef2581d84de4d763607bd37:

  Linux 3.7-rc1 (2012-10-14 14:41:04 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/linusw/linux-pinctrl.git
tags/pinctrl-v3.7-rc3

for you to fetch changes up to 38843e29217bc6b6fce80a5bf19d1636ee337c77:

  pinctrl/nomadik: pass DT node to the irqdomain (2012-10-23 11:52:25 +0200)

----------------------------------------------------------------
This fixes a few pinctrl problems seen since v3.7-rc1:
- Section tagging for init code
- Use proper pointers to lookup struct device * in the
  bcm2835 (a.k.a. Raspberry Pi)
- Remove duplicate #includes
- Fix bad return values in errorpath
- Remove extraneous pull function from the sirf driver
  causing build errors
- Provide compilation stubs for the Nomadik pinctrl driver
  when used with legacy systems without PRCMU units
- Various irqdomain fixes in the Nomadik driver as predicted
- Various smallish bugs in the Tegra driver, most also
  targeted for stable
- Removed a deadlocking mutex in the groups debugfs show
  function

----------------------------------------------------------------
Arnd Bergmann (2):
      pinctrl: samsung: use __devinit section for init code
      pinctrl: sirf: remove sirfsoc_gpio_set_pull function

Haojian Zhuang (1):
      pinctrl: remove mutex lock in groups show

Linus Walleij (5):
      pinctrl/nomadik: provide stubs for legacy Nomadik
      pinctrl/nomadik: always use the simple irqdomain
      pinctrl/nomadik: use irq_create_mapping()
      pinctrl/nomadik: use zero as default irq_start
      pinctrl/nomadik: pass DT node to the irqdomain

Pritesh Raithatha (3):
      dt: Document: correct tegra20/30 pinctrl slew-rate name
      pinctrl: tegra: set low power mode bank width to 2
      pinctrl: tegra: correct bank for pingroup and drv pingroup

Tobias Klauser (1):
      pinctrl: bcm2835: Use existing pointer to struct device

Wei Yongjun (4):
      pinctrl: remove duplicated include from pinctrl-bcm2835.c
      pinctrl: fix return value in bcm2835_pinctrl_probe()
      pinctrl: remove duplicated include from pinctrl-xway.c
      pinctrl: fix missing unlock on error in pinctrl_groups_show()

 .../bindings/pinctrl/nvidia,tegra20-pinmux.txt     |  2 +-
 .../bindings/pinctrl/nvidia,tegra30-pinmux.txt     |  2 +-
 arch/arm/mach-prima2/include/mach/gpio.h           | 13 --------
 drivers/pinctrl/core.c                             |  4 ++-
 drivers/pinctrl/pinconf.c                          |  4 ---
 drivers/pinctrl/pinctrl-bcm2835.c                  |  5 ++--
 drivers/pinctrl/pinctrl-nomadik.c                  | 28 ++++++++++-------
 drivers/pinctrl/pinctrl-samsung.c                  | 10 +++----
 drivers/pinctrl/pinctrl-sirf.c                     | 35 ----------------------
 drivers/pinctrl/pinctrl-tegra.c                    |  2 +-
 drivers/pinctrl/pinctrl-tegra30.c                  | 24 +++++++--------
 drivers/pinctrl/pinctrl-xway.c                     |  2 --
 12 files changed, 42 insertions(+), 89 deletions(-)
 delete mode 100644 arch/arm/mach-prima2/include/mach/gpio.h
