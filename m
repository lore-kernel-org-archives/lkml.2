Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752934Ab0JENZK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Oct 2010 09:25:10 -0400
Received: from cantor2.suse.de ([195.135.220.15]:45691 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752806Ab0JENZI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Oct 2010 09:25:08 -0400
Date: Tue, 5 Oct 2010 06:18:04 -0700
From: Greg KH <gregkh@suse.de>
To: tlinder <tlinder@codeaurora.org>
Cc: Alan Stern <stern@rowland.harvard.edu>,
        USB list <linux-usb@vger.kernel.org>,
        David Brownell <dbrownell@users.sourceforge.net>,
        Michal Nazarewicz <m.nazarewicz@samsung.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: [RFC/PATCH 1/2] Add usb_endpoint_descriptor to be part of the
 struct usb_ep
Message-ID: <20101005131804.GA3548@suse.de>
References: <1286092800-29107-1-git-send-email-tlinder@codeaurora.org>
 <Pine.LNX.4.44L0.1010031201050.26676-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1010031201050.26676-100000@netrider.rowland.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 03, 2010 at 12:35:07PM -0400, Alan Stern wrote:
> On Sun, 3 Oct 2010, tlinder wrote:
> 
> > From: Tatyana Linder <tlinder@codeaurora.org>
> > 
> > Change ep_choose() and usb_ep_enable() prototypes to use endpoint
> > descriptor from usb_ep. This optimization prevents the FDs from handling
> > the endpoint chosen descriptor.
> > This optimization is not full though. To fully exploit this change one
> > needs to update all the UDCs as well since in the current implementation
> > each of them saves the endpoint descriptor in it's internal (and extended)
> > endpoint structure.
> > This patch is a preparation for adding SuperSpeed support to the gadget
> > framework.
> > 
> > Signed-off-by: Tatyana Linder <tlinder@codeaurora.org>
> 
> ...
> 
> > diff --git a/drivers/usb/gadget/file_storage.c b/drivers/usb/gadget/file_storage.c
> > index a857b7a..6264fba 100644
> > --- a/drivers/usb/gadget/file_storage.c
> > +++ b/drivers/usb/gadget/file_storage.c
> > @@ -3,6 +3,7 @@
> >   *
> >   * Copyright (C) 2003-2008 Alan Stern
> >   * All rights reserved.
> > + * Copyright (C) 2010 Code Aurora Forum. All rights reserved.
> >   *
> >   * Redistribution and use in source and binary forms, with or without
> >   * modification, are permitted provided that the following conditions
> 
> Speaking for myself only, I don't think people should add their own 
> copyright notices in files to which they have not made substantial 
> changes.  A little code motion and a small API adjustment don't seem 
> like large enough changes to justify this.  Some of the other files in 
> this patch have even smaller changes!

I agree.  Tatyana, please work with your company's lawyers to properly
learn how to add this type of mark to a file in a manner that is
correct.

Hint, this way is not correct :)

thanks,

greg k-h
