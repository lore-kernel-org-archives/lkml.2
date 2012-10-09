Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756278Ab2JIPvX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 11:51:23 -0400
Received: from host-176-100-244-43.masterbit.su ([176.100.244.43]:49423 "EHLO
	tservice.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751115Ab2JIPvU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 11:51:20 -0400
Date: Tue, 9 Oct 2012 19:51:18 +0400
From: Evgeniy Polyakov <zbr@ioremap.net>
To: Wei Yongjun <weiyj.lk@gmail.com>
Cc: yongjun_wei@trendmicro.com.cn, linux-kernel@vger.kernel.org,
        Ben Gardner <bgardner@wabtec.com>, GregKH <greg@kroah.com>
Subject: Re: [PATCH] w1/ds2482: use module_i2c_driver to simplify the code
Message-ID: <20121009155118.GA29625@ioremap.net>
References: <CAPgLHd9u7-N=MVtP7d6QYTfeVL6CL3pc94Lrucp_NVDLo6yxPA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPgLHd9u7-N=MVtP7d6QYTfeVL6CL3pc94Lrucp_NVDLo6yxPA@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 08, 2012 at 10:06:07PM +0800, Wei Yongjun (weiyj.lk@gmail.com) wrote:
> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> 
> Use the module_i2c_driver() macro to make the code smaller
> and a bit simpler.
> 
> dpatch engine is used to auto generate this patch.
> (https://github.com/weiyj/dpatch)
> 
> Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Looks good for me, but I added Ben Gardner (original author) to hear
from him if it is ok.

Greg, please pull it into your tree, when things are settled.

Acked-by: Evgeniy Polyakov <zbr@ioremap.net>

> ---
>  drivers/w1/masters/ds2482.c | 13 +------------
>  1 file changed, 1 insertion(+), 12 deletions(-)
> 
> diff --git a/drivers/w1/masters/ds2482.c b/drivers/w1/masters/ds2482.c
> index e5f7441..6429b9e 100644
> --- a/drivers/w1/masters/ds2482.c
> +++ b/drivers/w1/masters/ds2482.c
> @@ -505,19 +505,8 @@ static int ds2482_remove(struct i2c_client *client)
>  	return 0;
>  }
>  
> -static int __init sensors_ds2482_init(void)
> -{
> -	return i2c_add_driver(&ds2482_driver);
> -}
> -
> -static void __exit sensors_ds2482_exit(void)
> -{
> -	i2c_del_driver(&ds2482_driver);
> -}
> +module_i2c_driver(ds2482_driver);
>  
>  MODULE_AUTHOR("Ben Gardner <bgardner@wabtec.com>");
>  MODULE_DESCRIPTION("DS2482 driver");
>  MODULE_LICENSE("GPL");
> -
> -module_init(sensors_ds2482_init);
> -module_exit(sensors_ds2482_exit);
> 

-- 
	Evgeniy Polyakov
