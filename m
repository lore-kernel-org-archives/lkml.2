Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753535Ab1DULLi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Apr 2011 07:11:38 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:65036 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752969Ab1DULLg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Apr 2011 07:11:36 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Guenter Roeck <guenter.roeck@ericsson.com>,
        "Hans J. Koch" <hjk@hansjkoch.de>
Subject: Re: [PATCH v2] misc: Driver for Silicon Labs Si570 and compatibles
Date: Thu, 21 Apr 2011 13:11:25 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.37; KDE/4.3.2; x86_64; ; )
Cc: "Greg Kroah-Hartman" <gregkh@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jonathan Cameron <kernel@jic23.retrosnub.co.uk>,
        Randy Dunlap <rdunlap@xenotime.net>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <1303248968-5069-1-git-send-email-guenter.roeck@ericsson.com> <201104201844.30919.arnd@arndb.de> <20110420181652.GA23298@ericsson.com>
In-Reply-To: <20110420181652.GA23298@ericsson.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201104211311.25988.arnd@arndb.de>
X-Provags-ID: V02:K0:Nv7XiGcHUp0p2ViVyIiVa7G112GvL8HqENoRuB5vtSJ
 HFWnZ9iEb/fdk62l2HKnWnlFgvc8UPhF20NzdQXhCN0V5vWkgb
 LNSad9EVMuNT2JCtiwTUYEq91uoyyR/xHRhwyCYGYUNaw2K3lW
 60FE83LlAzn+GjlMpHlemOU4De3WSfEUq+1GW2Qh9kR/1XSXhw
 +8IDjuhNadE51AWaRM0aQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 20 April 2011, Guenter Roeck wrote:
> On Wed, Apr 20, 2011 at 12:44:30PM -0400, Arnd Bergmann wrote:
> > On Tuesday 19 April 2011, Guenter Roeck wrote:
> > > This driver adds support for Si570, Si571, Si598, and Si599
> > > programmable XO/VCXO.
> > > 
> > > Signed-off-by: Guenter Roeck <guenter.roeck@ericsson.com>
> > 
> > This needs some more explanation of what the hardware is there for,
> > and why it's unlike everything else that we support in Linux.
> > 
> This is a generic configurable clock device. I'll be happy to add
> some text such as "The device can be used for any application requiring
> a static or a dynamically configurable clock, such as serdes clocks".
> Not sure if that would add much value, though.
> 
> Regarding "unlike everything else", not sure if that is really correct.
> The DDS chips Jonathan mentioned do get pretty close, and there are
> other drivers providing support for clock chips, though typically more
> dedicated.  ics932s401 in misc is one example, and then there are all
> the tuner chips in media/common/tuners/.

Isn't that what you'd normally call a 'struct clk' then?

> > If that is true, it should probably not have a user-visible
> > interface, but only an interface that can be used by other
> > kernel drivers.
> > 
> Depends. In our case, turns out the devices consuming the clock
> have user mode drivers. Lots of history there, but the chip vendors 
> provide those user mode drivers, and the teams responsible for
> integrating the drivers decided to not rewrite it to kernel mode drivers.
> Also, for special purposes such as margining, it is necessary to control
> the clock from userspace. So, for our use case, I need the user-visible
> interface. I _don't_ need the kernel interface, at least not right now,
> which is why I did not add it.
> 
> Browsing through the web, it seems the chip is somewhat popular with
> Amateur Radio. No idea if it would ever be controlled for such a purpose
> from Linux, but if so, it would also require a user configurable frequency.
> 
> If there is a better place for such a driver than misc, please let me know.

When you say user mode driver, do you mean as in drivers/uio? (taking Hans
on Cc for these)

Those already have generic support for memory and interrupt resources,
maybe we can just add a common way to associate a uio device with a struct clk
and provide a sysfs or ioctl interface to set a clock for a given device.

	Arnd
