Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758682Ab0HDTxj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 15:53:39 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34640 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756873Ab0HDTxi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 15:53:38 -0400
Date: Wed, 4 Aug 2010 12:52:53 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Philippe Langlais <philippe.langlais@stericsson.com>
Cc: <linux-kernel@vger.kernel.org>, <gregkh@suse.de>,
        <alan@lxorguk.ukuu.org.uk>, <ludovic.barre@stericsson.com>,
        <vincent.guittot@stericsson.com>
Subject: Re: [PATCH] U6715 16550A serial driver support
Message-Id: <20100804125253.3977b0d7.akpm@linux-foundation.org>
In-Reply-To: <1280739519-26930-1-git-send-email-philippe.langlais@stericsson.com>
References: <1280739519-26930-1-git-send-email-philippe.langlais@stericsson.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2 Aug 2010 10:58:39 +0200
Philippe Langlais <philippe.langlais@stericsson.com> wrote:

> UART Features extract from STEricsson U6715 data-sheet (arm926 SoC for mobile phone):
> * Fully compatible with industry standard 16C550 and 16C450 from various
> manufacturers
> * RX and TX 64 byte FIFO reduces CPU interrupts
> * Full double buffering
> * Modem control signals include CTS, RTS, (and DSR, DTR on UART1 only)
> * Automatic baud rate selection
> * Manual or automatic RTS/CTS smart hardware flow control
> * Programmable serial characteristics:
> ___ Baud rate generation (50 to 3.25M baud)
> ___ 5, 6, 7 or 8-bit characters
> ___ Even, odd or no-parity bit generation and detection
> ___ 1, 1.5 or 2 stop bit generation
> * Independent control of transmit, receive, line status, data set interrupts and FIFOs
> * Full status-reporting capabilities
> * Separate DMA signaling for RX and TX
> * Timed interrupt to spread receive interrupt on known duration
> * DMA time-out interrupt to allow detection of end of reception
> * Carkit pulse coding and decoding compliant with USB carkit control interface [40]
> 
> In 16550A auto-configuration, if the fifo size is 64 then it's an U6 16550A port
> Add set_termios hook & export serial8250_do_set_termios to change uart
> clock following baudrate

Confused.

> ...
>
> --- a/include/linux/serial_8250.h
> +++ b/include/linux/serial_8250.h
> @@ -32,6 +32,9 @@ struct plat_serial8250_port {
>  	unsigned int	type;		/* If UPF_FIXED_TYPE */
>  	unsigned int	(*serial_in)(struct uart_port *, int);
>  	void		(*serial_out)(struct uart_port *, int, int);
> +	void		(*set_termios)(struct uart_port *,
> +			               struct ktermios *new,
> +			               struct ktermios *old);
>  };
>  
> ...
>
> --- a/include/linux/serial_core.h
> +++ b/include/linux/serial_core.h
> @@ -279,6 +279,9 @@ struct uart_port {
>  	unsigned char __iomem	*membase;		/* read/write[bwl] */
>  	unsigned int		(*serial_in)(struct uart_port *, int);
>  	void			(*serial_out)(struct uart_port *, int, int);
> +	void			(*set_termios)(struct uart_port *,
> +				               struct ktermios *new,
> +				               struct ktermios *old);
>  	unsigned int		irq;			/* irq number */
>  	unsigned long		irqflags;		/* irq flags  */
>  	unsigned int		uartclk;		/* base uart clock */

The patch adds these .set_termios hooks but doesn't actually use them
for anything.

The changelog doesn't tell us _why_ this was done (it should) and
lacking any code to look at it's all a bit mysterious.

