Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758006Ab2FFSQJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 14:16:09 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:51350 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757903Ab2FFSQH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 14:16:07 -0400
Date: Wed, 6 Jun 2012 14:16:05 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Stefani Seibold <stefani@seibold.net>
cc: linux-kernel@vger.kernel.org, <gregkh@linuxfoundation.org>,
        <oneukum@suse.de>, <alan@lxorguk.ukuu.org.uk>,
        <linux-usb@vger.kernel.org>
Subject: Re: [PATCH] fix usb skeleton driver
In-Reply-To: <1339005186.11678.3.camel@wall-e>
Message-ID: <Pine.LNX.4.44L0.1206061406500.1788-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 6 Jun 2012, Stefani Seibold wrote:

> Am Mittwoch, den 06.06.2012, 12:55 -0400 schrieb Alan Stern:
> > On Wed, 6 Jun 2012 stefani@seibold.net wrote:
> > 
> > > From: Stefani Seibold <stefani@seibold.net>
> > > 
> > > This is a fix for the USB skeleton driver to bring it in shape.
> > > 
> > > - The usb_interface structure pointer will be no longer stored 
> > > - Every access to the USB will be handled trought the usb_interface pointer
> > 
> 
> Sorry, missed to fix. Should be:
> 
> Every access to the USB will be handled through the usb_device pointer

But that's wrong -- the accesses should go through the interface 
pointer.  After all, the driver is bound to the interface, not to the 
device.

> > Those two changes sound contradictory.
> > 
> > > - Add a new bool 'connected' for signaling a disconnect (== false)
> > > - Handle a non blocking read without blocking
> > > - Code cleanup
> > > - Synchronize disconnect() handler with open() and release(), to fix races
> > > - Introduced fsync
> > > - Single user mode
> > > - Eliminated dead code
> > > - Save some bytes in the dev structure
> > 
> > How about simplifying the code so that it can be read by somebody who's 
> > not already an expert?
> > 
> > Alan Stern
> > 
> 
> Hey, i thought i get a little thank you for the voluntary work, what a
> nice job. Not a demand for more work to do.

Have you submitted many kernel patches in the past?  :-)  This is the 
way it usually works out...

Seriously, what seems like an improvement to one person might not seem 
so great to somebody else.  Often even the most trivial changes can't 
get accepted without a lot of back-and-forth arguing^Wdiscussion.

In this case, I really think it's worthwhile to look for ways to
simplify usb-skeleton.c.  For example, does supporting fsync really
help somebody who's trying to learn how to write a USB device driver?  
I suspect it doesn't.

Going even farther, I'm not so sure it's a good idea for usb-skeleton
to try supporting both synchronous and asynchronous accesses.  This
adds a layer of complexity that people just don't need.  IMO it would 
be better to have two separate example drivers, an easy one that is 
purely synchronous and a more advanced one that is purely async.

Now, things like the race between disconnect and open are good for
teaching, because they crop up in every driver and have to be handled.  
Other things aren't so clear (such as the autosuspend support).

Alan Stern

