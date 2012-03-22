Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754728Ab2CVHiV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2012 03:38:21 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:57751 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751533Ab2CVHiU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2012 03:38:20 -0400
MIME-Version: 1.0
X-Originating-IP: [212.179.42.66]
In-Reply-To: <alpine.DEB.2.00.1203210953220.20482@router.home>
References: <1332338318-5958-1-git-send-email-fweisbec@gmail.com>
	<1332338318-5958-13-git-send-email-fweisbec@gmail.com>
	<alpine.DEB.2.00.1203210953220.20482@router.home>
Date: Thu, 22 Mar 2012 09:38:19 +0200
Message-ID: <CAOtvUMdkU92t0nj9OXsnzCenuOyjb12x6s11xR_GGJu1aJJ7GA@mail.gmail.com>
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

On Wed, Mar 21, 2012 at 4:54 PM, Christoph Lameter <cl@linux.com> wrote:
> On Wed, 21 Mar 2012, Frederic Weisbecker wrote:
>
>> If RCU is waiting for the current CPU to complete a grace
>> period, don't turn off the tick. Unlike dynctik-idle, we
>> are not necessarily going to enter into rcu extended quiescent
>> state, so we may need to keep the tick to note current CPU's
>> quiescent states.
>
> Is there any way for userspace to know that the tick is not off yet due to
> this? It would make sense for us to have busy loop in user space that
> waits until the OS has completed all processing if that avoids future
> latencies for the application.
>

I previously suggested having the user register to receive a signal
when the tick
is turned off. Since the tick is always turned off the user task is
the current task
by design, *I think* you can simply mark the signal pending when you
turn the tick off.

The user would register a signal handler to set a flag when it is
called and then busy
loop waiting for a flag to clear.

Checking this approach is on my todo list, but alas I had no progress
with it yet :-)

Gilad



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
