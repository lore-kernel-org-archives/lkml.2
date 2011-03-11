Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754086Ab1CKUVu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Mar 2011 15:21:50 -0500
Received: from kroah.org ([198.145.64.141]:36037 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752920Ab1CKUVs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Mar 2011 15:21:48 -0500
Date: Fri, 11 Mar 2011 12:21:35 -0800
From: Greg KH <greg@kroah.com>
To: andy.green@linaro.org
Cc: Alan Stern <stern@rowland.harvard.edu>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Linux USB list <linux-usb@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: RFC: Platform data for onboard USB assets
Message-ID: <20110311202135.GA10795@kroah.com>
References: <Pine.LNX.4.44L0.1103111406270.1975-100000@iolanthe.rowland.org>
 <4D7A80A4.6040008@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D7A80A4.6040008@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 11, 2011 at 08:05:56PM +0000, Andy Green wrote:
> On 03/11/2011 07:12 PM, Somebody in the thread at some point said:
> 
> Hi -
> 
> >>I don't believe I referred to class devices anywhere.  It does not
> >>matter if the main chip function is class device or not.
> >
> >It matters because the class specification for a USB device is never
> >going to mention information sources that are outside the USB protocol,
> >such as board definitions.  Consequently a class driver will never need
> >to use such a thing.
> 
> Is a gadget driver a class driver?

Some are, but you are now on the "other side" of the USB bus.

> Because I can set the MAC address for my g_ether from the kernel
> commandline which is most definitely an "information source outside
> the USB protocol".  That is exactly the kind of thing I am talking
> about enabling also to be taken from usb_device->dev.platform_data.

You don't have a usb_device for a gadget device.  USB Gadgets are a
totally different world here, don't confuse them please.

> >>>Also, do you have a real example of a USB driver today that needs this?
> >>
> >>I think you find without devpath ->  platform_data mapping, the kind of
> >>layout given above is made quite difficult to support in Linux.
> >
> >What would be needed to support such a mapping?  It seems to me that we
> >probably have all the necessary ingredients in place already.
> 
> What I was imagining is getting the platform data structs from a
> header in include/linux/
> 
> #include <linux/onboard_device_1.h>
> #include <linux/onboard_device_2.h>
> 
> Using a .name defined to be the first member to match to specific
> bus member devpath prepended with bus class:

You can't rely on USB bus numbers to be the same EVER.  These are
assigned by the host computer.

> struct onboard_device_1_platform_data device_1_platform_data {
> 	.name = "usb\1-0",
> 	.some_feature = 1,
> };
> 
> struct onboard_device_2_platform_data device_2_platform_data {
> 	.name = "usb\1-1",
> 	.some_feature = 2,
> };
> 
> Aggregating them into an array
> 
> void *devpath_to_platform_data_mapping[] = {
> 	device_1_platform_data,
> 	device_2_platform_data,
> };
> 
> Registering the array in the machine file
> 
> register_platform_data_by_devpath(devpath_to_platform_data_mapping,
> 	ARRAY_SIZE(devpath_to_platform_data_mapping));
> 
> It needs to set two globals for pointer and member count
> 
> void
> register_platform_data_by_devpath(void *map, int count)
> {
> 	platform_data_mapping = map;
> 	platform_data_mapping_count = count;
> }
> 
> Later, when a USB device is instantiated, if platform_data_mapping
> is not NULL, it checks to see if the devname it just synthesized
> matches any in the table that have static usb/ prefix, and if so,
> sets usb_device->dev.platform_data to the table entry.
> 
> Well, it's an RFC so if you have a better plan I am all ears.

I am totally confused, and as you are messing with bus id numbers, and
confusing usb gadgets and drivers, I think you are as well.

So, are you talking about USB gadgets, or USB drivers here?  They are
different and have different requirements and responsibilities.

confused,

greg k-h
