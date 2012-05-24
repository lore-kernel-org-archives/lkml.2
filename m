Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751081Ab2EXEY5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 00:24:57 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:59174 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750727Ab2EXEYz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 00:24:55 -0400
Message-ID: <4FBDB812.9060407@linaro.org>
Date: Thu, 24 May 2012 09:54:50 +0530
From: Tushar Behera <tushar.behera@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: vinod.koul@intel.com, dan.j.williams@intel.com, patches@linaro.org,
        Jassi Brar <jaswinder.singh@linaro.org>
Subject: Re: [PATCH] dmaengine: pl330: dont complete descriptor for cyclic
 dma
References: <1337771851-3431-1-git-send-email-tushar.behera@linaro.org>
In-Reply-To: <1337771851-3431-1-git-send-email-tushar.behera@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Forgot to add driver author in the original mail, adding now.

On 05/23/2012 04:47 PM, Tushar Behera wrote:
> Commit eab215855803 ("dmaengine: pl330: dont complete descriptor for
> cyclic dma") wrongly completes descriptor for cyclic dma, hence following
> BUG_ON is still hit with cyclic DMA operations.
> 
> kernel BUG at drivers/dma/dmaengine.h:53!
> 
> Signed-off-by: Tushar Behera <tushar.behera@linaro.org>
> ---
>  drivers/dma/pl330.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/dma/pl330.c b/drivers/dma/pl330.c
> index fa3fb21..8c44f17 100644
> --- a/drivers/dma/pl330.c
> +++ b/drivers/dma/pl330.c
> @@ -2322,7 +2322,7 @@ static void pl330_tasklet(unsigned long data)
>  	/* Pick up ripe tomatoes */
>  	list_for_each_entry_safe(desc, _dt, &pch->work_list, node)
>  		if (desc->status == DONE) {
> -			if (pch->cyclic)
> +			if (!pch->cyclic)
>  				dma_cookie_complete(&desc->txd);
>  			list_move_tail(&desc->node, &list);
>  		}


-- 
Tushar Behera
