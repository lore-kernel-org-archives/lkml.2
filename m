Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756450Ab2KZVfX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 16:35:23 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:35776 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754138Ab2KZVfV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 16:35:21 -0500
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH] wm831x: Add and use a wm831x_irq_byname convenience function
To: Joe Perches <joe@perches.com>, Sangho Yi <antiroot@gmail.com>
Cc: broonie@opensource.wolfsonmicro.com, cbow@mail.ru, dwmw2@inradead.org,
        linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com
In-Reply-To: <1350496855.3072.55.camel@joe-AO722>
References: <n> <1350486076-3784-1-git-send-email-antiroot@gmail.com> <1350486076-3784-3-git-send-email-antiroot@gmail.com> <1350488383.3072.46.camel@joe-AO722> <1350496855.3072.55.camel@joe-AO722>
Date: Mon, 26 Nov 2012 21:35:15 +0000
Message-Id: <20121126213515.C7AED3E08B7@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 17 Oct 2012 11:00:55 -0700, Joe Perches <joe@perches.com> wrote:
> Add and use a convenience inline to get an irq by name.
> 
> Signed-off-by: Joe Perches <joe@perches.com>
> ---
> Perhaps this is a better alternative to code reflowing.
> 
>  include/linux/mfd/wm831x/core.h       |  8 ++++++++
>  drivers/input/touchscreen/wm831x-ts.c |  7 ++-----
>  drivers/power/wm831x_power.c          | 20 ++++++++------------
>  drivers/regulator/wm831x-dcdc.c       | 23 +++++++++--------------
>  drivers/regulator/wm831x-ldo.c        | 10 ++++------
>  drivers/rtc/rtc-wm831x.c              |  2 +-
>  6 files changed, 32 insertions(+), 38 deletions(-)
> 
> diff --git a/include/linux/mfd/wm831x/core.h b/include/linux/mfd/wm831x/core.h
> index 4a3b83a..96cd081 100644
> --- a/include/linux/mfd/wm831x/core.h
> +++ b/include/linux/mfd/wm831x/core.h
> @@ -20,6 +20,7 @@
>  #include <linux/irqdomain.h>
>  #include <linux/list.h>
>  #include <linux/regmap.h>
> +#include <linux/platform_device.h>
>  
>  /*
>   * Register values.
> @@ -425,6 +426,13 @@ static inline int wm831x_irq(struct wm831x *wm831x, int irq)
>  	return irq_create_mapping(wm831x->irq_domain, irq);
>  }
>  
> +static inline int wm831x_irq_byname(struct wm831x *wm831x,
> +				    struct platform_device *pdev,
> +				    const char *name)
> +{
> +	return wm831x_irq(wm831x, platform_get_irq_byname(pdev, name));
> +}
> +
>  extern struct regmap_config wm831x_regmap_config;

Looks reasonable

g.

