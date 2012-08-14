Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757352Ab2HNS4v (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2012 14:56:51 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:63400 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757325Ab2HNS4u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2012 14:56:50 -0400
MIME-Version: 1.0
In-Reply-To: <20120814183454.GV25632@google.com>
References: <1344967816-1136-1-git-send-email-js1304@gmail.com>
	<1344967816-1136-3-git-send-email-js1304@gmail.com>
	<20120814183454.GV25632@google.com>
Date: Wed, 15 Aug 2012 03:56:49 +0900
Message-ID: <CAAmzW4O7we-Rj0yNAjzyQt=MhPXPL4oehwUsvOtqkcoSL=b_gQ@mail.gmail.com>
Subject: Re: [PATCH v2 2/6] workqueue: correct req_cpu in trace_workqueue_queue_work()
From: JoonSoo Kim <js1304@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/8/15 Tejun Heo <tj@kernel.org>:
> Hello,
>
> On Wed, Aug 15, 2012 at 03:10:12AM +0900, Joonsoo Kim wrote:
>> When we do tracing workqueue_queue_work(), it records requested cpu.
>> But, if !(@wq->flag & WQ_UNBOUND) and @cpu is WORK_CPU_UNBOUND,
>> requested cpu is changed as local cpu.
>> In case of @wq->flag & WQ_UNBOUND, above change is not occured,
>> therefore it is reasonable to correct it.
>>
>> Use temporary local variable for storing local cpu.
>>
>> Signed-off-by: Joonsoo Kim <js1304@gmail.com>
>>
>> diff --git a/kernel/workqueue.c b/kernel/workqueue.c
>> index 49d8f4a..6a17ab0 100644
>> --- a/kernel/workqueue.c
>> +++ b/kernel/workqueue.c
>> @@ -1198,6 +1198,7 @@ static void __queue_work(unsigned int cpu, struct workqueue_struct *wq,
>>       struct cpu_workqueue_struct *cwq;
>>       struct list_head *worklist;
>>       unsigned int work_flags;
>> +     unsigned int lcpu;
>
> @lcpu in __queue_delayed_work() stands for "last cpu", which is kinda
> weird here.  Maybe just add "unsigned int req_cpu = cpu" at the top of
> the function and use it for the TP?

Okay! It looks better.
I will re-send v3 of two patches commented from u.
Thanks!
