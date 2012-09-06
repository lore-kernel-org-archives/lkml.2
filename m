Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933126Ab2IFUy0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 16:54:26 -0400
Received: from mga09.intel.com ([134.134.136.24]:60374 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759636Ab2IFUyZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 16:54:25 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,381,1344236400"; 
   d="scan'208";a="189798348"
Date: Thu, 6 Sep 2012 13:54:08 -0700
From: Sarah Sharp <sarah.a.sharp@linux.intel.com>
To: Girish Verma <girish@circuitsutra.com>
Cc: gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] In xhci-ring.c, function inc_enq and inc_deq calculate
 the dma address of trb but never used.
Message-ID: <20120906205408.GD4618@xanatos>
References: <1346958484-13533-1-git-send-email-girish@circuitsutra.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1346958484-13533-1-git-send-email-girish@circuitsutra.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ok, there's no line wrapping this time, so it applies.

However, your subject line is really too long, and you're missing a
description in the body of the patch.  Did you lose the subject line
from the first version of the patch?

In general, subject lines shouldn't be longer than 50 characters,
because patch will truncate the subject line after that.  Make it short,
sweet, and easy to read in a glance, like "Remove unused variable in
inc_enq and inq_deq".

Sarah Sharp

On Fri, Sep 07, 2012 at 12:38:04AM +0530, Girish Verma wrote:
> 
> Signed-off-by: Girish Verma <girish@circuitsutra.com>
> ---
>  drivers/usb/host/xhci-ring.c |    4 ----
>  1 files changed, 0 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/usb/host/xhci-ring.c b/drivers/usb/host/xhci-ring.c
> index 643c2f3..5c5c47b 100644
> --- a/drivers/usb/host/xhci-ring.c
> +++ b/drivers/usb/host/xhci-ring.c
> @@ -145,7 +145,6 @@ static void next_trb(struct xhci_hcd *xhci,
>   */
>  static void inc_deq(struct xhci_hcd *xhci, struct xhci_ring *ring)
>  {
> -	unsigned long long addr;
>  
>  	ring->deq_updates++;
>  
> @@ -176,7 +175,6 @@ static void inc_deq(struct xhci_hcd *xhci, struct xhci_ring *ring)
>  		}
>  	} while (last_trb(xhci, ring, ring->deq_seg, ring->dequeue));
>  
> -	addr = (unsigned long long) xhci_trb_virt_to_dma(ring->deq_seg, ring->dequeue);
>  }
>  
>  /*
> @@ -201,7 +199,6 @@ static void inc_enq(struct xhci_hcd *xhci, struct xhci_ring *ring,
>  {
>  	u32 chain;
>  	union xhci_trb *next;
> -	unsigned long long addr;
>  
>  	chain = le32_to_cpu(ring->enqueue->generic.field[3]) & TRB_CHAIN;
>  	/* If this is not event ring, there is one less usable TRB */
> @@ -253,7 +250,6 @@ static void inc_enq(struct xhci_hcd *xhci, struct xhci_ring *ring,
>  		ring->enqueue = ring->enq_seg->trbs;
>  		next = ring->enqueue;
>  	}
> -	addr = (unsigned long long) xhci_trb_virt_to_dma(ring->enq_seg, ring->enqueue);
>  }
>  
>  /*
> -- 
> 1.7.0.4
> 
