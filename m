Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754503Ab0I2IOb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Sep 2010 04:14:31 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:32954 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754005Ab0I2IO3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Sep 2010 04:14:29 -0400
Date: Wed, 29 Sep 2010 17:14:26 +0900
From: Grant Likely <grant.likely@secretlab.ca>
To: Sinan Akman <sinan@writeme.com>
Cc: linux-kernel@vger.kernel.org, avorontsov@ru.mvista.com,
        dbrownell@users.sourceforge.net
Subject: Re: [PATCH] spi: Add OF-style registration and binding
Message-ID: <20100929081426.GA4703@angua.secretlab.ca>
References: <1285706848-9281-1-git-send-email-sinan@writeme.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1285706848-9281-1-git-send-email-sinan@writeme.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 28, 2010 at 04:47:28PM -0400, Sinan Akman wrote:
> This patch adds the OF hook to the spi core so that devices
> can automatically be registered based on device tree data.
> 
> Signed-off-by: Sinan Akman <sinan@writeme.com>

Applied to -merge, thanks.

g.

> ---
>  drivers/spi/spi.c |    5 +++++
>  1 files changed, 5 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/spi/spi.c b/drivers/spi/spi.c
> index 0bcf4c1..b5a78a1 100644
> --- a/drivers/spi/spi.c
> +++ b/drivers/spi/spi.c
> @@ -23,6 +23,7 @@
>  #include <linux/init.h>
>  #include <linux/cache.h>
>  #include <linux/mutex.h>
> +#include <linux/of_device.h>
>  #include <linux/slab.h>
>  #include <linux/mod_devicetable.h>
>  #include <linux/spi/spi.h>
> @@ -86,6 +87,10 @@ static int spi_match_device(struct device *dev, struct device_driver *drv)
>  	const struct spi_device	*spi = to_spi_device(dev);
>  	const struct spi_driver	*sdrv = to_spi_driver(drv);
>  
> +	/* Attempt an OF style match */
> +	if (of_driver_match_device(dev, drv))
> +		return 1;
> +
>  	if (sdrv->id_table)
>  		return !!spi_match_id(sdrv->id_table, spi);
>  
> -- 
> 1.6.2.5
> 
