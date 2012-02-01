Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756485Ab2BATY3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 14:24:29 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:46372 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755120Ab2BATY1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 14:24:27 -0500
From: Maciej Rutecki <maciej.rutecki@gmail.com>
Reply-To: maciej.rutecki@gmail.com
To: Manuel Lauss <manuel.lauss@googlemail.com>
Subject: Re: [WARN] offlining CPUs yields warning at arch/x86/kernel/smp.c:120
Date: Wed, 1 Feb 2012 20:24:22 +0100
User-Agent: KMail/1.13.7 (Linux/3.2.0; KDE/4.6.5; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>
References: <CAOLZvyE=z=Y5wD-Vyp1ZbWV1-kqW8EmZkrHOcMBPZmBQ67E+Ow@mail.gmail.com>
In-Reply-To: <CAOLZvyE=z=Y5wD-Vyp1ZbWV1-kqW8EmZkrHOcMBPZmBQ67E+Ow@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201202012024.22322.maciej.rutecki@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On środa, 1 lutego 2012 o 15:23:49 Manuel Lauss wrote:
> Hello,
> 
> When offlining/onlining CPUs the following warning is spat out repeatedly.
> System is a 4-core+HT SandyBridge laptop.  Full dmesg below.
> 
> CPU 7 is now offline
> CPU 6 is now offline
> CPU 5 is now offline
> ------------[ cut here ]------------
> WARNING: at /mnt/data/.src/linux.git/arch/x86/kernel/smp.c:120
> update_process_times+0x65/0x80()
> Hardware name: Precision M6600
> Modules linked in:
> Pid: 17, comm: migration/2 Not tainted 3.3.0-rc1-00473-g6bc2b95 #1
> Call Trace:
>  <IRQ>  [<ffffffff8104e5eb>] ? warn_slowpath_common+0x7b/0xc0
>  [<ffffffff8108a000>] ? tick_nohz_handler+0xd0/0xd0
>  [<ffffffff8105af45>] ? update_process_times+0x65/0x80
>  [<ffffffff8108a05b>] ? tick_sched_timer+0x5b/0xb0
>  [<ffffffff8106dc0e>] ? __run_hrtimer.isra.33+0x4e/0xe0
>  [<ffffffff8106e3e0>] ? hrtimer_interrupt+0xe0/0x210
>  [<ffffffff810a09e0>] ? queue_stop_cpus_work+0xf0/0xf0
>  [<ffffffff8101c513>] ? smp_apic_timer_interrupt+0x63/0xa0
>  [<ffffffff818acbcb>] ? apic_timer_interrupt+0x6b/0x70
>  <EOI>  [<ffffffff810a0a6a>] ? stop_machine_cpu_stop+0x8a/0xb0
>  [<ffffffff810a06f4>] ? cpu_stopper_thread+0xc4/0x190
>  [<ffffffff81073e6e>] ? try_to_wake_up+0x1de/0x290
>  [<ffffffff8107153f>] ? __wake_up_common+0x4f/0x80
>  [<ffffffff810a0630>] ? cpu_stop_signal_done+0x30/0x30
>  [<ffffffff81069ec5>] ? kthread+0x85/0x90
>  [<ffffffff818ad294>] ? kernel_thread_helper+0x4/0x10
>  [<ffffffff81069e40>] ? kthread_freezable_should_stop+0x60/0x60
>  [<ffffffff818ad290>] ? gs_change+0xb/0xb
> ---[ end trace 431db5dbf525be16 ]---
> CPU 4 is now offline
> 
> [and so on].
> 
> Please take a look.
> 
It is regression? If yes, which is latest good kernel and/or can you do 
bisection?

Regards
-- 
Maciej Rutecki
http://www.mrutecki.pl
