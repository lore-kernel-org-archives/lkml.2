Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753716Ab0HXClB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Aug 2010 22:41:01 -0400
Received: from nwd2mail11.analog.com ([137.71.25.57]:42507 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751579Ab0HXClA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Aug 2010 22:41:00 -0400
From: "Zhang, Sonic" <Sonic.Zhang@analog.com>
X-IronPort-AV: E=Sophos;i="4.56,260,1280721600"; 
   d="scan'208";a="21136780"
Content-Class: urn:content-classes:message
Subject: RE: [PATCH 2/2] drivers/serial/bfin_5xx.c: Use pr_<level> and pr_<fmt>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Date: Tue, 24 Aug 2010 10:42:21 +0800
X-MimeOLE: Produced By Microsoft Exchange V6.5
Message-ID: <0F1B54C89D5F954D8535DB252AF412FA06C35A09@chinexm1.ad.analog.com>
In-Reply-To: <08a2d7676742798de74d69e34b6c175a17d4f96d.1282589920.git.joe@perches.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH 2/2] drivers/serial/bfin_5xx.c: Use pr_<level> and pr_<fmt>
Thread-Index: ActC9Z7L+JwLFxNZQL+LpZQqbXHa2gAPranQ
References: <6028a858f4eb3f07cc5cdddebf5af64fb0e6204e.1282589920.git.joe@perches.com> <08a2d7676742798de74d69e34b6c175a17d4f96d.1282589920.git.joe@perches.com>
To: "Joe Perches" <joe@perches.com>, <linux-kernel@vger.kernel.org>
CC: <uclinux-dist-devel@blackfin.uclinux.org>
X-OriginalArrivalTime: 24 Aug 2010 02:40:49.0780 (UTC) FILETIME=[C338D340:01CB4335]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 

