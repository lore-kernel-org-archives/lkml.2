Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755893Ab1CQVsB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Mar 2011 17:48:01 -0400
Received: from kroah.org ([198.145.64.141]:50088 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755870Ab1CQVr7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Mar 2011 17:47:59 -0400
Date: Thu, 17 Mar 2011 14:47:36 -0700
From: Greg KH <greg@kroah.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Nicolas Pitre <nicolas.pitre@linaro.org>, Arnd Bergmann <arnd@arndb.de>,
        andy.green@linaro.org, Linux USB list <linux-usb@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: RFC: Platform data for onboard USB assets
Message-ID: <20110317214736.GA29014@kroah.com>
References: <20110311165642.GA9996@kroah.com>
 <20110311170807.GV1760@opensource.wolfsonmicro.com>
 <20110311172345.GA10876@kroah.com>
 <alpine.LFD.2.00.1103162207130.26889@xanadu.home>
 <20110317201320.GB4035@kroah.com>
 <20110317201835.GM31411@opensource.wolfsonmicro.com>
 <20110317202614.GA3155@kroah.com>
 <20110317212449.GO31411@opensource.wolfsonmicro.com>
 <20110317213108.GA16065@kroah.com>
 <20110317214042.GQ31411@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110317214042.GQ31411@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 17, 2011 at 09:40:42PM +0000, Mark Brown wrote:
> On Thu, Mar 17, 2011 at 02:31:08PM -0700, Greg KH wrote:
> > On Thu, Mar 17, 2011 at 09:24:49PM +0000, Mark Brown wrote:
> 
> > > The way this is normally done is that the ethernet controller can be
> > > attached to a SEPROM which it reads when it powers on.  This will
> > > contain a number of device configuration parameters, including the
> > > vendor IDs and the MAC address, which will be configured before the
> > > device makes itself available on the bus.  If the system integrator has
> > > omitted the SEPROM then the device will come up with defaults, usually
> > > something like all zeros.
> 
> > Ok, then again, let's deal with this on a case-by-case basis please, as
> > this is going to be a "rare" thing in the real world.  I don't want to
> > encourage _any_ engineers to think that this is ok to do for USB
> > devices.
> 
> It's really not at all rare in the embedded world - the overwhelming
> majority of the systems I've worked on have omitted the SEPROMS for
> components that are soldered down in the system.  It'd be pretty insane
> to do it for things that are distinct USB devices but that's not the
> case.
> 
> There are good solid engineering reasons for doing things this way if
> you've got any prospect of shifting any kind of volume, as well as the
> cost saving achieved by removing a component you also simplify and most
> likely speed up the production process as you can reduce the number of
> components that need to be programmed on each system that gets built.
> 
> > Patches to fix this, for this specific PandaBoard controller are gladly
> > accepted.  What's odd is this is explicitly a Linux development board,
> > so you would think that this could have been caught, and fixed, in the
> > hardware a long time ago, right?
> 
> The way everyone resolves this stuff is by patching their kernel
> locally.

Well, that means that the device tree work is going to be useful here,
right?  :)

Best of luck,

greg k-h
