Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758432Ab1DMT4f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 15:56:35 -0400
Received: from 30.mail-out.ovh.net ([213.186.62.213]:42486 "HELO
	30.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1758350Ab1DMT4e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 15:56:34 -0400
From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Patrice Vilchez <patrice.vilchez@atmel.com>,
        Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com>,
        Alan Cox <alan@linux.intel.com>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH] atmel_serial: keep the platform_device unchanged
Date: Wed, 13 Apr 2011 21:47:18 +0200
Message-Id: <1302724038-26236-1-git-send-email-plagnioj@jcrosoft.com>
X-Mailer: git-send-email 1.7.2.3
X-Ovh-Tracer-Id: 18427603775552531453
X-Ovh-Remote: 213.251.161.87 (ns32433.ovh.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-Spam-Check: DONE|U 0.5/N
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

specify the port num via platform_data this will allow to match the clock
with the plaform_dev staticly

Signed-off-by: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Patrice Vilchez <patrice.vilchez@atmel.com>
Cc: Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com>
Cc: Alan Cox <alan@linux.intel.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
---
 arch/arm/mach-at91/at572d940hf_devices.c    |    4 +++-
 arch/arm/mach-at91/at91cap9_devices.c       |    4 +++-
 arch/arm/mach-at91/at91rm9200_devices.c     |    4 +++-
 arch/arm/mach-at91/at91sam9260_devices.c    |    4 +++-
 arch/arm/mach-at91/at91sam9261_devices.c    |    4 +++-
 arch/arm/mach-at91/at91sam9263_devices.c    |    4 +++-
 arch/arm/mach-at91/at91sam9g45_devices.c    |    4 +++-
 arch/arm/mach-at91/at91sam9rl_devices.c     |    4 +++-
 arch/arm/mach-at91/include/mach/board.h     |    1 +
 arch/avr32/mach-at32ap/at32ap700x.c         |    4 +++-
 arch/avr32/mach-at32ap/include/mach/board.h |    1 +
 drivers/tty/serial/atmel_serial.c           |    2 +-
 12 files changed, 30 insertions(+), 10 deletions(-)

diff --git a/arch/arm/mach-at91/at572d940hf_devices.c b/arch/arm/mach-at91/at572d940hf_devices.c
index 6e1b9a3..57ed4b7 100644
--- a/arch/arm/mach-at91/at572d940hf_devices.c
+++ b/arch/arm/mach-at91/at572d940hf_devices.c
@@ -822,6 +822,7 @@ struct platform_device *atmel_default_console_device;	/* the serial console devi
 void __init at91_register_uart(unsigned id, unsigned portnr, unsigned pins)
 {
 	struct platform_device *pdev;
+	struct atmel_uart_data *pdata;
 
 	switch (id) {
 		case 0:		/* DBGU */
@@ -847,7 +848,8 @@ void __init at91_register_uart(unsigned id, unsigned portnr, unsigned pins)
 		default:
 			return;
 	}
-	pdev->id = portnr;		/* update to mapped ID */
+	pdata = pdev->dev.platform_data;
+	pdata->num = portnr;		/* update to mapped ID */
 
 	if (portnr < ATMEL_MAX_UART)
 		at91_uarts[portnr] = pdev;
diff --git a/arch/arm/mach-at91/at91cap9_devices.c b/arch/arm/mach-at91/at91cap9_devices.c
index e887632..ad41039 100644
--- a/arch/arm/mach-at91/at91cap9_devices.c
+++ b/arch/arm/mach-at91/at91cap9_devices.c
@@ -1199,6 +1199,7 @@ struct platform_device *atmel_default_console_device;	/* the serial console devi
 void __init at91_register_uart(unsigned id, unsigned portnr, unsigned pins)
 {
 	struct platform_device *pdev;
+	struct atmel_uart_data *pdata;
 
 	switch (id) {
 		case 0:		/* DBGU */
@@ -1224,7 +1225,8 @@ void __init at91_register_uart(unsigned id, unsigned portnr, unsigned pins)
 		default:
 			return;
 	}
-	pdev->id = portnr;		/* update to mapped ID */
+	pdata = pdev->dev.platform_data;
+	pdata->num = portnr;		/* update to mapped ID */
 
 	if (portnr < ATMEL_MAX_UART)
 		at91_uarts[portnr] = pdev;
diff --git a/arch/arm/mach-at91/at91rm9200_devices.c b/arch/arm/mach-at91/at91rm9200_devices.c
index 5f873d5..f65f9d3 100644
--- a/arch/arm/mach-at91/at91rm9200_devices.c
+++ b/arch/arm/mach-at91/at91rm9200_devices.c
@@ -1109,6 +1109,7 @@ struct platform_device *atmel_default_console_device;	/* the serial console devi
 void __init at91_register_uart(unsigned id, unsigned portnr, unsigned pins)
 {
 	struct platform_device *pdev;
+	struct atmel_uart_data *pdata;
 
 	switch (id) {
 		case 0:		/* DBGU */
