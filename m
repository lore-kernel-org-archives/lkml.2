Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751814Ab1GSTKo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jul 2011 15:10:44 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:65394 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751096Ab1GSTKn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jul 2011 15:10:43 -0400
Date: Tue, 19 Jul 2011 13:10:39 -0600
From: Grant Likely <grant.likely@secretlab.ca>
To: Shawn Guo <shawn.guo@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        patches@linaro.org
Subject: Re: [PATCH v2] gpio/mxc/mxs: fix build error introduced by the
 irq_gc_ack() renaming
Message-ID: <20110719191039.GC6848@ponder.secretlab.ca>
References: <1311046444-25423-1-git-send-email-shawn.guo@linaro.org>
 <1311081416-1251-1-git-send-email-shawn.guo@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1311081416-1251-1-git-send-email-shawn.guo@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 19, 2011 at 09:16:56PM +0800, Shawn Guo wrote:
> The following commit renames irq_gc_ack() to irq_gc_ack_set_bit(),
> and makes gpio-mxc and gpio-mxs fail to build.
> 
>   659fb32d1b67476f4ade25e9ea0e2642a5b9c4b5
>   genirq: replace irq_gc_ack() with {set,clr}_bit variants (fwd)
> 
> The patch fixed a couple of typo of comma to semicolon.
> 
> Signed-off-by: Shawn Guo <shawn.guo@linaro.org>

Applied, thanks.

g.

> ---
> Changes since v1:
>  * Fix a couple of typo of comma to semicolon
> 
>  drivers/gpio/gpio-mxc.c |    4 ++--
>  drivers/gpio/gpio-mxs.c |    4 ++--
>  2 files changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/gpio/gpio-mxc.c b/drivers/gpio/gpio-mxc.c
> index 89fda58..4340aca 100644
> --- a/drivers/gpio/gpio-mxc.c
> +++ b/drivers/gpio/gpio-mxc.c
> @@ -297,11 +297,11 @@ static void __init mxc_gpio_init_gc(struct mxc_gpio_port *port)
>  	gc->private = port;
>  
>  	ct = gc->chip_types;
> -	ct->chip.irq_ack = irq_gc_ack,
> +	ct->chip.irq_ack = irq_gc_ack_set_bit;
>  	ct->chip.irq_mask = irq_gc_mask_clr_bit;
>  	ct->chip.irq_unmask = irq_gc_mask_set_bit;
>  	ct->chip.irq_set_type = gpio_set_irq_type;
> -	ct->chip.irq_set_wake = gpio_set_wake_irq,
> +	ct->chip.irq_set_wake = gpio_set_wake_irq;
>  	ct->regs.ack = GPIO_ISR;
>  	ct->regs.mask = GPIO_IMR;
>  
> diff --git a/drivers/gpio/gpio-mxs.c b/drivers/gpio/gpio-mxs.c
> index d8cafba..af55a85 100644
> --- a/drivers/gpio/gpio-mxs.c
> +++ b/drivers/gpio/gpio-mxs.c
> @@ -156,11 +156,11 @@ static void __init mxs_gpio_init_gc(struct mxs_gpio_port *port)
>  	gc->private = port;
>  
>  	ct = gc->chip_types;
> -	ct->chip.irq_ack = irq_gc_ack,
> +	ct->chip.irq_ack = irq_gc_ack_set_bit;
>  	ct->chip.irq_mask = irq_gc_mask_clr_bit;
>  	ct->chip.irq_unmask = irq_gc_mask_set_bit;
>  	ct->chip.irq_set_type = mxs_gpio_set_irq_type;
> -	ct->chip.irq_set_wake = mxs_gpio_set_wake_irq,
> +	ct->chip.irq_set_wake = mxs_gpio_set_wake_irq;
>  	ct->regs.ack = PINCTRL_IRQSTAT(port->id) + MXS_CLR;
>  	ct->regs.mask = PINCTRL_IRQEN(port->id);
>  
> -- 
> 1.7.4.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
