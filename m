Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761709Ab0HMPPB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Aug 2010 11:15:01 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:53475 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755092Ab0HMPO6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Aug 2010 11:14:58 -0400
Date: Fri, 13 Aug 2010 08:14:51 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Felipe Contreras <felipe.contreras@gmail.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, "Ted Ts'o" <tytso@mit.edu>,
        david@lang.hm, Brian Swetland <swetland@google.com>,
        linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        arve@android.com, mjg59@srcf.ucam.org, pavel@ucw.cz,
        florian@mickler.org, rjw@sisk.pl, stern@rowland.harvard.edu,
        peterz@infradead.org, tglx@linutronix.de, menage@google.com,
        david-b@pacbell.net, James.Bottomley@suse.de, arjan@infradead.org,
        swmike@swm.pp.se, galibert@pobox.com, dipankar@in.ibm.com
Subject: Re: Attempted summary of suspend-blockers LKML thread, take three
Message-ID: <20100813151451.GC2511@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20100809181638.GI3026@linux.vnet.ibm.com>
 <20100809201822.441905f7@lxorguk.ukuu.org.uk>
 <20100810044541.GA2817@linux.vnet.ibm.com>
 <20100810093849.138e2318@lxorguk.ukuu.org.uk>
 <20100811004223.GH2379@linux.vnet.ibm.com>
 <AANLkTik7Po9OuKC-QBZ=E83J70sU_ewNi+nNWgcjjLXd@mail.gmail.com>
 <20100811221258.GI2516@linux.vnet.ibm.com>
 <AANLkTi=fJjM=uWeV+L66ajM9rhrL0t1OO-C7ThNRdbae@mail.gmail.com>
 <20100812161935.GC2524@linux.vnet.ibm.com>
 <AANLkTi=51cFa0t5ZYj2CMiauuW80ZWTrm1tQkn63Et0F@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTi=51cFa0t5ZYj2CMiauuW80ZWTrm1tQkn63Et0F@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 12, 2010 at 08:52:22PM +0300, Felipe Contreras wrote:
> On Thu, Aug 12, 2010 at 7:19 PM, Paul E. McKenney
> <paulmck@linux.vnet.ibm.com> wrote:
> > On Thu, Aug 12, 2010 at 03:17:29AM +0300, Felipe Contreras wrote:
> >> Anyway, Alan was picturing a hypothetical point in time when x86 can
> >> suspend/resume as fast as ARM, and thus the question of whether or not
> >> to enable suspend-blockers in a system that runs openoffice becomes
> >> relevant. If applications have been fixed by that time to not wake the
> >> system unnecessarily, as many of them have already been tanks to tools
> >> like powertop, then suspend-blockers would not make that much of a
> >> difference, therefore the effort required to implement
> >> suspend-blockers properly on all applications in the system, including
> >> openoffice might not be worth the gain.
> >
> > One more time, this time with feeling.  ;-)
> >
> >        Only PM-driving applications need concern themselves with suspend
> >        blockers, and experience thus far indicates that PM-driving
> >        applications are a very small fraction of the total.
> 
> There's no experience on this. Have you tried to run a small debian
> system with suspend blockers enabled? I can image at least all cron
> daemons need modifications, probably dbus, links, lftp, wget, rsync
> and a bunch of applications that download data too.

I have not.  I would be surprised if anyone else did that work unless
suspend blockers were in mainline.  I would be very happy to be proven
wrong, of course!

> It's easy to speculate one way or the other, but the fact of the
> matter is that we don't really know how many changes are needed in
> order to have a functional system that actually benefits from suspend
> blockers.
> 
> What we know is that if an application is not analyzed to see if it
> needs suspend blockers, and implement them if needed, it might get
> broken.

That would be your speculation.  Perhaps you are correct, but it seems
more likely that some large sets applications can be considered as a group
rather than one at a time.

