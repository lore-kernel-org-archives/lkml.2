Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760089Ab2FGIUx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 04:20:53 -0400
Received: from mga11.intel.com ([192.55.52.93]:5107 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752351Ab2FGIUc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 04:20:32 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="162135599"
Subject: Re: [PATCH] dmaengine: pl330: dont complete descriptor for cyclic
 dma
From: Vinod Koul <vinod.koul@linux.intel.com>
To: Tushar Behera <tushar.behera@linaro.org>
Cc: linux-kernel@vger.kernel.org, dan.j.williams@intel.com, patches@linaro.org,
        stable <stable@vger.kernel.org>
In-Reply-To: <1337771851-3431-1-git-send-email-tushar.behera@linaro.org>
References: <1337771851-3431-1-git-send-email-tushar.behera@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 07 Jun 2012 13:43:42 +0530
Message-ID: <1339056822.1927.8.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-05-23 at 16:47 +0530, Tushar Behera wrote:
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
Applied thanks. I have cc'ed stable.

-- 
~Vinod

