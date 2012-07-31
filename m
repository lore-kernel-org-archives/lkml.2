Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754777Ab2GaOq7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2012 10:46:59 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:34763 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754664Ab2GaOqJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2012 10:46:09 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: STEricsson_nomadik_linux@list.st.com, linus.walleij@stericsson.com,
        arnd@arndb.de, olalilja@yahoo.se, ola.o.lilja@stericsson.com,
        alsa-devel@alsa-project.org, broonie@opensource.wolfsonmicro.com,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 5/5] ARM: ux500: Ensure probing of Audio devices when Device Tree is enabled
Date: Tue, 31 Jul 2012 15:45:44 +0100
Message-Id: <1343745944-18418-6-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1343745944-18418-1-git-send-email-lee.jones@linaro.org>
References: <1343745944-18418-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Previous attempts to add platform probing of the Audio related devices
only call from non-DT initialisation functions. This patch extends that
functionality to the Device Tree related ones too.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 arch/arm/mach-ux500/board-mop500.c |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/arm/mach-ux500/board-mop500.c b/arch/arm/mach-ux500/board-mop500.c
index e641003..87a5cd7 100644
--- a/arch/arm/mach-ux500/board-mop500.c
+++ b/arch/arm/mach-ux500/board-mop500.c
@@ -794,6 +794,7 @@ static void __init u8500_init_machine(void)
 				ARRAY_SIZE(mop500_platform_devs));
 
 		mop500_sdi_init(parent);
+		mop500_msp_init(parent);
 		i2c0_devs = ARRAY_SIZE(mop500_i2c0_devices);
 		i2c_register_board_info(0, mop500_i2c0_devices, i2c0_devs);
 		i2c_register_board_info(2, mop500_i2c2_devices,
@@ -801,6 +802,8 @@ static void __init u8500_init_machine(void)
 
 		mop500_uib_init();
 
+	} else if (of_machine_is_compatible("calaosystems,snowball-a9500")) {
+		mop500_of_msp_init(parent);
 	} else if (of_machine_is_compatible("st-ericsson,hrefv60+")) {
 		/*
 		 * The HREFv60 board removed a GPIO expander and routed
@@ -812,6 +815,7 @@ static void __init u8500_init_machine(void)
 				ARRAY_SIZE(mop500_platform_devs));
 
 		hrefv60_sdi_init(parent);
+		mop500_msp_init(parent);
 
 		i2c0_devs = ARRAY_SIZE(mop500_i2c0_devices);
 		i2c0_devs -= NUM_PRE_V60_I2C0_DEVICES;
-- 
1.7.9.5

