Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753204Ab2KKMnT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Nov 2012 07:43:19 -0500
Received: from www.hansjkoch.de ([178.63.77.200]:51272 "EHLO www.hansjkoch.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753181Ab2KKMnR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Nov 2012 07:43:17 -0500
Date: Sun, 11 Nov 2012 13:43:10 +0100
From: "Hans J. Koch" <hjk@hansjkoch.de>
To: Manuel Traut <manut@linutronix.de>
Cc: linux-kernel@vger.kernel.org, "Hans J. Koch" <hjk@hansjkoch.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Stefan Staedtler <stefan.staedtler@siemens.com>,
        Magnus Damm <magnus.damm@gmail.com>,
        Uwe Kleine-Koenig <u.kleine-koenig@pengutronix.de>
Subject: Re: [PATCH] uio_pdrv: set memory mapping name
Message-ID: <20121111124310.GA4313@local>
References: <20121109060640.GW15531@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121109060640.GW15531@linutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 09, 2012 at 07:06:40AM +0100, Manuel Traut wrote:
> If uio_pdrv[_genirq] is used, the uio maps have currently no name set.
> This patch sets the uio_mem name to the name of the memory resource.

Looks fine to me. I added the driver's authors to Cc.

Signed-off-by: "Hans J. Koch" <hjk@hansjkoch.de>

>  
> Signed-off-by: Manuel Traut <manut@linutronix.de>
> Reported-by: Stefan Staedtler <stefan.staedtler@siemens.com>
> Tested-by: Stefan Staedtler <stefan.staedtler@siemens.com>
> 
> diff --git a/drivers/uio/uio_pdrv_genirq.c b/drivers/uio/uio_pdrv_genirq.c
> index 42202cd..ac988ce 100644
> --- a/drivers/uio/uio_pdrv_genirq.c
> +++ b/drivers/uio/uio_pdrv_genirq.c
> @@ -172,6 +172,7 @@ static int uio_pdrv_genirq_probe(struct platform_device *pdev)
>  		uiomem->memtype = UIO_MEM_PHYS;
>  		uiomem->addr = r->start;
>  		uiomem->size = resource_size(r);
> +		uiomem->name = r->name;
>  		++uiomem;
>  	}
>  
> diff --git a/drivers/uio/uio_pdrv.c b/drivers/uio/uio_pdrv.c
> index 72d3646..39be9e0 100644
> --- a/drivers/uio/uio_pdrv.c
> +++ b/drivers/uio/uio_pdrv.c
> @@ -60,6 +60,7 @@ static int uio_pdrv_probe(struct platform_device *pdev)
>  		uiomem->memtype = UIO_MEM_PHYS;
>  		uiomem->addr = r->start;
>  		uiomem->size = resource_size(r);
> +		uiomem->name = r->name;
>  		++uiomem;
>  	}
>  
> 
