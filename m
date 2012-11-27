Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758415Ab2K0Je6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2012 04:34:58 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:56942 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758300Ab2K0Je4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2012 04:34:56 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@stericsson.com,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 1/1] ARM: ux500: Fix u9540 booting issues
Date: Tue, 27 Nov 2012 09:34:50 +0000
Message-Id: <1354008890-10476-1-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The u9540 stopped booting after the v3.7 merge window due to
a lack of common clk support and early PRCMU initialisation.
In this patch we rectify these issues, placing the u9540
development board back into a successfully booting state.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 arch/arm/mach-ux500/cpu.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/arch/arm/mach-ux500/cpu.c b/arch/arm/mach-ux500/cpu.c
index 721e7b4..d4dcec5 100644
--- a/arch/arm/mach-ux500/cpu.c
+++ b/arch/arm/mach-ux500/cpu.c
@@ -71,13 +71,11 @@ void __init ux500_init_irq(void)
 	 * Init clocks here so that they are available for system timer
 	 * initialization.
 	 */
-	if (cpu_is_u8500_family())
+	if (cpu_is_u8500_family() || cpu_is_u9540())
 		db8500_prcmu_early_init();
 
-	if (cpu_is_u8500_family())
+	if (cpu_is_u8500_family() || cpu_is_u9540())
 		u8500_clk_init();
-	else if (cpu_is_u9540())
-		u9540_clk_init();
 	else if (cpu_is_u8540())
 		u8540_clk_init();
 }
-- 
1.7.9.5

