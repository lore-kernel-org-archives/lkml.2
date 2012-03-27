Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750784Ab2C0PVg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2012 11:21:36 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:46320 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750876Ab2C0PVe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2012 11:21:34 -0400
MIME-Version: 1.0
X-Originating-IP: [212.179.42.66]
In-Reply-To: <alpine.DEB.2.00.1203221117100.25011@router.home>
References: <1332338318-5958-1-git-send-email-fweisbec@gmail.com>
	<1332338318-5958-13-git-send-email-fweisbec@gmail.com>
	<alpine.DEB.2.00.1203210953220.20482@router.home>
	<CAOtvUMdkU92t0nj9OXsnzCenuOyjb12x6s11xR_GGJu1aJJ7GA@mail.gmail.com>
	<alpine.DEB.2.00.1203221117100.25011@router.home>
Date: Tue, 27 Mar 2012 17:21:34 +0200
Message-ID: <CAOtvUMeMhA_scQyJwDpfNZ7BipAKfLTqODqkn342mcxS_yL9OQ@mail.gmail.com>
Subject: Re: [PATCH 11/32] nohz/cpuset: Don't turn off the tick if rcu needs it
From: Gilad Ben-Yossef <gilad@benyossef.com>
To: Christoph Lameter <cl@linux.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, linaro-sched-sig@lists.linaro.org,
        Alessio Igor Bogani <abogani@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, Avi Kivity <avi@redhat.com>,
        Chris Metcalf <cmetcalf@tilera.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Geoff Levand <geoff@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Max Krasnyansky <maxk@qualcomm.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Sven-Thorsten Dietrich <thebigcorporation@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, Zen Lin <zen@openhuawei.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 22, 2012 at 6:18 PM, Christoph Lameter <cl@linux.com> wrote:
> On Thu, 22 Mar 2012, Gilad Ben-Yossef wrote:
>
>> > Is there any way for userspace to know that the tick is not off yet due to
>> > this? It would make sense for us to have busy loop in user space that
>> > waits until the OS has completed all processing if that avoids future
>> > latencies for the application.
>> >
>>
>> I previously suggested having the user register to receive a signal
>> when the tick
>> is turned off. Since the tick is always turned off the user task is
>> the current task
>> by design, *I think* you can simply mark the signal pending when you
>> turn the tick off.
>
> Ok that sounds good. You would define a new signal for this?
>

My gut instinct is to let the process register with a specific signal
(properly the RT range)
it wants to receive when the tick goes off and/or on.

> So we would startup the application. App will do all prep work (memory
> allocation, device setup etc etc) and then wait for the signal to be
> received. After that it would enter the low latency processing phase.
>
> Could we also get a signal if something disrupts the peace and switches
> the timer interrupt on again?
>

I think you'll have to since once you have the tick turned off there
is no guarantee that
it wont get turned on by a timer scheduling an task or an IPI.


-- 
Gilad Ben-Yossef
Chief Coffee Drinker
gilad@benyossef.com
Israel Cell: +972-52-8260388
US Cell: +1-973-8260388
http://benyossef.com

"If you take a class in large-scale robotics, can you end up in a
situation where the homework eats your dog?"
 -- Jean-Baptiste Queru
