Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754300Ab3AGR7y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2013 12:59:54 -0500
Received: from mail-oa0-f42.google.com ([209.85.219.42]:45709 "EHLO
	mail-oa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752092Ab3AGR7x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2013 12:59:53 -0500
MIME-Version: 1.0
In-Reply-To: <1357565303.10284.73.camel@gandalf.local.home>
References: <cover.1352196505.git.viresh.kumar@linaro.org>
	<ad25c731a6ca1bd1269555245952f05c856a9759.1352196505.git.viresh.kumar@linaro.org>
	<20121126171539.GZ15971@htj.dyndns.org>
	<CAKohpom9=K976NmyFWtXx2UQyRcLAqsoGw-5AaqXRpSL6uxP_g@mail.gmail.com>
	<CAKohpokBMhto6xzp3MPGRJqstEkkC=kzgrKNhVXzi1Y8GejkXg@mail.gmail.com>
	<20130104150928.GC15633@mtj.dyndns.org>
	<CAKohpo=hhScCDUnDcqnZx4YzU_8nF1658jmSM_wzsOpSCxXwqA@mail.gmail.com>
	<1357565303.10284.73.camel@gandalf.local.home>
Date: Mon, 7 Jan 2013 23:29:53 +0530
Message-ID: <CAKohpom9DxoojtcpMfmyGeUcEw8=tsS4n+TFMRV3+9_UBaod7g@mail.gmail.com>
Subject: Re: [PATCH V2 Resend 3/4] workqueue: Schedule work on non-idle cpu
 instead of current one
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Tejun Heo <tj@kernel.org>, Vincent Guittot <vincent.guittot@linaro.org>,
        pjt@google.com, paul.mckenney@linaro.org, tglx@linutronix.de,
        suresh.b.siddha@intel.com, venki@google.com, mingo@redhat.com,
        peterz@infradead.org, Arvind.Chauhan@arm.com,
        linaro-dev@lists.linaro.org, patches@linaro.org,
        pdsw-power-team@arm.com, linux-kernel@vger.kernel.org,
        linux-rt-users@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 7 January 2013 18:58, Steven Rostedt <rostedt@goodmis.org> wrote:
> On Mon, 2013-01-07 at 15:28 +0530, Viresh Kumar wrote:
>> I have another idea that we can try:
>>
>> queue_work_on_any_cpu().
>
> I think this is a good idea.

:) :)

>> - the mask of cpus to schedule this work on
>>   OR
>> - Sched Level (SD_LEVEL) of cpus to run it.
>
> I wouldn't give a mask. If one is needed, we could have a
> queue_work_on_mask_cpus(), or something. I think the "any" in the name
> should be good enough to let developers know that this will not be on
> the CPU that is called.

Fair Enough.

> By default, I would suggest for cache locality,
> that we try to keep it on the same CPU. But if there's a better CPU to
> run on, it runs there.

That would break our intention behind this routine. We should run
it on a cpu which we think is the best one for it power/performance wise.

So, i would like to call the sched_select_cpu() routine from this routine to
get the suggested cpu.

This routine would however would see more changes later to optimize it
more.

> Also, we could still add a debug option that
> makes it always run on other CPUs to slap developers that don't read.

I don't think we need it :(
It would be a new API, with zero existing users. And so, whomsoever uses
it, should know what exactly he is doing :)

Thanks for your quick feedback.
