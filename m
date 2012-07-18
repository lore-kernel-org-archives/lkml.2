Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751756Ab2GRG3v (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2012 02:29:51 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:1229 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750806Ab2GRG3r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2012 02:29:47 -0400
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Tue, 17 Jul 2012 23:29:42 -0700
From: Laxman Dewangan <ldewangan@nvidia.com>
To: <grant.likely@secretlab.ca>, <linus.walleij@stericsson.com>,
        <sameo@linux.intel.com>, <swarren@nvidia.com>,
        <broonie@opensource.wolfsonmicro.com>
CC: <linux-kernel@vger.kernel.org>, Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH V3 0/6] mfd: tp6586x: enhancements in the driver
Date: Wed, 18 Jul 2012 11:50:44 +0530
Message-ID: <1342592450-12488-1-git-send-email-ldewangan@nvidia.com>
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

Changes V2->V3
- Revert the irq regsitration through devm_* and used normal api.
- Rebased the series with above change as there was conflict.

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
 drivers/mfd/tps6586x.c           |  296 +++++++++++---------------------------
 6 files changed, 256 insertions(+), 210 deletions(-)
 create mode 100644 drivers/gpio/gpio-tps6586x.c

