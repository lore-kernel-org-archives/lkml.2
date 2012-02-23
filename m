Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754117Ab2BWQVY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Feb 2012 11:21:24 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:18181 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751654Ab2BWQVW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Feb 2012 11:21:22 -0500
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Thu, 23 Feb 2012 08:21:21 -0800
From: Peter De Schrijver <pdeschrijver@nvidia.com>
To: Peter De Schrijver <pdeschrijver@nvidia.com>
Cc: Colin Cross <ccross@android.com>, Olof Johansson <olof@lixom.net>,
        Stephen Warren <swarren@nvidia.com>,
        Russell King <linux@arm.linux.org.uk>, linux-tegra@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH] ARM: tegra: Enable CPUIdle on Tegra20
Date: Thu, 23 Feb 2012 18:20:56 +0200
Message-Id: <1330014056-26125-1-git-send-email-pdeschrijver@nvidia.com>
X-Mailer: git-send-email 1.7.7.rc0.72.g4b5ea.dirty
X-NVConfidentiality: public
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As the LP3 code also works for Tegra20, we can enable cpuidle for Tegra20.

Signed-off-by: Peter De Schrijver <pdeschrijver@nvidia.com>

---
Tested on Tegra2 Ventana,
/sys/devices/system/cpu/cpu[0-1]/cpuidle/state0/usage increments over time
and the system is stable.

---
 arch/arm/mach-tegra/common.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/arch/arm/mach-tegra/common.c b/arch/arm/mach-tegra/common.c
index e2a2c1f..2f86fcc 100644
--- a/arch/arm/mach-tegra/common.c
+++ b/arch/arm/mach-tegra/common.c
@@ -113,8 +113,6 @@ static void __init tegra_init_cache(u32 tag_latency, u32 data_latency)
 #ifdef CONFIG_ARCH_TEGRA_2x_SOC
 void __init tegra20_init_early(void)
 {
-	disable_hlt();  /* idle WFI usage needs to be confirmed */
-
 	tegra_init_fuse();
 	tegra2_init_clocks();
 	tegra_clk_init_from_table(tegra20_clk_init_table);
-- 
1.7.7.rc0.72.g4b5ea.dirty

