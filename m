Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751531Ab2AZRHk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jan 2012 12:07:40 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:7243 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750957Ab2AZRHj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jan 2012 12:07:39 -0500
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Thu, 26 Jan 2012 09:07:38 -0800
From: Peter De Schrijver <pdeschrijver@nvidia.com>
To: Peter De Schrijver <pdeschrijver@nvidia.com>
Cc: Colin Cross <ccross@android.com>, Olof Johansson <olof@lixom.net>,
        Stephen Warren <swarren@nvidia.com>,
        Russell King <linux@arm.linux.org.uk>, Gary King <gking@nvidia.com>,
        Arnd Bergmann <arnd@arndb.de>, linux-tegra@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH v1 0/8] Support for secondary cores on Tegra30
Date: Thu, 26 Jan 2012 19:07:05 +0200
Message-Id: <1327597641-7519-1-git-send-email-pdeschrijver@nvidia.com>
X-Mailer: git-send-email 1.7.7.rc0.72.g4b5ea.dirty
X-NVConfidentiality: public
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Implement bringing up secondary cores on Tegra30. This involves unpowergating
the appropriate domains enabling the CPU clocks and releasing the reset lines.

Peter De Schrijver (8):
  ARM: tegra: introduce support for reading chipid
  ARM: tegra: functions to access the flowcontroller
  ARM: tegra: rework Tegra secondary CPU core bringup
  ARM: tegra: prepare powergate.c for multiple variants
  ARM: tegra: export tegra_powergate_is_powered()
  ARM: tegra: add support for Tegra30 powerdomains
  ARM: tegra: support for Tegra30 CPU powerdomains
  ARM: tegra: support for secondary cores on Tegra30

 arch/arm/mach-tegra/Makefile                 |    2 +
 arch/arm/mach-tegra/chipid.h                 |   38 +++++
 arch/arm/mach-tegra/common.c                 |    3 +
 arch/arm/mach-tegra/flowctrl.c               |   62 ++++++++
 arch/arm/mach-tegra/flowctrl.h               |    5 +
 arch/arm/mach-tegra/headsmp.S                |  192 ++++++++++++++++++++++++-
 arch/arm/mach-tegra/include/mach/iomap.h     |    3 +
 arch/arm/mach-tegra/include/mach/powergate.h |   15 ++-
 arch/arm/mach-tegra/platsmp.c                |  139 +++++++++++++------
 arch/arm/mach-tegra/powergate.c              |   53 +++++++-
 arch/arm/mach-tegra/reset.c                  |   82 +++++++++++
 arch/arm/mach-tegra/reset.h                  |   50 +++++++
 12 files changed, 588 insertions(+), 56 deletions(-)
 create mode 100644 arch/arm/mach-tegra/chipid.h
 create mode 100644 arch/arm/mach-tegra/flowctrl.c
 create mode 100644 arch/arm/mach-tegra/reset.c
 create mode 100644 arch/arm/mach-tegra/reset.h

-- 
1.7.7.rc0.72.g4b5ea.dirty

