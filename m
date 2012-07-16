Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752118Ab2GPHBX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2012 03:01:23 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:6369 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750897Ab2GPHBU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2012 03:01:20 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Mon, 16 Jul 2012 00:01:05 -0700
From: Laxman Dewangan <ldewangan@nvidia.com>
To: <grant.likely@secretlab.ca>, <linus.walleij@stericsson.com>,
        <sameo@linux.intel.com>
CC: <linux-kernel@vger.kernel.org>, <swarren@nvidia.com>,
        <broonie@opensource.wolfsonmicro.com>,
        Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH V2 0/6] mfd: tp6586x: enhancements in the driver
Date: Mon, 16 Jul 2012 12:21:44 +0530
Message-ID: <1342421510-10638-1-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Doing some enhancements in the tps6586x core driver which is
based on some recent driver framework enhancements.
Following are highlights of changes:
- Use devm for allocation to remove the code for freeing it.
- Use regmap i2c for register access in place of direct i2c apis.
  This will give the debug fs and cache functionality through regmap
  framework.
- Use the regmap caching for some fo register in place of local
  implementation.
- Move the gpio support driver to the drivers/gpio and implement it as
  platform driver. The registration will be done as mfd sub devices.


Changes V1 -> V2:
- Remove the unnecessariy header inclusion in the gpio-tps6586x.
- To avoid bisect functionality break, grep the user of tps6586x and
  found that tegra_defconfig is only using this. Added the
  GPIO_TPS6586x in config variable on this series.
  This results 6 patch on this series.

Laxman Dewangan (6):
  mfd: tps6586x:use devm managed resources
  mfd: Use regmap for tps6586x register access.
  mfd: tps6586x: cache register through regmap
  gpio: tps6586x: add gpio support through platform driver
  ARM: tegra: defconfig: enable tps6586x gpio
  mfd: tps6586x: remove gpio support from core driver

 arch/arm/configs/tegra_defconfig |    1 +
 drivers/gpio/Kconfig             |    7 +
 drivers/gpio/Makefile            |    1 +
 drivers/gpio/gpio-tps6586x.c     |  158 ++++++++++++++++++++
 drivers/mfd/Kconfig              |    3 +-
 drivers/mfd/tps6586x.c           |  301 +++++++++++---------------------------
 6 files changed, 256 insertions(+), 215 deletions(-)
 create mode 100644 drivers/gpio/gpio-tps6586x.c

