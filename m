Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754359Ab0IARtW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Sep 2010 13:49:22 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:59662 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753217Ab0IARtV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Sep 2010 13:49:21 -0400
Date: Wed, 1 Sep 2010 13:49:17 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Simon Arlott <simon@fire.lp0.eu>
cc: Greg KH <greg@kroah.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        USB list <linux-usb@vger.kernel.org>
Subject: Re: [PATCH] USB: output an error message when the pipe type doesn't
 match the endpoint type
In-Reply-To: <4C7E87DD.3080508@simon.arlott.org.uk>
Message-ID: <Pine.LNX.4.44L0.1009011334160.1617-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 1 Sep 2010, Simon Arlott wrote:

> > This is okay with me.  If you're serious about not changing the
> > behavior merely because debugging is enabled, you could move this test
> > out of the debug-only region and possibly change the dev_err to
> > dev_dbg.  However doing so might break some devices that are currently
> > working.
> 
> I'd expect that to break potentially many devices, although only cxacru
> stopped working for me. The USB API isn't really suitable for adding
> this type of check because it allows the drivers to get away with too
> much already.

Unlike device hardware, drivers can always be changed.  If adding a 
check will help spot errors, it's probably worthwhile.

> usb_clear_halt() takes a pipe when it really wants the endpoint, the
> pipe type is ignored.

What's wrong with that?  Besides, in the end we shouldn't be using
pipes at all; we should always use pointers to struct
usb_host_endpoint.

> usb_bulk_msg() auto-detects the type between interrupt and bulk, as
> does usb_interrupt_msg() because the latter just calls the former.
> 
> (I think -EINVAL might be a better return code. The pipe isn't broken,
> it doesn't exist.)

Within the kernel, the meanings of the -Exxx error codes are fairly
arbitrary.  But since this code can be passed to userspace you are
right.

Alan Stern

