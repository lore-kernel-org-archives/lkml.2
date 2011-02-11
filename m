Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756915Ab1BKOij (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Feb 2011 09:38:39 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:50098 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755286Ab1BKOih (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Feb 2011 09:38:37 -0500
From: Subhasish Ghosh <subhasish@mistralsolutions.com>
To: davinci-linux-open-source@linux.davincidsp.com
Cc: linux-arm-kernel@lists.infradead.org, m-watkins@ti.com, nsekhar@ti.com,
        sachi@mistralsolutions.com,
        Subhasish Ghosh <subhasish@mistralsolutions.com>,
        Kevin Hilman <khilman@deeprootsystems.com> (supporter:TI DAVINCI
	MACHIN...),
        Russell King <linux@arm.linux.org.uk> (maintainer:ARM PORT),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v2 08/13] da850: pruss CAN board specific changes for gpios.
Date: Fri, 11 Feb 2011 20:21:27 +0530
Message-Id: <1297435892-28278-9-git-send-email-subhasish@mistralsolutions.com>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <1297435892-28278-1-git-send-email-subhasish@mistralsolutions.com>
References: <1297435892-28278-1-git-send-email-subhasish@mistralsolutions.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the GPIO modifications required for the pruss CAN.

Signed-off-by: Subhasish Ghosh <subhasish@mistralsolutions.com>
---
 arch/arm/mach-davinci/board-da850-evm.c |   11 ++++++++++-
 1 files changed, 10 insertions(+), 1 deletions(-)

diff --git a/arch/arm/mach-davinci/board-da850-evm.c b/arch/arm/mach-davinci/board-da850-evm.c
index 2ce5536..f9c38f8 100644
--- a/arch/arm/mach-davinci/board-da850-evm.c
+++ b/arch/arm/mach-davinci/board-da850-evm.c
@@ -45,6 +45,7 @@
 
 #define DA850_MMCSD_CD_PIN		GPIO_TO_PIN(4, 0)
 #define DA850_MMCSD_WP_PIN		GPIO_TO_PIN(4, 1)
+#define DA850_PRUSS_CAN_TRX_PIN	GPIO_TO_PIN(2, 0)
 
 #define DA850_MII_MDIO_CLKEN_PIN	GPIO_TO_PIN(2, 6)
 
@@ -1055,7 +1056,7 @@ static __init int da850_evm_init_cpufreq(void) { return 0; }
 
 const short da850_evm_pruss_can_pins[] = {
 	DA850_PRUSS_PRU0_R31_0, DA850_PRUSS_PRU1_R30_15,
-	DA850_PRUSS_PRU1_R31_18,
+	DA850_PRUSS_PRU1_R31_18, DA850_GPIO2_0,
 	-1
 };
 
@@ -1073,6 +1074,14 @@ static int __init da850_evm_setup_pruss_can(void)
 	val |= BIT(3);
 	__raw_writel(val, cfg_chip3_reg);
 
+	/* value = 0 to enable the CAN transceiver */
+	ret = gpio_request_one(DA850_PRUSS_CAN_TRX_PIN,
+					GPIOF_OUT_INIT_LOW, "pruss_can_en");
+	if (ret) {
+		pr_warning("Cannot setup GPIO %d\n", DA850_PRUSS_CAN_TRX_PIN);
+		gpio_free(DA850_PRUSS_CAN_TRX_PIN);
+	}
+
 	return ret;
 }
 
-- 
1.7.2.3

