Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757420Ab2DFOpF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2012 10:45:05 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:51628 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757380Ab2DFOoo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2012 10:44:44 -0400
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH 1/2] gpiolib: Add !CONFIG_GPIOLIB definitions of devm_ functions
To: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Linus Walleij <linus.walleij@stericsson.com>
Cc: linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
In-Reply-To: <1333552489-27694-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <1333552489-27694-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Date: Thu, 05 Apr 2012 21:40:51 -0700
Message-Id: <20120406044051.E99D63E0E8D@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed,  4 Apr 2012 16:14:48 +0100, Mark Brown <broonie@opensource.wolfsonmicro.com> wrote:
> Currently the managed gpio_request() and gpio_free() are not stubbed out
> for configurations not using gpiolib - do that to aid use in drivers.
> 
> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>

Applied, thanks.

g.

> ---
>  include/linux/gpio.h |   14 ++++++++++++++
>  1 files changed, 14 insertions(+), 0 deletions(-)
> 
> diff --git a/include/linux/gpio.h b/include/linux/gpio.h
> index f8b46af..ceb8eef 100644
> --- a/include/linux/gpio.h
> +++ b/include/linux/gpio.h
> @@ -89,6 +89,12 @@ static inline int gpio_request(unsigned gpio, const char *label)
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
> @@ -108,6 +114,14 @@ static inline void gpio_free(unsigned gpio)
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
> 1.7.9.1
> 

-- 
Grant Likely, B.Sc, P.Eng.
Secret Lab Technologies,Ltd.
