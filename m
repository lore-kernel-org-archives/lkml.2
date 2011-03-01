Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756143Ab1CALM3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Mar 2011 06:12:29 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:56254 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755560Ab1CALM2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Mar 2011 06:12:28 -0500
Date: Tue, 1 Mar 2011 12:12:20 +0100
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org, Paul Mundt <lethal@linux-sh.org>,
        linux-kernel@vger.kernel.org, linux-fbdev@vger.kernel.org,
        Samuel Ortiz <sameo@linux.intel.com>, Alan Cox <alan@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 3/8] Add a mfd IPUv3 driver
Message-ID: <20110301111220.GN29521@pengutronix.de>
References: <1298887229-7987-1-git-send-email-s.hauer@pengutronix.de>
 <201102281811.45277.arnd@arndb.de>
 <20110301091544.GK29521@pengutronix.de>
 <201103011127.51605.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201103011127.51605.arnd@arndb.de>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 12:07:07 up 12 days, 23:04, 39 users,  load average: 2.23, 3.74,
 4.23
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 01, 2011 at 11:27:49AM +0100, Arnd Bergmann wrote:
> On Tuesday 01 March 2011, Sascha Hauer wrote:
> 
> > When turning this into a kms driver moving the source code will be the
> > smallest problem I guess.
> > I have no preference where to put this code. First it was in
> > drivers/mfd/ and it felt wrong because there seems to be too much code
> > in it a mfd maintainer shouldn't be bothered with. drivers/video/ seems
> > to be wrong because this code will probably support cameras which belong
> > to drivers/media/video/. So if there's consensus on drivers/gpu/ I will
> > happily put it there.
> > What directory do you suggest? drivers/gpu/ or some subdirectory
> > (drm/vga)?
> 
> I'd suggest a subdirectory of drivers/gpu/, e.g.
> drivers/gpu/embedded/imx-ipu/. Alan is currently adding a driver
> for the Intel GMA500, and there are others (TI, ST-Ericsson, ...)
> that fit in a similar category of complex graphics subsystems
> without an actual GPU core. I think they should all go to the same
> place.
> 
> > > The interrupt logic needs some comments. What are you trying to achieve here?
> > 
> > The IPU has 463 status bits which can trigger an interrupt. Most
> > of them are associated to channels, some are general interrupts. My
> > problem is that I don't know how the interrupts will be used by drivers
> > later. Most drivers will probably use only one interrupt but others
> > will be interested in a larger group of interrupts. So I decided to
> > use a bitmap allowing each driver to register for groups of event
> > it is interested in.
> 
> Ok, I see. So you essentially have a huge nested interrupt controller
> and try to be clever about the possible use cases, which may be the
> right choice, but apparently you don't know that yet because not
> all the drivers have been written at this point.
> 
> Taking one step back from this, have you considered making this
> a regular interrupt controller? That would make the client drivers
> more standard -- you could define the interrupt numbers as resources
> of a platform device or in the device tree, for instance.
> The cost might be more complex code, e.g. when a device requires
> many interrupts, but I think it will be at least as efficient
> at run-time, and less surprising for readers and authors of
> client drivers.

I thought about this, but hesitated to increase NR_IRQS by 463. Do you
think we should do this instead?

Sascha

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
