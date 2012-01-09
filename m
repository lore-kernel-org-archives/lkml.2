Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933464Ab2AIWQT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jan 2012 17:16:19 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:60311 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932989Ab2AIWOB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jan 2012 17:14:01 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Olof Johansson <olof@lixom.net>,
        Russell King <linux@arm.linux.org.uk>,
        <linux-arm-kernel@lists.infradead.org>, Arnd Bergmann <arnd@arndb.de>
Subject: [GIT PULL 11/11] clock management changes for i.MX
Date: Mon,  9 Jan 2012 22:12:51 +0000
Message-Id: <1326147171-13752-12-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1326147171-13752-1-git-send-email-arnd@arndb.de>
References: <1326147171-13752-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:9UW3tbaKRuKaNECNjCKhoylcpQrTKEqxAjFhUTTA8SG
 wQrc1Jj1ZW0ye9Dpn+RT+frZZlnzLBT0X6PmuL1/5AyLUhFQki
 nrlyOCgTJMEJJoHnxD+HX+r/fLn+LItabHkvX1ulCRak4zqQmA
 7Yisxk6vJ1fvnkmBSDeFv8FfUMADFhIBBKFOzz1NefVgzB1ddE
 II9wMqZaHFUTV8hRVCzNI6G2x0UFO+eMwJVNsbxNU+zoQTsAuL
 pIKmwjI+YijeDamE7v/7Gr8OLIDJTMuja70HmbR9DIvMfjfPCs
 DO+avNUzIFL7PDXJpE4g/xwzTuKCcVPX33eefYqA+/79xGPU9R
 e5eOgbK84nDpvd/Wm3omwzb//GTEwtu4Igy/LnLmip/XUlLWjc
 yw1S2RidWqG+Q==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Another simple series related to clock management, this time only for
imx.

The following changes since commit d9253788a195d4e9ee54a53bc1d97678131c20ec:

  Merge branch 'next/timer' into for-next3 (2012-01-09 17:08:43 +0000)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc.git next/clk

Arnd Bergmann (2):
      Merge branch 'mxs/clk-prepare' of git://git.linaro.org/people/shawnguo/linux-2.6 into imx/clk
      Merge branch 'imx/clk' into next/clk

Richard Zhao (2):
      clk: add helper functions clk_prepare_enable and clk_disable_unprepare
      net: fec: add clk_prepare/clk_unprepare

Shawn Guo (10):
      ARM: mxs: convert platform code to clk_prepare/clk_unprepare
      dma: mxs-dma: convert to clk_prepare/clk_unprepare
      mmc: mxs-mmc: convert to clk_prepare/clk_unprepare
      mtd: gpmi-lib: convert to clk_prepare/clk_unprepare
      net: flexcan: convert to clk_prepare/clk_unprepare
      serial: mxs-auart: convert to clk_prepare/clk_unprepare
      video: mxsfb: convert to clk_prepare/clk_unprepare
      ASoC: mxs-saif: convert to clk_prepare/clk_unprepare
      clk: add config option HAVE_CLK_PREPARE into Kconfig
      ARM: mxs: select HAVE_CLK_PREPARE for clock

 arch/arm/Kconfig                      |    1 +
 arch/arm/mach-mxs/clock-mx23.c        |   10 +++++-----
 arch/arm/mach-mxs/clock-mx28.c        |   10 +++++-----
 arch/arm/mach-mxs/clock.c             |   33 +++++++++++++++++++++++----------
 arch/arm/mach-mxs/mach-mx28evk.c      |    2 +-
 arch/arm/mach-mxs/system.c            |    2 +-
 arch/arm/mach-mxs/timer.c             |    2 +-
 drivers/clk/Kconfig                   |    3 +++
 drivers/dma/mxs-dma.c                 |    8 ++++----
 drivers/mmc/host/mxs-mmc.c            |   10 +++++-----
 drivers/mtd/nand/gpmi-nand/gpmi-lib.c |   12 ++++++------
 drivers/net/can/flexcan.c             |   10 +++++-----
 drivers/net/ethernet/freescale/fec.c  |   10 +++++-----
 drivers/tty/serial/mxs-auart.c        |    8 ++++----
 drivers/video/mxsfb.c                 |    8 ++++----
 include/linux/clk.h                   |   22 ++++++++++++++++++++++
 sound/soc/mxs/mxs-saif.c              |    4 ++--
 17 files changed, 97 insertions(+), 58 deletions(-)
