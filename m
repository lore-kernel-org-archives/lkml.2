Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759111Ab0KPBwL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Nov 2010 20:52:11 -0500
Received: from smtp-out.google.com ([74.125.121.35]:30926 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754915Ab0KPBwJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Nov 2010 20:52:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=AiSN60KP73JMKKa6TrvyHXxdprOSHUB6DxnxyMrrnSV6voHXJD5z7MNvprDut/MufB
         SBtEJ4YBrzqhM8ZbY5Pw==
MIME-Version: 1.0
In-Reply-To: <20101019045256.GA20232@dirshya.in.ibm.com>
References: <AANLkTinQAwEMGADYXX=2Rt3RUoMozDReNdpo9NtV1OO7@mail.gmail.com>
	<20101019045256.GA20232@dirshya.in.ibm.com>
Date: Mon, 15 Nov 2010 17:52:05 -0800
Message-ID: <AANLkTinz49WDn8yUFE_=dxUvneoZKAJYw4if9D7m7xaO@mail.gmail.com>
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

On Mon, Oct 18, 2010 at 9:52 PM, Vaidyanathan Srinivasan
<svaidy@linux.vnet.ibm.com> wrote:
> * Ranjit Manomohan <ranjitm@google.com> [2010-10-12 10:29:54]:
>
>> Hi,
>>   I would like to announce the availability of the Linux Scheduler Simulator
>> (Linsched) for 2.6.35.
>>
>> Originally developed at the University of North Carolina, LinSched is a
>> user-space program that hosts the Linux scheduling subsystem.
>> Its purpose is to provide a tool for observing and modifying the behavior
>> of the Linux scheduler. This makes it a valuable tool in prototyping new
>> Linux scheduling policies in a way that may be easier (or otherwise
>> less painful or time-consuming) to many developers when compared
>> to working with real hardware.
>
> The idea and framework looks very interesting.  I tried it out in
> order to understand the workload model and verification model and it
> worked fine for the test cases that you have provided.

Thanks for evaluating it.

>
>> Since Linsched allows arbitrary hardware topologies to be modeled,
>> it enables testing of scheduler changes on hardware that may not be
>> easily accessible to the developer. For example, most developers don't
>> have access to a quad-core quad-socket box, but they can use LinSched
>> to see how their changes affect the scheduler on such boxes.
>
> I am interested in trying this simulator in order to
> design/study/verify task placement logic within the SMP loadbalancer.
> Basically the effects of SD_POWERSAVINGS_BALANCE, SD_PREFER_SIBLING,
> etc in various topologies.
>
> The current interface and verification mechanism is to create tasks
> and observe the runtime received by each task.  In an ideal
> loadbalancer situation, all tasks should have received runtime
> proportional to their priority.
>
> Can you help me figure out how to get to kstat_cpu() or per-cpu
> kernel_stat accounting/utilisation metrics within the simulation?

we don't use the kstat_cpu accounting in the simulation since it does
not really make sense in this environment.

We have a timer driven loop that advances time globally and kicks of
events scheduled to run at specified times on each CPU. The periodic
timer tick is one among these events. Since there is really no notion
of system vs user time in this scenario, the current code disables the
update_process_times routine. I am not sure how these times relate to
the task placement logic you are trying to verify. If you could let me
know how you plan to use these then I can try to accommodate that in
the simulation.

Sorry for the delay in response. My mail filters messed this up.

-Thanks,
Ranjit

>
> Thanks for sharing the framework.
>
> --Vaidy
>
>
