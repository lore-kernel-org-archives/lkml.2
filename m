Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754930Ab2ITMPf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 08:15:35 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:61749 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754729Ab2ITMNt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 08:13:49 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: STEricsson_nomadik_linux@list.st.com, linus.walleij@stericsson.com,
        arnd@arndb.de, olof.johansson@gmail.com,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 26/32] ARM: ux500: Stop registering I2C sub-devices for HREF when DT is enabled
Date: Thu, 20 Sep 2012 14:12:44 +0200
Message-Id: <1348143170-2130-27-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1348143170-2130-1-git-send-email-lee.jones@linaro.org>
References: <1348143170-2130-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here we remove all calls to register I2C sub-devices from platform
code when Device Tree is enabled. Instead the I2C driver will parse
the Device Tree for them.

Acked-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 arch/arm/mach-ux500/board-mop500.c |    9 ---------
 1 file changed, 9 deletions(-)

diff --git a/arch/arm/mach-ux500/board-mop500.c b/arch/arm/mach-ux500/board-mop500.c
index 671229e..3faedf0 100644
--- a/arch/arm/mach-ux500/board-mop500.c
+++ b/arch/arm/mach-ux500/board-mop500.c
@@ -824,15 +824,6 @@ static void __init u8500_init_machine(void)
 		platform_add_devices(mop500_platform_devs,
 				ARRAY_SIZE(mop500_platform_devs));
 
-		hrefv60_sdi_init(parent);
-
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

