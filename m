Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752928Ab0LVOSE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Dec 2010 09:18:04 -0500
Received: from smtp-out.google.com ([74.125.121.67]:4754 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751681Ab0LVOSC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Dec 2010 09:18:02 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=mpXUt5e84oWQ7SK2/YyGot7n3BmiF05spLkdKsbHLI0HQygsMWO1d3i3p3pDPZMcW0
         Qa6YDagdmbsNnqNUlG6w==
MIME-Version: 1.0
In-Reply-To: <1293026724.2170.137.camel@laptop>
References: <1292980144-28796-1-git-send-email-venki@google.com>
	<1292980144-28796-6-git-send-email-venki@google.com>
	<1293009621.2170.72.camel@laptop>
	<AANLkTimhtoMLSo1W421+EpXiSphcfJ_6z8=usrF4M3FH@mail.gmail.com>
	<1293026724.2170.137.camel@laptop>
Date: Wed, 22 Dec 2010 06:17:57 -0800
Message-ID: <AANLkTikicrm_z=hDcTiE8jKv3BzZBEy7u=u=qv_LsFCL@mail.gmail.com>
Subject: Re: [PATCH 5/5] Account ksoftirqd time as cpustat softirq -v2
From: Venkatesh Pallipadi <venki@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        linux-kernel@vger.kernel.org, Paul Turner <pjt@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Shaun Ruffell <sruffell@digium.com>
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 22, 2010 at 6:05 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Wed, 2010-12-22 at 05:59 -0800, Venkatesh Pallipadi wrote:
>> > So you add the ksoftirqd runtime as softirq time in the /proc/stat
>> > output?
>> >
>> > That seems dubious...
>> >
>>
>> Yes. Thats similar to what we do today. As long as we are in softirq,
>> whether bottomhalf or ksoftirqd, we account the tick as softirq time
>> in /proc/stat.
>> I thought it also makes sense from user perspective. They want to know
>> how much time are we currently spending serving softirqs and hardirqs.
>> It is better to get that information at one place, instead of say look
>> at /proc/stat and add percpu ksoftirqd time to it. I mean,
>> user/administrator does not have to care whether ksoftirqd is involved
>> or not to know how much time was spend serving softirqs.
>>
> But ksoftirqd time is also counted as sys time, so somewhere this won't
> add up to 100%.
>

It won't get added into cpu kstat system time. It will get added into
task stime, so looking into ksoftirqd task time, this will be seen as
system time. So, per cpu kstat should be consistent when added up. The
problem will be, with ksoftirqd, cpu stats will say the time as
softirq and task stats will account the time to ksoftirqd task as
stime, which is different from what we do with other tasks. I guess
that should be OK as ksoftirqd are special in some sense.

Thanks,
Venki
