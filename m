Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757149Ab1FFIuU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 04:50:20 -0400
Received: from mga14.intel.com ([143.182.124.37]:19150 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757053Ab1FFIuQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 04:50:16 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,325,1304319600"; 
   d="scan'208";a="7656450"
Subject: Re: [PATCH] dma: ipu_idmac.c: use resource_size in ioremap
From: "Koul, Vinod" <vinod.koul@intel.com>
To: H Hartley Sweeten <hartleys@visionengravers.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, dan.j.williams@intel.com,
        g.liakhovetski@gmx.de, agust@denx.de
In-Reply-To: <201106011510.30560.hartleys@visionengravers.com>
References: <201106011510.30560.hartleys@visionengravers.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 06 Jun 2011 13:45:24 +0530
Message-ID: <1307348124.10976.81.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-06-01 at 15:10 -0700, H Hartley Sweeten wrote:
> Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
> Cc: Dan Williams <dan.j.williams@intel.com>
> Cc: Vinod Koul <vinod.koul@intel.com>
> Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> Cc: Anatolij Gustschin <agust@denx.de>
> 
> ---
> 
> diff --git a/drivers/dma/ipu/ipu_idmac.c b/drivers/dma/ipu/ipu_idmac.c
> index c1a125e..25447a8 100644
> --- a/drivers/dma/ipu/ipu_idmac.c
> +++ b/drivers/dma/ipu/ipu_idmac.c
> @@ -1705,16 +1705,14 @@ static int __init ipu_probe(struct platform_device *pdev)
>  		ipu_data.irq_fn, ipu_data.irq_err, ipu_data.irq_base);
>  
>  	/* Remap IPU common registers */
> -	ipu_data.reg_ipu = ioremap(mem_ipu->start,
> -				   mem_ipu->end - mem_ipu->start + 1);
> +	ipu_data.reg_ipu = ioremap(mem_ipu->start, resource_size(mem_ipu));
>  	if (!ipu_data.reg_ipu) {
>  		ret = -ENOMEM;
>  		goto err_ioremap_ipu;
>  	}
>  
>  	/* Remap Image Converter and Image DMA Controller registers */
> -	ipu_data.reg_ic = ioremap(mem_ic->start,
> -				  mem_ic->end - mem_ic->start + 1);
> +	ipu_data.reg_ic = ioremap(mem_ic->start, resource_size(mem_ic));
>  	if (!ipu_data.reg_ic) {
>  		ret = -ENOMEM;
>  		goto err_ioremap_ic;
Applied, Thanks

-- 
~Vinod

