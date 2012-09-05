Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758577Ab2IEKBe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 06:01:34 -0400
Received: from eu1sys200aog113.obsmtp.com ([207.126.144.135]:48416 "EHLO
	eu1sys200aog113.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758410Ab2IEJ74 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 05:59:56 -0400
From: Loic Pallardy <loic.pallardy-ext@stericsson.com>
To: Samuel Ortiz <sameo@linux.intel.com>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        Linus Walleij <linus.walleij@linaro.com>
Cc: Lee Jones <lee.jones@linaro.org>, Loic Pallardy <loic.pallardy@gmail.com>,
        LT ST-Ericsson <st-ericsson@lists.linaro.org>,
        STEricsson_nomadik_linux <STEricsson_nomadik_linux@list.st.com>,
        Loic Pallardy <loic.pallardy-ext@stericsson.com>,
        Loic Pallardy <loic.pallardy@stericsson.com>
Subject: [PATCH 16/17] arm: ux500: add dbx540 prcmu platform data
Date: Wed, 5 Sep 2012 11:59:12 +0200
Message-ID: <1346839153-6465-17-git-send-email-loic.pallardy-ext@stericsson.com>
X-Mailer: git-send-email 1.7.11.1
In-Reply-To: <1346839153-6465-1-git-send-email-loic.pallardy-ext@stericsson.com>
References: <1346839153-6465-1-git-send-email-loic.pallardy-ext@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support for new dbx540-prcmu driver.

Signed-off-by: Loic Pallardy <loic.pallardy@stericsson.com>
Acked-by: Linus Walleij <linus.walleij@linaro.org>
---
 arch/arm/mach-ux500/board-mop500.c         | 12 ++++++++++++
 arch/arm/mach-ux500/cpu-db8500.c           |  7 +++++--
 arch/arm/mach-ux500/include/mach/devices.h |  3 +++
 3 files changed, 20 insertions(+), 2 deletions(-)

diff --git a/arch/arm/mach-ux500/board-mop500.c b/arch/arm/mach-ux500/board-mop500.c
index 0869c58..ed1507a 100644
--- a/arch/arm/mach-ux500/board-mop500.c
+++ b/arch/arm/mach-ux500/board-mop500.c
@@ -600,6 +600,9 @@ static void __init mop500_init_machine(void)
 
 	mop500_pinmaps_init();
 	parent = u8500_init_devices(&ab8500_platdata);
+	db8500_prcmu_device.dev.parent = parent;
+	db8500_prcmu_device.dev.platform_data = &ab8500_platdata;
+	platform_device_register(&db8500_prcmu_device);
 
 	for (i = 0; i < ARRAY_SIZE(mop500_platform_devs); i++)
 		mop500_platform_devs[i]->dev.parent = parent;
@@ -634,6 +637,9 @@ static void __init snowball_init_machine(void)
 
 	snowball_pinmaps_init();
 	parent = u8500_init_devices(&ab8500_platdata);
+	db8500_prcmu_device.dev.parent = parent;
+	db8500_prcmu_device.dev.platform_data = &ab8500_platdata;
+	platform_device_register(&db8500_prcmu_device);
 
 	for (i = 0; i < ARRAY_SIZE(snowball_platform_devs); i++)
 		snowball_platform_devs[i]->dev.parent = parent;
@@ -666,6 +672,9 @@ static void __init hrefv60_init_machine(void)
 
 	hrefv60_pinmaps_init();
 	parent = u8500_init_devices(&ab8500_platdata);
+	db8500_prcmu_device.dev.parent = parent;
+	db8500_prcmu_device.dev.platform_data = &ab8500_platdata;
+	platform_device_register(&db8500_prcmu_device);
 
 	for (i = 0; i < ARRAY_SIZE(mop500_platform_devs); i++)
 		mop500_platform_devs[i]->dev.parent = parent;
@@ -702,6 +711,9 @@ static void __init u9540_init_machine(void)
 	ccu9540_pins_init();
 
 	parent = u8500_init_devices(&ab8500_platdata);
+	dbx540_prcmu_device.dev.parent = parent;
+	dbx540_prcmu_device.dev.platform_data = &ab8500_platdata;
+	platform_device_register(&dbx540_prcmu_device);
 
 	for (i = 0; i < ARRAY_SIZE(mop500_platform_devs); i++)
 		mop500_platform_devs[i]->dev.parent = parent;
diff --git a/arch/arm/mach-ux500/cpu-db8500.c b/arch/arm/mach-ux500/cpu-db8500.c
index 59dcf82..8f74c31 100644
--- a/arch/arm/mach-ux500/cpu-db8500.c
+++ b/arch/arm/mach-ux500/cpu-db8500.c
@@ -130,7 +130,7 @@ static struct platform_device db8500_pmu_device = {
 	.dev.platform_data	= &db8500_pmu_platdata,
 };
 
-static struct platform_device db8500_prcmu_device = {
+struct platform_device db8500_prcmu_device = {
 	.name			= "db8500-prcmu",
 };
 
@@ -139,6 +139,10 @@ struct prcmu_tcdm_map db8500_tcdm_map = {
 	.legacy_offset = 0,
 };
 
+struct platform_device dbx540_prcmu_device = {
+	.name			= "dbx540-prcmu",
+};
+
 struct prcmu_tcdm_map db9540_tcdm_map = {
 	.tcdm_size = SZ_4K + SZ_8K,
 	.legacy_offset = SZ_8K,
@@ -147,7 +151,6 @@ struct prcmu_tcdm_map db9540_tcdm_map = {
 static struct platform_device *platform_devs[] __initdata = {
 	&u8500_dma40_device,
 	&db8500_pmu_device,
-	&db8500_prcmu_device,
 };
 
 static resource_size_t __initdata db8500_gpio_base[] = {
diff --git a/arch/arm/mach-ux500/include/mach/devices.h b/arch/arm/mach-ux500/include/mach/devices.h
index 1caa76e..5c4f92e 100644
--- a/arch/arm/mach-ux500/include/mach/devices.h
+++ b/arch/arm/mach-ux500/include/mach/devices.h
@@ -20,6 +20,9 @@ extern struct platform_device ux500_cryp1_device;
 extern struct platform_device u8500_dma40_device;
 extern struct platform_device ux500_ske_keypad_device;
 
+extern struct platform_device db8500_prcmu_device;
+extern struct platform_device dbx540_prcmu_device;
+
 extern struct prcmu_tcdm_map db8500_tcdm_map;
 extern struct prcmu_tcdm_map db9540_tcdm_map;
 
-- 
1.7.11.1

