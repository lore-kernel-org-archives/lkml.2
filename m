Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757625Ab0JUW6j (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 18:58:39 -0400
Received: from mga03.intel.com ([143.182.124.21]:56164 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756309Ab0JUW6i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 18:58:38 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.58,219,1286175600"; 
   d="scan'208";a="339013465"
Date: Fri, 22 Oct 2010 00:58:34 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: Re: [PATCH] mfd: max8998 cleanups
Message-ID: <20101021225834.GF11685@sortiz-mobl>
References: <1287565604.7849.4.camel@mola>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1287565604.7849.4.camel@mola>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Axel,

On Wed, Oct 20, 2010 at 05:06:44PM +0800, Axel Lin wrote:
> This patch includes below fixes:
> 1. i2c_smbus_write_byte_data() returns zero or negative value,
>    therefore no need to check if ret is greater than zero or not.
> 2. Properly free irq and unregister max8998->rtc device in
>    max8998_i2c_probe() error path and max8998_i2c_remove().
The fixes make sense, I'd appreciate to get 2 separate patches for them
though.

Cheers,
Samuel.


> Signed-off-by: Axel Lin <axel.lin@gmail.com>
> ---
>  drivers/mfd/max8998.c |    6 ++++--
>  1 files changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/mfd/max8998.c b/drivers/mfd/max8998.c
> index a720f41..bb9977b 100644
> --- a/drivers/mfd/max8998.c
> +++ b/drivers/mfd/max8998.c
> @@ -110,8 +110,6 @@ int max8998_update_reg(struct i2c_client *i2c, u8 reg, u8 val, u8 mask)
>  		u8 old_val = ret & 0xff;
>  		u8 new_val = (val & mask) | (old_val & (~mask));
>  		ret = i2c_smbus_write_byte_data(i2c, reg, new_val);
> -		if (ret >= 0)
> -			ret = 0;
>  	}
>  	mutex_unlock(&max8998->iolock);
>  	return ret;
> @@ -155,6 +153,8 @@ static int max8998_i2c_probe(struct i2c_client *i2c,
>  
>  err:
>  	mfd_remove_devices(max8998->dev);
> +	max8998_irq_exit(max8998);
> +	i2c_unregister_device(max8998->rtc);
>  	kfree(max8998);
>  	return ret;
>  }
> @@ -164,6 +164,8 @@ static int max8998_i2c_remove(struct i2c_client *i2c)
>  	struct max8998_dev *max8998 = i2c_get_clientdata(i2c);
>  
>  	mfd_remove_devices(max8998->dev);
> +	max8998_irq_exit(max8998);
> +	i2c_unregister_device(max8998->rtc);
>  	kfree(max8998);
>  
>  	return 0;
> -- 
> 1.7.2
> 
> 
> 

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
