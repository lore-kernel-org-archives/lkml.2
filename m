Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757571Ab2BBWW5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 17:22:57 -0500
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:55349 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932694Ab2BBWW4 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 17:22:56 -0500
MIME-Version: 1.0
In-Reply-To: <20120202213220.GB1642@x4>
References: <20120202211709.GA1642@x4>
	<20120202213220.GB1642@x4>
Date: Thu, 2 Feb 2012 23:22:54 +0100
Message-ID: <CABPqkBTutb5TuNVXZ4o+MzXczVSwk3NtsJh73KZS58xmrd=tbg@mail.gmail.com>
Subject: Re: WARNING: at arch/x86/kernel/cpu/perf_event.c:989
From: Stephane Eranian <eranian@google.com>
To: Markus Trippelsdorf <markus@trippelsdorf.de>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>
X-System-Of-Record: true
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks for the bug report.
I did fix a couple of those in intel_ds.c and intel_lbr.c, obviously
there is another one in x86_pmu_start().
I'll post a patch to remove that warning.


On Thu, Feb 2, 2012 at 10:32 PM, Markus Trippelsdorf
<markus@trippelsdorf.de> wrote:
> On 2012.02.02 at 22:17 +0100, Markus Trippelsdorf wrote:
>> The following warning is easily reproducible after todays
>> 'perf-urgent-for-mingo' merge by just running "perf top":
>>
>> ------------[ cut here ]------------
>> WARNING: at arch/x86/kernel/cpu/perf_event.c:989 x86_pmu_start+0xa5/0x100()
>> Hardware name: System Product Name
>> Pid: 0, comm: swapper/2 Not tainted 3.3.0-rc2-00068-g24b36da-dirty #22
>> Call Trace:
>>  <IRQ>  [<ffffffff81054ba0>] ? warn_slowpath_common+0x60/0xa0
>>  [<ffffffff8103e1a5>] ? x86_pmu_start+0xa5/0x100
>>  [<ffffffff8109f062>] ? perf_adjust_freq_unthr_context.part.82+0xe2/0x140
>>  [<ffffffff8109f260>] ? perf_event_task_tick+0x1a0/0x280
>>  [<ffffffff81078be3>] ? scheduler_tick+0xc3/0x140
>>  [<ffffffff810615b5>] ? update_process_times+0x55/0x80
>>  [<ffffffff8108904d>] ? tick_sched_timer+0x4d/0xa0
>>  [<ffffffff81072d1b>] ? __run_hrtimer.isra.32+0x3b/0xc0
>>  [<ffffffff810735e5>] ? hrtimer_interrupt+0xc5/0x1e0
>>  [<ffffffff81045de3>] ? smp_apic_timer_interrupt+0x63/0xa0
>>  [<ffffffff8147768b>] ? apic_timer_interrupt+0x6b/0x70
>>  <EOI>  [<ffffffff81039100>] ? default_idle+0x20/0x40
>>  [<ffffffff81039172>] ? amd_e400_idle+0x52/0x100
>>  [<ffffffff81030156>] ? cpu_idle+0xb6/0xe0
>> ---[ end trace 7dc3992f562261b6 ]---
>
> Most likely caused by e050e3f0a71b :
>  perf: Fix broken interrupt rate throttling
>
> CCing Stephane.
>
> --
> Markus
