Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932113Ab1DZPeX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 11:34:23 -0400
Received: from imr4.ericy.com ([198.24.6.8]:46277 "EHLO imr4.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755494Ab1DZPeU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 11:34:20 -0400
Date: Tue, 26 Apr 2011 08:33:23 -0700
From: Guenter Roeck <guenter.roeck@ericsson.com>
To: Arnd Bergmann <arnd@arndb.de>
CC: "Hans J. Koch" <hjk@hansjkoch.de>, Greg Kroah-Hartman <gregkh@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jonathan Cameron <kernel@jic23.retrosnub.co.uk>,
        Randy Dunlap <rdunlap@xenotime.net>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] misc: Driver for Silicon Labs Si570 and compatibles
Message-ID: <20110426153323.GA18176@ericsson.com>
References: <1303248968-5069-1-git-send-email-guenter.roeck@ericsson.com>
 <20110421233415.GC2786@local>
 <1303501213.31666.27.camel@groeck-laptop>
 <201104261600.23675.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <201104261600.23675.arnd@arndb.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 26, 2011 at 10:00:23AM -0400, Arnd Bergmann wrote:
> On Friday 22 April 2011, Guenter Roeck wrote:
> > On Thu, 2011-04-21 at 19:34 -0400, Hans J. Koch wrote:
> > > I don't think the UIO framework is the right place for such a thing. If it's
> > > just this one driver that needs modification of a clock from userspace, then
> > > a sysfs attribute could be added to that driver. If there are several drivers
> > > that need this, then the clock framework should be extended.
> > 
> > Agreed. Also, the desire to control the clock frequency through such a
> > driver (user mode or not) seems odd. Such an approach would be
> > inherently non-scalable (for my part I would have to support two drivers
> > already). Voltage regulators are not controlled through the drivers of
> > the chips they are providing power to either, but have an independent
> > existence.
> 
> I think you are talking about different things here. What I think
> Hans was saying is that it should be in the specific UIO driver, not
> in the framework, which I can agree with. If we get a bunch of these,
> we can still make it generic at a later point, but that is not your
> problem.

Sure it is.

> 
> I think exporting the clock to kernel drivers as a struct clk is
> the most useful approach to allow reuse, and then you just have to
> interface to that from your existing UIO driver.
> 
That would already be two (or more) uio drivers, since we use the si570 for two
different chips on several different boards. Still, you are effectively arguing
that the voltage to those devices should also be controlled through the uio driver,
and that device temperatures should also be reported that way. And so on.

I happen to pelieve that is not the right approach, so I won't implement it.
The argument that clocks should be handled diffferently than everything else 
affecting the chip just doesn't make sense to me and would create unnecessary
dependencies in the kernel code.

For our purpose, the driver does exactly what it needs to do. It has a clean,
simple ABI which lets me re-use it for any device I need it for, without having
to write code for each of the devices it supports.

If and when the clk infrastructure makes it into x86, and if that infrastructure
supports the ability to set clock frequencies from user space, I may port the driver
to that infrastructure (or not, since it looks like that will take a while).
Suggesting that I should do that right is a bit moot since the infrastructure
just isn't there. I may or may not re-submit the driver at that time; we'll see.

But I won't go through hoops and add unnecessary complexity to the driver 
(and make it much less usable for our purpose) and to the rest of our code just
to get the driver into the upstream kernel. Upstream integration is beneficial,
but only to a point.

Thanks,
Guenter
