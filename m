Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752046Ab2LWLme (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Dec 2012 06:42:34 -0500
Received: from mail-oa0-f44.google.com ([209.85.219.44]:57662 "EHLO
	mail-oa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751973Ab2LWLma (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Dec 2012 06:42:30 -0500
MIME-Version: 1.0
In-Reply-To: <87623wf2eb.fsf@sejong.aot.lge.com>
References: <1355127754-8444-1-git-send-email-alex.shi@intel.com>
	<1355127754-8444-8-git-send-email-alex.shi@intel.com>
	<50C800B5.1080205@linux.vnet.ibm.com>
	<50C995B8.6020801@intel.com>
	<87623wf2eb.fsf@sejong.aot.lge.com>
Date: Sun, 23 Dec 2012 19:42:29 +0800
Message-ID: <CAGjg+kGHxjrtb-Xn+mrJf0AgYhn+xB8awrpv94uhqOC=UBv3Kw@mail.gmail.com>
Subject: Re: [PATCH 07/18] sched: compute runnable load avg in cpu_load and cpu_avg_load_per_task
From: Alex Shi <lkml.alex@gmail.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Alex Shi <alex.shi@intel.com>, Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        rob@landley.net, mingo@redhat.com, peterz@infradead.org,
        gregkh@linuxfoundation.org, andre.przywara@amd.com, rjw@sisk.pl,
        paul.gortmaker@windriver.com, akpm@linux-foundation.org,
        paulmck@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
        pjt@google.com, vincent.guittot@linaro.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> @@ -2487,7 +2487,7 @@ static void __update_cpu_load(struct rq *this_rq, unsigned long this_load,
>>  void update_idle_cpu_load(struct rq *this_rq)
>>  {
>>       unsigned long curr_jiffies = ACCESS_ONCE(jiffies);
>> -     unsigned long load = this_rq->load.weight;
>> +     unsigned long load = (unsigned long)this_rq->cfs.runnable_load_avg;
>
> So shouldn't this line be guarded with CONFIG_SMP too?

Thanks reminder. Yes, I already found this problem and plan to resend
the patch base on latest tree.

>
> Thanks,
