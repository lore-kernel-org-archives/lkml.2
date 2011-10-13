Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752609Ab1JMC11 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Oct 2011 22:27:27 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:39518 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752486Ab1JMCZh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Oct 2011 22:25:37 -0400
Date: Wed, 12 Oct 2011 19:01:34 -0600
From: Grant Likely <grant.likely@secretlab.ca>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: linux-arm-kernel@lists.infradead.org, devicetree-discuss@lists.ozlabs.org,
        robherring2@gmail.com, claudio@evidence.eu.com,
        jesper.nilsson@axis.com, alan@lxorguk.ukuu.org.uk,
        linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org
Subject: Re: [PATCH v2 2/5] tty/serial: atmel_serial: change platform_data
 variable name
Message-ID: <20111013010134.GL14042@ponder.secretlab.ca>
References: <37a19e194d02144aecd24f284f5e43979643a3c3.1318433947.git.nicolas.ferre@atmel.com>
 <58d65421a85737b7a25b967da09c3f564fc49be7.1318433947.git.nicolas.ferre@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <58d65421a85737b7a25b967da09c3f564fc49be7.1318433947.git.nicolas.ferre@atmel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 12, 2011 at 06:06:57PM +0200, Nicolas Ferre wrote:
> Easier to follow if platform_data name is pdata.
> 
> Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>

Acked-by: Grant Likely <grant.likely@secretlab.ca>

> ---
>  drivers/tty/serial/atmel_serial.c |   14 +++++++-------
>  1 files changed, 7 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/tty/serial/atmel_serial.c b/drivers/tty/serial/atmel_serial.c
> index c7232a9..a507daa 100644
> --- a/drivers/tty/serial/atmel_serial.c
> +++ b/drivers/tty/serial/atmel_serial.c
> @@ -1417,13 +1417,13 @@ static void __devinit atmel_init_port(struct atmel_uart_port *atmel_port,
>  				      struct platform_device *pdev)
>  {
>  	struct uart_port *port = &atmel_port->uart;
> -	struct atmel_uart_data *data = pdev->dev.platform_data;
> +	struct atmel_uart_data *pdata = pdev->dev.platform_data;
>  
>  	port->iotype		= UPIO_MEM;
>  	port->flags		= UPF_BOOT_AUTOCONF;
>  	port->ops		= &atmel_pops;
>  	port->fifosize		= 1;
> -	port->line		= data->num;
> +	port->line		= pdata->num;
>  	port->dev		= &pdev->dev;
>  	port->mapbase	= pdev->resource[0].start;
>  	port->irq	= pdev->resource[1].start;
> @@ -1433,9 +1433,9 @@ static void __devinit atmel_init_port(struct atmel_uart_port *atmel_port,
>  
>  	memset(&atmel_port->rx_ring, 0, sizeof(atmel_port->rx_ring));
>  
> -	if (data->regs)
> +	if (pdata->regs)
>  		/* Already mapped by setup code */
> -		port->membase = data->regs;
> +		port->membase = pdata->regs;
>  	else {
>  		port->flags	|= UPF_IOREMAP;
>  		port->membase	= NULL;
> @@ -1450,9 +1450,9 @@ static void __devinit atmel_init_port(struct atmel_uart_port *atmel_port,
>  		/* only enable clock when USART is in use */
>  	}
>  
> -	atmel_port->use_dma_rx = data->use_dma_rx;
> -	atmel_port->use_dma_tx = data->use_dma_tx;
> -	atmel_port->rs485	= data->rs485;
> +	atmel_port->use_dma_rx = pdata->use_dma_rx;
> +	atmel_port->use_dma_tx = pdata->use_dma_tx;
> +	atmel_port->rs485	= pdata->rs485;
>  	/* Use TXEMPTY for interrupt when rs485 else TXRDY or ENDTX|TXBUFE */
>  	if (atmel_port->rs485.flags & SER_RS485_ENABLED)
>  		atmel_port->tx_done_mask = ATMEL_US_TXEMPTY;
> -- 
> 1.7.5.4
> 
