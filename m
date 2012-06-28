Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752861Ab2F1Khz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2012 06:37:55 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:9555 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751163Ab2F1Khx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2012 06:37:53 -0400
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Thu, 28 Jun 2012 03:37:44 -0700
From: Prashant Gaikwad <pgaikwad@nvidia.com>
To: <swarren@wwwdotorg.org>, <mturquette@ti.com>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <linux-tegra@vger.kernel.org>, <linux@arm.linux.org.uk>,
        <ccross@android.com>, <olof@lixom.net>,
        Prashant Gaikwad <pgaikwad@nvidia.com>
Subject: [PATCH 0/6] Port Tegra to generic clk framework
Date: Thu, 28 Jun 2012 16:07:20 +0530
Message-ID: <1340879846-12900-1-git-send-email-pgaikwad@nvidia.com>
X-Mailer: git-send-email 1.7.4.1
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch set ports Tegra clock code to generic clock framework.

Depends on
[PATCH v3 0/9] Add clk_prepare/clk_unprepare series
[PATCH] ARM: tegra: Remove second instance of uart clk
[PATCH] dma: tegra: add clk_prepare/clk_unprepare
[PATCH] ARM: tegra: dma: rename driver name for clock to "tegra-apbdma"

Tested on Ventana and Cardhu

Prashant Gaikwad (6):
  ARM: tegra30: Separate out clk ops and clk data
  ARM: tegra20: Separate out clk ops and clk data
  ARM: tegra: Rename tegra20 clock file
  ARM: tegra: Add clk_tegra structure and helper functions
  ARM: tegra: Port tegra to generic clock framework
  ARM: tegra: Remove duplicate code

 arch/arm/Kconfig                          |    1 +
 arch/arm/mach-tegra/Makefile              |    4 +-
 arch/arm/mach-tegra/clock.c               |  570 +-------
 arch/arm/mach-tegra/clock.h               |   40 +-
 arch/arm/mach-tegra/common.c              |    1 -
 arch/arm/mach-tegra/include/mach/clk.h    |    3 +
 arch/arm/mach-tegra/tegra20_clocks.c      | 1498 +++++++++++++++++
 arch/arm/mach-tegra/tegra20_clocks.h      |   41 +
 arch/arm/mach-tegra/tegra20_clocks_data.c | 1127 +++++++++++++
 arch/arm/mach-tegra/tegra2_clocks.c       | 2464 ----------------------------
 arch/arm/mach-tegra/tegra30_clocks.c      | 2474 +++++++++--------------------
 arch/arm/mach-tegra/tegra30_clocks.h      |   53 +
 arch/arm/mach-tegra/tegra30_clocks_data.c | 1374 ++++++++++++++++
 13 files changed, 4935 insertions(+), 4715 deletions(-)
 create mode 100644 arch/arm/mach-tegra/tegra20_clocks.c
 create mode 100644 arch/arm/mach-tegra/tegra20_clocks.h
 create mode 100644 arch/arm/mach-tegra/tegra20_clocks_data.c
 delete mode 100644 arch/arm/mach-tegra/tegra2_clocks.c
 create mode 100644 arch/arm/mach-tegra/tegra30_clocks.h
 create mode 100644 arch/arm/mach-tegra/tegra30_clocks_data.c

-- 
1.7.4.1

