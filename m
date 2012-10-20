Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755955Ab2JTPUT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Oct 2012 11:20:19 -0400
Received: from londo.lunn.ch ([80.238.139.98]:40291 "EHLO londo.lunn.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755715Ab2JTPUR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Oct 2012 11:20:17 -0400
Date: Sat, 20 Oct 2012 17:20:01 +0200
From: Andrew Lunn <andrew@lunn.ch>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: linux-kernel@vger.kernel.org, Rob Herring <rob.herring@calxeda.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>
Subject: Re: [PATCH 3/4 v2] gpio/mvebu: convert to use irq_domain_add_simple()
Message-ID: <20121020152001.GE21046@lunn.ch>
References: <1350644042-31793-1-git-send-email-linus.walleij@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1350644042-31793-1-git-send-email-linus.walleij@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 19, 2012 at 12:54:02PM +0200, Linus Walleij wrote:
> The MVEBU driver probably just wants a few IRQs. Using the simple
> domain has the upside of allocating IRQ descriptors if need be,
> especially in a SPARSE_IRQ environment.
> 
> Cc: Rob Herring <rob.herring@calxeda.com>
> Cc: Grant Likely <grant.likely@secretlab.ca>
> Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
> Cc: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
> Cc: Andrew Lunn <andrew@lunn.ch>
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
> ---
> ChangeLog v1->v2:
> - Keep irq_create_mapping() and do not replace with
>   irq_find_mapping() - if a linear domain is the outcome,
>   we really need to allocate a descriptor on the first mapping
>   call.
> ---
>  drivers/gpio/gpio-mvebu.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/gpio/gpio-mvebu.c b/drivers/gpio/gpio-mvebu.c
> index 902af43..e0bde06 100644
> --- a/drivers/gpio/gpio-mvebu.c
> +++ b/drivers/gpio/gpio-mvebu.c
> @@ -645,8 +645,8 @@ static int __devinit mvebu_gpio_probe(struct platform_device *pdev)
>  			       IRQ_NOREQUEST, IRQ_LEVEL | IRQ_NOPROBE);
>  
>  	/* Setup irq domain on top of the generic chip. */
> -	mvchip->domain = irq_domain_add_legacy(np, mvchip->chip.ngpio,
> -					       mvchip->irqbase, 0,
> +	mvchip->domain = irq_domain_add_simple(np, mvchip->chip.ngpio,
> +					       mvchip->irqbase,
>  					       &irq_domain_simple_ops,
>  					       mvchip);
>  	if (!mvchip->domain) {
> -- 
> 1.7.11.7
> 

Hi Linus

I tested this on a kirkwood QNAP NAS box. gpio-keys still work and
generate interrupts etc.

Tested-by: Andrew Lunn <andrew@lunn.ch>

	   Andrew
