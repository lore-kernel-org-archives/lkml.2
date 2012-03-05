Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757542Ab2CET42 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 14:56:28 -0500
Received: from mx1.redhat.com ([209.132.183.28]:43736 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757522Ab2CET41 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 14:56:27 -0500
Date: Mon, 5 Mar 2012 14:56:19 -0500
From: Josh Boyer <jwboyer@redhat.com>
To: John Stultz <john.stultz@linaro.org>
Cc: Dave Jones <davej@redhat.com>,
        Fedora Kernel Team <kernel-team@fedoraproject.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: WARNING: Adjusting tsc more then 11%
Message-ID: <20120305195619.GB17489@zod.bos.redhat.com>
References: <20120305154411.GA29668@redhat.com>
 <1330972323.2191.74.camel@work-vm>
 <20120305192338.GA30491@redhat.com>
 <1330977010.2191.84.camel@work-vm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1330977010.2191.84.camel@work-vm>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 05, 2012 at 11:50:10AM -0800, John Stultz wrote:
> On Mon, 2012-03-05 at 14:23 -0500, Dave Jones wrote:
> > On Mon, Mar 05, 2012 at 10:32:03AM -0800, John Stultz wrote:
> >  > On Mon, 2012-03-05 at 10:44 -0500, Dave Jones wrote:
> > 
> >  > > any idea what could have changed to start tripping that up ?
> >  > > 
> >  > > The reports seem to have started around 3.3-rc4.
> >  > 
> >  > Huh. No I don't know what would have started causing such a warning. I
> >  > had expected that there would be some edge hardware that might trip that
> >  > warning, but I'd expect the noise to start there w/ 3.2 after it was
> >  > introduced. There's only been spelling & comment changes to the
> >  > timekeeping core in the 3.3-rc series.
> > 
> > thinking about this some more, while the reports starts around rc4, this
> > may have been caused by something prior to that, as anyone moving from
> > Fedora 16 or earlier to F17 alpha would have jumped quite a kernel version or two.
> 
> Was F16 3.1 based? The warning was added in 3.2, so if you skipped it,
> it may not be new behavior then.
> 
> >  > Do you know if this is an occasional thing on any of the affected
> >  > hardware, or if it happens after every reboot?
> > 
> > Out of all the people running the Fedora 17 alpha, this has only shown
> > up those four times, so it does seem to be a rare thing.
> > I suspect we'll get more instances of it as more people start testing.
> > 
> > Three of the reporters noted that it happened on boot.
> > 
> >  > Are any of the reported boxes systems you have access to in order to
> >  > reproduce?
> > 
> > unfortunately not.
> 
> Ok. Well, just to level set: the warning is informative, and points to
> unexpected, but not necessarily unsafe behavior.
> 
> In fact, the risk (where mult is adjusted to be large enough to cause an
> overflow) we're warning about have been present 2.6.36 or even possibly
> before. The change in 3.2 which added the warning also added a more
> conservative mult calculation, so we're less likely to get overflow
> prone large mult values.

Is there a reason you decided to use a WARN_ONCE, which dumps a full stack
trace, instead of just printk(KERN_ERR ?

> So it would be great to get further feedback from folks who are seeing
> this warning, so we can really hammer this out, but I don't want the
> warning spooking anyone into thinking things are terribly broken.

Right... people see backtraces and start thinking "my kernel is broken."

I'm certainly not meaning to pick on you for this.  Lately it seems all
the rage to throw WARN_ONs for all kinds of error paths and leave the user
to figure out how screwed they are.

josh
