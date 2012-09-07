Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760481Ab2IGLPq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 07:15:46 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:41152 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760413Ab2IGLPe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 07:15:34 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: STEricsson_nomadik_linux@list.st.com, linus.walleij@stericsson.com,
        arnd@arndb.de, Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 13/19] ARM: ux500: Stop registering I2C sub-devices for HREF when DT is enabled
Date: Fri,  7 Sep 2012 12:14:53 +0100
Message-Id: <1347016499-29354-14-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1347016499-29354-1-git-send-email-lee.jones@linaro.org>
References: <1347016499-29354-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here we remove all calls to register I2C sub-devices from platform
code when Device Tree is enabled. Instead the I2C driver will parse
the Device Tree for them.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 arch/arm/mach-ux500/board-mop500.c |    7 -------
 1 file changed, 7 deletions(-)

diff --git a/arch/arm/mach-ux500/board-mop500.c b/arch/arm/mach-ux500/board-mop500.c
index 0219c276..181ed25 100644
--- a/arch/arm/mach-ux500/board-mop500.c
+++ b/arch/arm/mach-ux500/board-mop500.c
@@ -840,13 +840,6 @@ static void __init u8500_init_machine(void)
 		platform_add_devices(mop500_platform_devs,
 				ARRAY_SIZE(mop500_platform_devs));
 
-		i2c0_devs = ARRAY_SIZE(mop500_i2c0_devices);
-		i2c0_devs -= NUM_PRE_V60_I2C0_DEVICES;
-
-		i2c_register_board_info(0, mop500_i2c0_devices, i2c0_devs);
-		i2c_register_board_info(2, mop500_i2c2_devices,
-					ARRAY_SIZE(mop500_i2c2_devices));
-
 		mop500_uib_init();
 	}
 
-- 
1.7.9.5

