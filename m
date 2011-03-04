Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759329Ab1CDI7L (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Mar 2011 03:59:11 -0500
Received: from mail-px0-f174.google.com ([209.85.212.174]:47284 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755637Ab1CDI7J convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Mar 2011 03:59:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=JKys5E907BqviyRkXeZtdvFHiSZpt3Vcd9oR1RROX8dTBPReX0suL7A4/2uX9h5dra
         oLAkgpnKLFRsGflLxHUqau6Ca4/YQbtIHgjBNpdLPzK375+XQ4Tajg+ZFonDkR6ROs1a
         lHHFgZUigErnw4lK6m/tO3j4lIfoo/CKor82g=
MIME-Version: 1.0
In-Reply-To: <AANLkTinMvkuxdrwgj4bS9MfVaimWx-DYaanhUD-bT_wO@mail.gmail.com>
References: <20110303113435.GA2868@balbir.in.ibm.com>
	<20110303140551.GA20677@zhy>
	<AANLkTikHFLoJOZvx2YebKdHt+jjiHgUFasiLTrZ6vBUJ@mail.gmail.com>
	<AANLkTikqC=MNXXavJ_jxhFNQz1uNdABXVhvj82HW=BNA@mail.gmail.com>
	<20110304072517.GC2868@balbir.in.ibm.com>
	<AANLkTikuQKGS2SQArVBDo=5vOkyrNPdqXHPrOyQz3KdP@mail.gmail.com>
	<AANLkTi=gtnZ-uC-t6u9R=pNd_aSKE3YsXi_HUqnu5+VQ@mail.gmail.com>
	<AANLkTinMvkuxdrwgj4bS9MfVaimWx-DYaanhUD-bT_wO@mail.gmail.com>
Date: Fri, 4 Mar 2011 14:29:08 +0530
X-Google-Sender-Auth: 0Qy8l_Wf-DNFdMIQXKazClS7bFQ
Message-ID: <AANLkTimy5mPqCEbMv_68XMa7Pq_n_-jq0Pdor8+ck64B@mail.gmail.com>
Subject: Re: [BUGFIX][PATCH] Fix sched rt group scheduling when hierachy is enabled
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: Yong Zhang <yong.zhang0@gmail.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <pzijlstr@redhat.com>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Bharata B Rao <bharata.rao@in.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>  deactivate_task(b); /* A.throttled == 1 && A.rt_nr_running == 0 */
>>>    do_sched_rt_period_timer(); /* A.run_time == 0 && A.throttled == 0*/
>>
>> Note at some point rt_time becomes 0 and if enqueue is not set, the
>
> If the group should be add back, it will be at the first
> do_sched_rt_period_timer() which decreases run_time;
>

As long as idle is 0, the period will continue to run, if it has
rt_nr_running or rt_time, the timer will run.

>> next do_sched_rt_period_timer() is a NOP and does not enqueue back the
>> group
>
> Otherwise it will be added back when a task is attching to it.
>
> I still can't see how a unthrottled group which has task attched stay
> unqueued.

The other way of looking at the first change is

Can we have rt_time as 0, rt_nr_running >=1, rt_throttled !=0 and
still not have the rt_rq enqueued?

If this is not the case, we don't lose much, a quick check for
rt_nr_running and on_rt_q

Balbir
