Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752938Ab2KTBwU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 20:52:20 -0500
Received: from mail-vc0-f174.google.com ([209.85.220.174]:39026 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751252Ab2KTBwT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 20:52:19 -0500
MIME-Version: 1.0
In-Reply-To: <1353374226.6276.16.camel@gandalf.local.home>
References: <4FDD7AA8.6080601@gmail.com>
	<CAFTL4hy4SedXQ1Bc6o_1BHZ-7a8tbbvpUcFwp50hDbgNnv79zQ@mail.gmail.com>
	<CABVzNXqVdgTr1GNN6_yj-CZTDLPtP=Ok7r5TaDbRt2jpxHB-5Q@mail.gmail.com>
	<1353374226.6276.16.camel@gandalf.local.home>
Date: Tue, 20 Nov 2012 02:52:18 +0100
Message-ID: <CAFTL4hw6vWsHa5gqThUpWhC7MQUueXpze=Fyuvoyzy2t=zYrhA@mail.gmail.com>
Subject: Re: [PATCH] nohz/cpuset: Make a CPU stick with do_timer() duty in the
 presence of nohz cpusets
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Hakan Akkan <hakanakkan@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/11/20 Steven Rostedt <rostedt@goodmis.org>:
> On Mon, 2012-11-19 at 17:27 -0700, Hakan Akkan wrote:
>
>> >
>> > I suggest to rather define a tunable timekeeping duty CPU affinity in
>> > a cpumask file at /sys/devices/system/cpu/timekeeping and a toggle at
>> > /sys/devices/system/cpu/cpuX/timekeeping (like the online file). This
>> > way the user can decide whether adaptive nohz CPU can handle
>> > timekeeping or this must be forced to other CPUs in order to enforce
>> > isolation.
>>
>> Well, users want tickless CPUs because they don't want timekeeping
>> (or any other kernel activity for that matter) to run in there. So, I believe
>> having that "timekeeping affinity" stay in the regular CPUs is good enough.
>> Please let me know how users could utilize these control files to do anything
>> other than keeping the timekeeping out of adaptive nohz CPUs.
>
> I agree. If we already have some /sys cpumask that denotes which CPUs
> will be adaptive NO_HZ (or simply isolated) then just keep the tick from
> ever going on those CPUs. If all but one CPU is set for nohz, and that
> one CPU goes idle, it should still be the one doing the tick.

If you want isolation on your full dynticks CPU it's right. Now you
could have lower requirements, a different policy that rather enforce
energy saving.

But I realize we can integrate such granularity later if users request
it and take the behaviour you both describe as the default for now. So
let's take that direction.

Thanks.
