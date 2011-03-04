Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759144Ab1CDJbC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Mar 2011 04:31:02 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:34935 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751713Ab1CDJa7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Mar 2011 04:30:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=gkROMLGIDJ5hMexSwGgn5QDayq6B1C2MbwQzdEIf0S5g1GKmxrUxDLxIvHwz1vTVMD
         5g19qa0S1abfe3IeUXlgPrAnhz0qc+tWOqN0SlPHRKhS75oNQEp1YcbE78+7yc4oJ67m
         tbmNPF7YBgnQx3T5zWas/gZLIjgSFqn2rSVfM=
MIME-Version: 1.0
In-Reply-To: <AANLkTimy5mPqCEbMv_68XMa7Pq_n_-jq0Pdor8+ck64B@mail.gmail.com>
References: <20110303113435.GA2868@balbir.in.ibm.com>
	<20110303140551.GA20677@zhy>
	<AANLkTikHFLoJOZvx2YebKdHt+jjiHgUFasiLTrZ6vBUJ@mail.gmail.com>
	<AANLkTikqC=MNXXavJ_jxhFNQz1uNdABXVhvj82HW=BNA@mail.gmail.com>
	<20110304072517.GC2868@balbir.in.ibm.com>
	<AANLkTikuQKGS2SQArVBDo=5vOkyrNPdqXHPrOyQz3KdP@mail.gmail.com>
	<AANLkTi=gtnZ-uC-t6u9R=pNd_aSKE3YsXi_HUqnu5+VQ@mail.gmail.com>
	<AANLkTinMvkuxdrwgj4bS9MfVaimWx-DYaanhUD-bT_wO@mail.gmail.com>
	<AANLkTimy5mPqCEbMv_68XMa7Pq_n_-jq0Pdor8+ck64B@mail.gmail.com>
Date: Fri, 4 Mar 2011 17:30:58 +0800
Message-ID: <AANLkTi=CxyXHXpa-=CNyyJPOHe-OV0xGr3USKx+TyeqK@mail.gmail.com>
Subject: Re: [BUGFIX][PATCH] Fix sched rt group scheduling when hierachy is enabled
From: Yong Zhang <yong.zhang0@gmail.com>
To: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <pzijlstr@redhat.com>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Bharata B Rao <bharata.rao@in.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 4, 2011 at 4:59 PM, Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
>>>>  deactivate_task(b); /* A.throttled == 1 && A.rt_nr_running == 0 */
>>>>    do_sched_rt_period_timer(); /* A.run_time == 0 && A.throttled == 0*/
>>>
>>> Note at some point rt_time becomes 0 and if enqueue is not set, the
>>
>> If the group should be add back, it will be at the first
>> do_sched_rt_period_timer() which decreases run_time;
>>
>
> As long as idle is 0, the period will continue to run, if it has
> rt_nr_running or rt_time, the timer will run.

Yep.
Should be the first do_sched_rt_period_timer() which meets
rt_rq->rt_time < runtime :)

>
>>> next do_sched_rt_period_timer() is a NOP and does not enqueue back the
>>> group
>>
>> Otherwise it will be added back when a task is attching to it.
>>
>> I still can't see how a unthrottled group which has task attched stay
>> unqueued.
>
> The other way of looking at the first change is
>
> Can we have rt_time as 0, rt_nr_running >=1, rt_throttled !=0 and
> still not have the rt_rq enqueued?

Yeah, the same question. How could we reach that?

IMHO, rt_time == 0 and rt_throttled !=0 can't coexist.

>
> If this is not the case, we don't lose much, a quick check for
> rt_nr_running and on_rt_q

I don't get what you mean here.

Thanks,
Yong


-- 
Only stand for myself
