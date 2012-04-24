Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757918Ab2DXXgJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 19:36:09 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:16809 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756636Ab2DXXgH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 19:36:07 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Tue, 24 Apr 2012 16:36:06 -0700
From: Rhyland Klein <rklein@nvidia.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Liam Girdwood <lrg@ti.com>
CC: <linux-kernel@vger.kernel.org>, <devicetree-discuss@lists.ozlabs.org>,
        Rhyland Klein <rklein@nvidia.com>
Subject: [PATCH 0/8 v2] Update TPS65910 to boot using devicetree
Date: Tue, 24 Apr 2012 16:36:02 -0700
Message-ID: <1335310570-12455-1-git-send-email-rklein@nvidia.com>
X-Mailer: git-send-email 1.7.0.4
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch set updates the tps65910 driver to boot using devicetree.

This patch set now includes an addition to the of_regulator code which will
parse out all the regulator init data for a device given a list of the
regulator names it is expecting and a pointer to the array of where to store
the pointers to the regulator_init_data structures.

Rhyland Klein (8):
  regulator: add generic of node parsing for regulators
  regulator: add node validation checks
  mfd: tps65910: Commonize regmap access through header
  regulator: tps65910: Add device tree bindings
  mfd: tps65910: Add device-tree support
  regulator: tps65910 regulator: add device tree support
  mfd: tps65910-irq: Add devicetree init support
  ARM: Tegra: Add support for TPS65910 PMIC

 Documentation/devicetree/bindings/mfd/tps65910.txt |  133 +++++++++++++
 arch/arm/boot/dts/tegra-cardhu.dts                 |   91 +++++++++
 drivers/gpio/gpio-tps65910.c                       |   14 +-
 drivers/mfd/tps65910-irq.c                         |   55 ++++---
 drivers/mfd/tps65910.c                             |  107 ++++++++---
 drivers/regulator/of_regulator.c                   |   80 ++++++++
 drivers/regulator/tps65910-regulator.c             |  195 +++++++++++++++-----
 include/linux/mfd/tps65910.h                       |   29 +++-
 include/linux/regulator/of_regulator.h             |    9 +
 9 files changed, 606 insertions(+), 107 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/mfd/tps65910.txt

