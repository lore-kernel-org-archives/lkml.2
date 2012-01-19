Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932868Ab2ASTt5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jan 2012 14:49:57 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:43268 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932670Ab2ASTtz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jan 2012 14:49:55 -0500
Message-ID: <1327002594.6404.27.camel@joe2Laptop>
Subject: Re: [PATCH] serial: trivial checkpatch fixes in
 drivers/tty/serial/8250.c
From: Joe Perches <joe@perches.com>
To: Simon Glass <sjg@chromium.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Jiri Kosina <trivial@kernel.org>,
        Greg Kroah-Hartman <gregkh@suse.de>, linux-serial@vger.kernel.org
Date: Thu, 19 Jan 2012 11:49:54 -0800
In-Reply-To: <1327001868-29941-1-git-send-email-sjg@chromium.org>
References: <1327001868-29941-1-git-send-email-sjg@chromium.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-01-19 at 11:37 -0800, Simon Glass wrote:
> This makes the file checkpatch clean, fixing these warnings:

Some comments...

> This warning remains, since I am not sure how to fix it:
> error: drivers/tty/serial/8250.c,2929: Macros with complex values should
> 	be enclosed in parenthesis

you can ignore this warning.

> diff --git a/drivers/tty/serial/8250.c b/drivers/tty/serial/8250.c
[]
> @@ -669,7 +669,8 @@ static void disable_rsa(struct uart_8250_port *up)
>  		result = !(mode & UART_RSA_MSR_FIFO);
>  
>  		if (!result) {
> -
> 			serial_outp(up, UART_RSA_MSR, mode & ~UART_RSA_MSR_FIFO);
> +			serial_outp(up, UART_RSA_MSR, mode
> +					& ~UART_RSA_MSR_FIFO);

If it's really necessary to use 80 columns,
I'd prefer this sort of change be:
			serial_outp(up, UART_RSA_MSR,
				    mode & ~UART_RSA_MSR_FIFO);

[]
> @@ -2006,7 +2010,8 @@ static int serial8250_startup(struct uart_port *port)
>  	 */
>  	if (!(up->port.flags & UPF_BUGGY_UART) &&
>  	    (serial_inp(up, UART_LSR) == 0xff)) {
> -		printk_ratelimited(KERN_INFO "ttyS%d: LSR safety check engaged!\n",
> +		printk_ratelimited(KERN_INFO

		pr_info_ratelimited()


> @@ -2019,10 +2024,13 @@ static int serial8250_startup(struct uart_port *port)
>  
>  		serial_outp(up, UART_LCR, UART_LCR_CONF_MODE_B);
>  
> -		fctr = serial_inp(up, UART_FCTR) & ~(UART_FCTR_RX|UART_FCTR_TX);
> -		serial_outp(up, UART_FCTR, fctr | UART_FCTR_TRGD | UART_FCTR_RX);
> +		fctr = serial_inp(up, UART_FCTR) &
> +				  ~(UART_FCTR_RX | UART_FCTR_TX);
> +		serial_outp(up, UART_FCTR, fctr | UART_FCTR_TRGD |
> +			    UART_FCTR_RX);

I think it's better to have all the or's
on the same line where possible.

		serial_outp(up, UART_FCTR,
			    fctr | UART_FCTR_TRGD | UART_FCTR_RX);


> @@ -3130,7 +3139,8 @@ static struct platform_device *serial8250_isa_devs;
>   */
>  static DEFINE_MUTEX(serial_mutex);
>  
> -static struct uart_8250_port *serial8250_find_match_or_unused(struct uart_port *port)
> +static struct uart_8250_port *serial8250_find_match_or_unused(
> +						struct uart_port *port)

It might be better to use

static struct uart_8250_port *
serial8250_find_match_or_unused(struct uart_port *port)
{
> @ -3345,10 +3352,12 @@ MODULE_PARM_DESC(share_irqs, "Share IRQs with other non-8250/16x50 devices"
>  	" (unsafe)");
>  
>  module_param(nr_uarts, uint, 0644);
> -MODULE_PARM_DESC(nr_uarts, "Maximum number of UARTs supported. (1-" __MODULE_STRING(CONFIG_SERIAL_8250_NR_UARTS) ")");
> +MODULE_PARM_DESC(nr_uarts, "Maximum number of UARTs supported. (1-" \
> +		 __MODULE_STRING(CONFIG_SERIAL_8250_NR_UARTS) ")");

Broken.

Don't use line continuations with whitespace on the next line.
Better not use line continations at all except in #defines

 
>  module_param(skip_txen_test, uint, 0644);
> -MODULE_PARM_DESC(skip_txen_test, "Skip checking for the TXEN bug at init time");
> +MODULE_PARM_DESC(skip_txen_test, \
> +		"Skip checking for the TXEN bug at init time");

Useless line continuation.


