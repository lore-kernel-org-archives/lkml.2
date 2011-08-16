Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752183Ab1HPLJA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Aug 2011 07:09:00 -0400
Received: from merlin.infradead.org ([205.233.59.134]:48553 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751653Ab1HPLI7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Aug 2011 07:08:59 -0400
Subject: Re: [RFC patch resend] DMA engine/Langwell: process pending
 descriptors
From: Vinod Koul <vkoul@infradead.org>
To: Hillf Danton <dhillf@gmail.com>
Cc: vinod.koul@intel.com, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <CAJd=RBB8RBzS6LUWH3TS-7v3X7b695Bb92wyHqEYYBJQ19xAog@mail.gmail.com>
References: <CAJd=RBDqKoqozsOg9GYicLMh4QELu-yESjNZJk8e--=QPzKVoQ@mail.gmail.com>
	 <1312824486.1539.42.camel@vkoul-udesk3>
	 <CAJd=RBB8RBzS6LUWH3TS-7v3X7b695Bb92wyHqEYYBJQ19xAog@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 16 Aug 2011 16:38:25 +0530
Message-ID: <1313492905.1603.43.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2011-08-13 at 11:57 +0800, Hillf Danton wrote:
> Descriptors could be added onto the queue list, though pending descriptors are
> checked in intel_mid_dma_issue_pending(), they are not processed by scanning
> the queue list. Now it is added.
> 
> Signed-off-by: Hillf Danton <dhillf@gmail.com>
> ---
> 
> --- a/drivers/dma/intel_mid_dma.c	Sat Aug 13 11:44:46 2011
> +++ intel_mid_dma.c	Sat Aug 13 11:52:35 2011
This is wrong....

You should use git format-patch to generate the patches in your git
tree. Also send using git send-email will prevent errors in your patch.
While sending bunch of patches use git format-patch --cover-letter to
generate the diff stat and nice cover letter, that helps maintainer to
manage the patch series well

> @@ -338,8 +338,12 @@ static void midc_scan_descriptors(struct
>  		if (desc->status == DMA_IN_PROGRESS)
>  			midc_descriptor_complete(midc, desc);
>  	}
> -	return;
> +	list_for_each_entry_safe(desc, _desc, &midc->queue, desc_node) {
> +		if (desc->status == DMA_IN_PROGRESS)
> +			midc_descriptor_complete(midc, desc);
>  	}
> +}
> +
>  /**
>   * midc_lli_fill_sg -		Helper function to convert
>   *				SG list to Linked List Items.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/



