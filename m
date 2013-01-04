Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753389Ab3ADH1h (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2013 02:27:37 -0500
Received: from mga01.intel.com ([192.55.52.88]:20564 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752316Ab3ADH1g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2013 02:27:36 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,408,1355126400"; 
   d="scan'208";a="272754603"
Message-ID: <1357284451.2152.1.camel@rzhang1-mobl4>
Subject: Re: [PATCH] drivers/thermal/spear_thermal.c: use devm_clk_get
From: Zhang Rui <rui.zhang@intel.com>
To: Julia Lawall <Julia.Lawall@lip6.fr>
Cc: kernel-janitors@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Fri, 04 Jan 2013 15:27:31 +0800
In-Reply-To: <1354876172-1634-1-git-send-email-Julia.Lawall@lip6.fr>
References: <1354876172-1634-1-git-send-email-Julia.Lawall@lip6.fr>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-12-07 at 11:29 +0100, Julia Lawall wrote:
> From: Julia Lawall <Julia.Lawall@lip6.fr>
> 
> devm_clk_get allocates a resource that is released when a driver detaches.
> This patch uses devm_clk_get for data that is allocated in the probe
> function of a platform device and is only released in the remove function.
> 
> Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>
> 
applied to thermal-next.

thanks,
rui

> ---
> I was not able to compile this code.  At one point, devm_clk_get was not
> supported for all architectures.  If that is still the case, and the code
> doesn't compile, then just ignore the patch.
> 
>  drivers/thermal/spear_thermal.c |    7 ++-----
>  1 file changed, 2 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/thermal/spear_thermal.c b/drivers/thermal/spear_thermal.c
> index 6b2d8b2..3c5ee56 100644
> --- a/drivers/thermal/spear_thermal.c
> +++ b/drivers/thermal/spear_thermal.c
> @@ -131,7 +131,7 @@ static int spear_thermal_probe(struct platform_device *pdev)
>  		return -ENOMEM;
>  	}
>  
> -	stdev->clk = clk_get(&pdev->dev, NULL);
> +	stdev->clk = devm_clk_get(&pdev->dev, NULL);
>  	if (IS_ERR(stdev->clk)) {
>  		dev_err(&pdev->dev, "Can't get clock\n");
>  		return PTR_ERR(stdev->clk);
> @@ -140,7 +140,7 @@ static int spear_thermal_probe(struct platform_device *pdev)
>  	ret = clk_enable(stdev->clk);
>  	if (ret) {
>  		dev_err(&pdev->dev, "Can't enable clock\n");
> -		goto put_clk;
> +		return ret;
>  	}
>  
>  	stdev->flags = val;
> @@ -163,8 +163,6 @@ static int spear_thermal_probe(struct platform_device *pdev)
>  
>  disable_clk:
>  	clk_disable(stdev->clk);
> -put_clk:
> -	clk_put(stdev->clk);
>  
>  	return ret;
>  }
> @@ -183,7 +181,6 @@ static int spear_thermal_exit(struct platform_device *pdev)
>  	writel_relaxed(actual_mask & ~stdev->flags, stdev->thermal_base);
>  
>  	clk_disable(stdev->clk);
> -	clk_put(stdev->clk);
>  
>  	return 0;
>  }
> 


