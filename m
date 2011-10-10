Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753382Ab1JJWhS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Oct 2011 18:37:18 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:45179 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752453Ab1JJWhQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Oct 2011 18:37:16 -0400
Message-ID: <4E937396.7090100@gmail.com>
Date: Tue, 11 Oct 2011 09:37:10 +1100
From: Ryan Mallon <rmallon@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.23) Gecko/20110921 Lightning/1.0b2 Thunderbird/3.1.15
MIME-Version: 1.0
To: Hartmut Knaack <knaack.h@gmx.de>
CC: Grant Likely <grant.likely@secretlab.ca>, linux-kernel@vger.kernel.org
Subject: Re: [Patch 2/2] gpio-pca953x: fix gpio_base and add verbosity
References: <4E93703C.9050307@gmx.de>
In-Reply-To: <4E93703C.9050307@gmx.de>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/10/11 09:22, Hartmut Knaack wrote:

> Inspired by the gpio-pcf857x driver, this patch will output information
> about the instantiated gpio-chip, including gpio start and end, chip
> type and if irq is used.
> 
> Signed-off-by: Hartmut Knaack <knaack.h@gmx.de>
> -------------------------------------------------------------
> diff --git a/drivers/gpio/gpio-pca953x.c b/drivers/gpio/gpio-pca953x.c
> index ae479fd..4bdb88e 100644
> --- a/drivers/gpio/gpio-pca953x.c
> +++ b/drivers/gpio/gpio-pca953x.c
> @@ -683,6 +683,12 @@ static int __devinit pca953x_probe(struct
> i2c_client *client,
>      if (ret)
>          goto out_failed;
>  
> +    dev_info(&client->dev, "gpios %d..%d added on a %s%s\n",
> +         chip->gpio_chip.base,
> +         chip->gpio_chip.base + chip->gpio_chip.ngpio - 1,
> +         client->name,
> +         client->irq ? " (irq ignored)" : "");
> +   


If we want this, why not move it into gpiochip_add rather than
duplicating it in each driver? If you want to keep it here it should
probably be moved below the gpiochip_add, since the above would still
print if gpiochip_add failed.

>      ret = gpiochip_add(&chip->gpio_chip);
>      if (ret)
>          goto out_failed_irq;
> 


~Ryan

