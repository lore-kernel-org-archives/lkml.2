Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752394Ab2BRJSB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Feb 2012 04:18:01 -0500
Received: from cassarossa.samfundet.no ([129.241.93.19]:38774 "EHLO
	cassarossa.samfundet.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752203Ab2BRJR7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Feb 2012 04:17:59 -0500
Date: Sat, 18 Feb 2012 10:17:49 +0100
From: Hans-Christian Egtvedt <egtvedt@samfundet.no>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: plagnioj@jcrosoft.com, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, kernel@avr32linux.org
Subject: Re: [PATCH 16/18] Atmel: move console default platform_device to
 serial driver
Message-ID: <20120218091749.GA22669@samfundet.no>
References: <0d78171672a30e8ec8084f54a557e9948260356d.1329500622.git.nicolas.ferre@atmel.com>
 <81ce940f5ac09c5d50bfa712ab10a785f28df4ea.1329500622.git.nicolas.ferre@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <81ce940f5ac09c5d50bfa712ab10a785f28df4ea.1329500622.git.nicolas.ferre@atmel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Around Fri 17 Feb 2012 18:50:08 +0100 or thereabout, Nicolas Ferre wrote:
> From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
> 
> This variable spread on every SoC that is using the atmel_serial.c
> driver can be included directly into the latter.
> 
> This will allow to compile multiple soc in the same kernel.

Sounds like a good idea, but...

<snipp AT91 changes>

> diff --git a/arch/avr32/mach-at32ap/at32ap700x.c b/arch/avr32/mach-at32ap/at32ap700x.c
> index 402a7bb..889c544 100644
> --- a/arch/avr32/mach-at32ap/at32ap700x.c
> +++ b/arch/avr32/mach-at32ap/at32ap700x.c
> @@ -1055,8 +1055,6 @@ struct platform_device *__init at32_add_device_usart(unsigned int id)
>  	return at32_usarts[id];
>  }
>  
> -struct platform_device *atmel_default_console_device;
> -
>  void __init at32_setup_serial_console(unsigned int usart_id)
>  {
>  	atmel_default_console_device = at32_usarts[usart_id];

I doubt this assignment will work if you remove the struct above. I did not
look at how AT91 does this, will it be similar affected?

> diff --git a/drivers/tty/serial/atmel_serial.c b/drivers/tty/serial/atmel_serial.c
> index 10605ec..f9a6be7 100644
> --- a/drivers/tty/serial/atmel_serial.c
> +++ b/drivers/tty/serial/atmel_serial.c
> @@ -1526,6 +1526,8 @@ void __init atmel_register_uart_fns(struct atmel_port_fns *fns)
>  	atmel_pops.set_wake	= fns->set_wake;
>  }
>  
> +struct platform_device *atmel_default_console_device;	/* the serial console device */
> +
>  #ifdef CONFIG_SERIAL_ATMEL_CONSOLE
>  static void atmel_console_putchar(struct uart_port *port, int ch)
>  {
-- 
mvh
Hans-Christian Egtvedt
