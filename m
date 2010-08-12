Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760470Ab0HLRwZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Aug 2010 13:52:25 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:63722 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752947Ab0HLRwY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Aug 2010 13:52:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=CiM06VQuZHJ27Hv4wnomtBZGK6aBSdtW/11aZnX6BOk//Y8GlJqAeMuo3wn/P80CrP
         E8U6Fx2egrU/yOIXzLsf4Gbd/acwo+TnbXM6H4URdVpyrrh9WNqq5MZUYK0nWVLhqGgF
         nY7ruv4IJQ64CzlcdaMmKm0N0ujY70zCwyYHY=
MIME-Version: 1.0
In-Reply-To: <20100812161935.GC2524@linux.vnet.ibm.com>
References: <20100808213821.GD3635@thunk.org>
	<20100809112453.77210acc@lxorguk.ukuu.org.uk>
	<20100809181638.GI3026@linux.vnet.ibm.com>
	<20100809201822.441905f7@lxorguk.ukuu.org.uk>
	<20100810044541.GA2817@linux.vnet.ibm.com>
	<20100810093849.138e2318@lxorguk.ukuu.org.uk>
	<20100811004223.GH2379@linux.vnet.ibm.com>
	<AANLkTik7Po9OuKC-QBZ=E83J70sU_ewNi+nNWgcjjLXd@mail.gmail.com>
	<20100811221258.GI2516@linux.vnet.ibm.com>
	<AANLkTi=fJjM=uWeV+L66ajM9rhrL0t1OO-C7ThNRdbae@mail.gmail.com>
	<20100812161935.GC2524@linux.vnet.ibm.com>
Date: Thu, 12 Aug 2010 20:52:22 +0300
Message-ID: <AANLkTi=51cFa0t5ZYj2CMiauuW80ZWTrm1tQkn63Et0F@mail.gmail.com>
Subject: Re: Attempted summary of suspend-blockers LKML thread, take three
From: Felipe Contreras <felipe.contreras@gmail.com>
To: paulmck@linux.vnet.ibm.com
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, "Ted Ts'o" <tytso@mit.edu>,
        david@lang.hm, Brian Swetland <swetland@google.com>,
        linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        arve@android.com, mjg59@srcf.ucam.org, pavel@ucw.cz,
        florian@mickler.org, rjw@sisk.pl, stern@rowland.harvard.edu,
        peterz@infradead.org, tglx@linutronix.de, menage@google.com,
        david-b@pacbell.net, James.Bottomley@suse.de, arjan@infradead.org,
        swmike@swm.pp.se, galibert@pobox.com, dipankar@in.ibm.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 12, 2010 at 7:19 PM, Paul E. McKenney
<paulmck@linux.vnet.ibm.com> wrote:
> On Thu, Aug 12, 2010 at 03:17:29AM +0300, Felipe Contreras wrote:
>> Anyway, Alan was picturing a hypothetical point in time when x86 can
>> suspend/resume as fast as ARM, and thus the question of whether or not
>> to enable suspend-blockers in a system that runs openoffice becomes
>> relevant. If applications have been fixed by that time to not wake the
>> system unnecessarily, as many of them have already been tanks to tools
>> like powertop, then suspend-blockers would not make that much of a
>> difference, therefore the effort required to implement
>> suspend-blockers properly on all applications in the system, including
>> openoffice might not be worth the gain.
>
> One more time, this time with feeling.  ;-)
>
>        Only PM-driving applications need concern themselves with suspend
>        blockers, and experience thus far indicates that PM-driving
>        applications are a very small fraction of the total.

There's no experience on this. Have you tried to run a small debian
system with suspend blockers enabled? I can image at least all cron
daemons need modifications, probably dbus, links, lftp, wget, rsync
and a bunch of applications that download data too.

It's easy to speculate one way or the other, but the fact of the
matter is that we don't really know how many changes are needed in
order to have a functional system that actually benefits from suspend
blockers.

What we know is that if an application is not analyzed to see if it
needs suspend blockers, and implement them if needed, it might get
broken.

>> > Apparently different people in this debate have different targets.
>>
>> I remember clearly Android people explaining that dynamic PM is
>> orthogonal to suspend-blockers; if a suspend is blocked, you still
>> want dynamic PM to reach the lower power state. Therefore the target
>> of not having unneeded runnable tasks is shared by Android folks.
>
> And I have not seen anyone argue that suspend blockers are a replacement
> for dynamic power management.

That's exactly what I'm saying: they are orthogonal.

> In contrast, you are advocating dynamic power management to the exclusion
> of other mechanisms.

 * if dynamic PM was perfect, spend-blockers would *not* be not needed
 * if suspend-blockers were perfect, dynamic *will* still be needed

