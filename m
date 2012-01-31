Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754602Ab2AaOX4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jan 2012 09:23:56 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:45644 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754424Ab2AaOXy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jan 2012 09:23:54 -0500
Date: Tue, 31 Jan 2012 22:36:13 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: Rob Herring <robherring2@gmail.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Grant Likely <grant.likely@secretlab.ca>, b-cousson@ti.com,
        Rob Herring <rob.herring@calxeda.com>,
        Linus Walleij <linus.ml.walleij@gmail.com>
Subject: Re: [PATCH v3 2/2] gpio: pl061: enable interrupts with DT style
 binding
Message-ID: <20120131143609.GA26436@S2101-09.ap.freescale.net>
References: <1327944699-29882-1-git-send-email-robherring2@gmail.com>
 <1327944699-29882-3-git-send-email-robherring2@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1327944699-29882-3-git-send-email-robherring2@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 30, 2012 at 11:31:39AM -0600, Rob Herring wrote:
...
> -static void __init pl061_init_gc(struct pl061_gpio *chip, int irq_base)
> +static void __init pl061_init_gc(struct pl061_gpio *chip,
> +				 struct device_node *node, int irq_base)
>  {
>  	struct irq_chip_type *ct;
>  
> @@ -212,15 +212,17 @@ static void __init pl061_init_gc(struct pl061_gpio *chip, int irq_base)
>  	ct->chip.irq_set_wake = irq_gc_set_wake;
>  	ct->regs.mask = GPIOIE;
>  
> -	irq_setup_generic_chip(chip->irq_gc, IRQ_MSK(PL061_GPIO_NR),
> -			       IRQ_GC_INIT_NESTED_LOCK, IRQ_NOREQUEST, 0);
> +	irq_setup_generic_chip_domain(chip->irq_gc, node,
> +				      IRQ_MSK(PL061_GPIO_NR),
> +				      IRQ_GC_INIT_NESTED_LOCK,
> +				      IRQ_NOREQUEST, 0);
>  }

The function irq_setup_generic_chip_domain() is wrapped by
#ifdef CONFIG_IRQ_DOMAIN in patch #1.  Is it true that pl061 driver
will never work with !IRQ_DOMAIN case?

-- 
Regards,
Shawn
