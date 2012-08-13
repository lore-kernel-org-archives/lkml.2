Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752193Ab2HMFwN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 01:52:13 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:50269 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751762Ab2HMFwG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 01:52:06 -0400
From: Bryan Wu <bryan.wu@canonical.com>
To: linux@arm.linux.org.uk, rpurdie@rpsys.net,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-leds@vger.kernel.org, arnd.bergmann@linaro.org,
        nicolas.pitre@linaro.org, olof@lixom.net
Subject: [PATCH 02/18] ARM: at91: convert old leds drivers to gpio_led and led_trigger drivers
Date: Mon, 13 Aug 2012 13:51:26 +0800
Message-Id: <1344837102-11850-3-git-send-email-bryan.wu@canonical.com>
X-Mailer: git-send-email 1.7.11.4
In-Reply-To: <1344837102-11850-1-git-send-email-bryan.wu@canonical.com>
References: <1344837102-11850-1-git-send-email-bryan.wu@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Build with at91 defconfigs successfully

Signed-off-by: Bryan Wu <bryan.wu@canonical.com>
Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>
---
 arch/arm/mach-at91/board-csb337.c       |   2 -
 arch/arm/mach-at91/board-ecbat91.c      |  18 +++++-
 arch/arm/mach-at91/board-eco920.c       |  22 ++++++-
 arch/arm/mach-at91/board-kafa.c         |  17 +++++-
 arch/arm/mach-at91/board-kb9202.c       |  23 ++++++-
 arch/arm/mach-at91/board-rm9200dk.c     |   3 -
 arch/arm/mach-at91/board-rm9200ek.c     |   3 -
 arch/arm/mach-at91/board-rsi-ews.c      |   3 -
 arch/arm/mach-at91/board-sam9-l9260.c   |  23 ++++++-
 arch/arm/mach-at91/board-sam9261ek.c    |   3 -
 arch/arm/mach-at91/board-yl-9200.c      |   3 -
 arch/arm/mach-at91/include/mach/board.h |   1 -
 arch/arm/mach-at91/leds.c               | 105 --------------------------------
 13 files changed, 89 insertions(+), 137 deletions(-)

diff --git a/arch/arm/mach-at91/board-csb337.c b/arch/arm/mach-at91/board-csb337.c
index cd81336..4993f1b 100644
--- a/arch/arm/mach-at91/board-csb337.c
+++ b/arch/arm/mach-at91/board-csb337.c
@@ -219,8 +219,6 @@ static struct gpio_led csb_leds[] = {
 
 static void __init csb337_board_init(void)
 {
-	/* Setup the LEDs */
-	at91_init_leds(AT91_PIN_PB0, AT91_PIN_PB1);
 	/* Serial */
 	/* DBGU on ttyS0 */
 	at91_register_uart(0, 0, 0);
diff --git a/arch/arm/mach-at91/board-ecbat91.c b/arch/arm/mach-at91/board-ecbat91.c
index 89cc372..f9a4ab9 100644
--- a/arch/arm/mach-at91/board-ecbat91.c
+++ b/arch/arm/mach-at91/board-ecbat91.c
@@ -137,11 +137,20 @@ static struct spi_board_info __initdata ecb_at91spi_devices[] = {
 	},
 };
 
+/*
+ * LEDs
+ */
+static struct gpio_led ecb_leds[] = {
+	{	/* D1 */
+		.name			= "led1",
+		.gpio			= AT91_PIN_PC7,
+		.active_low		= 1,
+		.default_trigger	= "heartbeat",
+	}
+};
+
 static void __init ecb_at91board_init(void)
 {
-	/* Setup the LEDs */
-	at91_init_leds(AT91_PIN_PC7, AT91_PIN_PC7);
-
 	/* Serial */
 	/* DBGU on ttyS0. (Rx & Tx only) */
 	at91_register_uart(0, 0, 0);
@@ -164,6 +173,9 @@ static void __init ecb_at91board_init(void)
 
 	/* SPI */
 	at91_add_device_spi(ecb_at91spi_devices, ARRAY_SIZE(ecb_at91spi_devices));
+
+	/* LEDs */
+	at91_gpio_leds(ecb_leds, ARRAY_SIZE(ecb_leds));
 }
 
 MACHINE_START(ECBAT91, "emQbit's ECB_AT91")
diff --git a/arch/arm/mach-at91/board-eco920.c b/arch/arm/mach-at91/board-eco920.c
index 558546c..76cc826 100644
--- a/arch/arm/mach-at91/board-eco920.c
+++ b/arch/arm/mach-at91/board-eco920.c
@@ -92,10 +92,26 @@ static struct spi_board_info eco920_spi_devices[] = {
 	},
 };
 
