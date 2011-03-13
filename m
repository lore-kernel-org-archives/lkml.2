Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754689Ab1CMQRX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Mar 2011 12:17:23 -0400
Received: from kroah.org ([198.145.64.141]:41491 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754067Ab1CMQRW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Mar 2011 12:17:22 -0400
Date: Sun, 13 Mar 2011 09:14:35 -0700
From: Greg KH <greg@kroah.com>
To: andy.green@linaro.org
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org, patches@linaro.org
Subject: Re: [RFC PATCH 1/4] PLATFORM: introduce structure to bind async
 platform data to a dev path name
Message-ID: <20110313161435.GA10718@kroah.com>
References: <20110312222633.27020.19543.stgit@otae.warmcat.com>
 <20110312223212.27020.9839.stgit@otae.warmcat.com>
 <201103130029.38458.rjw@sisk.pl>
 <4D7C0423.9020204@linaro.org>
 <20110313010329.GB20396@kroah.com>
 <4D7CA900.2070302@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D7CA900.2070302@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 13, 2011 at 11:22:40AM +0000, Andy Green wrote:
> On 03/13/2011 01:03 AM, Somebody in the thread at some point said:
> 
> >>>Using device paths for this purpose seems to be very fragile to me.  Isn't
> >>>there any better solution?
> >>
> >>Given that this targets board definition files which commonly do the
> >>platform_add_device for the USB bus controller synchronously, and
> >>the bus-connected devices it is aimed at are soldered on to the
> >>board connected to specific bus controllers, the bus paths are
> >>completely deterministic.
> >
> >No they are not.
> >
> >The physical layout is deterministic, but the bus number, and device
> >number, is not.  You are using the bus number here in this path, so that
> >is not going to work, sorry.
> 
> Okay.  This is not a PC we are talking about.

I know that, and again, it doesn't matter.

You CAN NOT GUARANTEE the USB device ordering of bus numbers or device
numbers.  It's that simple.

> If the platform / board definition file is registering the USB hosts
> synchronously at boot time, the driver is composed into the
> monolithic kernel, there are no PCI busses or whatever on the SoC,
> the bus indexing is totally deterministic.

Not true, it could change for a number of reasons, not the least being
your kernel version changed.

So again NEVER rely on this, bad things could happen in the field when
you least expect it.

thanks,

greg k-h
