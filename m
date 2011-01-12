Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755795Ab1ALTjY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jan 2011 14:39:24 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:32912 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753821Ab1ALTjW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jan 2011 14:39:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=alQF3OUeSFeqGu9ybt1dN8gca3ng7c6h5YMm/uhcW0Df8OngBdpUwm0oGB2d0jKAB6
         eyInwHyR2IK8isaElEEKYzrSI36a7+JgQhRKVj+1kGt2gsaXVO7fLRyUoU809SzhO1yR
         MioaeRhH2nE0DHyFrHTwHP37BUOco14z7JbXc=
Subject: Re: [PATCH 01/16] crypto: omap-aes: don't treat NULL clk as an
 error
From: Tobias Karnat <tobias.karnat@googlemail.com>
To: Jamie Iles <jamie@jamieiles.com>
Cc: Dmitry Kasatkin <dmitry.kasatkin@nokia.com>,
        Aaro Koskinen <aaro.koskinen@nokia.com>, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org
In-Reply-To: <1294749833-32019-2-git-send-email-jamie@jamieiles.com>
References: <1294749833-32019-1-git-send-email-jamie@jamieiles.com>
	 <1294749833-32019-2-git-send-email-jamie@jamieiles.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 12 Jan 2011 20:38:55 +0100
Message-ID: <1294861135.14458.5.camel@Tobias-Karnat>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

You have included linux/err.h a second time.

-Tobias

Am Dienstag, den 11.01.2011, 12:43 +0000 schrieb Jamie Iles:
> clk_get() returns a struct clk cookie to the driver and some platforms
> may return NULL if they only support a single clock.  clk_get() has only
> failed if it returns a ERR_PTR() encoded pointer.
> 
> Cc: Dmitry Kasatkin <dmitry.kasatkin@nokia.com>
> Cc: linux-crypto@vger.kernel.org
> Signed-off-by: Jamie Iles <jamie@jamieiles.com>
> ---
>  drivers/crypto/omap-aes.c |    5 +++--
>  1 files changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/crypto/omap-aes.c b/drivers/crypto/omap-aes.c
> index 799ca51..24d0f3f 100644
> --- a/drivers/crypto/omap-aes.c
> +++ b/drivers/crypto/omap-aes.c
> @@ -17,6 +17,7 @@
>  #include <linux/err.h>
>  #include <linux/module.h>
>  #include <linux/init.h>
> +#include <linux/err.h>
>  #include <linux/errno.h>
>  #include <linux/kernel.h>
>  #include <linux/clk.h>
> @@ -830,9 +831,9 @@ static int omap_aes_probe(struct platform_device *pdev)
>  
>  	/* Initializing the clock */
>  	dd->iclk = clk_get(dev, "ick");
> -	if (!dd->iclk) {
> +	if (IS_ERR(dd->iclk)) {
>  		dev_err(dev, "clock intialization failed.\n");
> -		err = -ENODEV;
> +		err = PTR_ERR(dd->iclk);
>  		goto err_res;
>  	}
>  


