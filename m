Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757547Ab1KVP6A (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 10:58:00 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:36611 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754956Ab1KVP57 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 10:57:59 -0500
Date: Tue, 22 Nov 2011 10:57:58 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Linux PM list <linux-pm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Randy Dunlap <rdunlap@xenotime.net>
Subject: Re: [PATCH 5] PM: Update comments describing device power management
 callbacks
In-Reply-To: <201111212333.07799.rjw@sisk.pl>
Message-ID: <Pine.LNX.4.44L0.1111221043390.2466-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 21 Nov 2011, Rafael J. Wysocki wrote:

> On Monday, November 21, 2011, Alan Stern wrote:
> > On Mon, 21 Nov 2011, Rafael J. Wysocki wrote:
> > 
> > > > > I said "Analogous to @suspend()" instead.  I'm not sure why this is not
> > > > > sufficient?
> > > > 
> > > > Because @suspend() is very different!  Its description basically says 
> > > > to do three things:
> > > > 
> > > > 	Quiesce the device,
> > > > 
> > > > 	Put it into a low-power state,
> > > > 
> > > > 	And enable wakeup events.
> > > 
> > > No, it doesn't any more.  It's being changed by the proposed patch too. :-)
> > 
> > I must have missed reading that part.  Okay...  but it seems weird that
> > none of the new descriptions says anything about changing the power
> > state.  Shouldn't the description of @suspend say something like "For
> > many platforms and subsystems, the device should be put in a low-power
> > state"?
> 
> Hmm.  I'm not really sure, actually, because I'd recommend that subsystems
> rather than drivers change power states of devices and this description
> is targeted at driver writers mostly.

The same data structure (dev_pm_ops) is used for both drivers and
subsystems.  Therefore the comments should be directed toward both
driver writers and subsystem writers.

You could say: "For many platforms, the subsystem @suspend() or
@suspend_noirq() callback should put the device in a low-power state.  
Some subsystems may require the driver to do this instead."

> > > > @freeze() is supposed to do the first but not the second or third.  
> > > > This makes it only 33% similar to @suspend().  :-)
> > > > 
> > > > Also, the description of @suspend() says nothing about having a
> > > > consistent memory image.
> > > 
> > > Because that is irrelevant.  The state of the device after the resume
> > > has to be consistent, regardless of whether the resume is from RAM or
> > > from an on-disk image.
> > 
> > Sure, the device's state will be consistent.  But will the contents of
> > memory image be consistent?  Not if the device was doing DMA writes
> > during the time when the image was created.
> 
> Well, since .suspend() is also expected to stop DMA, that's rather moot.

It won't be moot if you add the sentences I recommend above.  You could
add an additional sentence: "Either way, the @freeze() and
@freeze_noirq() callbacks (both the subsystem's and the driver's)  
should always avoid changing the device's state."

Alan Stern

