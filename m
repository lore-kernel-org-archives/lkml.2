Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753533Ab0JRICk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 04:02:40 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:59916 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752853Ab0JRICi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 04:02:38 -0400
Date: Mon, 18 Oct 2010 10:02:31 +0200
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Vasiliy Kulikov <segooon@gmail.com>
Cc: kernel-janitors@vger.kernel.org, Dan Williams <dan.j.williams@intel.com>,
        Linus Walleij <linus.walleij@stericsson.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] dma: imx-dma: fix signedness bug
Message-ID: <20101018080230.GH28242@pengutronix.de>
References: <1287327110-9158-1-git-send-email-segooon@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1287327110-9158-1-git-send-email-segooon@gmail.com>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 10:02:13 up 106 days, 23:13, 24 users,  load average: 0.35, 0.35,
	0.36
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 17, 2010 at 06:51:50PM +0400, Vasiliy Kulikov wrote:
> mxdmac->channel was unsigned, so check (imxdmac->channel < 0) for
> failed imx_dma_request_by_prio() made no sence.  Explicitly check
> signed values.
> 
> Signed-off-by: Vasiliy Kulikov <segooon@gmail.com>

Acked-by: Sascha Hauer <s.hauer@pengutronix.de>

> ---
>  drivers/dma/imx-dma.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/dma/imx-dma.c b/drivers/dma/imx-dma.c
> index 346be62..75d870f 100644
> --- a/drivers/dma/imx-dma.c
> +++ b/drivers/dma/imx-dma.c
> @@ -335,7 +335,7 @@ static int __init imxdma_probe(struct platform_device *pdev)
>  
>  		imxdmac->imxdma_channel = imx_dma_request_by_prio("dmaengine",
>  				DMA_PRIO_MEDIUM);
> -		if (imxdmac->channel < 0)
> +		if ((int)imxdmac->channel < 0)
>  			goto err_init;
>  
>  		imx_dma_setup_handlers(imxdmac->imxdma_channel,
> -- 
> 1.7.0.4
> 
> 

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
