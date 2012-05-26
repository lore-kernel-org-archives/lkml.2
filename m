Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753180Ab2EZNLj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 May 2012 09:11:39 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:51289 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752788Ab2EZNLh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 May 2012 09:11:37 -0400
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH v4 2/6] gpio: re-add of_node_to_gpiochip function
To: Dong Aisheng <b29396@freescale.com>, linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, linus.walleij@stericsson.com,
        swarren@wwwdotorg.org, devicetree-discuss@lists.ozlabs.org,
        rob.herring@calxeda.com, b29396@freescale.com
In-Reply-To: <1337952980-14621-2-git-send-email-b29396@freescale.com>
References: <1337952980-14621-1-git-send-email-b29396@freescale.com> <1337952980-14621-2-git-send-email-b29396@freescale.com>
Date: Fri, 25 May 2012 18:01:27 -0600
Message-Id: <20120526000127.A53903E0D27@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 25 May 2012 21:36:16 +0800, Dong Aisheng <b29396@freescale.com> wrote:
> From: Dong Aisheng <dong.aisheng@linaro.org>
> 
> Signed-off-by: Dong Aisheng <dong.aisheng@linaro.org>

Nack.  Several problems here.  First and foremost there isn't any
description of *why* this change is needed or when it was removed.
Any patch beyond the most trivial change needs to have a commit
message the describes it.

Second, of_node_to_gpiochip() is no longer a valid API because gpiolib
now allows multiple gpiochips to use the same device tree node.  See
commit 3d0f7cf0f "gpio: Adjust of_xlate API to support multiple GPIO
chips" to see a description of why this was changed.

g.

> ---
>  drivers/gpio/gpiolib-of.c |   11 +++++++++++
>  include/linux/of_gpio.h   |    5 +++++
>  2 files changed, 16 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/gpio/gpiolib-of.c b/drivers/gpio/gpiolib-of.c
> index 8389d4a..b8010a9 100644
> --- a/drivers/gpio/gpiolib-of.c
> +++ b/drivers/gpio/gpiolib-of.c
> @@ -234,3 +234,14 @@ void of_gpiochip_remove(struct gpio_chip *chip)
>  	if (chip->of_node)
>  		of_node_put(chip->of_node);
>  }
> +
> +/* Private function for resolving node pointer to gpio_chip */
> +static int of_gpiochip_is_match(struct gpio_chip *chip, void *data)
> +{
> +	return chip->of_node == data;
> +}
> +
> +struct gpio_chip *of_node_to_gpiochip(struct device_node *np)
> +{
> +	return gpiochip_find(np, of_gpiochip_is_match);
> +}
> diff --git a/include/linux/of_gpio.h b/include/linux/of_gpio.h
> index c454f57..880783b 100644
> --- a/include/linux/of_gpio.h
> +++ b/include/linux/of_gpio.h
> @@ -61,6 +61,7 @@ extern void of_gpiochip_remove(struct gpio_chip *gc);
>  extern int of_gpio_simple_xlate(struct gpio_chip *gc,
>  				const struct of_phandle_args *gpiospec,
>  				u32 *flags);
> +extern struct gpio_chip *of_node_to_gpiochip(struct device_node *np);
>  
>  #else /* CONFIG_OF_GPIO */
>  
> @@ -84,6 +85,10 @@ static inline int of_gpio_simple_xlate(struct gpio_chip *gc,
>  	return -ENOSYS;
>  }
>  
> +static struct gpio_chip *of_node_to_gpiochip(struct device_node *np)
> +{
> +	return NULL;
> +}
>  static inline void of_gpiochip_add(struct gpio_chip *gc) { }
>  static inline void of_gpiochip_remove(struct gpio_chip *gc) { }
>  
> -- 
> 1.7.0.4
> 
> 

-- 
Grant Likely, B.Sc, P.Eng.
Secret Lab Technologies, Ltd.