@@ -1139,7 +1140,8 @@ void __init at91_register_uart(unsigned id, unsigned portnr, unsigned pins)
 		default:
 			return;
 	}
-	pdev->id = portnr;		/* update to mapped ID */
+	pdata = pdev->dev.platform_data;
+	pdata->num = portnr;		/* update to mapped ID */
 
 	if (portnr < ATMEL_MAX_UART)
 		at91_uarts[portnr] = pdev;
diff --git a/arch/arm/mach-at91/at91sam9260_devices.c b/arch/arm/mach-at91/at91sam9260_devices.c
index e172b46..bb74c2a 100644
--- a/arch/arm/mach-at91/at91sam9260_devices.c
+++ b/arch/arm/mach-at91/at91sam9260_devices.c
@@ -1139,6 +1139,7 @@ struct platform_device *atmel_default_console_device;	/* the serial console devi
 void __init at91_register_uart(unsigned id, unsigned portnr, unsigned pins)
 {
 	struct platform_device *pdev;
+	struct atmel_uart_data *pdata;
 
 	switch (id) {
 		case 0:		/* DBGU */
@@ -1179,7 +1180,8 @@ void __init at91_register_uart(unsigned id, unsigned portnr, unsigned pins)
 		default:
 			return;
 	}
-	pdev->id = portnr;		/* update to mapped ID */
+	pdata = pdev->dev.platform_data;
+	pdata->num = portnr;		/* update to mapped ID */
 
 	if (portnr < ATMEL_MAX_UART)
 		at91_uarts[portnr] = pdev;
diff --git a/arch/arm/mach-at91/at91sam9261_devices.c b/arch/arm/mach-at91/at91sam9261_devices.c
index 59fc483..8792f9b 100644
--- a/arch/arm/mach-at91/at91sam9261_devices.c
+++ b/arch/arm/mach-at91/at91sam9261_devices.c
@@ -989,6 +989,7 @@ struct platform_device *atmel_default_console_device;	/* the serial console devi
 void __init at91_register_uart(unsigned id, unsigned portnr, unsigned pins)
 {
 	struct platform_device *pdev;
+	struct atmel_uart_data *pdata;
 
 	switch (id) {
 		case 0:		/* DBGU */
@@ -1014,7 +1015,8 @@ void __init at91_register_uart(unsigned id, unsigned portnr, unsigned pins)
 		default:
 			return;
 	}
-	pdev->id = portnr;		/* update to mapped ID */
+	pdata = pdev->dev.platform_data;
+	pdata->num = portnr;		/* update to mapped ID */
 
 	if (portnr < ATMEL_MAX_UART)
 		at91_uarts[portnr] = pdev;
diff --git a/arch/arm/mach-at91/at91sam9263_devices.c b/arch/arm/mach-at91/at91sam9263_devices.c
index 416613c..1fc6878 100644
--- a/arch/arm/mach-at91/at91sam9263_devices.c
+++ b/arch/arm/mach-at91/at91sam9263_devices.c
@@ -1370,6 +1370,7 @@ struct platform_device *atmel_default_console_device;	/* the serial console devi
 void __init at91_register_uart(unsigned id, unsigned portnr, unsigned pins)
 {
 	struct platform_device *pdev;
+	struct atmel_uart_data *pdata;
 
 	switch (id) {
 		case 0:		/* DBGU */
@@ -1395,7 +1396,8 @@ void __init at91_register_uart(unsigned id, unsigned portnr, unsigned pins)
 		default:
 			return;
 	}
-	pdev->id = portnr;		/* update to mapped ID */
+	pdata = pdev->dev.platform_data;
+	pdata->num = portnr;		/* update to mapped ID */
 
 	if (portnr < ATMEL_MAX_UART)
 		at91_uarts[portnr] = pdev;
diff --git a/arch/arm/mach-at91/at91sam9g45_devices.c b/arch/arm/mach-at91/at91sam9g45_devices.c
index 0867343..fd031ce 100644
--- a/arch/arm/mach-at91/at91sam9g45_devices.c
+++ b/arch/arm/mach-at91/at91sam9g45_devices.c
@@ -1527,6 +1527,7 @@ struct platform_device *atmel_default_console_device;	/* the serial console devi
 void __init at91_register_uart(unsigned id, unsigned portnr, unsigned pins)
 {
 	struct platform_device *pdev;
+	struct atmel_uart_data *pdata;
 
 	switch (id) {
 		case 0:		/* DBGU */
