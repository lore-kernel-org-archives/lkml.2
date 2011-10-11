Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754250Ab1JKJi7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Oct 2011 05:38:59 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:40951 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753107Ab1JKJi6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Oct 2011 05:38:58 -0400
MIME-Version: 1.0
In-Reply-To: <1318324399.14400.71.camel@laptop>
References: <CAKfTPtB3sLWq5fHOTrFg6vfHSKnz2i17oYx9Btr0u_tWV2bsjQ@mail.gmail.com>
	<CAP245DX8b45Nj5SAwtLivp_vMKpwfeUrqnR2sqjnVyqiRd61gg@mail.gmail.com>
	<1318319852.14400.65.camel@laptop>
	<CAKfTPtB_eXgggeEYmNsXkvL8NsoEoz_NJFgA4E5WtAm74F515Q@mail.gmail.com>
	<1318324399.14400.71.camel@laptop>
Date: Tue, 11 Oct 2011 15:08:57 +0530
Message-ID: <CAP245DXbj5nEB2ya5BWVYinvr2RQ+m7vmuHHT3fD1iVZZQ2C5g@mail.gmail.com>
Subject: Re: sched: ARM: arch_scale_freq_power
From: Amit Kucheria <amit.kucheria@linaro.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Vincent Guittot <vincent.guittot@linaro.org>, linux-kernel@vger.kernel.org,
        LAK <linux-arm-kernel@lists.infradead.org>,
        linaro-dev@lists.linaro.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 11, 2011 at 2:43 PM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> On Tue, 2011-10-11 at 10:51 +0200, Vincent Guittot wrote:
>> I have several goals. The 1st one is that I need to put more load on
>> some cpus when I have packages with different cpu frequency.
>
> That should be rather easy.
>
>> I also study if I can follow the real cpu frequency but it seems to be
>> not so easy.
>
> Why not?
>
>>  I have noticed that the cpu_power is updated periodical
>> except when we have a lot of newly_idle events.
>
> We can certainly fix that.
>
>> Then, I have some use cases which have several running tasks but a low
>> cpu load. In this case, the small tasks are spread on several cpu by
>> the load_balance whereas they could be easily handled by one cpu
>> without significant performance modification.
>
> That shouldn't be done using cpu_power, we have sched_smt_power_savings
> and sched_mc_power_savings for stuff like that.

AFAICT, sched_mc assume all cores to have the same capacity - which is
certainly true of the x86 architecture. But in ARM you can see hybrid
cores[1] designed using different fab technology, so that some cores
can run at 'n' GHz and some at 'm' GHz. The idea being that when there
isn't much to do (e.g periodic keep alives for messaging, email, etc.)
you don't wake up the higher power-consuming cores.

>From TFA[1],  "Sheeva was already capable of 1.2GHz, but the new
design can go up to 1.5GHz. But only two of the 628's Sheeva cores run
at the full 1.5GHz. The third one is down-clocked to 624MHz, and
interesting design choice that saves on power but adds some extra
utility. In a sense, the 628 could be called a 2.5-core design."

Are we mistaken in thinking that sched_mc can not currently handle
this usecase? How would we 'tune' sched_mc to do this w/o playing with
cpu_power?

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

What is wrong - the use case simulation using cyclictest? Can you
suggest better tools?

Regards,
/Amit

[1] http://arstechnica.com/gadgets/news/2010/09/marvells-tri-core-chip-has-near-ps3-level-graphics.ars
