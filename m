Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757429Ab1EZMO0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 08:14:26 -0400
Received: from 50.23.254.54-static.reverse.softlayer.com ([50.23.254.54]:43982
	"EHLO softlayer.compulab.co.il" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753816Ab1EZMOZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 08:14:25 -0400
Message-ID: <4DDE441C.2080808@compulab.co.il>
Date: Thu, 26 May 2011 15:14:20 +0300
From: Igor Grinberg <grinberg@compulab.co.il>
Organization: CompuLab Ltd.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en; rv:1.9.2.13) Gecko/20101211 Lightning/1.0b2 Thunderbird/3.1.7
MIME-Version: 1.0
To: Tony Lindgren <tony@atomide.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-omap@vger.kernel.org
Subject: Re: [GIT PULL] omap updates for 2.6.40
References: <20110526113905.GG27250@atomide.com>
In-Reply-To: <20110526113905.GG27250@atomide.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - softlayer.compulab.co.il
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - compulab.co.il
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tony,


What about this one: [PATCH v2] arm: omap2plus: move NAND_BLOCK_SIZE out of boards

Why not include it? It is no new code, just generalize stuff and 11 lines off... not much but still.



On 05/26/11 14:39, Tony Lindgren wrote:

> Hi Linus,
>
> Please pull omap updates for this merge window from:
>
> git://git.kernel.org/pub/scm/linux/kernel/git/tmlind/linux-omap-2.6.git omap-for-linus
>
> This contains clean-up to shrink down omap specific code a bit. Also included
> are some fixes. But basically no new code at this point.
>
> Regards,
>
> Tony
>
>
> Aaro Koskinen (5):
>       OMAP3+: smartreflex: fix sr_late_init() error path in probe
>       OMAP3+: smartreflex: request the memory region
>       OMAP3+: smartreflex: fix ioremap leak on probe error
>       OMAP3+: smartreflex: delete instance from sr_list on probe error
>       OMAP3+: smartreflex: delete debugfs entries on probe error
>
> Felipe Balbi (1):
>       usb: musb: am35x: fix compile error when building am35x
>
> Hema HK (3):
>       usb: musb: OMAP4430: Power down the PHY during board init
>       usb: otg: OMAP4430: Fixing the omap4430_phy_init function
>       usb: otg: OMAP4430: Powerdown the internal PHY when USB is disabled
>
> Igor Grinberg (2):
>       arm: omap: gpmc-smsc911x: minor style fixes
>       arm: omap2plus: GPIO cleanup
>
> Jean Pihet (5):
>       OMAP3 cpuidle: remove useless SDP specific timings
>       OMAP3: clean-up mach specific cpuidle data structures
>       OMAP3: cpuidle: re-organize the C-states data
>       OMAP3: cpuidle: code rework for improved readability
>       OMAP3: cpuidle: change the power domains modes determination logic
>
> Mike Rapoport (10):
>       omap: gpmc-smsc911x: always set irq flags to IORESOURCE_IRQ_LOWLEVEL
>       omap: convert boards that use SMSC911x to use gpmc-smsc911x
>       omap: consolidate touch screen initialization among different boards
>       omap: use common initialization for PMIC i2c bus
>       omap: move detection of NAND CS to common-board-devices
>       omap: musb: introduce default board config
>       omap: igep0020: name refactoring for future merge with IGEP3
>       omap: igep0020: minor refactoring
>       omap: igep0020: add support for IGEP3
>       omap: drop board-igep0030.c
>
> Nishanth Menon (2):
>       OMAP4: PM: remove redundant #ifdef CONFIG_PM
>       OMAP3+: voltage: remove spurious pr_notice for debugfs
>
> Sanjeev Premi (1):
>       OMAP3: PM: Boot message is not an error, and not helpful, remove it
>
> Tony Lindgren (5):
>       omap: Run make savedefconfig on omap2plus_defconfig to shrink it
>       omap: Remove support for omap2evm
>       Merge branches 'devel-fixes', 'devel-cleanup' and 'devel-genirq' into for-next
>       Merge branch 'for-tony' of master.kernel.org:/.../balbi/usb into omap-for-linus
>       Merge branch 'for_2.6.40/pm-cleanup' of ssh://master.kernel.org/.../khilman/linux-omap-pm into omap-for-linus
>
> omar ramirez (2):
>       OMAP3/4: l3: fix omap3_l3_probe error path
>       OMAP3/4: l3: minor cleanup for parenthesis and extra spaces
>
>  arch/arm/configs/omap2plus_defconfig            |   83 +----
>  arch/arm/mach-omap2/Kconfig                     |    1 +
>  arch/arm/mach-omap2/Makefile                    |    4 +-
>  arch/arm/mach-omap2/board-2430sdp.c             |   27 +--
>  arch/arm/mach-omap2/board-3430sdp.c             |  151 ++-------
>  arch/arm/mach-omap2/board-4430sdp.c             |  114 ++-----
>  arch/arm/mach-omap2/board-am3517crane.c         |   10 +-
>  arch/arm/mach-omap2/board-am3517evm.c           |   56 +--
>  arch/arm/mach-omap2/board-apollon.c             |   29 +-
>  arch/arm/mach-omap2/board-cm-t35.c              |  236 ++----------
>  arch/arm/mach-omap2/board-cm-t3517.c            |    9 +-
>  arch/arm/mach-omap2/board-devkit8000.c          |  131 +------
>  arch/arm/mach-omap2/board-igep0020.c            |  449 +++++++++++-----------
>  arch/arm/mach-omap2/board-igep0030.c            |  458 -----------------------
>  arch/arm/mach-omap2/board-ldp.c                 |  138 +-------
>  arch/arm/mach-omap2/board-n8x0.c                |   28 +-
>  arch/arm/mach-omap2/board-omap3beagle.c         |  194 +++-------
>  arch/arm/mach-omap2/board-omap3evm.c            |  242 +++----------
>  arch/arm/mach-omap2/board-omap3logic.c          |   14 +-
>  arch/arm/mach-omap2/board-omap3pandora.c        |   90 +----
>  arch/arm/mach-omap2/board-omap3stalker.c        |  133 +------
>  arch/arm/mach-omap2/board-omap3touchbook.c      |  121 +------
>  arch/arm/mach-omap2/board-omap4panda.c          |   79 ++---
>  arch/arm/mach-omap2/board-overo.c               |  265 +++-----------
>  arch/arm/mach-omap2/board-rm680.c               |   21 +-
>  arch/arm/mach-omap2/board-rx51-peripherals.c    |   42 +--
>  arch/arm/mach-omap2/board-rx51-video.c          |    5 +-
>  arch/arm/mach-omap2/board-rx51.c                |   18 +-
>  arch/arm/mach-omap2/board-zoom-debugboard.c     |   65 +---
>  arch/arm/mach-omap2/board-zoom-display.c        |   31 +--
>  arch/arm/mach-omap2/board-zoom-peripherals.c    |   29 +--
>  arch/arm/mach-omap2/common-board-devices.c      |  163 ++++++++
>  arch/arm/mach-omap2/common-board-devices.h      |   35 ++
>  arch/arm/mach-omap2/cpuidle34xx.c               |  436 +++++++--------------
>  arch/arm/mach-omap2/gpmc-smc91x.c               |   11 +-
>  arch/arm/mach-omap2/gpmc-smsc911x.c             |   44 +--
>  arch/arm/mach-omap2/omap_l3_noc.c               |   51 ++--
>  arch/arm/mach-omap2/omap_l3_smx.c               |   42 +--
>  arch/arm/mach-omap2/omap_phy_internal.c         |    9 +-
>  arch/arm/mach-omap2/pm.h                        |   17 +-
>  arch/arm/mach-omap2/pm34xx.c                    |   14 -
>  arch/arm/mach-omap2/pm44xx.c                    |    2 -
>  arch/arm/mach-omap2/smartreflex.c               |   23 +-
>  arch/arm/mach-omap2/usb-musb.c                  |   22 +-
>  arch/arm/mach-omap2/usb-tusb6010.c              |    3 +-
>  arch/arm/mach-omap2/voltage.c                   |    1 -
>  arch/arm/plat-omap/include/plat/gpmc-smsc911x.h |    4 +-
>  arch/arm/plat-omap/include/plat/uncompress.h    |    1 -
>  arch/arm/plat-omap/include/plat/usb.h           |    2 +-
>  drivers/video/omap/Makefile                     |    1 -
>  drivers/video/omap/lcd_omap2evm.c               |  192 ----------
>  sound/soc/omap/Kconfig                          |    8 -
>  sound/soc/omap/Makefile                         |    1 -
>  sound/soc/omap/omap2evm.c                       |  139 -------
>  54 files changed, 1110 insertions(+), 3384 deletions(-)
>  delete mode 100644 arch/arm/mach-omap2/board-igep0030.c
>  create mode 100644 arch/arm/mach-omap2/common-board-devices.c
>  create mode 100644 arch/arm/mach-omap2/common-board-devices.h
>  delete mode 100644 drivers/video/omap/lcd_omap2evm.c
>  delete mode 100644 sound/soc/omap/omap2evm.c
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>

-- 
Regards,
Igor.

