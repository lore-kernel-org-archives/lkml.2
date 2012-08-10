Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760191Ab2HJTHI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2012 15:07:08 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:50997 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759963Ab2HJTGo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2012 15:06:44 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        arm@kernel.org, Arnd Bergmann <arnd@arndb.de>,
        =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
Subject: =?UTF-8?q?=5BGIT=20PULL=203/3=5D=20arm-soc=3A=20make=20of=5Fdevice=5Fid-=3Edata=20constant?=
Date: Fri, 10 Aug 2012 21:06:15 +0200
Message-Id: <1344625575-27560-4-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1344625575-27560-1-git-send-email-arnd@arndb.de>
References: <1344625575-27560-1-git-send-email-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Provags-ID: V02:K0:+bOys/jluB8kpOTsRpqzZzkh6xfV3u5uy28kAWWJKKU
 gfo9U1EKm3MeJ7E2v8bYHo641fMLt6JJ5IjIWr5qzSh45Xv/NZ
 OZQfcV8HJ9AnxjYWcag0aoKtX9DJuJ5JtG6ZzW48Vn+E2CQV7f
 JoxYjvnkjIEqcfEsNxVXiD6CXlEqy1uO3TGaS4CvE854LXqffM
 1rtTkERTMmNdYX1FG7b/SvL+ANWSm6xU8yNosFx0fTKJGxXpJT
 RW0eN2N2fsE3+5n+AHV32XWYgnLWyr5FidHQjdJDEadbtsVsPu
 imgsBoxoVNub5qBS32OkQqkTAtafIloHC5tIvLvcL9vOu3ZzWu
 aEjS4O3Z1yzlZ2NcuEmshvlh6I089Npeqzw87YWyD
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 28a33cbc24e4256c143dce96c7d93bf423229f92:

  Linux 3.5 (2012-07-21 13:58:29 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc.git tags/late-warnings

for you to fetch changes up to 100e8f5fda756fe71d21c0ea68d67e56f5f05167:

  Merge branch 'ofdeviceiddata' of git://git.pengutronix.de/git/ukl/linux into late/warnings (2012-07-24 16:58:51 +0200)

----------------------------------------------------------------

arm-soc: make of_device_id->data constant

This patch series from Uwe Kleine-Königwas meant to go into
the v3.6 merge window, but got lost in a small miscommunication
between Olof and me. It gets rid of a (harmless) gcc warning
by making the of_device_id->data pointer constant, which is
generally considered to be a good idea.

Cc: "Uwe Kleine-König" <u.kleine-koenig@pengutronix.de>
----------------------------------------------------------------
Arnd Bergmann (7):
      watchdog/mpc8xxx: add a const qualifier
      powerpc/fsl_msi: drop unneeded cast to non-const pointer
      mfd/da9052: make i2c_device_id array const
      i2c/mpc: make data used as *of_device_id.data const
      macintosh/mediabay: make data used as *of_device_id.data const
      can: mpc5xxx_can: make data used as *of_device_id.data const
      Merge branch 'ofdeviceiddata' of git://git.pengutronix.de/git/ukl/linux into late/warnings

Marc Kleine-Budde (1):
      can: mpc5xxx_can: make data in mpc5xxx_can_probe const

Uwe Kleine-König (18):
      spi/imx: make spi_imx_data.devtype_data member point to const data
      spi/spi-omap2-mcspi: add a const qualifier
      serial/imx: make imx_port.devdata member point to const data
      serial/mpc52xx_uart: add a const qualifier
      ARM: cache-l2x0: add a const qualifier
      misc/atmel_tc: make atmel_tc.tcb_config member point to const data
      gpio/gpio-omap.c: add a const qualifier
      gpio/mpc8xxx: add a const qualifier
      i2c/i2c-omap: add a const qualifier
      i2c/mpc: add a const qualifier
      dmaengine: at_hdmac: add a few const qualifiers
      mmc/omap_hsmmc: add a const qualifier
      macintosh/mediabay: add a const qualifier
      powerpc/83xx: add a const qualifier
      powerpc/fsl_msi: add a const qualifier
      powerpc/celleb_pci: add a const qualifier
      of: add const to struct *of_device_id.data
      gpio/gpio-omap: make platformdata used as *of_device_id.data const

 arch/arm/mm/cache-l2x0.c                 |    2 +-
 arch/powerpc/platforms/83xx/suspend.c    |    2 +-
 arch/powerpc/platforms/cell/celleb_pci.c |    2 +-
 arch/powerpc/sysdev/fsl_msi.c            |    8 ++++----
 drivers/dma/at_hdmac.c                   |    4 ++--
 drivers/gpio/gpio-mpc8xxx.c              |    2 +-
 drivers/gpio/gpio-omap.c                 |    8 ++++----
 drivers/i2c/busses/i2c-mpc.c             |   12 ++++++------
 drivers/i2c/busses/i2c-omap.c            |    3 ++-
 drivers/macintosh/mediabay.c             |    8 ++++----
 drivers/mfd/da9052-i2c.c                 |    4 ++--
 drivers/mmc/host/omap_hsmmc.c            |    2 +-
 drivers/net/can/mscan/mpc5xxx_can.c      |    6 +++---
 drivers/spi/spi-imx.c                    |    2 +-
 drivers/spi/spi-omap2-mcspi.c            |    2 +-
 drivers/tty/serial/imx.c                 |    2 +-
 drivers/tty/serial/mpc52xx_uart.c        |    2 +-
 drivers/watchdog/mpc8xxx_wdt.c           |    2 +-
 include/linux/atmel_tc.h                 |    2 +-
 include/linux/mod_devicetable.h          |    2 +-
 20 files changed, 39 insertions(+), 38 deletions(-)
