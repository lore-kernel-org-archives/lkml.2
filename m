Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756417Ab1DKIuQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Apr 2011 04:50:16 -0400
Received: from newsmtp5.atmel.com ([204.2.163.5]:47909 "EHLO
	sjogate2.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754187Ab1DKIuO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Apr 2011 04:50:14 -0400
Message-ID: <4DA2C0C0.6050903@atmel.com>
Date: Mon, 11 Apr 2011 10:50:08 +0200
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; fr; rv:1.9.2.13) Gecko/20110303 Lightning/1.0b2 Thunderbird/3.1.9
MIME-Version: 1.0
To: "Voss, Nikolaus" <N.Voss@weinmann.de>
CC: "'Linux Kernel'" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] drivers/spi/atmel_spi.c: prevent premature irqs
References: <EF2E73589CA71846A15D0B2CDF79505D086F931361@wm021.weinmann.com>
In-Reply-To: <EF2E73589CA71846A15D0B2CDF79505D086F931361@wm021.weinmann.com>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le 11/04/2011 08:53, Voss, Nikolaus :
> When restarting a kernel using kexec, filled rx buffers on SPI master
> interface reliably crash the kernel. This patch disables rx interrupts
> on startup to avoid this. Interrupts will be regulary enabled at start
> of a new SPI master transfer.
> 
> Signed-off-by: Nikolaus Voss <n.voss@weinmann.de>
> ---
>  drivers/spi/atmel_spi.c |    3 +++
>  1 files changed, 3 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/spi/atmel_spi.c b/drivers/spi/atmel_spi.c
> index 1a478bf..d17f14c 100644
> --- a/drivers/spi/atmel_spi.c
> +++ b/drivers/spi/atmel_spi.c
> @@ -811,6 +811,9 @@ static int __init atmel_spi_probe(struct platform_device *pdev)
>  	as->irq = irq;
>  	as->clk = clk;
>  
> +	/* disable rx interrupts to avoid premature irq triggering */
> +	spi_writel(as, IDR, SPI_BIT(RXBUFF) | SPI_BIT(ENDRX) | SPI_BIT(OVRES));
> +

What about something like this?

/* disable all interrupts to avoid premature irq triggering */
spi_writel(as, IDR, 0xffffffff);


>  	ret = request_irq(irq, atmel_spi_interrupt, 0,
>  			dev_name(&pdev->dev), master);
>  	if (ret)

Best regards,
-- 
Nicolas Ferre

