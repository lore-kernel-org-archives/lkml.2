Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934334Ab2HWUlo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2012 16:41:44 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:46477 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932284Ab2HWUll (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2012 16:41:41 -0400
X-Authenticated: #10250065
X-Provags-ID: V01U2FsdGVkX1/c4EYOM87cdLE92IQklwSySdLjK9TPWwYuIFIq82
	PaNZx+f82ENDX1
Message-ID: <50369580.5010303@gmx.de>
Date: Thu, 23 Aug 2012 20:41:36 +0000
From: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20120613 Icedove/3.0.11
MIME-Version: 1.0
To: Damien Cassou <damien.cassou@lifl.fr>
CC: kernel-janitors@vger.kernel.org, linux-fbdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/5] drivers/video/bf54x-lq043fb.c: use devm_ functions
References: <1344008414-2894-1-git-send-email-damien.cassou@lifl.fr> <1344008414-2894-4-git-send-email-damien.cassou@lifl.fr>
In-Reply-To: <1344008414-2894-4-git-send-email-damien.cassou@lifl.fr>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/03/2012 03:40 PM, Damien Cassou wrote:
> From: Damien Cassou <damien.cassou@lifl.fr>
> 
> The various devm_ functions allocate memory that is released when a driver
> detaches. This patch replaces the use of kzalloc by devm_kzalloc.
> 
> Signed-off-by: Damien Cassou <damien.cassou@lifl.fr>

Applied.


Thanks,

Florian Tobias Schandinat

> 
> ---
>  drivers/video/bf54x-lq043fb.c |    8 +++-----
>  1 file changed, 3 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/video/bf54x-lq043fb.c b/drivers/video/bf54x-lq043fb.c
> index dc2f004..47702ee 100644
> --- a/drivers/video/bf54x-lq043fb.c
> +++ b/drivers/video/bf54x-lq043fb.c
> @@ -601,7 +601,8 @@ static int __devinit bfin_bf54x_probe(struct platform_device *pdev)
> 
>  	fbinfo->fbops = &bfin_bf54x_fb_ops;
> 
> -	fbinfo->pseudo_palette = kzalloc(sizeof(u32) * 16, GFP_KERNEL);
> +	fbinfo->pseudo_palette = devm_kzalloc(&pdev->dev, sizeof(u32) * 16,
> +					      GFP_KERNEL);
>  	if (!fbinfo->pseudo_palette) {
>  		printk(KERN_ERR DRIVER_NAME
>  		       "Fail to allocate pseudo_palette\n");
> @@ -616,7 +617,7 @@ static int __devinit bfin_bf54x_probe(struct platform_device *pdev)
>  		       "Fail to allocate colormap (%d entries)\n",
>  		       BFIN_LCD_NBR_PALETTE_ENTRIES);
>  		ret = -EFAULT;
> -		goto out5;
> +		goto out4;
>  	}
> 
>  	if (request_ports(info)) {
> @@ -671,8 +672,6 @@ out7:
>  	free_ports(info);
>  out6:
>  	fb_dealloc_cmap(&fbinfo->cmap);
> -out5:
> -	kfree(fbinfo->pseudo_palette);
>  out4:
>  	dma_free_coherent(NULL, fbinfo->fix.smem_len, info->fb_buffer,
>  			  info->dma_handle);
> @@ -699,7 +698,6 @@ static int __devexit bfin_bf54x_remove(struct platform_device *pdev)
>  		dma_free_coherent(NULL, fbinfo->fix.smem_len, info->fb_buffer,
>  				  info->dma_handle);
> 
> -	kfree(fbinfo->pseudo_palette);
>  	fb_dealloc_cmap(&fbinfo->cmap);
> 
>  #ifndef NO_BL_SUPPORT
> 

