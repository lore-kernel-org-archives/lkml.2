Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932597Ab0HDGuc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 02:50:32 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:58029 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756438Ab0HDGua convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 02:50:30 -0400
MIME-Version: 1.0
In-Reply-To: <20100804062804.GA43413@dspnet.fr>
References: <alpine.DEB.2.00.1008022121430.6545@asgard.lang.hm>
	<AANLkTikhcYzNp8CPp8cqrV7Ey5CLMWu1sJTNxUtEi2as@mail.gmail.com>
	<alpine.DEB.2.00.1008022203470.6545@asgard.lang.hm>
	<AANLkTinFT5jq4nUhUpzS5S4TVDQGj0S7RtRgxNhsz2UF@mail.gmail.com>
	<alpine.DEB.2.00.1008031611100.6545@asgard.lang.hm>
	<20100804001015.GJ2407@linux.vnet.ibm.com>
	<alpine.DEB.2.00.1008031723530.6545@asgard.lang.hm>
	<AANLkTinjH0C0bSK=Y2wKASnbJFsR2BN303xBXkaHbmRC@mail.gmail.com>
	<20100804045813.GA33951@dspnet.fr>
	<AANLkTi=pwyidtK7aebRwZ+SsJCSS-6t=6cFffdvcKKnx@mail.gmail.com>
	<20100804062804.GA43413@dspnet.fr>
Date: Tue, 3 Aug 2010 23:50:29 -0700
Message-ID: <AANLkTi=xycL4K6xMbYBvyfnqmNfPKyqGanHdVHWGpty9@mail.gmail.com>
Subject: Re: Attempted summary of suspend-blockers LKML thread
From: =?ISO-8859-1?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>
To: Olivier Galibert <galibert@pobox.com>
Cc: david@lang.hm, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Arjan van de Ven <arjan@infradead.org>, "Ted Ts'o" <tytso@mit.edu>,
        linux-pm@lists.linux-foundation.org,
        linux-kernel <linux-kernel@vger.kernel.org>, mjg59@srcf.ucam.org,
        pavel@ucw.cz, florian@mickler.org, rjw@sisk.pl,
        stern@rowland.harvard.edu, swetland@google.com, peterz@infradead.org,
        tglx@linutronix.de, alan@lxorguk.ukuu.org.uk
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/8/3 Olivier Galibert <galibert@pobox.com>:
> On Tue, Aug 03, 2010 at 11:03:15PM -0700, Arve Hjønnevåg wrote:
>> 2010/8/3 Olivier Galibert <galibert@pobox.com>:
>> > On Tue, Aug 03, 2010 at 08:39:22PM -0700, Arve Hjønnevåg wrote:
>> >> If you just program the alarm you will wake up see that the monotonic
>> >> clock has not advanced and set the alarm another n seconds into the
>> >> future. Or are proposing that suspend should be changed to keep the
>> >> monotonic clock running?
>> >
>> > You're supposed to fix the clock after you wake up.  That's part of
>> > the cost of going suspend.
>>
>> I'm not sure what you are referring to. The generic Linux timekeeping
>> code makes sure the monotonic clock stops while the system is
>> suspended regardless of what values the (hardware specific)
>> clocksource returns.
>
> That just means the android-like suspend should not act in that
> specific area the same as the generic suspend to ram.  Which is not

Huh? Android uses the generic suspend code.

> entirely surprising.  In any case, it's not "keep the monotonic clock
> running", which would cost power.  It's fix it up afterwards, using
> the same means you already do but perhaps at a higher level currently.
> People don't want to see the wrong time of the day just because the
> phone went to suspend.  Laptop STR is different in perception because

The monotonic clock is not the same as the realtime clock which is
used for time of day.

> it shuts down things people don't want to see shutdown just by being
> idle, namely wifi connectivity.
>
> If your next polling timer is in half an hour and the screen/touchpad
> are off, you want to go as low in power as possible until then, and
> that's the deepest level of idle you can find that responds to alarms
> which may happen to be called suspend.  But from a user point of view,

Calling the deepest idle state suspend is just confusing. Linux
suspend has a different api than idle. In suspend every driver that
has a suspend hook is notified. Also, once cpu can be idle while
another cpu is running. Suspend is a system wide.

> it's just another idle level.  And from a power management code/policy
> decisions point of view, it should be the same.
>


-- 
Arve Hjønnevåg
