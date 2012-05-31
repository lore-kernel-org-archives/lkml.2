Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757623Ab2EaOdX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2012 10:33:23 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:43942 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757278Ab2EaOdV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2012 10:33:21 -0400
Date: Thu, 31 May 2012 22:32:55 +0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Oliver Neukum <oneukum@suse.de>
Cc: Stefani Seibold <stefani@seibold.net>, linux-kernel@vger.kernel.org,
        thomas.braunstorfinger@rohde-schwarz.com
Subject: Re: [PATCH] add new NRP power meter USB device driver
Message-ID: <20120531143255.GA7069@kroah.com>
References: <1338318858-24144-1-git-send-email-stefani@seibold.net>
 <201205311432.40695.oneukum@suse.de>
 <20120531124845.GA5844@kroah.com>
 <201205311622.31537.oneukum@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201205311622.31537.oneukum@suse.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 31, 2012 at 04:22:31PM +0200, Oliver Neukum wrote:
> Am Donnerstag, 31. Mai 2012, 14:48:45 schrieb Greg KH:
> > On Thu, May 31, 2012 at 02:32:40PM +0200, Oliver Neukum wrote:
> > >  Am Donnerstag, 31. Mai 2012, 14:04:11 schrieben Sie:
> > > > On Thu, May 31, 2012 at 12:17:11PM +0200, Oliver Neukum wrote:
> > > > > Am Donnerstag, 31. Mai 2012, 11:53:04 schrieb Greg KH:
> > > > > > > So it is a chicken and egg problem. A lot of software is now out with
> > > > > > > depends on this driver and a lot of embedded development environments
> > > > > > > doesn't provide libudev, libsysfs und libusb. It will also increase the
> > > > > > > size of the image and adds additional dependencies to the application.
> > > > > > 
> > > > > > You don't need any of those libraries to do this.  What's wrong with
> > > > > > using "raw" usbfs interactions?
> > > > > 
> > > > > SPI is not limited to USB. If we can get a unified subsystem then the
> > > > > drivers need to be in kernel space, as some hardware does not allow
> > > > > a solution in user space.
> > > > 
> > > > Ok, now that is a valid reason for a kernel driver.
> > > > 
> > > > But, I think it should use the IIO interface, as that should handle
> > > > these types of devices.
> > > 
> > > Bad gamble for the future. We will end up with an interface which
> > > would not be implementable.
> > 
> > Why do you say that?  What's wrong with IIO?
> 
> It seems to specialised for this kind of IO. SPI over USB is closer to a generic
> thing rather like sg or even a bus rather than an IIO device. Kernel space drivers
> that use SPI might belong into IIO. The infrastructure itself not so much.

Wait, are you talking about the SPI we already support in the kernel?
Or something else?  This driver really looks like it wants to send to
userspace "measurements" of something, which IIO is for.

Anyway, as-is, this isn't acceptable, I'm sure we can all agree on that
:)

thanks,

greg k-h
