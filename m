Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755578Ab1CKVpu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Mar 2011 16:45:50 -0500
Received: from kroah.org ([198.145.64.141]:55666 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755433Ab1CKVpr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Mar 2011 16:45:47 -0500
Date: Fri, 11 Mar 2011 13:44:06 -0800
From: Greg KH <greg@kroah.com>
To: andy.green@linaro.org
Cc: Alan Stern <stern@rowland.harvard.edu>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Linux USB list <linux-usb@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: RFC: Platform data for onboard USB assets
Message-ID: <20110311214406.GA29582@kroah.com>
References: <Pine.LNX.4.44L0.1103111406270.1975-100000@iolanthe.rowland.org>
 <4D7A80A4.6040008@linaro.org>
 <20110311202135.GA10795@kroah.com>
 <4D7A8F28.4080908@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D7A8F28.4080908@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 11, 2011 at 09:07:52PM +0000, Andy Green wrote:
> On 03/11/2011 08:21 PM, Somebody in the thread at some point said:
> 
> >>Is a gadget driver a class driver?
> >
> >Some are, but you are now on the "other side" of the USB bus.
> 
> The goal of this is to allow board-specific data to define
> platform_data in any bus members.

Ok, but I still don't think that's a worthy goal, as for some buses
(i.e. USB), it makes no sense.

> >>Because I can set the MAC address for my g_ether from the kernel
> >>commandline which is most definitely an "information source outside
> >>the USB protocol".  That is exactly the kind of thing I am talking
> >>about enabling also to be taken from usb_device->dev.platform_data.
> >
> >You don't have a usb_device for a gadget device.  USB Gadgets are a
> >totally different world here, don't confuse them please.
> 
> Okay; but all that matters for this is that usb_gadget has a struct
> device composed in it, which in turn has a platform_data.  Gadget
> drivers can also benefit from the mapping scheme the same way.

Perhaps.

> I wrote up this RFC after a quick check struct device exists in the
> usb objects and grepping that nothing uses platform_data already.
> If it isn't killed dead during this I will make workable patches for
> comment.

Let's see workable patches before I shoot it down any further :)

> >>Using a .name defined to be the first member to match to specific
> >>bus member devpath prepended with bus class:
> >
> >You can't rely on USB bus numbers to be the same EVER.  These are
> >assigned by the host computer.
> 
> Alright: is there a better invariant nomenclature to talk about "the
> gadget / host that is running on a particular pair of pins"?  That's
> the ultimate definition of what's wired to what.

For USB, there is no such thing, sorry.  You can see the "device
connected to the 3rd port of the second hub" but that's a mess and those
numbers can (and do) change randomly at boot time.

> It's okay if the nomenclature differs for gadget or host because we
> can prepend a namepace token that is checked for before looking for
> a match in each case.

I'd have to see your patch for how you do this, but again note that USB
device numbering is NOT deterministic in any way.  Just like PCI device
numbering isn't.  You would have the same problem there as well if you
were to want to do this type of thing.

> >>Well, it's an RFC so if you have a better plan I am all ears.
> >
> >I am totally confused, and as you are messing with bus id numbers, and
> >confusing usb gadgets and drivers, I think you are as well.
> >
> >So, are you talking about USB gadgets, or USB drivers here?  They are
> >different and have different requirements and responsibilities.
> 
> Both can make use of platform_data.  At the moment both gadget and
> host USB devices have NULL platform data members sitting there.

Host USB devices are different, as I noted before.

> What this proposal is about is being able to teleport structs into
> those pointers from the board file, when gadget or host are
> instantiated that match. After that, drivers that are interested to
> take direction about anything can tell what they're willing to look
> at in their platform_data struct definition.

Ok, let's see code before continuing to argue.

thanks,

greg k-h
