Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932480Ab2HHIHr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2012 04:07:47 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:3714 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932429Ab2HHIHX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2012 04:07:23 -0400
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Wed, 08 Aug 2012 01:06:41 -0700
From: Laxman Dewangan <ldewangan@nvidia.com>
To: <swarren@wwwdotorg.org>, <w.sang@pengutronix.de>, <olof@lixom.net>,
        <khali@linux-fr.org>
CC: <ben-linux@fluff.org>, <linux-tegra@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-i2c@vger.kernel.org>,
        Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH 0/4] i2c: tegra: required clock support for controller
Date: Wed, 8 Aug 2012 13:21:30 +0530
Message-ID: <1344412294-2420-1-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Tegra's i2c controller required two clock sources for proper
operation named as div-clk and fast-clk.

Adding support to make sure that driver will get these clocks and 
enable before any transfer and disable after transfer completed.

Patch 1 add the entry of fast clock in clock table.
Patch 2 modify i2c driver to get the div and fast clock.
Patch 3 name the connection of the clock entry.
Patch 4 removes non-required entry from tegra20 clock table.

Laxman Dewangan (4):
  ARM: tegra: clock: add i2c fast clock entry in clock table
  i2c: tegra: pass proper name for getting clock
  ARM: tegra: clock: add connection name in i2c clock entry
  ARM: tegra: clock: remove unused clock entry for i2c

 arch/arm/mach-tegra/tegra20_clocks_data.c |   20 +++++-------
 arch/arm/mach-tegra/tegra30_clocks_data.c |   15 ++++++---
 drivers/i2c/busses/i2c-tegra.c            |   46 ++++++++++++++--------------
 3 files changed, 41 insertions(+), 40 deletions(-)

