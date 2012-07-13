Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933296Ab2GMN6u (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2012 09:58:50 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:18241 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750908Ab2GMN6q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2012 09:58:46 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Fri, 13 Jul 2012 06:54:32 -0700
From: Laxman Dewangan <ldewangan@nvidia.com>
To: <broonie@opensource.wolfsonmicro.com>, <ccross@android.com>,
        <olof@lixom.net>, <swarren@wwwdotorg.org>, <lrg@ti.com>
CC: <thierry.reding@avionic-design.de>, <linux-kernel@vger.kernel.org>,
        <linux-tegra@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <devicetree-discuss@lists.ozlabs.org>, <rob.herring@calxeda.com>,
        <grant.likely@secretlab.ca>, Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH 0/2] regulator: tps6586x: support for input supply
Date: Fri, 13 Jul 2012 19:20:30 +0530
Message-ID: <1342187432-18668-1-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series add the support for the input supply of tps6586x
regulator.
The changes are based on on discussion on patch
[PATCH 1/3] ARM: dt: tegra: seaboard: add regulators
on which the input supply name should be require in DT case and
unconditionally set on the desc.supply_name.

To add this, the existing user (non-dt) of this PMIC also need to fill
require input supply so that it will not break the functionality with
this support.
Currently harmony is using this PMIC and hence making the changes
on this as first change of series to avoid any functionality break.

The grep shows that there is no more user of this regulator and hence it
is safe to change in tps6586x regulator driver.

Laxman Dewangan (2):
  ARM: tegra: harmony: add regulator supply name and its input supply
  regulator: tps6586x: add support for input supply

 .../devicetree/bindings/regulator/tps6586x.txt     |   17 +++++++
 arch/arm/mach-tegra/board-harmony-power.c          |   33 ++++++++-----
 drivers/regulator/tps6586x-regulator.c             |   47 ++++++++++---------
 3 files changed, 62 insertions(+), 35 deletions(-)

