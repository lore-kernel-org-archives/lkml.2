Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932659Ab1CWTCK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 15:02:10 -0400
Received: from mga03.intel.com ([143.182.124.21]:50714 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932706Ab1CWTCI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 15:02:08 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,232,1299484800"; 
   d="scan'208";a="407389700"
Date: Wed, 23 Mar 2011 12:02:05 -0700
From: Sarah Sharp <sarah.a.sharp@linux.intel.com>
To: Jeff Moyer <jmoyer@redhat.com>
Cc: linux-usb@vger.kernel.org, libusb-devel@lists.sourceforge.net,
        linux-kernel@vger.kernel.org, linux-aio@kvack.org
Subject: Re: Any USB gadget AIO interface users?
Message-ID: <20110323190205.GC5947@xanatos>
References: <20110322171251.GA4455@xanatos>
 <x49vcz9c3dr.fsf@segfault.boston.devel.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <x49vcz9c3dr.fsf@segfault.boston.devel.redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 23, 2011 at 10:34:08AM -0400, Jeff Moyer wrote:
> Sarah Sharp <sarah.a.sharp@linux.intel.com> writes:
> 
> > Has anyone successfully used the asynchronous I/O gadgetfs interface
> > before?  Specifically, has anyone used it for high-bandwidth isochronous
> > traffic?
> >
> > I ask because I remember discovering about four years ago that there
> > were several brain-twisty bugs in the in-kernel asynchronous I/O layer
> > that gadgetfs uses.
> 
> Weren't they addressed?  And are you looking to use the gadgetfs aio
> interface now, or are you looking to get rid of it?  In other words,
> what's the real motivation behind the question?

I was looking to use it.  The bug in question I remember was about
cancellation, but I would have to dig in my mailbox from 2007 to find
the exact issue.

The biggest problem I remember when I was looking at using the aio core
to replace the ioctls in the usbfs subsystem with true aio operations
was there was an issue with operation ordering.  In the kernel to
userspace interface for USB, we want asynchronous operations to a
particular file to be queued to the hardware in the order they are
submitted.  So if the userspace application submits asynchronous read A,
then asynchronous read B, then the buffer for read B doesn't get queued
to the USB host controller before the buffer for read A.  Otherwise you
get transmission reordering on the bus, and USB devices aren't very
happy.

> > The AIO core also seemed to be largely unmaintained.  Is this still
> > true?
> 
> Surely you should at least cc the aio list when asking such a question!
> Anyway, the aio core is maintained by several folks, but nobody is doing
> active development in that area, to my knowledge.

Sorry, I forgot the aio mailing list existed. :)  In 2007, there was
lots of talk of using syslets or fibrils in the aio core, and Zack Brown
had some patches for that, but it seemed like nothing really came out of
that.  Has anything new been added to the AIO core since then?

Sarah Sharp
