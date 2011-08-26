Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753354Ab1HZStJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Aug 2011 14:49:09 -0400
Received: from netrider.rowland.org ([192.131.102.5]:59338 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751929Ab1HZStH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Aug 2011 14:49:07 -0400
Date: Fri, 26 Aug 2011 14:49:05 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Greg KH <greg@kroah.com>
cc: Michal Nazarewicz <mnazarewicz@google.com>, Felipe Balbi <balbi@ti.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Yang Rui Rui <ruirui.r.yang@tieto.com>,
        Dave Young <hidave.darkstar@gmail.com>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCHv5 1/4] usb: Provide usb_speed_string() function
In-Reply-To: <20110826183450.GA32142@kroah.com>
Message-ID: <Pine.LNX.4.44L0.1108261437200.2275-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 26 Aug 2011, Greg KH wrote:

> > > No, this should be in include/linux/usb.h, not ch9.h.
> > 
> > There's a reason for both of these things.  The usb_speed_string 
> > routine, like the other stuff in ch9.h, is meant to be used with both 
> > the host-side and device-side USB stacks.
> 
> Ok, the __KERNEL__ stuff threw me off, those should not be in the patch
> as they are not needed, so it's ok to keep it here, sorry.

The __KERNEL__ guard is needed there because ch9.h is one of the files 
exported to /usr/include/linux.

> > This makes deciding where to put it kind of difficult.  The two stacks 
> > are pretty much independent; one might be built into the kernel while 
> > the other is built as modules.  The easiest solution that will always 
> > work is to put common.c into the main kernel.
> 
> A module, if the USB Host core is a module, and a module if the USB
> gadge core is a module, would be best if at all possible.  I'm a bit
> leery of adding stuff to be built into the kernel no matter how the user
> decided to configure USB.
> 
> Is this possible with the Kbuild system somehow?

I don't know.  Michal, can you look into this?  What we want is:

	common.o gets included in the main kernel if either CONFIG_USB 
	or CONFIG_USB_GADGET is set to Y.

	Otherwise, if either symbol is set to M then common.o gets 
	built into its own little module.  Perhaps some other stuff
	could get put in there too, though at the moment I can't
	think of anything.

Alan Stern

