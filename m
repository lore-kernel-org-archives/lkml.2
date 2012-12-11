Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754412Ab2LKSNm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2012 13:13:42 -0500
Received: from mail-da0-f46.google.com ([209.85.210.46]:51830 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753732Ab2LKSNk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2012 13:13:40 -0500
Date: Tue, 11 Dec 2012 10:13:36 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Linus Walleij <linus.walleij@stericsson.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Linus Walleij <linus.walleij@linaro.org>, Felipe Balbi <balbi@ti.com>,
        Benoit Cousson <b-cousson@ti.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Mitch Bradley <wmb@firmworks.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Kevin Hilman <khilman@ti.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Rickard Andersson <rickard.andersson@stericsson.com>,
        Russell King <linux@arm.linux.org.uk>
Subject: Re: [PATCH] drivers/pinctrl: grab default handles from device core
Message-ID: <20121211181336.GD25714@kroah.com>
References: <1355233246-16694-1-git-send-email-linus.walleij@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1355233246-16694-1-git-send-email-linus.walleij@stericsson.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 11, 2012 at 02:40:46PM +0100, Linus Walleij wrote:
> diff --git a/include/linux/device.h b/include/linux/device.h
> index 86ef6ab..dc399ab 100644
> --- a/include/linux/device.h
> +++ b/include/linux/device.h
> @@ -21,6 +21,7 @@
>  #include <linux/compiler.h>
>  #include <linux/types.h>
>  #include <linux/mutex.h>
> +#include <linux/pinctrl/devinfo.h>
>  #include <linux/pm.h>
>  #include <linux/atomic.h>
>  #include <linux/ratelimit.h>
> @@ -605,6 +606,8 @@ struct device_dma_parameters {
>   * @pm_domain:	Provide callbacks that are executed during system suspend,
>   * 		hibernation, system resume and during runtime PM transitions
>   * 		along with subsystem-level and driver-level callbacks.
> + * @pins:	For device pin management.
> + *		See Documentation/pinctrl.txt for details.
>   * @numa_node:	NUMA node this device is close to.
>   * @dma_mask:	Dma mask (if dma'ble device).
>   * @coherent_dma_mask: Like dma_mask, but for alloc_coherent mapping as not all
> @@ -656,6 +659,10 @@ struct device {
>  	struct dev_pm_info	power;
>  	struct dev_pm_domain	*pm_domain;
>  
> +#ifdef CONFIG_PINCTRL
> +	struct dev_pin_info	pins;
> +#endif

Can't you just make this a * to the structure, saving a bit of space for
those that don't use this structure?  Ok, it's only saving one pointer,
so it's really not a big deal to me if you don't want to do this, just
asking...

Also, this will have to wait until after 3.8-rc1 before I can consider
merging it, I'm a bit busy for the next two weeks at the least...

thanks,

greg k-h
