Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933586Ab2ERALM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 20:11:12 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:57658 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933088Ab2ERALK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 20:11:10 -0400
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH 1/2] gpiolib: Add !CONFIG_GPIOLIB definitions of devm_ functions
To: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Linus Walleij <linus.walleij@stericsson.com>
Cc: linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
In-Reply-To: <1335959206-8138-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <1335959206-8138-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Date: Thu, 17 May 2012 18:11:08 -0600
Message-Id: <20120518001108.C7AAA3E062C@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed,  2 May 2012 12:46:45 +0100, Mark Brown <broonie@opensource.wolfsonmicro.com> wrote:
> Currently the managed gpio_request() and gpio_free() are not stubbed out
> for configurations not using gpiolib - do that to aid use in drivers.
> 
> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> ---
> 
> I thought you'd applied this but it's not showing up in -next.

It was in my local tree.  I think I just forgot to push it out.

g.

> 
>  include/linux/gpio.h |   14 ++++++++++++++
>  1 file changed, 14 insertions(+)
> 
> diff --git a/include/linux/gpio.h b/include/linux/gpio.h
> index d1890d46..8e0fe1b 100644
> --- a/include/linux/gpio.h
> +++ b/include/linux/gpio.h
> @@ -66,6 +66,12 @@ static inline int devm_gpio_request(struct device *dev, unsigned gpio,
>  	return -ENOSYS;
>  }
>  
> +static inline int devm_gpio_request(struct device *dev, unsigned gpio,
> +				    const char *label)
> +{
> +	return -ENOSYS;
> +}
> +
>  static inline int gpio_request_one(unsigned gpio,
>  					unsigned long flags, const char *label)
>  {
> @@ -93,6 +99,14 @@ static inline void devm_gpio_free(struct device *dev, unsigned gpio)
>  	WARN_ON(1);
>  }
>  
> +static inline void devm_gpio_free(struct device *dev, unsigned gpio)
> +{
> +	might_sleep();
> +
> +	/* GPIO can never have been requested */
> +	WARN_ON(1);
> +}
> +
>  static inline void gpio_free_array(const struct gpio *array, size_t num)
>  {
>  	might_sleep();
> -- 
> 1.7.10
> 

-- 
Grant Likely, B.Sc, P.Eng.
Secret Lab Technologies, Ltd.
