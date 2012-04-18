Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753553Ab2DRBEQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2012 21:04:16 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:13448 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752195Ab2DRBEO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2012 21:04:14 -0400
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Tue, 17 Apr 2012 18:04:09 -0700
From: Rhyland Klein <rklein@nvidia.com>
To: Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Samuel Ortiz <sameo@linux.intel.com>
CC: <devicetree-discuss@lists.ozlabs.org>, <linux-kernel@vger.kernel.org>,
        <linux-tegra@vger.kernel.org>, Rhyland Klein <rklein@nvidia.com>
Subject: [PATCH 0/4] Update TPS65910 to boot using devicetree
Date: Tue, 17 Apr 2012 18:00:25 -0700
Message-ID: <1334710829-22777-1-git-send-email-rklein@nvidia.com>
X-Mailer: git-send-email 1.7.0.4
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch set updates the tps65910 driver to boot using devicetree.

One thing that is unfavorable is the addition of the use_dt_for_init_data
flag. I added this as I wanted to split the parsing of the of nodes between
the tps65910-regulator code and the main tps65910 code. This split was to
maintain the list of regulator names solely inside the tps65910-regulator
code as it already was.

Rhyland Klein (4):
  regulator: tps65910: update type for regmap
  regulator: tps65910: Add device tree bindings
  mfd: tps65910: Add device-tree support
  ARM: Tegra: Add support for TPS65910 PMIC

 Documentation/devicetree/bindings/mfd/tps65910.txt |  132 ++++++++++++++++++++
 arch/arm/boot/dts/tegra-cardhu.dts                 |   92 ++++++++++++++
 drivers/gpio/gpio-tps65910.c                       |   39 ++++++-
 drivers/mfd/tps65910-irq.c                         |   21 +++-
 drivers/mfd/tps65910.c                             |   78 ++++++++++++-
 drivers/regulator/tps65910-regulator.c             |   86 +++++++++++++-
 include/linux/mfd/tps65910.h                       |    3 +-
 7 files changed, 439 insertions(+), 12 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/mfd/tps65910.txt

