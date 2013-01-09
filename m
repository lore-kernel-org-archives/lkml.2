Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757904Ab3AIOMT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 09:12:19 -0500
Received: from mga01.intel.com ([192.55.52.88]:43946 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757809Ab3AIOMS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 09:12:18 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,438,1355126400"; 
   d="scan'208";a="271805411"
Date: Wed, 9 Jan 2013 05:47:57 -0800
From: Vinod Koul <vinod.koul@intel.com>
To: Andy Shevchenko <andriy.shevchenko@linux.jf.intel.com>
Cc: linux-kernel@vger.kernel.org, Viresh Kumar <viresh.kumar@linaro.org>,
        spear-devel <spear-devel@list.st.com>
Subject: Re: [resend][PATCH 01/16] dw_dmac: call .probe after we have a
 device in place
Message-ID: <20130109134757.GN19691@intel.com>
References: <20130108155423.GJ19691@intel.com>
 <1357719435-29955-1-git-send-email-andriy.shevchenko@linux.intel.com>
 <1357719435-29955-2-git-send-email-andriy.shevchenko@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1357719435-29955-2-git-send-email-andriy.shevchenko@linux.intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 09, 2013 at 10:17:00AM +0200, Andy Shevchenko wrote:
> If we don't yet have the platform device for the driver when it is being loaded
> we fail to probe the driver. So instead of calling probe() directly we call
> platform_driver_register(). It will call the probe() immediately if we have the
> device but also makes the driver to work on platforms where the platform device
> is created later.
Why wont you have the platform device? Is this only due to your approach of
creating the device in PCI probe?
> 
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
> ---
>  drivers/dma/dw_dmac.c |    3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/dma/dw_dmac.c b/drivers/dma/dw_dmac.c
> index 476e9c8..b5f21ba 100644
> --- a/drivers/dma/dw_dmac.c
> +++ b/drivers/dma/dw_dmac.c
> @@ -1829,6 +1829,7 @@ MODULE_DEVICE_TABLE(of, dw_dma_id_table);
>  #endif
>  
>  static struct platform_driver dw_driver = {
> +	.probe		= dw_probe,
>  	.remove		= dw_remove,
>  	.shutdown	= dw_shutdown,
>  	.driver = {
> @@ -1840,7 +1841,7 @@ static struct platform_driver dw_driver = {
>  
>  static int __init dw_init(void)
>  {
> -	return platform_driver_probe(&dw_driver, dw_probe);
> +	return platform_driver_register(&dw_driver);
>  }
>  subsys_initcall(dw_init);
>  
> -- 
> 1.7.10.4
> 
