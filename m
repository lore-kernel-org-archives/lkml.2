Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752420Ab2AQIXq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jan 2012 03:23:46 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:43184 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752189Ab2AQIXp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jan 2012 03:23:45 -0500
MIME-Version: 1.0
In-Reply-To: <1326784710.16397.1.camel@phoenix>
References: <1326784710.16397.1.camel@phoenix>
Date: Tue, 17 Jan 2012 17:23:44 +0900
Message-ID: <CANKRQngOHk8vHuaigEiaLZgvwu2MDbOz9c45byFb7eEXurEJ8Q@mail.gmail.com>
Subject: Re: [PATCH] gpio: Add missing spin_lock_init in gpio-ml-ioh driver
From: Tomoya MORINAGA <tomoya.rohm@gmail.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org,
        Tomoya MORINAGA <tomoya-linux@dsn.lapis-semi.com>,
        Feng Tang <feng.tang@intel.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@stericsson.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alex

Thank you for your indication.
gpio-pch also looks having the same issue.
Could you post the patch for gpio-pch ?
If you can't, I wil post the patch.

thanks,
tomoya

2012/1/17 Axel Lin <axel.lin@gmail.com>:
> I think this bug was introduced by commit 54be5663
> "gpio-ml-ioh: Support interrupt function" which adds a spinlock to struct
> ioh_gpio but never init the spinlock.
>
> Signed-off-by: Axel Lin <axel.lin@gmail.com>
> ---
>  drivers/gpio/gpio-ml-ioh.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/gpio/gpio-ml-ioh.c b/drivers/gpio/gpio-ml-ioh.c
> index 461958f..271fd49 100644
> --- a/drivers/gpio/gpio-ml-ioh.c
> +++ b/drivers/gpio/gpio-ml-ioh.c
> @@ -448,6 +448,7 @@ static int __devinit ioh_gpio_probe(struct pci_dev *pdev,
>                chip->reg = chip->base;
>                chip->ch = i;
>                mutex_init(&chip->lock);
> +               spin_lock_init(&chip->spinlock);
>                ioh_gpio_setup(chip, num_ports[i]);
>                ret = gpiochip_add(&chip->gpio);
>                if (ret) {
> --
> 1.7.5.4
>
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
