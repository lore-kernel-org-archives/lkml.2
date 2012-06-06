Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932112Ab2FFUT0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 16:19:26 -0400
Received: from www84.your-server.de ([213.133.104.84]:56223 "EHLO
	www84.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757520Ab2FFUTZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 16:19:25 -0400
Message-ID: <1339013986.3437.20.camel@wall-e>
Subject: Re: [PATCH] fix usb skeleton driver
From: Stefani Seibold <stefani@seibold.net>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org, oneukum@suse.de,
        alan@lxorguk.ukuu.org.uk, linux-usb@vger.kernel.org
Date: Wed, 06 Jun 2012 22:19:46 +0200
In-Reply-To: <Pine.LNX.4.44L0.1206061406500.1788-100000@iolanthe.rowland.org>
References: <Pine.LNX.4.44L0.1206061406500.1788-100000@iolanthe.rowland.org>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Authenticated-Sender: stefani@seibold.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Mittwoch, den 06.06.2012, 14:16 -0400 schrieb Alan Stern:
> On Wed, 6 Jun 2012, Stefani Seibold wrote:
> 
> > Am Mittwoch, den 06.06.2012, 12:55 -0400 schrieb Alan Stern:
> > > On Wed, 6 Jun 2012 stefani@seibold.net wrote:
> > > 
> > > > From: Stefani Seibold <stefani@seibold.net>
> > > > 
> > > > This is a fix for the USB skeleton driver to bring it in shape.
> > > > 
> > > > - The usb_interface structure pointer will be no longer stored 
> > > > - Every access to the USB will be handled trought the usb_interface pointer
> > > 
> > 
> > Sorry, missed to fix. Should be:
> > 
> > Every access to the USB will be handled through the usb_device pointer
> 
> But that's wrong -- the accesses should go through the interface 
> pointer.  After all, the driver is bound to the interface, not to the 
> device.
> 

Not really true, in whole driver only the open() and close() use the
interface pointer.

In the open path the interface is already determinate by
usb_find_interface(), so it was reasonable to do this also in the close
path.

> > > > - Introduced fsync
> > > > - Single user mode
> > > > - Eliminated dead code
> > > > - Save some bytes in the dev structure
> > > 
> > > How about simplifying the code so that it can be read by somebody who's 
> > > not already an expert?
> > > 
> > > Alan Stern
> > > 
> > 
> > Hey, i thought i get a little thank you for the voluntary work, what a
> > nice job. Not a demand for more work to do.
> 
> Have you submitted many kernel patches in the past?  :-)  This is the 
> way it usually works out...
> 

Yes i did (kfifo, superio, procfs, udpcp, nrpz, mtd nand, framebuffer
and so on). And i know the way it works ;-) But i do this mostly in my
spear time.

> In this case, I really think it's worthwhile to look for ways to
> simplify usb-skeleton.c.  For example, does supporting fsync really
> help somebody who's trying to learn how to write a USB device driver?  
> I suspect it doesn't.
> 

The reason to fix the skeleton driver was about the complains for my
NRPZ driver, which was based on the design of the usb skeleton driver.

> Going even farther, I'm not so sure it's a good idea for usb-skeleton
> to try supporting both synchronous and asynchronous accesses.  This
> adds a layer of complexity that people just don't need.  IMO it would 
> be better to have two separate example drivers, an easy one that is 
> purely synchronous and a more advanced one that is purely async.
> 

Agree, i think this would be a good idea to have to separate drivers.
Both should be also working drivers, for really simple hardware.

The best way for me to do this is to shrink later this to a simplified
driver. 

> Now, things like the race between disconnect and open are good for
> teaching, because they crop up in every driver and have to be handled.  
> Other things aren't so clear (such as the autosuspend support).
> 

I think it is important to have a clean and working example. It would
save a lot of time for everybody and shrinks the number of round trips.

Greetings,
Stefani


