Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758032Ab2EQGUm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 02:20:42 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:44756 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757932Ab2EQGUk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 02:20:40 -0400
MIME-Version: 1.0
In-Reply-To: <1337099546.7050.9.camel@joe2Laptop>
References: <20120515154333.6659.66479.sendpatchset@w520>
	<1337099546.7050.9.camel@joe2Laptop>
Date: Thu, 17 May 2012 15:20:39 +0900
Message-ID: <CANqRtoRW4xtRkCYvDs89XD82R8ac_kAFdLp3tSfUv8HufTS1cQ@mail.gmail.com>
Subject: Re: [PATCH] gpio: Emma Mobile GPIO driver V2
From: Magnus Damm <magnus.damm@gmail.com>
To: Joe Perches <joe@perches.com>
Cc: linux-kernel@vger.kernel.org, rjw@sisk.pl, linus.walleij@stericsson.com,
        arnd@arndb.de, linux-sh@vger.kernel.org, horms@verge.net.au,
        grant.likely@secretlab.ca, lethal@linux-sh.org, olof@lixom.net
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Joe,

On Wed, May 16, 2012 at 1:32 AM, Joe Perches <joe@perches.com> wrote:
> On Wed, 2012-05-16 at 00:43 +0900, Magnus Damm wrote:
>> This patch is V2 of the Emma Mobile GPIO driver.
>
> Just some trivial comments

Nice with feedback, thank you!

>> +++ work/drivers/gpio/gpio-em.c       2012-05-16 00:07:20.000000000 +0900
> []
>
> Adding pr_fmt before any #include prefixes all pr_<level> messages.
>
> #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt

Ok, good idea, will add.

>> +#include <linux/init.h>
>> +#include <linux/platform_device.h>
> []
>> +static int em_gio_irq_set_type(struct irq_data *d, unsigned int type)
>> +{
> []
>> +     pr_debug("gio: sense irq = %d, mode = %d\n", offset, value);
>
>        pr_debug("sense irq = %d, mode = %d\n", offset, value);

Right, with the above pr_fmt() line.

> []
>> +static void __em_gio_set(struct gpio_chip *chip, unsigned int reg,
>> +                      unsigned shift, int value)
>> +{
>> +     /* upper 16 bits contains mask and lower 16 actual value */
>> +     em_gio_write(gpio_to_priv(chip), reg,
>> +                  (1 << (shift + 16)) | (value << shift));
>> +}
>
> comment doesn't seem to match code unless
> value is a single bit, then value should
> probably be renamed.

Perhaps a bit odd, but the argument variable names match the GPIO API:

[include/linux/gpio.h]
..
static inline void gpio_set_value(unsigned int gpio, int value)

So I prefer to keep them as-is.

>> +static int em_gio_irq_domain_map(struct irq_domain *h, unsigned int virq,
>> +                              irq_hw_number_t hw)
>> +{
>> +     struct em_gio_priv *p = h->host_data;
>> +
>> +     pr_debug("gio: map hw irq = %d, virq = %d\n", (int)hw, virq);
>
>        pr_debug("map hw irq = %d, virq = %d\n", (int)hw, virq)
>
>> +static struct irq_domain_ops em_gio_irq_domain_ops = {
>
> const?

Sure, why not?

>> +static int __devinit em_gio_probe(struct platform_device *pdev)
> []
>> +     p = kzalloc(sizeof(*p), GFP_KERNEL);
>> +     if (!p) {
>> +             dev_err(&pdev->dev, "failed to allocate driver data\n");
>
> OOM messages aren't necessary as k.alloc failures
> produce a dump_stack.

Ok!

Thanks for your feedback, I will address them in a separate
incremental feature patch.

/ magnus
