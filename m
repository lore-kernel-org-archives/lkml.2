Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754387Ab2DWVVs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 17:21:48 -0400
Received: from mail-pz0-f51.google.com ([209.85.210.51]:46405 "EHLO
	mail-pz0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753421Ab2DWVVr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 17:21:47 -0400
Date: Mon, 23 Apr 2012 14:21:44 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: George Nychis <gnychis@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: what determines how firmware is loaded? (Q. on request_firmware
 details)
Message-ID: <20120423212144.GA3378@kroah.com>
References: <CA+7oygfcQbOFdCFibTW0pqYQpcLwrqCM_jvKpr=GYFBMn9t3GQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+7oygfcQbOFdCFibTW0pqYQpcLwrqCM_jvKpr=GYFBMn9t3GQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 23, 2012 at 04:18:56PM -0400, George Nychis wrote:
> Hi all,
> 
> I notice in an older version of Ubuntu that when I plugin a USB
> wireless device its firmware is loaded via sysfs.  For example, this
> would pop up in sysfs:
> /sys/devices/pci0000:00/0000:00:1d.7/usb2/2-1/compat_firmware/2-1/loading

How old are we talking about here?  What version of the kernel?

> In newer versions, I'm now seeing that the firmware seems to be loaded
> directly via a Kernel thread that is spawned.  It checks for the
> firmware in some firmware directory (e.g., /lib/firmware) and loads it
> to the device.

Yes.

> I see in documentation that one method is referred to as asynchronous.
>  Is this the  former or latter?

Depends on the device.

> Has the former method of loading firmware been removed as the default?
>  Is there any way to request that the firmware load be done manually
> (the former method)?

Why?  In the end, they do the same thing, right?

> It seems as though instead of calling request_firmware(), I could call
> _request_firmware() with "uevent" set to 0?  This would force for
> former behavior?
> 
> Does "nowait" also have to be 0?  I don't quite understand the
> separation between uevent and nowait.

I don't understand the problem here, isn't the end-result the same?
What is wrong with newer kernels?

thanks,

greg k-h
