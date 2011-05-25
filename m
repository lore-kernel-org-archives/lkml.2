Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754525Ab1EYS7E (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 14:59:04 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:50758 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752481Ab1EYS7B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 14:59:01 -0400
Date: Wed, 25 May 2011 14:59:00 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Brokhman Tatyana <tlinder@codeaurora.org>
cc: balbi@ti.com, "'Sarah Sharp'" <sarah.a.sharp@linux.intel.com>,
        <greg@kroah.com>, <linux-usb@vger.kernel.org>,
        <linux-arm-msm@vger.kernel.org>, <ablay@codeaurora.org>,
        "'open list'" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v12 7/8] usb: Adding SuperSpeed support to dummy_hcd
In-Reply-To: <8ce4e30b4a406fadf08af2daff163984.squirrel@www.codeaurora.org>
Message-ID: <Pine.LNX.4.44L0.1105251443040.1987-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 25 May 2011, Brokhman Tatyana wrote:

> 
>  composite_driver.speed to USB_SPEED_SUPER.
> >>
> >> Not sure how to verify this. I need to know whether the driver that is
> >> registered with the UDC is SS or not. This is before the function
> >> drivers
> >> are binded to it. So how can I verify at that point that the function
> >> drivers that will bind to this driver will provide SS descriptors?
> >> (I'm sorry, I don't have the ability to view the code at the moment and
> >> due to the time differences between us I don't want to leave this
> >> question
> >> for tomorrow and loose another day...)
> >
> > I'm not sure about this either.  I have never used the composite
> > framework so I'm not familiar with its details.  This has to be decided
> > before the composite gadget driver registers with the UDC driver ...
> Right, but at this point there is no way of knowing what function drivers
> will bind to it and what descriptors they will provide. Most of the
> function drivers allocate their descriptors at bind() that occurs after
> the UDC already registers.

Well, there must be an appropriate spot to do this.

It looks like you need to add a "max_speed" field to struct 
usb_composite_driver.  Each driver will initialize this to the highest 
speed it supports, and it must guarantee that the necessary descriptors 
are available.

Since these structures are passed to usb_composite_probe() before the 
gadget driver is registered, the necessary calculations can be done 
there.

Alan Stern

