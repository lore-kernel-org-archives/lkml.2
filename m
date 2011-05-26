Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932173Ab1EZLje (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 07:39:34 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:27993 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757393Ab1EZLjL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 07:39:11 -0400
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 98.234.237.12
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/OkwR0Us8seFb+KLNAbGAe
Date: Thu, 26 May 2011 04:39:06 -0700
From: Tony Lindgren <tony@atomide.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-omap@vger.kernel.org
Subject: [GIT PULL] omap updates for 2.6.40
Message-ID: <20110526113905.GG27250@atomide.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull omap updates for this merge window from:

git://git.kernel.org/pub/scm/linux/kernel/git/tmlind/linux-omap-2.6.git omap-for-linus

This contains clean-up to shrink down omap specific code a bit. Also included
are some fixes. But basically no new code at this point.

Regards,

Tony


Aaro Koskinen (5):
      OMAP3+: smartreflex: fix sr_late_init() error path in probe
      OMAP3+: smartreflex: request the memory region
      OMAP3+: smartreflex: fix ioremap leak on probe error
      OMAP3+: smartreflex: delete instance from sr_list on probe error
      OMAP3+: smartreflex: delete debugfs entries on probe error

Felipe Balbi (1):
      usb: musb: am35x: fix compile error when building am35x

Hema HK (3):
      usb: musb: OMAP4430: Power down the PHY during board init
      usb: otg: OMAP4430: Fixing the omap4430_phy_init function
      usb: otg: OMAP4430: Powerdown the internal PHY when USB is disabled

Igor Grinberg (2):
      arm: omap: gpmc-smsc911x: minor style fixes
      arm: omap2plus: GPIO cleanup

Jean Pihet (5):
      OMAP3 cpuidle: remove useless SDP specific timings
      OMAP3: clean-up mach specific cpuidle data structures
      OMAP3: cpuidle: re-organize the C-states data
      OMAP3: cpuidle: code rework for improved readability
      OMAP3: cpuidle: change the power domains modes determination logic

Mike Rapoport (10):
      omap: gpmc-smsc911x: always set irq flags to IORESOURCE_IRQ_LOWLEVEL
      omap: convert boards that use SMSC911x to use gpmc-smsc911x
      omap: consolidate touch screen initialization among different boards
      omap: use common initialization for PMIC i2c bus
      omap: move detection of NAND CS to common-board-devices
      omap: musb: introduce default board config
      omap: igep0020: name refactoring for future merge with IGEP3
      omap: igep0020: minor refactoring
      omap: igep0020: add support for IGEP3
      omap: drop board-igep0030.c

Nishanth Menon (2):
      OMAP4: PM: remove redundant #ifdef CONFIG_PM
      OMAP3+: voltage: remove spurious pr_notice for debugfs

Sanjeev Premi (1):
      OMAP3: PM: Boot message is not an error, and not helpful, remove it

Tony Lindgren (5):
      omap: Run make savedefconfig on omap2plus_defconfig to shrink it
      omap: Remove support for omap2evm
      Merge branches 'devel-fixes', 'devel-cleanup' and 'devel-genirq' into for-next
      Merge branch 'for-tony' of master.kernel.org:/.../balbi/usb into omap-for-linus
      Merge branch 'for_2.6.40/pm-cleanup' of ssh://master.kernel.org/.../khilman/linux-omap-pm into omap-for-linus

omar ramirez (2):
      OMAP3/4: l3: fix omap3_l3_probe error path
      OMAP3/4: l3: minor cleanup for parenthesis and extra spaces

 arch/arm/configs/omap2plus_defconfig            |   83 +----
 arch/arm/mach-omap2/Kconfig                     |    1 +
 arch/arm/mach-omap2/Makefile                    |    4 +-
 arch/arm/mach-omap2/board-2430sdp.c             |   27 +--
 arch/arm/mach-omap2/board-3430sdp.c             |  151 ++-------
 arch/arm/mach-omap2/board-4430sdp.c             |  114 ++-----
 arch/arm/mach-omap2/board-am3517crane.c         |   10 +-
 arch/arm/mach-omap2/board-am3517evm.c           |   56 +--
 arch/arm/mach-omap2/board-apollon.c             |   29 +-
 arch/arm/mach-omap2/board-cm-t35.c              |  236 ++----------
 arch/arm/mach-omap2/board-cm-t3517.c            |    9 +-
 arch/arm/mach-omap2/board-devkit8000.c          |  131 +------
 arch/arm/mach-omap2/board-igep0020.c            |  449 +++++++++++-----------
 arch/arm/mach-omap2/board-igep0030.c            |  458 -----------------------
 arch/arm/mach-omap2/board-ldp.c                 |  138 +-------
 arch/arm/mach-omap2/board-n8x0.c                |   28 +-
 arch/arm/mach-omap2/board-omap3beagle.c         |  194 +++-------
 arch/arm/mach-omap2/board-omap3evm.c            |  242 +++----------
 arch/arm/mach-omap2/board-omap3logic.c          |   14 +-
 arch/arm/mach-omap2/board-omap3pandora.c        |   90 +----
 arch/arm/mach-omap2/board-omap3stalker.c        |  133 +------
 arch/arm/mach-omap2/board-omap3touchbook.c      |  121 +------
 arch/arm/mach-omap2/board-omap4panda.c          |   79 ++---
 arch/arm/mach-omap2/board-overo.c               |  265 +++-----------
 arch/arm/mach-omap2/board-rm680.c               |   21 +-
 arch/arm/mach-omap2/board-rx51-peripherals.c    |   42 +--
 arch/arm/mach-omap2/board-rx51-video.c          |    5 +-
 arch/arm/mach-omap2/board-rx51.c                |   18 +-
 arch/arm/mach-omap2/board-zoom-debugboard.c     |   65 +---
 arch/arm/mach-omap2/board-zoom-display.c        |   31 +--
 arch/arm/mach-omap2/board-zoom-peripherals.c    |   29 +--
 arch/arm/mach-omap2/common-board-devices.c      |  163 ++++++++
 arch/arm/mach-omap2/common-board-devices.h      |   35 ++
 arch/arm/mach-omap2/cpuidle34xx.c               |  436 +++++++--------------
 arch/arm/mach-omap2/gpmc-smc91x.c               |   11 +-
 arch/arm/mach-omap2/gpmc-smsc911x.c             |   44 +--
 arch/arm/mach-omap2/omap_l3_noc.c               |   51 ++--
 arch/arm/mach-omap2/omap_l3_smx.c               |   42 +--
 arch/arm/mach-omap2/omap_phy_internal.c         |    9 +-
 arch/arm/mach-omap2/pm.h                        |   17 +-
 arch/arm/mach-omap2/pm34xx.c                    |   14 -
 arch/arm/mach-omap2/pm44xx.c                    |    2 -
 arch/arm/mach-omap2/smartreflex.c               |   23 +-
 arch/arm/mach-omap2/usb-musb.c                  |   22 +-
 arch/arm/mach-omap2/usb-tusb6010.c              |    3 +-
 arch/arm/mach-omap2/voltage.c                   |    1 -
 arch/arm/plat-omap/include/plat/gpmc-smsc911x.h |    4 +-
 arch/arm/plat-omap/include/plat/uncompress.h    |    1 -
 arch/arm/plat-omap/include/plat/usb.h           |    2 +-
 drivers/video/omap/Makefile                     |    1 -
 drivers/video/omap/lcd_omap2evm.c               |  192 ----------
 sound/soc/omap/Kconfig                          |    8 -
 sound/soc/omap/Makefile                         |    1 -
 sound/soc/omap/omap2evm.c                       |  139 -------
 54 files changed, 1110 insertions(+), 3384 deletions(-)
 delete mode 100644 arch/arm/mach-omap2/board-igep0030.c
 create mode 100644 arch/arm/mach-omap2/common-board-devices.c
 create mode 100644 arch/arm/mach-omap2/common-board-devices.h
 delete mode 100644 drivers/video/omap/lcd_omap2evm.c
 delete mode 100644 sound/soc/omap/omap2evm.c
