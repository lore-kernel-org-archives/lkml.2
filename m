Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757031Ab1BKOjN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Feb 2011 09:39:13 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:53394 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756932Ab1BKOjJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Feb 2011 09:39:09 -0500
From: Subhasish Ghosh <subhasish@mistralsolutions.com>
To: davinci-linux-open-source@linux.davincidsp.com
Cc: linux-arm-kernel@lists.infradead.org, m-watkins@ti.com, nsekhar@ti.com,
        sachi@mistralsolutions.com,
        Subhasish Ghosh <subhasish@mistralsolutions.com>,
        Kevin Hilman <khilman@deeprootsystems.com> (supporter:TI DAVINCI
	MACHIN...),
        Russell King <linux@arm.linux.org.uk> (maintainer:ARM PORT),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v2 11/13] da850: pruss SUART board specific additions.
Date: Fri, 11 Feb 2011 20:21:30 +0530
Message-Id: <1297435892-28278-12-git-send-email-subhasish@mistralsolutions.com>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <1297435892-28278-1-git-send-email-subhasish@mistralsolutions.com>
References: <1297435892-28278-1-git-send-email-subhasish@mistralsolutions.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the pruss SUART pin mux and registers the device
with the pruss mfd driver.

Signed-off-by: Subhasish Ghosh <subhasish@mistralsolutions.com>
---
 arch/arm/mach-davinci/board-da850-evm.c |   36 +++++++++++++++++++++++++++++++
 1 files changed, 36 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-davinci/board-da850-evm.c b/arch/arm/mach-davinci/board-da850-evm.c
index f9c38f8..3858516 100644
--- a/arch/arm/mach-davinci/board-da850-evm.c
+++ b/arch/arm/mach-davinci/board-da850-evm.c
@@ -1060,6 +1060,25 @@ const short da850_evm_pruss_can_pins[] = {
 	-1
 };
 
+const short da850_evm_pruss_suart_pins[] = {
+	DA850_AHCLKX, DA850_ACLKX, DA850_AFSX,
+	DA850_AHCLKR, DA850_ACLKR, DA850_AFSR,
+	DA850_AXR_13, DA850_AXR_9, DA850_AXR_7,
+	DA850_AXR_14, DA850_AXR_10, DA850_AXR_8,
+	-1
+};
+
+static int __init da850_evm_setup_pruss_suart(void)
+{
+	int ret;
+
+	ret = davinci_cfg_reg_list(da850_evm_pruss_suart_pins);
+	if (ret)
+		pr_warning("%s: da850_evm_pruss_suart_pins "
+			"mux setup failed: %d\n", __func__, ret);
+	return ret;
+}
+
 static int __init da850_evm_setup_pruss_can(void)
 {
 	int ret, val = 0;
@@ -1085,6 +1104,17 @@ static int __init da850_evm_setup_pruss_can(void)
 	return ret;
 }
 
+static struct da850_evm_pruss_suart_data suart_data = {
+	.version	= 1,
+	.resource	= {
+			.name	= "da8xx_mcasp0_iomem",
+			.start	= DAVINCI_DA8XX_MCASP0_REG_BASE,
+			.end	= DAVINCI_DA8XX_MCASP0_REG_BASE +
+					(SZ_1K * 12) - 1,
+			.flags	= IORESOURCE_MEM,
+		},
+};
+
 static struct da8xx_pruss_can_data can_data = {
 	.version	= 1,
 };
@@ -1094,6 +1124,12 @@ static struct da8xx_pruss_devices pruss_devices[] = {
 		.dev_name	= "da8xx_pruss_can",
 		.pdata		= &can_data,
 		.pdata_size	= sizeof(can_data),
+		.setup		= da850_evm_setup_pruss_suart,
+	},
+	{
+		.dev_name	= "da8xx_pruss_uart",
+		.pdata		= &suart_data,
+		.pdata_size	= sizeof(suart_data),
 		.setup		= da850_evm_setup_pruss_can,
 	},
 	{
-- 
1.7.2.3

