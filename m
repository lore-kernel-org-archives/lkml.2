Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757518Ab1KUWXg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 17:23:36 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:47724 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754996Ab1KUWXe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 17:23:34 -0500
Date: Mon, 21 Nov 2011 17:23:33 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Linux PM list <linux-pm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Randy Dunlap <rdunlap@xenotime.net>
Subject: Re: [PATCH 5] PM: Update comments describing device power management
 callbacks
In-Reply-To: <201111212257.26071.rjw@sisk.pl>
Message-ID: <Pine.LNX.4.44L0.1111211717500.1848-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 21 Nov 2011, Rafael J. Wysocki wrote:

> > > I said "Analogous to @suspend()" instead.  I'm not sure why this is not
> > > sufficient?
> > 
> > Because @suspend() is very different!  Its description basically says 
> > to do three things:
> > 
> > 	Quiesce the device,
> > 
> > 	Put it into a low-power state,
> > 
> > 	And enable wakeup events.
> 
> No, it doesn't any more.  It's being changed by the proposed patch too. :-)

I must have missed reading that part.  Okay...  but it seems weird that
none of the new descriptions says anything about changing the power
state.  Shouldn't the description of @suspend say something like "For
many platforms and subsystems, the device should be put in a low-power
state"?

> > @freeze() is supposed to do the first but not the second or third.  
> > This makes it only 33% similar to @suspend().  :-)
> > 
> > Also, the description of @suspend() says nothing about having a
> > consistent memory image.
> 
> Because that is irrelevant.  The state of the device after the resume
> has to be consistent, regardless of whether the resume is from RAM or
> from an on-disk image.

Sure, the device's state will be consistent.  But will the contents of
memory image be consistent?  Not if the device was doing DMA writes
during the time when the image was created.

Alan Stern

