Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755245Ab2EHNdI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 09:33:08 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:37791 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754560Ab2EHNdH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 09:33:07 -0400
MIME-Version: 1.0
In-Reply-To: <1336396416.27020.44.camel@laptop>
References: <1334072733-2614-1-git-send-email-sasikanth.v19@gmail.com>
	<1336396416.27020.44.camel@laptop>
Date: Tue, 8 May 2012 19:03:06 +0530
Message-ID: <CAOJFanVzCxpSDcNw34bEg1U82emuCytUERhfqd4EdR16XxHVpA@mail.gmail.com>
Subject: Re: [PATCH] sched: Removed redundant set_current_state in "yield"
From: Sasikanth babu <sasikanth.v19@gmail.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@kernel.org>, Frank Rowand <frank.rowand@am.sony.com>,
        Paul Turner <pjt@google.com>, Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 7, 2012 at 6:43 PM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> On Tue, 2012-04-10 at 21:15 +0530, Sasikantha babu wrote:
>> Removed redundant setting current task state to TASK_RUNNING.
>>
>> During yield process will always remains in TASK_RUNNING state.
>
> Uhm, no, if you call yield() with !TASK_RUNNING you'll block and need a
> proper wakeup. That is, you can in fact abuse yield() as schedule().
With the current code even if we call yield with !TASK_RUNNING, we are
setting it
back to TASK_RUNNING in yield. is this the expected behavior?.

void __sched yield(void)
 {
        set_current_state(TASK_RUNNING);
        sys_sched_yield();
 }

In the code I could not find yield was called with  !TASK_RUNNING.
>
>> Process state of  yielded process will not change from TASK_RUNNING, so it does not
>> make sense setting the process state again to TASK_RUNNING (TASK_RUNNING -> TASK_RUNNING).
>
> No real objections, but have you tested/verified that all users are
> indeed unaffected by this change?
 I did minimal testing on changes (Could not able to test all
scenarios, suggest me if there is anyway to test all cases) and
 verified none of the code path is going affected by this change.
>
>> Signed-off-by: Sasikantha babu <sasikanth.v19@gmail.com>
>> ---
>>  kernel/sched/core.c |    1 -
>>  1 files changed, 0 insertions(+), 1 deletions(-)
>>
>> diff --git a/kernel/sched/core.c b/kernel/sched/core.c
>> index 4603b9d..c2a357d 100644
>> --- a/kernel/sched/core.c
>> +++ b/kernel/sched/core.c
>> @@ -4624,7 +4624,6 @@ EXPORT_SYMBOL(__cond_resched_softirq);
>>   */
>>  void __sched yield(void)
>>  {
>> -     set_current_state(TASK_RUNNING);
>>       sys_sched_yield();
>>  }
>>  EXPORT_SYMBOL(yield);
>
>
>
