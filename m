Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753002Ab0HGBmi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Aug 2010 21:42:38 -0400
Received: from mail.lang.hm ([64.81.33.126]:49400 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752510Ab0HGBmh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Aug 2010 21:42:37 -0400
Date: Fri, 6 Aug 2010 18:40:55 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
cc: linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        arve@android.com, mjg59@srcf.ucam.org, pavel@ucw.cz,
        florian@mickler.org, rjw@sisk.pl, stern@rowland.harvard.edu,
        swetland@google.com, peterz@infradead.org, tglx@linutronix.de,
        alan@lxorguk.ukuu.org.uk, menage@google.com, david-b@pacbell.net,
        James.Bottomley@suse.de, tytso@mit.edu, arjan@infradead.org,
        swmike@swm.pp.se, galibert@pobox.com, dipankar@in.ibm.com
Subject: Re: Attempted summary of suspend-blockers LKML thread, take three
In-Reply-To: <20100807002543.GP2432@linux.vnet.ibm.com>
Message-ID: <alpine.DEB.2.00.1008061800580.30564@asgard.lang.hm>
References: <20100731175841.GA9367@linux.vnet.ibm.com> <20100804195704.GA23681@linux.vnet.ibm.com> <20100806225453.GA3947@linux.vnet.ibm.com> <alpine.DEB.2.00.1008061651530.30564@asgard.lang.hm> <20100807002543.GP2432@linux.vnet.ibm.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 6 Aug 2010, Paul E. McKenney wrote:

> On Fri, Aug 06, 2010 at 04:59:54PM -0700, david@lang.hm wrote:
>> one other nice-to-have (or conflicting requirement, depending on
>> your point of view), and I think one of the big things causing
>> people to dislike wavelocks, is the desire to not have to modify
>> applications to have them work with the infrastructure.
>>
>> you sort of touch on this when you say that power oblivious
>> applications need to be able to be intergrated, but it goes beyond
>> what that statement implies.
>>
>> with wavelocka, even power optimized applications need to be
>> modified, or the system may halt them at any time.
>
> Yes, I believe that Android would require most power-optimized application
> be modified to use wakelocks.  But power-optimized applications require
> so much tweaking that the addition of suspend blockers (or whatever
> other power-control mechanism) is pretty much a non-issue by comparison.
>
> And the number of power-optimized applications should be small, which,
> as you noted earlier, greatly eases the overall pain of modifying them.

except, power optimized applications aren't just written for android, they 
are also written for many other battery powered devices, many of which 
don't use wavelocks (and in fact, have no real reason to as they don't 
also have the untrusted apps running)

As such the pool of power optmized software will grow faster than the pool 
of wakelock enabled software.

>> one thing that has been very clear over the years is that if an API
>> only exists on Linux, no matter how good it is, most application
>> developers won't use it.
>
> Many application developers do indeed value portability.  But this in turn
> means that most application developers will not be writing power-optimized
> applications, because the process of power-optimization significantly
> degrades portability.  Just as does the process of performance tuning,
> beyond a certain point.

just like performance tuning, power optimization only degrades portability 
beyond a certin point. A lot of power optimization is like a lot of 
performance tuning, find algorithms that you are using (usually frequent 
polling in the case of power optimizations) and change them. These changes 
are very frequently very portable.

In this case we are talking about changes that not only aren't portable 
across different Operating systems, they would not even be portable across 
Linux itself.

> Of course, the reason that application developers value portability is
> that this is one way to gain large unit volumes.  Another way to gain
> large unit volumes is to code for a very popular platform, which explains
> the large number of apps that run only on iPhone, Android, and Windows.
>
> And in my experience, developers who have decided to commit to a single
> platform are usually not at all shy about exploiting special facilities
> of that platform to the fullest.

and they are not shy about ignoring other variations of a platform either 
(for example, Adobe has flash for i386 linux, but not amd64 linux, arm 
linux, powerpc linux, etc)

I see this as a bad thing to be discouraged.

>> In this case we are in an even worse situation, it's not only
>> specific to Linux, it's specific to a subset of Linux systems, and
>> not using it will cause no problems most of the time.
>
> It seems to me that PM-driving and power-optimized applications are going
> to be highly platform specific, whether that platform be Linux or some
> other OS.

The thing is, they don't need to be.

>> now, android is betting that the apps are all developed specifically
>> for the android from scratch, so having a different API is
>> acceptable, even if it cuts them off from the rest of the *nix
>> applications. For a phone this is not neccessarily an unreasonable
>> stance, but as Android moves into the spaces where normal
>> applications are in use (netbooks and tablets), this becomes a much
>> shakier stance to take.
>
> There certainly does seem to be a large and growing number of Android
> apps, so I might be reluctant to bet against them.  And the Android guys
> appear to be making another bet as well -- that almost all applications
> will be power-oblivious.  Their design handles this rather well, given
> that such applications need not worry about special power-control
> features.

there is also a growing population of nook applications, kindle 
applications (ok, in this category there are only two released, both in 
the last week, but the SDK has not hit public release yet ;-), maemo 
applications, OLPC applications, tom-tom applications, .....

unless all of these platforms are going to start using wavelocks there are 
going to be power optimized applications out there that don't use 
wavelocks.


>From this discussion, it looks to me like Android wants two key features 
that they don't see a way to get today

1. the ability to decide to suspend while there are still some 
'unimportant' apps running.

2. changes to idle/suspend so that they can get into a state of lower 
power consumption thatn any existing idle state (by being able to disable 
clocks), but still have some parts of the system powered (so that they are 
more awake than suspend)

If these two features were available, I think that the rest of what they 
are looking for could be built up without requireing other changes.

In addition to these key features, the fact that they use suspend much 
more frequently means that the race condition between deciding to freeze 
and wake events happening is far more likely to cause them problems, so 
improvements in this area are needed. I don't think that there is any 
fundamental opposition to these improvements, just questions on how best 
to do it without causing performance problems.



Today Android uses wakelocks to indicate that there is something 
'important' running and trigger a suspend when nothing 'important' is 
running.

they have cusomized suspend to sometimes not shut everythng down.



My straw-man to address these is the following

1. create the ability to tag cgroups with power management values
      track their timers separatly
      be able to set idle time before sleep per-group instead of system-wide
      other things in the future
        eventually this could be things like preventing processes in 
different cgroups from sharing userspace mutexes (or at least detecting 
when this is the case) to support being able to freeze one cgroup without 
affectng others.

2. modify the schedular/idle thread to be able to decide to go to a 
low-power state based on the cgroup information
      In addition to checking this in the idle thread, optionally check 
this at other times so that you can trigger low-power states even if not 
completely idle (possibly during the scheduler rebalancing check??)

3. modify the move to low-power modes to include disabling more components 
in the system (including clocks), in the extreme case this would be a full 
suspend.

      This may include doing work to standardize power management for 
devices more than it is to more readily be able to power down components.

      this may include making an idle mode of 'stop all clocks except for 
one alarm, until the alarm goes off, then advance the clocks to reflect 
the time passed'

      This probably does require the conceptual change from the fairly 
monolithic 'you are in this C state' approach to a more fine grained 'the 
CPU is in this C state, the video card is in that power management state, 
the audio is in this other state.....'

David Lang
