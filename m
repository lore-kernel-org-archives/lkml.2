Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756562Ab2FWXkM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jun 2012 19:40:12 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:48942 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756120Ab2FWXkK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jun 2012 19:40:10 -0400
MIME-Version: 1.0
X-Originating-IP: [2001:470:8656:0:b059:e1b3:ffa7:fba5]
Date: Sat, 23 Jun 2012 16:40:09 -0700
Message-ID: <CAOesGMir9Dv32C=Nykdp_nKv3quOs7qrF+NmzmFDgF77e-DMnA@mail.gmail.com>
Subject: [GIT PULL] ARM: SoC fixes
From: Olof Johansson <olof@lixom.net>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        arm@kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit fb09185a88cad9c59e22e84f8c0594303595e9af:

  Merge branch 'drm-fixes' of
git://people.freedesktop.org/~airlied/linux (2012-06-17 01:44:41
-0700)

are available in the git repository at:


  git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc.git
tags/fixes-for-linus

for you to fetch changes up to 0fa1f0609a0c1fe8b2be3c0089a2cb48f7fda521:

  ARM: Orion: Fix Virtual/Physical mixup with watchdog (2012-06-23
16:19:21 -0700)

----------------------------------------------------------------
ARM: SoC fixes

Nothing very controversial in here. Most of the fixes are for OMAP this time
around, with some orion/kirkwood and a tegra patch mixed in.

----------------------------------------------------------------
Andrew Lunn (3):
      ARM: iconnect: Remove include of removed linux/spi/orion_spi.h
      ARM: Orion5x - Restore parts of io.h, with rework
      ARM: Orion: Fix Virtual/Physical mixup with watchdog

Djamil Elaidi (1):
      ARM: OMAP4+: hwmod: fix issue causing IPs not going back to Smart-Standby

Jon Hunter (1):
      arm/dts: OMAP2: Fix interrupt controller binding

Marc Kleine-Budde (1):
      ARM: Kirkwood: clk_register_gate_fn: add fn assignment

Olof Johansson (2):
      Merge tag 'omap-fixes-for-v3.5-rc3' of
git://git.kernel.org/.../tmlind/linux-omap into fixes
      Merge tag 'omap-fixes-a-for-3.5rc' of
git://git.kernel.org/.../pjw/omap-pending into fixes

Paul Walmsley (4):
      ARM: OMAP4: hwmod data: fix 32k sync timer idle modes
      ARM: OMAP4: clock data: add clockdomains for clocks used as main clocks
      ARM: OMAP2+: CM: increase the module disable timeout
      ARM: OMAP2+: mux: fix sparse warning

Ricardo Neri (1):
      ARM: OMAP4: hwmod data: Force HDMI in no-idle while enabled

Russ Dill (1):
      ARM: OMAP: Fix Beagleboard DVI reset gpio

Stephen Warren (1):
      ARM: tegra: make tegra_cpu_reset_handler_enable() __init

Todd Poynor (1):
      ARM: OMAP: PM: Lock clocks list while generating summary

Tony Lindgren (2):
      ARM: OMAP2+: Fix MUSB ifdefs for platform init code
      ARM: OMAP2: Fix tusb6010 GPIO interrupt for n8x0

 arch/arm/Kconfig                                  |  1 +
 arch/arm/boot/dts/omap2.dtsi                      |  2 ++
 arch/arm/mach-kirkwood/board-iconnect.c           |  3 ---
 arch/arm/mach-kirkwood/common.c                   |  1 +
 arch/arm/mach-kirkwood/include/mach/bridge-regs.h |  1 +
 arch/arm/mach-kirkwood/include/mach/kirkwood.h    |  1 +
 arch/arm/mach-omap2/board-n8x0.c                  |  6 ++----
 arch/arm/mach-omap2/board-omap3beagle.c           | 28
++++++++++++----------------
 arch/arm/mach-omap2/clock44xx_data.c              |  5 +++++
 arch/arm/mach-omap2/cm.h                          | 11 +++++++++++
 arch/arm/mach-omap2/cminst44xx.c                  |  4 ++--
 arch/arm/mach-omap2/mux.c                         |  1 +
 arch/arm/mach-omap2/omap_hwmod.c                  |  2 +-
 arch/arm/mach-omap2/omap_hwmod_44xx_data.c        |  8 ++++++--
 arch/arm/mach-omap2/omap_phy_internal.c           |  6 ------
 arch/arm/mach-omap2/usb-musb.c                    |  6 ++----
 arch/arm/mach-omap2/usb-tusb6010.c                |  2 +-
 arch/arm/mach-orion5x/include/mach/bridge-regs.h  |  2 +-
 arch/arm/mach-orion5x/include/mach/io.h           | 22 ++++++++++++++++++++++
 arch/arm/mach-orion5x/include/mach/orion5x.h      |  1 +
 arch/arm/mach-tegra/reset.c                       |  2 +-
 arch/arm/plat-omap/clock.c                        |  2 ++
 arch/arm/plat-orion/common.c                      |  2 +-
 23 files changed, 77 insertions(+), 42 deletions(-)
 create mode 100644 arch/arm/mach-orion5x/include/mach/io.h
