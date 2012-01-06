Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758763Ab2AFOnA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jan 2012 09:43:00 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:48351 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1758741Ab2AFOm7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jan 2012 09:42:59 -0500
Date: Fri, 6 Jan 2012 09:42:58 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Greg KH <greg@kroah.com>
cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Kay Sievers <kay.sievers@vrfy.org>,
        USB list <linux-usb@vger.kernel.org>,
        Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: Problems with get_driver() and driver_attach() (and new_id too)
In-Reply-To: <20120105231731.GA15539@kroah.com>
Message-ID: <Pine.LNX.4.44L0.1201060940430.1326-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 5 Jan 2012, Greg KH wrote:

> > If Greg confirms that there's nothing with registering the usb driver 
> > before the usb_serial driver, I can fix the usb-serial code easily.
> > 
> > Greg, do you know offhand whether this will break anything?  It really 
> > seems like the right thing to do, because the usb_serial driver uses 
> > the usb driver but not vice versa.
> 
> Hm, there was a reason I ordered the way I did, as I remember having to
> go fix up a number of drivers that did it in the reverse order.  Give me
> a day or so to dig it up and figure out what is going on here, and to
> review this thread.

Well, the one obvious problem, if one isn't careful about it, is that
serial devices present before the module is loaded won't bind properly.  
The usb driver will get probed before the usb_serial driver is
registered, and the probe will fail.

I can fix that easily enough by calling driver_attach() for the usb
driver after all the usb_serial drivers are registered.

Alan Stern

