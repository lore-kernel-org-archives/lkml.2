Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753626Ab1HHRWl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Aug 2011 13:22:41 -0400
Received: from mga14.intel.com ([143.182.124.37]:30609 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753462Ab1HHRWi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Aug 2011 13:22:38 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,338,1309762800"; 
   d="scan'208";a="36331906"
Subject: Re: [RFC patch] DMAengine/Langwell: put dev object in error path
From: "Koul, Vinod" <vinod.koul@intel.com>
To: Hillf Danton <dhillf@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Steven Rostedt <rostedt@goodmis.org>
In-Reply-To: <CAJd=RBCO=Hhb4oCsmXgQ+HHRL6CWCDe6yRvo7wg+qXOcr6UsAg@mail.gmail.com>
References: <CAJd=RBCO=Hhb4oCsmXgQ+HHRL6CWCDe6yRvo7wg+qXOcr6UsAg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 08 Aug 2011 22:51:49 +0530
Message-ID: <1312824109.1539.39.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-07-27 at 21:24 +0800, Hillf Danton wrote:
> When allocating resources for DMA channel, if error encountered, the dev object
> of the relevant DMA device should be put, corresponding to the get operation.
> 
> Signed-off-by: Hillf Danton <dhillf@gmail.com>
> ---
>  drivers/dma/intel_mid_dma.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/dma/intel_mid_dma.c b/drivers/dma/intel_mid_dma.c
> index f653517..85bd8f3 100644
> --- a/drivers/dma/intel_mid_dma.c
> +++ b/drivers/dma/intel_mid_dma.c
> @@ -871,6 +871,7 @@ static int
> intel_mid_dma_alloc_chan_resources(struct dma_chan *chan)
This again looks corrupt

>  	if (mid->state == SUSPENDED) {
>  		if (dma_resume(mid->pdev)) {
>  			pr_err("ERR_MDMA: resume failed");
> +			pm_runtime_put(&mid->pdev->dev);
>  			return -EFAULT;
>  		}
>  	}
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/


-- 
~Vinod

