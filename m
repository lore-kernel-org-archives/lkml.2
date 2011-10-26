Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932404Ab1JZHwC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Oct 2011 03:52:02 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:58412 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754790Ab1JZHv7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Oct 2011 03:51:59 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>,
        Lucas De Marchi <lucas.demarchi@profusion.mobi>
Cc: linux-m68k@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] m68k: Fall back to __gpio_to_irq() for non-arch GPIOs
Date: Wed, 26 Oct 2011 09:51:55 +0200
Message-Id: <1319615515-3286-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.6.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

gpiolib provides __gpio_to_irq() to map gpiolib gpios to interrupts - hook
that up on m68k.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 arch/m68k/include/asm/gpio.h |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/arch/m68k/include/asm/gpio.h b/arch/m68k/include/asm/gpio.h
index b204683..00d0071 100644
--- a/arch/m68k/include/asm/gpio.h
+++ b/arch/m68k/include/asm/gpio.h
@@ -225,7 +225,8 @@ static inline void gpio_set_value(unsigned gpio, int value)
 
 static inline int gpio_to_irq(unsigned gpio)
 {
-	return (gpio < MCFGPIO_IRQ_MAX) ? gpio + MCFGPIO_IRQ_VECBASE : -EINVAL;
+	return (gpio < MCFGPIO_IRQ_MAX) ? gpio + MCFGPIO_IRQ_VECBASE
+		: __gpio_to_irq(gpio);
 }
 
 static inline int irq_to_gpio(unsigned irq)
-- 
1.7.6.3

