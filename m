Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755189Ab2K3ABY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2012 19:01:24 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:54390 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754807Ab2K3ABX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2012 19:01:23 -0500
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: linux-next: manual merge of the gpio tree with the driver-core tree
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Bill Pemberton <wfp5p@virginia.edu>, Greg KH <greg@kroah.com>,
        Linus Walleij <linus.walleij@linaro.org>
In-Reply-To: <20121129155723.60035c6419fd9a00f46e4d69@canb.auug.org.au>
References: <20121129155723.60035c6419fd9a00f46e4d69@canb.auug.org.au>
Date: Fri, 30 Nov 2012 00:01:18 +0000
Message-Id: <20121130000118.A68313E05AD@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 29 Nov 2012 15:57:23 +1100, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> Hi Grant,
> 
> Today's linux-next merge of the gpio tree got a conflict in
> drivers/gpio/gpio-em.c between commit 3836309d9346 ("gpio: remove use of
> __devinit") from the driver-core tree and commit 7385500a49b7 ("gpio/em:
> convert to linear IRQ domain") from the gpio tree.
> 
> I fixed it up (see below) and can carry the fix as necessary (no action
> is required).

Thanks Stephen.

Yes, please carry the fix.

g.

> 
> -- 
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au
> 
> diff --cc drivers/gpio/gpio-em.c
> index 320a718,b007063..0000000
> --- a/drivers/gpio/gpio-em.c
> +++ b/drivers/gpio/gpio-em.c
> @@@ -234,41 -233,7 +233,7 @@@ static struct irq_domain_ops em_gio_irq
>   	.map	= em_gio_irq_domain_map,
>   };
>   
> - static int __devinit em_gio_irq_domain_init(struct em_gio_priv *p)
> - {
> - 	struct platform_device *pdev = p->pdev;
> - 	struct gpio_em_config *pdata = pdev->dev.platform_data;
> - 
> - 	p->irq_base = irq_alloc_descs(pdata->irq_base, 0,
> - 				      pdata->number_of_pins, numa_node_id());
> - 	if (p->irq_base < 0) {
> - 		dev_err(&pdev->dev, "cannot get irq_desc\n");
> - 		return p->irq_base;
> - 	}
> - 	pr_debug("gio: hw base = %d, nr = %d, sw base = %d\n",
> - 		 pdata->gpio_base, pdata->number_of_pins, p->irq_base);
> - 
> - 	p->irq_domain = irq_domain_add_legacy(pdev->dev.of_node,
> - 					      pdata->number_of_pins,
> - 					      p->irq_base, 0,
> - 					      &em_gio_irq_domain_ops, p);
> - 	if (!p->irq_domain) {
> - 		irq_free_descs(p->irq_base, pdata->number_of_pins);
> - 		return -ENXIO;
> - 	}
> - 
> - 	return 0;
> - }
> - 
> - static void em_gio_irq_domain_cleanup(struct em_gio_priv *p)
> - {
> - 	struct gpio_em_config *pdata = p->pdev->dev.platform_data;
> - 
> - 	irq_free_descs(p->irq_base, pdata->number_of_pins);
> - 	/* FIXME: irq domain wants to be freed! */
> - }
> - 
>  -static int __devinit em_gio_probe(struct platform_device *pdev)
>  +static int em_gio_probe(struct platform_device *pdev)
>   {
>   	struct gpio_em_config *pdata = pdev->dev.platform_data;
>   	struct em_gio_priv *p;

-- 
Grant Likely, B.Sc, P.Eng.
Secret Lab Technologies, Ltd.
