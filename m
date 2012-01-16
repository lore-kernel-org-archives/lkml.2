Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754089Ab2APKfS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jan 2012 05:35:18 -0500
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:37635 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751841Ab2APKfQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jan 2012 05:35:16 -0500
Message-ID: <4F13FD45.4000804@linux.vnet.ibm.com>
Date: Mon, 16 Jan 2012 18:34:45 +0800
From: Michael Wang <wangyun@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.24) Gecko/20111108 Thunderbird/3.1.16
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] sched: Accelerate "pick_next_entity" under special condition
References: <4F13EFBE.1030002@linux.vnet.ibm.com> <1326707503.2442.219.camel@twins>
In-Reply-To: <1326707503.2442.219.camel@twins>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
x-cbid: 12011600-7014-0000-0000-0000006CC5F8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, peter

Thanks so much for your reply :)

On 01/16/2012 05:51 PM, Peter Zijlstra wrote:

> On Mon, 2012-01-16 at 17:37 +0800, Michael Wang wrote:
>> From: Michael Wang <wangyun@linux.vnet.ibm.com>
>>
>> We can avoid some useless operation in some special condition.
> 
> This is a pretty empty statement.
> 
>> For example:
>> If we have "cfs_rq->next" and it can be use, we just return it directly.
> 
> What it doesn't state is what it actually does, if it affects the common
> case and performance numbers (or a good reason for the lack thereof).
> 


Please help me to understand the logic, I think in the original code,
even if we have cfs_rq->next and wakeup_preempt_entity check passed, we
still need to do a lot of work (check cfs_rq->last for example) which
have no influence on result, will it be better if we skip them and just
do what really needed?

>> Signed-off-by: Michael Wang <wangyun@linux.vnet.ibm.com>
>> ---
>>  kernel/sched/fair.c |   28 +++++++++++++++++-----------
>>  1 files changed, 17 insertions(+), 11 deletions(-)
>>
>> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
>> index 84adb2d..9fc2c3c 100644
>> --- a/kernel/sched/fair.c
>> +++ b/kernel/sched/fair.c
>> @@ -1295,6 +1295,8 @@ set_next_entity(struct cfs_rq *cfs_rq, struct sched_entity *se)
>>  static int
>>  wakeup_preempt_entity(struct sched_entity *curr, struct sched_entity *se);
>>  
>> +#define ENTITY_PREEMPT_ALLOWED(prev,next)	(wakeup_preempt_entity(prev, next) < 1)
> 

> This is just uglification imo, its shouting and it doesn't actually win
> you much space.
> 


I see, sorry for the bad idea.

Best regards,
Michael Wang

