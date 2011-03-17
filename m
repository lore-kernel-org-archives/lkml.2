Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755761Ab1CQVdH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Mar 2011 17:33:07 -0400
Received: from kroah.org ([198.145.64.141]:51904 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755662Ab1CQVdC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Mar 2011 17:33:02 -0400
Date: Thu, 17 Mar 2011 14:31:08 -0700
From: Greg KH <greg@kroah.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Nicolas Pitre <nicolas.pitre@linaro.org>, Arnd Bergmann <arnd@arndb.de>,
        andy.green@linaro.org, Linux USB list <linux-usb@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: RFC: Platform data for onboard USB assets
Message-ID: <20110317213108.GA16065@kroah.com>
References: <20110311163522.GA9291@kroah.com>
 <20110311164850.GT1760@opensource.wolfsonmicro.com>
 <20110311165642.GA9996@kroah.com>
 <20110311170807.GV1760@opensource.wolfsonmicro.com>
 <20110311172345.GA10876@kroah.com>
 <alpine.LFD.2.00.1103162207130.26889@xanadu.home>
 <20110317201320.GB4035@kroah.com>
 <20110317201835.GM31411@opensource.wolfsonmicro.com>
 <20110317202614.GA3155@kroah.com>
 <20110317212449.GO31411@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110317212449.GO31411@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 17, 2011 at 09:24:49PM +0000, Mark Brown wrote:
> On Thu, Mar 17, 2011 at 01:26:14PM -0700, Greg KH wrote:
> > On Thu, Mar 17, 2011 at 08:18:35PM +0000, Mark Brown wrote:
> 
> > > It's going to be an off the shelf USB ethernet controller.  I'd be
> > > astonished if the board-configurable device IDs weren't set from the
> > > same SEPROM that the MAC address is so it'd just show up as a generic
> > > chip of whatever kind.
> 
> > Huh?  All USB controllers you buy have the ability to set the vendor and
> > product id, so you should always be able to key off of that.
> 
> > Isn't that the case here?
> 
> They generally the same facility that includes the ability to set the
> MAC address so if one's not been provided it seems optimistic to expect
> the other.

{sigh}  You are probably right :(

> The way this is normally done is that the ethernet controller can be
> attached to a SEPROM which it reads when it powers on.  This will
> contain a number of device configuration parameters, including the
> vendor IDs and the MAC address, which will be configured before the
> device makes itself available on the bus.  If the system integrator has
> omitted the SEPROM then the device will come up with defaults, usually
> something like all zeros.


Ok, then again, let's deal with this on a case-by-case basis please, as
this is going to be a "rare" thing in the real world.  I don't want to
encourage _any_ engineers to think that this is ok to do for USB
devices.

Patches to fix this, for this specific PandaBoard controller are gladly
accepted.  What's odd is this is explicitly a Linux development board,
so you would think that this could have been caught, and fixed, in the
hardware a long time ago, right?

Heck, it could be fixed today on future versions of this board, if
anyone from TI actually cared :(

thanks,

greg k-h
