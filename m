Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751022Ab1ITNFP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Sep 2011 09:05:15 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:41118 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750980Ab1ITNFN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Sep 2011 09:05:13 -0400
Date: Tue, 20 Sep 2011 14:05:09 +0100
From: Jamie Iles <jamie@jamieiles.com>
To: Shawn Guo <shawn.guo@linaro.org>
Cc: Grant Likely <grant.likely@secretlab.ca>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, patches@linaro.org
Subject: Re: [PATCH] gpio/mxc: make it work with imx6q
Message-ID: <20110920130508.GE2962@pulham.picochip.com>
References: <1316423432-18333-1-git-send-email-shawn.guo@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1316423432-18333-1-git-send-email-shawn.guo@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Shawn,

On Mon, Sep 19, 2011 at 05:10:32PM +0800, Shawn Guo wrote:
> The imx6q is a Cortex-A9 Quad Core SoC, which has GIC as the primary
> interrupt controller.  GIC requires gpio irq handler to signal EOI,
> otherwise system will hang whenever there is a gpio irq triggered.
> 
> Signed-off-by: Shawn Guo <shawn.guo@linaro.org>
> ---
>  drivers/gpio/gpio-mxc.c |    3 +++
>  1 files changed, 3 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/gpio/gpio-mxc.c b/drivers/gpio/gpio-mxc.c
> index 4340aca..00b4c9c 100644
> --- a/drivers/gpio/gpio-mxc.c
> +++ b/drivers/gpio/gpio-mxc.c
> @@ -233,6 +233,9 @@ static void mx3_gpio_irq_handler(u32 irq, struct irq_desc *desc)
>  	u32 irq_stat;
>  	struct mxc_gpio_port *port = irq_get_handler_data(irq);
>  
> +	if (desc->irq_data.chip->irq_eoi)
> +		desc->irq_data.chip->irq_eoi(&desc->irq_data);
> +
>  	irq_stat = readl(port->base + GPIO_ISR) & readl(port->base + GPIO_IMR);
>  
>  	mxc_gpio_irq_handler(port, irq_stat);
> -- 
> 1.7.4.1

Could this make use of the chained_irq_enter/chained_irq_exit functions 
added in 10a8c38 (ARM: 6806/1: irq: introduce entry and exit functions 
for chained handlers)?

Jamie
