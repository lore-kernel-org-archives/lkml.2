Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755444Ab0E0AtP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 20:49:15 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:38880 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754081Ab0E0AtN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 20:49:13 -0400
MIME-Version: 1.0
In-Reply-To: <20100527003943.07c17f85@lxorguk.ukuu.org.uk>
References: <1274482015-30899-1-git-send-email-arve@android.com>
	<201005242049.18920.rjw@sisk.pl>
	<87wrusvrqe.fsf@deeprootsystems.com>
	<201005250138.16293.rjw@sisk.pl>
	<1274863655.5882.4875.camel@twins>
	<AANLkTinN6MKvCEhPkbYQRD2gu-mGXdNW9asRsTuKN3_Y@mail.gmail.com>
	<1274867106.5882.5090.camel@twins>
	<20100526120242.5c9b73ad@schatten.dmk.lab>
	<AANLkTim4021cTnhVZrQpefq1MG-eEPOFLDRO-XDepHb4@mail.gmail.com>
	<20100526133721.602633b2@schatten.dmk.lab>
	<AANLkTikzgaOFdQKess4E-D86OLPOzxP3dWiDkU_UR0ri@mail.gmail.com>
	<20100526142430.327ccbc4@schatten.dmk.lab>
	<20100526141612.3e2e0443@lxorguk.ukuu.org.uk>
	<AANLkTin97MMu-XO_Lk-snefBWz2ymhS0Qi1y1RxLwdVA@mail.gmail.com>
	<20100527003943.07c17f85@lxorguk.ukuu.org.uk>
Date: Wed, 26 May 2010 17:49:11 -0700
Message-ID: <AANLkTinOf__Q9XIM1Lll1eJ5HZ35zkDlUp60LmGcetdG@mail.gmail.com>
Subject: Re: [linux-pm] [PATCH 0/8] Suspend block api (version 8)
From: =?ISO-8859-1?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Florian Mickler <florian@mickler.org>, Vitaly Wool <vitalywool@gmail.com>,
       Peter Zijlstra <peterz@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>, Paul@smtp1.linux-foundation.org,
       felipe.balbi@nokia.com,
       Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
       Linux PM <linux-pm@lists.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/5/26 Alan Cox <alan@lxorguk.ukuu.org.uk>:
> On Wed, 26 May 2010 15:30:58 -0700
> Arve Hjønnevåg <arve@android.com> wrote:
>
>> On Wed, May 26, 2010 at 6:16 AM, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
>> >> Really, what are you getting at? Do you deny that there are programs,
>> >> that prevent a device from sleeping? (Just think of the bouncing
>> >> cows app)
>> >>
>> >> And if you have two kernels, one with which your device is dead after 1
>> >> hour and one with which your device is dead after 10 hours. Which would
>> >> you prefer? I mean really... this is ridiculous.
>> >
>> > The problem you have is that this is policy. If I have the device wired
>> > to a big screen and I want cows bouncing on it I'll be most upset if
>> > instead it suspends.
>>
>> We never suspend when the screen is on. If the screen is off, I would
>> not be upset if it suspends.
>
> This is policy and platform specific. The OLPC can suspend with the
> screen on. Should I write my app to know about this once for Android and
> once for OLPC (and no doubt once for Apple). In the OLPC case cows could
> indeed suspend to RAM between frames if the wakeup time was suitable.

Are you still talking about Linux suspend? If you can enter S3 from
idle and still wake up for the next timer or interrupt, then do that.
Suspend blockers should have not effect on this.

>
> My app simply should not have to know this sort of crap, that's the whole
> point of an OS.
>

Most apps does not have to know about this with opportunistic suspend
either. If the user is interacting with the device, we don't suspend.
If your apps needs to run when the user is not interacting with the
device, then you can block suspend.

>> > What you are essentially arguing for is for the
>> > kernel to disobey the userspace.
>>
>> No I'm not. User-space asked the kernel to suspend when possible.
>> Suspend is an existing kernel feature. All opportunistic suspend adds
>> is the ability to use it safely when there are wakeup event you cannot
>> afford to ignore.
>
> Don't get me wrong - opportunistic suspend isn't the problem. Suspend
> blockers are - or more precisely - the manner in which they express
> intent from userspace. Opportunistic suspend is wonderful stuff for all
> sorts of things and if it persuades people like netbook manufacturers to
> think harder, and Linux driver authors to optimise their suspend/resume
> paths we all win.
>
>> Our actual stating point is this: Some systems can only enter their
>> lowest power state from suspend. So we added an api that allowed us to
>> use suspend without loosing wakeup events. Since suspending also
>> improves our battery life on platforms that enter the same power state
>> from idle and suspend and we already have a way to safely use suspend,
>> we would be crazy not to use it.
>
> Opportunistic suspend isn't special. Suspend is just a very deep idle. In

Suspend as it is currently implemented in Linux is special. Regular
timers stop, and only specially marked wakeup events can bring the
system back to the normal state.

> fact some of the low power states on processors look little different to
> suspend - the OS executes a whole pile of CPU state saving and cache
> flushing. It might be a hardware state machine, it might be buried in
> firmware or it might be quite explicit (eg mrst). So we already have
> differing degrees of doing additional work in different states.
>
> User triggered suspend is a bit special in that the user is usually right
> in that case to override the power management policy.
>

