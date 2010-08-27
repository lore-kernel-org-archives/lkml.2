Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755047Ab0H0Rjd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Aug 2010 13:39:33 -0400
Received: from smtp-out.google.com ([216.239.44.51]:11276 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754861Ab0H0Rjb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Aug 2010 13:39:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=QnGKMhzxFL3kilbpN1uMTs6zeyx1Uilghi/5MY62BHRW6reAV+lPyoOL9T/3s0f7Z9
         tinPbFrs0C3UdgQCk/aw==
MIME-Version: 1.0
In-Reply-To: <AANLkTikg7Q_oOecNgVLPPTu3dOu3aO776f4y1bw410PV@mail.gmail.com>
References: <AANLkTimT4T-6dO=Uo05DexYf3exq=0SkZemHuB5aRP3Q@mail.gmail.com>
	<AANLkTim75Z-X--LDJX8MLYF8G=vPW_GniVFQrkL7QoAy@mail.gmail.com>
	<AANLkTikg7Q_oOecNgVLPPTu3dOu3aO776f4y1bw410PV@mail.gmail.com>
Date: Fri, 27 Aug 2010 10:39:27 -0700
Message-ID: <AANLkTi=CqtT5HE1K40ukKmVO2AN3O9551Qq7RQEx272y@mail.gmail.com>
Subject: Re: divide by zero bug in find_busiest_group
From: Venkatesh Pallipadi <venki@google.com>
To: Chetan Ahuja <chetan.ahuja@gmail.com>
Cc: linux-kernel@vger.kernel.org, Suresh Siddha <suresh.b.siddha@intel.com>,
        Peter Zijlstra <peterz@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 26, 2010 at 4:52 PM, Chetan Ahuja <chetan.ahuja@gmail.com> wrote:
> On Thu, Aug 26, 2010 at 12:19 PM, Venkatesh Pallipadi <venki@google.com> wrote:
>> On Wed, Aug 25, 2010 at 6:17 PM, Chetan Ahuja <chetan.ahuja@gmail.com> wrote:
>
>> I tried reproducing the problem with vanilla kernel and couldn't
>> reproduce it. May be your workload is triggering this some how?
>> Also, Suresh did recent fixes to rt_avg and this may not be a problem
>> after that. I Haven't looked at this case closely after that recent
>> change.
>>
>> Thanks,
>> Venki
>>
>
> Venkatesh,
>
>     Thanks for your detailed response. I admit complete ignorance of
> the actual logic of the complicated cpu_power computations (or indeed,
> any other part of the scheduler code). I'm just looking at it from the
> perspective of bug-hunting in an unfamiliar piece of code. I think the
> three ways we've so far identified the cpu_power can be zero so far
> (all three would be extremely low probability events admittedly) are
> warning signs that the code is trying to do  a bit too much. It seems
> to be rather difficult to prove  correctness of the math or the
> synchronization for my taste. Is there a clear and present use-case
> which driving all these complicated computations ?
>
>  For one thing, I don't understand the reason for recomputing
> cpu_power dynamically. How does cpu_power of a gorup (which I believe
> refers to the group of "hyper-threaded" cores on one physical core)
> change while inthe system is in operation ? Is this in support of
> hot-swappable CPU's or something ?
>
>  To be honest, for my use case, I'd  like to just disable the whole
> work-stealing stuff (referred to as load-balancing in the kernel).
> There seems to be no config option that isolates just the dynamic
> load-balancing parts (or is there ?) so maybe I'd just hack away the
> load-balancing functions by hand so as never to worry about those
> denominators again.
>

Chetan,

For the purpose of this bug (assuming you can run a modified kernel in
your environment),
you can add above change and/or add some printk's, WARN_ON_ONCE() to see whether
power is going negative-zero at any point. That will give some more
clue on what may be
happening here.

Thanks,
Venki
