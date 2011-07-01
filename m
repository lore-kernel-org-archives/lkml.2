Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755204Ab1GAHTq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jul 2011 03:19:46 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:65474 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752475Ab1GAHTp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jul 2011 03:19:45 -0400
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 98.234.237.12
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/LfgGoi5u8arx72fDslt5f
Date: Fri, 1 Jul 2011 00:19:42 -0700
From: Tony Lindgren <tony@atomide.com>
To: Scott Ellis <scott@jumpnowtek.com>
Cc: linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Russell King <linux@arm.linux.org.uk>
Subject: Re: [PATCH] DMA: OMAP: Remove extra looping from omap_request_dma
Message-ID: <20110701071942.GC23145@atomide.com>
References: <1309356549.3995.13.camel@quad>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1309356549.3995.13.camel@quad>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Scott Ellis <scott@jumpnowtek.com> [110629 20:58]:
> Break from dma channel search when a free one is found.

Care to describe how the current code is not finding a
free channel currently?

Tony

 
> Signed-off-by: Scott Ellis <scott@jumpnowtek.com>
> ---
>  arch/arm/plat-omap/dma.c |    5 ++---
>  1 files changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/arm/plat-omap/dma.c b/arch/arm/plat-omap/dma.c
> index c22217c..3d36fcf 100644
> --- a/arch/arm/plat-omap/dma.c
> +++ b/arch/arm/plat-omap/dma.c
> @@ -678,10 +678,9 @@ int omap_request_dma(int dev_id, const char *dev_name,
>  
>  	spin_lock_irqsave(&dma_chan_lock, flags);
>  	for (ch = 0; ch < dma_chan_count; ch++) {
> -		if (free_ch == -1 && dma_chan[ch].dev_id == -1) {
> +		if (dma_chan[ch].dev_id == -1) {
>  			free_ch = ch;
> -			if (dev_id == 0)
> -				break;
> +			break;
>  		}
>  	}
>  	if (free_ch == -1) {
> 
