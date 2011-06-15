Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755521Ab1FOVAV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jun 2011 17:00:21 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:49756 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755197Ab1FOVAT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jun 2011 17:00:19 -0400
Date: Wed, 15 Jun 2011 17:00:17 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Sarah Sharp <sarah.a.sharp@linux.intel.com>
cc: Maarten Lankhorst <m.b.lankhorst@gmail.com>, <linux-usb@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] xhci: Add reset on resume quirk for asrock p67 host
In-Reply-To: <20110615203631.GF5382@xanatos>
Message-ID: <Pine.LNX.4.44L0.1106151657560.1650-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 15 Jun 2011, Sarah Sharp wrote:

> On Wed, Jun 15, 2011 at 10:29:01PM +0200, Maarten Lankhorst wrote:
> > The asrock p67 xhci controller completely dies on resume,
> > add a quirk for this, to bring the host back online after a suspend.
> > 
> > This should be backported to stable kernels as far back as 2.6.34.
> 
> Why 2.6.34?  Only kernels as old as 2.6.37 had xHCI suspend and resume
> support.  Before 2.6.37, the xHCI driver would prevent the system from
> suspending at all.
> 
> Otherwise looks fine.
> 
> Sarah Sharp
> 

> > diff --git a/drivers/usb/host/xhci.c b/drivers/usb/host/xhci.c
> > index 06e7023..42fd032 100644
> > --- a/drivers/usb/host/xhci.c
> > +++ b/drivers/usb/host/xhci.c
> > @@ -759,6 +759,8 @@ int xhci_resume(struct xhci_hcd *xhci, bool hibernated)
> >  		msleep(100);
> >  
> >  	spin_lock_irq(&xhci->lock);
> > +	if (xhci->quirks & XHCI_RESET_ON_RESUME)
> > +		hibernated = 0;

Shouldn't this be "hibernated = true;"?  You want the driver to treat 
suspend as though it were hibernation, not the other way around.

Alan Stern

