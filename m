Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755720Ab1DUXed (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Apr 2011 19:34:33 -0400
Received: from www.hansjkoch.de ([178.63.77.200]:58611 "EHLO www.hansjkoch.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755419Ab1DUXed (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Apr 2011 19:34:33 -0400
Date: Fri, 22 Apr 2011 01:34:15 +0200
From: "Hans J. Koch" <hjk@hansjkoch.de>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Guenter Roeck <guenter.roeck@ericsson.com>,
        "Hans J. Koch" <hjk@hansjkoch.de>, Greg Kroah-Hartman <gregkh@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jonathan Cameron <kernel@jic23.retrosnub.co.uk>,
        Randy Dunlap <rdunlap@xenotime.net>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] misc: Driver for Silicon Labs Si570 and compatibles
Message-ID: <20110421233415.GC2786@local>
References: <1303248968-5069-1-git-send-email-guenter.roeck@ericsson.com>
 <201104201844.30919.arnd@arndb.de>
 <20110420181652.GA23298@ericsson.com>
 <201104211311.25988.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201104211311.25988.arnd@arndb.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 21, 2011 at 01:11:25PM +0200, Arnd Bergmann wrote:
> On Wednesday 20 April 2011, Guenter Roeck wrote:
> > On Wed, Apr 20, 2011 at 12:44:30PM -0400, Arnd Bergmann wrote:
> > > On Tuesday 19 April 2011, Guenter Roeck wrote:
> > > > This driver adds support for Si570, Si571, Si598, and Si599
> > > > programmable XO/VCXO.
> > > > 
> > > > Signed-off-by: Guenter Roeck <guenter.roeck@ericsson.com>
> > > 
> > > This needs some more explanation of what the hardware is there for,
> > > and why it's unlike everything else that we support in Linux.
> > > 
> > This is a generic configurable clock device. I'll be happy to add
> > some text such as "The device can be used for any application requiring
> > a static or a dynamically configurable clock, such as serdes clocks".
> > Not sure if that would add much value, though.
> > 
> > Regarding "unlike everything else", not sure if that is really correct.
> > The DDS chips Jonathan mentioned do get pretty close, and there are
> > other drivers providing support for clock chips, though typically more
> > dedicated.  ics932s401 in misc is one example, and then there are all
> > the tuner chips in media/common/tuners/.
> 
> Isn't that what you'd normally call a 'struct clk' then?
> 
> > > If that is true, it should probably not have a user-visible
> > > interface, but only an interface that can be used by other
> > > kernel drivers.
> > > 
> > Depends. In our case, turns out the devices consuming the clock
> > have user mode drivers. Lots of history there, but the chip vendors 
> > provide those user mode drivers, and the teams responsible for
> > integrating the drivers decided to not rewrite it to kernel mode drivers.
> > Also, for special purposes such as margining, it is necessary to control
> > the clock from userspace. So, for our use case, I need the user-visible
> > interface. I _don't_ need the kernel interface, at least not right now,
> > which is why I did not add it.
> > 
> > Browsing through the web, it seems the chip is somewhat popular with
> > Amateur Radio. No idea if it would ever be controlled for such a purpose
> > from Linux, but if so, it would also require a user configurable frequency.
> > 
> > If there is a better place for such a driver than misc, please let me know.
> 
> When you say user mode driver, do you mean as in drivers/uio? (taking Hans
> on Cc for these)

No UIO driver like that ever reached me.

> 
> Those already have generic support for memory and interrupt resources,
> maybe we can just add a common way to associate a uio device with a struct clk
> and provide a sysfs or ioctl interface to set a clock for a given device.

I don't think the UIO framework is the right place for such a thing. If it's
just this one driver that needs modification of a clock from userspace, then
a sysfs attribute could be added to that driver. If there are several drivers
that need this, then the clock framework should be extended.

Thanks,
Hans


> 
> 	Arnd
> 
