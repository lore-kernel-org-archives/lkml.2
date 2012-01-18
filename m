Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758110Ab2ARUuF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jan 2012 15:50:05 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:61544 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758056Ab2ARUuD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jan 2012 15:50:03 -0500
Date: Wed, 18 Jan 2012 13:49:59 -0700
From: Grant Likely <grant.likely@secretlab.ca>
To: Laxman Dewangan <ldewangan@nvidia.com>
Cc: linus.walleij@stericsson.com, linux-kernel@vger.kernel.org,
        linux-tegra@vger.kernel.org
Subject: Re: [PATCH V1] gpio: tps65910: Use correct offset for gpio
 initialization
Message-ID: <20120118204959.GK4223@ponder.secretlab.ca>
References: <1326897455-8298-1-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1326897455-8298-1-git-send-email-ldewangan@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 18, 2012 at 08:07:35PM +0530, Laxman Dewangan wrote:
> Using the correct gpio offset for setting the initial value
> of gpio when setting output direction.
> 
> Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>

Applied, thanks.

g.

> ---
>  drivers/gpio/gpio-tps65910.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/gpio/gpio-tps65910.c b/drivers/gpio/gpio-tps65910.c
> index b9c1c29..91f45b9 100644
> --- a/drivers/gpio/gpio-tps65910.c
> +++ b/drivers/gpio/gpio-tps65910.c
> @@ -52,7 +52,7 @@ static int tps65910_gpio_output(struct gpio_chip *gc, unsigned offset,
>  	struct tps65910 *tps65910 = container_of(gc, struct tps65910, gpio);
>  
>  	/* Set the initial value */
> -	tps65910_gpio_set(gc, 0, value);
> +	tps65910_gpio_set(gc, offset, value);
>  
>  	return tps65910_set_bits(tps65910, TPS65910_GPIO0 + offset,
>  						GPIO_CFG_MASK);
> -- 
> 1.7.1.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
