Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932526Ab2FUJX5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2012 05:23:57 -0400
Received: from e28smtp06.in.ibm.com ([122.248.162.6]:46417 "EHLO
	e28smtp06.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759128Ab2FUJX4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2012 05:23:56 -0400
Message-ID: <4FE2E81C.2040402@linux.vnet.ibm.com>
Date: Thu, 21 Jun 2012 17:23:40 +0800
From: Michael Wang <wangyun@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: mingo@kernel.org, pjt@google.com, venki@google.com, efault@gmx.de,
        rostedt@goodmis.org, glommer@parallels.com,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH 2/4] sched: Push put_prev_task() into pick_next_task()
References: <20120614132902.800827488@chello.nl> <20120614133212.690691207@chello.nl> <4FE2CEB0.7080200@linux.vnet.ibm.com> <1340268104.21745.159.camel@twins>
In-Reply-To: <1340268104.21745.159.camel@twins>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
x-cbid: 12062109-9574-0000-0000-0000033FB52D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/21/2012 04:41 PM, Peter Zijlstra wrote:

> On Thu, 2012-06-21 at 15:35 +0800, Michael Wang wrote:
>>> +pick_next_task_fair(struct rq *rq, struct task_struct *prev)
>>>  {
>>>  	struct task_struct *p;
>>>  	struct cfs_rq *cfs_rq = &rq->cfs;
>>> @@ -2999,6 +3000,9 @@ static struct task_struct *pick_next_tas
>>>  	if (!cfs_rq->nr_running)
>>>  		return NULL;
>>>
>>> +	if (prev)
>>> +		prev->sched_class->put_prev_task(rq, prev);
>>> +
>>>  	do {
>>>  		se = pick_next_entity(cfs_rq);
>>>  		set_next_entity(cfs_rq, se);
>>> --- a/kernel/sched/idle_task.c
>>> +++ b/kernel/sched/idle_task.c
>>> @@ -22,8 +22,12 @@ static void check_preempt_curr_idle(stru
>>>  	resched_task(rq->idle);
>>>  }
>>
>> Will it cause trouble when the last task on cfs_rq was dequeued before
>> been putted?
>>
>> The cfs_rq->nr_running will be 0 and we will miss the chance to put
>> prev, will we?
> 
> pick_next_task_idle() will then do the put, no?

Oh, that's right, I see.

> 


