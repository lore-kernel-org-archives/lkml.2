Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932510Ab2CEU2z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 15:28:55 -0500
Received: from mx1.redhat.com ([209.132.183.28]:62099 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932461Ab2CEU2y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 15:28:54 -0500
Date: Mon, 5 Mar 2012 15:28:46 -0500
From: Josh Boyer <jwboyer@redhat.com>
To: John Stultz <john.stultz@linaro.org>
Cc: Dave Jones <davej@redhat.com>,
        Fedora Kernel Team <kernel-team@fedoraproject.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: WARNING: Adjusting tsc more then 11%
Message-ID: <20120305202845.GD17489@zod.bos.redhat.com>
References: <20120305154411.GA29668@redhat.com>
 <1330972323.2191.74.camel@work-vm>
 <20120305192338.GA30491@redhat.com>
 <1330977010.2191.84.camel@work-vm>
 <20120305195619.GB17489@zod.bos.redhat.com>
 <1330979077.2191.96.camel@work-vm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1330979077.2191.96.camel@work-vm>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 05, 2012 at 12:24:37PM -0800, John Stultz wrote:
> > > Ok. Well, just to level set: the warning is informative, and points to
> > > unexpected, but not necessarily unsafe behavior.
> > > 
> > > In fact, the risk (where mult is adjusted to be large enough to cause an
> > > overflow) we're warning about have been present 2.6.36 or even possibly
> > > before. The change in 3.2 which added the warning also added a more
> > > conservative mult calculation, so we're less likely to get overflow
> > > prone large mult values.
> > 
> > Is there a reason you decided to use a WARN_ONCE, which dumps a full stack
> > trace, instead of just printk(KERN_ERR ?
> 
> Well, the WARN_ONCE behavior is really nice, since just a printk would
> end up possibly filling the logs, since you might get one every tick.

We have printk_once too.

> > > So it would be great to get further feedback from folks who are seeing
> > > this warning, so we can really hammer this out, but I don't want the
> > > warning spooking anyone into thinking things are terribly broken.
> > 
> > Right... people see backtraces and start thinking "my kernel is broken."
> > 
> > I'm certainly not meaning to pick on you for this.  Lately it seems all
> > the rage to throw WARN_ONs for all kinds of error paths and leave the user
> > to figure out how screwed they are.
> 
> Its a trade-off, since we really do want to know if our code has been
> pushed outside of its expected boundaries (either by unexpected hadware
> behavior or by expectations being raised, like long nohz idle times), so
> we have to get folks attention somewhat. The type of error reporting
> Dave's managed to collect here is really great.

It is, yes.  Do you know, aside from distro kernel maintainers, how many
reports have you gotten from actual users directly?

> But at the same time, I agree there has been a few cases where the code
> is limited more narrowly then the reality of existing hardware, and we
> end up with a constant stream of error messages that get waved off as
> broken hardware.
> 
> There we need to either fix the code or drop the warnings, but I think
> it gets hard when we really want to know about "unexpected behavior,
> except on some wide swath of hardware that always acts poorly", where
> conditionalizing the warnings isn't easy.

Oh my.  Quirks in the timekeeping code would just give me nightmares ;).

josh
