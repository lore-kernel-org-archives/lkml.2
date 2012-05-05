Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757571Ab2EERuD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 May 2012 13:50:03 -0400
Received: from mail-pz0-f45.google.com ([209.85.210.45]:33447 "EHLO
	mail-pz0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756490Ab2EERuC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 May 2012 13:50:02 -0400
Date: Sat, 5 May 2012 10:49:57 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Martin Mokrejs <mmokrejs@fold.natur.cuni.cz>
Cc: Paul Bolle <pebolle@tiscali.nl>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] usb: also announce bcdDevice
Message-ID: <20120505174957.GA28364@kroah.com>
References: <1336218719.8450.19.camel@x61.thuisdomein>
 <4FA519B3.9030901@fold.natur.cuni.cz>
 <20120505145224.GA27469@kroah.com>
 <4FA54292.5000102@fold.natur.cuni.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FA54292.5000102@fold.natur.cuni.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 05, 2012 at 05:09:06PM +0200, Martin Mokrejs wrote:
> Greg Kroah-Hartman wrote:
> > On Sat, May 05, 2012 at 02:14:43PM +0200, Martin Mokrejs wrote:
> >> Paul Bolle wrote:
> >>> Currently announce_device() does print the idVendor and idProduct values
> >>> but does not print the bcdDevice value. USB devices are accurately
> >>> identified by all three values. See, for instance, the USB storage
> >>> quirks which will only apply for a certain (range of) bcdDevice
> >>> value(s). So it seems useful to also print bcdDevice when announcing USB
> >>> devices.
> >>
> >> Could it also report negotiated speed? full-speed, high-speed, super-speed?
> > 
> > All of this, including the bcdDevice, can be found in sysfs.  So I don't
> > want to take this patch, otherwise we would be just adding more and more
> > to the kernel log.
> > 
> > If you programatically want to find this out, use libudev or listen to
> > the dbus messages for new devices, don't watch the kernel log messages.
> 
> Hmm, but when you go through your syslog/dmesg lines especially in case of
> USB devices which you swap in and out quite often, it is too late to lookup
> some file elsewhere which relates to *current* device. The information
> is lost already if you changed device meanwhile. You just realize USB disk
> disconnected but you have not way find out except from the log files what
> speed did it use. In case of USB3 devices capable of lower speeds it is
> quite important. Some just claim USB3 capabilities (on the package box)
> but in real, always end up at high-speed only.

Then use a tool that tracks this type of thing (hint, it's not syslog).
That is what the patches that recently got sent to lkml are trying to
help accomplish.  It doesn't entail sending all of the device
information to the kernel log for every device, that's just noise.

> For me testing several USB disks, USB to SATA bridges, host controllers,
> kernel command-lines ... it is way to much work. Having the USB debug
> enabled, especially XHCI_HCD_DEBUG gives on the other had too much output
> for daily use but as this is all stuff prone to fail somewhere and at some
> point I keep it enabled.
> 
> I don't think it clutters syslog nor that it adds significant extra size
> to the output. It would save people from enabling debug just because of this.
> And no, average linux user never never lookup sysfs nor use libudev, really.
> Still, the link speed is of interest to everybody fiddling with the stuff
> and wondering why the damn thing is so slow or why did it disconnect. It gives
> an answer or at least a hint.
> 
> And if it is not enough to identify a device based on idVendor and idProduct
> but one needs also bcdDevice, why not to print it?

Why not print all other usb information to the syslog?  i.e. where do
you stop?  Right now, we are stopping at idVendor and idProduct, sorry.

greg k-h
