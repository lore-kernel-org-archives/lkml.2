Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754302Ab1JKJkV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Oct 2011 05:40:21 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:63912 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753461Ab1JKJkU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Oct 2011 05:40:20 -0400
MIME-Version: 1.0
In-Reply-To: <1318324399.14400.71.camel@laptop>
References: <CAKfTPtB3sLWq5fHOTrFg6vfHSKnz2i17oYx9Btr0u_tWV2bsjQ@mail.gmail.com>
	<CAP245DX8b45Nj5SAwtLivp_vMKpwfeUrqnR2sqjnVyqiRd61gg@mail.gmail.com>
	<1318319852.14400.65.camel@laptop>
	<CAKfTPtB_eXgggeEYmNsXkvL8NsoEoz_NJFgA4E5WtAm74F515Q@mail.gmail.com>
	<1318324399.14400.71.camel@laptop>
Date: Tue, 11 Oct 2011 11:40:18 +0200
Message-ID: <CAKfTPtDzY4pORvWd3Qa6kqpNsspKN7iEskQ+7F5D=mAwQWoKNg@mail.gmail.com>
Subject: Re: sched: ARM: arch_scale_freq_power
From: Vincent Guittot <vincent.guittot@linaro.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Amit Kucheria <amit.kucheria@linaro.org>, linux-kernel@vger.kernel.org,
        LAK <linux-arm-kernel@lists.infradead.org>,
        linaro-dev@lists.linaro.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11 October 2011 11:13, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> On Tue, 2011-10-11 at 10:51 +0200, Vincent Guittot wrote:
>> I have several goals. The 1st one is that I need to put more load on
>> some cpus when I have packages with different cpu frequency.
>
> That should be rather easy.
>

I agree, I was mainly wondering If I should use a [1-1024] or a
[1024-xxxx] range and it seems that both can be used according : SMT
uses <1024 and x86 turbo mode uses >1024

>> I also study if I can follow the real cpu frequency but it seems to be
>> not so easy.
>
> Why not?
>

In fact, the problem is not really to follow the frequency but to be
sure that update_group_power is called often enough by load_balance.
The newly_idle event was also one main problem.

>>  I have noticed that the cpu_power is updated periodical
>> except when we have a lot of newly_idle events.
>
> We can certainly fix that.
>

That's a good news.

>> Then, I have some use cases which have several running tasks but a low
>> cpu load. In this case, the small tasks are spread on several cpu by
>> the load_balance whereas they could be easily handled by one cpu
>> without significant performance modification.
>
> That shouldn't be done using cpu_power, we have sched_smt_power_savings
> and sched_mc_power_savings for stuff like that.
>

sched_mc_power_saving works fine when we have more than 2 cpus but
can't apply on a dual core because it needs at least 2 sched_groups
and the nr_running of these sched_groups must be higher than 0 but
smaller than group_capacity which is 1 on a dual core system.

> Although I would really like to kill all those different
> sched_*_power_savings knobs and reduce it to one.
>
>> If the cpu_power is
>> higher than 1024, the cpu is no more seen out of capacity by the
>> load_balance as soon as a short process is running and teh main result
>> is that the small tasks will stay on the same cpu. This configuration
>> is mainly usefull for ARM dual core system when we want to power gate
>> one cpu. I use cyclictest to simulate such use case.
>
> Yeah, but that's wrong.

That's the only way I have found to gathers small task without any
relationship on one cpu. Do you know any better solution ?

>
>
Regards,
Vincent