> >> > Apparently different people in this debate have different targets.
> >>
> >> I remember clearly Android people explaining that dynamic PM is
> >> orthogonal to suspend-blockers; if a suspend is blocked, you still
> >> want dynamic PM to reach the lower power state. Therefore the target
> >> of not having unneeded runnable tasks is shared by Android folks.
> >
> > And I have not seen anyone argue that suspend blockers are a replacement
> > for dynamic power management.
> 
> That's exactly what I'm saying: they are orthogonal.

OK, good to know!  Please understand that your sentence "Therefore the
target of not having unneeded runnable tasks is shared by Android folks"
can be interpreted as meaning "the Android guys really don't need suspend
blockers", which is how I interpreted it.

> > In contrast, you are advocating dynamic power management to the exclusion
> > of other mechanisms.
> 
>  * if dynamic PM was perfect, spend-blockers would *not* be not needed
>  * if suspend-blockers were perfect, dynamic *will* still be needed
> 
> All I said in that sentence you are replying is that dynamic PM will
> improve; it's a shared goal of everyone.

That is certainly not the way I read the sentence I was replying to,
but I will accept that this was what you were really trying to say.

> >> IOW. Alan wasn't talking about idle vs suspend on the same device, he
> >> was talking about opportunistic suspend vs dynamic PM.
> >
> > The most convincing comparisons will be of suspend vs. idle on the
> > same device.  If multiple devices are involved, then the most convincing
> > experiments would compare suspend vs. idle separately on each device.
> >
> > So, are you sure that you are correctly interpreting Alan's words?
> 
> The point you are trying to highlight is to which events the system
> reacts, that has nothing to do with dynamic PM vs opportunistic
> suspend.

Ahem.  I -do- know what -I- was trying to say.  ;-)

> > Again, I am in no way arguing for suspend blockers to the exclusion of
> > other approaches.  Heck, I am mostly just trying to get a clear statement
> > of the problem.  In contrast, you do seem to be advocating for dynamic
> > power management to the exclusion of other approaches.
> 
> What you are doing is copy pasting a definition of what is
> opportunistic suspend and making it pass as an advantage.

No, I was copy pasting a definition of a difference between idle and
suspend and making it pass as a difference between idle and suspend.

> This particular point (3.) is not an advantage, over dynamic PM, it's
> just a difference.

Yep.  I never claimed otherwise.

> >> No, I think both (for opportunistic suspend and dynamic PM) are
> >> completely reasonable. But think again; if you have the assumptions
> >> met on both, then both work fine, if you don't meet them, then both
> >> don't work correctly.
> >
> > That is true of any artifact, software or otherwise: if you don't meet the
> > assumptions inherent in its design and construction, the artifact might
> > fail.
> 
> [...]
> 
> > There is
> > a very real difference between those two tasks.
> 
> I've cut most of your explanation.

Indeed you have!  But you should be safe in doing so, as most people
probably won't bother to do the web search that would lead them to
http://lkml.org/lkml/2010/8/12/198 and then search that page for the
word "artifact".  ;-)

>                                    If I understand correctly what you
> are saying is that suspend blockers are harder to get wrong. I agree,
> but my point against 4. remains the same: suspend-blockers don't
> automatically get you more efficient power usage.

I am glad you agree that suspend blockers might be harder to get
wrong.  As to point #4, you were correct that I badly worded the last
sentence, which is now hopefully fixed to your satisfaction.

> > So are you sure that dynamic power management will turn out to be
> > the right tool for every job out there?  If so, on what grounds?
> 
> I don't understand this question. Dynamic PM is needed regardless. We
> are discussing your point 4 where you say suspend blockers inevitably
> lead to more efficient power usage (I say not necessarily).

But can dynamic power management do everything optimally?  If not, some
other approach may be needed in addition to dynamic power management.
If you really are arguing that the Linux kernel should support no
power-management mechanism other than dynamic power management, you
should be prepared to justify that position.

