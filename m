Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758785Ab0GBPQq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jul 2010 11:16:46 -0400
Received: from mga11.intel.com ([192.55.52.93]:38549 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756554Ab0GBPQo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jul 2010 11:16:44 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.53,526,1272870000"; 
   d="scan'208";a="582215268"
Date: Fri, 2 Jul 2010 17:16:40 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Magnus Damm <damm@opensource.se>,
       H Hartley Sweeten <hsweeten@visionengravers.com>,
       Julia Lawall <julia@diku.dk>, Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH] t7l66xb: properly free clk32k clock source
Message-ID: <20100702151639.GB2960@sortiz-mobl>
References: <1277977430.9342.5.camel@mola>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1277977430.9342.5.camel@mola>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alex,

On Thu, Jul 01, 2010 at 05:43:50PM +0800, Axel Lin wrote:
> This patch includes below fixes to properly free clk32k clock source:
> 1. remove a redundant clk_put in t7l66xb_probe error path
> 2. add missing clk_disable(t7l66xb->clk32k) and clk_put(t7l66xb->clk32k)
>    to properly free the clock source.
Patch applied to my for-next branch. This almost looks like 2.6.35 material
though.

Cheers,
Samuel.


> Signed-off-by: Axel Lin <axel.lin@gmail.com>
> ---
>  drivers/mfd/t7l66xb.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/mfd/t7l66xb.c b/drivers/mfd/t7l66xb.c
> index 5041d33..006c121 100644
> --- a/drivers/mfd/t7l66xb.c
> +++ b/drivers/mfd/t7l66xb.c
> @@ -350,7 +350,6 @@ static int t7l66xb_probe(struct platform_device *dev)
>  	t7l66xb->clk48m = clk_get(&dev->dev, "CLK_CK48M");
>  	if (IS_ERR(t7l66xb->clk48m)) {
>  		ret = PTR_ERR(t7l66xb->clk48m);
> -		clk_put(t7l66xb->clk32k);
>  		goto err_clk48m_get;
>  	}
>  
> @@ -425,6 +424,8 @@ static int t7l66xb_remove(struct platform_device *dev)
>  	ret = pdata->disable(dev);
>  	clk_disable(t7l66xb->clk48m);
>  	clk_put(t7l66xb->clk48m);
> +	clk_disable(t7l66xb->clk32k);
> +	clk_put(t7l66xb->clk32k);
>  	t7l66xb_detach_irq(dev);
>  	iounmap(t7l66xb->scr);
>  	release_resource(&t7l66xb->rscr);
> -- 
> 1.5.4.3
> 
> 
> 

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
