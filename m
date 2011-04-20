Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752699Ab1DTSRL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Apr 2011 14:17:11 -0400
Received: from imr4.ericy.com ([198.24.6.8]:39994 "EHLO imr4.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751630Ab1DTSRJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Apr 2011 14:17:09 -0400
Date: Wed, 20 Apr 2011 11:16:52 -0700
From: Guenter Roeck <guenter.roeck@ericsson.com>
To: Arnd Bergmann <arnd@arndb.de>
CC: Greg Kroah-Hartman <gregkh@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jonathan Cameron <kernel@jic23.retrosnub.co.uk>,
        Randy Dunlap <rdunlap@xenotime.net>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] misc: Driver for Silicon Labs Si570 and compatibles
Message-ID: <20110420181652.GA23298@ericsson.com>
References: <1303248968-5069-1-git-send-email-guenter.roeck@ericsson.com>
 <201104201844.30919.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <201104201844.30919.arnd@arndb.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 20, 2011 at 12:44:30PM -0400, Arnd Bergmann wrote:
> On Tuesday 19 April 2011, Guenter Roeck wrote:
> > This driver adds support for Si570, Si571, Si598, and Si599
> > programmable XO/VCXO.
> > 
> > Signed-off-by: Guenter Roeck <guenter.roeck@ericsson.com>
> 
> This needs some more explanation of what the hardware is there for,
> and why it's unlike everything else that we support in Linux.
> 
This is a generic configurable clock device. I'll be happy to add
some text such as "The device can be used for any application requiring
a static or a dynamically configurable clock, such as serdes clocks".
Not sure if that would add much value, though.

Regarding "unlike everything else", not sure if that is really correct.
The DDS chips Jonathan mentioned do get pretty close, and there are
other drivers providing support for clock chips, though typically more
dedicated.  ics932s401 in misc is one example, and then there are all
the tuner chips in media/common/tuners/.

> We try not to have too many things in drivers/misc that are
> one-off interfaces, so if the hardware is related to something
> else, it should probably go into one subsystem.
> 
> My impression from readin the source code is that this is
> simply a clock device that would be used in combination with
> some other device in practice that consumes the clock.

Exactly. Point here is that it can be _any_ other device.

> If that is true, it should probably not have a user-visible
> interface, but only an interface that can be used by other
> kernel drivers.
> 
Depends. In our case, turns out the devices consuming the clock
have user mode drivers. Lots of history there, but the chip vendors 
provide those user mode drivers, and the teams responsible for
integrating the drivers decided to not rewrite it to kernel mode drivers.
Also, for special purposes such as margining, it is necessary to control
the clock from userspace. So, for our use case, I need the user-visible
interface. I _don't_ need the kernel interface, at least not right now,
which is why I did not add it.

Browsing through the web, it seems the chip is somewhat popular with
Amateur Radio. No idea if it would ever be controlled for such a purpose
from Linux, but if so, it would also require a user configurable frequency.

If there is a better place for such a driver than misc, please let me know.

Thanks,
Guenter

