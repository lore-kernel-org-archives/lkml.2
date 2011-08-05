Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756580Ab1HEVlH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Aug 2011 17:41:07 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:53369 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754501Ab1HEVlE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Aug 2011 17:41:04 -0400
Date: Fri, 5 Aug 2011 22:40:27 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Stephen Warren <swarren@nvidia.com>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, Chris Ball <cjb@laptop.org>,
        "ccross@android.com" <ccross@android.com>,
        "olof@lixom.net" <olof@lixom.net>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [RFC PATCH 0/3] If an IRQ is a GPIO, request and configure it
Message-ID: <20110805214027.GA4699@n2100.arm.linux.org.uk>
References: <1312498820-2275-1-git-send-email-swarren@nvidia.com> <20110805094017.GC20575@n2100.arm.linux.org.uk> <74CDBE0F657A3D45AFBB94109FB122FF049F171EFC@HQMAIL01.nvidia.com> <20110805191504.GB28958@n2100.arm.linux.org.uk> <74CDBE0F657A3D45AFBB94109FB122FF049F171FD3@HQMAIL01.nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <74CDBE0F657A3D45AFBB94109FB122FF049F171FD3@HQMAIL01.nvidia.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 05, 2011 at 12:33:31PM -0700, Stephen Warren wrote:
> Russell King - ARM Linux wrote at Friday, August 05, 2011 1:15 PM:
> > On Fri, Aug 05, 2011 at 08:43:20AM -0700, Stephen Warren wrote:
> > > Russell King - ARM Linux wrote at Friday, August 05, 2011 3:40 AM:
> > > > On Thu, Aug 04, 2011 at 05:00:17PM -0600, Stephen Warren wrote:
> > > > > In http://www.spinics.net/lists/linux-tegra/msg01731.html, Mark Brown
> > > > > pointed out that it was a little silly forcing every board or driver
> > > > > to gpio_request() a GPIO that is later converted to an IRQ, and passed
> > > > > to request_irq. The first patch in this series instead makes the core
> > > > > IRQ code perform these calls when appropriate, to avoid duplicating it
> > > > > everywhere.
> > > >
> > > > Trying to go from IRQ to GPIO is not a good idea - most of the
> > > > IRQ <-> GPIO macros we have today are just plain broken.  Many of them
> > > > just add or subtract a constant, which means non-GPIO IRQs have an
> > > > apparant GPIO number too.  Couple this with the fact that all positive
> > > > GPIO numbers are valid, and this is a recipe for wrong GPIOs getting
> > > > used and GPIOs being requested for non-GPIO IRQs.
> > > >
> > > > I think this was also discussed in the past, and the conclusion was that
> > > > IRQs should be kept separate from GPIOs.  Maybe views have changed since
> > > > then...
> > > >
> > > > However, if we do want to do this, then it would be much better to provide
> > > > a new API for requesting GPIO IRQs, eg:
> > > >
> > > > gpio_request_irq()
> > > >
> > > > which would wrap around request_threaded_irq(), takes a GPIO number,
> > > > does the GPIO->IRQ conversion internally, and whatever GPIO setup is
> > > > required.  Something like this:
> > >
> > > With that approach, drivers need to explicitly know whether they're
> > > passed a GPIO or an IRQ, and do something different, or they need to
> > > choose to only accept a GPIO or IRQ.
> > 
> > You completely missed the biggest reason why your approach is broken.
> 
> No, I didn't.

Yes you did.

> I was discussing whether an alternative API for IRQ registration
> would work, and I was pointing out some problems with it.
> 
> That has nothing to do with whether my original proposal is workable.

And that proves that you missed the point.  I am suggesting an alternative
solution precisely because your original proposal is unworkable.
