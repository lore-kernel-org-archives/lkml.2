Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754059Ab2BWQWN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Feb 2012 11:22:13 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:5416 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751654Ab2BWQWM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Feb 2012 11:22:12 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Thu, 23 Feb 2012 08:22:12 -0800
From: Peter De Schrijver <pdeschrijver@nvidia.com>
To: Peter De Schrijver <pdeschrijver@nvidia.com>
Cc: Colin Cross <ccross@android.com>, Olof Johansson <olof@lixom.net>,
        Stephen Warren <swarren@nvidia.com>,
        Russell King <linux@arm.linux.org.uk>, linux-tegra@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH] ARM: tegra: Avoid compiling cpuidle code when not configured
Date: Thu, 23 Feb 2012 18:21:52 +0200
Message-Id: <1330014112-26203-1-git-send-email-pdeschrijver@nvidia.com>
X-Mailer: git-send-email 1.7.7.rc0.72.g4b5ea.dirty
X-NVConfidentiality: public
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No need to compile cpuidle.c and sleep.S if cpuidle isn't configured in the
kernel.

Signed-off-by: Peter De Schrijver <pdeschrijver@nvidia.com>
---
 arch/arm/mach-tegra/Makefile |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/mach-tegra/Makefile b/arch/arm/mach-tegra/Makefile
index 82994c0..d4c1a6b 100644
--- a/arch/arm/mach-tegra/Makefile
+++ b/arch/arm/mach-tegra/Makefile
@@ -7,8 +7,8 @@ obj-y                                   += clock.o
 obj-y                                   += timer.o
 obj-y                                   += pinmux.o
 obj-y					+= fuse.o
-obj-y					+= cpuidle.o
-obj-y					+= sleep.o
+obj-$(CONFIG_CPU_IDLE)			+= cpuidle.o
+obj-$(CONFIG_CPU_IDLE)			+= sleep.o
 obj-y					+= pmc.o
 obj-$(CONFIG_ARCH_TEGRA_2x_SOC)		+= powergate.o
 obj-$(CONFIG_ARCH_TEGRA_2x_SOC)         += tegra2_clocks.o
-- 
1.7.7.rc0.72.g4b5ea.dirty

