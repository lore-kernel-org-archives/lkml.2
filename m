Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756922Ab0KBHkq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Nov 2010 03:40:46 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:41088 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752043Ab0KBHkk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Nov 2010 03:40:40 -0400
Date: Tue, 2 Nov 2010 08:40:38 +0100
From: Pengutronix <s.hauer@pengutronix.de>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Dan Williams <dan.j.williams@intel.com>,
        Thiago Farina <tfransosi@gmail.com>
Subject: Re: [PATCH Resend] dma: imx-dma: fix imxdma_probe error path
Message-ID: <20101102074038.GC6017@pengutronix.de>
References: <1288662971.20990.7.camel@mola>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1288662971.20990.7.camel@mola>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 08:40:18 up 121 days, 22:51, 37 users,  load average: 0.21, 0.19,
	0.17
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 02, 2010 at 09:56:11AM +0800, Axel Lin wrote:
> Otherwise, the i variable will be -1 inside the latest iteration of the while loop.
> 
> Signed-off-by: Axel Lin <axel.lin@gmail.com>

Acked-by: Sascha Hauer <s.hauer@pengutronix.de>

> ---
> This resend only update the commit log.
> Regards,
> Axel
> 
>  drivers/dma/imx-dma.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/dma/imx-dma.c b/drivers/dma/imx-dma.c
> index f629e49..e53d438 100644
> --- a/drivers/dma/imx-dma.c
> +++ b/drivers/dma/imx-dma.c
> @@ -379,7 +379,7 @@ static int __init imxdma_probe(struct platform_device *pdev)
>  	return 0;
>  
>  err_init:
> -	while (i-- >= 0) {
> +	while (--i >= 0) {
>  		struct imxdma_channel *imxdmac = &imxdma->channel[i];
>  		imx_dma_free(imxdmac->imxdma_channel);
>  	}
> -- 
> 1.7.2
> 
> 
> 
> 

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
