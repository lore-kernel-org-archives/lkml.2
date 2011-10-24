Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756135Ab1JXWG3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Oct 2011 18:06:29 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:42025 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756072Ab1JXWG2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Oct 2011 18:06:28 -0400
Date: Tue, 25 Oct 2011 00:06:25 +0200
From: Grant Likely <grant.likely@secretlab.ca>
To: Hamo <hamo.by@gmail.com>
Cc: arnd@arndb.de, linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] gpio: fix build error in include/asm-generic/gpio.h
Message-ID: <20111024220625.GD4394@ponder.secretlab.ca>
References: <CAO_0yfOa7B4tB1nJg8c_5a612KjNmPh_aMvS=wHhfU_maAvZAg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAO_0yfOa7B4tB1nJg8c_5a612KjNmPh_aMvS=wHhfU_maAvZAg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 21, 2011 at 09:38:32AM +0800, Hamo wrote:
> Should call the platform-specific __gpio_{get,set}_value
> instead of generic gpio_{get,set}_value
> 
> Signed-off-by: Yang Bai <hamo.by@gmail.com>

Applied, thanks.

> ---
>  include/asm-generic/gpio.h |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/include/asm-generic/gpio.h b/include/asm-generic/gpio.h
> index d494001..6acff5d 100644
> --- a/include/asm-generic/gpio.h
> +++ b/include/asm-generic/gpio.h
> @@ -220,13 +220,13 @@ static inline int gpio_cansleep(unsigned gpio)
>  static inline int gpio_get_value_cansleep(unsigned gpio)
>  {
>  	might_sleep();
> -	return gpio_get_value(gpio);
> +	return __gpio_get_value(gpio);
>  }
> 
>  static inline void gpio_set_value_cansleep(unsigned gpio, int value)
>  {
>  	might_sleep();
> -	gpio_set_value(gpio, value);
> +	__gpio_set_value(gpio, value);
>  }
> 
>  #endif /* !CONFIG_GPIOLIB */
> -- 
> 1.7.1
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
