Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753100Ab1CJQj3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 11:39:29 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:60193 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752014Ab1CJQj2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 11:39:28 -0500
From: Abhilash K V <abhilash.kv@ti.com>
To: linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Cc: tony@atomide.com, linux@arm.linux.org.uk,
        Abhilash K V <abhilash.kv@ti.com>, Sriramakrishnan <srk@ti.com>
Subject: [PATCH] can : AM3517EVM : add platform specific init
Date: Thu, 10 Mar 2011 22:09:13 +0530
Message-Id: <1299775153-16766-1-git-send-email-abhilash.kv@ti.com>
X-Mailer: git-send-email 1.6.2.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CAN module on AM3517 requires programming of IO expander
as part of init sequence. Added transceiver_switch
callback to handle this.

Signed-off-by: Sriramakrishnan <srk@ti.com>
Reviewed-by:  Vaibhav Hiremath <hvaibhav@ti.com>
Signed-off-by: Abhilash K V <abhilash.kv@ti.com>
---
 arch/arm/mach-omap2/board-am3517evm.c |   18 ++++++++++++++++++
 1 files changed, 18 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-omap2/board-am3517evm.c b/arch/arm/mach-omap2/board-am3517evm.c
index 2e4aad2..782d72d 100644
--- a/arch/arm/mach-omap2/board-am3517evm.c
+++ b/arch/arm/mach-omap2/board-am3517evm.c
@@ -734,6 +734,23 @@ static struct omap_board_mux board_mux[] __initdata = {
 };
 #endif
 
+/*
+ * HECC information
+ */
+
+#define CAN_STB         214
+static void hecc_phy_control(int on)
+{
+        int r;
+
+        r = gpio_request(CAN_STB, "can_stb");
+        if (r) {
+                printk(KERN_ERR "failed to get can_stb \n");
+                return;
+        }
+
+        gpio_direction_output(CAN_STB, (on==1)?0:1);
+}
 
 static struct resource am3517_hecc_resources[] = {
 	{
@@ -762,6 +779,7 @@ static struct ti_hecc_platform_data am3517_evm_hecc_pdata = {
 	.mbx_offset		= AM35XX_HECC_MBOX_OFFSET,
 	.int_line		= AM35XX_HECC_INT_LINE,
 	.version		= AM35XX_HECC_VERSION,
+	.transceiver_switch     = hecc_phy_control,
 };
 
 static void am3517_evm_hecc_init(struct ti_hecc_platform_data *pdata)
-- 
1.6.2.4

