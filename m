Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754834Ab2EVFho (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 01:37:44 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:42286 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754511Ab2EVFhk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 01:37:40 -0400
From: Olof Johansson <olof@lixom.net>
To: torvalds@linux-foundation.org
Cc: arm@kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, Olof Johansson <olof@lixom.net>
Subject: =?UTF-8?q?=5BGIT=20PULL=203/8=5D=20arm-soc=3A=20non-critical=20bug=20fixes?=
Date: Mon, 21 May 2012 22:35:03 -0700
Message-Id: <1337664908-17478-4-git-send-email-olof@lixom.net>
X-Mailer: git-send-email 1.7.10.1.488.g05fbf7a
In-Reply-To: <1337664908-17478-1-git-send-email-olof@lixom.net>
References: <1337664908-17478-1-git-send-email-olof@lixom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These bug fixes were not important enough to have them included in the
v3.4 release, mostly because they cover harmless warnings or unrealistic
configurations. Instead we queue them up to be picked up in the next
merge window.

This branch will result in one conflict when merged in: panda_dvi_init()
is modified on one side and removed on the other. The correct resolution
is to remove it during merge.

----------------------------------------------------------------

The following changes since commit c5407b32071ef1bb5ea85b6fbc901ff890e6e321:

  Merge tag 'cleanup' of git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc into HEAD

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc.git tags/fixes

for you to fetch changes up to 74c437532b8b5db53509963ec38e8424c56ff6f4:

  ARM: spear6xx: remove board selection options

----------------------------------------------------------------

Akinobu Mita (1):
      arm: davinci: use for_each_set_bit_from

Arnd Bergmann (1):
      ARM: spear6xx: remove board selection options

Artem Bityutskiy (1):
      ARM: OMAP1: fix compilation issue in board-sx1.c

Balaji T K (1):
      ARM: OMAP4: hsmmc: check for null pointer

Chris Lalancette (1):
      ARM: OMAP4: Adding ID for OMAP4460 ES1.1

Felipe Contreras (1):
      ARM: OMAP: fix trivial warnings for dspbridge

Grazvydas Ignotas (1):
      ARM: OMAP2+: remove incorrect irq_chip ack field

Kevin Hilman (1):
      ARM: OMAP2+: INTC: fix Kconfig option for TI81XX

Laurent Pinchart (1):
      ARM: OMAP: igep0020: Specify the VPLL2 regulator unconditionally

Murali Karicheri (1):
      ARM: davinci: fix incorrect pdctl next bit position

Olof Johansson (3):
      Merge branch 'for-3.5/fixes' of git://git.kernel.org/.../swarren/linux-tegra into next/fixes
      Merge tag 'v3.5-fixes-and-cleanups' of git://gitorious.org/linux-davinci/linux-davinci into next/fixes
      Merge tag 'omap-fixes-non-critical-for-v3.5' of git://git.kernel.org/.../tmlind/linux-omap into next/fixes

Stephen Warren (2):
      ARM: tegra: add pll_x freq table entry for 750MHz
      ARM: disable SUSPEND/ARCH_SUSPEND_POSSIBLE for ARCH_TEGRA

Tomi Valkeinen (1):
      ARM: OMAP4: panda: add statics to remove warnings

Tony Lindgren (1):
      ARM: OMAP2+: Incorrect Register Offsets in OMAP Mailbox

Uwe Kleine-König (2):
      ARM: davinci: mark spi_board_info arguments as const
      ARM: davinci: da850-evm: fix section mismatch


 arch/arm/Kconfig                           |  2 +-
 arch/arm/mach-davinci/board-da850-evm.c    |  2 +-
 arch/arm/mach-davinci/davinci.h            |  4 +-
 arch/arm/mach-davinci/devices-da8xx.c      |  2 +-
 arch/arm/mach-davinci/dm355.c              |  2 +-
 arch/arm/mach-davinci/dm365.c              |  2 +-
 arch/arm/mach-davinci/dma.c                |  6 +--
 arch/arm/mach-davinci/include/mach/da8xx.h |  3 +-
 arch/arm/mach-davinci/include/mach/psc.h   |  2 +-
 arch/arm/mach-omap1/Kconfig                |  1 +
 arch/arm/mach-omap2/board-4430sdp.c        | 44 -------------------
 arch/arm/mach-omap2/board-igep0020.c       | 10 ++---
 arch/arm/mach-omap2/board-omap4panda.c     | 49 ---------------------
 arch/arm/mach-omap2/common.h               |  3 ++
 arch/arm/mach-omap2/dsp.c                  |  5 ++-
 arch/arm/mach-omap2/id.c                   |  5 ++-
 arch/arm/mach-omap2/irq.c                  |  3 +-
 arch/arm/mach-omap2/mailbox.c              |  6 +--
 arch/arm/mach-omap2/omap4-common.c         | 58 +++++++++++++++++++++++++
 arch/arm/mach-spear6xx/Kconfig             | 18 ++------
 arch/arm/mach-tegra/tegra2_clocks.c        |  6 +++
 arch/arm/plat-omap/devices.c               |  4 +-
 arch/arm/plat-omap/include/plat/cpu.h      |  1 +
 23 files changed, 103 insertions(+), 135 deletions(-)
