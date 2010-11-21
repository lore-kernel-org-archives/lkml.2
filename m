Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755531Ab0KUSnk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Nov 2010 13:43:40 -0500
Received: from mail.wdtv.com ([66.118.69.84]:60692 "EHLO mail.wdtv.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755042Ab0KUSnj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Nov 2010 13:43:39 -0500
From: Gene Heskett <gene.heskett@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH v4] sched: automated per session task groups
Date: Sun, 21 Nov 2010 13:43:34 -0500
User-Agent: KMail/1.13.5 (Linux/2.6.36.1-latencyfix; KDE/4.5.3; i686; ; )
Cc: Mike Galbraith <efault@gmx.de>, Oleg Nesterov <oleg@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
References: <20101121133744.GA10765@elte.hu>
In-Reply-To: <20101121133744.GA10765@elte.hu>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201011211343.34783.gene.heskett@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, November 21, 2010, Ingo Molnar wrote:
>Hello Mike,
>
>* Mike Galbraith <efault@gmx.de> wrote:
>> On Tue, 2010-11-16 at 18:28 +0100, Ingo Molnar wrote:
>> > Mike,
>> > 
>> > Mind sending a new patch with a separate v2 announcement in a new
>> > thread, once you have something i could apply to the scheduler tree
>> > (for a v2.6.38 merge)?
>> 
>> Changes since last:
>> - switch to per session vs tty
>> - make autogroups visible in /proc/sched_debug
>> - make autogroups visible in /proc/<pid>/autogroup
>> - add nice level bandwidth tweakability to /proc/<pid>/autogroup
>
>I tested it a bit, and autosched-v4 crashes on bootup with with attached
>config.
>
>Note: the box has serial logging enabled and there's UART code in the
>stacktrace - maybe it's related. Let me know if you need the full bootup
>log.
>
>Thanks,
>
>	Ingo
>
>[FAILED]
>Enabling local filesystem quotas:  [  OK  ]
>PPS event at 4294886381
>Enabling /etc/fstab swaps:  swapon: /dev/hda2: Function not implemented
>[FAILED]
>INIT: Entering runleveBUG: unable to handle kernel paging request at
>f548604c IP:l: 3 [<c10307f0>] update_cfs_shares+0x60/0x160
>*pdpt = 0000000002017001 *pde = 00000000029d4067 *pte = 8000000035486160
>Oops: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
>last sysfs file: /sys/block/sr0/dev
>
>Pid: 1, comm: init Not tainted 2.6.37-rc2-tip+ #64308 A8N-E/System
>Product Name EIP: 0060:[<c10307f0>] EFLAGS: 00010086 CPU: 1
>EIP is at update_cfs_shares+0x60/0x160
>EAX: fffffffe EBX: f547603b ECX: 00000400 EDX: 00000002
>ESI: f5486000 EDI: 0000013b EBP: f6459d48 ESP: f6459d3c
> DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
>Process init (pid: 1, ti=f6458000 task=f6450000 task.ti=f6458000)
>Stack:
> f5475a80 f6f066c0 00000004 f6459d84 c103256f 00000002 00000001 00000000
> c10324d0 c200e6c0 00000001 f6f06b34 00000046 f5475a80 f5475ac8 f6f066c0
> 00000001 ffffffff f6459dfc c1b32820 f64a0010 f6459dc4 00000046 00000000
>Call Trace:
> [<c103256f>] update_shares+0x9f/0x170
> [<c10324d0>] ? update_shares+0x0/0x170
> [<c1b32820>] schedule+0x580/0x9d0
> [<c1039335>] ? sub_preempt_count+0xa5/0xe0
> [<c1b330e5>] schedule_timeout+0x125/0x2a0
> [<c104fe60>] ? process_timeout+0x0/0x10
> [<c15aef4f>] uart_close+0x17f/0x350
> [<c105fea0>] ? autoremove_wake_function+0x0/0x50
> [<c1471f72>] tty_release+0x102/0x500
> [<c1125fdf>] ? locks_remove_posix+0xf/0xa0
> [<c1119a43>] ? fsnotify+0x1e3/0x2f0
> [<c11198d3>] ? fsnotify+0x73/0x2f0
> [<c10ea1e1>] fput+0xb1/0x230
> [<c10e7e7e>] filp_close+0x4e/0x70
> [<c10e7f14>] sys_close+0x74/0xc0
> [<c1002b90>] sysenter_do_call+0x12/0x31
>Code: 00 00 00 8b 18 8b 79 1c 8b 49 18 2b b8 84 00 00 00 01 d3 89 d8 0f
>af c1 01 fb 74 07 89 c2 c1 fa 1f f7 fb 83 f8 02 ba 02 00 00 00 <8b> 5e
>4c 0f 4d d0 39 d1 0f 42 d1 8b 4e 1c 85 c9 0f 84 6a 00 00 EIP:
>[<c10307f0>] update_cfs_shares+0x60/0x160 SS:ESP 0068:f6459d3c CR2:
>00000000f548604c
>---[ end trace f0ad48f53e29a8fe ]---
>Kernel panic - not syncing: Fatal exception
>Pid: 1, comm: init Tainted: G      D     2.6.37-rc2-tip+ #64308
>Call Trace:
> [<c1b31ef1>] ? panic+0x66/0x15c
> [<c10065c3>] ? oops_end+0x83/0x90
> [<c10220fc>] ? no_context+0xbc/0x190
> [<c102225d>] ? __bad_area_nosemaphore+0x8d/0x130
> [<c10219a4>] ? vmalloc_fault+0x14/0x1c0
> [<c1021b64>] ? spurious_fault+0x14/0x110
> [<c1022317>] ? bad_area_nosemaphore+0x17/0x20
> [<c1022741>] ? do_page_fault+0x281/0x4c0
> [<c1008756>] ? native_sched_clock+0x26/0x90
> [<c1066033>] ? sched_clock_local+0xd3/0x1c0
> [<c10224c0>] ? do_page_fault+0x0/0x4c0
> [<c1b361e2>] ? error_code+0x5a/0x60
> [<c10224c0>] ? do_page_fault+0x0/0x4c0
> [<c10307f0>] ? update_cfs_shares+0x60/0x160
> [<c103256f>] ? update_shares+0x9f/0x170
> [<c10324d0>] ? update_shares+0x0/0x170
> [<c1b32820>] ? schedule+0x580/0x9d0
> [<c1039335>] ? sub_preempt_count+0xa5/0xe0
> [<c1b330e5>] ? schedule_timeout+0x125/0x2a0
> [<c104fe60>] ? process_timeout+0x0/0x10
> [<c15aef4f>] ? uart_close+0x17f/0x350
> [<c105fea0>] ? autoremove_wake_function+0x0/0x50
> [<c1471f72>] ? tty_release+0x102/0x500
> [<c1125fdf>] ? locks_remove_posix+0xf/0xa0
> [<c1119a43>] ? fsnotify+0x1e3/0x2f0
> [<c11198d3>] ? fsnotify+0x73/0x2f0
> [<c10ea1e1>] ? fput+0xb1/0x230
> [<c10e7e7e>] ? filp_close+0x4e/0x70
> [<c10e7f14>] ? sys_close+0x74/0xc0
> [<c1002b90>] ? sysenter_do_call+0x12/0x31
>Rebooting in 1 seconds..Press any key to enter the menu

And I just 2 hours ago got it working on 2.6.36.1(rc1) but had to learn and 
add to my 'makeit' script before I could make x work again.  Yeah, I'm a 
bad bad boy, I run the latest nvidia drivers.  A tail on the syslog is 
clean (so far anyway, uptime is 2:06).

So you can have (FWTW) my reviewed by: Gene Heskett

These patches are a definite keeper IMNSHO.

-- 
Cheers, Gene
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
On the whole, I'd rather be in Philadelphia.
		-- W.C. Fields' epitaph
