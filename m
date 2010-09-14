Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754336Ab0INRF5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Sep 2010 13:05:57 -0400
Received: from smtp-out.google.com ([216.239.44.51]:48295 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752798Ab0INRF4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Sep 2010 13:05:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=MChgl0VQygyVMO5NCV/xhEiClxsPbehFKA6HR8sREpQyF4/HyXWPyNE9yJFSn00895
         S5133SJz2RUiWQgYDUsA==
MIME-Version: 1.0
In-Reply-To: <1284197541.2251.23.camel@laptop>
References: <1284167957-3675-1-git-send-email-venki@google.com>
	<1284197541.2251.23.camel@laptop>
Date: Tue, 14 Sep 2010 10:05:52 -0700
Message-ID: <AANLkTimB04126K8nAh3FTNVv2vY0XXncK3Y+RyB-nGi0@mail.gmail.com>
Subject: Re: [PATCH] sched: Increment cache_nice_tries only on periodic lb
From: Venkatesh Pallipadi <venki@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Mike Galbraith <efault@gmx.de>, Gregory Haskins <ghaskins@novell.com>
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 11, 2010 at 2:32 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Fri, 2010-09-10 at 18:19 -0700, Venkatesh Pallipadi wrote:
>> scheduler uses cache_nice_tries as an indicator to do cache_hot and active
>> load balance, when normal load balance fails. Currently, this value is changed
>> on any failed load balance attempt. That ends up being not so nice to workloads
>> that enter/exit idle often, as they do more frequent new_idle balance and
>> that pretty soon results in cache hot tasks being pulled in.
>>
>> Making the cache_nice_tries ignore failed new_idle balance seems to make
>> better sense. With that only the failed load balance in periodic load balance
>> gets accounted and the rate of accumulation of cache_nice_tries will not
>> depend on idle entry/exit (short running sleep-wakeup kind of tasks). This
>> reduces movement of cache_hot tasks.
>
> Seems to make sense..
>
> I've also wondered if it would make sense to restore 0437e109e (sched:
> zap the migration init / cache-hot balancing code), esp because what the
> comment says isn't actually true anymore, we don't use the tree for
> load-balancing.
>
> But even if we were, the left size of the tree isn't the cold side, nor
> would I guess the right side be.. tricky stuff that.
>
> I know Gregory Haskins has played with restoring it, and I think he
> found some benefit from it, although he didn't pursue it, it might be
> worth seeing if it does for your workloads.
>

Yes. We often talk about that boot time migration overhead
calculations revert here, especially with bigger caches and increased
levels of domain hierarchy. I guess, at some point one size fits all
value will not work and we will need some change like what we used to
have. I did a quick resurrect of that patch and I did not see any
significant benefit (no upside no downside) with this particular
workload. I will keep an eye on this with different workloads and
platforms.

Thanks,
Venki
