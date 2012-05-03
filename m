Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757637Ab2ECQyn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 12:54:43 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:58975 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755584Ab2ECQyl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 12:54:41 -0400
Date: Thu, 3 May 2012 18:54:37 +0200
From: Johan Hovold <jhovold@gmail.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Rob Landley <rob@landley.net>, Richard Purdie <rpurdie@rpsys.net>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Jonathan Cameron <jic23@cam.ac.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        Arnd Bergmann <arnd@arndb.de>,
        Andrew Morton <akpm@linux-foundation.org>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-iio@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-fbdev@vger.kernel.org
Subject: Re: [PATCH v2 1/4] mfd: add LM3533 lighting-power core driver
Message-ID: <20120503165437.GF15752@localhost>
References: <1334935826-12527-1-git-send-email-jhovold@gmail.com>
 <1336040799-18433-1-git-send-email-jhovold@gmail.com>
 <1336040799-18433-2-git-send-email-jhovold@gmail.com>
 <20120503103848.GB3955@opensource.wolfsonmicro.com>
 <20120503112803.GA15752@localhost>
 <20120503113801.GE3955@opensource.wolfsonmicro.com>
 <20120503150040.GC15752@localhost>
 <20120503152407.GK3955@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120503152407.GK3955@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 03, 2012 at 04:24:07PM +0100, Mark Brown wrote:
> On Thu, May 03, 2012 at 05:00:40PM +0200, Johan Hovold wrote:
> > On Thu, May 03, 2012 at 12:38:02PM +0100, Mark Brown wrote:
> 
> > > This is one of the reasons why we currently use tracepoints (they just
> > > don't have this issue as they're trivial to filter), though
> > > adding some sort of infrastructure for it ought not to be too difficult
> > > even if it's just at the regmap level.
> 
> > So a /sys/kernel/debug/regmap/<device>/io_printk attribute (with a
> > better name) to enable debug printks in io paths
> > (regmap*{read,write,update} outside of mutex) in regmap.c would be
> > acceptable?
> 
> Yes, that'd be totally fine for me - it's debugfs so we can always drop
> it later if someone comes up with a better idea or something.

Ok. I'll have a look at this next week (will be on the road for a few
days), and drop the dev_dbg from the lm3533 io-functions for now.

> > > Actually, the other question I had but forgot to ask (or I think punted
> > > on for your response) was why these are in sysfs at all - things like
> > > which things are connected to the backlight are going to be a property
> > > of the board design so should be defined by the machine not tweaked from
> > > userspace.
> 
> > I agree with you and the reason is the same as for the max_current
> > attribute (discussed in the other thread) -- it was an explicit request
> > from the end customer.
> 
> > I could replace the boost attributes with a platform_data entry where it
> > really belongs.
> 
> I really think this is much better for mainline.

Agreed.

> > There is a use case (beyond testing/integration) for keeping the (lvled)
> > outputs configurable from userspace, in that it provides a way to
> > synchronise LED activity such as blinking. So I still want to keep those,
> > at least for the lvleds.
> 
> I'm not sure exactly which control that is?

That would be the output_lvled[n] (n = 1..5) attributes. For example, to
have all five low-voltage sinks blink synchronously, you could assign 0
to all these five attributes, and set a timer trigger for the led device
which has id 0.

Thanks,
Johan
