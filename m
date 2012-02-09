Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758688Ab2BIXs3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Feb 2012 18:48:29 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:18221 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758670Ab2BIXs1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Feb 2012 18:48:27 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Thu, 09 Feb 2012 15:48:26 -0800
From: Peter De Schrijver <pdeschrijver@nvidia.com>
To: Peter De Schrijver <pdeschrijver@nvidia.com>
Cc: Colin Cross <ccross@android.com>, Olof Johansson <olof@lixom.net>,
        Stephen Warren <swarren@nvidia.com>,
        Russell King <linux@arm.linux.org.uk>, Gary King <gking@nvidia.com>,
        Arnd Bergmann <arnd@arndb.de>, linux-tegra@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH v3 00/10] Add tegra30 support for secondary cores
Date: Fri, 10 Feb 2012 01:47:40 +0200
Message-Id: <1328831277-21002-1-git-send-email-pdeschrijver@nvidia.com>
X-Mailer: git-send-email 1.7.7.rc0.72.g4b5ea.dirty
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset introduces support for secondary cores on tegra30. It also
introduces some functions for the flowcontroller and adds basic support for
tegra30 powerdomains.

---

This patchset requires http://www.spinics.net/lists/arm-kernel/msg158016.html
for the cortex A9 erratum #743622 workaround

Changes in v3:

 * split out chip id changes in several patches
 * remove reset handler debugging code
 * remove unused size declartion for reset SRAM code
 * remove workaround for cortex A9 erratum #743622. This will be handled by
   generic code.

Changes in v2:

 * moved chip id reading to fuse.c and cleanup code
 * don't set bit 1 of SB_CTRL on Tegra20
 * removed unused variables in tegra_cpu_reset_handler_init()

Peter De Schrijver (10):
  ARM: tegra: cleanup use of chipid register
  ARM: tegra: export Tegra chipid
  ARM: tegra: initialize Tegra chipid early
  ARM: tegra: functions to access the flowcontroller
  ARM: tegra: rework Tegra secondary CPU core bringup
  ARM: tegra: prepare powergate.c for multiple variants
  ARM: tegra: export tegra_powergate_is_powered()
  ARM: tegra: add support for Tegra30 powerdomains
  ARM: tegra: support for Tegra30 CPU powerdomains
  ARM: tegra: support for secondary cores on Tegra30

 arch/arm/mach-tegra/Makefile                 |    2 +
 arch/arm/mach-tegra/common.c                 |    4 +
 arch/arm/mach-tegra/flowctrl.c               |   62 ++++++++++
 arch/arm/mach-tegra/flowctrl.h               |    5 +
 arch/arm/mach-tegra/fuse.c                   |   18 ++-
 arch/arm/mach-tegra/fuse.h                   |    4 +
 arch/arm/mach-tegra/headsmp.S                |  166 ++++++++++++++++++++++++--
 arch/arm/mach-tegra/include/mach/iomap.h     |    3 +
 arch/arm/mach-tegra/include/mach/powergate.h |   15 ++-
 arch/arm/mach-tegra/platsmp.c                |  137 +++++++++++++++-------
 arch/arm/mach-tegra/powergate.c              |   53 +++++++-
 arch/arm/mach-tegra/reset.c                  |   84 +++++++++++++
 arch/arm/mach-tegra/reset.h                  |   50 ++++++++
 13 files changed, 540 insertions(+), 63 deletions(-)
 create mode 100644 arch/arm/mach-tegra/flowctrl.c
 create mode 100644 arch/arm/mach-tegra/reset.c
 create mode 100644 arch/arm/mach-tegra/reset.h

-- 
1.7.4.1

