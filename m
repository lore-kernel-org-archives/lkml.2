Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753580Ab1GNIO3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jul 2011 04:14:29 -0400
Received: from cpc7-stkp7-2-0-cust918.10-2.cable.virginmedia.com ([86.22.251.151]:47843
	"EHLO freya" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752804Ab1GNIO1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jul 2011 04:14:27 -0400
Date: Wed, 13 Jul 2011 22:32:04 +0100
From: Ben Dooks <ben-i2c@fluff.org>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Dirk Brandewie <dirk.brandewie@gmail.com>,
        Jean Delvare <khali@linux-fr.org>, Ben Dooks <ben-linux@fluff.org>,
        linux-i2c@vger.kernel.org
Subject: Re: [PATCH] i2c-pxa2xx: return proper error code in
 ce4100_i2c_probe error paths
Message-ID: <20110713213204.GE3369@freya.fluff.org>
References: <1310534439.6086.1.camel@phoenix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1310534439.6086.1.camel@phoenix>
X-Disclaimer: These are my views alone.
X-URL: http://www.fluff.org/
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 13, 2011 at 01:20:39PM +0800, Axel Lin wrote:
> Signed-off-by: Axel Lin <axel.lin@gmail.com>

thanks, will apply

> ---
>  drivers/i2c/busses/i2c-pxa-pci.c |    5 ++++-
>  1 files changed, 4 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/i2c/busses/i2c-pxa-pci.c b/drivers/i2c/busses/i2c-pxa-pci.c
> index 6659d26..b73da6c 100644
> --- a/drivers/i2c/busses/i2c-pxa-pci.c
> +++ b/drivers/i2c/busses/i2c-pxa-pci.c
> @@ -109,12 +109,15 @@ static int __devinit ce4100_i2c_probe(struct pci_dev *dev,
>  		return -EINVAL;
>  	}
>  	sds = kzalloc(sizeof(*sds), GFP_KERNEL);
> -	if (!sds)
> +	if (!sds) {
> +		ret = -ENOMEM;
>  		goto err_mem;
> +	}
>  
>  	for (i = 0; i < ARRAY_SIZE(sds->pdev); i++) {
>  		sds->pdev[i] = add_i2c_device(dev, i);
>  		if (IS_ERR(sds->pdev[i])) {
> +			ret = PTR_ERR(sds->pdev[i]);
>  			while (--i >= 0)
>  				platform_device_unregister(sds->pdev[i]);
>  			goto err_dev_add;
> -- 
> 1.7.4.1
> 
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-i2c" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