+/*
+ * LEDs
+ */
+static struct gpio_led eco920_leds[] = {
+	{       /* D1 */
+		.name                   = "led1",
+		.gpio                   = AT91_PIN_PB0,
+		.active_low             = 1,
+		.default_trigger        = "heartbeat",
+	},
+	{       /* D2 */
+		.name                   = "led2",
+		.gpio                   = AT91_PIN_PB1,
+		.active_low             = 1,
+		.default_trigger        = "timer",
+	}
+};
+
 static void __init eco920_board_init(void)
 {
-	/* Setup the LEDs */
-	at91_init_leds(AT91_PIN_PB0, AT91_PIN_PB1);
 	/* DBGU on ttyS0. (Rx & Tx only */
 	at91_register_uart(0, 0, 0);
 	at91_add_device_serial();
@@ -126,6 +142,8 @@ static void __init eco920_board_init(void)
 	);
 
 	at91_add_device_spi(eco920_spi_devices, ARRAY_SIZE(eco920_spi_devices));
+	/* LEDs */
+	at91_gpio_leds(eco920_leds, ARRAY_SIZE(eco920_leds));
 }
 
 MACHINE_START(ECO920, "eco920")
diff --git a/arch/arm/mach-at91/board-kafa.c b/arch/arm/mach-at91/board-kafa.c
index f260657..8db11f4 100644
--- a/arch/arm/mach-at91/board-kafa.c
+++ b/arch/arm/mach-at91/board-kafa.c
@@ -65,11 +65,20 @@ static struct at91_udc_data __initdata kafa_udc_data = {
 	.pullup_pin	= AT91_PIN_PB7,
 };
 
+/*
+ * LEDs
+ */
+static struct gpio_led kafa_leds[] = {
+	{	/* D1 */
+		.name			= "led1",
+		.gpio			= AT91_PIN_PB4,
+		.active_low		= 1,
+		.default_trigger	= "heartbeat",
+	},
+};
+
 static void __init kafa_board_init(void)
 {
-	/* Set up the LEDs */
-	at91_init_leds(AT91_PIN_PB4, AT91_PIN_PB4);
-
 	/* Serial */
 	/* DBGU on ttyS0. (Rx & Tx only) */
 	at91_register_uart(0, 0, 0);
@@ -87,6 +96,8 @@ static void __init kafa_board_init(void)
 	at91_add_device_i2c(NULL, 0);
 	/* SPI */
 	at91_add_device_spi(NULL, 0);
+	/* LEDs */
+	at91_gpio_leds(kafa_leds, ARRAY_SIZE(kafa_leds));
 }
 
 MACHINE_START(KAFA, "Sperry-Sun KAFA")
diff --git a/arch/arm/mach-at91/board-kb9202.c b/arch/arm/mach-at91/board-kb9202.c
index ba39db5..4e362b8 100644
--- a/arch/arm/mach-at91/board-kb9202.c
+++ b/arch/arm/mach-at91/board-kb9202.c
@@ -95,11 +95,26 @@ static struct atmel_nand_data __initdata kb9202_nand_data = {
 	.num_parts	= ARRAY_SIZE(kb9202_nand_partition),
 };
 
+/*
+ * LEDs
+ */
+static struct gpio_led kb9202_leds[] = {
+	{	/* D1 */
+		.name			= "led1",
+		.gpio			= AT91_PIN_PC19,
+		.active_low		= 1,
+		.default_trigger	= "heartbeat",
+	},
+	{	/* D2 */
+		.name			= "led2",
+		.gpio			= AT91_PIN_PC18,
+		.active_low		= 1,
+		.default_trigger	= "timer",
+	}
+};
+
 static void __init kb9202_board_init(void)
 {
-	/* Set up the LEDs */
-	at91_init_leds(AT91_PIN_PC19, AT91_PIN_PC18);
-
 	/* Serial */
 	/* DBGU on ttyS0. (Rx & Tx only) */
 	at91_register_uart(0, 0, 0);
@@ -127,6 +142,8 @@ static void __init kb9202_board_init(void)
 	at91_add_device_spi(NULL, 0);
 	/* NAND */
 	at91_add_device_nand(&kb9202_nand_data);
+	/* LEDs */
+	at91_gpio_leds(kb9202_leds, ARRAY_SIZE(kb9202_leds));
 }
 
 MACHINE_START(KB9200, "KB920x")
