Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932332Ab1AKP6J (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jan 2011 10:58:09 -0500
Received: from smtp.nokia.com ([147.243.1.47]:39861 "EHLO mgw-sa01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932284Ab1AKP6G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jan 2011 10:58:06 -0500
Date: Tue, 11 Jan 2011 17:56:51 +0200 (EET)
From: Aaro Koskinen <aaro.koskinen@nokia.com>
X-X-Sender: aakoskin@esdhcp041196.research.nokia.com
To: Jamie Iles <jamie@jamieiles.com>
cc: linux-kernel@vger.kernel.org, Dmitry Kasatkin <dmitry.kasatkin@nokia.com>,
        linux-crypto@vger.kernel.org
Subject: Re: [PATCH 02/16] crypto: omap-sham: don't treat NULL clk as an
 error
In-Reply-To: <1294749833-32019-3-git-send-email-jamie@jamieiles.com>
Message-ID: <alpine.DEB.1.10.1101111756130.18906@esdhcp041196.research.nokia.com>
References: <1294749833-32019-1-git-send-email-jamie@jamieiles.com> <1294749833-32019-3-git-send-email-jamie@jamieiles.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, 11 Jan 2011, Jamie Iles wrote:

> clk_get() returns a struct clk cookie to the driver and some platforms
> may return NULL if they only support a single clock.  clk_get() has only
> failed if it returns a ERR_PTR() encoded pointer.
>
> Cc: Dmitry Kasatkin <dmitry.kasatkin@nokia.com>
> Cc: linux-crypto@vger.kernel.org
> Signed-off-by: Jamie Iles <jamie@jamieiles.com>

Reviewed-by: Aaro Koskinen <aaro.koskinen@nokia.com>

> ---
> drivers/crypto/omap-sham.c |    4 ++--
> 1 files changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/crypto/omap-sham.c b/drivers/crypto/omap-sham.c
> index a081c7c..1acfcd2 100644
> --- a/drivers/crypto/omap-sham.c
> +++ b/drivers/crypto/omap-sham.c
> @@ -1150,9 +1150,9 @@ static int __devinit omap_sham_probe(struct platform_device *pdev)
>
> 	/* Initializing the clock */
> 	dd->iclk = clk_get(dev, "ick");
> -	if (!dd->iclk) {
> +	if (IS_ERR(dd->iclk)) {
> 		dev_err(dev, "clock intialization failed.\n");
> -		err = -ENODEV;
> +		err = PTR_ERR(dd->iclk);
> 		goto clk_err;
> 	}
>
> -- 
> 1.7.3.4
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