@@ -1557,7 +1558,8 @@ void __init at91_register_uart(unsigned id, unsigned portnr, unsigned pins)
 		default:
 			return;
 	}
-	pdev->id = portnr;		/* update to mapped ID */
+	pdata = pdev->dev.platform_data;
+	pdata->num = portnr;		/* update to mapped ID */
 
 	if (portnr < ATMEL_MAX_UART)
 		at91_uarts[portnr] = pdev;
diff --git a/arch/arm/mach-at91/at91sam9rl_devices.c b/arch/arm/mach-at91/at91sam9rl_devices.c
index 53aaa94..2d8d519 100644
--- a/arch/arm/mach-at91/at91sam9rl_devices.c
+++ b/arch/arm/mach-at91/at91sam9rl_devices.c
@@ -1141,6 +1141,7 @@ struct platform_device *atmel_default_console_device;	/* the serial console devi
 void __init at91_register_uart(unsigned id, unsigned portnr, unsigned pins)
 {
 	struct platform_device *pdev;
+	struct atmel_uart_data *pdata;
 
 	switch (id) {
 		case 0:		/* DBGU */
@@ -1171,7 +1172,8 @@ void __init at91_register_uart(unsigned id, unsigned portnr, unsigned pins)
 		default:
 			return;
 	}
-	pdev->id = portnr;		/* update to mapped ID */
+	pdata = pdev->dev.platform_data;
+	pdata->num = portnr;		/* update to mapped ID */
 
 	if (portnr < ATMEL_MAX_UART)
 		at91_uarts[portnr] = pdev;
diff --git a/arch/arm/mach-at91/include/mach/board.h b/arch/arm/mach-at91/include/mach/board.h
index d970420..ef10f32 100644
--- a/arch/arm/mach-at91/include/mach/board.h
+++ b/arch/arm/mach-at91/include/mach/board.h
@@ -130,6 +130,7 @@ extern void __init at91_set_serial_console(unsigned portnr);
 extern struct platform_device *atmel_default_console_device;
 
 struct atmel_uart_data {
+	int			num;		/* port num */
 	short			use_dma_tx;	/* use transmit DMA? */
 	short			use_dma_rx;	/* use receive DMA? */
 	void __iomem		*regs;		/* virt. base address, if any */
diff --git a/arch/avr32/mach-at32ap/at32ap700x.c b/arch/avr32/mach-at32ap/at32ap700x.c
index bfc9d07..aa677e2 100644
--- a/arch/avr32/mach-at32ap/at32ap700x.c
+++ b/arch/avr32/mach-at32ap/at32ap700x.c
@@ -1014,6 +1014,7 @@ static struct platform_device *__initdata at32_usarts[4];
 void __init at32_map_usart(unsigned int hw_id, unsigned int line, int flags)
 {
 	struct platform_device *pdev;
+	struct atmel_uart_data *pdata;
 
 	switch (hw_id) {
 	case 0:
@@ -1042,7 +1043,8 @@ void __init at32_map_usart(unsigned int hw_id, unsigned int line, int flags)
 		data->regs = (void __iomem *)pdev->resource[0].start;
 	}
 
-	pdev->id = line;
+	pdata = pdev->dev.platform_data;
+	pdata->num = portnr;
 	at32_usarts[line] = pdev;
 }
 
diff --git a/arch/avr32/mach-at32ap/include/mach/board.h b/arch/avr32/mach-at32ap/include/mach/board.h
index 3d79356..dd61a24 100644
--- a/arch/avr32/mach-at32ap/include/mach/board.h
+++ b/arch/avr32/mach-at32ap/include/mach/board.h
@@ -34,6 +34,7 @@ extern struct platform_device *atmel_default_console_device;
 #define	ATMEL_USART_CLK		0x04
 
 struct atmel_uart_data {
+	int		num;		/* port num */
 	short		use_dma_tx;	/* use transmit DMA? */
 	short		use_dma_rx;	/* use receive DMA? */
 	void __iomem	*regs;		/* virtual base address, if any */
diff --git a/drivers/tty/serial/atmel_serial.c b/drivers/tty/serial/atmel_serial.c
index 2dc8a66..57e294c 100644
--- a/drivers/tty/serial/atmel_serial.c
+++ b/drivers/tty/serial/atmel_serial.c
@@ -1423,7 +1423,7 @@ static int __devinit atmel_init_port(struct atmel_uart_port *atmel_port,
 	port->flags		= UPF_BOOT_AUTOCONF;
 	port->ops		= &atmel_pops;
 	port->fifosize		= 1;
-	port->line		= pdev->id;
+	port->line		= data->num;
 	port->dev		= &pdev->dev;
 	port->mapbase	= pdev->resource[0].start;
 	port->irq	= pdev->resource[1].start;
-- 
1.7.4.1

