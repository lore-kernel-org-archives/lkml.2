Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754766Ab2INCai (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 22:30:38 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:38568 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754170Ab2INCag (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 22:30:36 -0400
MIME-Version: 1.0
Date: Fri, 14 Sep 2012 10:30:35 +0800
Message-ID: <CAPgLHd_AmmE0K597Q7uLrPFOFDYZ_WP7zKmGuEaMWN6KCknFVA@mail.gmail.com>
Subject: [PATCH] ARM: at91/gpio: using for_each_set_bit to simplify the code
From: Wei Yongjun <weiyj.lk@gmail.com>
To: linux@maxim.org.za, nicolas.ferre@atmel.com, plagnioj@jcrosoft.com,
        linux@arm.linux.org.uk
Cc: yongjun_wei@trendmicro.com.cn, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Using for_each_set_bit() to simplify the code.

spatch with a semantic match is used to found this.
(http://coccinelle.lip6.fr/)

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 arch/arm/mach-at91/gpio.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/arch/arm/mach-at91/gpio.c b/arch/arm/mach-at91/gpio.c
index be42cf0..ed6ed8c 100644
--- a/arch/arm/mach-at91/gpio.c
+++ b/arch/arm/mach-at91/gpio.c
@@ -609,10 +609,8 @@ static void gpio_irq_handler(unsigned irq, struct irq_desc *desc)
 			continue;
 		}
 
-		n = find_first_bit(&isr, BITS_PER_LONG);
-		while (n < BITS_PER_LONG) {
+		for_each_set_bit(n, &isr, BITS_PER_LONG) {
 			generic_handle_irq(irq_find_mapping(at91_gpio->domain, n));
-			n = find_next_bit(&isr, BITS_PER_LONG, n + 1);
 		}
 	}
 	chained_irq_exit(chip, desc);

