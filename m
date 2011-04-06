Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756489Ab1DFSnF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Apr 2011 14:43:05 -0400
Received: from cantor2.suse.de ([195.135.220.15]:45456 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756424Ab1DFSnD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Apr 2011 14:43:03 -0400
Date: Wed, 6 Apr 2011 11:38:54 -0700
From: Greg KH <gregkh@suse.de>
To: Andres Salomon <dilinger@queued.net>
Cc: Samuel Ortiz <sameo@linux.intel.com>,
        Grant Likely <grant.likely@secretlab.ca>, linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>, khali@linux-fr.org,
        ben-linux@fluff.org, Peter Korsgaard <jacmet@sunsite.dk>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        David Brownell <dbrownell@users.sourceforge.net>,
        linux-i2c@vger.kernel.org, linux-media@vger.kernel.org,
        netdev@vger.kernel.org, spi-devel-general@lists.sourceforge.net,
        Mocean Laboratories <info@mocean-labs.com>
Subject: Re: [PATCH 07/19] timberdale: mfd_cell is now implicitly available
 to drivers
Message-ID: <20110406183854.GA10058@suse.de>
References: <BANLkTi=bCd_+f=EG-O=U5VH_ZNjFhxkziQ@mail.gmail.com>
 <20110401235239.GE29397@sortiz-mobl>
 <BANLkTi=bq=OGzXFp7qiBr7x_BnGOWf=DRQ@mail.gmail.com>
 <20110404100314.GC2751@sortiz-mobl>
 <20110405030428.GB29522@ponder.secretlab.ca>
 <20110406152322.GA2757@sortiz-mobl>
 <20110406155805.GA20095@suse.de>
 <20110406170537.GB2757@sortiz-mobl>
 <20110406175647.GA8048@suse.de>
 <20110406112557.5c4c9bfe@debxo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110406112557.5c4c9bfe@debxo>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 06, 2011 at 11:25:57AM -0700, Andres Salomon wrote:
> > > We've been faced with the problem of being able to pass both MFD
> > > related data and a platform_data pointer to some of those drivers.
> > > Squeezing the MFD bits in the sub driver platform_data pointer
> > > doesn't work for drivers that know nothing about MFDs. It also adds
> > > an additional dependency on the MFD API to all MFD sub drivers.
> > > That prevents any of those drivers to eventually be used as plain
> > > platform device drivers.
> > 
> > Then they shouldn't be "plain" platform drivers, that should only be
> > reserved for drivers that are the "lowest" type.  Just make them MFD
> > devices and go from there.
> 
> 
> The problem is of mixing "plain" platform devices and MFD devices.

Then don't do that.

> It's reasonable to assume that different hardware may be using
> one method or the other to create devices; in order to maintain
> compatibility with the driver, one either needs to use a plain platform
> device.  Alternatively, if an MFD-specific device class is created,
> then MFD devices would start showing up in weird places.

Then fix it.  Lots of other drivers handle different "bus types" just
fine (look at the EHCI USB driver for an example.)  Don't polute the
driver core just because you don't want to fix up the individual driver
issues that are quite obvious.

thanks,

greg k-h
