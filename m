Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753003Ab1ARG7B (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jan 2011 01:59:01 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:55478 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751823Ab1ARG7A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jan 2011 01:59:00 -0500
From: Thomas Weber <weber@corscience.de>
To: linux-omap@vger.kernel.org
Cc: Daniel Morsing <daniel.morsing@gmail.com>,
        Tony Lindgren <tony@atomide.com>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Thomas Weber <weber@corscience.de>
Subject: [PATCHv3 2/2] OMAP3: Devkit8000: Fix tps65930 pullup/pulldown configuration
Date: Tue, 18 Jan 2011 07:58:52 +0100
Message-Id: <1295333932-23935-3-git-send-email-weber@corscience.de>
X-Mailer: git-send-email 1.7.4.rc2
In-Reply-To: <1295333932-23935-1-git-send-email-weber@corscience.de>
References: <1295333932-23935-1-git-send-email-weber@corscience.de>
X-Provags-ID: V02:K0:8hwXFYSSUONOT+Bpo6MeRWn6TWmUa940GDpfwLX7oit
 x37Frdn5dz1LJTpoQZzax7HHfmDQE+dwblKmcW2i5KEPsZV9a5
 SWH0wn1JuO3jaeX6sHuZBuiCmLGLKD6Og3ZJQFCmpkRGopm3cx
 YsBdecTyg38OX3chOrU0SHO91EHEfZVSnWQkPT9w16DJfMiUdR
 ksY5O9xRYVeYx7LnBGLig==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Daniel Morsing <daniel.morsing@gmail.com>

gpio7 on the tps65930 is used as an output on the devkit8000 and
gpio1 is not connected. Remove gpio7 and change gpio1 to pulldown

Signed-off-by: Daniel Morsing <daniel.morsing@gmail.com>
---
 arch/arm/mach-omap2/board-devkit8000.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/arch/arm/mach-omap2/board-devkit8000.c b/arch/arm/mach-omap2/board-devkit8000.c
index 719f4e5..9fb416b 100644
--- a/arch/arm/mach-omap2/board-devkit8000.c
+++ b/arch/arm/mach-omap2/board-devkit8000.c
@@ -262,8 +262,7 @@ static struct twl4030_gpio_platform_data devkit8000_gpio_data = {
 	.irq_base	= TWL4030_GPIO_IRQ_BASE,
 	.irq_end	= TWL4030_GPIO_IRQ_END,
 	.use_leds	= true,
-	.pullups	= BIT(1),
-	.pulldowns	= BIT(2) | BIT(6) | BIT(7) | BIT(8) | BIT(13)
+	.pulldowns	= BIT(1) | BIT(2) | BIT(6) | BIT(8) | BIT(13)
 				| BIT(15) | BIT(16) | BIT(17),
 	.setup		= devkit8000_twl_gpio_setup,
 };
-- 
1.7.4.rc2

