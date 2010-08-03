Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757935Ab0HCWrk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 18:47:40 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:61720 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751453Ab0HCWrj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 18:47:39 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.1008022203470.6545@asgard.lang.hm>
References: <20100731175841.GA9367@linux.vnet.ibm.com>
	<20100731215214.2543c07e@infradead.org>
	<20100801054816.GI2470@linux.vnet.ibm.com>
	<20100731230101.7cc1d8c7@infradead.org>
	<20100801191228.GL2470@linux.vnet.ibm.com>
	<20100801204026.GH31324@thunk.org>
	<20100802030304.GU2470@linux.vnet.ibm.com>
	<20100801210548.23f77ff6@infradead.org>
	<alpine.DEB.2.00.1008012153300.25170@asgard.lang.hm>
	<20100802140933.GB2405@linux.vnet.ibm.com>
	<alpine.DEB.2.00.1008021627290.29820@asgard.lang.hm>
	<AANLkTi=1kBuyPS_P+eNLcnRu1mJH6BzpzQW_sENZuL1L@mail.gmail.com>
	<alpine.DEB.2.00.1008022121430.6545@asgard.lang.hm>
	<AANLkTikhcYzNp8CPp8cqrV7Ey5CLMWu1sJTNxUtEi2as@mail.gmail.com>
	<alpine.DEB.2.00.1008022203470.6545@asgard.lang.hm>
Date: Tue, 3 Aug 2010 15:47:38 -0700
Message-ID: <AANLkTinFT5jq4nUhUpzS5S4TVDQGj0S7RtRgxNhsz2UF@mail.gmail.com>
Subject: Re: Attempted summary of suspend-blockers LKML thread
From: =?ISO-8859-1?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>
To: david@lang.hm
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Arjan van de Ven <arjan@infradead.org>, "Ted Ts'o" <tytso@mit.edu>,
        linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        mjg59@srcf.ucam.org, pavel@ucw.cz, florian@mickler.org, rjw@sisk.pl,
        stern@rowland.harvard.edu, swetland@google.com, peterz@infradead.org,
        tglx@linutronix.de, alan@lxorguk.ukuu.org.uk
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/8/2  <david@lang.hm>:
> On Mon, 2 Aug 2010, Arve Hj?nnev?g wrote:
>
>> 2010/8/2  <david@lang.hm>:
>>>
>>> On Mon, 2 Aug 2010, Arve Hj?nnev?g wrote:
>>>
>>>> On Mon, Aug 2, 2010 at 5:08 PM,  <david@lang.hm> wrote:
>>>>>
>>>>> On Mon, 2 Aug 2010, Paul E. McKenney wrote:
>>>>>
>>>>>
>>>>> you are close, but I think what I'm proposing is actually simpler
>>>>> (assuming
>>>>> that the scheduler can be configured to generate the appropriate stats)
>>>>>
>>>>> my thought was not to move applications between cgroups as they
>>>>> aquire/release the suspend-block lock, bur rather to say that any
>>>>> application that you would trust to get the suspend-block lock should
>>>>> be
>>>>> in
>>>>> cgroup A while all other applications are in cgroup B
>>>>>
>>>>> when you are deciding if the system shoudl go to sleep because it is
>>>>> idle,
>>>>> ignore the activity of all applications in cgroup B
>>>>>
>>>>> if cgroup A applications are busy, the system is not idle and should
>>>>> not
>>>>> suspend.
>>>>>
>>>>
>>>> Triggering suspend from idle has been suggested before. However, idle
>>>> is not a signal that it is safe to suspend since timers stop in
>>>> suspend (or the code could temporarily be waiting on a non-wakeup
>>>> interrupt). If you add suspend blockers or wakelocks to prevent
>>>> suspend while events you care about are pending, then it does not make
>>>> a lot of sense to prevent suspend just because the cpu is not idle.
>>>
>>> isn't this a matter of making the suspend decision look at what timers
>>> have
>>> been set to expire in the near future and/or tweaking how long the system
>>> needs to be idle before going to sleep?
>>>
>>
>> You are describing low power idle modes, not suspend. Most timers stop
>> in suspend, so a timer set 10 seconds from now when entering suspend
>> will go off 10 seconds after resume so it should have no impact on how
>> long you decide to stay in suspend.
>
> so what is the fundamental difference between deciding to go into low-power
> idle modes to wake up back up on a given point in the future and deciding
> that you are going to be idle for so long that you may as well suspend until
> there is user input?
>

Low power idle modes are supposed to be transparent. Suspend stops the
monotonic clock, ignores ready threads and switches over to a separate
set of wakeup events/interrupts. We don't suspend until there is user
input, we suspend until there is a wakeup event (user-input, incoming
network data/phone-calls, alarms etc..).

-- 
Arve Hjønnevåg
