Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752159Ab1GIFnb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jul 2011 01:43:31 -0400
Received: from out5.smtp.messagingengine.com ([66.111.4.29]:47370 "EHLO
	out5.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751916Ab1GIFn2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jul 2011 01:43:28 -0400
X-Sasl-enc: mCjK3+rdEeRocshGMf5y6jR2GklwmP53+9xZ5M2cn4qV 1310190207
Date: Fri, 8 Jul 2011 22:43:10 -0700
From: Greg KH <greg@kroah.com>
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [RFC PATCH v2 0/4] Core device subsystem
Message-ID: <20110709054310.GB14519@kroah.com>
References: <1310115250-3859-1-git-send-email-marc.zyngier@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1310115250-3859-1-git-send-email-marc.zyngier@arm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 08, 2011 at 09:54:06AM +0100, Marc Zyngier wrote:
> There is a small number of devices that the core kernel needs very
> early in the boot process, namely an interrupt controller and a timer,
> long before the driver model is up and running.

What in the "driver model" needs to be up and running early for you to
use it?

Why not just start it up sooner if it's so needed?

Are you really just needing your bus to start up sooner?  Or your
"platform" bus?

> Most architectures implement this requirement by hardcoding the
> initialisation of a "well known" piece of hardware which is standard
> enough to work on any platform.
> 
> This is very different on the ARM architecture, where platforms have a
> variety of interrupt controllers and timers. While the same hardcoding
> is possible (and is actually used), it makes it almost impossible to
> support several platforms in the same kernel.
> 
> Though the device tree is helping greatly to solve this problem, some
> platform won't ever be converted to DT, hence the need to have a
> mechanism supporting a variety of information source.

So because you are not willing to convert to DT, we must support
yet-another-one-off type of thing instead?  That's a pretty poor reason.

Why can't you just move the platform to DT instead, which would solve
this for you?  That seems much easier than adding this core code.

> Early platform
> devices having been deemed unsuitable (complexity, abuse of various
> subsystems), this subsystem has been designed to provide the very
> minimal level of functionality.
> 
> The "core device subsystem" offers a class based device/driver
> matching model, doesn't rely on any other subsystem, is very (too?)
> simple, and support getting information both from DT as well as from
> static data provided by the platform. It also gives the opportunity to
> define the probing order by offering a sorting hook at run-time.

Again, just use DT and all would be fine, right?

> As for the Linux driver model, the core device subsystem deals mainly
> with device and driver objects. It also has the notion of "class" to
> designate a group of devices implementing the same functionality, and
> a group of drivers to be matched against the above devices
> (CORE_DEV_CLASS_TIMER for example).

Classes are going away, never create a new one, so please don't create
new code that emulates it.

I'm still not sold as to why this is needed.

greg k-h
