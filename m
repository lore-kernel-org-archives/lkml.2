Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755048Ab2GJLKL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2012 07:10:11 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:50400 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754727Ab2GJLKG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2012 07:10:06 -0400
From: AnilKumar Ch <anilkumar@ti.com>
To: <sameo@linux.intel.com>, <lrg@ti.com>,
        <broonie@opensource.wolfsonmicro.com>, <linux-kernel@vger.kernel.org>
CC: <linux-omap@vger.kernel.org>, <devicetree-discuss@lists.ozlabs.org>,
        <grant.likely@secretlab.ca>, AnilKumar Ch <anilkumar@ti.com>
Subject: [PATCH v2 0/3] Add device tree support for AM33XX regulators
Date: Tue, 10 Jul 2012 16:39:41 +0530
Message-ID: <1341918584-28004-1-git-send-email-anilkumar@ti.com>
X-Mailer: git-send-email 1.7.0.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add device tree support for regulators present on AM33XX family
of devices like AM335X-EVM and AM335X-Bone. TPS65217 regulator
is present on AM335X-Bone and TPS65910 on AM335X-EVM.

First patch adds the device tree support to tps65217 regulator
so that it will take the parameters from tps65217.dtsi file and
convert to tps65217 regulator parameters.

Second patch adds tps65910 device tree data by adding separate
DT tps65910.dtsi file, which contains the generic tps65910 PMIC
DT data.

Third patch adds tps65217 device tree data by adding separate
tps65910.dtsi file, which contains the generic tps65910 PMIC
DT data.

This patch series was tested by adding the I2C slave address to
corresponding .dts files.

Changes form V1:
        - Add regulator-compatible data to dt files.
        - Separated device tree data addition to am335x-evm/bone dts
          from the regulator patches

AnilKumar Ch (3):
  regulator: tps65217: Add device tree support
  ARM: OMAP2+: AM33XX: Add tps65910 device tree data
  ARM: OMAP2+: AM33XX: Add tps65217 device tree data

 .../devicetree/bindings/regulator/tps65217.txt     |   91 +++++++++++++++
 arch/arm/boot/dts/tps65217.dtsi                    |   84 +++++++++++++
 arch/arm/boot/dts/tps65910.dtsi                    |  123 ++++++++++++++++++++
 drivers/mfd/tps65217.c                             |   67 ++++++++++-
 drivers/regulator/tps65217-regulator.c             |    1 +
 include/linux/mfd/tps65217.h                       |    3 +-
 6 files changed, 366 insertions(+), 3 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/regulator/tps65217.txt
 create mode 100644 arch/arm/boot/dts/tps65217.dtsi
 create mode 100644 arch/arm/boot/dts/tps65910.dtsi

-- 
1.7.9.5