All I said in that sentence you are replying is that dynamic PM will
improve; it's a shared goal of everyone.

>> IOW. Alan wasn't talking about idle vs suspend on the same device, he
>> was talking about opportunistic suspend vs dynamic PM.
>
> The most convincing comparisons will be of suspend vs. idle on the
> same device.  If multiple devices are involved, then the most convincing
> experiments would compare suspend vs. idle separately on each device.
>
> So, are you sure that you are correctly interpreting Alan's words?

The point you are trying to highlight is to which events the system
reacts, that has nothing to do with dynamic PM vs opportunistic
suspend.

> Again, I am in no way arguing for suspend blockers to the exclusion of
> other approaches.  Heck, I am mostly just trying to get a clear statement
> of the problem.  In contrast, you do seem to be advocating for dynamic
> power management to the exclusion of other approaches.

What you are doing is copy pasting a definition of what is
opportunistic suspend and making it pass as an advantage.

This particular point (3.) is not an advantage, over dynamic PM, it's
just a difference.

>> No, I think both (for opportunistic suspend and dynamic PM) are
>> completely reasonable. But think again; if you have the assumptions
>> met on both, then both work fine, if you don't meet them, then both
>> don't work correctly.
>
> That is true of any artifact, software or otherwise: if you don't meet the
> assumptions inherent in its design and construction, the artifact might
> fail.

[...]

> There is
> a very real difference between those two tasks.

I've cut most of your explanation. If I understand correctly what you
are saying is that suspend blockers are harder to get wrong. I agree,
but my point against 4. remains the same: suspend-blockers don't
automatically get you more efficient power usage.

> So are you sure that dynamic power management will turn out to be
> the right tool for every job out there?  If so, on what grounds?

I don't understand this question. Dynamic PM is needed regardless. We
are discussing your point 4 where you say suspend blockers inevitably
lead to more efficient power usage (I say not necessarily).

>> My point is that suspend-blockers don't magically reduce power usage,
>> just like dynamic PM, it depends on what user-space actually does. You
>> made it look as it *always* reached better energy efficiency.
>
> I do?  Really???  Exactly what did I say to give you that impression?

Here's your point 4 again:

> >> > 4.      Suspend generally forces devices to go into their low-power
> >> >        states immediately.  In contrast, idle generally leaves unused
> >> >        devices at full power, relying on timers to shut down these
> >> >        devices.  Idle thus has shorter average wakeup latencies, but
> >> >        worse energy efficiency.

Remove "but worse energy efficiency" and I think that point would be
correct, albeit it's not really an argument in favor of opportunistic
suspend.

>> > It seems to me that the same social-engineering approaches work in
>> > both cases.
>>
>> Yes, but if dynamic PM works as advertised, you don't need
>> opportunistic suspend.
>
> For dynamic power management to totally eliminate the need for something
> like suspend blockers, you are having to make some brave assumptions.
> Yes, dynamic power management is quite useful, but there is a big
> difference between something being useful and something doing everything
> for everyone.  You have not yet convinced me that dynamic power management
> will make it to the "doing everything for everyone" stage.

As it has been explained before, there's a sweet-spot of idleness:
http://article.gmane.org/gmane.linux.kernel/995525
http://article.gmane.org/gmane.linux.ports.arm.omap/37982

Do you agree that there's such a thing, and if so, do you agree that
the benefits of opportunistic suspend are much less once that point is
reached?

>> >> If not, you'll see much worst energy efficiency. So in theory maybe,
>> >> but in practice you can't say that.
>> >
>> > Really?  What makes you say that?
>>
>> For starters an application might be holding the wakelock more than it
>> should, also, an application might miss a timer due to not having PM
>> permissions to hold the lock, and thus might need an expensive
>> initialization when it runs again.
>
> Just as an application might run continuously without blocking, which
> would defeat the dynamic power management scheme that have thus far been
> put forward.  And just as an application might miss a timer due to
> dynamic power management having decided that it didn't need that timer
> to fire at the desired time.

You are making this discussion entropic, concentrate on what I said:
>>>> If not, you'll see much worst energy efficiency. So in theory maybe,
>>>> but in practice you can't say that.

I just proved to you that in certain cases opportunistic suspend might
actually hurt. Thus you should accept my premise that you can't say
that in practice opportunistic suspend _always_ leads to better
results, because that's not the case.

And in order to try to avoid going back to the same points:
 1) yes, there are advantages of opportunistic suspend
 2) yes, there are cases where it works as it should
 3) no, it's not a silver bullet that will inevitably improve power usage
 4) no, we can't say anything about what opportunistic suspend means in practice

-- 
Felipe Contreras
