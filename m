Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756947Ab1DFW12 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Apr 2011 18:27:28 -0400
Received: from cantor2.suse.de ([195.135.220.15]:51618 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755481Ab1DFW1Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Apr 2011 18:27:25 -0400
Date: Wed, 6 Apr 2011 15:09:00 -0700
From: Greg KH <gregkh@suse.de>
To: Felipe Balbi <balbi@ti.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Andres Salomon <dilinger@queued.net>, linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>, khali@linux-fr.org,
        ben-linux@fluff.org, Peter Korsgaard <jacmet@sunsite.dk>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        David Brownell <dbrownell@users.sourceforge.net>,
        linux-i2c@vger.kernel.org, linux-media@vger.kernel.org,
        netdev@vger.kernel.org, spi-devel-general@lists.sourceforge.net,
        Mocean Laboratories <info@mocean-labs.com>
Subject: Re: [PATCH 07/19] timberdale: mfd_cell is now implicitly available
 to drivers
Message-ID: <20110406220900.GA16117@suse.de>
References: <20110401235239.GE29397@sortiz-mobl>
 <BANLkTi=bq=OGzXFp7qiBr7x_BnGOWf=DRQ@mail.gmail.com>
 <20110404100314.GC2751@sortiz-mobl>
 <20110405030428.GB29522@ponder.secretlab.ca>
 <20110406152322.GA2757@sortiz-mobl>
 <20110406155805.GA20095@suse.de>
 <20110406170537.GB2757@sortiz-mobl>
 <20110406175647.GA8048@suse.de>
 <20110406184733.GD2757@sortiz-mobl>
 <20110406185902.GN25654@legolas.emea.dhcp.ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110406185902.GN25654@legolas.emea.dhcp.ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 06, 2011 at 09:59:02PM +0300, Felipe Balbi wrote:
> Hi,
> 
> On Wed, Apr 06, 2011 at 08:47:34PM +0200, Samuel Ortiz wrote:
> > > > > What is a "MFD cell pointer" and why is it needed in struct device?
> > > > An MFD cell is an MFD instantiated device.
> > > > MFD (Multi Function Device) drivers instantiate platform devices. Those
> > > > devices drivers sometimes need a platform data pointer, sometimes an MFD
> > > > specific pointer, and sometimes both. Also, some of those drivers have been
> > > > implemented as MFD sub drivers, while others know nothing about MFD and just
> > > > expect a plain platform_data pointer.
> > > 
> > > That sounds like a bug in those drivers, why not fix them to properly
> > > pass in the correct pointer?
> > Because they're drivers for generic IPs, not MFD ones. By forcing them to use
> > MFD specific structure and APIs, we make it more difficult for platform code
> > to instantiate them.
> 
> I agree. What I do on those cases is to have a simple platform_device
> for the core IP driver and use platform_device_id tables to do runtime
> checks of the small differences. If one platform X doesn't use a
> platform_bus, it uses e.g. PCI, then you make a PCI "bridge" which
> allocates a platform_device with the correct name and adds that to the
> driver model.
> 
> See [1] (for the core driver) and [2] (for a PCI bridge driver) for an
> example of what I'm talking about.

Yes, thanks for providing a real example, this is the best way to handle
this.

thanks,

greg k-h
