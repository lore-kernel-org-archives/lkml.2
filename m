Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752682Ab2KPRqs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 12:46:48 -0500
Received: from mail-ie0-f174.google.com ([209.85.223.174]:33228 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752566Ab2KPRqq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 12:46:46 -0500
MIME-Version: 1.0
X-Originating-IP: [2620:0:1000:1b02:ae16:2dff:fe07:4e83]
Date: Fri, 16 Nov 2012 09:46:46 -0800
Message-ID: <CAOesGMhNdEDn_JtfK7ZZ589WUx3jbAF83XLe_Bwuq2sZmS0pkw@mail.gmail.com>
Subject: [GIT PULL] ARM: SoC fixes for 3.7-rc
From: Olof Johansson <olof@lixom.net>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: arm@kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

The following changes since commit 77b67063bb6bce6d475e910d3b886a606d0d91f7:

  Linux 3.7-rc5 (2012-11-11 13:44:33 +0100)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc.git
tags/fixes-for-linus

for you to fetch changes up to 6658d6a5957662d0b9b2da8cc2466de2dad09a1a:

  Merge tag 'at91-fixes' of git://github.com/at91linux/linux-at91 into
fixes (2012-11-16 16:43:58 +0100)

----------------------------------------------------------------

ARM: SoC fixes for 3.7

We've been sitting on this longer than we meant to due to travel and
other activities, but the number of patches is luckily not that high.

Biggest changes are from a batch of OMAP bugfixes, but there are a
few for the broader set of SoCs too (bcm2835, pxa, highbank, tegra,
at91 and i.MX).

The OMAP patches contain some fixes for MUSB/PHY on omap4 which
ends up being a bit on the large side but needed for legacy (non-DT)
platforms. Beyond that there are a handful of hwmod/pm changes.

So, fairly noncontroversial stuff all in all, and as usual around this
time the fixes are well targeted at specific problems.

----------------------------------------------------------------
Arnd Bergmann (4):
      Merge tag 'omap-for-v3.7-rc4/musb-regression-signed' of
git://git.kernel.org/.../tmlind/linux-omap into fixes
      Merge tag 'omap-for-v3.7-rc4/fixes-signed' of
git://git.kernel.org/.../tmlind/linux-omap into fixes
      Merge tag 'imx-fixes-rc' of
git://git.pengutronix.de/git/imx/linux-2.6 into fixes
      Merge tag 'at91-fixes' of git://github.com/at91linux/linux-at91 into fixes

Axel Lin (1):
      irqchip: irq-bcm2835: Add terminating entry for of_device_id table

Christoph Fritz (1):
      ARM: imx: ehci: fix host power mask bit

Fabio Estevam (1):
      ARM: boot: Fix usage of kecho

Johan Hovold (1):
      ARM: at91/usbh: fix overcurrent gpio setup

Kevin Hilman (2):
      ARM: OMAP2+: PM: add missing newline to VC warning message
      ARM: OMAP4: PM: fix regulator name for VDD_MPU

Kishon Vijay Abraham I (3):
      drivers: bus: ocp2scp: add pdata support
      ARM: OMAP4: add _dev_attr_ to ocp2scp for representing usb_phy
      ARM: OMAP: ocp2scp: create omap device for ocp2scp

Marko Katic (1):
      ARM: pxa/spitz_pm: Fix hang when resuming from STR

Miguel Vadillo (1):
      ARM: OMAP2+: clockdomain: Fix OMAP4 ISS clk domain to support only SWSUP

Nicolas Royer (1):
      ARM: at91/AT91SAM9G45: fix crypto peripherals irq issue due to
sparse irq support

Olof Johansson (2):
      Merge branch 'upload/fix' of git://github.com/hzhuang1/linux into fixes
      Merge branch 'for-3.7/fixes-for-rc4' of
git://git.kernel.org/.../swarren/linux-tegra into fixes

Paul Parsons (1):
      ARM: pxa: hx4700: Fix backlight PWM device number

Paul Walmsley (2):
      ARM: OMAP2+: hwmod: add flag to prevent hwmod code from touching
IP block during init
      ARM: OMAP4: hwmod data: do not enable or reset the McPDM during
kernel init

Pritesh Raithatha (1):
      ARM: dt: tegra: fix length of pad control and mux registers

Rob Herring (1):
      ARM: highbank: retry wfi on reset request

Tero Kristo (1):
      ARM: OMAP: hwmod: wait for sysreset complete after enabling hwmod

Tony Lindgren (2):
      Merge tag 'for_3.7-rc5-fixes-pm' of
git://git.kernel.org/.../khilman/linux-omap-pm into
omap-for-v3.7-rc4/fixes
      Merge tag 'omap-fixes-b2-for-3.7-rc' of
git://git.kernel.org/.../pjw/omap-pending into omap-for-v3.7-rc4/fixes

Wei Yongjun (1):
      ARM i.MX: fix error-valued pointer dereference in clk_register_gate2()

 arch/arm/boot/Makefile                       | 10 ++--
 arch/arm/boot/dts/tegra30.dtsi               |  4 +-
 arch/arm/mach-at91/at91rm9200_devices.c      |  2 +-
 arch/arm/mach-at91/at91sam9260_devices.c     |  2 +-
 arch/arm/mach-at91/at91sam9261_devices.c     |  2 +-
 arch/arm/mach-at91/at91sam9263_devices.c     |  2 +-
 arch/arm/mach-at91/at91sam9g45_devices.c     | 12 ++---
 arch/arm/mach-highbank/system.c              |  3 +-
 arch/arm/mach-imx/clk-gate2.c                |  2 +-
 arch/arm/mach-imx/ehci-imx25.c               |  2 +-
 arch/arm/mach-imx/ehci-imx35.c               |  2 +-
 arch/arm/mach-omap2/clockdomains44xx_data.c  |  2 +-
 arch/arm/mach-omap2/devices.c                | 79 ++++++++++++++++++++++++++++
 arch/arm/mach-omap2/omap_hwmod.c             | 63 +++++++++++++++++-----
 arch/arm/mach-omap2/omap_hwmod_44xx_data.c   | 36 +++++++++++++
 arch/arm/mach-omap2/twl-common.c             |  2 +-
 arch/arm/mach-omap2/vc.c                     |  2 +-
 arch/arm/mach-pxa/hx4700.c                   |  8 ++-
 arch/arm/mach-pxa/spitz_pm.c                 |  8 +--
 arch/arm/plat-omap/include/plat/omap_hwmod.h |  6 +++
 arch/arm/tools/Makefile                      |  2 +-
 drivers/bus/omap-ocp2scp.c                   | 68 ++++++++++++++++++++++--
 drivers/irqchip/irq-bcm2835.c                |  3 +-
 include/linux/platform_data/omap_ocp2scp.h   | 31 +++++++++++
 24 files changed, 303 insertions(+), 50 deletions(-)
 create mode 100644 include/linux/platform_data/omap_ocp2scp.h
