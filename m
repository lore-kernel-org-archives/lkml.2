Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030400Ab2GMKqy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2012 06:46:54 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:3175 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030272Ab2GMKqx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2012 06:46:53 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Fri, 13 Jul 2012 03:46:45 -0700
From: Laxman Dewangan <ldewangan@nvidia.com>
To: <grant.likely@secretlab.ca>, <linus.walleij@stericsson.com>,
        <sameo@linux.intel.com>
CC: <linux-kernel@vger.kernel.org>, <swarren@nvidia.com>,
        <broonie@opensource.wolfsonmicro.com>,
        Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH 0/5] mfd: tp6586x: enhancements in the driver
Date: Fri, 13 Jul 2012 16:09:22 +0530
Message-ID: <1342175967-10087-1-git-send-email-ldewangan@nvidia.com>
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

Laxman Dewangan (5):
  mfd: tps6586x:use devm managed resources
  mfd: Use regmap for tps6586x register access.
  mfd: tps6586x: cache register through regmap
  gpio: tps6586x: add gpio support through platform driver
  mfd: tps6586x: remove gpio support from core driver

 drivers/gpio/Kconfig         |    7 +
 drivers/gpio/Makefile        |    1 +
 drivers/gpio/gpio-tps6586x.c |  158 ++++++++++++++++++++++
 drivers/mfd/Kconfig          |    3 +-
 drivers/mfd/tps6586x.c       |  301 ++++++++++++------------------------------
 5 files changed, 255 insertions(+), 215 deletions(-)
 create mode 100644 drivers/gpio/gpio-tps6586x.c

