Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758355Ab0HDGcX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 02:32:23 -0400
Received: from mail.lang.hm ([64.81.33.126]:40979 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755611Ab0HDGcW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 02:32:22 -0400
Date: Tue, 3 Aug 2010 23:30:33 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: =?ISO-8859-15?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>
cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Arjan van de Ven <arjan@infradead.org>, "Ted Ts'o" <tytso@mit.edu>,
        linux-pm@lists.linux-foundation.org,
        linux-kernel <linux-kernel@vger.kernel.org>, mjg59@srcf.ucam.org,
        pavel@ucw.cz, florian@mickler.org, rjw@sisk.pl,
        stern@rowland.harvard.edu, swetland@google.com, peterz@infradead.org,
        tglx@linutronix.de, alan@lxorguk.ukuu.org.uk
Subject: Re: Attempted summary of suspend-blockers LKML thread
In-Reply-To: <AANLkTi=O++qfY7zz5rErqWQn0n4Tj7dfxQNcytjwiP4q@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.1008032312440.25170@asgard.lang.hm>
References: <20100801210548.23f77ff6@infradead.org> <alpine.DEB.2.00.1008012153300.25170@asgard.lang.hm> <20100802140933.GB2405@linux.vnet.ibm.com> <alpine.DEB.2.00.1008021627290.29820@asgard.lang.hm> <AANLkTi=1kBuyPS_P+eNLcnRu1mJH6BzpzQW_sENZuL1L@mail.gmail.com>
 <alpine.DEB.2.00.1008022121430.6545@asgard.lang.hm> <AANLkTikhcYzNp8CPp8cqrV7Ey5CLMWu1sJTNxUtEi2as@mail.gmail.com> <alpine.DEB.2.00.1008022203470.6545@asgard.lang.hm> <AANLkTinFT5jq4nUhUpzS5S4TVDQGj0S7RtRgxNhsz2UF@mail.gmail.com>
 <alpine.DEB.2.00.1008031611100.6545@asgard.lang.hm> <20100804001015.GJ2407@linux.vnet.ibm.com> <alpine.DEB.2.00.1008031723530.6545@asgard.lang.hm> <AANLkTinjH0C0bSK=Y2wKASnbJFsR2BN303xBXkaHbmRC@mail.gmail.com> <alpine.DEB.2.00.1008032111350.25170@asgard.lang.hm>
 <AANLkTi=O++qfY7zz5rErqWQn0n4Tj7dfxQNcytjwiP4q@mail.gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="680960-610028221-1280903433=:25170"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--680960-610028221-1280903433=:25170
Content-Type: TEXT/PLAIN; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8BIT

On Tue, 3 Aug 2010, Arve Hj?nnev?g wrote:

> 2010/8/3  <david@lang.hm>:
>> On Tue, 3 Aug 2010, Arve Hj?nnev?g wrote:
>>
>>> On Tue, Aug 3, 2010 at 5:51 PM,  <david@lang.hm> wrote:
>>>>
>>>> On Tue, 3 Aug 2010, Paul E. McKenney wrote:
>>>>
>>>>> OK, I'll bite...
>>>>
>>>> thanks, this is not intended to be a trap.
>>>>
>>>>> From an Android perspective, the differences are as follows:
>>>>>
>>>>> 1. ? ? ?Deep idle states are entered only if there are no runnable
>>>>> tasks.
>>>>> ? ? ? ?In contrast, opportunistic suspend can happen even when there
>>>>> ? ? ? ?are tasks that are ready, willing, and able to run.
>>>>
>>>> Ok, this is a complication to what I'm proposing (and seems a little odd,
>>>> but I can see how it can work), but not neccessarily a major problem. it
>>>> depends on exactly how the decision is made to go into low power states
>>>> and/or suspend. If this is done by an application that is able to look at
>>>> either all activity or ignore one cgroup of processes at different times
>>>> in
>>>> it's calculations than this would work.
>>>>
>>>>> 2. ? ? ?There can be a set of input events that do not bring the system
>>>>> ? ? ? ?out of suspend, but which would bring the system out of a deep
>>>>> ? ? ? ?idle state. ?For example, I believe that it was stated that one
>>>>> ? ? ? ?of the Android-based smartphones ignores touchscreen input while
>>>>> ? ? ? ?suspended, but pays attention to it while in deep idle states.
>>>>
>>>> I see this as simply being a matter of what devices are still enabled at
>>>> the
>>>> different power savings levels. At one level the touchscreen is still
>>>> powered, while at another level it isn't, and at yet another level you
>>>> have
>>>> to hit the power soft-button. This isn't fundamentally different from
>>>> powering off a USB peripheral that the system decides is idle (and then
>>>> not
>>>> seeing input from it until something else wakes the system)
>>>
>>> The touchscreen on android devices is powered down long before we
>>> suspend, so that is not a good example. There is still a significant
>>> difference between suspend and idle though. In idle all interrupts
>>> work, in suspend only interrupts that the driver has called
>>> enable_irq_wake on will work (on platforms that support it).
>>
>> are you talking about Android here or are you talking genricly across all
>> platforms?
>>
>
> This appears to be the current Linux driver model. Old platform code
> hardcoded the wakeup interrupts.