diff --git a/arch/arm/mach-at91/board-rm9200dk.c b/arch/arm/mach-at91/board-rm9200dk.c
index afd7a47..7417b7c 100644
--- a/arch/arm/mach-at91/board-rm9200dk.c
+++ b/arch/arm/mach-at91/board-rm9200dk.c
@@ -176,9 +176,6 @@ static struct gpio_led dk_leds[] = {
 
 static void __init dk_board_init(void)
 {
-	/* Setup the LEDs */
-	at91_init_leds(AT91_PIN_PB2, AT91_PIN_PB2);
-
 	/* Serial */
 	/* DBGU on ttyS0. (Rx & Tx only) */
 	at91_register_uart(0, 0, 0);
diff --git a/arch/arm/mach-at91/board-rm9200ek.c b/arch/arm/mach-at91/board-rm9200ek.c
index 2b15b8a..18b2ec0 100644
--- a/arch/arm/mach-at91/board-rm9200ek.c
+++ b/arch/arm/mach-at91/board-rm9200ek.c
@@ -147,9 +147,6 @@ static struct gpio_led ek_leds[] = {
 
 static void __init ek_board_init(void)
 {
-	/* Setup the LEDs */
-	at91_init_leds(AT91_PIN_PB1, AT91_PIN_PB2);
-
 	/* Serial */
 	/* DBGU on ttyS0. (Rx & Tx only) */
 	at91_register_uart(0, 0, 0);
diff --git a/arch/arm/mach-at91/board-rsi-ews.c b/arch/arm/mach-at91/board-rsi-ews.c
index 24ab9be..32342b8 100644
--- a/arch/arm/mach-at91/board-rsi-ews.c
+++ b/arch/arm/mach-at91/board-rsi-ews.c
@@ -184,9 +184,6 @@ static struct platform_device rsiews_nor_flash = {
  */
 static void __init rsi_ews_board_init(void)
 {
-	/* Setup the LEDs */
-	at91_init_leds(AT91_PIN_PB6, AT91_PIN_PB9);
-
 	/* Serial */
 	/* DBGU on ttyS0. (Rx & Tx only) */
 	/* This one is for debugging */
diff --git a/arch/arm/mach-at91/board-sam9-l9260.c b/arch/arm/mach-at91/board-sam9-l9260.c
index cdd21f2..ef982f8 100644
--- a/arch/arm/mach-at91/board-sam9-l9260.c
+++ b/arch/arm/mach-at91/board-sam9-l9260.c
@@ -165,11 +165,26 @@ static struct at91_mmc_data __initdata ek_mmc_data = {
 	.vcc_pin	= -EINVAL,
 };
 
+/*
+ * LEDs
+ */
+static struct gpio_led ek_leds[] = {
+	{	/* D1 */
+		.name			= "led1",
+		.gpio			= AT91_PIN_PA9,
+		.active_low		= 1,
+		.default_trigger	= "heartbeat",
+	},
+	{	/* D2 */
+		.name			= "led2",
+		.gpio			= AT91_PIN_PA6,
+		.active_low		= 1,
+		.default_trigger	= "timer",
+	}
+};
+
 static void __init ek_board_init(void)
 {
-	/* Setup the LEDs */
-	at91_init_leds(AT91_PIN_PA9, AT91_PIN_PA6);
-
 	/* Serial */
 	/* DBGU on ttyS0. (Rx & Tx only) */
 	at91_register_uart(0, 0, 0);
@@ -196,6 +211,8 @@ static void __init ek_board_init(void)
 	at91_add_device_mmc(0, &ek_mmc_data);
 	/* I2C */
 	at91_add_device_i2c(NULL, 0);
+	/* LEDs */
+	at91_gpio_leds(ek_leds, ARRAY_SIZE(ek_leds));
 }
 
 MACHINE_START(SAM9_L9260, "Olimex SAM9-L9260")
diff --git a/arch/arm/mach-at91/board-sam9261ek.c b/arch/arm/mach-at91/board-sam9261ek.c
index 2736453..0b4501c 100644
--- a/arch/arm/mach-at91/board-sam9261ek.c
+++ b/arch/arm/mach-at91/board-sam9261ek.c
@@ -568,9 +568,6 @@ static struct gpio_led ek_leds[] = {
 
 static void __init ek_board_init(void)
 {
-	/* Setup the LEDs */
-	at91_init_leds(AT91_PIN_PA13, AT91_PIN_PA14);
-
 	/* Serial */
 	/* DBGU on ttyS0. (Rx & Tx only) */
 	at91_register_uart(0, 0, 0);
diff --git a/arch/arm/mach-at91/board-yl-9200.c b/arch/arm/mach-at91/board-yl-9200.c
index d56665e..cc05dd1 100644
--- a/arch/arm/mach-at91/board-yl-9200.c
+++ b/arch/arm/mach-at91/board-yl-9200.c
@@ -540,9 +540,6 @@ void __init yl9200_add_device_video(void) {}
 
 static void __init yl9200_board_init(void)
 {
-	/* Setup the LEDs D2=PB17 (timer), D3=PB16 (cpu) */
-	at91_init_leds(AT91_PIN_PB16, AT91_PIN_PB17);
-
 	/* Serial */
 	/* DBGU on ttyS0. (Rx & Tx only) */
 	at91_register_uart(0, 0, 0);
diff --git a/arch/arm/mach-at91/include/mach/board.h b/arch/arm/mach-at91/include/mach/board.h
index 369afc2..c55a436 100644
--- a/arch/arm/mach-at91/include/mach/board.h
+++ b/arch/arm/mach-at91/include/mach/board.h
@@ -187,7 +187,6 @@ struct at91_can_data {
 extern void __init at91_add_device_can(struct at91_can_data *data);
 
  /* LEDs */
-extern void __init at91_init_leds(u8 cpu_led, u8 timer_led);
 extern void __init at91_gpio_leds(struct gpio_led *leds, int nr);
 extern void __init at91_pwm_leds(struct gpio_led *leds, int nr);
 
diff --git a/arch/arm/mach-at91/leds.c b/arch/arm/mach-at91/leds.c
index 8dfafe7..1b1e62b 100644
--- a/arch/arm/mach-at91/leds.c
+++ b/arch/arm/mach-at91/leds.c
@@ -90,108 +90,3 @@ void __init at91_pwm_leds(struct gpio_led *leds, int nr)
 #else
 void __init at91_pwm_leds(struct gpio_led *leds, int nr){}
 #endif
-
-
-/* ------------------------------------------------------------------------- */
-
-#if defined(CONFIG_LEDS)
-
-#include <asm/leds.h>
-
-/*
- * Old ARM-specific LED framework; not fully functional when generic time is
- * in use.
- */
-
-static u8 at91_leds_cpu;
-static u8 at91_leds_timer;
-
-static inline void at91_led_on(unsigned int led)
-{
-	at91_set_gpio_value(led, 0);
-}
-
-static inline void at91_led_off(unsigned int led)
-{
-	at91_set_gpio_value(led, 1);
-}
-
-static inline void at91_led_toggle(unsigned int led)
-{
-	unsigned long is_off = at91_get_gpio_value(led);
-	if (is_off)
-		at91_led_on(led);
-	else
-		at91_led_off(led);
-}
-
-
-/*
- * Handle LED events.
- */
-static void at91_leds_event(led_event_t evt)
-{
-	unsigned long flags;
-
-	local_irq_save(flags);
-
-	switch(evt) {
-	case led_start:		/* System startup */
-		at91_led_on(at91_leds_cpu);
-		break;
-
-	case led_stop:		/* System stop / suspend */
-		at91_led_off(at91_leds_cpu);
-		break;
-
-#ifdef CONFIG_LEDS_TIMER
-	case led_timer:		/* Every 50 timer ticks */
-		at91_led_toggle(at91_leds_timer);
-		break;
-#endif
-
-#ifdef CONFIG_LEDS_CPU
-	case led_idle_start:	/* Entering idle state */
-		at91_led_off(at91_leds_cpu);
-		break;
-
-	case led_idle_end:	/* Exit idle state */
-		at91_led_on(at91_leds_cpu);
-		break;
-#endif
-
-	default:
-		break;
-	}
-
-	local_irq_restore(flags);
-}
-
-
-static int __init leds_init(void)
-{
-	if (!at91_leds_timer || !at91_leds_cpu)
-		return -ENODEV;
-
-	leds_event = at91_leds_event;
-
-	leds_event(led_start);
-	return 0;
-}
-
-__initcall(leds_init);
-
-
-void __init at91_init_leds(u8 cpu_led, u8 timer_led)
-{
-	/* Enable GPIO to access the LEDs */
-	at91_set_gpio_output(cpu_led, 1);
-	at91_set_gpio_output(timer_led, 1);
-
-	at91_leds_cpu	= cpu_led;
-	at91_leds_timer	= timer_led;
-}
-
-#else
-void __init at91_init_leds(u8 cpu_led, u8 timer_led) {}
-#endif
-- 
1.7.11.4

