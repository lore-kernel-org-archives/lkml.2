Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753539Ab2B0ODw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 09:03:52 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:64609 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752883Ab2B0ODu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 09:03:50 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH v2] USB: Support for LPC32xx SoC
Date: Mon, 27 Feb 2012 14:03:16 +0000
User-Agent: KMail/1.12.2 (Linux/3.3.0-rc1; KDE/4.3.2; x86_64; ; )
Cc: Wolfram Sang <w.sang@pengutronix.de>, linux-arm-kernel@lists.infradead.org,
        Roland Stigge <stigge@antcom.de>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        kevin.wells@nxp.com
References: <Pine.LNX.4.44L0.1202261040020.22970-100000@netrider.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1202261040020.22970-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201202271403.16893.arnd@arndb.de>
X-Provags-ID: V02:K0:oUHsOCR8v8HnogbR2J/5QBPPGMrpTxCaShTypJPKEZ5
 BhNE5XLASsDWnMOMVM5zgxL1IQR2Ut6Qg/0FjucavqChdJmekF
 n1pY3RGfAlflHsAN+cwO6DJi7NX1l63roIy8L529GOT+UpVeOb
 75HPZSSYM3mgtKvPzOGeuEfoqHP76Chx3LUg9hQdZML7cTzEeM
 dDK+g0p+cPo6gMaGBocjlBSkWd2A4S+savIqkcI/lMzNtvKA9X
 uwgF06la65Aw6YlUr9dUiL81KIfaSglHLBAwsUx6ESmCKHqnFF
 lNuQpmTpVEFcX0SWjp1YXaFCztniRJi6BmJfJZHnFEofy52d65
 hcNTKx+YE65CPb9s7v+c=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 26 February 2012, Alan Stern wrote:
> On Sun, 26 Feb 2012, Arnd Bergmann wrote:
> 
> > We are doing a major rework of the ARM architecture tree right now
> > to allow building multiple SoC platforms together, which has not
> > been possible traditionally. The "PLATFORM_DRIVER" macro in ohci
> > and ehci is one of many things standing in the way still and will have
> > to be dealt with at some point.
> 
> Is there anybody in particular who is going to attack this issue?

Not the USB portion, we're still busy with more fundamental issues like
conflicting header files between the various subarchitectures.

> > > A little progress has been made already.  We just received a submission
> > > for a "generic" platform bus glue file that will be able to take over
> > > the jobs of several of the existiing files.  If anyone wants to take
> > > this further I won't object, but I don't plan to work on it myself
> > > soon.
> > 
> > Ok, good to know. The approach of a generic glue is exactly what I
> > was going to suggest. As we get to ARM platforms that are currently
> > using PLATFORM_DRIVER, I will then ask people to convert the ohci
> > glue to use that generic glue instead of adding another *_DRIVER
> > macro to ohci/ehci.
> 
> The problem is that several platforms have highly specialized needs
> that can't sanely be handled in a single generic driver.  Although a
> lot of drivers can be converted over, not all of them will.

Can you give an example? We have recently converted the sdhci mmc drivers
in a similar way, and we have the libata drivers that have always worked
in this manner.

> > I'm not sure about what we should do for lpc32xx. Is that
> > generic glue going into v3.4?
> 
> That's up to Greg.  At the moment it isn't used by anything, and unless
> an existing driver can be converted over I'd guess it's not likely to
> get merged right away.

Where is that patch? Maybe I can help out by converting the PCI
variants of ohci and ehci to the generic glue, because they are
easy to test.

> >  If so, we could convert the
> > pnx4008 driver to use that and abstract it in a way that works
> > nicely for pnx4008 and lpc32xx. OTOH, we might just let this
> > one go in as before and ask people to do it right for the next
> > one.
> 
> I don't know anything about these two platforms.  If they are
> sufficiently similar then it does make sense to combine the drivers
> into a single file, with various platform-specific decisions made at
> runtime.  These decisions don't necessarily have to use a machine_is_*
> kind of test (although they can); it might be simpler to do such a
> test once during probe and store the result in a flag for later reuse.
> Or then again, it might not since there's no obvious place to keep 
> such a flag...
> 
> At the moment, switching the pnx4008 driver to use the generic bus glue
> doesn't look easy.  The generic code doesn't know anything about i2c.

Maybe I misunderstood what the generic bus glue does then, because I
would not expect that it should know about i2c ;-)

I would think the generic bus glue would be a very simple library that
just exports the various symbols that are defined in ohci-hcd.c and
used in the bus specific driver so that the driver can be a separate
module. Is it something different from that?

	Arnd
