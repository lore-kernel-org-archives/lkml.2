Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755761Ab1CGLZ1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Mar 2011 06:25:27 -0500
Received: from mail-ew0-f46.google.com ([209.85.215.46]:61049 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751221Ab1CGLZR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Mar 2011 06:25:17 -0500
MIME-Version: 1.0
In-Reply-To: <1299192176.6376.47.camel@gandalf.stny.rr.com>
References: <AANLkTinbYWQxde2jTcAtyYQGvGgt2Lmtnph=voj=haXF@mail.gmail.com>
	<201103021157.08260.trenn@suse.de>
	<AANLkTi=dht7+bPrBqmt6shHefBxSB3yOUu4OcSvcd0am@mail.gmail.com>
	<201103022307.46694.trenn@suse.de>
	<1299192176.6376.47.camel@gandalf.stny.rr.com>
Date: Mon, 7 Mar 2011 13:25:15 +0200
Message-ID: <AANLkTi=VnpgjKdz1GBX801Uf3SHo-nOFEn1fSq9nVYct@mail.gmail.com>
Subject: Re: [PATCH V6 0/2] tracing, perf: cpu hotplug trace events
From: Amit Kucheria <amit.kucheria@linaro.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Thomas Renninger <trenn@suse.de>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
        linux-hotplug@vger.kernel.org, fweisbec@gmail.com,
        rusty@rustcorp.com.au, tglx@linutronix.de,
        Arjan van de Ven <arjan@infradead.org>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-perf-users@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 4, 2011 at 12:42 AM, Steven Rostedt <rostedt@goodmis.org> wrote:
> On Wed, 2011-03-02 at 23:07 +0100, Thomas Renninger wrote:
>
>> I doubt cpu offlining is the proper instrument to save power.
>> You want to prevent the CPU of being used by ripping it out from scheduler decisions and
>> make sure it doesn't get interrupts by offlining. But the (latency) price is high.
>
> I could imagine that a server could use this for power savings to take
> down all but 1 CPU on off hours. When it knows its not going to get much
> action but still needs to remain online. Then just before peak times
> begin, online the other CPUs.
>
> But anything more dynamic than that, I can't see it really worth it. As
> the latency to bring the other CPU online, may miss a peak when it was
> needed.
>

ARM SoCs require both cores to be idle to hit the really low power
retention/off states. Hoping for both cores to go idle at the same
instant causes several low power opportunities to be lost. Hence the
experiments with hotplug to improve the idle characteristics of the
system. On our wiki page[1], you can see some results under "Idle
improvement" section.

But sched_mc does seem like a more appropriate way to help nudge all
the workload onto a single core.

Regards,
Amit


[1] https://wiki.linaro.org/WorkingGroups/PowerManagement/Doc/Hotplug
