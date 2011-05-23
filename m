Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755359Ab1EWOTF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 10:19:05 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:35002 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755233Ab1EWOTD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 10:19:03 -0400
Date: Mon, 23 May 2011 10:18:35 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Felipe Balbi <balbi@ti.com>
cc: Tatyana Brokhman <tlinder@codeaurora.org>, <greg@kroah.com>,
        <linux-usb@vger.kernel.org>, <linux-arm-msm@vger.kernel.org>,
        <ablay@codeaurora.org>, open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v12 7/8] usb: Adding SuperSpeed support to dummy_hcd
In-Reply-To: <20110523070556.GJ3095@legolas.emea.dhcp.ti.com>
Message-ID: <Pine.LNX.4.44L0.1105231012330.2020-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 23 May 2011, Felipe Balbi wrote:

> > diff --git a/drivers/usb/gadget/dummy_hcd.c b/drivers/usb/gadget/dummy_hcd.c
> > index bf7981d..c2731d3 100644
> > --- a/drivers/usb/gadget/dummy_hcd.c
> > +++ b/drivers/usb/gadget/dummy_hcd.c
> > @@ -70,6 +70,15 @@ MODULE_DESCRIPTION (DRIVER_DESC);
> >  MODULE_AUTHOR ("David Brownell");
> >  MODULE_LICENSE ("GPL");
> >  
> > +struct dummy_hcd_module_parameters {
> > +	bool is_super_speed;
> > +};
> > +
> > +static struct dummy_hcd_module_parameters mod_data = {
> > +	.is_super_speed = false
> > +};
> > +module_param_named(is_super_speed, mod_data.is_super_speed, bool, S_IRUGO);
> > +MODULE_PARM_DESC(is_super_speed, "true to simulate SuperSpeed connection");
> 
> you shouldn't need this. You should always enable SuperSpeed for this
> driver.

I would say the opposite and go even farther.  It's good to have a way 
to force a SuperSpeed gadget to run at high speed, and it would also be 
good to have a way to force a high-speed gadget to run at full speed.

A module parameter seems to be the simplest way of doing this.

> > +		/*
> > +		 * We're connected and not reseted (reset occured now),
> 
> 'reseted' isn't proper spelling :-)

Neither is "occured".

> > @@ -1371,6 +1577,10 @@ static void dummy_timer(unsigned long _dum_hcd)
> >  	case USB_SPEED_HIGH:
> >  		total = 512/*bytes*/ * 13/*packets*/ * 8/*uframes*/;
> >  		break;
> > +	case USB_SPEED_SUPER:
> > +		/* Bus speed is 500000 bytes/ms, so use a little less */
> 
> isn't it 500000 bits/ms ?

SuperSpeed is 5 billion bits/s or 5 million bits/ms.  The physical
layer encodes each data byte using 10 bits, therefore the bus speed is
500000 bytes/ms.

Alan Stern

