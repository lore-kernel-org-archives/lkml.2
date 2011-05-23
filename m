Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756491Ab1EWQaf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 12:30:35 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:60937 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756376Ab1EWQae (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 12:30:34 -0400
Date: Mon, 23 May 2011 12:28:27 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Sarah Sharp <sarah.a.sharp@linux.intel.com>
cc: Tanya Brokhman <tlinder@codeaurora.org>, <balbi@ti.com>, <greg@kroah.com>,
        <linux-usb@vger.kernel.org>, <linux-arm-msm@vger.kernel.org>,
        <ablay@codeaurora.org>, "'open list'" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v12 7/8] usb: Adding SuperSpeed support to dummy_hcd
In-Reply-To: <20110523160803.GB5606@xanatos>
Message-ID: <Pine.LNX.4.44L0.1105231220230.2020-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 23 May 2011, Sarah Sharp wrote:

> > 2. whether the device HW supports SS protocol. In our scenario it can since
> > SS support is enabled in our udc. (We haven't released it yet.)
> 
> What is a UDC?

USB Device Controller.  It's the device-side analog of a host
controller.

> > Since in dummy_hcd all of this is much simpler I think that the device speed
> > should be determined by driver->speed and "which type of cable the
> > connection was made over - SS or HS". The "cable type" is exactly what the
> > module parameter is.
> 
> I really don't understand this.  You're going to have a module parameter
> for what type of cable is plugged in?

It would be more accurate to say the module parameter will be used to
force the connection to run at a lower speed than the maximum possible.  
This is kind of like what happens when you plug in a SuperSpeed device 
using a USB-2 cable -- the connection runs at a lower speed than it 
could have.

>  How can you tell which one the
> user is going to use?

This isn't about actual cables or devices.  dummy-hcd is an emulator;  
it presents as a host controller and a device controller both on the
same system.  This allows people to test gadget drivers without having
any UDC hardware.

>  What about the case where SuperSpeed enumeration
> fails and you have to fall back to high speed?

If SuperSpeed enumeration fails, say because the device doesn't have 
any SuperSpeed descriptors, xhci-hcd doesn't fall back to high speed, 
does it?  dummy-hcd should behave the same way.

>  It seems like you really
> need to handle both speeds and the speed fall back parameter in the same
> driver.  Isn't there some other gadget driver that has a fall back to
> full or low speed when high speed enumeration fails?

That's a property of the gadget driver, not the UDC driver.  dummy-hcd 
is a UDC driver (and an HCD too).

Alan Stern

