Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753471Ab2JPKK1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 06:10:27 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:4331 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751539Ab2JPKKY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 06:10:24 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Tue, 16 Oct 2012 02:58:45 -0700
From: Sivaram Nair <sivaramn@nvidia.com>
To: <swarren@wwwdotorg.org>, <linux@arm.linux.org.uk>,
        <linux-tegra@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
CC: <linux-kernel@vger.kernel.org>, <sivaramn@nvidia.com>
Subject: [PATCH 1/2] ARM: tegra: rename tegra system timer
Date: Tue, 16 Oct 2012 13:08:35 +0300
Message-ID: <1350382116-18024-2-git-send-email-sivaramn@nvidia.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1350382116-18024-1-git-send-email-sivaramn@nvidia.com>
References: <1350382116-18024-1-git-send-email-sivaramn@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sivaram Nair <sivaramn@nvidia.com>

The timer variable is renamed to avoid confusion and symbol name clash
with the tegra_timer clock.

Signed-off-by: Sivaram Nair <sivaramn@nvidia.com>
---
 arch/arm/mach-tegra/board-dt-tegra20.c |    2 +-
 arch/arm/mach-tegra/board-dt-tegra30.c |    2 +-
 arch/arm/mach-tegra/board.h            |    2 +-
 arch/arm/mach-tegra/timer.c            |    2 +-
 4 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/arm/mach-tegra/board-dt-tegra20.c b/arch/arm/mach-tegra/board-dt-tegra20.c
index 57e235f..aa5325c 100644
--- a/arch/arm/mach-tegra/board-dt-tegra20.c
+++ b/arch/arm/mach-tegra/board-dt-tegra20.c
@@ -182,7 +182,7 @@ DT_MACHINE_START(TEGRA_DT, "nVidia Tegra20 (Flattened Device Tree)")
 	.init_early	= tegra20_init_early,
 	.init_irq	= tegra_dt_init_irq,
 	.handle_irq	= gic_handle_irq,
-	.timer		= &tegra_timer,
+	.timer		= &tegra_sys_timer,
 	.init_machine	= tegra_dt_init,
 	.init_late	= tegra_dt_init_late,
 	.restart	= tegra_assert_system_reset,
diff --git a/arch/arm/mach-tegra/board-dt-tegra30.c b/arch/arm/mach-tegra/board-dt-tegra30.c
index e4a676d..5e92a81 100644
--- a/arch/arm/mach-tegra/board-dt-tegra30.c
+++ b/arch/arm/mach-tegra/board-dt-tegra30.c
@@ -89,7 +89,7 @@ DT_MACHINE_START(TEGRA30_DT, "NVIDIA Tegra30 (Flattened Device Tree)")
 	.init_early	= tegra30_init_early,
 	.init_irq	= tegra_dt_init_irq,
 	.handle_irq	= gic_handle_irq,
-	.timer		= &tegra_timer,
+	.timer		= &tegra_sys_timer,
 	.init_machine	= tegra30_dt_init,
 	.init_late	= tegra_init_late,
 	.restart	= tegra_assert_system_reset,
diff --git a/arch/arm/mach-tegra/board.h b/arch/arm/mach-tegra/board.h
index f88e514..91fbe73 100644
--- a/arch/arm/mach-tegra/board.h
+++ b/arch/arm/mach-tegra/board.h
@@ -55,5 +55,5 @@ static inline int harmony_pcie_init(void) { return 0; }
 
 void __init tegra_paz00_wifikill_init(void);
 
-extern struct sys_timer tegra_timer;
+extern struct sys_timer tegra_sys_timer;
 #endif
diff --git a/arch/arm/mach-tegra/timer.c b/arch/arm/mach-tegra/timer.c
index eccdce9..d3b8c8e 100644
--- a/arch/arm/mach-tegra/timer.c
+++ b/arch/arm/mach-tegra/timer.c
@@ -245,7 +245,7 @@ static void __init tegra_init_timer(void)
 	register_persistent_clock(NULL, tegra_read_persistent_clock);
 }
 
-struct sys_timer tegra_timer = {
+struct sys_timer tegra_sys_timer = {
 	.init = tegra_init_timer,
 };
 
-- 
1.7.0.4