not quite the question I was trying (and failing) to ask, but from the 
answer it sounds like setting suspend to wake up on all interrupts is 
the same as idle.

so here suspend is looking like just a variation of low-power idle 
(different wakeup criteria)

>>>>> 3. ? ? ?The system comes out of a deep idle state when a timer
>>>>> ? ? ? ?expires. ?In contrast, timers cannot expire while the
>>>>> ? ? ? ?system is suspended. ?(This one is debatable: some people
>>>>> ? ? ? ?argue that timers are subject to jitter, and the suspend
>>>>> ? ? ? ?case for timers is the same as that for deep idle states,
>>>>> ? ? ? ?but with unbounded timer jitter. ?Others disagree. ?The
>>>>> ? ? ? ?resulting discussions have produced much heat, but little
>>>>> ? ? ? ?light. ?Such is life.)
>>>>
>>>> if you have the ability to wake for an alarm, you have the ability to
>>>> wake
>>>> for a timer (if from no other method than to set the alarm to when the
>>>> timer
>>>> tick would go off)
>>>>
>>>
>>> If you just program the alarm you will wake up see that the monotonic
>>> clock has not advanced and set the alarm another n seconds into the
>>> future. Or are proposing that suspend should be changed to keep the
>>> monotonic clock running? If you are, why? We can enter the same
>>> hardware states from idle, and modifying suspend to wake up more often
>>> would increase the average power consumption in suspend, not improve
>>> it for idle. In other words, if suspend wakes up as often as idle, why
>>> use suspend?
>>
>> no, I was thinking that you set the alarm to go off, and when it goes off
>> and wakes you up, you correct other local clocks before doing anything else.
>>
>> even if they wake up at the same time, you would use suspend instead of idle
>> if it saved more power (allowing for the power to get in and out of suspend
>> vs the power to get in and out of idle)
>
> Suspend and idle use the same power state on the devices we shipped.
> The power saving we get from suspend if from ignoring the timers.

Ok, so if you set the alarm to the next time the timer for a privilaged 
task would run and wake up then to be completely transparent to the 
privilaged task, or you could decide to disable the timers as well

again, this looks like suspend and idle are very closely related.

>> in this case, another reason you would consider using suspend over idle is
>> that you can suspend until the next timer that your privilaged applications
>> have set, and skip timers set by the non-privilaged applications, resulting
>> in more time asleep.
>
> Without wakelock or suspend blockers this can still break since a
> privileged application may be waiting on a resource held by a
> non-privileged application.

since the non-privilaged application is never frozen when a privilaged 
application is running, I'm not sure how you would get this to happen that 
wouldn't also be a problem with wakelocks.

