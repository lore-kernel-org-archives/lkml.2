Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754976Ab1G2GYw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jul 2011 02:24:52 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:52308 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753847Ab1G2GYv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jul 2011 02:24:51 -0400
MIME-Version: 1.0
In-Reply-To: <20110729062158.GA8971@zhy>
References: <1311846203.3938.1555.camel@minggr.sh.intel.com>
	<20110729062158.GA8971@zhy>
Date: Fri, 29 Jul 2011 14:24:49 +0800
Message-ID: <CAM2zO=BhH0Npn_L1HubJwjr+XhRYJXfrLV9u50oba2-s5vjoEQ@mail.gmail.com>
Subject: Re: [PATCH] sched: Remove WAKEUP_PREEMPT feature check in entity_tick
From: Yong Zhang <yong.zhang0@gmail.com>
To: Lin Ming <ming.m.lin@intel.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, mingo@elte.hu,
        lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 29, 2011 at 2:21 PM, Yong Zhang <yong.zhang0@gmail.com> wrote:
> On Thu, Jul 28, 2011 at 05:43:23PM +0800, Lin Ming wrote:
>> Currently, entity_tick calls check_preempt_tick if WAKEUP_PREEMPT feature is
>> disabled. That's wrong. It should do that if the feature is enabled.
>
> Why is it wrong?
> check_preempt_wakeup() is used for wakeup.
>
>>
>> And actually the check is duplicate because check_preempt_tick will do
>> that. So just remove it from entity_tick.
>
> It's not exactly duplicated. entity_tick() will resched_task(*p)

s/entity_tick/check_preempt_tick

> if p's slice is over. So if there is an following wakeup(say X),
> then there is an opportunity for X to schedule quickly.
>
> Thanks,
> Yong
>
>>
>> Signed-off-by: Lin Ming <ming.m.lin@intel.com>
>> ---
>>  kernel/sched_fair.c |    2 +-
>>  1 files changed, 1 insertions(+), 1 deletions(-)
>>
>> diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
>> index bc8ee99..af2fe9d 100644
>> --- a/kernel/sched_fair.c
>> +++ b/kernel/sched_fair.c
>> @@ -1233,7 +1233,7 @@ entity_tick(struct cfs_rq *cfs_rq, struct sched_entity *curr, int queued)
>>               return;
>>  #endif
>>
>> -     if (cfs_rq->nr_running > 1 || !sched_feat(WAKEUP_PREEMPT))
>> +     if (cfs_rq->nr_running > 1)
>>               check_preempt_tick(cfs_rq, curr);
>>  }
>>
>> --
>> 1.7.2.3
>>
>>
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/
>
> --
> Only stand for myself
>



-- 
Only stand for myself
