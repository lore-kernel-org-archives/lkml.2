Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756800Ab0GMKX7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jul 2010 06:23:59 -0400
Received: from anguilla.debian.or.at ([86.59.21.37]:33601 "EHLO
	anguilla.debian.or.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756719Ab0GMKXy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jul 2010 06:23:54 -0400
Date: Tue, 13 Jul 2010 12:23:51 +0200
From: Peter Palfrader <peter@palfrader.org>
To: Avi Kivity <avi@redhat.com>
Cc: Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org, stable@kernel.org,
        stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Glauber Costa <glommer@redhat.com>,
        Zachary Amsden <zamsden@redhat.com>,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        Marcelo Tosatti <mtosatti@redhat.com>
Subject: Re: [patch 134/149] x86, paravirt: Add a global synchronization
	point for pvclock
Message-ID: <20100713102350.GW15122@anguilla.noreply.org>
Mail-Followup-To: Peter Palfrader <peter@palfrader.org>,
	Avi Kivity <avi@redhat.com>, Greg KH <gregkh@suse.de>,
	linux-kernel@vger.kernel.org, stable@kernel.org,
	stable-review@kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
	Glauber Costa <glommer@redhat.com>,
	Zachary Amsden <zamsden@redhat.com>,
	Jeremy Fitzhardinge <jeremy@goop.org>,
	Marcelo Tosatti <mtosatti@redhat.com>
References: <20100701175144.GA2116@kroah.com> <20100701173218.125822294@clark.site> <20100707124731.GJ15122@anguilla.noreply.org> <4C359D5A.1050906@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <4C359D5A.1050906@redhat.com>
X-PGP: 1024D/94C09C7F 5B00 C96D 5D54 AEE1 206B  AF84 DE7A AF6E 94C0 9C7F
X-Request-PGP: http://www.palfrader.org/keys/94C09C7F.asc
X-Accept-Language: de, en
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry for the delay.

On Thu, 08 Jul 2010, Avi Kivity wrote:

> I'm unable to reproduce.
>
> Can you provide the stack trace where this hangs?

Here goes:

| (gdb) target remote :1234
| Remote debugging using :1234
| [New Thread 1]
| 0xffffffff81702314 in _spin_lock (lock=0xffffffff81ab9e30)
|     at /scratch/kernel/2.6.32.16/arch/x86/include/asm/spinlock.h:65
| 65      /scratch/kernel/2.6.32.16/arch/x86/include/asm/spinlock.h: No such file or directory.
|         in /scratch/kernel/2.6.32.16/arch/x86/include/asm/spinlock.h
| (gdb) bt
| #0  0xffffffff81702314 in _spin_lock (lock=0xffffffff81ab9e30)
|     at /scratch/kernel/2.6.32.16/arch/x86/include/asm/spinlock.h:65
| #1  0xffffffff8107b214 in vprintk (
|     fmt=0xffffffff818a3ee8 "<1>BUG: unable to handle kernel ", 
|     args=0xffff88001f8f2c38) at kernel/printk.c:705
| #2  0xffffffff816ff387 in printk (fmt=0xffffffff81ab9e30 "")
|     at kernel/printk.c:595
| #3  0xffffffff8105b94a in no_context (regs=0xffff88001f8f2e98, error_code=3, 
|     address=18446744071586262656) at arch/x86/mm/fault.c:583
| #4  0xffffffff8105bb65 in __bad_area_nosemaphore (regs=0xffff88001f8f2e98, 
|     error_code=3, address=18446744071586262656, si_code=196609)
|     at arch/x86/mm/fault.c:741
| #5  0xffffffff8105bc4e in bad_area_nosemaphore (regs=0xffffffff81ab9e30, 
|     error_code=18446612132843695160, address=4294892530)
|     at arch/x86/mm/fault.c:748
| #6  0xffffffff8105c02f in do_page_fault (regs=0xffff88001f8f2e98, error_code=3)
|     at arch/x86/mm/fault.c:1061
| #7  0xffffffff81702765 in page_fault ()
| #8  0x000d3496569e13a8 in ?? ()
| #9  0x00000000b4b2c8e7 in ?? ()
| #10 0x00000003ede5a5a5 in ?? ()
| #11 0x0000000000000001 in per_cpu__irq_stack_union ()
| #12 0xffff880001c11e80 in ?? ()
| ---Type <return> to continue, or q <return> to quit---
| #13 0x0000000000000000 in ?? ()
| (gdb) 
| (gdb) 
| (gdb) 
| (gdb) bt full
| #0  0xffffffff81702314 in _spin_lock (lock=0xffffffff81ab9e30)
|     at /scratch/kernel/2.6.32.16/arch/x86/include/asm/spinlock.h:65
| No locals.
| #1  0xffffffff8107b214 in vprintk (
|     fmt=0xffffffff818a3ee8 "<1>BUG: unable to handle kernel ", 
|     args=0xffff88001f8f2c38) at kernel/printk.c:705
|         printed_len = 0
|         current_log_level = 4
|         flags = 70
|         p = <value optimized out>
| #2  0xffffffff816ff387 in printk (fmt=0xffffffff81ab9e30 "")
|     at kernel/printk.c:595
|         args = {{gp_offset = 8, fp_offset = 48, 
|     overflow_arg_area = 0xffff88001f8f2d18, 
|     reg_save_area = 0xffff88001f8f2c58}}
|         r = 256
| #3  0xffffffff8105b94a in no_context (regs=0xffff88001f8f2e98, error_code=3, 
|     address=18446744071586262656) at arch/x86/mm/fault.c:583
|         tsk = (struct task_struct *) 0xffff88001f908000
|         flags = 146
|         sig = <value optimized out>
| #4  0xffffffff8105bb65 in __bad_area_nosemaphore (regs=0xffff88001f8f2e98, 
|     error_code=3, address=18446744071586262656, si_code=196609)
| ---Type <return> to continue, or q <return> to quit---
|     at arch/x86/mm/fault.c:741
|         tsk = (struct task_struct *) 0xffff88001f908000
| #5  0xffffffff8105bc4e in bad_area_nosemaphore (regs=0xffffffff81ab9e30, 
|     error_code=18446612132843695160, address=4294892530)
|     at arch/x86/mm/fault.c:748
| No locals.
| #6  0xffffffff8105c02f in do_page_fault (regs=0xffff88001f8f2e98, error_code=3)
|     at arch/x86/mm/fault.c:1061
|         vma = <value optimized out>
|         tsk = (struct task_struct *) 0xffff88001f908000
|         address = 18446744071586262656
|         mm = (struct mm_struct *) 0x0
|         write = <value optimized out>
|         fault = 256
| #7  0xffffffff81702765 in page_fault ()
| No symbol table info available.
| #8  0x000d3496569e13a8 in ?? ()
| No symbol table info available.
| #9  0x00000000b4b2c8e7 in ?? ()
| No symbol table info available.
| #10 0x00000003ede5a5a5 in ?? ()
| No symbol table info available.
| #11 0x0000000000000001 in per_cpu__irq_stack_union ()
| ---Type <return> to continue, or q <return> to quit---
| No symbol table info available.
| #12 0xffff880001c11e80 in ?? ()
| No symbol table info available.
| #13 0x0000000000000000 in ?? ()
| No symbol table info available.
| (gdb) quit


