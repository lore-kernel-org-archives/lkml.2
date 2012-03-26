Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755489Ab2CZUHE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2012 16:07:04 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:45476 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754771Ab2CZUHB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2012 16:07:01 -0400
Date: Mon, 26 Mar 2012 16:06:59 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Greg KH <gregkh@linuxfoundation.org>
cc: Randy Dunlap <rdunlap@xenotime.net>,
        Stephen Rothwell <sfr@canb.auug.org.au>, <linux-next@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, <linux-usb@vger.kernel.org>
Subject: Re: linux-next: Tree for Mar 26 (usbcore)
In-Reply-To: <20120326180736.GA2893@kroah.com>
Message-ID: <Pine.LNX.4.44L0.1203261550290.1179-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 26 Mar 2012, Greg KH wrote:

> On Mon, Mar 26, 2012 at 09:58:36AM -0700, Randy Dunlap wrote:
> > On 03/25/2012 09:28 PM, Stephen Rothwell wrote:
> > 
> > > Hi all,
> > > 
> > > Reminder: please do not add stuff destined for v3.5 to linux-next
> > > included trees/branches until after v3.4-rc1 has been released.
> > > 
> > > Changes since 20120323:
> > 
> > 
> > 
> > on x86_64:
> > 
> > ERROR: "utf16s_to_utf8s" [drivers/usb/core/usbcore.ko] undefined!
> > ERROR: "usb_speed_string" [drivers/usb/core/usbcore.ko] undefined!
> > 
> > Full randconfig file is attached.
> 
> Odd, nothing in the usb core has changed in a while in this area,
> although we might have gotten some core dependancies mixed up for random
> configurations like this.

This is puzzling.

	utf16s_to_utf8s is defined in fs/nls/nls_base.c,
	which is built according to CONFIG_NLS (in fs/nls/Makefile),
	which is selected by CONFIG_USB (in drivers/usb/Kconfig).

But the config that Randy attached had CONFIG_USB set to M and 
CONFIG_NLS not set.  How is that possible?

	usb_speed_string is defined in drivers/usb/usb-common.c,
	which is built according to CONFIG_USB_COMMON (in
		drivers/usb/Makefile),
	which defaults to Y if CONFIG_USB_SUPPORT and either
		CONFIG_USB or CONFIG_USB_GADGET is set (in 
		drivers/usb/Kconfig).

The problem here was that CONFIG_USB_SUPPORT isn't set but CONFIG_USB
is set to M.  This used not to be possible, since CONFIG_USB was
defined inside an "if USB_SUPPORT" section.  Maybe that got changed and
needs to be fixed (but
https://git.kernel.org/?p=linux/kernel/git/next/linux-next.git thinks
it's still not possible).  Or maybe Randy's tree is a little out of 
date.

Alan Stern

