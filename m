Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752279Ab1HHRB1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Aug 2011 13:01:27 -0400
Received: from mga11.intel.com ([192.55.52.93]:34336 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751583Ab1HHRB0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Aug 2011 13:01:26 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,338,1309762800"; 
   d="scan'208";a="36978666"
Subject: Re: [RFC patch] DMAengine/Langwell: put tx descriptor in error path
From: "Koul, Vinod" <vinod.koul@intel.com>
To: Hillf Danton <dhillf@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Steven Rostedt <rostedt@goodmis.org>
In-Reply-To: <CAJd=RBDCLp0hXNtXVSzUd4De+z9cZLpTDftnxWVGeHauAbsWaQ@mail.gmail.com>
References: <CAJd=RBDCLp0hXNtXVSzUd4De+z9cZLpTDftnxWVGeHauAbsWaQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 08 Aug 2011 22:30:37 +0530
Message-ID: <1312822837.1539.38.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-07-26 at 20:43 +0800, Hillf Danton wrote:
> When preparing LLI based periphral transfer, if error encountered, the newly
> prepared tx descriptor should be put for later recycling.
> 
> Signed-off-by: Hillf Danton <dhillf@gmail.com>
> ---
>  drivers/dma/intel_mid_dma.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/dma/intel_mid_dma.c b/drivers/dma/intel_mid_dma.c
> index f653517..b78a65a 100644
> --- a/drivers/dma/intel_mid_dma.c
> +++ b/drivers/dma/intel_mid_dma.c
> @@ -793,6 +793,7 @@ static struct dma_async_tx_descriptor
> *intel_mid_dma_prep_slave_sg(
>  				32, 0);
This looks like a corrupt patch, can you fix this
>  	if (NULL == desc->lli_pool) {
>  		pr_err("MID_DMA:LLI pool create failed\n");
> +		midc_desc_put(midc, desc);
>  		return NULL;
>  	}
> 
> @@ -800,6 +801,7 @@ static struct dma_async_tx_descriptor
> *intel_mid_dma_prep_slave_sg(
>  	if (!desc->lli) {
>  		pr_err("MID_DMA: LLI alloc failed\n");
>  		pci_pool_destroy(desc->lli_pool);
> +		midc_desc_put(midc, desc);
>  		return NULL;
>  	}
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/


-- 
~Vinod

