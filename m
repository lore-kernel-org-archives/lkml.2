Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755501Ab1HRO7b (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Aug 2011 10:59:31 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:41052 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753228Ab1HRO7a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Aug 2011 10:59:30 -0400
Date: Thu, 18 Aug 2011 10:59:28 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Michal Nazarewicz <mnazarewicz@google.com>
cc: Sergei Shtylyov <sshtylyov@mvista.com>, Felipe Balbi <balbi@ti.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Yang Rui Rui <ruirui.r.yang@tieto.com>,
        Greg Kroah-Hartman <gregkh@suse.de>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCHv2] usb: gadget: get rid of USB_GADGET_DUALSPEED and
 USB_GADGET_SUPERSPEED
In-Reply-To: <op.v0evaiyqvgw7ix@mnazarewicz-glaptop>
Message-ID: <Pine.LNX.4.44L0.1108181055240.1912-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 18 Aug 2011, Michal Nazarewicz wrote:

> On Wed, 17 Aug 2011 23:09:37 +0200, Alan Stern <stern@rowland.harvard.edu>  
> wrote:
> > I see what's going on here.  Your original patch was wrong and then my
> > correction was wrong as well.
> >
> > This line has to remain the way it was (although those (u8) typecasts
> > don't seem to be necessary).  Above, you have to initialize
> > composite_driver.speed to an appropriate value, probably
> > USB_SPEED_SUPER.
> >
> > What you didn't realize in your original patch is that
> > usb_composite_probe() gets called more than once.  Each time it is
> > called, it has to adjust composite_driver.speed.
> 
> That's sneaky of composite.c...  But is it desired behaviour?

Yes, it is.

>  I cannot
> came up with a situation where that's what we want.  I would imagine that
> usb_composite_probe() should assume the same speed for given
> usb_composite_driver regardless if some other slower usb_composite_driver
> was loaded.

The speed being calculated isn't the speed of the usb_composite_driver; 
it's the speed of the usb_gadget_driver.  The gadget itself cannot be 
allowed to run faster than its internal drivers can handle.

For example, if you have a composite gadget where one of the function 
drivers can handle SuperSpeed and the other can't go beyond high speed, 
the overall gadget must never run faster than high speed.

Alan Stern

