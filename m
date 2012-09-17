Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753299Ab2IQFra (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 01:47:30 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:46505 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751038Ab2IQFr3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 01:47:29 -0400
MIME-Version: 1.0
In-Reply-To: <1347856065-14027-1-git-send-email-inderpal.singh@linaro.org>
References: <1347856065-14027-1-git-send-email-inderpal.singh@linaro.org>
Date: Mon, 17 Sep 2012 11:17:28 +0530
Message-ID: <CABb+yY1-_NVHfGnRNpNpN1g8Xk399SRjippR_8DQ2pBYRxx47w@mail.gmail.com>
Subject: Re: [PATCH] DMA: PL330: return ENOMEM instead of 0 from pl330_alloc_chan_resources
From: Jassi Brar <jassisinghbrar@gmail.com>
To: Inderpal Singh <inderpal.singh@linaro.org>
Cc: linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        kgene.kim@samsung.com, vinod.koul@intel.com, patches@linaro.org,
        boojin.kim@samsung.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 17, 2012 at 9:57 AM, Inderpal Singh
<inderpal.singh@linaro.org> wrote:
> Since 0 is not considered as error at dmaengine level, return ENOMEM
> from pl330_alloc_chan_resources in case of failure.
>
> Signed-off-by: Inderpal Singh <inderpal.singh@linaro.org>

Acked-by: Jassi Brar <jassisinghbrar@gmail.com>


> ---
>  drivers/dma/pl330.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/dma/pl330.c b/drivers/dma/pl330.c
> index e4feba6..14d881c 100644
> --- a/drivers/dma/pl330.c
> +++ b/drivers/dma/pl330.c
> @@ -2393,7 +2393,7 @@ static int pl330_alloc_chan_resources(struct dma_chan *chan)
>         pch->pl330_chid = pl330_request_channel(&pdmac->pif);
>         if (!pch->pl330_chid) {
>                 spin_unlock_irqrestore(&pch->lock, flags);
> -               return 0;
> +               return -ENOMEM;
>         }
>
>         tasklet_init(&pch->task, pl330_tasklet, (unsigned long) pch);
> --
> 1.7.9.5
>
