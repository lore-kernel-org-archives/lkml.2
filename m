Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760593Ab2ESPFV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 May 2012 11:05:21 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:48205 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754376Ab2ESPFG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 May 2012 11:05:06 -0400
MIME-Version: 1.0
In-Reply-To: <1337083082.27020.151.camel@laptop>
References: <CAKfTPtDSDAOAdv0GTDswZeRM7TmACrjok+5kddSaQpvy6_6xWw@mail.gmail.com>
	<CAKfTPtCfiY7A29+e50F+6awd8BjNJjg4=uNN4ReZfdS_4FbpkA@mail.gmail.com>
	<CANQmPXj_81NBBrTYCkhUO1k1i4WVu0iHwY1_10wDVOFWCSkvsw@mail.gmail.com>
	<CAKfTPtBhPpQyr1qugbMzq2nENh+zBT+zx_nWQpQ9NPbF=+ppcQ@mail.gmail.com>
	<833A8DB8-1AB4-45E4-8D44-14A0D782807D@gmail.com>
	<1337077714.27694.21.camel@twins>
	<9093E8BA-80E4-4113-B036-0259E5FB44F1@gmail.com>
	<1337083082.27020.151.camel@laptop>
Date: Sat, 19 May 2012 22:58:32 +0800
Message-ID: <CAJRGBZzriRQMO9Mutk+VzrwKDdjFTBw7v2CbXseyKvshxXhxKA@mail.gmail.com>
Subject: Re: Plumbers: Tweaking scheduler policy micro-conf RFP
From: Luming Yu <luming.yu@gmail.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Pantelis Antoniou <pantelis.antoniou@gmail.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        mou Chen <hi3766691@gmail.com>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@kernel.org>, torvalds@linux-foundation.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 15, 2012 at 7:58 PM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> On Tue, 2012-05-15 at 14:35 +0300, Pantelis Antoniou wrote:

>> Power: Now that's a tricky one, we can't measure power directly, it's a
>> function of the cpu load we run in a period of time, along with any
>> history of the cstates & pstates of that period. How can we collect
>> information about that? Also we to take into account peripheral device
>> power to that; GPUs are particularly power hungry.
>
> Intel provides some measure of CPU power drain on recent chips (iirc),
> but yeah that doesn't include GPUs and other peripherals iirc.
>
>> Thermal management: How to distribute load to the processors in such
>> a way that the temperature of the die doesn't increase too much that
>> we have to either go to a lower OPP or shut down the core all-together.
>> This is in direct conflict with throughput since we'd have better performance
>> if we could keep the same warmed-up cpu going.
>
> Core-hopping.. yay! We have the whole sensors framework that provides an
> interface to such hardware, the question is, do chips have enough
> sensors spread on them to be useful?
>
>> Memory I/O: Some workloads are memory bandwidth hungry but do not need
>> much CPU power. In the case of asymmetric cores it would make sense to move
>> the memory bandwidth hog to a lower performance CPU without any impact.
>> Probably need to use some kind of performance counter for that; not going
>> to be very generic.
>
> You're assuming the slower cores have the same memory bandwidth, isn't
> that a dangerous assumption?
>
> Anyway, so the 'problem' with using PMCs from within the scheduler is
> that, 1) they're ass backwards slow on some chips (x86 anyone?) 2) some
> userspace gets 'upset' if they can't get at all of them.
>
> So it has to be optional at best, and I hate knobs :-) Also, the more
> information you're going to feed this load-balancer thing, the harder
> all that becomes, you don't want to do the full nm! m-dimensional bin
> fit.. :-)
>

Just curious if load-balance doesn't necessarily mean power/thermal balance,
or memory balance, then where to hack to satisfy such needs when it became
critical. e.g. People may want to have fine granularity usage plan to
control over
how processors gets used in day-to-day life. e.g. People may want to idle half
processors for few hours,while we want the request done in a way that it create
minimal impact on the quality of service provided by the system, which means:
1. we need to choose best cpus to idle. 2. soft-offline-cpu is not
right solution,
3. when really needed, get them back to service as fast as possible.

So my question is if any existing scheduler can help me do this?
Yes, I need knobs or interfaces :-)  that could be used by another
driver which could be
thermal or power related.  if there isn't, I would be very interested
to help create one.

thanks.
/l
