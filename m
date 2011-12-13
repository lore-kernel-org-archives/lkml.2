Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754611Ab1LMADR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 19:03:17 -0500
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:59716 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753557Ab1LMADO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 19:03:14 -0500
X-Sasl-enc: GbYWAFwbGaPqbKSPFciYg1VceLrMKJogwTA6gez75jx6 1323734593
Date: Mon, 12 Dec 2011 16:03:02 -0800
From: Greg KH <greg@kroah.com>
To: Sonic Zhang <sonic.adi@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, linux-serial@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        uclinux-dist-devel@blackfin.uclinux.org,
        Sonic Zhang <sonic.zhang@analog.com>
Subject: Re: [PATCH 1/2 v2] serial: bfin-uart: Enable hardware automatic CTS
 only when CTS pin is available.
Message-ID: <20111213000302.GA18722@kroah.com>
References: <1323673191-9210-1-git-send-email-sonic.adi@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1323673191-9210-1-git-send-email-sonic.adi@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 12, 2011 at 02:59:50PM +0800, Sonic Zhang wrote:
> From: Sonic Zhang <sonic.zhang@analog.com>
> 
> Signed-off-by: Sonic Zhang <sonic.zhang@analog.com>
> ---
>  drivers/tty/serial/bfin_uart.c |   19 ++++++++++---------
>  1 files changed, 10 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/tty/serial/bfin_uart.c b/drivers/tty/serial/bfin_uart.c
> index abac237..a6c1c08 100644
> --- a/drivers/tty/serial/bfin_uart.c
> +++ b/drivers/tty/serial/bfin_uart.c
> @@ -726,16 +726,17 @@ static int bfin_serial_startup(struct uart_port *port)
>  	}
>  #endif
>  #ifdef CONFIG_SERIAL_BFIN_HARD_CTSRTS
> -	if (uart->cts_pin >= 0 && request_irq(uart->status_irq,
> -		bfin_serial_mctrl_cts_int,
> -		0, "BFIN_UART_MODEM_STATUS", uart)) {
> -		uart->cts_pin = -1;
> -		pr_info("Unable to attach BlackFin UART Modem Status interrupt.\n");
> -	}
> +	if (uart->cts_pin >= 0) {
> +		if (request_irq(uart->status_irq, bfin_serial_mctrl_cts_int,
> +			IRQF_DISABLED, "BFIN_UART_MODEM_STATUS", uart)) {
> +			uart->cts_pin = -1;
> +			pr_info("Unable to attach BlackFin UART Modem Status interrupt.\n");

Please use dev_info() here instead, that properly identifies the exact
device you are having problems with.

thanks,

greg k-h
