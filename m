Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754843Ab1FOVVv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jun 2011 17:21:51 -0400
Received: from mga09.intel.com ([134.134.136.24]:38715 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752161Ab1FOVVs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jun 2011 17:21:48 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,371,1304319600"; 
   d="scan'208";a="13999265"
Date: Wed, 15 Jun 2011 14:21:35 -0700
From: Sarah Sharp <sarah.a.sharp@linux.intel.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Maarten Lankhorst <m.b.lankhorst@gmail.com>, linux-usb@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] xhci: Add reset on resume quirk for asrock p67 host
Message-ID: <20110615212135.GH5382@xanatos>
References: <20110615203631.GF5382@xanatos>
 <Pine.LNX.4.44L0.1106151657560.1650-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1106151657560.1650-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 15, 2011 at 05:00:17PM -0400, Alan Stern wrote:
> On Wed, 15 Jun 2011, Sarah Sharp wrote:
> 
> > On Wed, Jun 15, 2011 at 10:29:01PM +0200, Maarten Lankhorst wrote:
> > > The asrock p67 xhci controller completely dies on resume,
> > > add a quirk for this, to bring the host back online after a suspend.
> > > 
> > > This should be backported to stable kernels as far back as 2.6.34.
> > 
> > Why 2.6.34?  Only kernels as old as 2.6.37 had xHCI suspend and resume
> > support.  Before 2.6.37, the xHCI driver would prevent the system from
> > suspending at all.
> > 
> > Otherwise looks fine.
> > 
> > Sarah Sharp
> > 
> 
> > > diff --git a/drivers/usb/host/xhci.c b/drivers/usb/host/xhci.c
> > > index 06e7023..42fd032 100644
> > > --- a/drivers/usb/host/xhci.c
> > > +++ b/drivers/usb/host/xhci.c
> > > @@ -759,6 +759,8 @@ int xhci_resume(struct xhci_hcd *xhci, bool hibernated)
> > >  		msleep(100);
> > >  
> > >  	spin_lock_irq(&xhci->lock);
> > > +	if (xhci->quirks & XHCI_RESET_ON_RESUME)
> > > +		hibernated = 0;
> 
> Shouldn't this be "hibernated = true;"?  You want the driver to treat 
> suspend as though it were hibernation, not the other way around.

Yes, good catch.  Maarten, can you respin this patch (and with the
note that it should be backported as far as 2.6.37).

Sarah Sharp
