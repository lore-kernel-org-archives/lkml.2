Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752999Ab1HHR3b (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Aug 2011 13:29:31 -0400
Received: from mga01.intel.com ([192.55.52.88]:50574 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751217Ab1HHR3a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Aug 2011 13:29:30 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,338,1309762800"; 
   d="scan'208";a="39248656"
Subject: Re: [RFC patch] DMA engine/Langwell: process pending descriptors
From: "Koul, Vinod" <vinod.koul@intel.com>
To: Hillf Danton <dhillf@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Steven Rostedt <rostedt@goodmis.org>
In-Reply-To: <CAJd=RBDqKoqozsOg9GYicLMh4QELu-yESjNZJk8e--=QPzKVoQ@mail.gmail.com>
References: <CAJd=RBDqKoqozsOg9GYicLMh4QELu-yESjNZJk8e--=QPzKVoQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 08 Aug 2011 22:58:06 +0530
Message-ID: <1312824486.1539.42.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-07-27 at 21:24 +0800, Hillf Danton wrote:
> Descriptors could be added onto the queue list, though pending descriptors are
> checked in intel_mid_dma_issue_pending(), they are not processed by scanning
> the queue list.
> In this work scanning the queue list is added in midc_scan_descriptors().
> 
> Signed-off-by: Hillf Danton <dhillf@gmail.com>
> ---
>  drivers/dma/intel_mid_dma.c |    5 ++++-
>  1 files changed, 4 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/dma/intel_mid_dma.c b/drivers/dma/intel_mid_dma.c
> index f653517..a176fb9 100644
> --- a/drivers/dma/intel_mid_dma.c
> +++ b/drivers/dma/intel_mid_dma.c
> @@ -338,8 +338,11 @@ static void midc_scan_descriptors(struct
> middma_device *mid,
Here again!!!

Pls fix your mailer to not screw patches :(
Also when sending a bunch of patches, ensure you send as a patch series

>  		if (desc->status == DMA_IN_PROGRESS)
>  			midc_descriptor_complete(midc, desc);
>  	}
> -	return;
> +	list_for_each_entry_safe(desc, _desc, &midc->queue, desc_node) {
> +		if (desc->status == DMA_IN_PROGRESS)
> +			midc_descriptor_complete(midc, desc);
>  	}
> +}
>  /**
>   * midc_lli_fill_sg -		Helper function to convert
>   *				SG list to Linked List Items.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/


-- 
~Vinod

