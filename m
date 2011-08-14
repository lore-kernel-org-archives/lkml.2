Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754184Ab1HNRip (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Aug 2011 13:38:45 -0400
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:55525 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752705Ab1HNRim (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Aug 2011 13:38:42 -0400
X-Sasl-enc: mW1toJ8O3GUOgaLdjxcZSVJANzBNQe4ZG0LuvE51oYLu 1313343521
Date: Sun, 14 Aug 2011 10:38:16 -0700
From: Greg KH <greg@kroah.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: linux-kernel@vger.kernel.org, Linux/m68k <linux-m68k@vger.kernel.org>
Subject: Re: Driver framework: binding a driver to two devices?
Message-ID: <20110814173816.GA10062@kroah.com>
References: <CAMuHMdVr9iAyqQJUgHq4gcLg+gp7GxF=sH+SBKBuqVWYymXs8Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMuHMdVr9iAyqQJUgHq4gcLg+gp7GxF=sH+SBKBuqVWYymXs8Q@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 13, 2011 at 10:44:42PM +0200, Geert Uytterhoeven wrote:
> As Amiga Zorro expansion boards have only one BAR (unlike PCI, which has
> multiple BARs), several Amiga graphics cards show up as two Zorro devices:
> one for the graphics memory and one for the graphics controller's registers.
> 
> Traditionally, a driver for such a device used
> 
>     dev1 = zorro_find_device(id1, ...)
>     dev2 = zorro_find_device(id2, ...)
> 
> to find the two devices and match them.
> 
> With the "new" driver framework, the matching with device id1 is now
> done using a
> struct zorro_driver with a table of IDs, while the matching with device id2 is
> still done by calling zorro_find_device(id2, ...).
> 
> Recently (with cirrusfb) it turned out that the call to
> zorro_find_device(id2, ...)
> may fail to find the second device. I suspect this happens due to the second
> device haven't been probed for at the time the zorro_driver for the
> first device is
> initialized.
> 
> I expect this can be fixed by delaying all calls to device_register() in
> amiga_zorro_probe() until all devices have been detected and added to the array
> used by zorro_find_device(). But I was wondering whether there's a more generic
> way in the driver framework to bind a driver to two devices?

What you really want is the same "driver instance" bound to two devices,
right?  That way the device would operate "knowing" about both physical
devices so as to properly control the thing.

Right now, no, there's not a simple way to do this with the driver
model.  USB does this on its own for some devices that need to have
multiple "interfaces" (the USB equalivant for a "device") controlled at
the same time, so you might want to look at how that happens (in the
indivdual drivers, not in the USB core.)

Sorry,

greg k-h
