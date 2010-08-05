Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760226Ab0HEQUJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 12:20:09 -0400
Received: from mga09.intel.com ([134.134.136.24]:38734 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759080Ab0HEQUF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 12:20:05 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.55,323,1278313200"; 
   d="scan'208";a="644972086"
Date: Thu, 5 Aug 2010 18:20:07 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: Re: [PATCH] wm8994-core: fix wm8994_device_init() return value
Message-ID: <20100805162006.GA7722@sortiz-mobl>
References: <1280886287.31990.1.camel@mola>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1280886287.31990.1.camel@mola>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Axel,

On Wed, Aug 04, 2010 at 09:44:47AM +0800, Axel Lin wrote:
> wm8994_device_init() will return 0 in the case of kzalloc fail
> in current implementation.
> This patch fixes the return value.
Patch applied, thanks a lot.

Cheers,
Samuel.

 
> Signed-off-by: Axel Lin <axel.lin@gmail.com>
> ---
>  drivers/mfd/wm8994-core.c |    4 +++-
>  1 files changed, 3 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/mfd/wm8994-core.c b/drivers/mfd/wm8994-core.c
> index ec71c93..69533f5 100644
> --- a/drivers/mfd/wm8994-core.c
> +++ b/drivers/mfd/wm8994-core.c
> @@ -326,8 +326,10 @@ static int wm8994_device_init(struct wm8994 *wm8994, unsigned long id, int irq)
>  	wm8994->supplies = kzalloc(sizeof(struct regulator_bulk_data) *
>  				   ARRAY_SIZE(wm8994_main_supplies),
>  				   GFP_KERNEL);
> -	if (!wm8994->supplies)
> +	if (!wm8994->supplies) {
> +		ret = -ENOMEM;
>  		goto err;
> +	}
>  
>  	for (i = 0; i < ARRAY_SIZE(wm8994_main_supplies); i++)
>  		wm8994->supplies[i].supply = wm8994_main_supplies[i];
> -- 
> 1.5.4.3
> 
> 
> 

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
