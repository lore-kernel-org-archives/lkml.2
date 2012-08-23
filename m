Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933683Ab2HWUgZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2012 16:36:25 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:49160 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932493Ab2HWUgV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2012 16:36:21 -0400
X-Authenticated: #10250065
X-Provags-ID: V01U2FsdGVkX188KSUCajw8VerPeMRkzAqfLhnQfhj497Tb7P3+Zz
	Hq10UCGYQLsLpG
Message-ID: <5036943A.80103@gmx.de>
Date: Thu, 23 Aug 2012 20:36:10 +0000
From: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20120613 Icedove/3.0.11
MIME-Version: 1.0
To: Damien Cassou <damien.cassou@lifl.fr>
CC: kernel-janitors@vger.kernel.org, linux-fbdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/5] drivers/video/cobalt_lcdfb.c: use devm_ functions
References: <1343742860-16213-1-git-send-email-damien.cassou@lifl.fr> <1343742860-16213-4-git-send-email-damien.cassou@lifl.fr>
In-Reply-To: <1343742860-16213-4-git-send-email-damien.cassou@lifl.fr>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/31/2012 01:54 PM, Damien Cassou wrote:
> From: Damien Cassou <damien.cassou@lifl.fr>
> 
> The various devm_ functions allocate memory that is released when a driver
> detaches.  This patch uses these functions for data that is allocated in
> the probe function of a platform device and is only freed in the remove
> function.
> 
> Signed-off-by: Damien Cassou <damien.cassou@lifl.fr>

Applied.


Thanks,

Florian Tobias Schandinat

> 
> ---
>  drivers/video/cobalt_lcdfb.c |    5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/video/cobalt_lcdfb.c b/drivers/video/cobalt_lcdfb.c
> index eae46f6..01a4ee7 100644
> --- a/drivers/video/cobalt_lcdfb.c
> +++ b/drivers/video/cobalt_lcdfb.c
> @@ -348,7 +348,8 @@ static int __devinit cobalt_lcdfb_probe(struct platform_device *dev)
>  	}
>  
>  	info->screen_size = resource_size(res);
> -	info->screen_base = ioremap(res->start, info->screen_size);
> +	info->screen_base = devm_ioremap(&dev->dev, res->start,
> +					 info->screen_size);
>  	info->fbops = &cobalt_lcd_fbops;
>  	info->fix = cobalt_lcdfb_fix;
>  	info->fix.smem_start = res->start;
> @@ -359,7 +360,6 @@ static int __devinit cobalt_lcdfb_probe(struct platform_device *dev)
>  
>  	retval = register_framebuffer(info);
>  	if (retval < 0) {
> -		iounmap(info->screen_base);
>  		framebuffer_release(info);
>  		return retval;
>  	}
> @@ -380,7 +380,6 @@ static int __devexit cobalt_lcdfb_remove(struct platform_device *dev)
>  
>  	info = platform_get_drvdata(dev);
>  	if (info) {
> -		iounmap(info->screen_base);
>  		unregister_framebuffer(info);
>  		framebuffer_release(info);
>  	}
> 
> 

