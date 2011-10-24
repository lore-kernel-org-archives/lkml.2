Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755734Ab1JXLp1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Oct 2011 07:45:27 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:38010 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755644Ab1JXLp0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Oct 2011 07:45:26 -0400
Date: Mon, 24 Oct 2011 13:45:07 +0200
From: Grant Likely <grant.likely@secretlab.ca>
To: Shubhrajyoti D <shubhrajyoti@ti.com>
Cc: spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] OMAP: SPI: Fix the trying to free nonexistent resource
 error
Message-ID: <20111024114507.GK8708@ponder.secretlab.ca>
References: <1319451864-8212-1-git-send-email-shubhrajyoti@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1319451864-8212-1-git-send-email-shubhrajyoti@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 24, 2011 at 03:54:24PM +0530, Shubhrajyoti D wrote:
> Currently there is a request_mem_region(r->start, ..
> followed by r->start += pdata->regs_offset;
> 
> And then in remove
> 
>    r = platform_get_resource(pdev, IORESOURCE_MEM, 0);
>    release_mem_region(r->start, resource_size(r));
> 
> Here the offset addition is not taken care. Fix the code for the
> same.
> 
> Signed-off-by: Shubhrajyoti D <shubhrajyoti@ti.com>

Applied, thanks.

g.

> ---
>  drivers/spi/spi-omap2-mcspi.c |    6 +++---
>  1 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/spi/spi-omap2-mcspi.c b/drivers/spi/spi-omap2-mcspi.c
> index 06dc9a9..471b0f3 100644
> --- a/drivers/spi/spi-omap2-mcspi.c
> +++ b/drivers/spi/spi-omap2-mcspi.c
> @@ -1123,15 +1123,15 @@ static int __init omap2_mcspi_probe(struct platform_device *pdev)
>  		status = -ENODEV;
>  		goto err1;
>  	}
> +	r->start += pdata->regs_offset;
> +	r->end += pdata->regs_offset;
> +	mcspi->phys = r->start;
>  	if (!request_mem_region(r->start, resource_size(r),
>  				dev_name(&pdev->dev))) {
>  		status = -EBUSY;
>  		goto err1;
>  	}
>  
> -	r->start += pdata->regs_offset;
> -	r->end += pdata->regs_offset;
> -	mcspi->phys = r->start;
>  	mcspi->base = ioremap(r->start, resource_size(r));
>  	if (!mcspi->base) {
>  		dev_dbg(&pdev->dev, "can't ioremap MCSPI\n");
> -- 
> 1.7.1
> 
> 
> ------------------------------------------------------------------------------
> The demand for IT networking professionals continues to grow, and the
> demand for specialized networking skills is growing even more rapidly.
> Take a complimentary Learning@Cisco Self-Assessment and learn 
> about Cisco certifications, training, and career opportunities. 
> http://p.sf.net/sfu/cisco-dev2dev
> _______________________________________________
> spi-devel-general mailing list
> spi-devel-general@lists.sourceforge.net
> https://lists.sourceforge.net/lists/listinfo/spi-devel-general
