Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757262Ab1E3OoM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 May 2011 10:44:12 -0400
Received: from mail-px0-f179.google.com ([209.85.212.179]:61439 "EHLO
	mail-px0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757048Ab1E3OoL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 May 2011 10:44:11 -0400
From: Shawn Guo <shawn.guo@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: grant.likely@secretlab.ca, arnd@arndb.de, kernel@pengutronix.de,
        linux-arm-kernel@lists.infradead.org, patches@linaro.org
Subject: [PATCH 0/4] Move plat-mxc gpio driver into drivers/gpio
Date: Mon, 30 May 2011 22:52:15 +0800
Message-Id: <1306767139-24763-1-git-send-email-shawn.guo@linaro.org>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch set moves plat-mxc gpio driver into drivers/gpio.  It's
based on the following tree, plus Sascha's i.MX consolidation
patches.

    git://git.pengutronix.de/git/imx/linux-2.6.git imx-for-3.0

Shawn Guo (4):
      gpio: gpio-mxc: add gpio driver for Freescale MXC architecture
      ARM: mxc: migrate mach-mx5 gpio driver to gpio-mxc
      ARM: mxc: migrate mach-imx gpio driver to gpio-mxc
      ARM: mxc: remove plat-mxc/gpio driver

 arch/arm/mach-imx/mm-imx1.c                        |    9 -
 arch/arm/mach-imx/mm-imx21.c                       |   11 -
 arch/arm/mach-imx/mm-imx25.c                       |    9 -
 arch/arm/mach-imx/mm-imx27.c                       |   11 -
 arch/arm/mach-imx/mm-imx31.c                       |    8 -
 arch/arm/mach-imx/mm-imx35.c                       |    8 -
 arch/arm/mach-mx5/devices.c                        |   64 ------
 arch/arm/mach-mx5/mm-mx50.c                        |   11 -
 arch/arm/mach-mx5/mm.c                             |    6 -
 arch/arm/plat-mxc/Makefile                         |    2 +-
 arch/arm/plat-mxc/devices.c                        |   11 +
 arch/arm/plat-mxc/devices/Makefile                 |    1 +
 arch/arm/plat-mxc/devices/platform-gpio-mxc.c      |  113 ++++++++++
 arch/arm/plat-mxc/include/mach/devices-common.h    |    2 +
 arch/arm/plat-mxc/include/mach/gpio.h              |   27 ---
 drivers/gpio/Makefile                              |    1 +
 .../arm/plat-mxc/gpio.c => drivers/gpio/gpio-mxc.c |  218 +++++++++++++-------
 17 files changed, 275 insertions(+), 237 deletions(-)
