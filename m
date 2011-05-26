Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758011Ab1EZObu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 10:31:50 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:32979 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757992Ab1EZObs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 10:31:48 -0400
Date: Thu, 26 May 2011 10:31:47 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Tanya Brokhman <tlinder@codeaurora.org>
cc: balbi@ti.com, "'Sarah Sharp'" <sarah.a.sharp@linux.intel.com>,
        <greg@kroah.com>, <linux-usb@vger.kernel.org>,
        <linux-arm-msm@vger.kernel.org>, <ablay@codeaurora.org>,
        "'open list'" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v12 7/8] usb: Adding SuperSpeed support to dummy_hcd
In-Reply-To: <01fc01cc1b71$53e2d210$fba87630$@org>
Message-ID: <Pine.LNX.4.44L0.1105261028040.1960-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 26 May 2011, Tanya Brokhman wrote:

> > > Right, but at this point there is no way of knowing what function
> > drivers
> > > will bind to it and what descriptors they will provide. Most of the
> > > function drivers allocate their descriptors at bind() that occurs
> > after
> > > the UDC already registers.
> > 
> > Well, there must be an appropriate spot to do this.
> 
> Unfortunately in the current implementation there isn't.

Sure there is.  You describe a good possibility later on in your 
email...

> > It looks like you need to add a "max_speed" field to struct
> > usb_composite_driver.  Each driver will initialize this to the highest
> > speed it supports, and it must guarantee that the necessary descriptors
> > are available.
> 
> I also thought of that. This can be done...
> Just to make sure we're on the same page:
> We can add a "max_sup_speed" field to struct usb_composite_driver. Each of
> the Gadget drivers will set this field prior to calling
> usb_composite_probe(). Then, in usb_composite_probe(), we'll update the
> composite_driver.speed as follows:
> 
> 	composite_driver.speed = min(composite_driver.speed,
> driver->max_sup_speed);

Just call it max_speed.  You can mention in the kerneldoc that it is 
the maximum speed supported by the driver.

> Of course for SS we'll update the composite_driver.speed @ static struct
> usb_gadget_driver composite_driver, as we agreed with Felipe.
> 
> How does that sound? Felipe - it seems to me that these should cover your
> hesitations about updating the driver speed :)
> 
> Now that I think about it, the above will be true for HS as well. I mean the
> current speed of composite_driver is set always to HS but if there is a
> function driver that supports only FS then the above will update
> composite_driver.speed to FS.

That's right.  The same solution will work for both cases.

Alan Stern

