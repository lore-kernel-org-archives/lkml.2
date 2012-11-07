Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753566Ab2KGDeo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2012 22:34:44 -0500
Received: from mga03.intel.com ([143.182.124.21]:37871 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753144Ab2KGDen (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2012 22:34:43 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,725,1344236400"; 
   d="scan'208";a="165339504"
Message-ID: <1352259279.2137.15.camel@rzhang1-mobl4>
Subject: Re: [PATCH] thermal: rcar: fixup compilation errors
From: Zhang Rui <rui.zhang@intel.com>
To: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        Devendra Naga <develkernel412222@gmail.com>
Date: Wed, 07 Nov 2012 11:34:39 +0800
In-Reply-To: <87391ot63w.wl%kuninori.morimoto.gx@renesas.com>
References: <1345566696-21164-1-git-send-email-develkernel412222@gmail.com>
	 <87391ot63w.wl%kuninori.morimoto.gx@renesas.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-10-09 at 01:14 -0700, Kuninori Morimoto wrote:
> This patch fixup following error
> 
> ${LINUX}/drivers/thermal/rcar_thermal.c: In function 'rcar_thermal_probe':
> ${LINUX}/drivers/thermal/rcar_thermal.c:214:9: warning: passing argument 3 \
> 	of 'thermal_zone_device_register' makes integer from pointer without\
> 	a cast [enabled by default]
> ${LINUX}/include/linux/thermal.h:215:29: note: expected 'int' but argument \
> 	is of type 'struct rcar_thermal_priv *'
> ${LINUX}/drivers/thermal/rcar_thermal.c:214:9:\
> 	error: too few arguments to function 'thermal_zone_device_register'
> 
> Signed-off-by: Devendra Naga <develkernel412222@gmail.com>
> Signed-off-by: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>

shipped in 3.7-rc4.

thanks,
rui
> ---
> for linus/master branch
> 
>  drivers/thermal/rcar_thermal.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/thermal/rcar_thermal.c b/drivers/thermal/rcar_thermal.c
> index b13fe5d..762f637 100644
> --- a/drivers/thermal/rcar_thermal.c
> +++ b/drivers/thermal/rcar_thermal.c
> @@ -210,7 +210,7 @@ static int rcar_thermal_probe(struct platform_device *pdev)
>  		goto error_free_priv;
>  	}
>  
> -	zone = thermal_zone_device_register("rcar_thermal", 0, priv,
> +	zone = thermal_zone_device_register("rcar_thermal", 0, 0, priv,
>  				    &rcar_thermal_zone_ops, NULL, 0, 0);
>  	if (IS_ERR(zone)) {
>  		dev_err(&pdev->dev, "thermal zone device is NULL\n");


