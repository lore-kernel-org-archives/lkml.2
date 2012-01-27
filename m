Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756015Ab2A0IEU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jan 2012 03:04:20 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:45619 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754874Ab2A0IET (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jan 2012 03:04:19 -0500
Date: Fri, 27 Jan 2012 00:04:14 -0800
From: Olof Johansson <olof@lixom.net>
To: torvalds@linux-foundation.org
Cc: arnd@arndb.de, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, arm@kernel.org
Subject: [GIT PULL] arm-soc fixes for 3.3-rc
Message-ID: <20120127080414.GA13212@quad.lixom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,


The following changes since commit dcd6c92267155e70a94b3927bce681ce74b80d1f:

  Linux 3.3-rc1 (2012-01-19 15:04:48 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc.git fixes-for-linus

for you to fetch changes up to 5e9638643132795e6168bb483e883b6a9678e7b5:

  Merge branch 'imx-fixes' of git://git.pengutronix.de/git/imx/linux-2.6 into fixes (2012-01-26 23:15:11 -0800)

----------------------------------------------------------------

arm-soc fixes for 3.3-rc:

AT91 needed reset fixes which resulted in some minor code refactoring,
it also adds a feature-removal for one of their platforms for 3.4.
The USB patches have been acked by Greg K-H.

i.MX and ux500 both have some minor fixes, nothing controversial.

----------------------------------------------------------------
Fabio Estevam (1):
      ARM: imx: iomux-v1.h: Fix build error due to __init annotation

Jean-Christophe PLAGNIOL-VILLARD (7):
      USB: at91: fix clk_get error handling
      ARM/USB: at91/ohci-at91: rename vbus_pin_inverted to vbus_pin_active_low
      ARM: at91: fix cap9 ddrsdr register
      ARM: at91: merge at91cap9_ddrsdr.h in at91sam9_ddrsdr.h
      ARM: at91: introduce AT91_SAM9_ALT_RESET to select the at91sam9 alternative reset
      ARM: at91: make rstc soc independent
      ARM: at91: Fix at91sam9g45 and at91cap9 reset

Julia Lawall (1):
      arch/arm/mach-imx/mach-mx53_ard.c: add missing iounmap

Nicolas Ferre (2):
      ARM: at91: fix at91rm9200 soc subtype handling
      ARM: at91: removal of CAP9 SoC family

Olof Johansson (4):
      Merge branch 'at91-fixes' of git://github.com/at91linux/linux-at91 into fixes
      Merge branch 'imx6/fixes' of git://git.linaro.org/people/shawnguo/linux-2.6 into fixes
      Merge branch 'fixes-for-arm-soc' of git://git.kernel.org/.../linusw/linux-stericsson into fixes
      Merge branch 'imx-fixes' of git://git.pengutronix.de/git/imx/linux-2.6 into fixes

Philippe Langlais (2):
      mach-ux500: musb: now musb is always in OTG mode
      mach-ux500: no MMC_CAP_SD_HIGHSPEED on Snowball

Shawn Guo (1):
      ARM: imx6: add missing twd_clk for imx6q clock

Srinidhi KASAGAR (1):
      mach-ux500: enable ARM errata 764369

srinidhi kasagar (1):
      mach-ux500: do not override outer.inv_all

 Documentation/feature-removal-schedule.txt        |   14 +++
 arch/arm/mach-at91/Kconfig                        |   14 +++
 arch/arm/mach-at91/Makefile                       |   14 ++-
 arch/arm/mach-at91/at91cap9.c                     |    9 +--
 arch/arm/mach-at91/at91sam9260.c                  |    1 +
 arch/arm/mach-at91/at91sam9261.c                  |    1 +
 arch/arm/mach-at91/at91sam9263.c                  |    1 +
 arch/arm/mach-at91/at91sam9_alt_reset.S           |    7 +-
 arch/arm/mach-at91/at91sam9g45.c                  |    7 +-
 arch/arm/mach-at91/at91sam9g45_reset.S            |   40 ++++++++
 arch/arm/mach-at91/at91sam9rl.c                   |    1 +
 arch/arm/mach-at91/generic.h                      |    2 +
 arch/arm/mach-at91/include/mach/at91_rstc.h       |   18 +++-
 arch/arm/mach-at91/include/mach/at91cap9.h        |    2 +-
 arch/arm/mach-at91/include/mach/at91cap9_ddrsdr.h |  108 ---------------------
 arch/arm/mach-at91/include/mach/at91sam9260.h     |    2 +-
 arch/arm/mach-at91/include/mach/at91sam9261.h     |    2 +-
 arch/arm/mach-at91/include/mach/at91sam9263.h     |    2 +-
 arch/arm/mach-at91/include/mach/at91sam9_ddrsdr.h |   30 ++++--
 arch/arm/mach-at91/include/mach/at91sam9g45.h     |    2 +-
 arch/arm/mach-at91/include/mach/at91sam9rl.h      |    2 +-
 arch/arm/mach-at91/include/mach/board.h           |    2 +-
 arch/arm/mach-at91/pm.c                           |    9 +--
 arch/arm/mach-at91/pm.h                           |    8 +-
 arch/arm/mach-at91/pm_slowclock.S                 |    5 +-
 arch/arm/mach-at91/setup.c                        |   16 +++-
 arch/arm/mach-imx/clock-imx6q.c                   |   11 ++
 arch/arm/mach-mx5/board-mx53_ard.c                |    4 +-
 arch/arm/mach-ux500/Kconfig                       |    1 +
 arch/arm/mach-ux500/board-mop500-sdi.c            |    2 +
 arch/arm/mach-ux500/cache-l2x0.c                  |   48 ++--------
 arch/arm/mach-ux500/usb.c                         |    6 -
 arch/arm/plat-mxc/include/mach/iomux-v1.h         |    2 +-
 drivers/usb/host/ohci-at91.c                      |   24 ++++-
 34 files changed, 199 insertions(+), 218 deletions(-)
 create mode 100644 arch/arm/mach-at91/at91sam9g45_reset.S
 delete mode 100644 arch/arm/mach-at91/include/mach/at91cap9_ddrsdr.h
