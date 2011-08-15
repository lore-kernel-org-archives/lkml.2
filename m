Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753389Ab1HOU3T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Aug 2011 16:29:19 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:45057 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753267Ab1HOU3Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Aug 2011 16:29:16 -0400
From: Stephen Warren <swarren@nvidia.com>
To: Grant Likely <grant.likely@secretlab.ca>, Colin Cross <ccross@android.com>,
        Erik Gilling <konkers@android.com>, Olof Johansson <olof@lixom.net>
Cc: Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        devicetree-discuss@lists.ozlabs.org, linux-tegra@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Belisko Marek <marek.belisko@gmail.com>,
        Jamie Iles <jamie@jamieiles.com>, Shawn Guo <shawn.guo@freescale.com>,
        Sergei Shtylyov <sshtylyov@mvista.com>,
        Stephen Warren <swarren@nvidia.com>
Subject: [RFC PATCH v2 12/13] arm/tegra: board-dt: Remove dependency on non-dt pinmux functions
Date: Mon, 15 Aug 2011 14:28:19 -0600
Message-Id: <1313440100-17131-13-git-send-email-swarren@nvidia.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1313440100-17131-1-git-send-email-swarren@nvidia.com>
References: <1313440100-17131-1-git-send-email-swarren@nvidia.com>
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

