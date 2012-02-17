Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753940Ab2BQRvD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Feb 2012 12:51:03 -0500
Received: from newsmtp5.atmel.com ([204.2.163.5]:9037 "EHLO sjogate2.atmel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752425Ab2BQRvA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Feb 2012 12:51:00 -0500
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: plagnioj@jcrosoft.com, linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org,
        Hans-Christian Egtvedt <egtvedt@samfundet.no>, kernel@avr32linux.org
Subject: [PATCH 16/18] Atmel: move console default platform_device to serial driver
Date: Fri, 17 Feb 2012 18:50:08 +0100
Message-Id: <81ce940f5ac09c5d50bfa712ab10a785f28df4ea.1329500622.git.nicolas.ferre@atmel.com>
X-Mailer: git-send-email 1.7.9
In-Reply-To: <1329501010-30468-1-git-send-email-nicolas.ferre@atmel.com>
References: <1329501010-30468-1-git-send-email-nicolas.ferre@atmel.com>
In-Reply-To: <0d78171672a30e8ec8084f54a557e9948260356d.1329500622.git.nicolas.ferre@atmel.com>
References: <0d78171672a30e8ec8084f54a557e9948260356d.1329500622.git.nicolas.ferre@atmel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>

This variable spread on every SoC that is using the atmel_serial.c
driver can be included directly into the latter.

This will allow to compile multiple soc in the same kernel.

Signed-off-by: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Hans-Christian Egtvedt <egtvedt@samfundet.no>
Cc: kernel@avr32linux.org
---
 arch/arm/mach-at91/at91rm9200_devices.c  |    1 -
 arch/arm/mach-at91/at91sam9260_devices.c |    1 -
 arch/arm/mach-at91/at91sam9261_devices.c |    1 -
 arch/arm/mach-at91/at91sam9263_devices.c |    1 -
 arch/arm/mach-at91/at91sam9g45_devices.c |    1 -
 arch/arm/mach-at91/at91sam9rl_devices.c  |    1 -
 arch/arm/mach-at91/at91sam9x5.c          |    1 -
 arch/avr32/mach-at32ap/at32ap700x.c      |    2 --
 drivers/tty/serial/atmel_serial.c        |    2 ++
 9 files changed, 2 insertions(+), 9 deletions(-)

diff --git a/arch/arm/mach-at91/at91rm9200_devices.c b/arch/arm/mach-at91/at91rm9200_devices.c
index aca272b..640520c 100644
--- a/arch/arm/mach-at91/at91rm9200_devices.c
+++ b/arch/arm/mach-at91/at91rm9200_devices.c
@@ -1115,7 +1115,6 @@ static inline void configure_usart3_pins(unsigned pins)
 }
 
 static struct platform_device *__initdata at91_uarts[ATMEL_MAX_UART];	/* the UARTs to use */
-struct platform_device *atmel_default_console_device;	/* the serial console device */
 
 void __init at91_register_uart(unsigned id, unsigned portnr, unsigned pins)
 {
diff --git a/arch/arm/mach-at91/at91sam9260_devices.c b/arch/arm/mach-at91/at91sam9260_devices.c
index ae2b648..f8a88fb 100644
--- a/arch/arm/mach-at91/at91sam9260_devices.c
+++ b/arch/arm/mach-at91/at91sam9260_devices.c
@@ -1157,7 +1157,6 @@ static inline void configure_usart5_pins(void)
 }
 
 static struct platform_device *__initdata at91_uarts[ATMEL_MAX_UART];	/* the UARTs to use */
-struct platform_device *atmel_default_console_device;	/* the serial console device */
 
 void __init at91_register_uart(unsigned id, unsigned portnr, unsigned pins)
 {
diff --git a/arch/arm/mach-at91/at91sam9261_devices.c b/arch/arm/mach-at91/at91sam9261_devices.c
index 57dca50..32a20ef 100644
--- a/arch/arm/mach-at91/at91sam9261_devices.c
+++ b/arch/arm/mach-at91/at91sam9261_devices.c
@@ -1008,7 +1008,6 @@ static inline void configure_usart2_pins(unsigned pins)
 }
 
 static struct platform_device *__initdata at91_uarts[ATMEL_MAX_UART];	/* the UARTs to use */