On a phone this is not the case. The user manually can toggle the
screen on and off, and we may or may not enter suspend when the screen
is off. If we forced suspend when the user turned the screen off, we
could miss phone calls.

> Note I'm not suggesting we run off and restructure all our power
> management code to take this view right now. I'm suggesting we need a
> clean 'opportunistic suspend is not special' view by user space. How the
> kernel handles this is addressible later without app breakage, but only
> if we get the interface wrong to begin with.
>
>> > Sandboxing/Resource Limits: handling apps that can't be trusted. So the
>> > phone runs the appstore code via something like
>>
>> Sandboxing is problematic on Android since there are a lot of cross
>> process dependencies. When a call comes in I don't know where the name
>> and picture to display comes from. With suspend blockers we block
>> suspend when we get notified that we have an incoming call and we can
>> call into any process and get a response.
>
> But you can express user suspend blocking in this manner. Your call
> incoming code would say 'I want good latency'. As someone needs good
> latency the box won't suspend. If your approach is to start with an
> initial 'anyone can set a low latency we don't care' then anyone can
> block suspends.
>
> Equally your call handling example is about latency not about suspend.
> You want the phone to stay on, to fetch a picture and display it promptly.
>

I don't think a latency api is the right way to express this since the
only latency values we would use is minimal-latency and any-latency.
What we are expressing is that this works need to happen now, even if
the user is not currently interacting with the device.

> So what are expressing
>
> 'I am using device 'screen' please keep it live'  (which may or may not
> block suspend - see OLPC). I guess your display server and kernel support
> manage this bit.
>
> 'I want the photo to appear in a resonable timescale'  (latency). It's
> not a suspend question - an imaginary non suspend idle mode with a 20
> second latency would be just as annoying yes ?
>
> At the moment we have a very real bigger problem that your problem is
> part of.
>
> - Hard real time people want to be able to limit the CPU sleeping
>  behaviour based upon what tasks are running
>
> - Certain gaming types want their boxes to be good power citizens except
>  when committing digital mass murder. Right now that involves wrapping
>  the game in a script with bits occurring as root and that generally
>  breaks if the game crashes so the script doesn't run nicely on exit
>
> - Virtual machine people desperately want to see latency data to help
>  schedule stuff in a power efficient manner.  In a virtual machine
>  environment its vital information about how you schedule a virtual
>  machine, whether now is a good time to live migrate it and how best to
>  optimise power/performance on the server end.
>
> - Some drivers want to constrain idling because they know
>  platform/hardware stuff the core power management code doesn't (eg
>  serial ports at high speed). We want that expressed in a way that keeps
>  the power management code clean of such device knowledge
>
> Now I don't care if we have an elegant kernel interface and Android uses
> it as a big hammer - if that makes Android work well everyone can be
> happy. What I don't want is to have a big hammer when it doesn't solve the
> underlying big picture problem for everyone.
>
> So my working position is summarised thusly
>
> - Supporting Android needs well good
> - Opportunistic suspend good
> - Manner in which interface is expressed to userspace bad
> - Latency constraint interface would be better
> - Your existing behaviour can be implemented by a simplistic use of a
>  latency constraint interface
> - We can fix a pile of other directly connected things at the same time
> - Implementation internals I care far less about because we can fix those
>  later
> - Suspend is just a power state
>
> How does that fit your model and vision ?
>

We have two main modes of operation. The user is interacting with the
device and tasks and timers should run as requested. And, the user is
not interacting with the device and the device should enter (and stay
in) low power states regardless of running tasks and timers. Since
some events (e.g. incoming phone call, alarm clock) will may cause the
user to start interacting with the device, they need special
treatment. A per thread latency api does not work for us. A global
latency api could work, but since would only use minimal latency or
any latency this seem like overkill. Also, with a global latency api,
how do I know it the requested latency is meant to improve the
experience while the user is interacting with the app, or if it meant
the app needs to run when the user is not interacting with the device.

>> What about platforms that currently cannot enter low power states from
>> idle? Do you remove suspend support from the kernel?
>
> I would actually expect a system that can't do any low power states to
> support the user API and blissfully ignore it. Applications will ask for

I don't think you understood what I asked. Currently most x86 systems
can enter much lower power states from suspend than they can from
idle. Are you suggesting that we remove suspend support from Linux and
try to enter the same power states on x86 from idle that we now enter
from suspend? It is not clear to me if this is possible.

> various latency guarantees and of course always get them. The apps will be
> portable, the device will be offering it's best behaviour and everyone
> will be happy.
>
> If your device only supports full on and suspend I don't see why
> opportunistic suspend couldn't be provided assuming sufficient wakeup
> support was present. It won't be the most exciting power management
> policy to write but it's perfectly doable and the apps again will not need
> recoding to handle it.
>
> The latency goal data is also priceless for another consumer - in a
> virtual machine environment its vital information about how you schedule
> a virtual machine, whether now is a good time to live migrate it and how
> best to optimise power/performance on the server end.
>
> Alan
>



-- 
Arve Hjønnevåg
