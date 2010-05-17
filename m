Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756049Ab0EQVE0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 17:04:26 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:63170 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752654Ab0EQVEY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 17:04:24 -0400
MIME-Version: 1.0
In-Reply-To: <AANLkTikEIuVEhJXSx4kP4sGMP8LBepuJI5jBjqSxoH7F@mail.gmail.com>
References: <1272667021-21312-1-git-send-email-arve@android.com>
	 <20100503215028.GB18910@srcf.ucam.org>
	 <alpine.DEB.2.00.1005141408260.3348@utopia.booyaka.com>
	 <20100514203202.GA12409@srcf.ucam.org>
	 <87aas2azc5.fsf@deeprootsystems.com>
	 <20100514231510.GG16989@thunk.org>
	 <87r5laa4oc.fsf@deeprootsystems.com>
	 <AANLkTilL90pYVlquvMDAEPHj_AraEi9Qzk-0tTjw9Bkx@mail.gmail.com>
	 <AANLkTil7358FHTlFZ0LqwymkiZZ-7An0HlaOTVhTkpgW@mail.gmail.com>
	 <AANLkTikEIuVEhJXSx4kP4sGMP8LBepuJI5jBjqSxoH7F@mail.gmail.com>
Date: Mon, 17 May 2010 14:04:20 -0700
Message-ID: <AANLkTimsPpdWEEuwcsJ2XT7fHO8h-EyzYvR06X5EJ-T5@mail.gmail.com>
Subject: Re: [linux-pm] [PATCH 0/8] Suspend block api (version 6)
From: Mike Chan <mike@android.com>
To: Vitaly Wool <vitalywool@gmail.com>
Cc: Kevin Hilman <khilman@deeprootsystems.com>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, linux-kernel@vger.kernel.org,
       linux-pm@lists.linux-foundation.org,
       Arjan van de Ven <arjan@infradead.org>,
       Matthew Garrett <mjg@redhat.com>, Len Brown <len.brown@intel.com>,
       Jacob Pan <jacob.jun.pan@linux.intel.com>,
       Oleg Nesterov <oleg@redhat.com>, Liam Girdwood <lrg@slimlogic.co.uk>,
       linux-omap@vger.kernel.org,
       Linus Walleij <linus.walleij@stericsson.com>,
       Daniel Walker <dwalker@codeaurora.org>, tytso@mit.edu,
       Brian Swetland <swetland@google.com>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Geoff Smith <geoffx.smith@intel.com>, Tejun Heo <tj@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Wu Fengguang <fengguang.wu@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 17, 2010 at 1:17 PM, Vitaly Wool <vitalywool@gmail.com> wrote:
> On Mon, May 17, 2010 at 10:07 PM, Mike Chan <mike@android.com> wrote:
>> On Mon, May 17, 2010 at 12:27 PM, Vitaly Wool <vitalywool@gmail.com> wrote:
>>> On Mon, May 17, 2010 at 6:12 PM, Kevin Hilman
>>> <khilman@deeprootsystems.com> wrote:
>>>
>>>>> and #2, the battery lifetime on the N770 and N800 (both of which I have)
>>>>> is **appalling** **bad**.
>>>>
>>>> Appalling bad compared to what?
>>>>
>>>> What's probably more interesting in terms of rough comparisons is
>>>> comparing similar devices with and without opportunistic suspend.  The
>>>> Nokia n900 (maemo) and the Moto Droid (android) use the same SoC (TI
>>>> OMAP3) and roughly the same kernel (2.6.2[89], although both are
>>>> heavily patched from mainline.)
>>>>
>>>> The n900 *never* suspends.  It only uses dynamic PM + CPUidle.
>>>> The droid uses opportunistic suspend (as well as dynamic PM + CPUidle)
>>>>
>>>> I don't know of any more objective comparison of the two, but as a
>>>> user of both devices I can say that the active usage is basically the
>>>> same (around a day) and the idle use is similar as well, even though
>>>> the Droid has a slightly bigger battery (1400 mAh vs. 1320 mAh.)  My
>>>> own usage suggests the n900 is a bit better in idle time, but I have
>>>> not done any measuring or objective tests.  I'm guessing the
>>>> difference is probably because the Droid does not use the deepest
>>>> off-mode power states either in idle or suspend (IIRC) where the n900
>>>> does.  I suspect that if both were using off-mode and had the same
>>>> battery, these differences would go away.
>>>>
>>
>> Although both are OMAP3430 and run 2.6.29 you cannot compare the N900
>> and Droid's perceived user battery life to one another to evaluate
>> opportunistic suspend. There are many factors uncounted for such as:
>> network reception, screen brightness (and size), button back-light,
>> keyboard back-light, modem stack (CDMA vs UMTS). Also the difference
>> in uerspace.
>>
>>>> While this is not really a scientific comparison, it at least gives a
>>>> rough idea.  If using opportunistic suspend was adding noticably
>>>> better battery life, I think this would be a different discussion.
>>>


