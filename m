Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754015Ab2B0Qmz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 11:42:55 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:53778 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753654Ab2B0Qmx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 11:42:53 -0500
Date: Mon, 27 Feb 2012 11:42:52 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Arnd Bergmann <arnd@arndb.de>
cc: Wolfram Sang <w.sang@pengutronix.de>,
        <linux-arm-kernel@lists.infradead.org>,
        Roland Stigge <stigge@antcom.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <kevin.wells@nxp.com>
Subject: Re: [PATCH v2] USB: Support for LPC32xx SoC
In-Reply-To: <201202271403.16893.arnd@arndb.de>
Message-ID: <Pine.LNX.4.44L0.1202271131070.1539-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 27 Feb 2012, Arnd Bergmann wrote:

> > > > A little progress has been made already.  We just received a submission
> > > > for a "generic" platform bus glue file that will be able to take over
> > > > the jobs of several of the existiing files.  If anyone wants to take
> > > > this further I won't object, but I don't plan to work on it myself
> > > > soon.
> > > 
> > > Ok, good to know. The approach of a generic glue is exactly what I
> > > was going to suggest. As we get to ARM platforms that are currently
> > > using PLATFORM_DRIVER, I will then ask people to convert the ohci
> > > glue to use that generic glue instead of adding another *_DRIVER
> > > macro to ohci/ehci.
> > 
> > The problem is that several platforms have highly specialized needs
> > that can't sanely be handled in a single generic driver.  Although a
> > lot of drivers can be converted over, not all of them will.
> 
> Can you give an example? We have recently converted the sdhci mmc drivers
> in a similar way, and we have the libata drivers that have always worked
> in this manner.

Look at ehci-tegra.c.  It has numerous non-generic overrides, such as
tegra_ehci_hub_control().  It also has support for two clocks and a 
transceiver.

> > > I'm not sure about what we should do for lpc32xx. Is that
> > > generic glue going into v3.4?
> > 
> > That's up to Greg.  At the moment it isn't used by anything, and unless
> > an existing driver can be converted over I'd guess it's not likely to
> > get merged right away.
> 
> Where is that patch? Maybe I can help out by converting the PCI
> variants of ohci and ehci to the generic glue, because they are
> easy to test.

	http://marc.info/?l=linux-usb&m=132986573930143&w=2

and the following two messages in the linux-usb mailing list.

> > At the moment, switching the pnx4008 driver to use the generic bus glue
> > doesn't look easy.  The generic code doesn't know anything about i2c.
> 
> Maybe I misunderstood what the generic bus glue does then, because I
> would not expect that it should know about i2c ;-)
> 
> I would think the generic bus glue would be a very simple library that
> just exports the various symbols that are defined in ohci-hcd.c and
> used in the bus specific driver so that the driver can be a separate
> module. Is it something different from that?

Quite different.  What you just described is ohci-hcd.c itself -- 
except that it doesn't export the necessary symbols.

The generic driver, as you'll see when you read the patch, includes 
generic versions of the various routines that a bus glue file has to 
provide (probe, remove, initialize, and so on).

Alan Stern

