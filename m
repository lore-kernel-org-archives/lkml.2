Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759365Ab1FARth (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 13:49:37 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:50612 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754754Ab1FARtf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 13:49:35 -0400
Date: Wed, 1 Jun 2011 19:49:15 +0200
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Julia Lawall <julia@diku.dk>
Cc: Sascha Hauer <kernel@pengutronix.de>, kernel-janitors@vger.kernel.org,
        Paul Mundt <lethal@linux-sh.org>, linux-fbdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 8/10] drivers/video/imxfb.c: add missing clk_put
Message-ID: <20110601174915.GL23771@pengutronix.de>
References: <1306948213-20767-8-git-send-email-julia@diku.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1306948213-20767-8-git-send-email-julia@diku.dk>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 19:48:54 up 6 days, 10:50, 13 users,  load average: 0.03, 0.33, 1.26
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 01, 2011 at 07:10:11PM +0200, Julia Lawall wrote:
> From: Julia Lawall <julia@diku.dk>
> 
> Reorder the labels at the end of the function to correspond to the order in
> which the resources are allocated.
> 
> A simplified version of the semantic match that finds this problem is as
> follows: (http://coccinelle.lip6.fr/)
> 
> // <smpl>
> @r exists@
> expression e1,e2;
> statement S;
> @@
> 
> e1 = clk_get@p1(...);
> ... when != e1 = e2
>     when != clk_put(e1)
>     when any
> if (...) { ... when != clk_put(e1)
>                when != if (...) { ... clk_put(e1) ... }
> * return@p3 ...;
>  } else S
> // </smpl>
> 
> Signed-off-by: Julia Lawall <julia@diku.dk>

Acked-by: Sascha Hauer <s.hauer@pengutronix.de>

> 
> ---
>  drivers/video/imxfb.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/video/imxfb.c b/drivers/video/imxfb.c
> index d2ccfd6..f135dbe 100644
> --- a/drivers/video/imxfb.c
> +++ b/drivers/video/imxfb.c
> @@ -856,10 +856,10 @@ failed_platform_init:
>  		dma_free_writecombine(&pdev->dev,fbi->map_size,fbi->map_cpu,
>  			fbi->map_dma);
>  failed_map:
> -	clk_put(fbi->clk);
> -failed_getclock:
>  	iounmap(fbi->regs);
>  failed_ioremap:
> +	clk_put(fbi->clk);
> +failed_getclock:
>  	release_mem_region(res->start, resource_size(res));
>  failed_req:
>  	kfree(info->pseudo_palette);
> 
> 

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
