Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752167Ab1FYWKm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Jun 2011 18:10:42 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:65130 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752575Ab1FYWKg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Jun 2011 18:10:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=HuA3aRTT8hrCPnSxZEmRNHszGN3NtT+lw2ZfRxbqj/tqfUy4gWrDAW6lAl94D/IKb8
         JFmL0Ozbp1zlWlW2FKKpjNWfZbByR3XddJrkxIJMBd4YosEls4sHHpRbwxmltOPyKMmC
         URuALHOxjq9NOamPSrWZU+IFKnoUW8/gn7StM=
From: Bryan Wu <bryan.wu@canonical.com>
To: linus.walleij@linaro.org, linux-arm-kernel@lists.infradead.org,
        rpurdie@rpsys.net, linux-kernel@vger.kernel.org
Subject: [PATCH 4/4] mach-versatile: retire custom LED code
Date: Sun, 26 Jun 2011 06:10:04 +0800
Message-Id: <1309039804-659-5-git-send-email-bryan.wu@canonical.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1309039804-659-1-git-send-email-bryan.wu@canonical.com>
References: <1309039804-659-1-git-send-email-bryan.wu@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Walleij <linus.walleij@linaro.org>

The CPU activity LED is now handled by the trigger in the leds
subsystem, retire this old CONFIG_LEDS-based code.

Cc: Richard Purdie <rpurdie@rpsys.net>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Bryan Wu <bryan.wu@canonical.com>
---
 arch/arm/mach-versatile/core.c |   42 ----------------------------------------
 1 files changed, 0 insertions(+), 42 deletions(-)

diff --git a/arch/arm/mach-versatile/core.c b/arch/arm/mach-versatile/core.c
index 0c99cf0..b9ff8ff 100644
--- a/arch/arm/mach-versatile/core.c
+++ b/arch/arm/mach-versatile/core.c
@@ -36,7 +36,6 @@
 
 #include <asm/system.h>
 #include <asm/irq.h>
-#include <asm/leds.h>
 #include <asm/hardware/arm_timer.h>
 #include <asm/hardware/icst.h>
 #include <asm/hardware/vic.h>
@@ -646,43 +645,6 @@ static struct amba_device *amba_devs[] __initdata = {
 	&kmi1_device,
 };
 
-#ifdef CONFIG_LEDS
-#define VA_LEDS_BASE (__io_address(VERSATILE_SYS_BASE) + VERSATILE_SYS_LED_OFFSET)
-
-static void versatile_leds_event(led_event_t ledevt)
-{
-	unsigned long flags;
-	u32 val;
-
-	local_irq_save(flags);
-	val = readl(VA_LEDS_BASE);
-
-	switch (ledevt) {
-	case led_idle_start:
-		val = val & ~VERSATILE_SYS_LED0;
-		break;
-
-	case led_idle_end:
-		val = val | VERSATILE_SYS_LED0;
-		break;
-
-	case led_timer:
-		val = val ^ VERSATILE_SYS_LED1;
-		break;
-
-	case led_halted:
-		val = 0;
-		break;
-
-	default:
-		break;
-	}
-
-	writel(val, VA_LEDS_BASE);
-	local_irq_restore(flags);
-}
-#endif	/* CONFIG_LEDS */
-
 /* Early initializations */
 void __init versatile_init_early(void)
 {
@@ -707,10 +669,6 @@ void __init versatile_init(void)
 		struct amba_device *d = amba_devs[i];
 		amba_device_register(d, &iomem_resource);
 	}
-
-#ifdef CONFIG_LEDS
-	leds_event = versatile_leds_event;
-#endif
 }
 
 /*
-- 
1.7.4.1

