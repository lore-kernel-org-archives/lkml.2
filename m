Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755209Ab2LSPQ0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2012 10:16:26 -0500
Received: from mail-we0-f181.google.com ([74.125.82.181]:58749 "EHLO
	mail-we0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751456Ab2LSPQU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2012 10:16:20 -0500
Date: Wed, 19 Dec 2012 15:16:15 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Linus Walleij <linus.walleij@stericsson.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org,
        Anmar Oueja <anmar.oueja@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>, stable@kernel.org
Subject: Re: [PATCH] mfd: db8500-prcmu: fix irqdomain usage
Message-ID: <20121219151615.GC2691@gmail.com>
References: <1355928161-8082-1-git-send-email-linus.walleij@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1355928161-8082-1-git-send-email-linus.walleij@stericsson.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 19 Dec 2012, Linus Walleij wrote:

> From: Linus Walleij <linus.walleij@linaro.org>
> 
> This fixes two issues with the DB8500 PRCMU irqdomain:
> - You have to state the irq base 0 to get a linear domain
>   for the DT case from irq_domain_add_simple()
> - The irqdomain was not used to translate the initial irq
>   request using irq_create_mapping() making the linear
>   case fail as it was lacking a proper descriptor.
> 
> I took this opportunity to fix two lines of whitespace
> errors in related code as I was anyway messing around with
> it.
> 
> Cc: stable@kernel.org
> Cc: Lee Jones <lee.jones@linaro.org>
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
> ---
> Hi Sam, this is a regression and as such should go into the
> -rc series. As you can see I also added the Cc: stable tag.
> 
> Yours,
> Linus Walleij
> ---
>  drivers/mfd/db8500-prcmu.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/mfd/db8500-prcmu.c b/drivers/mfd/db8500-prcmu.c
> index dc8826d..fcac8e0 100644
> --- a/drivers/mfd/db8500-prcmu.c
> +++ b/drivers/mfd/db8500-prcmu.c
> @@ -2524,7 +2524,7 @@ static bool read_mailbox_0(void)
>  
>  		for (n = 0; n < NUM_PRCMU_WAKEUPS; n++) {
>  			if (ev & prcmu_irq_bit[n])
> -				generic_handle_irq(IRQ_PRCMU_BASE + n);
> +				generic_handle_irq(irq_create_mapping(db8500_irq_domain,n));

                   I thought you were fixing whitespace errors, not introducing them --^

=:-)

>  		}
>  		r = true;
>  		break;
> @@ -2737,13 +2737,13 @@ static int db8500_irq_map(struct irq_domain *d, unsigned int virq,
>  }
>  
>  static struct irq_domain_ops db8500_irq_ops = {
> -        .map    = db8500_irq_map,
> -        .xlate  = irq_domain_xlate_twocell,
> +	.map    = db8500_irq_map,
> +	.xlate  = irq_domain_xlate_twocell,

That's strange. I wrote this, but have always used 8 space tabbing. :|

>  };
>  
>  static int db8500_irq_init(struct device_node *np)
>  {
> -	int irq_base = -1;
> +	int irq_base = 0;
>  
>  	/* In the device tree case, just take some IRQs */
>  	if (!np)
> -- 
> 1.7.11.3
> 

Besides the whitespace error it looks good.

Acked-by: Lee Jones <lee.jones@linaro.org>

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
