Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755396Ab1KUWaZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 17:30:25 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:50416 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752612Ab1KUWaX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 17:30:23 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH 5] PM: Update comments describing device power management callbacks
Date: Mon, 21 Nov 2011 23:33:07 +0100
User-Agent: KMail/1.13.6 (Linux/3.1.0-rc10+; KDE/4.6.0; x86_64; ; )
Cc: Linux PM list <linux-pm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Randy Dunlap <rdunlap@xenotime.net>
References: <Pine.LNX.4.44L0.1111211717500.1848-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1111211717500.1848-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201111212333.07799.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, November 21, 2011, Alan Stern wrote:
> On Mon, 21 Nov 2011, Rafael J. Wysocki wrote:
> 
> > > > I said "Analogous to @suspend()" instead.  I'm not sure why this is not
> > > > sufficient?
> > > 
> > > Because @suspend() is very different!  Its description basically says 
> > > to do three things:
> > > 
> > > 	Quiesce the device,
> > > 
> > > 	Put it into a low-power state,
> > > 
> > > 	And enable wakeup events.
> > 
> > No, it doesn't any more.  It's being changed by the proposed patch too. :-)
> 
> I must have missed reading that part.  Okay...  but it seems weird that
> none of the new descriptions says anything about changing the power
> state.  Shouldn't the description of @suspend say something like "For
> many platforms and subsystems, the device should be put in a low-power
> state"?

Hmm.  I'm not really sure, actually, because I'd recommend that subsystems
rather than drivers change power states of devices and this description
is targeted at driver writers mostly.

> > > @freeze() is supposed to do the first but not the second or third.  
> > > This makes it only 33% similar to @suspend().  :-)
> > > 
> > > Also, the description of @suspend() says nothing about having a
> > > consistent memory image.
> > 
> > Because that is irrelevant.  The state of the device after the resume
> > has to be consistent, regardless of whether the resume is from RAM or
> > from an on-disk image.
> 
> Sure, the device's state will be consistent.  But will the contents of
> memory image be consistent?  Not if the device was doing DMA writes
> during the time when the image was created.

Well, since .suspend() is also expected to stop DMA, that's rather moot.

Thanks,
Rafael
