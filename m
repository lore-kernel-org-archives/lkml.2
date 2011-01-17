Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753384Ab1AQOMd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jan 2011 09:12:33 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:57262 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752153Ab1AQOM0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jan 2011 09:12:26 -0500
From: Thomas Weber <weber@corscience.de>
To: linux-omap@vger.kernel.org
Cc: Daniel Morsing <daniel.morsing@gmail.com>,
        Tony Lindgren <tony@atomide.com>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCHv2 2/2] omap3: devkit8000: fix tps65930 pullup/pulldown configuration
Date: Mon, 17 Jan 2011 15:11:59 +0100
Message-Id: <1295273519-6189-3-git-send-email-weber@corscience.de>
X-Mailer: git-send-email 1.7.4.rc2
In-Reply-To: <1295273519-6189-1-git-send-email-weber@corscience.de>
References: <1295273519-6189-1-git-send-email-weber@corscience.de>
X-Provags-ID: V02:K0:jpHPl/QGFMwqE3CNA5yFxEtpaWPKuunE0lBPjFYI2CW
 4T9UkwrdwlJEwKzbq1fyQeE5K86QIFxHHJeJKIliRyZJq8GoGw
 A0/BS8WM+L4F4TBA/pnoWOnWa33KoSmK0sVE1kTdtCxmcMKMa6
 9yj5zI990bm/GbE3xxMuyo6/RKTl4k0Pou5ALtGEiLmZOUMajM
 Jnmp0RpAIKTpCC1zojEOQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Daniel Morsing <daniel.morsing@gmail.com>

gpio7 on the tps65930 is used as an output on the devkit8000 and gpio1
is not connected. Remove gpio7 and change gpio1 to pulldown

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

