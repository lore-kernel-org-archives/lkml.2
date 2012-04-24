Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758570Ab2DXXAs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 19:00:48 -0400
Received: from mail-pz0-f51.google.com ([209.85.210.51]:33944 "EHLO
	mail-pz0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932379Ab2DXWeq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 18:34:46 -0400
Message-Id: <20120424223242.684756150@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Tue, 24 Apr 2012 15:32:49 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: [ 08/62] ARM: at91: fix at91sam9261ek Ethernet dm9000 irq
In-Reply-To: <20120424223305.GA7748@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>

commit ee9dd7631af6fb5c02964ed5b496217cd4ced059 upstream.

You need to setup the dm9000 irq via gpio_to_irq() since
d0fbda9add (ARM: at91/gpio: drop PIN_BASE).

Signed-off-by: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/mach-at91/board-sam9261ek.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/arch/arm/mach-at91/board-sam9261ek.c
+++ b/arch/arm/mach-at91/board-sam9261ek.c
@@ -85,8 +85,6 @@ static struct resource dm9000_resource[]
 		.flags	= IORESOURCE_MEM
 	},
 	[2] = {
-		.start	= AT91_PIN_PC11,
-		.end	= AT91_PIN_PC11,
 		.flags	= IORESOURCE_IRQ
 			| IORESOURCE_IRQ_LOWEDGE | IORESOURCE_IRQ_HIGHEDGE,
 	}
@@ -130,6 +128,8 @@ static struct sam9_smc_config __initdata
 
 static void __init ek_add_device_dm9000(void)
 {
+	struct resource *r = &dm9000_resource[2];
+
 	/* Configure chip-select 2 (DM9000) */
 	sam9_smc_configure(0, 2, &dm9000_smc_config);
 
@@ -139,6 +139,7 @@ static void __init ek_add_device_dm9000(
 	/* Configure Interrupt pin as input, no pull-up */
 	at91_set_gpio_input(AT91_PIN_PC11, 0);
 
+	r->start = r->end = gpio_to_irq(AT91_PIN_PC11);
 	platform_device_register(&dm9000_device);
 }
 #else


