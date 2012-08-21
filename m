Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756863Ab2HULFI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 07:05:08 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:55350 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754501Ab2HULFF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 07:05:05 -0400
MIME-Version: 1.0
In-Reply-To: <5032DD22.4000909@intel.com>
References: <5028F12C.7080405@intel.com>
	<1345028738.31459.82.camel@twins>
	<CAKfTPtDst+DEW=E=+cMcGL39oKODMfx3gh+x04siSC_5jt-6dg@mail.gmail.com>
	<5032DD22.4000909@intel.com>
Date: Tue, 21 Aug 2012 13:05:04 +0200
Message-ID: <CAKfTPtBJJcLmT_FVVRM_gB-KNHYYKYTmRdow7JzTnnrUfH+HXA@mail.gmail.com>
Subject: Re: [discussion]sched: a rough proposal to enable power saving in scheduler
From: Vincent Guittot <vincent.guittot@linaro.org>
To: Alex Shi <alex.shi@intel.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Arjan van de Ven <arjan@linux.intel.com>, svaidy@linux.vnet.ibm.com,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Paul Turner <pjt@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 21 August 2012 02:58, Alex Shi <alex.shi@intel.com> wrote:
> On 08/20/2012 11:36 PM, Vincent Guittot wrote:
>
>>> > What you want it to keep track of a per-cpu utilization level (inverse
>>> > of idle-time) and using PJTs per-task runnable avg see if placing the
>>> > new task on will exceed the utilization limit.
>>> >
>>> > I think some of the Linaro people actually played around with this,
>>> > Vincent?
>> Sorry for the late reply but I had almost no network access during last weeks.
>>
>> So Linaro also works on a power aware scheduler as Peter mentioned.
>>
>> Based on previous tests, we have concluded that main drawback of the
>> (now removed) old power scheduler was that we had no way to make
>> difference between short and long running tasks whereas it's a key
>> input (at least for phone) for deciding to pack tasks and for
>> selecting the core on an asymmetric system.
>
>
> It is hard to estimate future in general view point. but from hack
> point, maybe you can add something to hint this from task_struct. :)
>

per-task load tracking patchsets give you a good view of the last dozen of ms

>> One additional key information is the power distribution in the system
>> which can have a finer granularity than current sched_domain
>> description. Peter's proposal was to use a SHARE_POWERLINE flag
>> similarly to flags that already describe if a sched_domain share
>> resources or cpu capacity.
>
>
> Seems I missed this. what's difference with current SD_SHARE_CPUPOWER
> and SD_SHARE_PKG_RESOURCES.

SD_SHARE_CPUPOWER is set in a sched domain at SMT level (sharing some
part of the physical core)
SD_SHARE_PKG_RESOURCES is set at MC level (sharing some resources like
cache and memory access)

>
>>
>> With these 2 new information, we can have a 1st power saving scheduler
>> which spread or packed tasks across core and package
>
>
> Fine, I like to test them on X86, plus SMT and NUMA :)
>
>>
>> Vincent
>
>
