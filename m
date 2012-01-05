Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933036Ab2AEXRn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jan 2012 18:17:43 -0500
Received: from out5.smtp.messagingengine.com ([66.111.4.29]:38429 "EHLO
	out5.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932957Ab2AEXRl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jan 2012 18:17:41 -0500
X-Sasl-enc: /YosR3L8Q83e3++q7RsKkPVXyTQHbOUlcKCmin49uo9D 1325805460
Date: Thu, 5 Jan 2012 15:17:31 -0800
From: Greg KH <greg@kroah.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Kay Sievers <kay.sievers@vrfy.org>,
        USB list <linux-usb@vger.kernel.org>,
        Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: Problems with get_driver() and driver_attach() (and new_id too)
Message-ID: <20120105231731.GA15539@kroah.com>
References: <20120105200515.GA1071@core.coreip.homeip.net>
 <Pine.LNX.4.44L0.1201051531410.1434-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1201051531410.1434-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 05, 2012 at 03:48:19PM -0500, Alan Stern wrote:
> On Thu, 5 Jan 2012, Dmitry Torokhov wrote:
> 
> > So I looked at the users of device_attach():
> > 
> > - we call it from generic bus code when adding a new driver so naturally
> >   driver is valid there;
> > - serio and gameport call it by hand but they ensure that the driver is
> >   valid because they protected by subsystem-private mutex;
> > - PCI, PCMCI, HID and USB new_id handling is tied to the driver itself
> >   and attributes are removed when driver is unregistered so there is no
> >   chance driver will be attached through newid after it has been
> >   unregistered;
> > - agp_amd64_init calls it once immediately after registering the driver;
> > - pci-stub driver is safe as well.
> 
> Okay, that's all good.
> 
> > That leaves only usb-serial which is problematic exactly as you
> > described below. So I think we should remove get_driver() and
> > put_driver(); document that caller if driver_attach() should ensure
> > that driver is live and let usb-serial code solve this issue as this
> > is the only code that plays games with drivers it does not own.
> 
> If Greg confirms that there's nothing with registering the usb driver 
> before the usb_serial driver, I can fix the usb-serial code easily.
> 
> Greg, do you know offhand whether this will break anything?  It really 
> seems like the right thing to do, because the usb_serial driver uses 
> the usb driver but not vice versa.

Hm, there was a reason I ordered the way I did, as I remember having to
go fix up a number of drivers that did it in the reverse order.  Give me
a day or so to dig it up and figure out what is going on here, and to
review this thread.

thanks,

greg k-h