Okay, I measured with and without using the scientific method. With a
1390mAh battery, if you set your device in airplane mode you will get
435.7 hours of standby vs 397.14 hours of standby.

Is this data sufficient for a "different discussion" now?

>>> Exactly. The point is, opportunistic suspend doesn't in fact add any
>>> value compared to dynamic PM + CPUIdle. It only produces some false
>>> impression that one can handle power management right without using
>>> dynamic PM. And this false impression is the cause for many really
>>> ugly designs (like, for instance, 15 minutes touchscreen inactivity
>>> delay before forcibly shutting down the wireless, as it's done in
>>> stock Android framework).
>>>
>>
>> Opportunistic suspend is an extension to the current suspend model,
>> not a replacement dynamic / run-time PM. If you can replace good old
>> suspend then this would be a different story.
>
> Yes, but what does it extend? What aspect it makes the current suspend
> model better in?
>

Network configuration and cell reception is a big factor here. You can
easily get +4-8mA on the original numbers I gave below, so its large
enough to skew your "perceived" power usage.

>> As you mention, Droid uses opportunistic suspend + dynamic pm +
>> cpuidle + freq. So I decided to do some measurements on a Droid using
>> our 2.9.32 kernel
>> (http://android.git.kernel.org/?p=kernel/omap.git;a=summary). For a
>> little better apples to apples comparison.
>>
>> Droid (idle system, airplane mode, screen off, 3 min interval):
>> measured average current
>> - with opportunity suspend: 3.19mA
>> - without opportunistic suspend: 3.5mA
>>
>> Stock userspace build, all I did was replace the kernel. We are
>> hitting retention on idle as well as suspend for omap (instead of full
>> off-mode).
>
> That's implementation specific. If CPUIdle implemented CPU deep sleep,
> I bet you would see different figures.
>

The important part here is not the absolute value, but how they
compare relatively. If I added off-mode support then I the averages
would both drop, but they would not be the same (key point).

I simply wanted show with real numbers that there is a difference in
opportunistic suspend and without. Instead of purely hypothesizing
that there is no power benefit from using opportunistic suspend.


>> Also, your point about wifi, the 15 min timeout is in the framework
>> and is configurable in the code and via UI, nothing to do with kernel,
>> opportunistic suspend or run time suspend.
>
> You don't quite get it :) This should NOT at all be timeout driven.
> This should be activity driven or constraint driven which perfectly
> fits into the runtime PM paradigm but is in no way cleanly implemented
> within the "pure" Android PM.
>

I admit, our timeout approach is a bit hacky, but there is method for
the madness.

In order to properly determine when you should turn off wifi for
"perfect" power management, you need to know a few things. 1) When, in
the 'future' is the user going to turn on the screen. 2) How many
network packets will be sent  to the device while the screen is off.

Some of these factors are Android specific, in particular the device
always has a TCP connection open to google servers. So switching from
WIFI -> 3G for example causes us to generate extra network traffic as
we try to establish our SSL connection to google servers. Likewise
this cost is paid when moving from 3G -> wifi.

Its *really* hard to predict the future, so we use this timeout based
off of various heuristics, usability studies and power measurements.

So we attempt to minimize excessive network io for both power reasons
and network reasons (ie: cell carriers), as well as user experience
(latency to connect / disconnect to a wifi access point).

However we are not talking about kernel power management here, we are
talking about Android policy that might be dedicated by various OEM /
carrier requirements and user experience. I wouldn't necessarily go so
far and say its flat out "wrong" what we are doing, but I do feel that
it is Android specific enough that having our own policy for this is
valid.

If you feel strongly against this, I will be more than happy to dive
into details in an android specific thread off lkml.

-- Mike

> Thanks,
>   Vitaly
>
