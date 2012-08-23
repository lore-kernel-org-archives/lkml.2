Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933874Ab2HWUi3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2012 16:38:29 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:35281 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932826Ab2HWUiZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2012 16:38:25 -0400
X-Authenticated: #10250065
X-Provags-ID: V01U2FsdGVkX1+Y6ARRn1OYFHm+ouOctxyXWiEXZ4SzatrF6IIRmf
	bBW/977h08QO2o
Message-ID: <503694BC.8090707@gmx.de>
Date: Thu, 23 Aug 2012 20:38:20 +0000
From: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20120613 Icedove/3.0.11
MIME-Version: 1.0
To: Damien Cassou <damien.cassou@lifl.fr>
CC: kernel-janitors@vger.kernel.org, linux-fbdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/5] drivers/video/fsl-diu-fb.c: use devm_ functions
References: <1343752762-16861-1-git-send-email-damien.cassou@lifl.fr> <1343752762-16861-4-git-send-email-damien.cassou@lifl.fr>
In-Reply-To: <1343752762-16861-4-git-send-email-damien.cassou@lifl.fr>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/31/2012 04:39 PM, Damien Cassou wrote:
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
>  drivers/video/fsl-diu-fb.c |   11 ++---------
>  1 file changed, 2 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/video/fsl-diu-fb.c b/drivers/video/fsl-diu-fb.c
> index 458c006..19194c5 100644
> --- a/drivers/video/fsl-diu-fb.c
> +++ b/drivers/video/fsl-diu-fb.c
> @@ -1501,8 +1501,8 @@ static int __devinit fsl_diu_probe(struct platform_device *pdev)
>  	unsigned int i;
>  	int ret;
> 
> -	data = dma_alloc_coherent(&pdev->dev, sizeof(struct fsl_diu_data),
> -				  &dma_addr, GFP_DMA | __GFP_ZERO);
> +	data = dmam_alloc_coherent(&pdev->dev, sizeof(struct fsl_diu_data),
> +				   &dma_addr, GFP_DMA | __GFP_ZERO);
>  	if (!data)
>  		return -ENOMEM;
>  	data->dma_addr = dma_addr;
> @@ -1628,9 +1628,6 @@ error:
> 
>  	iounmap(data->diu_reg);
> 
> -	dma_free_coherent(&pdev->dev, sizeof(struct fsl_diu_data), data,
> -			  data->dma_addr);
> -
>  	return ret;
>  }
> 
> @@ -1648,9 +1645,6 @@ static int fsl_diu_remove(struct platform_device *pdev)
> 
>  	iounmap(data->diu_reg);
> 
> -	dma_free_coherent(&pdev->dev, sizeof(struct fsl_diu_data), data,
> -			  data->dma_addr);
> -
>  	return 0;
>  }
> 

