Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754063Ab2BBIqw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 03:46:52 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:37974 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753371Ab2BBIqu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 03:46:50 -0500
MIME-Version: 1.0
In-Reply-To: <4F29D221.9050104@linux.vnet.ibm.com>
References: <CAOLZvyE=z=Y5wD-Vyp1ZbWV1-kqW8EmZkrHOcMBPZmBQ67E+Ow@mail.gmail.com>
 <4F29D221.9050104@linux.vnet.ibm.com>
From: Manuel Lauss <manuel.lauss@googlemail.com>
Date: Thu, 2 Feb 2012 09:46:10 +0100
Message-ID: <CAOLZvyG9gR_M3m=rU2oBXSAiUkrn+c4W6ejfNJh3aVoAwAA=aw@mail.gmail.com>
Subject: Re: [WARN] offlining CPUs yields warning at arch/x86/kernel/smp.c:120
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Suresh B Siddha <suresh.b.siddha@intel.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 2, 2012 at 1:00 AM, Srivatsa S. Bhat
<srivatsa.bhat@linux.vnet.ibm.com> wrote:
> On 02/01/2012 07:53 PM, Manuel Lauss wrote:
>
>> Hello,
>>
>> When offlining/onlining CPUs the following warning is spat out repeatedly.
>> System is a 4-core+HT SandyBridge laptop.  Full dmesg below.
>>
>> CPU 7 is now offline
>> CPU 6 is now offline
>> CPU 5 is now offline
>> ------------[ cut here ]------------
>> WARNING: at /mnt/data/.src/linux.git/arch/x86/kernel/smp.c:120
>> update_process_times+0x65/0x80()
>> Hardware name: Precision M6600
>> Modules linked in:
>> Pid: 17, comm: migration/2 Not tainted 3.3.0-rc1-00473-g6bc2b95 #1
>> Call Trace:
>>  <IRQ>  [<ffffffff8104e5eb>] ? warn_slowpath_common+0x7b/0xc0
>>  [<ffffffff8108a000>] ? tick_nohz_handler+0xd0/0xd0
>>  [<ffffffff8105af45>] ? update_process_times+0x65/0x80
>>  [<ffffffff8108a05b>] ? tick_sched_timer+0x5b/0xb0
>>  [<ffffffff8106dc0e>] ? __run_hrtimer.isra.33+0x4e/0xe0
>>  [<ffffffff8106e3e0>] ? hrtimer_interrupt+0xe0/0x210
>>  [<ffffffff810a09e0>] ? queue_stop_cpus_work+0xf0/0xf0
>>  [<ffffffff8101c513>] ? smp_apic_timer_interrupt+0x63/0xa0
>>  [<ffffffff818acbcb>] ? apic_timer_interrupt+0x6b/0x70
>>  <EOI>  [<ffffffff810a0a6a>] ? stop_machine_cpu_stop+0x8a/0xb0
>>  [<ffffffff810a06f4>] ? cpu_stopper_thread+0xc4/0x190
>>  [<ffffffff81073e6e>] ? try_to_wake_up+0x1de/0x290
>>  [<ffffffff8107153f>] ? __wake_up_common+0x4f/0x80
>>  [<ffffffff810a0630>] ? cpu_stop_signal_done+0x30/0x30
>>  [<ffffffff81069ec5>] ? kthread+0x85/0x90
>>  [<ffffffff818ad294>] ? kernel_thread_helper+0x4/0x10
>>  [<ffffffff81069e40>] ? kthread_freezable_should_stop+0x60/0x60
>>  [<ffffffff818ad290>] ? gs_change+0xb/0xb
>> ---[ end trace 431db5dbf525be16 ]---
>> CPU 4 is now offline
>
>
> Hi,
>
> Try this patch:
> https://lkml.org/lkml/2012/1/19/463

That did the trick!

Thanks!
        Manuel Lauss
