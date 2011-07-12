Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753633Ab1GLNve (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jul 2011 09:51:34 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:54534 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753209Ab1GLNvd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jul 2011 09:51:33 -0400
Date: Tue, 12 Jul 2011 15:51:28 +0200
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Dan Williams <dan.j.williams@intel.com>,
        Vinod Koul <vinod.koul@intel.com>
Subject: Re: [PATCH] dmaengine: imx-sdma: return proper error if kzalloc fails
Message-ID: <20110712135128.GV6069@pengutronix.de>
References: <1310475613.2618.0.camel@phoenix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1310475613.2618.0.camel@phoenix>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 15:51:10 up 20 days, 19:38, 60 users,  load average: 1.49, 1.40,
 2.20
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 12, 2011 at 09:00:13PM +0800, Axel Lin wrote:
> Signed-off-by: Axel Lin <axel.lin@gmail.com>
> ---
>  drivers/dma/imx-sdma.c |    4 +++-
>  1 files changed, 3 insertions(+), 1 deletions(-)

Acked-by: Sascha Hauer <s.hauer@pengutronix.de>

> 
> diff --git a/drivers/dma/imx-sdma.c b/drivers/dma/imx-sdma.c
> index 1ea47db..f96d038 100644
> --- a/drivers/dma/imx-sdma.c
> +++ b/drivers/dma/imx-sdma.c
> @@ -1281,8 +1281,10 @@ static int __init sdma_probe(struct platform_device *pdev)
>  		goto err_request_irq;
>  
>  	sdma->script_addrs = kzalloc(sizeof(*sdma->script_addrs), GFP_KERNEL);
> -	if (!sdma->script_addrs)
> +	if (!sdma->script_addrs) {
> +		ret = -ENOMEM;
>  		goto err_alloc;
> +	}
>  
>  	sdma->version = pdata->sdma_version;
>  
> -- 
> 1.7.4.1
> 
> 
> 
> 

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
