Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752960Ab2JJJEM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 05:04:12 -0400
Received: from mga02.intel.com ([134.134.136.20]:14421 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752410Ab2JJJEJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 05:04:09 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,564,1344236400"; 
   d="scan'208";a="224934257"
Message-ID: <1349859841.10584.122.camel@smile>
Subject: Re: [PATCH 1/4] dmaengine: dw_dmac: use helper macro
 module_platform_driver()
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Viresh Kumar <viresh.linux@gmail.com>
Cc: Vinod Koul <vinod.koul@intel.com>, linux-kernel@vger.kernel.org,
        spear-devel <spear-devel@list.st.com>, balbi@ti.com,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>
Date: Wed, 10 Oct 2012 12:04:01 +0300
In-Reply-To: <1349178121-9105-2-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1349178121-9105-1-git-send-email-andriy.shevchenko@linux.intel.com>
	 <1349178121-9105-2-git-send-email-andriy.shevchenko@linux.intel.com>
Organization: Intel Finland Oy
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-10-02 at 14:41 +0300, Andy Shevchenko wrote: 
> From: Heikki Krogerus <heikki.krogerus@linux.intel.com>
> 
> Since v3.2 we have nice macro to define the platform driver's init and exit
> calls. This patch simplifies the dw_dmac driver by using that macro.

Actually we can't do this. It will break initialization of some other
drivers.


> 
> Signed-off-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> Reviewed-by: Felipe Balbi <balbi@ti.com>
> Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
> ---
>  drivers/dma/dw_dmac.c |   13 ++-----------
>  1 file changed, 2 insertions(+), 11 deletions(-)
> 
> diff --git a/drivers/dma/dw_dmac.c b/drivers/dma/dw_dmac.c
> index c4b0eb3..0b88ced 100644
> --- a/drivers/dma/dw_dmac.c
> +++ b/drivers/dma/dw_dmac.c
> @@ -1700,6 +1700,7 @@ MODULE_DEVICE_TABLE(of, dw_dma_id_table);
>  #endif
>  
>  static struct platform_driver dw_driver = {
> +	.probe		= dw_probe,
>  	.remove		= __devexit_p(dw_remove),
>  	.shutdown	= dw_shutdown,
>  	.driver = {
> @@ -1709,17 +1710,7 @@ static struct platform_driver dw_driver = {
>  	},
>  };
>  
> -static int __init dw_init(void)
> -{
> -	return platform_driver_probe(&dw_driver, dw_probe);
> -}
> -subsys_initcall(dw_init);
> -
> -static void __exit dw_exit(void)
> -{
> -	platform_driver_unregister(&dw_driver);
> -}
> -module_exit(dw_exit);
> +module_platform_driver(dw_driver);
>  
>  MODULE_LICENSE("GPL v2");
>  MODULE_DESCRIPTION("Synopsys DesignWare DMA Controller driver");

-- 
Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Intel Finland Oy
