Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752602Ab2FMB52 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2012 21:57:28 -0400
Received: from mga02.intel.com ([134.134.136.20]:56664 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751460Ab2FMB51 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2012 21:57:27 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="156863655"
Message-ID: <4FD7F385.1090303@intel.com>
Date: Wed, 13 Jun 2012 09:57:25 +0800
From: "Yan, Zheng" <zheng.z.yan@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120605 Thunderbird/13.0
MIME-Version: 1.0
To: Stephane Eranian <eranian@google.com>
CC: a.p.zijlstra@chello.nl, mingo@elte.hu, jolsa@redhat.com,
        andi@firstfloor.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH V5 03/13] perf: Allow pmu to choose cpu on which to install
 event
References: <1339479468-3815-1-git-send-email-zheng.z.yan@intel.com> <1339479468-3815-4-git-send-email-zheng.z.yan@intel.com> <CABPqkBRepH-=j3Y9qJ1kXTkTv3_p0wC=Kzu+q=7rdxwk8vxk6A@mail.gmail.com>
In-Reply-To: <CABPqkBRepH-=j3Y9qJ1kXTkTv3_p0wC=Kzu+q=7rdxwk8vxk6A@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/12/2012 06:17 PM, Stephane Eranian wrote:
> On Tue, Jun 12, 2012 at 7:37 AM, Yan, Zheng <zheng.z.yan@intel.com> wrote:
>> From: "Yan, Zheng" <zheng.z.yan@intel.com>
>>
>> Allow the pmu->event_init callback to change event->cpu, so pmu can
>> choose cpu on which to install event.
>>
> So now, the user can say perf record -e xxxx -C 1 -a and then get nothing
> out of perf report -C1 because under the cover the kernel has swapped
> it for another CPU?

This change is for uncore, it does not support 'perf report'.

Regards
Yan, Zheng
> 
>> Signed-off-by: Zheng Yan <zheng.z.yan@intel.com>
>> ---
>>  kernel/events/core.c |    8 ++++----
>>  1 file changed, 4 insertions(+), 4 deletions(-)
>>
>> diff --git a/kernel/events/core.c b/kernel/events/core.c
>> index d71a2d6..2c05027 100644
>> --- a/kernel/events/core.c
>> +++ b/kernel/events/core.c
>> @@ -6302,7 +6302,7 @@ SYSCALL_DEFINE5(perf_event_open,
>>        /*
>>         * Get the target context (task or percpu):
>>         */
>> -       ctx = find_get_context(pmu, task, cpu);
>> +       ctx = find_get_context(pmu, task, event->cpu);
>>        if (IS_ERR(ctx)) {
>>                err = PTR_ERR(ctx);
>>                goto err_alloc;
>> @@ -6375,16 +6375,16 @@ SYSCALL_DEFINE5(perf_event_open,
>>        mutex_lock(&ctx->mutex);
>>
>>        if (move_group) {
>> -               perf_install_in_context(ctx, group_leader, cpu);
>> +               perf_install_in_context(ctx, group_leader, event->cpu);
>>                get_ctx(ctx);
>>                list_for_each_entry(sibling, &group_leader->sibling_list,
>>                                    group_entry) {
>> -                       perf_install_in_context(ctx, sibling, cpu);
>> +                       perf_install_in_context(ctx, sibling, event->cpu);
>>                        get_ctx(ctx);
>>                }
>>        }
>>
>> -       perf_install_in_context(ctx, event, cpu);
>> +       perf_install_in_context(ctx, event, event->cpu);
>>        ++ctx->generation;
>>        perf_unpin_context(ctx);
>>        mutex_unlock(&ctx->mutex);
>> --
>> 1.7.10.2
>>