-struct platform_device *atmel_default_console_device;	/* the serial console device */
 
 void __init at91_register_uart(unsigned id, unsigned portnr, unsigned pins)
 {
diff --git a/arch/arm/mach-at91/at91sam9263_devices.c b/arch/arm/mach-at91/at91sam9263_devices.c
index d042f91..28cb074 100644
--- a/arch/arm/mach-at91/at91sam9263_devices.c
+++ b/arch/arm/mach-at91/at91sam9263_devices.c
@@ -1414,7 +1414,6 @@ static inline void configure_usart2_pins(unsigned pins)
 }
 
 static struct platform_device *__initdata at91_uarts[ATMEL_MAX_UART];	/* the UARTs to use */
-struct platform_device *atmel_default_console_device;	/* the serial console device */
 
 void __init at91_register_uart(unsigned id, unsigned portnr, unsigned pins)
 {
diff --git a/arch/arm/mach-at91/at91sam9g45_devices.c b/arch/arm/mach-at91/at91sam9g45_devices.c
index d184ae4..bb7e2ce 100644
--- a/arch/arm/mach-at91/at91sam9g45_devices.c
+++ b/arch/arm/mach-at91/at91sam9g45_devices.c
@@ -1676,7 +1676,6 @@ static inline void configure_usart3_pins(unsigned pins)
 }
 
 static struct platform_device *__initdata at91_uarts[ATMEL_MAX_UART];	/* the UARTs to use */
-struct platform_device *atmel_default_console_device;	/* the serial console device */
 
 void __init at91_register_uart(unsigned id, unsigned portnr, unsigned pins)
 {
diff --git a/arch/arm/mach-at91/at91sam9rl_devices.c b/arch/arm/mach-at91/at91sam9rl_devices.c
index 285dc6b..16fd20b 100644
--- a/arch/arm/mach-at91/at91sam9rl_devices.c
+++ b/arch/arm/mach-at91/at91sam9rl_devices.c
@@ -1145,7 +1145,6 @@ static inline void configure_usart3_pins(unsigned pins)
 }
 
 static struct platform_device *__initdata at91_uarts[ATMEL_MAX_UART];	/* the UARTs to use */
-struct platform_device *atmel_default_console_device;	/* the serial console device */
 
 void __init at91_register_uart(unsigned id, unsigned portnr, unsigned pins)
 {
diff --git a/arch/arm/mach-at91/at91sam9x5.c b/arch/arm/mach-at91/at91sam9x5.c
index 67b37a0..90bb7ec 100644
--- a/arch/arm/mach-at91/at91sam9x5.c
+++ b/arch/arm/mach-at91/at91sam9x5.c
@@ -320,7 +320,6 @@ void __init at91sam9x5_initialize(void)
  * -------------------------------------------------------------------- */
 void __init at91_register_uart(unsigned id, unsigned portnr, unsigned pins) {}
 void __init at91_set_serial_console(unsigned portnr) {}
-struct platform_device *atmel_default_console_device = NULL;
 
 void __init at91_add_device_nand(struct atmel_nand_data *data) {}
 
diff --git a/arch/avr32/mach-at32ap/at32ap700x.c b/arch/avr32/mach-at32ap/at32ap700x.c
index 402a7bb..889c544 100644
--- a/arch/avr32/mach-at32ap/at32ap700x.c
+++ b/arch/avr32/mach-at32ap/at32ap700x.c
@@ -1055,8 +1055,6 @@ struct platform_device *__init at32_add_device_usart(unsigned int id)
 	return at32_usarts[id];
 }
 
-struct platform_device *atmel_default_console_device;
-
 void __init at32_setup_serial_console(unsigned int usart_id)
 {
 	atmel_default_console_device = at32_usarts[usart_id];
diff --git a/drivers/tty/serial/atmel_serial.c b/drivers/tty/serial/atmel_serial.c
index 10605ec..f9a6be7 100644
--- a/drivers/tty/serial/atmel_serial.c
+++ b/drivers/tty/serial/atmel_serial.c
@@ -1526,6 +1526,8 @@ void __init atmel_register_uart_fns(struct atmel_port_fns *fns)
 	atmel_pops.set_wake	= fns->set_wake;
 }
 
+struct platform_device *atmel_default_console_device;	/* the serial console device */
+
 #ifdef CONFIG_SERIAL_ATMEL_CONSOLE
 static void atmel_console_putchar(struct uart_port *port, int ch)
 {
-- 
1.7.9

