Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753329Ab1BVCnL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Feb 2011 21:43:11 -0500
Received: from smtp-out.google.com ([216.239.44.51]:62608 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751571Ab1BVCl0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Feb 2011 21:41:26 -0500
From: Colin Cross <ccross@android.com>
To: linux-tegra@vger.kernel.org
Cc: konkers@android.com, olof@lixom.net, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, mike@compulab.co.il,
        Colin Cross <ccross@android.com>,
        Russell King <linux@arm.linux.org.uk>
Subject: [PATCH 4/7] ARM: tegra: Move tegra_common_init to tegra_init_early
Date: Mon, 21 Feb 2011 18:39:49 -0800
Message-Id: <1298342392-21236-5-git-send-email-ccross@android.com>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1298342392-21236-1-git-send-email-ccross@android.com>
References: <1298342392-21236-1-git-send-email-ccross@android.com>
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move tegra_common_init to tegra_init_early, and set it
as the init_early entry in the machine struct.
Initializes the clocks earlier so that timers can enable
their clocks.

Also reorders the members in the Harmony and Trimslice
boards' machine structs to match the order they are
called in.

Signed-off-by: Colin Cross <ccross@android.com>
---
 arch/arm/mach-tegra/board-harmony.c   |    7 +++----
 arch/arm/mach-tegra/board-trimslice.c |    7 +++----
 arch/arm/mach-tegra/board.h           |    2 +-
 arch/arm/mach-tegra/common.c          |    2 +-
 4 files changed, 8 insertions(+), 10 deletions(-)

diff --git a/arch/arm/mach-tegra/board-harmony.c b/arch/arm/mach-tegra/board-harmony.c
index b9dbdb1..368ddff 100644
--- a/arch/arm/mach-tegra/board-harmony.c
+++ b/arch/arm/mach-tegra/board-harmony.c
@@ -104,8 +104,6 @@ static __initdata struct tegra_clk_init_table harmony_clk_init_table[] = {
 
 static void __init tegra_harmony_init(void)
 {
-	tegra_common_init();
-
 	tegra_clk_init_from_table(harmony_clk_init_table);
 
 	harmony_pinmux_init();
@@ -116,8 +114,9 @@ static void __init tegra_harmony_init(void)
 MACHINE_START(HARMONY, "harmony")
 	.boot_params  = 0x00000100,
 	.fixup		= tegra_harmony_fixup,
-	.init_irq       = tegra_init_irq,
-	.init_machine   = tegra_harmony_init,
 	.map_io         = tegra_map_common_io,
+	.init_early	= tegra_init_early,
+	.init_irq       = tegra_init_irq,
 	.timer          = &tegra_timer,
+	.init_machine   = tegra_harmony_init,
 MACHINE_END
diff --git a/arch/arm/mach-tegra/board-trimslice.c b/arch/arm/mach-tegra/board-trimslice.c
index ef233b2..0f3081a 100644
--- a/arch/arm/mach-tegra/board-trimslice.c
+++ b/arch/arm/mach-tegra/board-trimslice.c
@@ -85,8 +85,6 @@ subsys_initcall(tegra_trimslice_pci_init);
 
 static void __init tegra_trimslice_init(void)
 {
-	tegra_common_init();
-
 	tegra_clk_init_from_table(trimslice_clk_init_table);
 
 	trimslice_pinmux_init();
@@ -97,8 +95,9 @@ static void __init tegra_trimslice_init(void)
 MACHINE_START(TRIMSLICE, "trimslice")
 	.boot_params	= 0x00000100,
 	.fixup		= tegra_trimslice_fixup,
-	.init_irq       = tegra_init_irq,
-	.init_machine   = tegra_trimslice_init,
 	.map_io         = tegra_map_common_io,
+	.init_early	= tegra_init_early,
+	.init_irq       = tegra_init_irq,
 	.timer          = &tegra_timer,
+	.init_machine   = tegra_trimslice_init,
 MACHINE_END
diff --git a/arch/arm/mach-tegra/board.h b/arch/arm/mach-tegra/board.h
index b3f9c94..1d14df7 100644
--- a/arch/arm/mach-tegra/board.h
+++ b/arch/arm/mach-tegra/board.h
@@ -25,7 +25,7 @@
 
 void tegra_assert_system_reset(char mode, const char *cmd);
 
-void __init tegra_common_init(void);
+void __init tegra_init_early(void);
 void __init tegra_map_common_io(void);
 void __init tegra_init_irq(void);
 void __init tegra_init_clock(void);
diff --git a/arch/arm/mach-tegra/common.c b/arch/arm/mach-tegra/common.c
index 54826b8..14fa533 100644
--- a/arch/arm/mach-tegra/common.c
+++ b/arch/arm/mach-tegra/common.c
@@ -72,7 +72,7 @@ void __init tegra_init_cache(void)
 
 }
 
-void __init tegra_common_init(void)
+void __init tegra_init_early(void)
 {
 	tegra_init_fuse();
 	tegra_init_clock();
-- 
1.7.3.1

