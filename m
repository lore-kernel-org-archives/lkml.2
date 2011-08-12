Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753354Ab1HLIa3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Aug 2011 04:30:29 -0400
Received: from eu1sys200aog110.obsmtp.com ([207.126.144.129]:44351 "EHLO
	eu1sys200aog110.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751317Ab1HLIaZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Aug 2011 04:30:25 -0400
From: Linus Walleij <linus.walleij@stericsson.com>
To: Samuel Ortiz <sameo@linux.intel.com>, <linux-kernel@vger.kernel.org>
Cc: Lee Jones <lee.jones@linaro.org>, Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 15/23] mfd/db5500-prcmu: convert to platform device
Date: Fri, 12 Aug 2011 10:29:37 +0200
Message-ID: <1313137777-31081-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.7.3.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Walleij <linus.walleij@linaro.org>

This converts the DB5500 PRCMU driver to become a platform
device just like the DB8500 PRCMU driver.

Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 arch/arm/mach-ux500/cpu-db5500.c |    5 +++++
 drivers/mfd/db5500-prcmu.c       |   15 ++++++++++++++-
 2 files changed, 19 insertions(+), 1 deletions(-)

diff --git a/arch/arm/mach-ux500/cpu-db5500.c b/arch/arm/mach-ux500/cpu-db5500.c
index 22705d2..e532c32 100644
--- a/arch/arm/mach-ux500/cpu-db5500.c
+++ b/arch/arm/mach-ux500/cpu-db5500.c
@@ -151,11 +151,16 @@ static struct platform_device mbox2_device = {
 	.num_resources = ARRAY_SIZE(mbox2_resources),
 };
 
+static struct platform_device db5500_prcmu_device = {
+	.name			= "db5500-prcmu",
+};
+
 static struct platform_device *db5500_platform_devs[] __initdata = {
 	&db5500_pmu_device,
 	&mbox0_device,
 	&mbox1_device,
 	&mbox2_device,
+	&db5500_prcmu_device,
 };
 
 static resource_size_t __initdata db5500_gpio_base[] = {
diff --git a/drivers/mfd/db5500-prcmu.c b/drivers/mfd/db5500-prcmu.c
index 2762cfa..5550ac9 100644
--- a/drivers/mfd/db5500-prcmu.c
+++ b/drivers/mfd/db5500-prcmu.c
@@ -19,6 +19,7 @@
 #include <linux/irq.h>
 #include <linux/jiffies.h>
 #include <linux/bitops.h>
+#include <linux/platform_device.h>
 #include <linux/interrupt.h>
 #include <linux/mfd/dbx500-prcmu.h>
 #include <mach/hardware.h>
@@ -894,7 +895,7 @@ void __init db5500_prcmu_early_init(void)
  * prcmu_fw_init - arch init call for the Linux PRCMU fw init logic
  *
  */
-int __init db5500_prcmu_init(void)
+static int __init db5500_prcmu_probe(struct platform_device *pdev)
 {
 	int err = 0;
 
@@ -917,4 +918,16 @@ no_irq_return:
 
 }
 
+static struct platform_driver db5500_prcmu_driver = {
+	.driver = {
+		.name = "db5500-prcmu",
+		.owner = THIS_MODULE,
+	},
+};
+
+static int __init db5500_prcmu_init(void)
+{
+	return platform_driver_probe(&db5500_prcmu_driver, db5500_prcmu_probe);
+}
+
 arch_initcall(db5500_prcmu_init);
-- 
1.7.3.2

