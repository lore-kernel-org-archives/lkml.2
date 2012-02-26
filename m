Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751838Ab2BZP7v (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Feb 2012 10:59:51 -0500
Received: from netrider.rowland.org ([192.131.102.5]:45383 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751197Ab2BZP7t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Feb 2012 10:59:49 -0500
Date: Sun, 26 Feb 2012 10:59:47 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Arnd Bergmann <arnd@arndb.de>
cc: Wolfram Sang <w.sang@pengutronix.de>,
        <linux-arm-kernel@lists.infradead.org>,
        Roland Stigge <stigge@antcom.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <kevin.wells@nxp.com>
Subject: Re: [PATCH v2] USB: Support for LPC32xx SoC
In-Reply-To: <201202261001.49937.arnd@arndb.de>
Message-ID: <Pine.LNX.4.44L0.1202261040020.22970-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 26 Feb 2012, Arnd Bergmann wrote:

> We are doing a major rework of the ARM architecture tree right now
> to allow building multiple SoC platforms together, which has not
> been possible traditionally. The "PLATFORM_DRIVER" macro in ohci
> and ehci is one of many things standing in the way still and will have
> to be dealt with at some point.

Is there anybody in particular who is going to attack this issue?

> > A little progress has been made already.  We just received a submission
> > for a "generic" platform bus glue file that will be able to take over
> > the jobs of several of the existiing files.  If anyone wants to take
> > this further I won't object, but I don't plan to work on it myself
> > soon.
> 
> Ok, good to know. The approach of a generic glue is exactly what I
> was going to suggest. As we get to ARM platforms that are currently
> using PLATFORM_DRIVER, I will then ask people to convert the ohci
> glue to use that generic glue instead of adding another *_DRIVER
> macro to ohci/ehci.

The problem is that several platforms have highly specialized needs
that can't sanely be handled in a single generic driver.  Although a
lot of drivers can be converted over, not all of them will.

> I'm not sure about what we should do for lpc32xx. Is that
> generic glue going into v3.4?

That's up to Greg.  At the moment it isn't used by anything, and unless
an existing driver can be converted over I'd guess it's not likely to
get merged right away.

>  If so, we could convert the
> pnx4008 driver to use that and abstract it in a way that works
> nicely for pnx4008 and lpc32xx. OTOH, we might just let this
> one go in as before and ask people to do it right for the next
> one.

I don't know anything about these two platforms.  If they are
sufficiently similar then it does make sense to combine the drivers
into a single file, with various platform-specific decisions made at
runtime.  These decisions don't necessarily have to use a machine_is_*
kind of test (although they can); it might be simpler to do such a
test once during probe and store the result in a flag for later reuse.
Or then again, it might not since there's no obvious place to keep 
such a flag...

At the moment, switching the pnx4008 driver to use the generic bus glue
doesn't look easy.  The generic code doesn't know anything about i2c.

Alan Stern

