Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753750Ab1EYR3R (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 13:29:17 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:35551 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752964Ab1EYR3P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 13:29:15 -0400
Date: Wed, 25 May 2011 13:29:14 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Brokhman Tatyana <tlinder@codeaurora.org>
cc: balbi@ti.com, "'Sarah Sharp'" <sarah.a.sharp@linux.intel.com>,
        <greg@kroah.com>, <linux-usb@vger.kernel.org>,
        <linux-arm-msm@vger.kernel.org>, <ablay@codeaurora.org>,
        "'open list'" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v12 7/8] usb: Adding SuperSpeed support to dummy_hcd
In-Reply-To: <fa2182365beee6fa243f8d3957e2da2b.squirrel@www.codeaurora.org>
Message-ID: <Pine.LNX.4.44L0.1105251316170.1987-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 25 May 2011, Brokhman Tatyana wrote:

> Hi Alan,
> 
> > I have looked this over more carefully.  It turns out that both of you
> > have misunderstood the purpose of CONFIG_USB_GADGET_DUALSPEED (and by
> > extension, CONFIG_USB_GADGET_SUPERSPEED).  In fact, the existing
> > Kconfig file is also wrong.
> >
> > The _only_ reason for CONFIG_USB_GADGET_DUALSPEED is so that gadget
> > drivers can use conditional compilation to avoid including the
> > high-speed descriptors when the UDC doesn't support high-speed
> > operation.  That's all.  This means that the
> > CONFIG_USB_GAGDET_DUALSPEED option does not need to be
> > user-controllable in Kconfig.  It should default to N, and UDC drivers
> > that support high speed should select it.
> >
> > The same should be true of CONFIG_USB_GADGET_HIGHSPEED.  It should not
> > be user-controllable.  It should default to N, and UDC drivers that
> > support SuperSpeed operation (after these patches, only dummy-hcd)
> > should select it.
> 
> Ok, agreed. Thanks for the clarification. I saw your patch, I'll update
> mine in the same way.

Good.  If Felipe doesn't object to my patch, I'll send it to Greg.

> > There remains the other question, about whether composite_driver.speed
> > should be set to USB_SPEED_SUPER.  I think the matter can be settled at
> > runtime.  Iterate through all the function drivers; if all of them
> > support SuperSpeed and CONFIG_USB_GADGET_SUPERSPEED is enabled then set
> > composite_driver.speed to USB_SPEED_SUPER.
> 
> Not sure how to verify this. I need to know whether the driver that is
> registered with the UDC is SS or not. This is before the function drivers
> are binded to it. So how can I verify at that point that the function
> drivers that will bind to this driver will provide SS descriptors?
> (I'm sorry, I don't have the ability to view the code at the moment and
> due to the time differences between us I don't want to leave this question
> for tomorrow and loose another day...)

I'm not sure about this either.  I have never used the composite
framework so I'm not familiar with its details.  This has to be decided
before the composite gadget driver registers with the UDC driver ...  
and surely that can't happen until all the function drivers have
registered with the composite driver?  After all, the gadget can't be
enumerated until all the function drivers are registered.

Maybe this logic can be put in usb_add_function()?  That routine
already deals with issues involving device speed and available
descriptors.

Alan Stern

