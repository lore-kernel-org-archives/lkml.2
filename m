Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031054Ab1EWV0V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 17:26:21 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:45364 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1030208Ab1EWV0S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 17:26:18 -0400
Date: Mon, 23 May 2011 17:21:01 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Felipe Balbi <balbi@ti.com>
cc: Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Tanya Brokhman <tlinder@codeaurora.org>, <greg@kroah.com>,
        <linux-usb@vger.kernel.org>, <linux-arm-msm@vger.kernel.org>,
        <ablay@codeaurora.org>, "'open list'" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v12 7/8] usb: Adding SuperSpeed support to dummy_hcd
In-Reply-To: <BD27AEAC-1E6D-480C-9E18-A970B992AD75@ti.com>
Message-ID: <Pine.LNX.4.44L0.1105231710590.2020-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 May 2011, Felipe Balbi wrote:

> > It would be more accurate to say the module parameter will be used to
> > force the connection to run at a lower speed than the maximum possible.  
> > This is kind of like what happens when you plug in a SuperSpeed device 
> > using a USB-2 cable -- the connection runs at a lower speed than it 
> > could have.
> 
> if it's something like that, for sure we can have the module parameter. But
> plugging a USB2 gadget/function to a USB3-capable UDC/HCD should
> work fine.
> 
> With Tatyana's patches, if we load a USB2 g_zero to dummy_hcd, enumeration
> will fail where it shouldn't. This has been my whole point ;-) Maybe I wasn't
> clear enough.

I guess not.  I thought Tatyana said she was working to fix that bug...

> >> What about the case where SuperSpeed enumeration
> >> fails and you have to fall back to high speed?
> > 
> > If SuperSpeed enumeration fails, say because the device doesn't have 
> > any SuperSpeed descriptors, xhci-hcd doesn't fall back to high speed, 
> > does it?  dummy-hcd should behave the same way.
> 
> it should at least. Isn't that what happens between EHCI/OHCI ? HS Chirp
> sequencing fails, then we fall back to FullSpeed.

That's a failure in initialization, not a failure in enumeration.

There are two reasons why the HS chirp might fail: the device doesn't 
support high speed operation or hardware errors prevent the chirp from 
working.  With dummy-hcd there are no hardware errors (because there's 
no hardware).

As for whether or not the device supports high-speed or SuperSpeed
operation, that's determined by the usb_gadget_driver->speed field.  If 
the field doesn't specify SuperSpeed then dummy-hcd should connect the 
gadget to the USB-2 root hub rather than the USB-3 root hub.  Isn't 
that what Tatyana's patch does?  It contains a line saying:

		dum->gadget.speed = driver->speed;

> >> It seems like you really
> >> need to handle both speeds and the speed fall back parameter in the same
> >> driver.  Isn't there some other gadget driver that has a fall back to
> >> full or low speed when high speed enumeration fails?
> > 
> > That's a property of the gadget driver, not the UDC driver.  dummy-hcd 
> > is a UDC driver (and an HCD too).
> 
> USB3.0 dummy_hcd should still enumerate USB2.0 gadget drivers.

Yes, certainly it should.  If it doesn't, that's a bug, not a design 
error.

Alan Stern

