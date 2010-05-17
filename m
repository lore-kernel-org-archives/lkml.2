Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756673Ab0EQWzo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 18:55:44 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:58552 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754734Ab0EQWzl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 18:55:41 -0400
To: Mike Chan <mike@android.com>
Cc: Vitaly Wool <vitalywool@gmail.com>, Greg Kroah-Hartman <gregkh@suse.de>,
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
Subject: Re: [linux-pm] [PATCH 0/8] Suspend block api (version 6)
References: <1272667021-21312-1-git-send-email-arve@android.com>
	<87wrvl5479.fsf@deeprootsystems.com>
	<20100503215028.GB18910@srcf.ucam.org>
	<alpine.DEB.2.00.1005141408260.3348@utopia.booyaka.com>
	<20100514203202.GA12409@srcf.ucam.org>
	<87aas2azc5.fsf@deeprootsystems.com>
	<20100514231510.GG16989@thunk.org>
	<87r5laa4oc.fsf@deeprootsystems.com>
	<AANLkTilL90pYVlquvMDAEPHj_AraEi9Qzk-0tTjw9Bkx@mail.gmail.com>
	<AANLkTil7358FHTlFZ0LqwymkiZZ-7An0HlaOTVhTkpgW@mail.gmail.com>
From: Kevin Hilman <khilman@deeprootsystems.com>
Organization: Deep Root Systems, LLC
Date: Mon, 17 May 2010 15:55:36 -0700
In-Reply-To: <AANLkTil7358FHTlFZ0LqwymkiZZ-7An0HlaOTVhTkpgW@mail.gmail.com> (Mike Chan's message of "Mon\, 17 May 2010 13\:07\:50 -0700")
Message-ID: <87mxvyt9xz.fsf@deeprootsystems.com>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mike Chan <mike@android.com> writes:

> On Mon, May 17, 2010 at 12:27 PM, Vitaly Wool <vitalywool@gmail.com> wrote:
>> On Mon, May 17, 2010 at 6:12 PM, Kevin Hilman
>> <khilman@deeprootsystems.com> wrote:
>>
>>>> and #2, the battery lifetime on the N770 and N800 (both of which I have)
>>>> is **appalling** **bad**.
>>>
>>> Appalling bad compared to what?
>>>
>>> What's probably more interesting in terms of rough comparisons is
>>> comparing similar devices with and without opportunistic suspend.  The
>>> Nokia n900 (maemo) and the Moto Droid (android) use the same SoC (TI
>>> OMAP3) and roughly the same kernel (2.6.2[89], although both are
>>> heavily patched from mainline.)
>>>
>>> The n900 *never* suspends.  It only uses dynamic PM + CPUidle.
>>> The droid uses opportunistic suspend (as well as dynamic PM + CPUidle)
>>>
>>> I don't know of any more objective comparison of the two, but as a
>>> user of both devices I can say that the active usage is basically the
>>> same (around a day) and the idle use is similar as well, even though
>>> the Droid has a slightly bigger battery (1400 mAh vs. 1320 mAh.)  My
>>> own usage suggests the n900 is a bit better in idle time, but I have
>>> not done any measuring or objective tests.  I'm guessing the
>>> difference is probably because the Droid does not use the deepest
>>> off-mode power states either in idle or suspend (IIRC) where the n900
>>> does.  I suspect that if both were using off-mode and had the same
>>> battery, these differences would go away.
>>>
>
> Although both are OMAP3430 and run 2.6.29 you cannot compare the N900
> and Droid's perceived user battery life to one another to evaluate
> opportunistic suspend. There are many factors uncounted for such as:
> network reception, screen brightness (and size), button back-light,
> keyboard back-light, modem stack (CDMA vs UMTS). Also the difference
> in uerspace.

Agreed.  I was reluctant to even make the comparison for all those
reasons, but with the lack of real numbers, it was all I had to show a
very rough subjective guess, and at least show that with and without
opportunistic suspend, you're in the same ballpark.

>>> While this is not really a scientific comparison, it at least gives a
>>> rough idea.  If using opportunistic suspend was adding noticably
>>> better battery life, I think this would be a different discussion.
>>
>> Exactly. The point is, opportunistic suspend doesn't in fact add any
>> value compared to dynamic PM + CPUIdle. It only produces some false
>> impression that one can handle power management right without using
>> dynamic PM. And this false impression is the cause for many really
>> ugly designs (like, for instance, 15 minutes touchscreen inactivity
>> delay before forcibly shutting down the wireless, as it's done in
>> stock Android framework).
>>
>
> Opportunistic suspend is an extension to the current suspend model,
> not a replacement dynamic / run-time PM. If you can replace good old
> suspend then this would be a different story.
>
> As you mention, Droid uses opportunistic suspend + dynamic pm +
> cpuidle + freq. So I decided to do some measurements on a Droid using
> our 2.9.32 kernel
> (http://android.git.kernel.org/?p=kernel/omap.git;a=summary). For a
> little better apples to apples comparison.

Excellent.  Thanks for some real numbers.

(btw, sure would be nice to have the basic droid board files in mainline. ;)

> Droid (idle system, airplane mode, screen off, 3 min interval):
> measured average current
> - with opportunity suspend: 3.19mA
> - without opportunistic suspend: 3.5mA
>
> Stock userspace build, all I did was replace the kernel. We are
> hitting retention on idle as well as suspend for omap (instead of full
> off-mode).

[at risk of stating the obvious] Since both approaches hit the same
power states, if the system was truly idle, you'd expect the numbers
to be the same, right?  So what the difference shows is that the
system is not fully idle, IOW userspace and/or kernel wakeups are
cusing the difference.

It might also be instructive to see these numbers with a "noop"
userspace, like just booting into busybox init=/bin/sh (or the android
equivalent.)  That would show how much of that difference is due to
kernel idleness (or lack thereof.)

Even still, to me this all boils down to the lack of definition of the
problem and clear description of the solution

The fundamental problem is one of idleness.  What we want is the
system to be idle in order to hit the lowest power states.  We can't
get there because the system is not truly idle.

So, there are basically two solutions:

1) find and fix the problem spots so we can be idle more often
2) add a new definition of idle so we can be idle more often

Opporuntistic suspend takes the second approach where the new
definition of idle is "no suspend blockers held."

Of course, I clearly prefer the former, but it's also becoming clear
that since I'm the only one still whining about it, I must be too much
of an idealist to keep hoping for it.

Kevin



