Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755456Ab2EHPnc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 11:43:32 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:5586 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754857Ab2EHPnb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 11:43:31 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Tue, 08 May 2012 08:43:30 -0700
From: Rhyland Klein <rklein@nvidia.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Liam Girdwood <lrg@ti.com>
CC: <linux-kernel@vger.kernel.org>, <devicetree-discuss@lists.ozlabs.org>,
        Rhyland Klein <rklein@nvidia.com>
Subject: [PATCH 0/6 v3] Update TPS65910 to boot using devicetree
Date: Tue, 8 May 2012 11:42:37 -0700
Message-ID: <1336502563-31789-1-git-send-email-rklein@nvidia.com>
X-Mailer: git-send-email 1.7.0.4
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch set updates the tps65910 driver to boot using devicetree.

This patch set now uses the new addition to the of_regulator code,
of_regulator_match to find all the regulator init data for the device.

Rhyland Klein (6):
  mfd: tps65910: Commonize regmap access through header
  regulator: tps65910: Add device tree bindings
  mfd: tps65910: Add device-tree support
  regulator: tps65910 regulator: add device tree support
  mfd: tps65910-irq: Add devicetree init support
  ARM: Tegra: Add support for TPS65910 PMIC

 Documentation/devicetree/bindings/mfd/tps65910.txt |  133 ++++++++++++++
 arch/arm/boot/dts/tegra-cardhu.dts                 |   91 ++++++++++
 drivers/gpio/gpio-tps65910.c                       |   14 +-
 drivers/mfd/tps65910-irq.c                         |   55 ++++---
 drivers/mfd/tps65910.c                             |  120 +++++++++----
 drivers/regulator/tps65910-regulator.c             |  190 +++++++++++++++-----
 include/linux/mfd/tps65910.h                       |   29 +++-
 7 files changed, 523 insertions(+), 109 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/mfd/tps65910.txt

