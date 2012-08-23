Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933526Ab2HWUg6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2012 16:36:58 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:57487 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932738Ab2HWUgy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2012 16:36:54 -0400
X-Authenticated: #10250065
X-Provags-ID: V01U2FsdGVkX1/mtyU5SD/mZ1zjbmerLMxPhKEKEGgkpQyDdXSpIx
	H45dMjOsHEQ9jR
Message-ID: <50369460.7010303@gmx.de>
Date: Thu, 23 Aug 2012 20:36:48 +0000
From: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20120613 Icedove/3.0.11
MIME-Version: 1.0
To: Damien Cassou <damien.cassou@lifl.fr>
CC: kernel-janitors@vger.kernel.org, linux-fbdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/5] drivers/video/bf537-lq035.c: use devm_ functions
References: <1343742860-16213-1-git-send-email-damien.cassou@lifl.fr> <1343742860-16213-6-git-send-email-damien.cassou@lifl.fr>
In-Reply-To: <1343742860-16213-6-git-send-email-damien.cassou@lifl.fr>
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
>  drivers/video/bf537-lq035.c |   12 +++++-------
>  1 file changed, 5 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/video/bf537-lq035.c b/drivers/video/bf537-lq035.c
> index befbc80..7347aa1 100644
> --- a/drivers/video/bf537-lq035.c
> +++ b/drivers/video/bf537-lq035.c
> @@ -760,18 +760,20 @@ static int __devinit bfin_lq035_probe(struct platform_device *pdev)
>  	bfin_lq035_fb.flags = FBINFO_DEFAULT;
>  
>  
> -	bfin_lq035_fb.pseudo_palette = kzalloc(sizeof(u32) * 16, GFP_KERNEL);
> +	bfin_lq035_fb.pseudo_palette = devm_kzalloc(&pdev->dev,
> +						    sizeof(u32) * 16,
> +						    GFP_KERNEL);
>  	if (bfin_lq035_fb.pseudo_palette == NULL) {
>  		pr_err("failed to allocate pseudo_palette\n");
>  		ret = -ENOMEM;
> -		goto out_palette;
> +		goto out_table;
>  	}
>  
>  	if (fb_alloc_cmap(&bfin_lq035_fb.cmap, NBR_PALETTE, 0) < 0) {
>  		pr_err("failed to allocate colormap (%d entries)\n",
>  			NBR_PALETTE);
>  		ret = -EFAULT;
> -		goto out_cmap;
> +		goto out_table;
>  	}
>  
>  	if (register_framebuffer(&bfin_lq035_fb) < 0) {
> @@ -804,9 +806,6 @@ out_lcd:
>  	unregister_framebuffer(&bfin_lq035_fb);
>  out_reg:
>  	fb_dealloc_cmap(&bfin_lq035_fb.cmap);
> -out_cmap:
> -	kfree(bfin_lq035_fb.pseudo_palette);
> -out_palette:
>  out_table:
>  	dma_free_coherent(NULL, TOTAL_VIDEO_MEM_SIZE, fb_buffer, 0);
>  	fb_buffer = NULL;
> @@ -834,7 +833,6 @@ static int __devexit bfin_lq035_remove(struct platform_device *pdev)
>  	free_dma(CH_PPI);
>  
>  
> -	kfree(bfin_lq035_fb.pseudo_palette);
>  	fb_dealloc_cmap(&bfin_lq035_fb.cmap);
>  
>  
> 
> 

