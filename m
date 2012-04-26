Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755835Ab2DZVWM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2012 17:22:12 -0400
Received: from terminus.zytor.com ([198.137.202.10]:57608 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752077Ab2DZVWL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2012 17:22:11 -0400
References: <20120227115905.GB9943@elte.hu> <1332974587-15452-1-git-send-email-kjwinchester@gmail.com> <4F99A69B.4040004@zytor.com> <CAELBVzAi_yndZbDc0TkXhbqzn2wULpnsFMA_dop=Uvaii8tkqg@mail.gmail.com>
User-Agent: K-9 Mail for Android
In-Reply-To: <CAELBVzAi_yndZbDc0TkXhbqzn2wULpnsFMA_dop=Uvaii8tkqg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v5 0/5] x86: Cleanup and simplify cpu-specific data
From: "H. Peter Anvin" <hpa@zytor.com>
Date: Thu, 26 Apr 2012 14:21:40 -0700
To: Kevin Winchester <kjwinchester@gmail.com>
CC: Nick Bowler <nbowler@elliptictech.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        linux-kernel@vger.kernel.org, Randy Dunlap <rdunlap@xenotime.net>,
        Borislav Petkov <bp@alien8.de>
Message-ID: <1a0aaa16-df06-40bf-88c7-28180455e6b9@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Against mainline would be better, unless it actively conflicts with something in tip.

Kevin Winchester <kjwinchester@gmail.com> wrote:

>On Apr 26, 2012 4:49 PM, "H. Peter Anvin" <hpa@zytor.com> wrote:
>>
>> On 03/28/2012 03:43 PM, Kevin Winchester wrote:
>> > Various per-cpu fields are define in arch/x86/kernel/smpboot.c that
>are
>> > basically equivalent to the cpu-specific data in struct
>cpuinfo_x86.
>> > By moving these fields into the structure, a number of codepaths
>can be
>> > simplified since they no longer need to care about those fields not
>> > existing on !SMP builds.
>> >
>> > The size effects on allno (UP) and allyes (MAX_SMP) kernels are as
>> > follows:
>> >
>> > text      data      bss             dec        hex      filename
>> >  1369227    181536   1399180    2949943   2d0337 
>vmlinux.i386.allno
>> >  1370216    181600   1399012    2950828         2d06ac
> vmlinux.i386.allno.after
>> >  1608231    310968    505088    2424287   24fddf 
>vmlinux.x86_64.allno
>> >  1609232    311032    504896    2425160   250148
> vmlinux.x86_64.allno.after
>> > 97643748   6891747  34668544  139204039  84c15c7 
>vmlinux.i386.allyes
>> > 97643582   6892011  34668544  139204137  84c1629
> vmlinux.i386.allyes.after
>> > 85869519  13567071  44511232  143947822  894782e 
>vmlinux.x86_64.allyes
>> > 85869134  13568607  44511232  143948973  8947cad
> vmlinux.x86_64.allyes.after
>> >
>> > As can be seen, the kernels get slighly larger, but the code
>reduction/
>> > simplification should be enough to compensate for it.
>> >
>> > Changes in v5:
>> > - Reduced the number of files affected in the patchset by keeping
>helper
>> > functions in arch/x86/include/asm/smp.h
>> > - Rebased to latest tip/master
>> >
>> > Kevin Winchester (5):
>> >   x86: Move per cpu cpu_llc_shared_map to a field in struct
>cpuinfo_x86
>> >   x86: Move per cpu cpu_llc_id to a field in struct cpuinfo_x86
>> >   x86: Move per cpu cpu_sibling_map to a field in struct
>cpuinfo_x86
>> >   x86: Move per cpu cpu_core_map to a field in struct cpuinfo_x86
>> >   x86: Remove #ifdef CONFIG_SMP sections by moving smp_num_siblings
>> >     into common.c
>> >
>>
>> I applied this patchset on top of v3.4-rc4 (to get a clean topic
>branch)
>> and ran into the following build problems:
>>
>> i386 "allnoconfig":
>>
>> /home/hpa/kernel/tip.x86-cpu/arch/x86/kernel/process.c: In function
>> ‘select_idle_routine’:
>> /home/hpa/kernel/tip.x86-cpu/arch/x86/kernel/process.c:679:30: error:
>> ‘smp_num_siblings’ undeclared (first use in this function)
>> /home/hpa/kernel/tip.x86-cpu/arch/x86/kernel/process.c:679:30: note:
>> each undeclared identifier is reported only once for each function it
>> appears in
>>
>> i386 "allyesconfig" and "allmodconfig":
>>
>> /home/hpa/kernel/tip.x86-cpu/drivers/cpufreq/speedstep-ich.c: In
>> function ‘speedstep_cpu_init’:
>> /home/hpa/kernel/tip.x86-cpu/drivers/cpufreq/speedstep-ich.c:337:2:
>> error: incompatible type for argument 2 of ‘cpumask_copy’
>> /home/hpa/kernel/tip.x86-cpu/include/linux/cpumask.h:483:20: note:
>> expected ‘const struct cpumask *’ but argument is of type ‘cpumask_t’
>>
>> I will try it again against tip:master, but it looks to have the same
>> problems.
>>
>
>I'm pretty sure I tested at least some of those configurations, so
>maybe
>something has changed since I last tried it against tip/master. I'll
>rebase
>and fix up - would you prefer the series against mainline or tip?
>
>Kevin

-- 
Sent from my mobile phone. Please excuse brevity and lack of formatting.
