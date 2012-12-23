Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751973Ab2LWMAg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Dec 2012 07:00:36 -0500
Received: from mail-ob0-f172.google.com ([209.85.214.172]:34542 "EHLO
	mail-ob0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751154Ab2LWMAe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Dec 2012 07:00:34 -0500
MIME-Version: 1.0
In-Reply-To: <87a9t8f2ic.fsf@sejong.aot.lge.com>
References: <1355127754-8444-1-git-send-email-alex.shi@intel.com>
	<1355127754-8444-7-git-send-email-alex.shi@intel.com>
	<87a9t8f2ic.fsf@sejong.aot.lge.com>
Date: Sun, 23 Dec 2012 20:00:33 +0800
Message-ID: <CAGjg+kEKE3T0h8Z1YHourT3iVW_nb8FkAUZ9jnOE8Urxo2KpxQ@mail.gmail.com>
Subject: Re: [PATCH 06/18] sched: set initial load avg of new forked task as
 its load weight
From: Alex Shi <lkml.alex@gmail.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Alex Shi <alex.shi@intel.com>, rob@landley.net, mingo@redhat.com,
        peterz@infradead.org, gregkh@linuxfoundation.org,
        andre.przywara@amd.com, rjw@sisk.pl, paul.gortmaker@windriver.com,
        akpm@linux-foundation.org, paulmck@linux.vnet.ibm.com,
        linux-kernel@vger.kernel.org, pjt@google.com,
        vincent.guittot@linaro.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>       update_curr(cfs_rq);
>>       account_entity_enqueue(cfs_rq, se);
>> -     enqueue_entity_load_avg(cfs_rq, se, flags & ENQUEUE_WAKEUP);
>> +     enqueue_entity_load_avg(cfs_rq, se, flags &
>> +                             (ENQUEUE_WAKEUP | ENQUEUE_NEWTASK));
>
> It seems that just passing 'flags' is enough.

Uh, Yes, it's true. will remove this.
>
>>
>>       if (flags & ENQUEUE_WAKEUP) {
>>               place_entity(cfs_rq, se, 0);
>> @@ -2586,6 +2594,7 @@ enqueue_task_fair(struct rq *rq, struct task_struct *p, int flags)
>>               cfs_rq->h_nr_running++;
>>
>>               flags = ENQUEUE_WAKEUP;
>> +             flags &= ~ENQUEUE_NEWTASK;
>
> Why is this needed?

Uh. not needed, will remove this too. Thanks a lot!

-- 
Thanks
    Alex
