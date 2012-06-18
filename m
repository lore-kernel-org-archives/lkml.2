Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751223Ab2FRLLi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 07:11:38 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:52959 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750786Ab2FRLLh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 07:11:37 -0400
From: Michal Simek <monstr@monstr.eu>
To: linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, John.Linn@xilinx.com, linux@arm.linux.org.uk,
        linux-arm-kernel@lists.infradead.org, Michal Simek <monstr@monstr.eu>
Subject: [PATCH] arm: zynq: Support GIC OF initialization
Date: Mon, 18 Jun 2012 13:11:13 +0200
Message-Id: <1340017873-18170-1-git-send-email-monstr@monstr.eu>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Zynq is OF driven platfrom which requires OF initialization.

Signed-off-by: Michal Simek <monstr@monstr.eu>
---
 arch/arm/mach-zynq/common.c |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/arch/arm/mach-zynq/common.c b/arch/arm/mach-zynq/common.c
index 17d68d6..7941544 100644
--- a/arch/arm/mach-zynq/common.c
+++ b/arch/arm/mach-zynq/common.c
@@ -56,12 +56,17 @@ static void __init xilinx_init_machine(void)
 	of_platform_bus_probe(NULL, zynq_of_bus_ids, NULL);
 }
 
+static const struct of_device_id zynq_dt_irq_match[] __initconst = {
+	{ .compatible = "arm,cortex-a9-gic", .data = gic_of_init },
+	{ }
+};
+
 /**
  * xilinx_irq_init() - Interrupt controller initialization for the GIC.
  */
 static void __init xilinx_irq_init(void)
 {
-	gic_init(0, 29, SCU_GIC_DIST_BASE, SCU_GIC_CPU_BASE);
+	of_irq_init(zynq_dt_irq_match);
 }
 
 /* The minimum devices needed to be mapped before the VM system is up and
-- 
1.7.0.4

