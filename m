Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756642Ab1ILOHo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Sep 2011 10:07:44 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:39668 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756058Ab1ILOHm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Sep 2011 10:07:42 -0400
Date: Mon, 12 Sep 2011 10:07:41 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Markus Rechberger <mrechberger@gmail.com>
cc: Greg KH <greg@kroah.com>, Oliver Neukum <oliver@neukum.org>,
        USB list <linux-usb@vger.kernel.org>,
        Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Increase usbfs bulk buffer size
In-Reply-To: <CA+O4pCKvi7rYYC=NSGgufA4T2Gajvj=+Z5YCdLKaDkcSVQ7jwA@mail.gmail.com>
Message-ID: <Pine.LNX.4.44L0.1109121002560.1983-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 12 Sep 2011, Markus Rechberger wrote:

> On Mon, Sep 12, 2011 at 1:33 PM, Greg KH <greg@kroah.com> wrote:
> > On Mon, Sep 12, 2011 at 12:18:02PM +0200, Markus Rechberger wrote:
> >> Hi,
> >>
> >> I'm a little bit curious why you guys are just ignoring this.
> >
> > Because you seem to be ignoring the fact that changing this can cause
> > problems on systems.
> >
> 
> Can you explain which problems? We are even using analogTV on
> Freescale ARM Systems.
> There is no way to read the maximum allowed buffersize from the kernel
> right now,
> if an application wants to use it they roughly need to know the
> current maximum packet size.

I don't understand.  Surely applications need to know the maximum 
packet size exactly (not just roughly!) in any case.  They can get that 
value easily by looking at the endpoint descriptor.

Do you mean applications need to know the maximum buffer size?  Why do 
they need to know it?

> Since this is about a product I'm not eager to introduce trouble to
> our customers frankly speaking
> those things are well tested at our side.
> 
> > And because it really doesn't solve any problems,
> 
> wrong, it does solve problems, and it also solved it in the past for
> isochronous.

I can understand that increasing the maximum isochronous buffer size 
fixed a problem.  It's not so clear why increasing the maximum bulk 
buffer size would fix anything, though.  You haven't explained this.

>  Would it help if we ship a sample
> device to you?
> The easiest way to reproduce this is to take 2 different Ubuntu
> versions, an old one with lower Isochronous packet size eg. Ubuntu
> 9.04
> and another new one Ubuntu 10.04.
> Simply dragging the player with Ubuntu 9.04 can cause framedrops,
> while it works smoothly with 10.04.
> Next step update the buffer with 9.04 and the video is also smoothly
> with the old version - and there are no framedrops (=incomplete data).
> I can imagine because the application just gets a certain timeslice
> and cannot reliable requeue many packets.
> The problem with Bulk is that we need to submit many Bulk URBs in
> order to get it work at all, aside of that it shows up the
> same issue as with isochronous.

What's wrong with submitting many bulk URBs?

Besides, if you use libusb then the library will automatically break up
the transfer into as many URBs as necessary.  The application doesn't
have to worry about it at all.

> > you are only pushing
> > the processing to the kernel, when it can be done in userspace just as
> > easily.
> >
> 
> Your assumption is wrong, even though I understand your point.

What's wrong with this assumption?

> All I want is to sort this out.

Alan Stern