if you want to have a privilaged application keep the system awake while 
it waits for a non-privilaged application, all it would need to do is to 
set a timer near enough in the future that it's considered 'awake' all the 
time. this will cost a context switch every timeout period (for the 
application to check that it's still waiting and set the next timer), but 
that's pretty cheap.

one thing this would destroy is the stats currently built around the 
wakelock, but since they would be replaced by stats of exactly the type of 
thing that powertop was written to deal with, I don't see this as a 
problem (powertop would just have to learn a mode where it ignores the 
non-privilaged tasks).consolodating tools is a good thing.

>>>>> There may well be others.
>>>>>
>>>>> Whether these distinctions are a good thing or a bad thing is one of
>>>>> the topics of this discussion. ?But the distinctions themselves are
>>>>> certainly very real, from what I can see.
>>>>>
>>>>> Or am I missing your point?
>>>>
>>>> these big distinction that I see as significant seem to be in the
>>>> decision
>>>> of when to go into the different states, and the difference between the
>>>> states ?themselves seem to be less significant (and either very close to,
>>>> or
>>>> within the variation that already exists for power saving modes)
>>>>
>>>> If I'm right bout this, then it would seem to simplify the concept and
>>>> change it from some really foreign android-only thing into a special case
>>>> variation of existing core concepts.
>>>
>>> Suspend is not an android only concept. The android extensions just
>>> allow us to aggressively use suspend without loosing (or delaying)
>>> wakeup events. On the hardware that we shipped we can enter the same
>>> power mode from idle as we do in suspend, but we still use suspend
>>> primarily because it stops the monotonic clock and all the timers that
>>> use it. Changing suspend to behave more like an idle mode, which seems
>>> to be what you are suggesting, would not buy us anything.
>>
>> Ok, If I am understanding you correctly I think this is an important point.
>>
>> What Android calls suspend is not what other linux distros call suspend,
>> it's just a low-power mode with different wakeup rules.
>>
>> Is this correct?
>>
>
> No. Android suspend is Linux suspend. We just enter it more frequently.

In Linux, a full suspend normally takes the system down to a mode that 
can't be reached by the normal idle mechnism (including powering down 
peripherals). It also takes significantly different actions to wake up. 
What you are describing seems much milder than that.

>> If this is the case it seems even more so that the android suspend should be
>> addressed by tieing into the power management/idle stuff rather than the
>> suspend/hibernate side of things
>>
>> is the reason you want to stop the onotonic clock and the timers because the
>> applications need to be fooled into thinking no time has passed?
>>
>
> Yes, but this is not an Android extension, it is part of the normal
> Linux suspend sequence.

no, as noted by others in this thread, normal linux suspend/resume 
modifies the clock to show that time has passed since the suspend 
happened.

>> or is it to prevent extranious wakeups?
>>
> That too.

as noted above, this sounds like it's configurable.

>> or is it to save additional power?
>>
> No (assuming you are asking about the clock), the actual hardware
> clock (on msm) stops even in idle but it is resynchronized on wakeup
> with a clock that never stops when used from idle.

so I'm left not understanding the huge desire to stop the monotonic clock.

>>>> you have many different power saving modes, the daemon (or kernel code)
>>>> that
>>>> is determining which mode to go into would need different logic
>>>> (including,
>>>> but not limited to the ability to be able to ignore one or more cgroups
>>>> of
>>>> processes). different power saving modes have different trade-offs, and
>>>> some
>>>> of them power down different peripherals (which is always a platform
>>>> specific, if not system specific set of trade-offs)
>>>>
>>>
>>> The hardware specific idle hook can (and does) decide to go into any
>>> power state from idle that does not disrupt any active devices.
>>
>> This I know is an Andoid specific thing. On other platforms power states
>> very definantly can make user visible changes.
>
> How is this Android specific?

you are stating that this must be suspend because low-power idle must be 
transparent to the user.

I am saying that on Linux, low-power idle commonly is not transparent to 
the user, so the requirement for it to be transparent (therefor putting 
the suspend into a different category) is an Android only requirement.

David Lang
--680960-610028221-1280903433=:25170--
