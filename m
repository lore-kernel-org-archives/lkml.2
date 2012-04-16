Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752967Ab2DPJYX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 05:24:23 -0400
Received: from newsmtp5.atmel.com ([204.2.163.5]:12048 "EHLO
	sjogate2.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752042Ab2DPJVT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 05:21:19 -0400
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: linux-arm-kernel@lists.infradead.org, arnd@arndb.de, olof@lixom.net
Cc: plagnioj@jcrosoft.com, ludovic.desroches@atmel.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH 08/12] ARM: at91: fix at91sam9261ek Ethernet dm9000 irq
Date: Mon, 16 Apr 2012 11:20:52 +0200
Message-Id: <ee9dd7631af6fb5c02964ed5b496217cd4ced059.1334567594.git.nicolas.ferre@atmel.com>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <cover.1334567594.git.nicolas.ferre@atmel.com>
References: <cover.1334567594.git.nicolas.ferre@atmel.com>
In-Reply-To: <cover.1334567594.git.nicolas.ferre@atmel.com>
References: <cover.1334567594.git.nicolas.ferre@atmel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>

You need to setup the dm9000 irq via gpio_to_irq() since
d0fbda9add (ARM: at91/gpio: drop PIN_BASE).

Signed-off-by: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: stable <stable@vger.kernel.org>	[3.2+]
---
 arch/arm/mach-at91/board-sam9261ek.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/arm/mach-at91/board-sam9261ek.c b/arch/arm/mach-at91/board-sam9261ek.c
index c3f9944..065fed3 100644
--- a/arch/arm/mach-at91/board-sam9261ek.c
+++ b/arch/arm/mach-at91/board-sam9261ek.c
@@ -85,8 +85,6 @@ static struct resource dm9000_resource[] = {
 		.flags	= IORESOURCE_MEM
 	},
 	[2] = {
-		.start	= AT91_PIN_PC11,
-		.end	= AT91_PIN_PC11,
 		.flags	= IORESOURCE_IRQ
 			| IORESOURCE_IRQ_LOWEDGE | IORESOURCE_IRQ_HIGHEDGE,
 	}
@@ -130,6 +128,8 @@ static struct sam9_smc_config __initdata dm9000_smc_config = {
 
 static void __init ek_add_device_dm9000(void)
 {
+	struct resource *r = &dm9000_resource[2];
+
 	/* Configure chip-select 2 (DM9000) */
 	sam9_smc_configure(0, 2, &dm9000_smc_config);
 
@@ -139,6 +139,7 @@ static void __init ek_add_device_dm9000(void)
 	/* Configure Interrupt pin as input, no pull-up */
 	at91_set_gpio_input(AT91_PIN_PC11, 0);
 
+	r->start = r->end = gpio_to_irq(AT91_PIN_PC11);
 	platform_device_register(&dm9000_device);
 }
 #else
-- 
1.7.10

