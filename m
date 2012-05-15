Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965823Ab2EOQc3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 12:32:29 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:46780 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S965661Ab2EOQc1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 12:32:27 -0400
Message-ID: <1337099546.7050.9.camel@joe2Laptop>
Subject: Re: [PATCH] gpio: Emma Mobile GPIO driver V2
From: Joe Perches <joe@perches.com>
To: Magnus Damm <magnus.damm@gmail.com>
Cc: linux-kernel@vger.kernel.org, rjw@sisk.pl, linus.walleij@stericsson.com,
        arnd@arndb.de, linux-sh@vger.kernel.org, horms@verge.net.au,
        grant.likely@secretlab.ca, lethal@linux-sh.org, olof@lixom.net
Date: Tue, 15 May 2012 09:32:26 -0700
In-Reply-To: <20120515154333.6659.66479.sendpatchset@w520>
References: <20120515154333.6659.66479.sendpatchset@w520>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-05-16 at 00:43 +0900, Magnus Damm wrote:
> This patch is V2 of the Emma Mobile GPIO driver.

Just some trivial comments

> +++ work/drivers/gpio/gpio-em.c	2012-05-16 00:07:20.000000000 +0900
[]

Adding pr_fmt before any #include prefixes all pr_<level> messages.

#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt

> +#include <linux/init.h>
> +#include <linux/platform_device.h>
[]
> +static int em_gio_irq_set_type(struct irq_data *d, unsigned int type)
> +{
[]
> +	pr_debug("gio: sense irq = %d, mode = %d\n", offset, value);

	pr_debug("sense irq = %d, mode = %d\n", offset, value);
[]
> +static void __em_gio_set(struct gpio_chip *chip, unsigned int reg,
> +			 unsigned shift, int value)
> +{
> +	/* upper 16 bits contains mask and lower 16 actual value */
> +	em_gio_write(gpio_to_priv(chip), reg,
> +		     (1 << (shift + 16)) | (value << shift));
> +}

comment doesn't seem to match code unless
value is a single bit, then value should
probably be renamed.

> +static int em_gio_irq_domain_map(struct irq_domain *h, unsigned int virq,
> +				 irq_hw_number_t hw)
> +{
> +	struct em_gio_priv *p = h->host_data;
> +
> +	pr_debug("gio: map hw irq = %d, virq = %d\n", (int)hw, virq);

	pr_debug("map hw irq = %d, virq = %d\n", (int)hw, virq)

> +static struct irq_domain_ops em_gio_irq_domain_ops = {

const?

> +static int __devinit em_gio_irq_domain_init(struct em_gio_priv *p)
[]
> +	pr_debug("gio: hw base = %d, nr = %d, sw base = %d\n",
> +		 pdata->gpio_base, pdata->number_of_pins, p->irq_base);

etc.

> +static int __devinit em_gio_probe(struct platform_device *pdev)
[]
> +	p = kzalloc(sizeof(*p), GFP_KERNEL);
> +	if (!p) {
> +		dev_err(&pdev->dev, "failed to allocate driver data\n");

OOM messages aren't necessary as k.alloc failures
produce a dump_stack.


