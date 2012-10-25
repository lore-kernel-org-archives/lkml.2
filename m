Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422820Ab2JYJ5a (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 05:57:30 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:64740 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422723Ab2JYJ51 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 05:57:27 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@stericsson.com,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 3/8] ARM: ux500: Remove duplicate DT_MACHINE_START - make u8500 for generic
Date: Thu, 25 Oct 2012 10:57:06 +0100
Message-Id: <1351159031-25391-4-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1351159031-25391-1-git-send-email-lee.jones@linaro.org>
References: <1351159031-25391-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The u8500 and u9540 DT_MACHINE_START calls are almost identical
at the moment, referencing exactly the same function pointers.
Until this changes we may as well convert the original one to
be more generic and use that instead.

Acked-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 arch/arm/mach-ux500/cpu-db8500.c |   12 +-----------
 1 file changed, 1 insertion(+), 11 deletions(-)

diff --git a/arch/arm/mach-ux500/cpu-db8500.c b/arch/arm/mach-ux500/cpu-db8500.c
index 6e9a06d..472b49f 100644
--- a/arch/arm/mach-ux500/cpu-db8500.c
+++ b/arch/arm/mach-ux500/cpu-db8500.c
@@ -338,7 +338,7 @@ static const char * u8500_dt_board_compat[] = {
 	NULL,
 };
 
-DT_MACHINE_START(U8500_DT, "ST-Ericsson U8500 platform (Device Tree Support)")
+DT_MACHINE_START(U8500_DT, "ST-Ericsson Ux5x0 platform (Device Tree Support)")
 	.map_io		= u8500_map_io,
 	.init_irq	= ux500_init_irq,
 	/* we re-use nomadik timer here */
@@ -349,14 +349,4 @@ DT_MACHINE_START(U8500_DT, "ST-Ericsson U8500 platform (Device Tree Support)")
 	.dt_compat      = u8500_dt_board_compat,
 MACHINE_END
 
-DT_MACHINE_START(U9540_DT, "ST-Ericsson 9540 platform (Device Tree Support)")
-	.map_io		= u8500_map_io,
-	.init_irq	= ux500_init_irq,
-	.timer		= &ux500_timer,
-	.handle_irq	= gic_handle_irq,
-	.init_machine	= u8500_init_machine,
-	.init_late	= NULL,
-	.dt_compat      = u8500_dt_board_compat,
-MACHINE_END
-
 #endif
-- 
1.7.9.5

