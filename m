Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756729Ab2JWHSz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 03:18:55 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:14400 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756666Ab2JWHSy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 03:18:54 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Tue, 23 Oct 2012 00:18:53 -0700
From: Pavan Kunapuli <pkunapuli@nvidia.com>
To: <swarren@wwwdotorg.org>, <linux@arm.linux.org.uk>, <cjb@laptop.org>,
        <linux-kernel@vger.kernel.org>, <linux-mmc@vger.kernel.org>
CC: Pavan Kunapuli <pkunapuli@nvidia.com>
Subject: [PATCH 0/2] mmc: sdhci: Defer probe if regulators are not registered
Date: Tue, 23 Oct 2012 12:48:27 +0530
Message-ID: <1350976709-19248-1-git-send-email-pkunapuli@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Regulator driver registration may sometimes be done after
mmc driver registration. In such cases, defer mmc probe
to obtain vmmc and vmmcq regulators.
Added vmmc and vmmcq supplies to tegra dt files.

Pavan Kunapuli (2):
  ARM: dt: tegra: Add sdhci regulators
  mmc: sdhci: Defer probe if regulator_get fails

 arch/arm/boot/dts/tegra20-harmony.dts    |   27 ++++++++++++++++++++-
 arch/arm/boot/dts/tegra20-paz00.dts      |   24 +++++++++++++++++++-
 arch/arm/boot/dts/tegra20-seaboard.dts   |   35 ++++++++++++++++++++++++++++-
 arch/arm/boot/dts/tegra20-tamonten.dtsi  |   10 ++++++++
 arch/arm/boot/dts/tegra20-ventana.dts    |   36 ++++++++++++++++++++++++++++-
 arch/arm/boot/dts/tegra20-whistler.dts   |    9 +++++-
 arch/arm/boot/dts/tegra30-cardhu-a02.dts |    2 +
 arch/arm/boot/dts/tegra30-cardhu-a04.dts |    2 +
 arch/arm/boot/dts/tegra30-cardhu.dtsi    |   19 ++++++++++++++-
 drivers/mmc/host/sdhci.c                 |   25 ++++++++++++++++++--
 10 files changed, 176 insertions(+), 13 deletions(-)

