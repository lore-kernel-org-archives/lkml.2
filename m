Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754325Ab0H0LGt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Aug 2010 07:06:49 -0400
Received: from smarthost1.greenhost.nl ([195.190.28.78]:59667 "EHLO
	smarthost1.greenhost.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753088Ab0H0LGo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Aug 2010 07:06:44 -0400
X-Greylist: delayed 1135 seconds by postgrey-1.27 at vger.kernel.org; Fri, 27 Aug 2010 07:06:43 EDT
Message-ID: <c065aaeb33752e7fce8958c8501a5a15.squirrel@webmail.greenhost.nl>
In-Reply-To: <20100826180908.648103531@efficios.com>
References: <20100826180908.648103531@efficios.com>
Date: Fri, 27 Aug 2010 12:47:30 +0200 (CEST)
Subject: Re: [RFC PATCH 00/11] sched: CFS low-latency features
From: "Indan Zupancic" <indan@nul.nu>
To: "Mathieu Desnoyers" <mathieu.desnoyers@efficios.com>
Cc: "LKML" <linux-kernel@vger.kernel.org>,
        "Peter Zijlstra" <peterz@infradead.org>,
        "Linus Torvalds" <torvalds@linux-foundation.org>,
        "Andrew Morton" <akpm@linux-foundation.org>,
        "Ingo Molnar" <mingo@elte.hu>, "Steven Rostedt" <rostedt@goodmis.org>,
        "Thomas Gleixner" <tglx@linutronix.de>,
        "Mathieu Desnoyers" <mathieu.desnoyers@efficios.com>
User-Agent: SquirrelMail/1.4.17
MIME-Version: 1.0
Content-Type: text/plain;charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Priority: 3 (Normal)
Importance: Normal
X-Spam-Score: 0.0
X-Scan-Signature: 9b84bad32751a42de3aa9e7877f1ca86
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Thu, August 26, 2010 20:09, Mathieu Desnoyers wrote:
> Hi,
>
> Following the findings I presented a few months ago
> (http://lkml.org/lkml/2010/4/18/13) about CFS having large vruntime spread
> issues, Peter Zijlstra and I pursued the discussion and the implementation
> effort (my work on this is funded by Nokia). I recently put the result
> together
> and came up with this patchset, combining both his work and mine.
>
> With this patchset, I got the following results with wakeup-latency.c (a 10ms
> periodic timer), running periodic-fork.sh, Xorg, make -j3 and firefox (playing
> a
> youtube video), with Xorg moving terminal windows around, in parallel on a UP
> system (links to the test program source in the dyn min_vruntime patch). The
> Xorg interactivity is very good with the new features enabled, but was poor
> originally with the vanilla mainline scheduler. The 10ms timer delays are as
> follow:
>
>                          2.6.35.2 mainline*   with low-latency features**
> maximum latency:                34465.2 µs                    8261.4 µs
> average latency:                 6445.5 µs                     211.2 µs
> missed timer events:                yes                           no
>
> * 2.6.35.2 mainline test needs to run periodic-fork.sh for a few minutes first
>   to let it rip the spread apart.
>
> ** low-latency features:
>
> with the patchset applied and CONFIG_SCHED_DEBUG=y
> (with debugfs mounted in /sys/debugfs)
>
> for opt in DYN_MIN_VRUNTIME \
>         NO_FAIR_SLEEPERS FAIR_SLEEPERS_INTERACTIVE FAIR_SLEEPERS_TIMER \
>         INTERACTIVE TIMER \
>         INTERACTIVE_FORK_EXPEDITED TIMER_FORK_EXPEDITED;
> do echo $opt > /sys/debugfs/sched_features;
> done
>
> These patches are designed to allow individual enabling of each feature and to
> make sure that the object size of sched.o does not grow when the features are
> disabled on a CONFIG_SCHED_DEBUG=n kernel.

Please don't hide scheduler improvements behind obscure CONFIG_SCHED_DEBUG
options. If it doesn't make the scheduler better just don't merge it. If it
does then it should be enabled by default.

Thank you,

Indan


P.S. Tony Luck seems to be chopped of the CC list.


