Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757447Ab2DFOpH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2012 10:45:07 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:51628 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757382Ab2DFOoq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2012 10:44:46 -0400
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH V1 2/2] mfd: rc5t583: Initialize gpio during initialization.
To: Laxman Dewangan <ldewangan@nvidia.com>, linus.walleij@stericsson.com,
        sameo@linux.intel.com, ldewangan@nvidia.com
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <1333544671-24549-3-git-send-email-ldewangan@nvidia.com>
References: <1333544671-24549-1-git-send-email-ldewangan@nvidia.com> <1333544671-24549-3-git-send-email-ldewangan@nvidia.com>
Date: Thu, 05 Apr 2012 21:57:45 -0700
Message-Id: <20120406045745.20B393E0EDF@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed,  4 Apr 2012 18:34:31 +0530, Laxman Dewangan <ldewangan@nvidia.com> wrote:
> Initializing gpios of the device RICOH's PMIC RC5T583
> during device initialization. This device support 8 gpios
> which can be access through gpio library.
> 
> Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
> ---
>  drivers/mfd/Kconfig   |    1 +
>  drivers/mfd/rc5t583.c |    1 +
>  2 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
> index 29f463c..7155d5f 100644
> --- a/drivers/mfd/Kconfig
> +++ b/drivers/mfd/Kconfig
> @@ -864,6 +864,7 @@ config MFD_RC5T583
>  	depends on I2C=y && GENERIC_HARDIRQS
>  	select MFD_CORE
>  	select REGMAP_I2C
> +	select GPIO_RC5T583

Don't select a symbol like this.  It gets enabled unconditionally even
if the GPIO_RC5T583 dependencies aren't met.

>  	help
>  	  Select this option to get support for the RICOH583 Power
>  	  Management system device.
> diff --git a/drivers/mfd/rc5t583.c b/drivers/mfd/rc5t583.c
> index 99ef944..a0c9e61 100644
> --- a/drivers/mfd/rc5t583.c
> +++ b/drivers/mfd/rc5t583.c
> @@ -331,6 +331,7 @@ static int __devinit rc5t583_i2c_probe(struct i2c_client *i2c,
>  		goto err_add_devs;
>  	}
>  
> +	rc5t583_gpio_init(rc5t583, pdata);

This looks wrong.  If you're going to do it this way, then just put
the GPIO bits directly into the driver and don't bother with the
separate file at all.  The point of mfd is to split up a driver and
allow each of the sub functions to be probed separately by the driver
model (and loaded as separate modules)

This looks wrong.  If you're going to do it this way, then just put
the GPIO bits directly into the driver and don't bother with the
separate file at all.  The point of mfd is to split up a driver and
allow each of the sub functions to be probed separately by the driver
model, and be loaded as separate modules.

g.
