Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753448Ab2LEQjL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2012 11:39:11 -0500
Received: from rhlx01.hs-esslingen.de ([129.143.116.10]:33974 "EHLO
	rhlx01.hs-esslingen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752495Ab2LEQjI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2012 11:39:08 -0500
Date: Wed, 5 Dec 2012 17:39:05 +0100
From: Andreas Mohr <andi@lisas.de>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Borislav Petkov <bp@alien8.de>, Andreas Mohr <andi@lisas.de>,
        linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
Subject: Re: Look Ma, da kernel is b0rken
Message-ID: <20121205163905.GA18522@rhlx01.hs-esslingen.de>
References: <20121205070901.GA12123@rhlx01.hs-esslingen.de>
 <20121205142935.GA12119@liondog.tnic>
 <20121205152756.5afec12c@pyramind.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121205152756.5afec12c@pyramind.ukuu.org.uk>
X-Priority: none
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, Dec 05, 2012 at 03:27:56PM +0000, Alan Cox wrote:
> > On Wed, Dec 05, 2012 at 08:09:01AM +0100, Andreas Mohr wrote:
> > > Hi,
> > > 
> > > drivers/pnp/pnpacpi/core.c: In function 'ispnpidacpi':
> > > drivers/pnp/pnpacpi/core.c:65:2: warning: logical 'or' of collectively
> > > exhaustive tests is always true [-Wlogical-op]
> > > drivers/pnp/pnpacpi/core.c:66:2: warning: logical 'or' of collectively
> > > exhaustive tests is always true [-Wlogical-op]
> > > drivers/pnp/pnpacpi/core.c:67:2: warning: logical 'or' of collectively
> > > exhaustive tests is always true [-Wlogical-op]
> > > 
> > > 
> > > That's already the second less enticing -Wlogical-op issue
> > > which was discovered by accident during less than two days
> 
> No it's not. It's been reported in bugzilla. I sent patches ages ago.
> They were ignored. Coverity has had it tagged for years (and a ton more
> of them you've not noticed yet)

And that additional new info bit now arriving
is supposed to improve on the total set of the general state of affairs
as I'm observing it (and thus to appease me, sufficiently), how exactly? ;)
(well, admittedly it was new to me since I didn't bother with doing
any more research after discovering that bug
after also having endured countless pages of dangerously obscuring
completely *superfluous* warning spew scrolling by)

Let's see:

- we've got this *core layer* (right?) bug
  originally appearing in <= 2.6.10 (2004, i.e. 8+ years).
- we've got a janitorial project which does not (possibly "cannot"?)
  do a sufficiently clean work (as evidenced by a metric crap ton of
  header-side woefully repeated warnings persisting over perhaps half a year
  in my observation, with W=2 or W=3)
- we've got how many dozen dozen kernel maintainers or "interested" persons
  who I'd imagine would be a sure-fire method to get such issues fixed
  in due time, and how many distributors or embedded companies
  who I'd imagine would help towards doing a quite large amount of effective
  testing/verification/housekeeping work in a controlled manner?
  (which would include regularly/mechanically keeping an eye
  on a larger set of *non-default* compiler warnings, too)
- we've got how many kernel-related tools to assist in such efforts,
  which then were not being followed sufficiently? [Coverity]
- and now your reply seems to indicate we additionally have
  a less optimal response time for such fixes, too?


If that isn't a strong indicator of having to spend some time on
rethinking possibly automated kernel development core infrastructure
or due process...


Heck, the Linux kernel isn't a "Joe's Garage works" effort -
it's a *very* widely used *very* public project, thus you'd think
with its clout and resulting manpower
it should be able to easily afford things such as near-eradication of warnings
(and thus the resulting much improved precision in *successfully* letting
mere users pinpoint single critical warnings as near-soon as they newly appear, due to a low amount of warnings even on a high warning level).


I'm afraid even with my measly very specific project/laughable manpower
I've got certain parts in place which go beyond of what the kernel
chooses to use.


As an additional factor, the C-based kernel has the convenience of
not even having to spend effort on the large set
of additional compiler warnings that the developer is gifted with in C++ space!


For gcc -Wlogical-op, it seems many articles/discussions were in 2009 time,
thus there admittedly probably wasn't such a large window of opportunity
to get this bug discovered - however that's still no excuse for the very
visible showering of simple warnings when enabling advanced levels.


Thanks to Borislav Petkov for his reply, too -
however I'd like to state that given this lack of tooling/attention
writing a mail in this more special manner was fully justified IMPHO.

Andreas Mohr
