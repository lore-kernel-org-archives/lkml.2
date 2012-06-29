Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932383Ab2F2QOz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2012 12:14:55 -0400
Received: from mga14.intel.com ([143.182.124.37]:45054 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932140Ab2F2QOy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2012 12:14:54 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="162291392"
Date: Fri, 29 Jun 2012 18:26:01 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Chanwoo Choi <cw00.choi@samsung.com>,
        Myungjoo Ham <myungjoo.ham@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: Re: [PATCH 2/2] mfd: max77693: fix irq leak and wrong kfree call
Message-ID: <20120629162601.GT22806@sortiz-mobl>
References: <1339115669.4310.6.camel@phoenix>
 <1339115737.4310.7.camel@phoenix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1339115737.4310.7.camel@phoenix>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Axel,

On Fri, Jun 08, 2012 at 08:35:37AM +0800, Axel Lin wrote:
> We need to call max77693_irq_exit() in max77693_i2c_probe error patch and
> max77693_i2c_remove.
> 
> Current code already uses devm_kzalloc() to allocate memory for max77693.
> Thus we should not call kfree(max77693), otherwise we got double free.
> 
> Signed-off-by: Axel Lin <axel.lin@gmail.com>
> ---
>  drivers/mfd/max77693.c |    9 +++++----
>  1 file changed, 5 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/mfd/max77693.c b/drivers/mfd/max77693.c
> index 4055bc2..4251757 100644
> --- a/drivers/mfd/max77693.c
> +++ b/drivers/mfd/max77693.c
> @@ -122,7 +122,7 @@ static int max77693_i2c_probe(struct i2c_client *i2c,
>  	max77693->regmap = devm_regmap_init_i2c(i2c, &max77693_regmap_config);
>  	if (IS_ERR(max77693->regmap)) {
>  		ret = PTR_ERR(max77693->regmap);
> -		dev_err(max77693->dev,"failed to allocate register map: %d\n",
> +		dev_err(max77693->dev, "failed to allocate register map: %d\n",
>  				ret);
>  		goto err_regmap;
>  	}
This is an unrelated change. I applied this patch except for this chunk.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
