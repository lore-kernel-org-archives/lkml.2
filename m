Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755112Ab1FFK1c (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 06:27:32 -0400
Received: from mho-04-ewr.mailhop.org ([204.13.248.74]:11849 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754743Ab1FFK1W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 06:27:22 -0400
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 98.234.237.12
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18DOxr2iBkfCDKZ/3dk4Of0
Date: Mon, 6 Jun 2011 03:27:19 -0700
From: Tony Lindgren <tony@atomide.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-omap@vger.kernel.org
Subject: [GIT PULL] omap fixes for v3.0-rc2
Message-ID: <20110606102718.GJ11352@atomide.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull omap fixes from:

git://git.kernel.org/pub/scm/linux/kernel/git/tmlind/linux-omap-2.6.git fixes

This contains build and warning related fixes, mux and mmc init fixes, and
some board related fixes. Also included is one patch to remove duplicate
defines of NAND_BLOCK_SIZE.

Regards,

Tony


The following changes since commit 55922c9d1b84b89cb946c777fddccb3247e7df2c:
  Linus Torvalds (1):
        Linux 3.0-rc1

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tmlind/linux-omap-2.6.git fixes

Alexander Holler (1):
      arm: omap3: beagle: Ensure msecure is mux'd to be able to set the RTC

Axel Lin (1):
      ARM: OMAP2: Add missing include of linux/gpio.h

Balaji T K (2):
      ARM: OMAP4: MMC: no regulator off during probe for eMMC
      ARM: OMAP4: MMC: increase delay for pbias

Colin Cross (2):
      ARM: omap2+: mux: Allow board mux settings to be NULL
      ARM: omap4: Pass core and wakeup mux tables to omap4_mux_init

Govindraj.R (1):
      OMAP2+: mux: fix compilation warnings

Igor Grinberg (3):
      arm: omap3: cm-t3517: fix section mismatch warning
      arm: omap2plus: fix ads7846 pendown gpio request
      arm: omap2plus: move NAND_BLOCK_SIZE out of boards

Janusz Krzysztofik (1):
      OMAP: fix compilation error

Jarkko Nikula (2):
      omap: rx51: Set regulator V28_A always on
      omap: rx51: Don't power up speaker amplifier at bootup

Julia Lawall (1):
      arch/arm/mach-omap1/dma.c: Invert calls to platform_device_put and platform_device_del

Omar Ramirez Luna (1):
      OMAP: iovmm: fix SW flags passed by user

Rabin Vincent (1):
      OMAP4: fix return value of omap4_l3_init

Santosh Shilimkar (2):
      OMAP2+: Fix 9 section mismatch(es) warnings from mach-omap2/built-in.o
      OMAP: SRAM: Fix warning: format '%08lx' expects type 'long unsigned int'

Shubhrajyoti D (1):
      omap4: hwmod: Enable the keypad

Tasslehoff Kjappfot (1):
      omap3: Free Beagle rev gpios when they are read, so others can read them later

Todd Poynor (1):
      ARM: OMAP2: Add missing iounmap in omap4430_phy_init

 arch/arm/mach-omap1/dma.c                    |   11 ++++++-----
 arch/arm/mach-omap2/board-2430sdp.c          |    2 +-
 arch/arm/mach-omap2/board-3430sdp.c          |    6 +++---
 arch/arm/mach-omap2/board-4430sdp.c          |   11 ++++++-----
 arch/arm/mach-omap2/board-apollon.c          |    2 +-
 arch/arm/mach-omap2/board-cm-t35.c           |    2 --
 arch/arm/mach-omap2/board-cm-t3517.c         |    5 ++---
 arch/arm/mach-omap2/board-devkit8000.c       |    2 --
 arch/arm/mach-omap2/board-omap3beagle.c      |    8 ++++++--
 arch/arm/mach-omap2/board-omap3pandora.c     |    4 +---
 arch/arm/mach-omap2/board-omap3touchbook.c   |    2 --
 arch/arm/mach-omap2/board-omap4panda.c       |    8 ++++----
 arch/arm/mach-omap2/board-overo.c            |    4 +---
 arch/arm/mach-omap2/board-rx51-peripherals.c |    3 ++-
 arch/arm/mach-omap2/board-zoom-display.c     |    2 +-
 arch/arm/mach-omap2/common-board-devices.c   |   20 ++++++++++----------
 arch/arm/mach-omap2/common-board-devices.h   |    2 ++
 arch/arm/mach-omap2/devices.c                |    2 +-
 arch/arm/mach-omap2/hsmmc.c                  |   16 +++++++++++++---
 arch/arm/mach-omap2/hsmmc.h                  |    1 +
 arch/arm/mach-omap2/mux.c                    |    5 ++++-
 arch/arm/mach-omap2/mux.h                    |    6 ++++--
 arch/arm/mach-omap2/mux44xx.c                |    5 +++--
 arch/arm/mach-omap2/omap_hwmod.c             |    2 +-
 arch/arm/mach-omap2/omap_hwmod_44xx_data.c   |    2 +-
 arch/arm/mach-omap2/omap_phy_internal.c      |    4 +++-
 arch/arm/plat-omap/include/plat/flash.h      |    1 +
 arch/arm/plat-omap/include/plat/iovmm.h      |    3 ---
 arch/arm/plat-omap/include/plat/mmc.h        |    3 +++
 arch/arm/plat-omap/iovmm.c                   |    4 ----
 arch/arm/plat-omap/sram.c                    |   12 ++++++------
 drivers/mmc/host/omap_hsmmc.c                |    3 +++
 32 files changed, 90 insertions(+), 73 deletions(-)
