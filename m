Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754836Ab2AaQlR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jan 2012 11:41:17 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:7830 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754627Ab2AaQlP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jan 2012 11:41:15 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Tue, 31 Jan 2012 08:41:15 -0800
From: Peter De Schrijver <pdeschrijver@nvidia.com>
To: Peter De Schrijver <pdeschrijver@nvidia.com>
Cc: Colin Cross <ccross@android.com>, Olof Johansson <olof@lixom.net>,
        Stephen Warren <swarren@nvidia.com>,
        Russell King <linux@arm.linux.org.uk>, Gary King <gking@nvidia.com>,
        Arnd Bergmann <arnd@arndb.de>, linux-tegra@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 0/8] Add tegra30 support for secondary cores
Date: Tue, 31 Jan 2012 18:40:38 +0200
Message-Id: <1328028051-24271-1-git-send-email-pdeschrijver@nvidia.com>
X-Mailer: git-send-email 1.7.7.rc0.72.g4b5ea.dirty
X-NVConfidentiality: public
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset introduces support for secondary cores on tegra30. It also
introduces some functions for the flowcontroller and adds basic support for
tegra30 powerdomains.

Peter De Schrijver (8):
  ARM: tegra: export the chipid
  ARM: tegra: functions to access the flowcontroller
  ARM: tegra: rework Tegra secondary CPU core bringup
  ARM: tegra: prepare powergate.c for multiple variants
  ARM: tegra: export tegra_powergate_is_powered()
  ARM: tegra: add support for Tegra30 powerdomains
  ARM: tegra: support for Tegra30 CPU powerdomains
  ARM: tegra: support for secondary cores on Tegra30

 arch/arm/mach-tegra/Makefile                 |    2 +
 arch/arm/mach-tegra/common.c                 |    4 +
 arch/arm/mach-tegra/flowctrl.c               |   62 ++++++++
 arch/arm/mach-tegra/flowctrl.h               |    5 +
 arch/arm/mach-tegra/fuse.c                   |   18 ++-
 arch/arm/mach-tegra/fuse.h                   |    4 +
 arch/arm/mach-tegra/headsmp.S                |  192 ++++++++++++++++++++++++-
 arch/arm/mach-tegra/include/mach/iomap.h     |    3 +
 arch/arm/mach-tegra/include/mach/powergate.h |   15 ++-
 arch/arm/mach-tegra/platsmp.c                |  139 +++++++++++++------
 arch/arm/mach-tegra/powergate.c              |   53 +++++++-
 arch/arm/mach-tegra/reset.c                  |   84 +++++++++++
 arch/arm/mach-tegra/reset.h                  |   50 +++++++
 13 files changed, 568 insertions(+), 63 deletions(-)
 create mode 100644 arch/arm/mach-tegra/flowctrl.c
 create mode 100644 arch/arm/mach-tegra/reset.c
 create mode 100644 arch/arm/mach-tegra/reset.h

-- 
1.7.7.rc0.72.g4b5ea.dirty

