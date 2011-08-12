Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753455Ab1HLWz7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Aug 2011 18:55:59 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:57807 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752827Ab1HLWz1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Aug 2011 18:55:27 -0400
From: Stephen Warren <swarren@nvidia.com>
To: Grant Likely <grant.likely@secretlab.ca>, Colin Cross <ccross@android.com>,
        Erik Gilling <konkers@android.com>, Olof Johansson <olof@lixom.net>
Cc: Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        devicetree-discuss@lists.ozlabs.org, linux-tegra@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Stephen Warren <swarren@nvidia.com>
Subject: [RFC PATCH 11/12] arm/tegra: board-dt: Remove dependency on non-dt pinmux functions
Date: Fri, 12 Aug 2011 16:54:56 -0600
Message-Id: <1313189697-21287-12-git-send-email-swarren@nvidia.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1313189697-21287-1-git-send-email-swarren@nvidia.com>
References: <1313189697-21287-1-git-send-email-swarren@nvidia.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Stephen Warren <swarren@nvidia.com>
---
 arch/arm/mach-tegra/Makefile   |    1 -
 arch/arm/mach-tegra/board-dt.c |   10 ----------
 2 files changed, 0 insertions(+), 11 deletions(-)

diff --git a/arch/arm/mach-tegra/Makefile b/arch/arm/mach-tegra/Makefile
index f11b910..bab6544 100644
--- a/arch/arm/mach-tegra/Makefile
+++ b/arch/arm/mach-tegra/Makefile
@@ -30,7 +30,6 @@ obj-${CONFIG_MACH_SEABOARD}             += board-seaboard.o
 obj-${CONFIG_MACH_SEABOARD}             += board-seaboard-pinmux.o
 
 obj-${CONFIG_MACH_TEGRA_DT}             += board-dt.o
-obj-${CONFIG_MACH_TEGRA_DT}             += board-harmony-pinmux.o
 
 obj-${CONFIG_MACH_TRIMSLICE}            += board-trimslice.o
 obj-${CONFIG_MACH_TRIMSLICE}            += board-trimslice-pinmux.o
diff --git a/arch/arm/mach-tegra/board-dt.c b/arch/arm/mach-tegra/board-dt.c
index 1995b79..06e82c4 100644
--- a/arch/arm/mach-tegra/board-dt.c
+++ b/arch/arm/mach-tegra/board-dt.c
@@ -41,14 +41,9 @@
 #include <mach/irqs.h>
 
 #include "board.h"
-#include "board-harmony.h"
 #include "clock.h"
 #include "devices.h"
 
-void harmony_pinmux_init(void);
-void seaboard_pinmux_init(void);
-
-
 struct of_dev_auxdata tegra20_auxdata_lookup[] __initdata = {
 	OF_DEV_AUXDATA("nvidia,tegra20-gpio", TEGRA_GPIO_BASE, "tegra-gpio", NULL),
 	OF_DEV_AUXDATA("nvidia,tegra20-pinmux", TEGRA_APB_MISC_BASE, "tegra-pinmux", NULL),
@@ -93,11 +88,6 @@ static void __init tegra_dt_init(void)
 
 	tegra_clk_init_from_table(tegra_dt_clk_init_table);
 
-	if (of_machine_is_compatible("nvidia,harmony"))
-		harmony_pinmux_init();
-	else if (of_machine_is_compatible("nvidia,seaboard"))
-		seaboard_pinmux_init();
-
 	/*
 	 * Finished with the static registrations now; fill in the missing
 	 * devices
-- 
1.7.0.4

