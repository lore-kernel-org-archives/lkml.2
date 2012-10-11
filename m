Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758764Ab2JKPQA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2012 11:16:00 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:38867 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751819Ab2JKPP7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2012 11:15:59 -0400
Date: Thu, 11 Oct 2012 16:15:53 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Linus Walleij <linus.walleij@stericsson.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Stephen Warren <swarren@nvidia.com>,
        Anmar Oueja <anmar.oueja@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>
Subject: Re: [PATCH] pinctrl/nomadik: always use the simple irqdomain
Message-ID: <20121011151553.GC15428@gmail.com>
References: <1349966197-18777-1-git-send-email-linus.walleij@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1349966197-18777-1-git-send-email-linus.walleij@stericsson.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Linus Walleij <linus.walleij@linaro.org>
> 
> Since the simple irqdomain will fall back to a linear domain
> if the first_irq provided is <= 0, just use this, just make
> sure the first_irq is negative in the device tree case.
> 
> Cc: Lee Jones <lee.jones@linaro.org>
> Cc: Rob Herring <rob.herring@calxeda.com>
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
> ---
>  drivers/pinctrl/pinctrl-nomadik.c | 13 +++----------
>  1 file changed, 3 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/pinctrl/pinctrl-nomadik.c b/drivers/pinctrl/pinctrl-nomadik.c
> index 992982c..a4a4247 100644
> --- a/drivers/pinctrl/pinctrl-nomadik.c
> +++ b/drivers/pinctrl/pinctrl-nomadik.c
> @@ -1277,6 +1277,7 @@ static int __devinit nmk_gpio_probe(struct platform_device *dev)
>  	struct clk *clk;
>  	int secondary_irq;
>  	void __iomem *base;
> +	int irq_start = -1;
>  	int irq;
>  	int ret;
>  
> @@ -1380,19 +1381,11 @@ static int __devinit nmk_gpio_probe(struct platform_device *dev)
>  
>  	platform_set_drvdata(dev, nmk_chip);
>  
> -	if (np) {
> -		/* The DT case will just grab a set of IRQ numbers */
> -		nmk_chip->domain = irq_domain_add_linear(np, NMK_GPIO_PER_CHIP,
> -				&nmk_gpio_irq_simple_ops, nmk_chip);
> -	} else {
> -		/* Non-DT legacy mode, use hardwired IRQ numbers */
> -		int irq_start;
> -
> +	if (!np)
>  		irq_start = NOMADIK_GPIO_TO_IRQ(pdata->first_gpio);
> -		nmk_chip->domain = irq_domain_add_simple(NULL,
> +	nmk_chip->domain = irq_domain_add_simple(NULL,
>  				NMK_GPIO_PER_CHIP, irq_start,
>  				&nmk_gpio_irq_simple_ops, nmk_chip);
> -	}
>  	if (!nmk_chip->domain) {
>  		dev_err(&dev->dev, "failed to create irqdomain\n");
>  		ret = -ENOSYS;

Looks good:

Acked-by: Lee Jones <lee.jones@linaro.org>

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
