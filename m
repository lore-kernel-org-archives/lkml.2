Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753948Ab2KGDcT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2012 22:32:19 -0500
Received: from mga01.intel.com ([192.55.52.88]:8519 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753724Ab2KGDcP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2012 22:32:15 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,725,1344236400"; 
   d="scan'208";a="245117918"
Message-ID: <1352259132.2137.14.camel@rzhang1-mobl4>
Subject: Re: [PATCH] thermal: rcar_thermal: remove explicitly used
 devm_kfree/iounap()
From: Zhang Rui <rui.zhang@intel.com>
To: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Kuninori Morimoto <kuninori.morimoto.gx@gmail.com>,
        linux-kernel@vger.kernel.org
Date: Wed, 07 Nov 2012 11:32:12 +0800
In-Reply-To: <87ehlgrque.wl%kuninori.morimoto.gx@renesas.com>
References: <1345566696-21164-1-git-send-email-develkernel412222@gmail.com>
	 <87ehlgrque.wl%kuninori.morimoto.gx@renesas.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 2012-10-02 at 23:51 -0700, Kuninori Morimoto wrote:
> devm_kfree and devm_iounmap should not have to be explicitly used
> 
> Signed-off-by: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>

applied to thermal-next.

thanks,
rui
> ---
> This patch is based on Devendra's
> [PATCH] thermal: solve compilation errors in rcar_thermal
> 
>  drivers/thermal/rcar_thermal.c |   18 ++----------------
>  1 file changed, 2 insertions(+), 16 deletions(-)
> 
> diff --git a/drivers/thermal/rcar_thermal.c b/drivers/thermal/rcar_thermal.c
> index 762f637..81dce23 100644
> --- a/drivers/thermal/rcar_thermal.c
> +++ b/drivers/thermal/rcar_thermal.c
> @@ -185,7 +185,6 @@ static int rcar_thermal_probe(struct platform_device *pdev)
>  	struct thermal_zone_device *zone;
>  	struct rcar_thermal_priv *priv;
>  	struct resource *res;
> -	int ret;
>  
>  	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
>  	if (!res) {
> @@ -206,16 +205,14 @@ static int rcar_thermal_probe(struct platform_device *pdev)
>  					  res->start, resource_size(res));
>  	if (!priv->base) {
>  		dev_err(&pdev->dev, "Unable to ioremap thermal register\n");
> -		ret = -ENOMEM;
> -		goto error_free_priv;
> +		return -ENOMEM;
>  	}
>  
>  	zone = thermal_zone_device_register("rcar_thermal", 0, 0, priv,
>  				    &rcar_thermal_zone_ops, NULL, 0, 0);
>  	if (IS_ERR(zone)) {
>  		dev_err(&pdev->dev, "thermal zone device is NULL\n");
> -		ret = PTR_ERR(zone);
> -		goto error_iounmap;
> +		return PTR_ERR(zone);
>  	}
>  
>  	platform_set_drvdata(pdev, zone);
> @@ -223,26 +220,15 @@ static int rcar_thermal_probe(struct platform_device *pdev)
>  	dev_info(&pdev->dev, "proved\n");
>  
>  	return 0;
> -
> -error_iounmap:
> -	devm_iounmap(&pdev->dev, priv->base);
> -error_free_priv:
> -	devm_kfree(&pdev->dev, priv);
> -
> -	return ret;
>  }
>  
>  static int rcar_thermal_remove(struct platform_device *pdev)
>  {
>  	struct thermal_zone_device *zone = platform_get_drvdata(pdev);
> -	struct rcar_thermal_priv *priv = zone->devdata;
>  
>  	thermal_zone_device_unregister(zone);
>  	platform_set_drvdata(pdev, NULL);
>  
> -	devm_iounmap(&pdev->dev, priv->base);
> -	devm_kfree(&pdev->dev, priv);
> -
>  	return 0;
>  }
>  


