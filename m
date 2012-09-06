Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933020Ab2IFS3D (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 14:29:03 -0400
Received: from mga09.intel.com ([134.134.136.24]:17162 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932373Ab2IFS3B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 14:29:01 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,380,1344236400"; 
   d="scan'208";a="189750584"
Date: Thu, 6 Sep 2012 11:28:56 -0700
From: Sarah Sharp <sarah.a.sharp@linux.intel.com>
To: Girish Verma <girish@circuitsutra.com>
Cc: kernel-janitors@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org
Subject: Re: [PATCH] USB: XHCI: xhci-ring: Remove unused dma address
 calculation in inc_enq and inc_deq function
Message-ID: <20120906182856.GC4618@xanatos>
References: <1336922942.3945.12.camel@cst-girish-laptop>
 <1346946453.5012.1.camel@cst-girish-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1346946453.5012.1.camel@cst-girish-laptop>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hmm, your patch got corrupted:

sarah@xanatos:~/git/kernels/xhci$ git am -s -3 ~/Maildir.fetchmail/.to-apply-next/
Applying: USB: XHCI: xhci-ring: Remove unused dma address calculation in inc_enq and inc_deq function
fatal: corrupt patch at line 18
Repository lacks necessary blobs to fall back on 3-way merge.
Cannot fall back to three-way merge.
Patch failed at 0001 USB: XHCI: xhci-ring: Remove unused dma address calculation in inc_enq and inc_deq function
When you have resolved this problem run "git am --resolved".
If you would prefer to skip this patch, instead run "git am --skip".
To restore the original branch and stop patching run "git am --abort".

It looks like your mail client attempted to line wrap it.  You might
want to use mutt, thunderbird, or maybe even the plain text gmail
interface to resend this.

Also...

On Thu, Sep 06, 2012 at 09:17:33PM +0530, Girish Verma wrote:
> Resending patch with latest kernel code:

^^^ Don't include this line in your patch description.  Otherwise it
will be in the git history forever.  If you want to add comments to me
like this, you can edit the patch before you send it in your email
client, and put comments...

> In xhci-ring.c, function inc_enq and inc_deq calculate the dma address
> of trb but never used. 
> 
> 
> 
> Signed-off-by: Girish Verma <girish@circuitsutra.com>
> ---

...here, after the --- line and before the diff stat.  patch will ignore
any lines after the dash line up until the first @ line.

Finally, please remove the two newlines between your patch description
and the signed-off-by line.  Thanks!

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
> @@ -176,7 +175,6 @@ static void inc_deq(struct xhci_hcd *xhci, struct
> xhci_ring *ring)
>  		}
>  	} while (last_trb(xhci, ring, ring->deq_seg, ring->dequeue));
>  
> -	addr = (unsigned long long) xhci_trb_virt_to_dma(ring->deq_seg,
> ring->dequeue);
>  }
>  
>  /*
> @@ -201,7 +199,6 @@ static void inc_enq(struct xhci_hcd *xhci, struct
> xhci_ring *ring,
>  {
>  	u32 chain;
>  	union xhci_trb *next;
> -	unsigned long long addr;
>  
>  	chain = le32_to_cpu(ring->enqueue->generic.field[3]) & TRB_CHAIN;
>  	/* If this is not event ring, there is one less usable TRB */
> @@ -253,7 +250,6 @@ static void inc_enq(struct xhci_hcd *xhci, struct
> xhci_ring *ring,
>  		ring->enqueue = ring->enq_seg->trbs;
>  		next = ring->enqueue;
>  	}
> -	addr = (unsigned long long) xhci_trb_virt_to_dma(ring->enq_seg,
> ring->enqueue);
>  }
>  
>  /*
> -- 
> 1.7.0.4
> 
> 
