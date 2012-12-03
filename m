Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754382Ab2LCPk1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2012 10:40:27 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:48756 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753172Ab2LCPkZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2012 10:40:25 -0500
Date: Mon, 3 Dec 2012 15:40:14 +0000
From: Jamie Iles <jamie@jamieiles.com>
To: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Cox <alan@linux.intel.com>, Jamie Iles <jamie@jamieiles.com>,
        linux-serial@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCHv2 3/5] serial: 8250_dw: Map IO memory
Message-ID: <20121203154014.GA20140@page>
References: <1354533479-27306-1-git-send-email-heikki.krogerus@linux.intel.com>
 <1354533479-27306-4-git-send-email-heikki.krogerus@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1354533479-27306-4-git-send-email-heikki.krogerus@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Heikki,

On Mon, Dec 03, 2012 at 01:17:57PM +0200, Heikki Krogerus wrote:
> This needs to be done in order to later access the
> Designware specific registers.
> 
> Signed-off-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
> ---
>  drivers/tty/serial/8250/8250_dw.c |    7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/tty/serial/8250/8250_dw.c b/drivers/tty/serial/8250/8250_dw.c
> index ff83ea5..300bbed 100644
> --- a/drivers/tty/serial/8250/8250_dw.c
> +++ b/drivers/tty/serial/8250/8250_dw.c
> @@ -111,10 +111,13 @@ static int dw8250_probe(struct platform_device *pdev)
>  	uart.port.irq = irq->start;
>  	uart.port.handle_irq = dw8250_handle_irq;
>  	uart.port.type = PORT_8250;
> -	uart.port.flags = UPF_SHARE_IRQ | UPF_BOOT_AUTOCONF | UPF_IOREMAP |
> -		UPF_FIXED_PORT;
> +	uart.port.flags = UPF_SHARE_IRQ | UPF_BOOT_AUTOCONF | UPF_FIXED_PORT;
>  	uart.port.dev = &pdev->dev;
>  
> +	uart.port.membase = ioremap(regs->start, regs->end - regs->start);

Doesn't this have an off-by-one error?  Perhaps:

+	uart.port.membase = ioremap(regs->start, resource_size(regs));

instead?

Jamie
