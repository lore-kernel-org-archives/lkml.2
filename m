Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756064Ab2JXEdK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 00:33:10 -0400
Received: from casper.infradead.org ([85.118.1.10]:54813 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755909Ab2JXEdG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 00:33:06 -0400
Subject: Re: [PATCH v2 4/4] DMA: PL330: unregister dma_device in module's
 remove function
From: Vinod Koul <vkoul@infradead.org>
To: Inderpal Singh <inderpal.singh@linaro.org>
Cc: vinod.koul@intel.com, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org, jassisinghbrar@gmail.com,
        boojin.kim@samsung.com, patches@linaro.org, kgene.kim@samsung.com
In-Reply-To: <1349432276-22919-5-git-send-email-inderpal.singh@linaro.org>
References: <1349432276-22919-1-git-send-email-inderpal.singh@linaro.org>
	 <1349432276-22919-5-git-send-email-inderpal.singh@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 24 Oct 2012 09:49:39 +0530
Message-ID: <1351052379.5263.20.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-10-05 at 15:47 +0530, Inderpal Singh wrote:
> unregister dma_device in module's remove function.
> 
> Signed-off-by: Inderpal Singh <inderpal.singh@linaro.org>
> ---
>  drivers/dma/pl330.c |    2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/dma/pl330.c b/drivers/dma/pl330.c
> index 4b7a34d..e7dc040 100644
> --- a/drivers/dma/pl330.c
> +++ b/drivers/dma/pl330.c
> @@ -3017,6 +3017,8 @@ static int __devexit pl330_remove(struct amba_device *adev)
>  			return -EBUSY;
>  	}
>  
> +	dma_async_device_unregister(&pdmac->ddma);
> +
>  	amba_set_drvdata(adev, NULL);
>  
>  	list_for_each_entry_safe(pch, _p, &pdmac->ddma.channels,

Ok with this one :)

Tried applying but didn't work out. You would need to regenerate this
one.

Thanks
-- 
Vinod Koul
Intel Corp.

