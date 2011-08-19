Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753738Ab1HSLw6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Aug 2011 07:52:58 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:59024 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752668Ab1HSLwp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Aug 2011 07:52:45 -0400
From: Abhilash K V <abhilash.kv@ti.com>
To: <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
CC: <tony@atomide.com>, <linux@arm.linux.org.uk>,
        Vaibhav Hiremath <hvaibhav@ti.com>, Abhilash K V <abhilash.kv@ti.com>
Subject: [PATCH 1/2] AM3517EVM: Add support for base-board MMC slot
Date: Fri, 19 Aug 2011 17:22:30 +0530
Message-ID: <1313754751-11752-2-git-send-email-abhilash.kv@ti.com>
X-Mailer: git-send-email 1.6.2.4
In-Reply-To: <1313754751-11752-1-git-send-email-abhilash.kv@ti.com>
References: <1313754751-11752-1-git-send-email-abhilash.kv@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Vaibhav Hiremath <hvaibhav@ti.com>

Signed-off-by: Vaibhav Hiremath <hvaibhav@ti.com>
Signed-off-by: Abhilash K V <abhilash.kv@ti.com>
---
 arch/arm/mach-omap2/board-am3517evm.c |   22 ++++++++++++++++++++++
 1 files changed, 22 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-omap2/board-am3517evm.c b/arch/arm/mach-omap2/board-am3517evm.c
index f3006c3..bea6da0 100644
--- a/arch/arm/mach-omap2/board-am3517evm.c
+++ b/arch/arm/mach-omap2/board-am3517evm.c
@@ -24,6 +24,7 @@
 #include <linux/i2c/pca953x.h>
 #include <linux/can/platform/ti_hecc.h>
 #include <linux/davinci_emac.h>
+#include <linux/mmc/host.h>
 
 #include <mach/hardware.h>
 #include <mach/am35xx.h>
@@ -39,6 +40,7 @@
 
 #include "mux.h"
 #include "control.h"
+#include "hsmmc.h"
 
 #define AM35XX_EVM_MDIO_FREQUENCY	(1000000)
 
@@ -460,6 +462,23 @@ static void am3517_evm_hecc_init(struct ti_hecc_platform_data *pdata)
 static struct omap_board_config_kernel am3517_evm_config[] __initdata = {
 };
 
+static struct omap2_hsmmc_info mmc[] = {
+	{
+		.mmc		= 1,
+		.caps		= MMC_CAP_4_BIT_DATA,
+		.gpio_cd	= 127,
+		.gpio_wp	= 126,
+	},
+	{
+		.mmc		= 2,
+		.caps		= MMC_CAP_4_BIT_DATA,
+		.gpio_cd	= 128,
+		.gpio_wp	= 129,
+	},
+	{}      /* Terminator */
+};
+
+
 static void __init am3517_evm_init(void)
 {
 	omap_board_config = am3517_evm_config;
@@ -487,6 +506,9 @@ static void __init am3517_evm_init(void)
 
 	/* MUSB */
 	am3517_evm_musb_init();
+
+	/* MMC init function */
+	omap2_hsmmc_init(mmc);
 }
 
 MACHINE_START(OMAP3517EVM, "OMAP3517/AM3517 EVM")
-- 
1.7.1

