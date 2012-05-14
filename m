Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932409Ab2ENV0P (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 17:26:15 -0400
Received: from www.hansjkoch.de ([178.63.77.200]:49032 "EHLO www.hansjkoch.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932258Ab2ENV0O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 17:26:14 -0400
X-Greylist: delayed 1779 seconds by postgrey-1.27 at vger.kernel.org; Mon, 14 May 2012 17:26:14 EDT
Date: Mon, 14 May 2012 22:56:28 +0200
From: "Hans J. Koch" <hjk@hansjkoch.de>
To: Benedikt Spranger <b.spranger@linutronix.de>
Cc: hjk@hansjkoch.de, gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        magnus.damm@gmail.com
Subject: Re: [PATCH] uio_pdrv_genirq: get irq through platform resource if
 not set otherwise
Message-ID: <20120514205627.GC6153@local>
References: <1337014097-5034-1-git-send-email-b.spranger@linutronix.de>
 <1337014097-5034-2-git-send-email-b.spranger@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1337014097-5034-2-git-send-email-b.spranger@linutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 14, 2012 at 06:48:17PM +0200, Benedikt Spranger wrote:
> Platform devices are configured through platform resources. The interrupt
> in the driver uio_pdrv_genirq is instead configured through a side channel
> i.e. the platform data structure. Make it possible to use the generic
> configuration scheme via platform resource.

Looks alright to me.

> 
> Signed-off-by: Benedikt Spranger <b.spranger@linutronix.de>

Signed-off-by: "Hans J. Koch" <hjk@hansjkoch.de>

> ---
>  drivers/uio/uio_pdrv_genirq.c |    8 ++++++++
>  1 files changed, 8 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/uio/uio_pdrv_genirq.c b/drivers/uio/uio_pdrv_genirq.c
> index b98371d..42202cd 100644
> --- a/drivers/uio/uio_pdrv_genirq.c
> +++ b/drivers/uio/uio_pdrv_genirq.c
> @@ -146,6 +146,14 @@ static int uio_pdrv_genirq_probe(struct platform_device *pdev)
>  	priv->flags = 0; /* interrupt is enabled to begin with */
>  	priv->pdev = pdev;
>  
> +	if (!uioinfo->irq) {
> +		ret = platform_get_irq(pdev, 0);
> +		if (ret < 0) {
> +			dev_err(&pdev->dev, "failed to get IRQ\n");
> +			goto bad0;
> +		}
> +		uioinfo->irq = ret;
> +	}
>  	uiomem = &uioinfo->mem[0];
>  
>  	for (i = 0; i < pdev->num_resources; ++i) {
> -- 
> 1.7.9.1
> 
> 
