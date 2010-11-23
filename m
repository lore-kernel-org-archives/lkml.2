Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751008Ab0KWCFm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Nov 2010 21:05:42 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:33905 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750858Ab0KWCFl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Nov 2010 21:05:41 -0500
MIME-Version: 1.0
In-Reply-To: <20101122132306.245e0bcb@schatten.dmk.lab>
References: <1290218934-8544-1-git-send-email-john.stultz@linaro.org>
	<1290218934-8544-4-git-send-email-john.stultz@linaro.org>
	<1290250104.2118.4.camel@laptop>
	<20101122065129.072bba06@schatten.dmk.lab>
	<1290422639.2110.3.camel@laptop>
	<20101122132306.245e0bcb@schatten.dmk.lab>
Date: Mon, 22 Nov 2010 18:05:37 -0800
Message-ID: <AANLkTike-bR-fjakyxiFbWvER=BYdDnFSegjOcdsb1qt@mail.gmail.com>
Subject: Re: [PATCH 3/5] scheduler: cpuacct: Enable platform hooks to track
 cpuusage for CPU frequencies
From: Mike Chan <mike@android.com>
To: Florian Mickler <florian@mickler.org>
Cc: Peter Zijlstra <peterz@infradead.org>,
        John Stultz <john.stultz@linaro.org>,
        lkml <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 22, 2010 at 4:23 AM, Florian Mickler <florian@mickler.org> wrote:
> On Mon, 22 Nov 2010 11:43:59 +0100
> Peter Zijlstra <peterz@infradead.org> wrote:
>
>> On Mon, 2010-11-22 at 06:51 +0100, Florian Mickler wrote:
>> > On Sat, 20 Nov 2010 11:48:24 +0100
>> > Peter Zijlstra <peterz@infradead.org> wrote:
>> >
>> > > On Fri, 2010-11-19 at 18:08 -0800, John Stultz wrote:
>> > > > From: Mike Chan <mike@android.com>
>> > > >
>> > > > Introduce new platform callback hooks for cpuacct for tracking CPU frequencies
>> > > >
>> > > > Not all platforms / architectures have a set CPU_FREQ_TABLE defined
>> > > > for CPU transition speeds. In order to track time spent in at various
>> > > > CPU frequencies, we enable platform callbacks from cpuacct for this accounting.
>> > > >
>> > > > Architectures that support overclock boosting, or don't have pre-defined
>> > > > frequency tables can implement their own bucketing system that makes sense
>> > > > given their cpufreq scaling abilities.
>> > > >
>> > > > New file:
>> > > > cpuacct.cpufreq reports the CPU time (in nanoseconds) spent at each CPU
>> > > > frequency.
>> > >
>> > > I utterly detest all such accounting crap.. it adds ABI constraints it
>> > > add runtime overhead. etc..
>> > >
>> > > Can't you get the same information by using the various perf bits? If
>> > > you trace the cpufreq changes you can compute the time spend in each
>> > > power state, if you additionally trace the sched_switch you can compute
>> > > it for each task.
>> > >
>> > >
>> > This is probably used for "on-site" debugging of production systems.
>>
>> Dude, its from the _android_ tree... its cpufreq crud.. it must be some
>> crack induced power management scheme.
>>
>>
>
> :)
>
> what I wanted to get at, was that they probably need these stats
> aggregated somewhere neat and tidy and can not compute them on the fly
> recording massive amounts of data...
>
> I wonder why they didn't put this in the
> idle-driver.  I don't know.
>

This is useful for tracking cpu power per c-group. We split each
android application into its own c-group and track what cpu speeds and
how long the cpu spent for each one. Peter we've actually discussed
this before:
http://lkml.org/lkml/2010/5/6/301

These patches were discussed with Paul Menage and Balbir Singh back in
April, as well as on lmkl and the cpufreq mailing lists. These may or
may not be useful for mainline, I assume anyone wanting to track power
specific for c-groups would be interested. I'm open for different
implementations that can help achieve cpu power tracking per-cgroup if
this particular implementation is controversial, or if you just want
to help make Android's kernel better.

-- Mike

> Regards,
> Flo
>
>