So, I disabled PRINTK_TIME and tried again.  This time I got:

VFS: Mounted root (ext3 filesystem) readonly on device 253:0.
Freeing unused kernel memory: 632k freed
Write protecting the kernel read-only data: 9492k
BUG: unable to handle kernel paging request at ffffffff81712e80
IP: [<ffffffff81054f73>] pvclock_clocksource_read+0x83/0xc0
PGD 1003067 PUD 1007063 PMD 7e8b1063 PTE 8000000001712161
Oops: 0003 [#1] SMP 
last sysfs file: 
CPU 0 
Pid: 1, comm: swapper Not tainted 2.6.32.16-dsa-amd64 #2 
RIP: 0010:[<ffffffff81054f73>]  [<ffffffff81054f73>] pvclock_clocksource_read+0x83/0xc0
RSP: 0018:ffff88007fb47880  EFLAGS: 00010283
RAX: 000d362a57085b85 RBX: ffff880001c11e80 RCX: 000d362a573c6400
RDX: 000d362a57085b85 RSI: 000000000001c410 RDI: ffff880001c11e80
RBP: ffff88007fb478c0 R08: 000000000001a9f2 R09: 6db6db6db6db6db7
R10: ffff88007f15a0a0 R11: ffff88007f15a040 R12: 0000000000000001
R13: 0000001112bb6a47 R14: 00000000b4b2c8e7 R15: 000d362a573c2e34
FS:  0000000000000000(0000) GS:ffff880001c00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
CR2: ffffffff81712e80 CR3: 0000000001001000 CR4: 00000000000006f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process swapper (pid: 1, threadinfo ffff88007fb46000, task ffff88007fb50000)
Stack:
 ffff88007fb47900 ffffffff0001a9f2 ffff88007e884150 ffffffff81975c00
<0> 00000000000001b6 ffffffffb3c3c368 ffff88007fb29078 0000000000000000
<0> ffff88007fb478d0 ffffffff8105423c ffff88007fb478e0 ffffffff81054249
Call Trace:
 [<ffffffff8105423c>] kvm_clock_read+0x1c/0x20
 [<ffffffff81054249>] kvm_clock_get_cycles+0x9/0x10
 [<ffffffff81099101>] ktime_get_ts+0x71/0xe0
 [<ffffffff810add4d>] __delayacct_blkio_start+0x1d/0x20
 [<ffffffff8170032a>] io_schedule+0x5a/0xd0
 [<ffffffff81117bdd>] sync_buffer+0x3d/0x50
 [<ffffffff817008ca>] __wait_on_bit+0x5a/0x90
 [<ffffffff81117ba0>] ? sync_buffer+0x0/0x50
 [<ffffffff81117ba0>] ? sync_buffer+0x0/0x50
 [<ffffffff81700974>] out_of_line_wait_on_bit+0x74/0x90
 [<ffffffff81090b30>] ? wake_bit_function+0x0/0x40
 [<ffffffff81117b46>] __wait_on_buffer+0x26/0x30
 [<ffffffff8116331d>] ext3_find_entry+0x19d/0x6b0
 [<ffffffff81060e90>] ? do_flush_tlb_all+0x0/0x70
 [<ffffffff8116418d>] ext3_lookup+0x4d/0x130
 [<ffffffff81105203>] ? d_alloc+0x123/0x1b0
 [<ffffffff810f9fe6>] do_lookup+0x206/0x260
 [<ffffffff810fbe6b>] __link_path_walk+0x19b/0x1000
 [<ffffffff81060eb8>] ? do_flush_tlb_all+0x28/0x70
 [<ffffffff8107fece>] ? on_each_cpu+0x2e/0x50
 [<ffffffff810fcf5e>] path_walk+0x6e/0xe0
 [<ffffffff810fd0eb>] do_path_lookup+0x5b/0x60
 [<ffffffff810fe015>] do_filp_open+0xf5/0xb10
 [<ffffffff810a4026>] ? smp_call_function_many+0x1e6/0x230
 [<ffffffff8105cad0>] ? __cpa_flush_range+0x0/0x30
 [<ffffffff8105caf5>] ? __cpa_flush_range+0x25/0x30
 [<ffffffff8105db73>] ? change_page_attr_set_clr+0x273/0x410
 [<ffffffff81108a5a>] ? alloc_fd+0x4a/0x140
 [<ffffffff810eed7f>] do_sys_open+0x7f/0x140
 [<ffffffff810eee6b>] sys_open+0x1b/0x20
 [<ffffffff810091ef>] init_post+0x3f/0x1b0
 [<ffffffff81a106e5>] kernel_init+0x1a2/0x1ba
 [<ffffffff810373ca>] child_rip+0xa/0x20
 [<ffffffff81a10543>] ? kernel_init+0x0/0x1ba
 [<ffffffff810373c0>] ? child_rip+0x0/0x20
Code: 78 4f 44 89 e1 48 d3 e0 44 89 f2 48 f7 e2 48 0f ac d0 20 4a 8d 0c 38 44 39 03 75 a4 48 8b 15 15 df 6b 00 48 39 ca 77 17 48 89 d0 <f0> 48 0f b1 0d 04 df 6b 00 48 39 c1 48 89 c2 75 e7 48 89 ca 48 
RIP  [<ffffffff81054f73>] pvclock_clocksource_read+0x83/0xc0
 RSP <ffff88007fb47880>
CR2: ffffffff81712e80
---[ end trace 38f25e02ae34d4c1 ]---
BUG: unable to handle kernel paging request at ffffffff81712e80
IP: [<ffffffff81054f73>] pvclock_clocksource_read+0x83/0xc0
PGD 1003067 PUD 1007063 PMD 7e8b1063 PTE 8000000001712161
Oops: 0003 [#2] SMP 
last sysfs file: 
CPU 0 
Pid: 1, comm: swapper Tainted: G      D    2.6.32.16-dsa-amd64 #2 
RIP: 0010:[<ffffffff81054f73>]  [<ffffffff81054f73>] pvclock_clocksource_read+0x83/0xc0
RSP: 0018:ffff880001c03e78  EFLAGS: 00010097
RAX: 000d362a57085b85 RBX: ffff880001c11e80 RCX: 000d362a5b7e8c49
RDX: 000d362a57085b85 RSI: 0000000000000000 RDI: ffff880001c11e80
RBP: ffff880001c03eb8 R08: 000000000001e50c R09: 0000000000000001
R10: ffffffff81ac2360 R11: 0000000000000021 R12: 0000000000000001
R13: 000000111eca7f9f R14: 00000000b4b2c8e7 R15: 000d362a5b7dc64c
FS:  0000000000000000(0000) GS:ffff880001c00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
CR2: ffffffff81712e80 CR3: 0000000001001000 CR4: 00000000000006f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process swapper (pid: 1, threadinfo ffff88007fb46000, task ffff88007fb50000)
Stack:
 0000000000000282 000000000001e50c 0000000000000001 ffffffff81975c00
<0> 0000000000000000 0000000023493c1b 00000000000001b6 0000000000000000
<0> ffff880001c03ec8 ffffffff8105423c ffff880001c03ed8 ffffffff81054249
Call Trace:
 <IRQ> 
 [<ffffffff8105423c>] kvm_clock_read+0x1c/0x20
 [<ffffffff81054249>] kvm_clock_get_cycles+0x9/0x10
 [<ffffffff810991da>] ktime_get+0x6a/0xf0
 [<ffffffff81093cd4>] hrtimer_interrupt+0x54/0x1f0
 [<ffffffff810374cc>] ? call_softirq+0x1c/0x30
 [<ffffffff8104e138>] smp_apic_timer_interrupt+0x68/0xa0
 [<ffffffff81036eb3>] apic_timer_interrupt+0x13/0x20
 <EOI> 
 [<ffffffff810a5bb4>] ? acct_collect+0x164/0x1b0
 [<ffffffff810a5af5>] ? acct_collect+0xa5/0x1b0
 [<ffffffff8107e5bc>] ? do_exit+0x6ec/0x7a0
 [<ffffffff8103a943>] ? oops_end+0xa3/0xb0
 [<ffffffff8105b8a8>] ? no_context+0xe8/0x260
 [<ffffffff810c442d>] ? zone_statistics+0x7d/0xa0
 [<ffffffff8105bb65>] ? __bad_area_nosemaphore+0x145/0x220
 [<ffffffff810b2a01>] ? mempool_alloc_slab+0x11/0x20
 [<ffffffff810b2b30>] ? mempool_alloc+0x60/0x130
 [<ffffffff8105bc4e>] ? bad_area_nosemaphore+0xe/0x10
 [<ffffffff8105c02f>] ? do_page_fault+0x1cf/0x280
 [<ffffffff81702765>] ? page_fault+0x25/0x30
 [<ffffffff81054f73>] ? pvclock_clocksource_read+0x83/0xc0
 [<ffffffff8105423c>] ? kvm_clock_read+0x1c/0x20
 [<ffffffff81054249>] ? kvm_clock_get_cycles+0x9/0x10
 [<ffffffff81099101>] ? ktime_get_ts+0x71/0xe0
 [<ffffffff810add4d>] ? __delayacct_blkio_start+0x1d/0x20
 [<ffffffff8170032a>] ? io_schedule+0x5a/0xd0
 [<ffffffff81117bdd>] ? sync_buffer+0x3d/0x50
 [<ffffffff817008ca>] ? __wait_on_bit+0x5a/0x90
 [<ffffffff81117ba0>] ? sync_buffer+0x0/0x50
 [<ffffffff81117ba0>] ? sync_buffer+0x0/0x50
 [<ffffffff81700974>] ? out_of_line_wait_on_bit+0x74/0x90
 [<ffffffff81090b30>] ? wake_bit_function+0x0/0x40
 [<ffffffff81117b46>] ? __wait_on_buffer+0x26/0x30
 [<ffffffff8116331d>] ? ext3_find_entry+0x19d/0x6b0
 [<ffffffff81060e90>] ? do_flush_tlb_all+0x0/0x70
 [<ffffffff8116418d>] ? ext3_lookup+0x4d/0x130
 [<ffffffff81105203>] ? d_alloc+0x123/0x1b0
 [<ffffffff810f9fe6>] ? do_lookup+0x206/0x260
 [<ffffffff810fbe6b>] ? __link_path_walk+0x19b/0x1000
 [<ffffffff81060eb8>] ? do_flush_tlb_all+0x28/0x70
 [<ffffffff8107fece>] ? on_each_cpu+0x2e/0x50
 [<ffffffff810fcf5e>] ? path_walk+0x6e/0xe0
 [<ffffffff810fd0eb>] ? do_path_lookup+0x5b/0x60
 [<ffffffff810fe015>] ? do_filp_open+0xf5/0xb10
 [<ffffffff810a4026>] ? smp_call_function_many+0x1e6/0x230
 [<ffffffff8105cad0>] ? __cpa_flush_range+0x0/0x30
 [<ffffffff8105caf5>] ? __cpa_flush_range+0x25/0x30
 [<ffffffff8105db73>] ? change_page_attr_set_clr+0x273/0x410
 [<ffffffff81108a5a>] ? alloc_fd+0x4a/0x140
 [<ffffffff810eed7f>] ? do_sys_open+0x7f/0x140
 [<ffffffff810eee6b>] ? sys_open+0x1b/0x20
 [<ffffffff810091ef>] ? init_post+0x3f/0x1b0
 [<ffffffff81a106e5>] ? kernel_init+0x1a2/0x1ba
 [<ffffffff810373ca>] ? child_rip+0xa/0x20
 [<ffffffff81a10543>] ? kernel_init+0x0/0x1ba
 [<ffffffff810373c0>] ? child_rip+0x0/0x20
Code: 78 4f 44 89 e1 48 d3 e0 44 89 f2 48 f7 e2 48 0f ac d0 20 4a 8d 0c 38 44 39 03 75 a4 48 8b 15 15 df 6b 00 48 39 ca 77 17 48 89 d0 <f0> 48 0f b1 0d 04 df 6b 00 48 39 c1 48 89 c2 75 e7 48 89 ca 48 
RIP  [<ffffffff81054f73>] pvclock_clocksource_read+0x83/0xc0
 RSP <ffff880001c03e78>
CR2: ffffffff81712e80
---[ end trace 38f25e02ae34d4c2 ]---
Kernel panic - not syncing: Fatal exception in interrupt
Pid: 1, comm: swapper Tainted: G      D    2.6.32.16-dsa-amd64 #2
Call Trace:
 <IRQ>  [<ffffffff816ff24f>] panic+0xa0/0x171
 [<ffffffff81095095>] ? up+0x35/0x50
 [<ffffffff8107ae7d>] ? release_console_sem+0x1cd/0x220
 [<ffffffff8107b155>] ? console_unblank+0x75/0x90
 [<ffffffff8103a93b>] oops_end+0x9b/0xb0
 [<ffffffff8105b8a8>] no_context+0xe8/0x260
 [<ffffffff8105bb65>] __bad_area_nosemaphore+0x145/0x220
 [<ffffffff810b2a22>] ? mempool_free_slab+0x12/0x20
 [<ffffffff810b2aba>] ? mempool_free+0x8a/0xa0
 [<ffffffff813ec9cb>] ? mix_pool_bytes_extract+0x14b/0x160
 [<ffffffff8105bc4e>] bad_area_nosemaphore+0xe/0x10
 [<ffffffff8105c02f>] do_page_fault+0x1cf/0x280
 [<ffffffff81702765>] page_fault+0x25/0x30
 [<ffffffff81054f73>] ? pvclock_clocksource_read+0x83/0xc0
 [<ffffffff81054f3e>] ? pvclock_clocksource_read+0x4e/0xc0
 [<ffffffff8105423c>] kvm_clock_read+0x1c/0x20
 [<ffffffff81054249>] kvm_clock_get_cycles+0x9/0x10
 [<ffffffff810991da>] ktime_get+0x6a/0xf0
 [<ffffffff81093cd4>] hrtimer_interrupt+0x54/0x1f0
 [<ffffffff810374cc>] ? call_softirq+0x1c/0x30
 [<ffffffff8104e138>] smp_apic_timer_interrupt+0x68/0xa0
 [<ffffffff81036eb3>] apic_timer_interrupt+0x13/0x20
 <EOI>  [<ffffffff810a5bb4>] ? acct_collect+0x164/0x1b0
 [<ffffffff810a5af5>] ? acct_collect+0xa5/0x1b0
 [<ffffffff8107e5bc>] ? do_exit+0x6ec/0x7a0
 [<ffffffff8103a943>] ? oops_end+0xa3/0xb0
 [<ffffffff8105b8a8>] ? no_context+0xe8/0x260
 [<ffffffff810c442d>] ? zone_statistics+0x7d/0xa0
 [<ffffffff8105bb65>] ? __bad_area_nosemaphore+0x145/0x220
 [<ffffffff810b2a01>] ? mempool_alloc_slab+0x11/0x20
 [<ffffffff810b2b30>] ? mempool_alloc+0x60/0x130
 [<ffffffff8105bc4e>] ? bad_area_nosemaphore+0xe/0x10
 [<ffffffff8105c02f>] ? do_page_fault+0x1cf/0x280
 [<ffffffff81702765>] ? page_fault+0x25/0x30
 [<ffffffff81054f73>] ? pvclock_clocksource_read+0x83/0xc0
 [<ffffffff8105423c>] ? kvm_clock_read+0x1c/0x20
 [<ffffffff81054249>] ? kvm_clock_get_cycles+0x9/0x10
 [<ffffffff81099101>] ? ktime_get_ts+0x71/0xe0
 [<ffffffff810add4d>] ? __delayacct_blkio_start+0x1d/0x20
 [<ffffffff8170032a>] ? io_schedule+0x5a/0xd0
 [<ffffffff81117bdd>] ? sync_buffer+0x3d/0x50
 [<ffffffff817008ca>] ? __wait_on_bit+0x5a/0x90
 [<ffffffff81117ba0>] ? sync_buffer+0x0/0x50
 [<ffffffff81117ba0>] ? sync_buffer+0x0/0x50
 [<ffffffff81700974>] ? out_of_line_wait_on_bit+0x74/0x90
 [<ffffffff81090b30>] ? wake_bit_function+0x0/0x40
 [<ffffffff81117b46>] ? __wait_on_buffer+0x26/0x30
 [<ffffffff8116331d>] ? ext3_find_entry+0x19d/0x6b0
 [<ffffffff81060e90>] ? do_flush_tlb_all+0x0/0x70
 [<ffffffff8116418d>] ? ext3_lookup+0x4d/0x130
 [<ffffffff81105203>] ? d_alloc+0x123/0x1b0
 [<ffffffff810f9fe6>] ? do_lookup+0x206/0x260
 [<ffffffff810fbe6b>] ? __link_path_walk+0x19b/0x1000
 [<ffffffff81060eb8>] ? do_flush_tlb_all+0x28/0x70
 [<ffffffff8107fece>] ? on_each_cpu+0x2e/0x50
 [<ffffffff810fcf5e>] ? path_walk+0x6e/0xe0
 [<ffffffff810fd0eb>] ? do_path_lookup+0x5b/0x60
 [<ffffffff810fe015>] ? do_filp_open+0xf5/0xb10
 [<ffffffff810a4026>] ? smp_call_function_many+0x1e6/0x230
 [<ffffffff8105cad0>] ? __cpa_flush_range+0x0/0x30
 [<ffffffff8105caf5>] ? __cpa_flush_range+0x25/0x30
 [<ffffffff8105db73>] ? change_page_attr_set_clr+0x273/0x410
 [<ffffffff81108a5a>] ? alloc_fd+0x4a/0x140
 [<ffffffff810eed7f>] ? do_sys_open+0x7f/0x140
 [<ffffffff810eee6b>] ? sys_open+0x1b/0x20
 [<ffffffff810091ef>] ? init_post+0x3f/0x1b0
 [<ffffffff81a106e5>] ? kernel_init+0x1a2/0x1ba
 [<ffffffff810373ca>] ? child_rip+0xa/0x20
 [<ffffffff81a10543>] ? kernel_init+0x0/0x1ba
 [<ffffffff810373c0>] ? child_rip+0x0/0x20

[Also available at http://asteria.noreply.org/~weasel/volatile/2010-07-13-CQL4Lj0xCNo/typescript.zoe.kvmclock.panic ]
-- 
                           |  .''`.  ** Debian GNU/Linux **
      Peter Palfrader      | : :' :      The  universal
 http://www.palfrader.org/ | `. `'      Operating System
                           |   `-    http://www.debian.org/