>-----Original Message-----
>From: Joe Perches [mailto:joe@perches.com] 
>Sent: Tuesday, August 24, 2010 3:02 AM
>To: linux-kernel@vger.kernel.org
>Cc: Zhang, Sonic; uclinux-dist-devel@blackfin.uclinux.org
>Subject: [PATCH 2/2] drivers/serial/bfin_5xx.c: Use pr_<level> 
>and pr_<fmt>
>
>Also fix typo of length.
>
>Signed-off-by: Joe Perches <joe@perches.com>
>---
> drivers/serial/bfin_5xx.c |   29 ++++++++++++++---------------
> 1 files changed, 14 insertions(+), 15 deletions(-)
>
>diff --git a/drivers/serial/bfin_5xx.c 
>b/drivers/serial/bfin_5xx.c index 4e38f99..4c01ee6 100644
>--- a/drivers/serial/bfin_5xx.c
>+++ b/drivers/serial/bfin_5xx.c
>@@ -8,6 +8,8 @@
>  * Licensed under the GPL-2 or later.
>  */
> 
>+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
>+
> #if defined(CONFIG_SERIAL_BFIN_CONSOLE) && 
>defined(CONFIG_MAGIC_SYSRQ)  #define SUPPORT_SYSRQ  #endif @@ 
>-631,12 +633,12 @@ static int bfin_serial_startup(struct 
>uart_port *port)
> 	dma_addr_t dma_handle;
> 
> 	if (request_dma(uart->rx_dma_channel, "BFIN_UART_RX") < 0) {
>-		printk(KERN_NOTICE "Unable to attach Blackfin 
>UART RX DMA channel\n");
>+		pr_notice("Unable to attach Blackfin UART RX 
>DMA channel\n");
> 		return -EBUSY;
> 	}
> 
> 	if (request_dma(uart->tx_dma_channel, "BFIN_UART_TX") < 0) {
>-		printk(KERN_NOTICE "Unable to attach Blackfin 
>UART TX DMA channel\n");
>+		pr_notice("Unable to attach Blackfin UART TX 
>DMA channel\n");
> 		free_dma(uart->rx_dma_channel);
> 		return -EBUSY;
> 	}
>@@ -674,14 +676,14 @@ static int bfin_serial_startup(struct 
>uart_port *port)  # endif
> 	if (request_irq(uart->port.irq, bfin_serial_rx_int, 
>IRQF_DISABLED,
> 	     "BFIN_UART_RX", uart)) {
>-		printk(KERN_NOTICE "Unable to attach BlackFin 
>UART RX interrupt\n");
>+		pr_notice("Unable to attach BlackFin UART RX 
>interrupt\n");
> 		return -EBUSY;
> 	}
> 
> 	if (request_irq
> 	    (uart->port.irq+1, bfin_serial_tx_int, IRQF_DISABLED,
> 	     "BFIN_UART_TX", uart)) {
>-		printk(KERN_NOTICE "Unable to attach BlackFin 
>UART TX interrupt\n");
>+		pr_notice("Unable to attach BlackFin UART TX 
>interrupt\n");
> 		free_irq(uart->port.irq, uart);
> 		return -EBUSY;
> 	}
>@@ -706,14 +708,14 @@ static int bfin_serial_startup(struct 
>uart_port *port)
> 
> 		if (uart_dma_ch_rx &&
> 			request_dma(uart_dma_ch_rx, 
>"BFIN_UART_RX") < 0) {
>-			printk(KERN_NOTICE"Fail to attach UART 
>interrupt\n");
>+			pr_notice("Fail to attach UART interrupt\n");
> 			free_irq(uart->port.irq, uart);
> 			free_irq(uart->port.irq + 1, uart);
> 			return -EBUSY;
> 		}
> 		if (uart_dma_ch_tx &&
> 			request_dma(uart_dma_ch_tx, 
>"BFIN_UART_TX") < 0) {
>-			printk(KERN_NOTICE "Fail to attach UART 
>interrupt\n");
>+			pr_notice("Fail to attach UART interrupt\n");
> 			free_dma(uart_dma_ch_rx);
> 			free_irq(uart->port.irq, uart);
> 			free_irq(uart->port.irq + 1, uart);
>@@ -734,8 +736,7 @@ static int bfin_serial_startup(struct 
>uart_port *port)
> 			IRQF_TRIGGER_RISING | IRQF_TRIGGER_FALLING |
> 			IRQF_DISABLED, "BFIN_UART_CTS", uart)) {
> 			uart->cts_pin = -1;
>-			pr_info("Unable to attach BlackFin UART 
>CTS interrupt. "
>-				"So, disable it.\n");
>+			pr_info("Unable to attach BlackFin UART 
>CTS interrupt. So, disable 
>+it.\n");
> 		}
> 	}
> 	if (uart->rts_pin >= 0) {
>@@ -747,8 +748,7 @@ static int bfin_serial_startup(struct 
>uart_port *port)
> 	if (request_irq(uart->status_irq,
> 		bfin_serial_mctrl_cts_int,
> 		IRQF_DISABLED, "BFIN_UART_MODEM_STATUS", uart)) {
>-		pr_info("Unable to attach BlackFin UART Modem "
>-			"Status interrupt.\n");
>+		pr_info("Unable to attach BlackFin UART Modem 
>Status interrupt\n");

I don't this this change is necessary.

> 	}
> 
> 	/* CTS RTS PINs are negative assertive. */ @@ -825,8 
>+825,7 @@ bfin_serial_set_termios(struct uart_port *port, 
>struct ktermios *termios,
> 		lcr = WLS(5);
> 		break;
> 	default:
>-		printk(KERN_ERR "%s: word lengh not supported\n",
>-			__func__);
>+		pr_err("%s: word length not supported\n", __func__);
> 	}
> 
> 	/* Anomaly notes:
>@@ -834,8 +833,7 @@ bfin_serial_set_termios(struct uart_port 
>*port, struct ktermios *termios,
> 	 */
> 	if (termios->c_cflag & CSTOPB) {
> 		if (ANOMALY_05000231)
>-			printk(KERN_WARNING "STOP bits other 
>than 1 is not "
>-				"supported in case of anomaly 
>05000231.\n");
>+			pr_warning("STOP bits other than 1 is 
>not supported in case of 
>+anomaly 05000231\n");

How about following style?

			pr_warning( "STOP bits other than 1 is not "
				"supported in case of anomaly
05000231.\n");


Sonic Zhang

> 		else
> 			lcr |= STB;
> 	}
>@@ -1188,7 +1186,8 @@ bfin_serial_console_get_options(struct 
>bfin_serial_port *uart, int *baud,
> 
> 		*baud = get_sclk() / (16*(dll | dlh << 8));
> 	}
>-	pr_debug("%s:baud = %d, parity = %c, bits= %d\n", 
>__func__, *baud, *parity, *bits);
>+	pr_debug("%s:baud = %d, parity = %c, bits= %d\n",
>+		 __func__, *baud, *parity, *bits);
> }
> 
> static struct uart_driver bfin_serial_reg;
>--
>1.7.2.19.g9a302
>
>
