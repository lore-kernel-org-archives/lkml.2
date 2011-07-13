Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752757Ab1GMWmp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jul 2011 18:42:45 -0400
Received: from mga11.intel.com ([192.55.52.93]:18357 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752612Ab1GMWmo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jul 2011 18:42:44 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,527,1304319600"; 
   d="scan'208";a="27622354"
Subject: Re: [PATCH] dma: mv_xor: use resource_size()
From: "Koul, Vinod" <vinod.koul@intel.com>
To: H Hartley Sweeten <hartleys@visionengravers.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, dan.j.williams@intel.com
In-Reply-To: <201106061349.00474.hartleys@visionengravers.com>
References: <201106061349.00474.hartleys@visionengravers.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 14 Jul 2011 03:32:15 +0530
Message-ID: <1310594535.1536.20.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-06-06 at 13:49 -0700, H Hartley Sweeten wrote:
> Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
> Cc: Dan Williams <dan.j.williams@intel.com> (supporter:ASYNCHRONOUS TRAN...)
> Cc: Vinod Koul <vinod.koul@intel.com> (supporter:DMA GENERIC OFFLO...)
> 
> ---
> 
> diff --git a/drivers/dma/mv_xor.c b/drivers/dma/mv_xor.c
> index 954e334..9a353c2 100644
> --- a/drivers/dma/mv_xor.c
> +++ b/drivers/dma/mv_xor.c
> @@ -1305,7 +1305,7 @@ static int mv_xor_shared_probe(struct platform_device *pdev)
>  		return -ENODEV;
>  
>  	msp->xor_base = devm_ioremap(&pdev->dev, res->start,
> -				     res->end - res->start + 1);
> +				     resource_size(res));
>  	if (!msp->xor_base)
>  		return -EBUSY;
>  
> @@ -1314,7 +1314,7 @@ static int mv_xor_shared_probe(struct platform_device *pdev)
>  		return -ENODEV;
>  
>  	msp->xor_high_base = devm_ioremap(&pdev->dev, res->start,
> -					  res->end - res->start + 1);
> +					  resource_size(res));
>  	if (!msp->xor_high_base)
>  		return -EBUSY;
>  
Applied thanks

-- 
~Vinod