> >> My point is that suspend-blockers don't magically reduce power usage,
> >> just like dynamic PM, it depends on what user-space actually does. You
> >> made it look as it *always* reached better energy efficiency.
> >
> > I do?  Really???  Exactly what did I say to give you that impression?
> 
> Here's your point 4 again:
> 
> > >> > 4.      Suspend generally forces devices to go into their low-power
> > >> >        states immediately.  In contrast, idle generally leaves unused
> > >> >        devices at full power, relying on timers to shut down these
> > >> >        devices.  Idle thus has shorter average wakeup latencies, but
> > >> >        worse energy efficiency.
> 
> Remove "but worse energy efficiency" and I think that point would be
> correct, albeit it's not really an argument in favor of opportunistic
> suspend.

Fix put forward in earlier email.  Again, thank you -- good catch!!!

> >> > It seems to me that the same social-engineering approaches work in
> >> > both cases.
> >>
> >> Yes, but if dynamic PM works as advertised, you don't need
> >> opportunistic suspend.
> >
> > For dynamic power management to totally eliminate the need for something
> > like suspend blockers, you are having to make some brave assumptions.
> > Yes, dynamic power management is quite useful, but there is a big
> > difference between something being useful and something doing everything
> > for everyone.  You have not yet convinced me that dynamic power management
> > will make it to the "doing everything for everyone" stage.
> 
> As it has been explained before, there's a sweet-spot of idleness:
> http://article.gmane.org/gmane.linux.kernel/995525
> http://article.gmane.org/gmane.linux.ports.arm.omap/37982
> 
> Do you agree that there's such a thing, and if so, do you agree that
> the benefits of opportunistic suspend are much less once that point is
> reached?

I agree that there will be a sweet spot of idleness (though I would call
it a "point of diminishing returns"), but only if all the applications
are power-optimized.  The advantage of opportunistic suspend is instead
its tolerance of power-oblivious applications with minimal degradation
of battery life.

> >> >> If not, you'll see much worst energy efficiency. So in theory maybe,
> >> >> but in practice you can't say that.
> >> >
> >> > Really?  What makes you say that?
> >>
> >> For starters an application might be holding the wakelock more than it
> >> should, also, an application might miss a timer due to not having PM
> >> permissions to hold the lock, and thus might need an expensive
> >> initialization when it runs again.
> >
> > Just as an application might run continuously without blocking, which
> > would defeat the dynamic power management scheme that have thus far been
> > put forward.  And just as an application might miss a timer due to
> > dynamic power management having decided that it didn't need that timer
> > to fire at the desired time.
> 
> You are making this discussion entropic, concentrate on what I said:
> >>>> If not, you'll see much worst energy efficiency. So in theory maybe,
> >>>> but in practice you can't say that.
> 
> I just proved to you that in certain cases opportunistic suspend might
> actually hurt. Thus you should accept my premise that you can't say
> that in practice opportunistic suspend _always_ leads to better
> results, because that's not the case.

And in the paragraph above, I proved to you that relying solely on dynamic
power management might actually hurt.  And I am not trying to prove
that opportunistic suspend always leads to better results -- that is a
strawman that you set up.  And yes, you might have been led to set up that
strawman because I messed up the wording of one of the suspend-vs.-idle
definitions.  Of course, had you called out that sentence to start with,
we would likely have spent much less time arguing generalities.  ;-)

> And in order to try to avoid going back to the same points:
>  1) yes, there are advantages of opportunistic suspend

Good, agreed.

>  2) yes, there are cases where it works as it should

Good, agreed.

>  3) no, it's not a silver bullet that will inevitably improve power usage

Agreed.  This is no surprise, as there are very few silver bullets to be
had in this field.  Of course, dynamic power management is not a silver
bullet, either.

>  4) no, we can't say anything about what opportunistic suspend means in practice

Here I disagree.  The Android folks have used it for quite some time.
We might not be able to apply their experience directly to other software
stacks, but we should nevertheless be able to learn quite a bit from it.

							Thanx, Paul
