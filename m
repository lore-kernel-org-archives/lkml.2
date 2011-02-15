Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755907Ab1BOSZ1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 13:25:27 -0500
Received: from smtp-out.google.com ([216.239.44.51]:34032 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755534Ab1BOSZW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 13:25:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=J87Vj1ue74g7og0IdqSenItMEYYuOGj4XibCRpPt/rnPCKv88MD6A+oNOe1+yVkGCJ
         STd+iuKAUu4njjLw/cDA==
MIME-Version: 1.0
In-Reply-To: <20110208181026.GB8278@dirshya.in.ibm.com>
References: <AANLkTinQAwEMGADYXX=2Rt3RUoMozDReNdpo9NtV1OO7@mail.gmail.com>
	<20101019045256.GA20232@dirshya.in.ibm.com>
	<AANLkTinz49WDn8yUFE_=dxUvneoZKAJYw4if9D7m7xaO@mail.gmail.com>
	<20110208181026.GB8278@dirshya.in.ibm.com>
Date: Tue, 15 Feb 2011 10:25:18 -0800
Message-ID: <AANLkTikFXGW7iJX+S6NNj-wT15mUXKx21fEP1+9nKkv6@mail.gmail.com>
Subject: Re: [ANNOUNCE] Linsched for 2.6.35 released
From: Ranjit Manomohan <ranjitm@google.com>
To: svaidy@linux.vnet.ibm.com
Cc: linux-kernel@vger.kernel.org, Mike Galbraith <efault@gmx.de>,
        Nikhil Rao <ncrao@google.com>, Salman Qazi <sqazi@google.com>,
        Dhaval Giani <dhaval.giani@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        Venkatesh Pallipadi <venki@google.com>, Paul Turner <pjt@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 8, 2011 at 10:10 AM, Vaidyanathan Srinivasan
<svaidy@linux.vnet.ibm.com> wrote:
> * Ranjit Manomohan <ranjitm@google.com> [2010-11-15 17:52:05]:
>
>> On Mon, Oct 18, 2010 at 9:52 PM, Vaidyanathan Srinivasan
>> <svaidy@linux.vnet.ibm.com> wrote:
>> > * Ranjit Manomohan <ranjitm@google.com> [2010-10-12 10:29:54]:
>> >
>
> [snip]
>
>> > Can you help me figure out how to get to kstat_cpu() or per-cpu
>> > kernel_stat accounting/utilisation metrics within the simulation?
>>
>> we don't use the kstat_cpu accounting in the simulation since it does
>> not really make sense in this environment.
>>
>> We have a timer driven loop that advances time globally and kicks of
>> events scheduled to run at specified times on each CPU. The periodic
>> timer tick is one among these events. Since there is really no notion
>> of system vs user time in this scenario, the current code disables the
>> update_process_times routine. I am not sure how these times relate to
>> the task placement logic you are trying to verify. If you could let me
>> know how you plan to use these then I can try to accommodate that in
>> the simulation.
>
> The current setup lets us find how much time each task was run.
> I would like to use the kernel_stat information to understand 'which
> cpu' ran the task.  Basically we could place nr_tasks < nr_cpus and
> see them settle to the right CPUs within the sched domain topology.
> This can be verified by checking the CPU's utilisation or run time at
> the end of the simulation.  Like two tasks on the same socket of
> a dual-socket dual-core system should settle to one task per socket.
> The load balancer should be able to spread the tasks around slowly.
>
> The ability to create diverse topology within linsched is very
> useful to test these load balancer functions and corner cases.

Ok, I understand what you are looking for. There does not seem to be
anything in the kernel that I can reuse. I can add a Linsched specific
per cpu task counter to get the stats. I will try to send out an
update in a couple of days.

>
>> Sorry for the delay in response. My mail filters messed this up.
>
> I got your reply earlier. No problem with the delay.
> Do you have a new version to share?  Any new feature that you are planning?

Unfortunately we have fallen a little behind in terms of keeping
linsched up to date with mainline kernel releases. Hopefully we can
get an updated version out this summer. Our current plans are to
include a record/replay type of option to the simulation that will
allow us to optimize a particular workload. Please let me know if
there is anything else that you would like to see added.

-Thanks,
Ranjit

>
> --Vaidy
>
>
