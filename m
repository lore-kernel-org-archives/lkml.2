Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759344Ab2EINOj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 09:14:39 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:8076 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756927Ab2EINOi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 09:14:38 -0400
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Wed, 09 May 2012 06:14:38 -0700
From: Laxman Dewangan <ldewangan@nvidia.com>
To: grant.likely@secretlab.ca, linus.walleij@stericsson.com,
        sameo@linux.intel.com, broonie@opensource.wolfsonmicro.com,
        jedu@slimlogic.co.uk, lrg@slimlogic.co.uk
Cc: linux-kernel@vger.kernel.org, Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH 0/4] mfd:tps65910: use devm_* and register gpio as platform driver
Date: Wed,  9 May 2012 18:40:53 +0530
Message-Id: <1336569057-3890-1-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series does cleanup in the mfd/tps65910 as follows:
- Do not cache the register when initailizing regmap. Cache when
  actually when we need it.
- Convert the allocation to use devm_* apis.
- Move the gpio as platform driver and register it as mfd sub devices.

Laxman Dewangan (4):
  mfd: tps65910: cache register when we need it
	Remove the chaching of register in regmap initialization.

  mfd: tps65910: convert all allocation to devm_*
	Convert the allocation to use devm_* apis.

  mfd: tps65910: register gpio as mfd device
  gpio: tps65910: move this as platform driver
	Above two patch to make gpio driver as platform driver and register
	as mfd sub device from core driver.
	

 drivers/gpio/gpio-tps65910.c |  140 ++++++++++++++++++++++++++++++-----------
 drivers/mfd/Kconfig          |    1 -
 drivers/mfd/tps65910.c       |   37 ++++-------
 include/linux/mfd/tps65910.h |    6 --
 4 files changed, 115 insertions(+), 69 deletions(-)

