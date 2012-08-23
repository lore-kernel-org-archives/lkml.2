Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756891Ab2HWUaN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2012 16:30:13 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:39542 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753069Ab2HWUaI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2012 16:30:08 -0400
X-Authenticated: #10250065
X-Provags-ID: V01U2FsdGVkX1//q7MUhTv/H1eYkFmTv80nKLHk3CjCnREsSYG528
	0HgINNiEfWSTYu
Message-ID: <503692CA.8080608@gmx.de>
Date: Thu, 23 Aug 2012 20:30:02 +0000
From: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20120613 Icedove/3.0.11
MIME-Version: 1.0
To: Julia Lawall <Julia.Lawall@lip6.fr>
CC: kernel-janitors@vger.kernel.org, linux-fbdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] drivers/video/auo_k190x.c: drop kfree of devm_kzalloc's
 data
References: <1344081632-4729-1-git-send-email-Julia.Lawall@lip6.fr>
In-Reply-To: <1344081632-4729-1-git-send-email-Julia.Lawall@lip6.fr>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/04/2012 12:00 PM, Julia Lawall wrote:
> From: Julia Lawall <Julia.Lawall@lip6.fr>
> 
> Using kfree to free data allocated with devm_kzalloc causes double frees.
> 
> The semantic patch that fixes this problem is as follows:
> (http://coccinelle.lip6.fr/)
> 
> // <smpl>
> @@
> expression x;
> @@
> 
> x = devm_kzalloc(...)
> ...
> ?-kfree(x);
> // </smpl>
> 
> Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

Applied.


Thanks,

Florian Tobias Schandinat

> 
> ---
>  drivers/video/auo_k190x.c |    2 --
>  1 file changed, 2 deletions(-)
> 
> diff --git a/drivers/video/auo_k190x.c b/drivers/video/auo_k190x.c
> index 77da6a2..c03ecdd 100644
> --- a/drivers/video/auo_k190x.c
> +++ b/drivers/video/auo_k190x.c
> @@ -987,7 +987,6 @@ err_regfb:
>  	fb_dealloc_cmap(&info->cmap);
>  err_cmap:
>  	fb_deferred_io_cleanup(info);
> -	kfree(info->fbdefio);
>  err_defio:
>  	vfree((void *)info->screen_base);
>  err_irq:
> @@ -1022,7 +1021,6 @@ int  __devexit auok190x_common_remove(struct platform_device *pdev)
>  	fb_dealloc_cmap(&info->cmap);
>  
>  	fb_deferred_io_cleanup(info);
> -	kfree(info->fbdefio);
>  
>  	vfree((void *)info->screen_base);
>  
> 
> 

