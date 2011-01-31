Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756577Ab1AaWQl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 17:16:41 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:55098 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754113Ab1AaWQk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Jan 2011 17:16:40 -0500
Date: Mon, 31 Jan 2011 15:16:35 -0700
From: Grant Likely <grant.likely@secretlab.ca>
To: Thomas Chou <thomas@wytron.com.tw>
Cc: Haavard Skinnemoen <hskinnemoen@gmail.com>,
        Ben Dooks <ben-linux@fluff.org>, linux-kernel@vger.kernel.org,
        nios2-dev@sopc.et.ntust.edu.tw, devicetree-discuss@lists.ozlabs.org,
        linux-i2c@vger.kernel.org, Jean Delvare <khali@linux-fr.org>
Subject: Re: [PATCH 2/3] of: of_gpiochip_add is needed only for gpiolib
Message-ID: <20110131221635.GB27856@angua.secretlab.ca>
References: <AANLkTimS70uHqmv3jhr+7mPz4QFKXRXuFnWj8s3EpKsO@mail.gmail.com>
 <1296487551-30938-2-git-send-email-thomas@wytron.com.tw>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1296487551-30938-2-git-send-email-thomas@wytron.com.tw>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 31, 2011 at 11:25:50PM +0800, Thomas Chou wrote:
> Some gpio drivers may not use gpiolib. In this case, struct gpio_chip
> is not defined and of_gpiochip_add/remove are not needed.
> 
> Signed-off-by: Thomas Chou <thomas@wytron.com.tw>

I'm not thrilled with the idea of supporting a gpio subsystem that
doesn't use gpiolib.  These functions don't even make sense if gpiolib
isn't being used (gpio_chip is a gpiolib construct).

Have you posted a patch that depends on this change?  Patch 3 in this
series doesn't seem to need it.

g.

> ---
>  include/linux/of_gpio.h |    4 ++++
>  1 files changed, 4 insertions(+), 0 deletions(-)
> 
> diff --git a/include/linux/of_gpio.h b/include/linux/of_gpio.h
> index 6598c04..fc96af0 100644
> --- a/include/linux/of_gpio.h
> +++ b/include/linux/of_gpio.h
> @@ -71,9 +71,13 @@ static inline unsigned int of_gpio_count(struct device_node *np)
>  	return 0;
>  }
>  
> +#ifdef CONFIG_GPIOLIB
> +
>  static inline void of_gpiochip_add(struct gpio_chip *gc) { }
>  static inline void of_gpiochip_remove(struct gpio_chip *gc) { }
>  
> +#endif /* CONFIG_GPIOLIB */
> +
>  #endif /* CONFIG_OF_GPIO */
>  
>  /**
> -- 
> 1.7.3.5
> 
