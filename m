Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755914Ab2JQBA5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 21:00:57 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:21174 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755759Ab2JQBAz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 21:00:55 -0400
X-AuditID: cbfee61a-b7f976d000001eb9-95-507e034535c9
From: Jingoo Han <jg1.han@samsung.com>
To: "'Ryan Mallon'" <rmallon@gmail.com>
Cc: "'Grant Likely'" <grant.likely@secretlab.ca>,
        "'Linus Walleij'" <linus.walleij@linaro.org>,
        "'Kukjin Kim'" <kgene.kim@samsung.com>,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <008901cdab77$d2538800$76fa9800$%han@samsung.com>
 <507D2C3C.8050706@gmail.com>
In-reply-to: <507D2C3C.8050706@gmail.com>
Subject: Re: [PATCH V2 RESEND] gpio: samsung: use pr_* instead of printk
Date: Wed, 17 Oct 2012 10:00:53 +0900
Message-id: <002401cdac02$db6f29e0$924d7da0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac2rgsYGzwBYhLTHQECjynjn7//z7QAf6yYQ
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrILMWRmVeSWpSXmKPExsVy+t9jQV1X5roAg5/3VSwu75rDZjHj/D4m
	ByaPz5vkAhijuGxSUnMyy1KL9O0SuDK+bfrIVrBZpqJ5zVLGBsadYl2MnBwSAiYSu/ZOZ4Ow
	xSQu3FsPZgsJTGeUmNmT3MXIBWT/YpR41tzKCpJgE1CT+PLlMDuILSKgKrGz/z8rSBGzwGtG
	iY4zbawQ3TESR+ZeBCviFNCU6Lw6BcwWFvCQmPn0JSOIzQLUfGTjcSCbg4NXwFbi7okikDCv
	gKDEj8n3WEBsZgEtic3bmlghbHmJzWveMoOUSwioSzz6qwtxgpHE9mtHocpFJPa9eMc4gVFo
	FpJJs5BMmoVk0iwkLQsYWVYxiqYWJBcUJ6XnGuoVJ+YWl+al6yXn525iBAf0M6kdjCsbLA4x
	CnAwKvHwfphdGyDEmlhWXJl7iFGCg1lJhNe8ESjEm5JYWZValB9fVJqTWnyIUZqDRUmct9kj
	JUBIID2xJDU7NbUgtQgmy8TBKdXAWBldwPj0uXad5Q22+8+q5ae+FLsf5a109ufem8c263zZ
	sfsF7+X1RyT5wkqsRV9IT17y/GDxyfOrZ3+YPl1N6eHXIJdwnpf5T3Rbsvqljj4o/JJxXSRh
	wZ4j7NOiUzkNjcxiz+2d2BySLpD24tDK68vXLOgPK5t9teJ1iHaUQ4yhRWiQ+uTHlUosxRmJ
	hlrMRcWJAA56sClkAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, October 16, 2012 6:43 PM Ryan Mallon wrote
> 
> On 16/10/12 19:25, Jingoo Han wrote:
> 
> > This patch uses pr_* instead of printk. Also, gpio_dbg
> > is replaced with pr_debug.
> >
> > Signed-off-by: Ryan Mallon <rmallon@gmail.com>
> 
> 
> If I recall correctly, I only offered review comments on this patch,
> I wasn't directly involved in writing it, or in the submission
> process, so you don't need to have my signed-off-by here.  It's also
> generally considered impolite to add someone's signed-off-by without
> asking for permission. I don't mind either way, but you don't need
> my tag since you wrote the patch, I only provided feedback.

Sorry, it's my fault.
I will remove your signed-off-by, and will send v3 patch.
Thank you for letting me know.

Best regards,
Jingoo Han

> 
> Thanks,
> ~Ryan
> 
> > Signed-off-by: Jingoo Han <jg1.han@samsung.com>
> > Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
> > ---
> >  drivers/gpio/gpio-samsung.c |   18 ++++++------------
> >  1 files changed, 6 insertions(+), 12 deletions(-)
> >
> > diff --git a/drivers/gpio/gpio-samsung.c b/drivers/gpio/gpio-samsung.c
> > index a006f0d..5c5ccdf 100644
> > --- a/drivers/gpio/gpio-samsung.c
> > +++ b/drivers/gpio/gpio-samsung.c
> > @@ -42,12 +42,6 @@
> >  #include <plat/gpio-fns.h>
> >  #include <plat/pm.h>
> >
> > -#ifndef DEBUG_GPIO
> > -#define gpio_dbg(x...) do { } while (0)
> > -#else
> > -#define gpio_dbg(x...) printk(KERN_DEBUG x)
> > -#endif
> > -
> >  int samsung_gpio_setpull_updown(struct samsung_gpio_chip *chip,
> >  				unsigned int off, samsung_gpio_pull_t pull)
> >  {
> > @@ -599,7 +593,7 @@ static int samsung_gpiolib_4bit_input(struct gpio_chip *chip,
> >  	con &= ~(0xf << con_4bit_shift(offset));
> >  	__raw_writel(con, base + GPIOCON_OFF);
> >
> > -	gpio_dbg("%s: %p: CON now %08lx\n", __func__, base, con);
> > +	pr_debug("%s: %p: CON now %08lx\n", __func__, base, con);
> >
> >  	return 0;
> >  }
> > @@ -627,7 +621,7 @@ static int samsung_gpiolib_4bit_output(struct gpio_chip *chip,
> >  	__raw_writel(con, base + GPIOCON_OFF);
> >  	__raw_writel(dat, base + GPIODAT_OFF);
> >
> > -	gpio_dbg("%s: %p: CON %08lx, DAT %08lx\n", __func__, base, con, dat);
> > +	pr_debug("%s: %p: CON %08lx, DAT %08lx\n", __func__, base, con, dat);
> >
> >  	return 0;
> >  }
> > @@ -671,7 +665,7 @@ static int samsung_gpiolib_4bit2_input(struct gpio_chip *chip,
> >  	con &= ~(0xf << con_4bit_shift(offset));
> >  	__raw_writel(con, regcon);
> >
> > -	gpio_dbg("%s: %p: CON %08lx\n", __func__, base, con);
> > +	pr_debug("%s: %p: CON %08lx\n", __func__, base, con);
> >
> >  	return 0;
> >  }
> > @@ -706,7 +700,7 @@ static int samsung_gpiolib_4bit2_output(struct gpio_chip *chip,
> >  	__raw_writel(con, regcon);
> >  	__raw_writel(dat, base + GPIODAT_OFF);
> >
> > -	gpio_dbg("%s: %p: CON %08lx, DAT %08lx\n", __func__, base, con, dat);
> > +	pr_debug("%s: %p: CON %08lx, DAT %08lx\n", __func__, base, con, dat);
> >
> >  	return 0;
> >  }
> > @@ -926,10 +920,10 @@ static void __init samsung_gpiolib_add(struct samsung_gpio_chip *chip)
> >  #ifdef CONFIG_PM
> >  	if (chip->pm != NULL) {
> >  		if (!chip->pm->save || !chip->pm->resume)
> > -			printk(KERN_ERR "gpio: %s has missing PM functions\n",
> > +			pr_err("gpio: %s has missing PM functions\n",
> >  			       gc->label);
> >  	} else
> > -		printk(KERN_ERR "gpio: %s has no PM function\n", gc->label);
> > +		pr_err("gpio: %s has no PM function\n", gc->label);
> >  #endif
> >
> >  	/* gpiochip_add() prints own failure message on error. */


