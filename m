Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754529Ab2FSOjI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2012 10:39:08 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:13310 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754395Ab2FSOi1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2012 10:38:27 -0400
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Tue, 19 Jun 2012 07:38:13 -0700
From: Laxman Dewangan <ldewangan@nvidia.com>
To: <broonie@opensource.wolfsonmicro.com>, <grant.likely@secretlab.ca>,
        <rob.herring@calxeda.com>, <arnd@arndb.de>, <linus.walleij@linaro.org>,
        <lrg@ti.com>, <lee.jones@linaro.org>, <swarren@wwwdotorg.org>
CC: <devicetree-discuss@lists.ozlabs.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH V2 0/3] regulator: dt: add policy to match regulator with prop "regulator-compatible"
Date: Tue, 19 Jun 2012 19:58:16 +0530
Message-ID: <1340116099-17629-1-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Based on the discussion on patch
 [PATCH 2/2] ARM: dt: tegra: cardhu: register core regulator tps65911

and patch V1 of this series:
add policy to match regulator with the property of "regulator-compatible" of each
child regulator node with their hardware counterparts name.
Modify documentation as well to reflect this change and dts files.

Changes from V1:
- Modify the existing of_regulator_match() to use the property 
  "regulator-compatible" of each child node of regulator for
   matching rather than child node name.
- Documentation change to reflect this policy who are using the
  of_regulator_match().
- Modify the dts file to absorb this policy.

Laxman Dewangan (3):
  regulator: dt: regulator match by regulator-compatible
  regulator: dt: add policy to have property "regulator-compatible"
  ARM: dts: db8500: add node property "regulator-compatible" regulator
    node

 Documentation/devicetree/bindings/mfd/tps65910.txt |   54 ++++++--
 .../devicetree/bindings/regulator/tps6586x.txt     |   60 +++++++---
 arch/arm/boot/dts/db8500.dtsi                      |  128 +++++++++++++++-----
 drivers/regulator/of_regulator.c                   |   50 +++++---
 4 files changed, 215 insertions(+), 77 deletions(-)

