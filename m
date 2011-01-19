Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753650Ab1ASITe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jan 2011 03:19:34 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:50300 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753465Ab1ASITd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jan 2011 03:19:33 -0500
From: Thomas Weber <weber@corscience.de>
To: linux-omap@vger.kernel.org
Cc: Daniel Morsing <daniel.morsing@gmail.com>,
        Tony Lindgren <tony@atomide.com>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Thomas Weber <weber@corscience.de>, charu@ti.com, sshtylyov@mvista.com
Subject: [PATCHv4 2/4] OMAP3: Devkit8000: Fix tps65930 pullup/pulldown configuration
Date: Wed, 19 Jan 2011 09:19:24 +0100
Message-Id: <1295425166-25540-3-git-send-email-weber@corscience.de>
X-Mailer: git-send-email 1.7.4.rc2
In-Reply-To: <1295425166-25540-1-git-send-email-weber@corscience.de>
References: <1295425166-25540-1-git-send-email-weber@corscience.de>
X-Provags-ID: V02:K0:W99kUhE7PXs8DLploId0JQEjpCczTPJV9gr4mjeRIkE
 B9wtYXSvVheC+zpETG2nkCHTYjVxBkNDjnygJW78crlKFHA7i3
 HUn0sXGV275LQM21xhdtbrmgevf7fBGJr1aMwNLypaMIEv1T20
 5dcLE2E+UU/PBv+t1MvdzEAuP433ZShRFh6AL9enwybnxJ0ytO
 xO4JMjYl5Ga7HPuwc7pHA==
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

