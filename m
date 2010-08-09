Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755926Ab0HIJP2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Aug 2010 05:15:28 -0400
Received: from mga03.intel.com ([143.182.124.21]:41221 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755834Ab0HIJP1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Aug 2010 05:15:27 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.55,341,1278313200"; 
   d="scan'208";a="309715081"
Date: Mon, 9 Aug 2010 11:15:31 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@slimlogic.co.uk>
Subject: Re: [PATCH 1/4] mfd: max8998 - fix incorrect kfree(i2c) in
 i2c_driver probe callback handler
Message-ID: <20100809091530.GB2513@sortiz-mobl>
References: <1281336496.18804.2.camel@mola>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1281336496.18804.2.camel@mola>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Axel,

On Mon, Aug 09, 2010 at 02:48:16PM +0800, Axel Lin wrote:
> The i2c_client received in probe() should not be kfree()'d.
This should go through Liam's tree, I'm  CC'ing him to this thread.

Cheers,
Samuel.


> Signed-off-by: Axel Lin <axel.lin@gmail.com>
> ---
>  drivers/mfd/max8998.c |    4 +---
>  1 files changed, 1 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/mfd/max8998.c b/drivers/mfd/max8998.c
> index 0d68de2..73e6f5c 100644
> --- a/drivers/mfd/max8998.c
> +++ b/drivers/mfd/max8998.c
> @@ -89,10 +89,8 @@ static int max8998_i2c_probe(struct i2c_client *i2c,
>  	int ret = 0;
>  
>  	max8998 = kzalloc(sizeof(struct max8998_dev), GFP_KERNEL);
> -	if (max8998 == NULL) {
> -		kfree(i2c);
> +	if (max8998 == NULL)
>  		return -ENOMEM;
> -	}
>  
>  	i2c_set_clientdata(i2c, max8998);
>  	max8998->dev = &i2c->dev;
> -- 
> 1.5.4.3
> 
> 
> 

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
