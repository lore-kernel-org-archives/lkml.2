Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755516Ab0IBOW1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Sep 2010 10:22:27 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:39846 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755482Ab0IBOWZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Sep 2010 10:22:25 -0400
Date: Thu, 2 Sep 2010 10:22:25 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Simon Arlott <simon@fire.lp0.eu>
cc: Greg KH <greg@kroah.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        USB list <linux-usb@vger.kernel.org>
Subject: Re: [PATCH] USB: output an error message when the pipe type  doesn't
 match the endpoint type
In-Reply-To: <e875e8d2d6b6000fcb31da07f393618f3466233c@8b5064a13e22126c1b9329f0dc35b8915774b7c3.invalid>
Message-ID: <Pine.LNX.4.44L0.1009021019090.1513-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2 Sep 2010, Simon Arlott wrote:

> On Wed, September 1, 2010 18:49, Alan Stern wrote:
> > On Wed, 1 Sep 2010, Simon Arlott wrote:
> >> > This is okay with me.  If you're serious about not changing the
> >> > behavior merely because debugging is enabled, you could move this test
> >> > out of the debug-only region and possibly change the dev_err to
> >> > dev_dbg.  However doing so might break some devices that are currently
> >> > working.
> >>
> >> I'd expect that to break potentially many devices, although only cxacru
> >> stopped working for me. The USB API isn't really suitable for adding
> >> this type of check because it allows the drivers to get away with too
> >> much already.
> >
> > Unlike device hardware, drivers can always be changed.  If adding a
> > check will help spot errors, it's probably worthwhile.
> 
> Yes, however the information about the device endpoint types hasn't been
> required in the past for the driver to work. The only way to check is to
> have the hardware available so the error may only show up after a full
> release of the kernel and break drivers that used to work. It could be
> enabled for all -rc kernels...

Which suggests that the best approach is to print the error message 
always, but allow the submission unless CONFIG_USB_DEBUG is set.

> >> usb_clear_halt() takes a pipe when it really wants the endpoint, the
> >> pipe type is ignored.
> >
> > What's wrong with that?  Besides, in the end we shouldn't be using
> > pipes at all; we should always use pointers to struct
> > usb_host_endpoint.
> 
> If a driver was trying to conform to the "don't use the wrong pipe type
> with an endpoint" rule then it may have to check it was using the
> correct pipe when calling usb_clear_halt(), although this is only a
> problem with drivers where the devices sometimes have interrupt instead
> of bulk endpoints.
> 
> Looking at usb_clear_halt(), it doesn't use the direction either... but
> drivers can call it in both directions. Several drivers already do this.

What do you mean?  Look at the first lines of code in usb_clear_halt():

	if (usb_pipein(pipe))
		endp |= USB_DIR_IN;

Alan Stern

