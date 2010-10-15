Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756249Ab0JOP3l (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Oct 2010 11:29:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57171 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754334Ab0JOP3k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Oct 2010 11:29:40 -0400
Date: Fri, 15 Oct 2010 12:29:11 -0300
From: Glauber Costa <glommer@redhat.com>
To: john stultz <johnstul@us.ibm.com>
Cc: linux-kernel@vger.kernel.org, avi@redhat.com,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH] use a stable clock reference in vdso vgetns
Message-ID: <20101015152911.GP5590@mothafucka.localdomain>
References: <1285938596-2186-1-git-send-email-glommer@redhat.com>
 <AANLkTimdukAnwtPooFJYTxtzoT+Scy9JwWoxkkj3g0zO@mail.gmail.com>
 <20101013140746.GM5590@mothafucka.localdomain>
 <1287020215.3467.27.camel@localhost.localdomain>
 <20101014024445.GN5590@mothafucka.localdomain>
 <1287080211.3138.0.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1287080211.3138.0.camel@localhost.localdomain>
X-ChuckNorris: True
User-Agent: Jack Bauer
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 14, 2010 at 11:16:51AM -0700, john stultz wrote:
> On Wed, 2010-10-13 at 23:44 -0300, Glauber Costa wrote:
> > On Wed, Oct 13, 2010 at 06:36:55PM -0700, john stultz wrote:
> > > On Wed, 2010-10-13 at 11:07 -0300, Glauber Costa wrote:
> > > > On Fri, Oct 01, 2010 at 10:49:53AM -0700, john stultz wrote:
> > > > > On Fri, Oct 1, 2010 at 6:09 AM, Glauber Costa <glommer@redhat.com> wrote:
> > > > > > When using vdso services for clock_gettime, we test for the ability
> > > > > > of a fine-grained measurement through the existance of a vread() function.
> > > > > >
> > > > > > However, from the time we test it, to the time we use it, vread() reference
> > > > > > may not be valid anymore. It happens, for example, when we change the current
> > > > > > clocksource from one that provides vread (say tsc) to one that lacks it
> > > > > > (say acpi_pm), in the middle of clock_gettime routine.
> > > > > >
> > > > > > seqlock does not really protect us, since readers here won't stop the writers
> > > > > > to change references. The proposed solution is to grab a copy of the clock
> > > > > > structure early, and use it as a stable reference onwards.
> > > > > 
> > > > > Ah. Good find! The fix looks reasonable to me. However, its likely the
> > > > > similar code in arch/x86/kernel/vsyscall_64.c will need a similar fix.
> > > > > 
> > > > > Awhile back there was some motivation to merge the two vdso/vsyscall
> > > > > implementations to avoid the duplication, but my memory is failing on
> > > > > why that didn't happen. I feel like it had to do with complication
> > > > > with the way the two implementations are mapped out to userland. Even
> > > > > so, it seems a shared forced inline method would resolve the issue, so
> > > > > maybe it just fell off the todo list?
> > > > News here?
> > > 
> > > Errr.. Sorry, are you waiting for me to implement this? Or did you want
> > > a comment on your earlier mail? (Apologies, I've been a bit scattered
> > > here).
> > > 
> > np. Comments on the earlier e-mail.
> > I tried a bit more with that, and sent two other e-mails arguing why I thought
> > that was the right approach. (well, the second best, just after unification)
> > 
> > > I think trying to unify the two implementations would be nice if you're
> > > up to trying, but if not, go ahead and push your patch and that will fix
> > > the bug until I can get around to looking at the unification.
> > Unfortunately, I have other things under my radar now, so if people
> > don't see a problem, I'd like to have this particular problem solved.
> > The patch seems right anyway.
> 
> Ok. Then go ahead and push it in and I'll try to get the unification
> done later.
Also, if we're integrating this, I'd expect the code in vdso to be
the end result, not the other way around. This makes this patch applicable
as-is, anyway.

So, as for pushing it, I don't expect any changes to it. Maintainers?

