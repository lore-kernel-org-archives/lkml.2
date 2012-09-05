Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759785Ab2IEWr3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 18:47:29 -0400
Received: from mga09.intel.com ([134.134.136.24]:9386 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759738Ab2IEWr1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 18:47:27 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,376,1344236400"; 
   d="scan'208";a="189381345"
Date: Wed, 5 Sep 2012 15:47:23 -0700
From: Sarah Sharp <sarah.a.sharp@linux.intel.com>
To: Girish Verma <girish@circuitsutra.com>
Cc: kernel-janitors@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org
Subject: Re: [PATCH] USB: XHCI: xhci-ring: Remove unused dma address
 calculation in inc_enq and inc_deq function
Message-ID: <20120905224723.GD8975@xanatos>
References: <1336922942.3945.12.camel@cst-girish-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1336922942.3945.12.camel@cst-girish-laptop>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Girish,

Sorry for taking a really long time to respond!  This is a good idea,
but your patch doesn't apply any more.  Can you update it against the
latest kernel and resend it?

Sarah Sharp

On Sun, May 13, 2012 at 08:59:02PM +0530, Girish Verma wrote:
> In xhci-ring.c, function inc_enq and inc_deq calculate the dma address
> of trb but never used. 
> 
> Signed-off-by: Girish Verma <girish@circuitsutra.com>
> ---
>  drivers/usb/host/xhci-ring.c |    4 ----
>  1 files changed, 0 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/usb/host/xhci-ring.c b/drivers/usb/host/xhci-ring.c
> index 3d9422f..dcd67c1 100644
> --- a/drivers/usb/host/xhci-ring.c
> +++ b/drivers/usb/host/xhci-ring.c
> @@ -146,7 +146,6 @@ static void next_trb(struct xhci_hcd *xhci,
>  static void inc_deq(struct xhci_hcd *xhci, struct xhci_ring *ring)
>  {
>  	union xhci_trb *next;
> -	unsigned long long addr;
>  
>  	ring->deq_updates++;
>  
> @@ -168,7 +167,6 @@ static void inc_deq(struct xhci_hcd *xhci, struct xhci_ring *ring)
>  		ring->dequeue = ring->deq_seg->trbs;
>  		next = ring->dequeue;
>  	}
> -	addr = (unsigned long long) xhci_trb_virt_to_dma(ring->deq_seg, ring->dequeue);
>  }
>  
>  /*
> @@ -193,7 +191,6 @@ static void inc_enq(struct xhci_hcd *xhci, struct xhci_ring *ring,
>  {
>  	u32 chain;
>  	union xhci_trb *next;
> -	unsigned long long addr;
>  
>  	chain = le32_to_cpu(ring->enqueue->generic.field[3]) & TRB_CHAIN;
>  	/* If this is not event ring, there is one less usable TRB */
> @@ -245,7 +242,6 @@ static void inc_enq(struct xhci_hcd *xhci, struct xhci_ring *ring,
>  		ring->enqueue = ring->enq_seg->trbs;
>  		next = ring->enqueue;
>  	}
> -	addr = (unsigned long long) xhci_trb_virt_to_dma(ring->enq_seg, ring->enqueue);
>  }
>  
>  /*
> -- 
> 
> 
