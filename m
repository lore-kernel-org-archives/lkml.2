Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753103Ab1HRR1Y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Aug 2011 13:27:24 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:57075 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750923Ab1HRR1X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Aug 2011 13:27:23 -0400
Date: Thu, 18 Aug 2011 13:27:21 -0400 (EDT)
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
In-Reply-To: <op.v0e5q6pyvgw7ix@mnazarewicz-glaptop>
Message-ID: <Pine.LNX.4.44L0.1108181323360.1912-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 18 Aug 2011, Michal Nazarewicz wrote:

> For the most part, usb_composite_probe() is called only once in module's
> init function.  As far as I know, only g_ffs calls it several times.  So
> in all cases expect for g_ffs, composite_driver.speed =  
> min(composite_driver.speed,
> driver->max_speed) should have the same effect as composite_driver.speed
> = driver->max_speed.
> 
> > For example, if you have a composite gadget where one of the function
> > drivers can handle SuperSpeed and the other can't go beyond high speed,
> > the overall gadget must never run faster than high speed.
> 
> Shouldn't that be dealt in usb_add_function()?  I cannot see any code that
> would do that here atm though.

Maybe you're right.  But isn't that too late?  The UDC driver has to 
know the gadget driver's limitations before it can connect to the host.

Alan Stern

