Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756014Ab1K2QuQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Nov 2011 11:50:16 -0500
Received: from lo.gmane.org ([80.91.229.12]:56229 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754671Ab1K2QuO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Nov 2011 11:50:14 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Jack Byer <ftn768@gmail.com>
Subject: Re: Kernel oops on bootup if initramfs built with udev version higher than 163
Date: Tue, 29 Nov 2011 10:42:36 -0600
Message-ID: <jb321t$5o9$2@dough.gmane.org>
References: <CAHxD=PC-rvD_zBmp-VHvxNCe_sgXDGHDYwajdn_ukAFqK0eDOg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7Bit
X-Complaints-To: usenet@dough.gmane.org
X-Gmane-NNTP-Posting-Host: cpe-76-183-217-112.tx.res.rr.com
User-Agent: KNode/4.7.3
Cc: linux-hotplug@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jack Byer wrote:

> My computer hangs on bootup if I build my initramfs with a version of
> udev higher than 163. I've obtained a boot log by using the serial
> console and uploaded the results here:
> 
> Successful boot: http://pastebin.com/UUEHqjge
> Failed boot: http://pastebin.com/ZEp1ni3Z
> 
> The only difference between the two cases is the version of udev used
> to build the initramfs - both kernel images are the same. If I boot an
> initramfs that uses an old version of udev but then have a newer
> version installed in the OS it does not cause any problems.
> 
> I've been working around this problem for a long time first by
> temporarily downgrading udev each time I needed to build a new
> initramfs and later by building kernel images that didn't need modules
> to boot so that I could keep using the same initramfs across kernel
> upgrades. Now that I have a working serial console to capture the boot
> sequence I'd like to see if there's any information I can provide that
> would enable the problem to be fixed the right way.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-hotplug"
> in the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Unpacking initramfs...
Freeing initrd memory: 4404k freed
PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
Placing 64MB software IO TLB between ffff8800bbf7a000 - ffff8800bff7a000
software IO TLB at phys 0xbbf7a000 - 0xbff7a000
BUG: unable to handle kernel NULL pointer dereference at           (null)
IP: [<ffffffff81073edf>] futex_wake+0x8f/0x130
PGD 13b0fa067 PUD 13b0fe067 PMD 0
Oops: 0000 [#1] PREEMPT SMP
CPU 1
Modules linked in:

Pid: 396, comm: udevadm Not tainted 3.1.3+ #19 System manufacturer System 
Product Name/P5P43TD
RIP: 0010:[<ffffffff81073edf>]  [<ffffffff81073edf>] futex_wake+0x8f/0x130
RSP: 0018:ffff88013a855d58  EFLAGS: 00010282
RAX: 0000000000000000 RBX: 00000000ffffffff RCX: 00000000df6a7233
RDX: ffffffff81830568 RSI: 00000000ca6a7945 RDI: ffffffffffffffe8
RBP: ffff88013a855db8 R08: 000000007b966a6a R09: 0000000000000000
R10: 00007fffc49d57d0 R11: 0000000000000202 R12: 0000000000000001
R13: ffff88013a855d68 R14: 0000000000000000 R15: 0000000000000000
FS:  00007f1f82b40700(0000) GS:ffff88013fc80000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000000000 CR3: 000000013b0f6000 CR4: 00000000000406e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process udevadm (pid: 396, threadinfo ffff88013a854000, task 
ffff88013b0e56a0)
Stack:
 ffff88013a855de8 ffffffff81830560 00007fffc49d5000 ffff88013b3e8000
 00000000000008fc ffffea0004ff67c0 ffff88013a855da8 0000000000000000
 00007fffc49d58fc 0000000000000001 0000000000000001 0000000000000000
Call Trace:
 [<ffffffff81075880>] do_futex+0xf0/0xba0
 [<ffffffff810c3570>] ? handle_mm_fault+0x130/0x220
 [<ffffffff81023c24>] ? do_page_fault+0x194/0x460
 [<ffffffff810fb87a>] ? mntput+0x1a/0x30
 [<ffffffff810d915d>] ? kmem_cache_free+0x8d/0x90
 [<ffffffff810763a6>] sys_futex+0x76/0x170
 [<ffffffff8149ba7b>] system_call_fastpath+0x16/0x1b
Code: 85 c0 75 d0 4c 89 ef e8 90 ef ff ff 48 89 c7 48 89 45 a8 e8 24 6d 42 
00 48 8b 55 a8 48 8b 42 08 48 83 c2 08 48 8d 78 e8 48 39 c2 <4c> 8b 7f 18 74 
6b 49 83 ef 18 eb 19 0f 1f 44 00 00 49 8d 47 18
RIP  [<ffffffff81073edf>] futex_wake+0x8f/0x130
 RSP <ffff88013a855d58>
CR2: 0000000000000000
BUG: unable to handle kernel
---[ end trace bb26011d21a2b1cd ]---
note: udevadm[396] exited with preempt_count 1
NULL pointer dereference at           (null)
IP: [<ffffffff81073edf>] futex_wake+0x8f/0x130
PGD 1365dc067 PUD 13a86f067 PMD 0
Oops: 0000 [#2] PREEMPT SMP
CPU 2
Modules linked in:

Pid: 397, comm: udevadm Tainted: G      D     3.1.3+ #19 System manufacturer 
System Product Name/P5P43TD
RIP: 0010:[<ffffffff81073edf>]  [<ffffffff81073edf>] futex_wake+0x8f/0x130
RSP: 0018:ffff88013a857d58  EFLAGS: 00010282
RAX: 0000000000000000 RBX: 00000000ffffffff RCX: 000000000dad1a55
RDX: ffffffff818319a8 RSI: 00000000a9b9f48e RDI: ffffffffffffffe8
RBP: ffff88013a857db8 R08: 000000007090b2af R09: 0000000000000000
R10: 00007fffe2052630 R11: 0000000000000202 R12: 0000000000000001
R13: ffff88013a857d68 R14: 0000000000000000 R15: 0000000000000000
FS:  00007fab813bd700(0000) GS:ffff88013fd00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000000000 CR3: 000000013b3f6000 CR4: 00000000000406e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process udevadm (pid: 397, threadinfo ffff88013a856000, task 
ffff88013b0c37b0)
Stack:
 ffff88013a857de8 ffffffff818319a0 00007fffe2052000 ffff8801355ec000
 000000000000075c ffffea0004ff6940 ffff88013a857da8 0000000000000000
 00007fffe205275c 0000000000000001 0000000000000001 0000000000000000
Call Trace:
 [<ffffffff81075880>] do_futex+0xf0/0xba0
 [<ffffffff810c3570>] ? handle_mm_fault+0x130/0x220
 [<ffffffff81023c24>] ? do_page_fault+0x194/0x460
 [<ffffffff810fb87a>] ? mntput+0x1a/0x30
 [<ffffffff810d915d>] ? kmem_cache_free+0x8d/0x90
 [<ffffffff810763a6>] sys_futex+0x76/0x170
 [<ffffffff8149ba7b>] system_call_fastpath+0x16/0x1b
Code: 85 c0 75 d0 4c 89 ef e8 90 ef ff ff 48 89 c7 48 89 45 a8 e8 24 6d 42 
00 48 8b 55 a8 48 8b 42 08 48 83 c2 08 48 8d 78 e8 48 39 c2 <4c> 8b 7f 18 74 
6b 49 83 ef 18 eb 19 0f 1f 44 00 00 49 8d 47 18
RIP  [<ffffffff81073edf>] futex_wake+0x8f/0x130
 RSP <ffff88013a857d58>
CR2: 0000000000000000
BUG: unable to handle kernel
---[ end trace bb26011d21a2b1ce ]---
note: udevadm[397] exited with preempt_count 1
NULL pointer dereference at           (null)
IP: [<ffffffff81073edf>] futex_wake+0x8f/0x130
PGD 135977067 PUD 13598d067 PMD 0
Oops: 0000 [#3] PREEMPT SMP
CPU 0
Modules linked in:

Pid: 398, comm: udevadm Tainted: G      D     3.1.3+ #19 System manufacturer 
System Product Name/P5P43TD
RIP: 0010:[<ffffffff81073edf>]  [<ffffffff81073edf>] futex_wake+0x8f/0x130
RSP: 0018:ffff8801365c9d58  EFLAGS: 00010282
RAX: 0000000000000000 RBX: 00000000ffffffff RCX: 00000000b3bb95ce
RDX: ffffffff81831558 RSI: 00000000471d223f RDI: ffffffffffffffe8
RBP: ffff8801365c9db8 R08: 000000004715524e R09: 0000000000000000
R10: 00007fff7fc08050 R11: 0000000000000202 R12: 0000000000000001
R13: ffff8801365c9d68 R14: 0000000000000000 R15: 0000000000000000
FS:  00007fc8dfe9f700(0000) GS:ffff88013fc00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000000000 CR3: 0000000135a6f000 CR4: 00000000000406f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process udevadm (pid: 398, threadinfo ffff8801365c8000, task 
ffff88013b0c3de0)
Stack:
 ffff8801365c9de8 ffffffff81831550 00007fff7fc08000 ffff8801365cc000
 000000000000017c ffffea0004ff28c0 ffff8801365c9da8 0000000000000000
 00007fff7fc0817c 0000000000000001 0000000000000001 0000000000000000
Call Trace:
 [<ffffffff81075880>] do_futex+0xf0/0xba0
 [<ffffffff810c3570>] ? handle_mm_fault+0x130/0x220
 [<ffffffff81023c24>] ? do_page_fault+0x194/0x460
 [<ffffffff810fb87a>] ? mntput+0x1a/0x30
 [<ffffffff810d915d>] ? kmem_cache_free+0x8d/0x90
 [<ffffffff810763a6>] sys_futex+0x76/0x170
 [<ffffffff8149ba7b>] system_call_fastpath+0x16/0x1b
Code: 85 c0 75 d0 4c 89 ef e8 90 ef ff ff 48 89 c7 48 89 45 a8 e8 24 6d 42 
00 48 8b 55 a8 48 8b 42 08 48 83 c2 08 48 8d 78 e8 48 39 c2 <4c> 8b 7f 18 74 
6b 49 83 ef 18 eb 19 0f 1f 44 00 00 49 8d 47 18
RIP  [<ffffffff81073edf>] futex_wake+0x8f/0x130
 RSP <ffff8801365c9d58>
CR2: 0000000000000000
BUG: unable to handle kernel
---[ end trace bb26011d21a2b1cf ]---
note: udevadm[398] exited with preempt_count 1
BUG: scheduling while atomic: udevadm/398/0x10000002
Modules linked in:
Pid: 398, comm: udevadm Tainted: G      D     3.1.3+ #19
Call Trace:
 [<ffffffff8103b47c>] __schedule_bug+0x5c/0x60
 [<ffffffff81498dd1>] __schedule+0x6b1/0x8b0
 [<ffffffff8125749f>] ? symbol_string.clone.7+0x7f/0xe0
 [<ffffffff81255d19>] ? put_dec+0x59/0x60
 [<ffffffff81257091>] ? number.clone.2+0x311/0x350
 [<ffffffff8103fbe5>] __cond_resched+0x25/0x40
 [<ffffffff8149904c>] _cond_resched+0x2c/0x40
 [<ffffffff810c241d>] unmap_vmas+0x4ed/0x6d0
 [<ffffffff810c90d8>] exit_mmap+0xa8/0x110
 [<ffffffff81047bb7>] ? console_trylock+0x17/0x70
 [<ffffffff8149b0e7>] ? _raw_spin_unlock+0x27/0x30
 [<ffffffff8104501d>] mmput+0x2d/0xe0
 [<ffffffff810495bf>] exit_mm+0x10f/0x140
 [<ffffffff8149b068>] ? _raw_spin_unlock_irq+0x28/0x40
 [<ffffffff8104acc1>] do_exit+0x141/0x7e0
 [<ffffffff81005455>] oops_end+0x75/0xa0
 [<ffffffff81023480>] no_context+0xf0/0x260
 [<ffffffff81023715>] __bad_area_nosemaphore+0x125/0x210
 [<ffffffff8102380e>] bad_area_nosemaphore+0xe/0x10
 [<ffffffff81023e32>] do_page_fault+0x3a2/0x460
 [<ffffffff810ae64d>] ? __alloc_pages_nodemask+0x10d/0x700
 [<ffffffff8149b66f>] page_fault+0x1f/0x30
 [<ffffffff81073edf>] ? futex_wake+0x8f/0x130
 [<ffffffff81073ecc>] ? futex_wake+0x7c/0x130
 [<ffffffff81075880>] do_futex+0xf0/0xba0
 [<ffffffff810c3570>] ? handle_mm_fault+0x130/0x220
 [<ffffffff81023c24>] ? do_page_fault+0x194/0x460
 [<ffffffff810fb87a>] ? mntput+0x1a/0x30
 [<ffffffff810d915d>] ? kmem_cache_free+0x8d/0x90
 [<ffffffff810763a6>] sys_futex+0x76/0x170
 [<ffffffff8149ba7b>] system_call_fastpath+0x16/0x1b
NULL pointer dereference at           (null)
IP: [<ffffffff81073edf>] futex_wake+0x8f/0x130
PGD 13b226067 PUD 13b0de067 PMD 0
Oops: 0000 [#4] PREEMPT SMP
CPU 3
Modules linked in:

Pid: 399, comm: udevadm Tainted: G      D     3.1.3+ #19 System manufacturer 
System Product Name/P5P43TD
RIP: 0010:[<ffffffff81073edf>]  [<ffffffff81073edf>] futex_wake+0x8f/0x130
RSP: 0018:ffff8801365dfd58  EFLAGS: 00010286
RAX: 0000000000000000 RBX: 00000000ffffffff RCX: 0000000087aedf7b
RDX: ffffffff818306a0 RSI: 0000000097e1e27b RDI: ffffffffffffffe8
RBP: ffff8801365dfdb8 R08: 000000007aeaca4f R09: 0000000000000000
R10: 00007fff98763d50 R11: 0000000000000202 R12: 0000000000000001
R13: ffff8801365dfd68 R14: 0000000000000000 R15: 0000000000000000
FS:  00007fafd4ae7700(0000) GS:ffff88013fd80000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000000000 CR3: 000000013b0e8000 CR4: 00000000000406e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process udevadm (pid: 399, threadinfo ffff8801365de000, task 
ffff88013b0c4410)
Stack:
 ffff8801365dfde8 ffffffff81830698 00007fff98763000 ffff88013a8b4000
 0000000000000e7c ffffea0004ff4b80 ffff8801365dfda8 0000000000000000
 00007fff98763e7c 0000000000000001 0000000000000001 0000000000000000
Call Trace:
 [<ffffffff81075880>] do_futex+0xf0/0xba0
 [<ffffffff810c3570>] ? handle_mm_fault+0x130/0x220
 [<ffffffff81023c24>] ? do_page_fault+0x194/0x460
 [<ffffffff810fb87a>] ? mntput+0x1a/0x30
 [<ffffffff810d915d>] ? kmem_cache_free+0x8d/0x90
 [<ffffffff810763a6>] sys_futex+0x76/0x170
 [<ffffffff8149ba7b>] system_call_fastpath+0x16/0x1b
Code: 85 c0 75 d0 4c 89 ef e8 90 ef ff ff 48 89 c7 48 89 45 a8 e8 24 6d 42 
00 48 8b 55 a8 48 8b 42 08 48 83 c2 08 48 8d 78 e8 48 39 c2 <4c> 8b 7f 18 74 
6b 49 83 ef 18 eb 19 0f 1f 44 00 00 49 8d 47 18
RIP  [<ffffffff81073edf>] futex_wake+0x8f/0x130
 RSP <ffff8801365dfd58>
CR2: 0000000000000000
BUG: unable to handle kernel
---[ end trace bb26011d21a2b1d0 ]---
note: udevadm[399] exited with preempt_count 1
NULL pointer dereference at           (null)
IP: [<ffffffff81073edf>] futex_wake+0x8f/0x130
PGD 13b3ff067 PUD 13b0fa067 PMD 0
Oops: 0000 [#5] PREEMPT SMP
CPU 1
Modules linked in:

Pid: 400, comm: udevadm Tainted: G      D     3.1.3+ #19 System manufacturer 
System Product Name/P5P43TD
RIP: 0010:[<ffffffff81073edf>]  [<ffffffff81073edf>] futex_wake+0x8f/0x130
RSP: 0018:ffff8801365cbd58  EFLAGS: 00010286
RAX: 0000000000000000 RBX: 00000000ffffffff RCX: 000000009a742934
RDX: ffffffff81831060 RSI: 000000001ce215be RDI: ffffffffffffffe8
RBP: ffff8801365cbdb8 R08: 00000000d427fdfd R09: 0000000000000000
R10: 00007fff749eca30 R11: 0000000000000202 R12: 0000000000000001
R13: ffff8801365cbd68 R14: 0000000000000000 R15: 0000000000000000
FS:  00007f587cf0f700(0000) GS:ffff88013fc80000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000000000 CR3: 000000013b0ff000 CR4: 00000000000406e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process udevadm (pid: 400, threadinfo ffff8801365ca000, task 
ffff88013b0c4a40)
Stack:
 ffff8801365cbde8 ffffffff81831058 00007fff749ec000 ffff88013b3e8340
 0000000000000b5c ffffea0004ff4640 ffff8801365cbda8 0000000000000000
 00007fff749ecb5c 0000000000000001 0000000000000001 0000000000000000
Call Trace:
 [<ffffffff81075880>] do_futex+0xf0/0xba0
 [<ffffffff810c3570>] ? handle_mm_fault+0x130/0x220
 [<ffffffff81023c24>] ? do_page_fault+0x194/0x460
 [<ffffffff810fb87a>] ? mntput+0x1a/0x30
 [<ffffffff810d915d>] ? kmem_cache_free+0x8d/0x90
 [<ffffffff810763a6>] sys_futex+0x76/0x170
 [<ffffffff8149ba7b>] system_call_fastpath+0x16/0x1b
Code: 85 c0 75 d0 4c 89 ef e8 90 ef ff ff 48 89 c7 48 89 45 a8 e8 24 6d 42 
00 48 8b 55 a8 48 8b 42 08 48 83 c2 08 48 8d 78 e8 48 39 c2 <4c> 8b 7f 18 74 
6b 49 83 ef 18 eb 19 0f 1f 44 00 00 49 8d 47 18
RIP  [<ffffffff81073edf>] futex_wake+0x8f/0x130
 RSP <ffff8801365cbd58>
CR2: 0000000000000000
BUG: unable to handle kernel
---[ end trace bb26011d21a2b1d1 ]---
note: udevadm[400] exited with preempt_count 1
Refined TSC clocksource calibration: 2333.333 MHz.
Switching to clocksource tsc
NULL pointer dereference at           (null)
IP: [<ffffffff81073edf>] futex_wake+0x8f/0x130
PGD 13587b067 PUD 135977067 PMD 0
Oops: 0000 [#6] PREEMPT SMP
CPU 0
Modules linked in:

Pid: 401, comm: udevadm Tainted: G      D     3.1.3+ #19 System manufacturer 
System Product Name/P5P43TD
RIP: 0010:[<ffffffff81073edf>]  [<ffffffff81073edf>] futex_wake+0x8f/0x130
RSP: 0018:ffff8801365f1d58  EFLAGS: 00010282
RAX: 0000000000000000 RBX: 00000000ffffffff RCX: 000000009f14cdff
RDX: ffffffff81831a98 RSI: 0000000011a0c663 RDI: ffffffffffffffe8
RBP: ffff8801365f1db8 R08: 00000000b88582c9 R09: 0000000000000000
R10: 00007fff14b3dc40 R11: 0000000000000202 R12: 0000000000000001
R13: ffff8801365f1d68 R14: 0000000000000000 R15: 0000000000000000
FS:  00007f697cd3b700(0000) GS:ffff88013fc00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000000000 CR3: 000000013584d000 CR4: 00000000000406f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process udevadm (pid: 401, threadinfo ffff8801365f0000, task 
ffff88013b0c5070)
Stack:
 ffff8801365f1de8 ffffffff81831a90 00007fff14b3d000 ffff8801365cc340
 0000000000000d6c ffffea0004fdf800 ffff8801365f1da8 0000000000000000
 00007fff14b3dd6c 0000000000000001 0000000000000001 0000000000000000
Call Trace:
 [<ffffffff81075880>] do_futex+0xf0/0xba0
 [<ffffffff810c3570>] ? handle_mm_fault+0x130/0x220
 [<ffffffff81023c24>] ? do_page_fault+0x194/0x460
 [<ffffffff810fb87a>] ? mntput+0x1a/0x30
 [<ffffffff810d915d>] ? kmem_cache_free+0x8d/0x90
 [<ffffffff810763a6>] sys_futex+0x76/0x170
 [<ffffffff8149ba7b>] system_call_fastpath+0x16/0x1b
Code: 85 c0 75 d0 4c 89 ef e8 90 ef ff ff 48 89 c7 48 89 45 a8 e8 24 6d 42 
00 48 8b 55 a8 48 8b 42 08 48 83 c2 08 48 8d 78 e8 48 39 c2 <4c> 8b 7f 18 74 
6b 49 83 ef 18 eb 19 0f 1f 44 00 00 49 8d 47 18
RIP  [<ffffffff81073edf>] futex_wake+0x8f/0x130
 RSP <ffff8801365f1d58>
CR2: 0000000000000000
---[ end trace bb26011d21a2b1d2 ]---
note: udevadm[401] exited with preempt_count 1
BUG: scheduling while atomic: udevadm/401/0x10000002
Modules linked in:
Pid: 401, comm: udevadm Tainted: G      D     3.1.3+ #19
Call Trace:
 [<ffffffff8103b47c>] __schedule_bug+0x5c/0x60
 [<ffffffff81498dd1>] __schedule+0x6b1/0x8b0
 [<ffffffff81258a21>] ? delay_tsc+0xd1/0xe0
 [<ffffffff8149b0a9>] ? _raw_spin_unlock_irqrestore+0x29/0x40
 [<ffffffff81281d77>] ? vgacon_scroll+0x157/0x340
 [<ffffffff81068fcc>] ? __atomic_notifier_call_chain+0x4c/0x70
 [<ffffffff8103fbe5>] __cond_resched+0x25/0x40
 [<ffffffff8149904c>] _cond_resched+0x2c/0x40
 [<ffffffff810c241d>] unmap_vmas+0x4ed/0x6d0
 [<ffffffff810c90d8>] exit_mmap+0xa8/0x110
 [<ffffffff81048317>] ? vprintk+0x357/0x4a0
 [<ffffffff8104501d>] mmput+0x2d/0xe0
 [<ffffffff810495bf>] exit_mm+0x10f/0x140
 [<ffffffff8149b068>] ? _raw_spin_unlock_irq+0x28/0x40
 [<ffffffff8104acc1>] do_exit+0x141/0x7e0
 [<ffffffff81005455>] oops_end+0x75/0xa0
 [<ffffffff81023480>] no_context+0xf0/0x260
 [<ffffffff81023715>] __bad_area_nosemaphore+0x125/0x210
 [<ffffffff8102380e>] bad_area_nosemaphore+0xe/0x10
 [<ffffffff81023e32>] do_page_fault+0x3a2/0x460
 [<ffffffff810ae64d>] ? __alloc_pages_nodemask+0x10d/0x700
 [<ffffffff8149b66f>] page_fault+0x1f/0x30
 [<ffffffff81073edf>] ? futex_wake+0x8f/0x130
 [<ffffffff81073ecc>] ? futex_wake+0x7c/0x130
 [<ffffffff81075880>] do_futex+0xf0/0xba0
 [<ffffffff810c3570>] ? handle_mm_fault+0x130/0x220
 [<ffffffff81023c24>] ? do_page_fault+0x194/0x460
 [<ffffffff810fb87a>] ? mntput+0x1a/0x30
 [<ffffffff810d915d>] ? kmem_cache_free+0x8d/0x90
 [<ffffffff810763a6>] sys_futex+0x76/0x170
 [<ffffffff8149ba7b>] system_call_fastpath+0x16/0x1b
BUG: unable to handle kernel NULL pointer dereference at           (null)
IP: [<ffffffff81073edf>] futex_wake+0x8f/0x130
PGD 13b0f9067 PUD 13b0f8067 PMD 0
Oops: 0000 [#7] PREEMPT SMP
CPU 1
Modules linked in:

Pid: 402, comm: udevadm Tainted: G      D     3.1.3+ #19 System manufacturer 
System Product Name/P5P43TD
RIP: 0010:[<ffffffff81073edf>]  [<ffffffff81073edf>] futex_wake+0x8f/0x130
RSP: 0018:ffff8801365c9d58  EFLAGS: 00010282
RAX: 0000000000000000 RBX: 00000000ffffffff RCX: 000000001ef2fa89
RDX: ffffffff818316a8 RSI: 00000000a60d8470 RDI: ffffffffffffffe8
RBP: ffff8801365c9db8 R08: 00000000d84dde6a R09: 0000000000000000
R10: 00007fff9a9f47e0 R11: 0000000000000202 R12: 0000000000000001
R13: ffff8801365c9d68 R14: 0000000000000000 R15: 0000000000000000
FS:  00007f81b21e2700(0000) GS:ffff88013fc80000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000000000 CR3: 000000013b3ff000 CR4: 00000000000406e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process udevadm (pid: 402, threadinfo ffff8801365c8000, task 
ffff88013b0e5cd0)
Stack:
 ffff8801365c9de8 ffffffff818316a0 00007fff9a9f4000 ffff88013b3e8000
 000000000000090c ffffea0004ff6680 ffff8801365c9da8 0000000000000000
 00007fff9a9f490c 0000000000000001 0000000000000001 0000000000000000
Call Trace:
 [<ffffffff81075880>] do_futex+0xf0/0xba0
 [<ffffffff810c3570>] ? handle_mm_fault+0x130/0x220
 [<ffffffff81023c24>] ? do_page_fault+0x194/0x460
 [<ffffffff810fb87a>] ? mntput+0x1a/0x30
 [<ffffffff810d915d>] ? kmem_cache_free+0x8d/0x90
 [<ffffffff810763a6>] sys_futex+0x76/0x170
 [<ffffffff8149ba7b>] system_call_fastpath+0x16/0x1b
Code: 85 c0 75 d0 4c 89 ef e8 90 ef ff ff 48 89 c7 48 89 45 a8 e8 24 6d 42 
00 48 8b 55 a8 48 8b 42 08 48 83 c2 08 48 8d 78 e8 48 39 c2 <4c> 8b 7f 18 74 
6b 49 83 ef 18 eb 19 0f 1f 44 00 00 49 8d 47 18
RIP  [<ffffffff81073edf>] futex_wake+0x8f/0x130
 RSP <ffff8801365c9d58>
CR2: 0000000000000000
BUG: unable to handle kernel
---[ end trace bb26011d21a2b1d3 ]---
note: udevadm[402] exited with preempt_count 1
BUG: scheduling while atomic: udevadm/402/0x10000002
Modules linked in:
Pid: 402, comm: udevadm Tainted: G      D     3.1.3+ #19
Call Trace:
 [<ffffffff8103b47c>] __schedule_bug+0x5c/0x60
 [<ffffffff81498dd1>] __schedule+0x6b1/0x8b0
 [<ffffffff8125749f>] ? symbol_string.clone.7+0x7f/0xe0
 [<ffffffff81255d19>] ? put_dec+0x59/0x60
 [<ffffffff81257091>] ? number.clone.2+0x311/0x350
 [<ffffffff8103fbe5>] __cond_resched+0x25/0x40
 [<ffffffff8149904c>] _cond_resched+0x2c/0x40
 [<ffffffff810c241d>] unmap_vmas+0x4ed/0x6d0
 [<ffffffff810c90d8>] exit_mmap+0xa8/0x110
 [<ffffffff81047bb7>] ? console_trylock+0x17/0x70
 [<ffffffff8149b0e7>] ? _raw_spin_unlock+0x27/0x30
 [<ffffffff8104501d>] mmput+0x2d/0xe0
 [<ffffffff810495bf>] exit_mm+0x10f/0x140
 [<ffffffff8149b068>] ? _raw_spin_unlock_irq+0x28/0x40
 [<ffffffff8104acc1>] do_exit+0x141/0x7e0
 [<ffffffff81005455>] oops_end+0x75/0xa0
 [<ffffffff81023480>] no_context+0xf0/0x260
 [<ffffffff81023715>] __bad_area_nosemaphore+0x125/0x210
 [<ffffffff8102380e>] bad_area_nosemaphore+0xe/0x10
 [<ffffffff81023e32>] do_page_fault+0x3a2/0x460
 [<ffffffff810ae64d>] ? __alloc_pages_nodemask+0x10d/0x700
 [<ffffffff8149b66f>] page_fault+0x1f/0x30
 [<ffffffff81073edf>] ? futex_wake+0x8f/0x130
 [<ffffffff81073ecc>] ? futex_wake+0x7c/0x130
 [<ffffffff81075880>] do_futex+0xf0/0xba0
 [<ffffffff810c3570>] ? handle_mm_fault+0x130/0x220
 [<ffffffff81023c24>] ? do_page_fault+0x194/0x460
 [<ffffffff810fb87a>] ? mntput+0x1a/0x30
 [<ffffffff810d915d>] ? kmem_cache_free+0x8d/0x90
 [<ffffffff810763a6>] sys_futex+0x76/0x170
 [<ffffffff8149ba7b>] system_call_fastpath+0x16/0x1b
NULL pointer dereference at           (null)
IP: [<ffffffff81073edf>] futex_wake+0x8f/0x130
PGD 13591c067 PUD 13587b067 PMD 0
Oops: 0000 [#8] PREEMPT SMP
CPU 2
Pid: 403, comm: udevadm Tainted: G      D     3.1.3+ #19 System manufacturer 
System Product Name/P5P43TD
RIP: 0010:[<ffffffff81073edf>]  [<ffffffff81073edf>] futex_wake+0x8f/0x130
RSP: 0018:ffff8801365dfd58  EFLAGS: 00010286
RAX: 0000000000000000 RBX: 00000000ffffffff RCX: 00000000a597499f
RDX: ffffffff818303b8 RSI: 000000004e6fa002 RDI: ffffffffffffffe8
RBP: ffff8801365dfdb8 R08: 000000007a2004e3 R09: 0000000000000000
R10: 00007fffa6027d40 R11: 0000000000000202 R12: 0000000000000001
R13: ffff8801365dfd68 R14: 0000000000000000 R15: 0000000000000000
FS:  00007f0816203700(0000) GS:ffff88013fd00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000000000 CR3: 000000013b3e1000 CR4: 00000000000406e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process udevadm (pid: 403, threadinfo ffff8801365de000, task 
ffff88013b0c3de0)
Stack:
 ffff8801365dfde8 ffffffff818303b0 00007fffa6027000 ffff8801355ec340
 0000000000000e6c ffffea0004ff6840 ffff8801365dfda8 0000000000000000
 00007fffa6027e6c 0000000000000001 0000000000000001 0000000000000000
Call Trace:
 [<ffffffff81075880>] do_futex+0xf0/0xba0
 [<ffffffff810c3570>] ? handle_mm_fault+0x130/0x220
 [<ffffffff81023c24>] ? do_page_fault+0x194/0x460
 [<ffffffff810fb87a>] ? mntput+0x1a/0x30
 [<ffffffff810d915d>] ? kmem_cache_free+0x8d/0x90
 [<ffffffff810763a6>] sys_futex+0x76/0x170
 [<ffffffff8149ba7b>] system_call_fastpath+0x16/0x1b
Code: 85 c0 75 d0 4c 89 ef e8 90 ef ff ff 48 89 c7 48 89 45 a8 e8 24 6d 42 
00 48 8b 55 a8 48 8b 42 08 48 83 c2 08 48 8d 78 e8 48 39 c2 <4c> 8b 7f 18 74 
6b 49 83 ef 18 eb 19 0f 1f 44 00 00 49 8d 47 18
RIP  [<ffffffff81073edf>] futex_wake+0x8f/0x130
 RSP <ffff8801365dfd58>
CR2: 0000000000000000
BUG: unable to handle kernel
---[ end trace bb26011d21a2b1d4 ]---
note: udevadm[403] exited with preempt_count 1
BUG: scheduling while atomic: udevadm/403/0x10000002
Modules linked in:
Pid: 403, comm: udevadm Tainted: G      D     3.1.3+ #19
Call Trace:
 [<ffffffff8103b47c>] __schedule_bug+0x5c/0x60
 [<ffffffff81498dd1>] __schedule+0x6b1/0x8b0
 [<ffffffff8125749f>] ? symbol_string.clone.7+0x7f/0xe0
 [<ffffffff81255d19>] ? put_dec+0x59/0x60
 [<ffffffff81257091>] ? number.clone.2+0x311/0x350
 [<ffffffff8149b0a9>] ? _raw_spin_unlock_irqrestore+0x29/0x40
 [<ffffffff8103fbe5>] __cond_resched+0x25/0x40
 [<ffffffff8149904c>] _cond_resched+0x2c/0x40
 [<ffffffff810c241d>] unmap_vmas+0x4ed/0x6d0
 [<ffffffff810c90d8>] exit_mmap+0xa8/0x110
 [<ffffffff81047bb7>] ? console_trylock+0x17/0x70
 [<ffffffff8149b0e7>] ? _raw_spin_unlock+0x27/0x30
 [<ffffffff8104501d>] mmput+0x2d/0xe0
 [<ffffffff810495bf>] exit_mm+0x10f/0x140
 [<ffffffff8149b068>] ? _raw_spin_unlock_irq+0x28/0x40
 [<ffffffff8104acc1>] do_exit+0x141/0x7e0
 [<ffffffff81005455>] oops_end+0x75/0xa0
 [<ffffffff81023480>] no_context+0xf0/0x260
 [<ffffffff81023715>] __bad_area_nosemaphore+0x125/0x210
 [<ffffffff8102380e>] bad_area_nosemaphore+0xe/0x10
 [<ffffffff81023e32>] do_page_fault+0x3a2/0x460
 [<ffffffff810ae64d>] ? __alloc_pages_nodemask+0x10d/0x700
 [<ffffffff8149b66f>] page_fault+0x1f/0x30
 [<ffffffff81073edf>] ? futex_wake+0x8f/0x130
 [<ffffffff81073ecc>] ? futex_wake+0x7c/0x130
 [<ffffffff81075880>] do_futex+0xf0/0xba0
 [<ffffffff810c3570>] ? handle_mm_fault+0x130/0x220
 [<ffffffff81023c24>] ? do_page_fault+0x194/0x460
 [<ffffffff810fb87a>] ? mntput+0x1a/0x30
 [<ffffffff810d915d>] ? kmem_cache_free+0x8d/0x90
 [<ffffffff810763a6>] sys_futex+0x76/0x170
 [<ffffffff8149ba7b>] system_call_fastpath+0x16/0x1b
NULL pointer dereference at           (null)
IP: [<ffffffff81073edf>] futex_wake+0x8f/0x130
PGD 135ff4067 PUD 13580a067 PMD 0
Oops: 0000 [#9] PREEMPT SMP
CPU 0
Pid: 404, comm: udevadm Tainted: G      D     3.1.3+ #19 System manufacturer 
System Product Name/P5P43TD
RIP: 0010:[<ffffffff81073edf>]  [<ffffffff81073edf>] futex_wake+0x8f/0x130
RSP: 0018:ffff88013a84fd58  EFLAGS: 00010282
RAX: 0000000000000000 RBX: 00000000ffffffff RCX: 000000005c20e87e
RDX: ffffffff81831840 RSI: 0000000031155031 RDI: ffffffffffffffe8
RBP: ffff88013a84fdb8 R08: 00000000dd9ec215 R09: 0000000000000000
R10: 00007fff0b9b66f0 R11: 0000000000000202 R12: 0000000000000001
R13: ffff88013a84fd68 R14: 0000000000000000 R15: 0000000000000000
FS:  00007ff1ee290700(0000) GS:ffff88013fc00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000000000 CR3: 0000000135836000 CR4: 00000000000406f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process udevadm (pid: 404, threadinfo ffff88013a84e000, task 
ffff88013b0c56a0)
Stack:
 ffff88013a84fde8 ffffffff81831838 00007fff0b9b6000 ffff8801365cc000
 000000000000081c ffffea0004ff2e40 ffff88013a84fda8 0000000000000000
 00007fff0b9b681c 0000000000000001 0000000000000001 0000000000000000
Call Trace:
 [<ffffffff81075880>] do_futex+0xf0/0xba0
 [<ffffffff810c3570>] ? handle_mm_fault+0x130/0x220
 [<ffffffff81023c24>] ? do_page_fault+0x194/0x460
 [<ffffffff810fb87a>] ? mntput+0x1a/0x30
 [<ffffffff810d915d>] ? kmem_cache_free+0x8d/0x90
 [<ffffffff810763a6>] sys_futex+0x76/0x170
 [<ffffffff8149ba7b>] system_call_fastpath+0x16/0x1b
Code: 85 c0 75 d0 4c 89 ef e8 90 ef ff ff 48 89 c7 48 89 45 a8 e8 24 6d 42 
00 48 8b 55 a8 48 8b 42 08 48 83 c2 08 48 8d 78 e8 48 39 c2 <4c> 8b 7f 18 74 
6b 49 83 ef 18 eb 19 0f 1f 44 00 00 49 8d 47 18
RIP  [<ffffffff81073edf>] futex_wake+0x8f/0x130
 RSP <ffff88013a84fd58>
CR2: 0000000000000000
BUG: unable to handle kernel
---[ end trace bb26011d21a2b1d5 ]---
note: udevadm[404] exited with preempt_count 1
BUG: scheduling while atomic: udevadm/404/0x10000002
Modules linked in:
Pid: 404, comm: udevadm Tainted: G      D     3.1.3+ #19
Call Trace:
 [<ffffffff8103b47c>] __schedule_bug+0x5c/0x60
 [<ffffffff81498dd1>] __schedule+0x6b1/0x8b0
 [<ffffffff8125749f>] ? symbol_string.clone.7+0x7f/0xe0
 [<ffffffff81255d19>] ? put_dec+0x59/0x60
 [<ffffffff81257091>] ? number.clone.2+0x311/0x350
 [<ffffffff8103fbe5>] __cond_resched+0x25/0x40
 [<ffffffff8149904c>] _cond_resched+0x2c/0x40
 [<ffffffff810c241d>] unmap_vmas+0x4ed/0x6d0
 [<ffffffff810c90d8>] exit_mmap+0xa8/0x110
 [<ffffffff81047bb7>] ? console_trylock+0x17/0x70
 [<ffffffff8149b0e7>] ? _raw_spin_unlock+0x27/0x30
 [<ffffffff8104501d>] mmput+0x2d/0xe0
 [<ffffffff810495bf>] exit_mm+0x10f/0x140
 [<ffffffff8149b068>] ? _raw_spin_unlock_irq+0x28/0x40
 [<ffffffff8104acc1>] do_exit+0x141/0x7e0
 [<ffffffff81005455>] oops_end+0x75/0xa0
 [<ffffffff81023480>] no_context+0xf0/0x260
 [<ffffffff81023715>] __bad_area_nosemaphore+0x125/0x210
 [<ffffffff8102380e>] bad_area_nosemaphore+0xe/0x10
 [<ffffffff81023e32>] do_page_fault+0x3a2/0x460
 [<ffffffff810ae64d>] ? __alloc_pages_nodemask+0x10d/0x700
 [<ffffffff8149b66f>] page_fault+0x1f/0x30
 [<ffffffff81073edf>] ? futex_wake+0x8f/0x130
 [<ffffffff81073ecc>] ? futex_wake+0x7c/0x130
 [<ffffffff81075880>] do_futex+0xf0/0xba0
 [<ffffffff810c3570>] ? handle_mm_fault+0x130/0x220
 [<ffffffff81023c24>] ? do_page_fault+0x194/0x460
 [<ffffffff810fb87a>] ? mntput+0x1a/0x30
 [<ffffffff810d915d>] ? kmem_cache_free+0x8d/0x90
 [<ffffffff810763a6>] sys_futex+0x76/0x170
 [<ffffffff8149ba7b>] system_call_fastpath+0x16/0x1b
NULL pointer dereference at           (null)
IP: [<ffffffff81073edf>] futex_wake+0x8f/0x130
PGD 13a833067 PUD 13b0f9067 PMD 0
Oops: 0000 [#10] PREEMPT SMP
CPU 1
Pid: 405, comm: udevadm Tainted: G      D     3.1.3+ #19 System manufacturer 
System Product Name/P5P43TD
RIP: 0010:[<ffffffff81073edf>]  [<ffffffff81073edf>] futex_wake+0x8f/0x130
RSP: 0018:ffff8801355f1d58  EFLAGS: 00010286
RAX: 0000000000000000 RBX: 00000000ffffffff RCX: 00000000b009ad73
RDX: ffffffff818312a0 RSI: 000000006a7bea89 RDI: ffffffffffffffe8
RBP: ffff8801355f1db8 R08: 000000002d56544b R09: 0000000000000000
R10: 00007fff554f5740 R11: 0000000000000202 R12: 0000000000000001
R13: ffff8801355f1d68 R14: 0000000000000000 R15: 0000000000000000
FS:  00007f6d4b5e8700(0000) GS:ffff88013fc80000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000000000 CR3: 000000013a834000 CR4: 00000000000406e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process udevadm (pid: 405, threadinfo ffff8801355f0000, task 
ffff88013b0e6300)
Stack:
 ffff8801355f1de8 ffffffff81831298 00007fff554f5000 ffff88013b3e8340
 000000000000086c ffffea0004ff6c80 ffff8801355f1da8 0000000000000000
 00007fff554f586c 0000000000000001 0000000000000001 0000000000000000
Call Trace:
 [<ffffffff81075880>] do_futex+0xf0/0xba0
 [<ffffffff810c3570>] ? handle_mm_fault+0x130/0x220
 [<ffffffff81023c24>] ? do_page_fault+0x194/0x460
 [<ffffffff810fb87a>] ? mntput+0x1a/0x30
 [<ffffffff810d915d>] ? kmem_cache_free+0x8d/0x90
 [<ffffffff810763a6>] sys_futex+0x76/0x170
 [<ffffffff8149ba7b>] system_call_fastpath+0x16/0x1b
Code: 85 c0 75 d0 4c 89 ef e8 90 ef ff ff 48 89 c7 48 89 45 a8 e8 24 6d 42 
00 48 8b 55 a8 48 8b 42 08 48 83 c2 08 48 8d 78 e8 48 39 c2 <4c> 8b 7f 18 74 
6b 49 83 ef 18 eb 19 0f 1f 44 00 00 49 8d 47 18
RIP  [<ffffffff81073edf>] futex_wake+0x8f/0x130
 RSP <ffff8801355f1d58>
CR2: 0000000000000000
BUG: unable to handle kernel
---[ end trace bb26011d21a2b1d6 ]---
note: udevadm[405] exited with preempt_count 1
BUG: scheduling while atomic: udevadm/405/0x10000002
Modules linked in:
Pid: 405, comm: udevadm Tainted: G      D     3.1.3+ #19
Call Trace:
 [<ffffffff8103b47c>] __schedule_bug+0x5c/0x60
 [<ffffffff81498dd1>] __schedule+0x6b1/0x8b0
 [<ffffffff8125749f>] ? symbol_string.clone.7+0x7f/0xe0
 [<ffffffff81255d19>] ? put_dec+0x59/0x60
 [<ffffffff81257091>] ? number.clone.2+0x311/0x350
 [<ffffffff8149b0a9>] ? _raw_spin_unlock_irqrestore+0x29/0x40
 [<ffffffff8103fbe5>] __cond_resched+0x25/0x40
 [<ffffffff8149904c>] _cond_resched+0x2c/0x40
 [<ffffffff810c241d>] unmap_vmas+0x4ed/0x6d0
 [<ffffffff810c90d8>] exit_mmap+0xa8/0x110
 [<ffffffff81047bb7>] ? console_trylock+0x17/0x70
 [<ffffffff8149b0e7>] ? _raw_spin_unlock+0x27/0x30
 [<ffffffff8104501d>] mmput+0x2d/0xe0
 [<ffffffff810495bf>] exit_mm+0x10f/0x140
 [<ffffffff8149b068>] ? _raw_spin_unlock_irq+0x28/0x40
 [<ffffffff8104acc1>] do_exit+0x141/0x7e0
 [<ffffffff81005455>] oops_end+0x75/0xa0
 [<ffffffff81023480>] no_context+0xf0/0x260
 [<ffffffff81023715>] __bad_area_nosemaphore+0x125/0x210
 [<ffffffff8102380e>] bad_area_nosemaphore+0xe/0x10
 [<ffffffff81023e32>] do_page_fault+0x3a2/0x460
 [<ffffffff810ae64d>] ? __alloc_pages_nodemask+0x10d/0x700
 [<ffffffff8149b66f>] page_fault+0x1f/0x30
 [<ffffffff81073edf>] ? futex_wake+0x8f/0x130
 [<ffffffff81073ecc>] ? futex_wake+0x7c/0x130
 [<ffffffff81075880>] do_futex+0xf0/0xba0
 [<ffffffff810c3570>] ? handle_mm_fault+0x130/0x220
 [<ffffffff81023c24>] ? do_page_fault+0x194/0x460
 [<ffffffff810fb87a>] ? mntput+0x1a/0x30
 [<ffffffff810d915d>] ? kmem_cache_free+0x8d/0x90
 [<ffffffff810763a6>] sys_futex+0x76/0x170
 [<ffffffff8149ba7b>] system_call_fastpath+0x16/0x1b
NULL pointer dereference at           (null)
IP: [<ffffffff81073edf>] futex_wake+0x8f/0x130
PGD 13b3d1067 PUD 13b3d0067 PMD 0
Oops: 0000 [#11] PREEMPT SMP
CPU 3
Pid: 406, comm: udevadm Tainted: G      D     3.1.3+ #19 System manufacturer 
System Product Name/P5P43TD
RIP: 0010:[<ffffffff81073edf>]  [<ffffffff81073edf>] futex_wake+0x8f/0x130
RSP: 0018:ffff88013a857d58  EFLAGS: 00010282
RAX: 0000000000000000 RBX: 00000000ffffffff RCX: 00000000f25bc317
RDX: ffffffff81830f70 RSI: 000000006cabe682 RDI: ffffffffffffffe8
RBP: ffff88013a857db8 R08: 00000000b337ea9c R09: 0000000000000000
R10: 00007ffffc2d5c50 R11: 0000000000000202 R12: 0000000000000001
R13: ffff88013a857d68 R14: 0000000000000000 R15: 0000000000000000
FS:  00007f638c8e1700(0000) GS:ffff88013fd80000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000000000 CR3: 000000013b3d3000 CR4: 00000000000406e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process udevadm (pid: 406, threadinfo ffff88013a856000, task 
ffff88013b27b180)
Stack:
 ffff88013a857de8 ffffffff81830f68 00007ffffc2d5000 ffff88013a8b4340
 0000000000000d7c ffffea0004fdfa80 ffff88013a857da8 0000000000000000
 00007ffffc2d5d7c 0000000000000001 0000000000000001 0000000000000000
Call Trace:
 [<ffffffff81075880>] do_futex+0xf0/0xba0
 [<ffffffff810c3570>] ? handle_mm_fault+0x130/0x220
 [<ffffffff81023c24>] ? do_page_fault+0x194/0x460
 [<ffffffff810fb87a>] ? mntput+0x1a/0x30
 [<ffffffff810d915d>] ? kmem_cache_free+0x8d/0x90
 [<ffffffff810763a6>] sys_futex+0x76/0x170
 [<ffffffff8149ba7b>] system_call_fastpath+0x16/0x1b
Code: 85 c0 75 d0 4c 89 ef e8 90 ef ff ff 48 89 c7 48 89 45 a8 e8 24 6d 42 
00 48 8b 55 a8 48 8b 42 08 48 83 c2 08 48 8d 78 e8 48 39 c2 <4c> 8b 7f 18 74 
6b 49 83 ef 18 eb 19 0f 1f 44 00 00 49 8d 47 18
RIP  [<ffffffff81073edf>] futex_wake+0x8f/0x130
 RSP <ffff88013a857d58>
CR2: 0000000000000000
BUG: unable to handle kernel
---[ end trace bb26011d21a2b1d7 ]---
note: udevadm[406] exited with preempt_count 1
NULL pointer dereference at           (null)
IP: [<ffffffff81073edf>] futex_wake+0x8f/0x130
PGD 13591c067 PUD 13587b067 PMD 0
Oops: 0000 [#12] PREEMPT SMP
CPU 2
Pid: 407, comm: udevadm Tainted: G      D     3.1.3+ #19 System manufacturer 
System Product Name/P5P43TD
RIP: 0010:[<ffffffff81073edf>]  [<ffffffff81073edf>] futex_wake+0x8f/0x130
RSP: 0018:ffff8801355f3d58  EFLAGS: 00010286
RAX: 0000000000000000 RBX: 00000000ffffffff RCX: 0000000009c1935f
RDX: ffffffff818313f0 RSI: 000000003e2511b1 RDI: ffffffffffffffe8
RBP: ffff8801355f3db8 R08: 00000000c7212e93 R09: 0000000000000000
R10: 00007fff2aee8ad0 R11: 0000000000000202 R12: 0000000000000001
R13: ffff8801355f3d68 R14: 0000000000000000 R15: 0000000000000000
FS:  00007f886b785700(0000) GS:ffff88013fd00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000000000 CR3: 000000013a86f000 CR4: 00000000000406e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process udevadm (pid: 407, threadinfo ffff8801355f2000, task 
ffff88013b2b7590)
Stack:
 ffff8801355f3de8 ffffffff818313e8 00007fff2aee8000 ffff8801355ec000
 0000000000000bfc ffffea0004ff4e80 ffff8801355f3da8 0000000000000000
 00007fff2aee8bfc 0000000000000001 0000000000000001 0000000000000000
Call Trace:
 [<ffffffff81075880>] do_futex+0xf0/0xba0
 [<ffffffff810c3570>] ? handle_mm_fault+0x130/0x220
 [<ffffffff81023c24>] ? do_page_fault+0x194/0x460
 [<ffffffff810fb87a>] ? mntput+0x1a/0x30
 [<ffffffff810d915d>] ? kmem_cache_free+0x8d/0x90
 [<ffffffff810763a6>] sys_futex+0x76/0x170
 [<ffffffff8149ba7b>] system_call_fastpath+0x16/0x1b
Code: 85 c0 75 d0 4c 89 ef e8 90 ef ff ff 48 89 c7 48 89 45 a8 e8 24 6d 42 
00 48 8b 55 a8 48 8b 42 08 48 83 c2 08 48 8d 78 e8 48 39 c2 <4c> 8b 7f 18 74 
6b 49 83 ef 18 eb 19 0f 1f 44 00 00 49 8d 47 18
RIP  [<ffffffff81073edf>] futex_wake+0x8f/0x130
 RSP <ffff8801355f3d58>
CR2: 0000000000000000
BUG: unable to handle kernel
---[ end trace bb26011d21a2b1d8 ]---
note: udevadm[407] exited with preempt_count 1
BUG: scheduling while atomic: udevadm/407/0x10000002
Modules linked in:
Pid: 407, comm: udevadm Tainted: G      D     3.1.3+ #19
Call Trace:
 [<ffffffff8103b47c>] __schedule_bug+0x5c/0x60
 [<ffffffff81498dd1>] __schedule+0x6b1/0x8b0
 [<ffffffff8125749f>] ? symbol_string.clone.7+0x7f/0xe0
 [<ffffffff81255d19>] ? put_dec+0x59/0x60
 [<ffffffff81257091>] ? number.clone.2+0x311/0x350
 [<ffffffff8149b0a9>] ? _raw_spin_unlock_irqrestore+0x29/0x40
 [<ffffffff8103fbe5>] __cond_resched+0x25/0x40
 [<ffffffff8149904c>] _cond_resched+0x2c/0x40
 [<ffffffff810c241d>] unmap_vmas+0x4ed/0x6d0
 [<ffffffff810c90d8>] exit_mmap+0xa8/0x110
 [<ffffffff81047bb7>] ? console_trylock+0x17/0x70
 [<ffffffff8149b0e7>] ? _raw_spin_unlock+0x27/0x30
 [<ffffffff8104501d>] mmput+0x2d/0xe0
 [<ffffffff810495bf>] exit_mm+0x10f/0x140
 [<ffffffff8149b068>] ? _raw_spin_unlock_irq+0x28/0x40
 [<ffffffff8104acc1>] do_exit+0x141/0x7e0
 [<ffffffff81005455>] oops_end+0x75/0xa0
 [<ffffffff81023480>] no_context+0xf0/0x260
 [<ffffffff81023715>] __bad_area_nosemaphore+0x125/0x210
 [<ffffffff8102380e>] bad_area_nosemaphore+0xe/0x10
 [<ffffffff81023e32>] do_page_fault+0x3a2/0x460
 [<ffffffff810ae64d>] ? __alloc_pages_nodemask+0x10d/0x700
 [<ffffffff8149b66f>] page_fault+0x1f/0x30
 [<ffffffff81073edf>] ? futex_wake+0x8f/0x130
 [<ffffffff81073ecc>] ? futex_wake+0x7c/0x130
 [<ffffffff81075880>] do_futex+0xf0/0xba0
 [<ffffffff810c3570>] ? handle_mm_fault+0x130/0x220
 [<ffffffff81023c24>] ? do_page_fault+0x194/0x460
 [<ffffffff810fb87a>] ? mntput+0x1a/0x30
 [<ffffffff810d915d>] ? kmem_cache_free+0x8d/0x90
 [<ffffffff810763a6>] sys_futex+0x76/0x170
 [<ffffffff8149ba7b>] system_call_fastpath+0x16/0x1b
NULL pointer dereference at           (null)
IP: [<ffffffff81073edf>] futex_wake+0x8f/0x130
PGD 13b230067 PUD 13b3d1067 PMD 0
Oops: 0000 [#13] PREEMPT SMP
CPU 3
Pid: 408, comm: udevadm Tainted: G      D     3.1.3+ #19 System manufacturer 
System Product Name/P5P43TD
RIP: 0010:[<ffffffff81073edf>]  [<ffffffff81073edf>] futex_wake+0x8f/0x130
RSP: 0018:ffff88013a855d58  EFLAGS: 00010286
RAX: 0000000000000000 RBX: 00000000ffffffff RCX: 00000000dc921be2
RDX: ffffffff81830418 RSI: 000000006d9a430d RDI: ffffffffffffffe8
RBP: ffff88013a855db8 R08: 00000000c5e9c8f6 R09: 0000000000000000
R10: 00007fff5317d850 R11: 0000000000000202 R12: 0000000000000001
R13: ffff88013a855d68 R14: 0000000000000000 R15: 0000000000000000
FS:  00007f631e1b1700(0000) GS:ffff88013fd80000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000000000 CR3: 000000013b3d4000 CR4: 00000000000406e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process udevadm (pid: 408, threadinfo ffff88013a854000, task 
ffff88013b278000)
Stack:
 ffff88013a855de8 ffffffff81830410 00007fff5317d000 ffff88013a8b4000
 000000000000097c ffffea0004ff4bc0 ffff88013a855da8 0000000000000000
 00007fff5317d97c 0000000000000001 0000000000000001 0000000000000000
Call Trace:
 [<ffffffff81075880>] do_futex+0xf0/0xba0
 [<ffffffff810c3570>] ? handle_mm_fault+0x130/0x220
 [<ffffffff81023c24>] ? do_page_fault+0x194/0x460
 [<ffffffff810fb87a>] ? mntput+0x1a/0x30
 [<ffffffff810d915d>] ? kmem_cache_free+0x8d/0x90
 [<ffffffff810763a6>] sys_futex+0x76/0x170
 [<ffffffff8149ba7b>] system_call_fastpath+0x16/0x1b
Code: 85 c0 75 d0 4c 89 ef e8 90 ef ff ff 48 89 c7 48 89 45 a8 e8 24 6d 42 
00 48 8b 55 a8 48 8b 42 08 48 83 c2 08 48 8d 78 e8 48 39 c2 <4c> 8b 7f 18 74 
6b 49 83 ef 18 eb 19 0f 1f 44 00 00 49 8d 47 18
RIP  [<ffffffff81073edf>] futex_wake+0x8f/0x130
 RSP <ffff88013a855d58>
CR2: 0000000000000000
BUG: unable to handle kernel
---[ end trace bb26011d21a2b1d9 ]---
note: udevadm[408] exited with preempt_count 1
BUG: scheduling while atomic: udevadm/408/0x10000002
Modules linked in:
Pid: 408, comm: udevadm Tainted: G      D     3.1.3+ #19
Call Trace:
 [<ffffffff8103b47c>] __schedule_bug+0x5c/0x60
 [<ffffffff81498dd1>] __schedule+0x6b1/0x8b0
 [<ffffffff8125749f>] ? symbol_string.clone.7+0x7f/0xe0
 [<ffffffff81255d19>] ? put_dec+0x59/0x60
 [<ffffffff81257091>] ? number.clone.2+0x311/0x350
 [<ffffffff8149b0a9>] ? _raw_spin_unlock_irqrestore+0x29/0x40
 [<ffffffff8103fbe5>] __cond_resched+0x25/0x40
 [<ffffffff8149904c>] _cond_resched+0x2c/0x40
 [<ffffffff810c241d>] unmap_vmas+0x4ed/0x6d0
 [<ffffffff810c90d8>] exit_mmap+0xa8/0x110
 [<ffffffff81047bb7>] ? console_trylock+0x17/0x70
 [<ffffffff8149b0e7>] ? _raw_spin_unlock+0x27/0x30
 [<ffffffff8104501d>] mmput+0x2d/0xe0
 [<ffffffff810495bf>] exit_mm+0x10f/0x140
 [<ffffffff8149b068>] ? _raw_spin_unlock_irq+0x28/0x40
 [<ffffffff8104acc1>] do_exit+0x141/0x7e0
 [<ffffffff81005455>] oops_end+0x75/0xa0
 [<ffffffff81023480>] no_context+0xf0/0x260
 [<ffffffff81023715>] __bad_area_nosemaphore+0x125/0x210
 [<ffffffff8102380e>] bad_area_nosemaphore+0xe/0x10
 [<ffffffff81023e32>] do_page_fault+0x3a2/0x460
 [<ffffffff810ae64d>] ? __alloc_pages_nodemask+0x10d/0x700
 [<ffffffff8149b66f>] page_fault+0x1f/0x30
 [<ffffffff81073edf>] ? futex_wake+0x8f/0x130
 [<ffffffff81073ecc>] ? futex_wake+0x7c/0x130
 [<ffffffff81075880>] do_futex+0xf0/0xba0
 [<ffffffff810c3570>] ? handle_mm_fault+0x130/0x220
 [<ffffffff81023c24>] ? do_page_fault+0x194/0x460
 [<ffffffff810fb87a>] ? mntput+0x1a/0x30
 [<ffffffff810d915d>] ? kmem_cache_free+0x8d/0x90
 [<ffffffff810763a6>] sys_futex+0x76/0x170
 [<ffffffff8149ba7b>] system_call_fastpath+0x16/0x1b
NULL pointer dereference at           (null)
IP: [<ffffffff81073edf>] futex_wake+0x8f/0x130
PGD 135ede067 PUD 135ef9067 PMD 0
Oops: 0000 [#14] PREEMPT SMP
CPU 0
Pid: 409, comm: udevadm Tainted: G      D     3.1.3+ #19 System manufacturer 
System Product Name/P5P43TD
RIP: 0010:[<ffffffff81073edf>]  [<ffffffff81073edf>] futex_wake+0x8f/0x130
RSP: 0018:ffff8801365c9d58  EFLAGS: 00010286
RAX: 0000000000000000 RBX: 00000000ffffffff RCX: 0000000024429042
RDX: ffffffff81830df0 RSI: 00000000ebfc891f RDI: ffffffffffffffe8
RBP: ffff8801365c9db8 R08: 00000000098a14aa R09: 0000000000000000
R10: 00007fffe21775d0 R11: 0000000000000202 R12: 0000000000000001
R13: ffff8801365c9d68 R14: 0000000000000000 R15: 0000000000000000
FS:  00007f6a0161e700(0000) GS:ffff88013fc00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000000000 CR3: 000000013580a000 CR4: 00000000000406f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process udevadm (pid: 409, threadinfo ffff8801365c8000, task 
ffff88013b0c5cd0)
Stack:
 ffff8801365c9de8 ffffffff81830de8 00007fffe2177000 ffff8801365cc340
 00000000000006fc ffffea0004ff2940 ffff8801365c9da8 0000000000000000
 00007fffe21776fc 0000000000000001 0000000000000001 0000000000000000
Call Trace:
 [<ffffffff81075880>] do_futex+0xf0/0xba0
 [<ffffffff810c3570>] ? handle_mm_fault+0x130/0x220
 [<ffffffff81023c24>] ? do_page_fault+0x194/0x460
 [<ffffffff810fb87a>] ? mntput+0x1a/0x30
 [<ffffffff810d915d>] ? kmem_cache_free+0x8d/0x90
 [<ffffffff810763a6>] sys_futex+0x76/0x170
 [<ffffffff8149ba7b>] system_call_fastpath+0x16/0x1b
Code: 85 c0 75 d0 4c 89 ef e8 90 ef ff ff 48 89 c7 48 89 45 a8 e8 24 6d 42 
00 48 8b 55 a8 48 8b 42 08 48 83 c2 08 48 8d 78 e8 48 39 c2 <4c> 8b 7f 18 74 
6b 49 83 ef 18 eb 19 0f 1f 44 00 00 49 8d 47 18
RIP  [<ffffffff81073edf>] futex_wake+0x8f/0x130
 RSP <ffff8801365c9d58>
CR2: 0000000000000000
BUG: unable to handle kernel
---[ end trace bb26011d21a2b1da ]---
note: udevadm[409] exited with preempt_count 1
BUG: scheduling while atomic: udevadm/409/0x10000002
Modules linked in:
Pid: 409, comm: udevadm Tainted: G      D     3.1.3+ #19
Call Trace:
 [<ffffffff8103b47c>] __schedule_bug+0x5c/0x60
 [<ffffffff81498dd1>] __schedule+0x6b1/0x8b0
 [<ffffffff8125749f>] ? symbol_string.clone.7+0x7f/0xe0
 [<ffffffff81255d19>] ? put_dec+0x59/0x60
 [<ffffffff81257091>] ? number.clone.2+0x311/0x350
 [<ffffffff8149b0a9>] ? _raw_spin_unlock_irqrestore+0x29/0x40
 [<ffffffff8103fbe5>] __cond_resched+0x25/0x40
 [<ffffffff8149904c>] _cond_resched+0x2c/0x40
 [<ffffffff810c241d>] unmap_vmas+0x4ed/0x6d0
 [<ffffffff810c90d8>] exit_mmap+0xa8/0x110
 [<ffffffff81047bb7>] ? console_trylock+0x17/0x70
 [<ffffffff8149b0e7>] ? _raw_spin_unlock+0x27/0x30
 [<ffffffff8104501d>] mmput+0x2d/0xe0
 [<ffffffff810495bf>] exit_mm+0x10f/0x140
 [<ffffffff8149b068>] ? _raw_spin_unlock_irq+0x28/0x40
 [<ffffffff8104acc1>] do_exit+0x141/0x7e0
 [<ffffffff81005455>] oops_end+0x75/0xa0
 [<ffffffff81023480>] no_context+0xf0/0x260
 [<ffffffff81023715>] __bad_area_nosemaphore+0x125/0x210
 [<ffffffff8102380e>] bad_area_nosemaphore+0xe/0x10
 [<ffffffff81023e32>] do_page_fault+0x3a2/0x460
 [<ffffffff810ae64d>] ? __alloc_pages_nodemask+0x10d/0x700
 [<ffffffff8149b66f>] page_fault+0x1f/0x30
 [<ffffffff81073edf>] ? futex_wake+0x8f/0x130
 [<ffffffff81073ecc>] ? futex_wake+0x7c/0x130
 [<ffffffff81075880>] do_futex+0xf0/0xba0
 [<ffffffff810c3570>] ? handle_mm_fault+0x130/0x220
 [<ffffffff81023c24>] ? do_page_fault+0x194/0x460
 [<ffffffff810fb87a>] ? mntput+0x1a/0x30
 [<ffffffff810d915d>] ? kmem_cache_free+0x8d/0x90
 [<ffffffff810763a6>] sys_futex+0x76/0x170
 [<ffffffff8149ba7b>] system_call_fastpath+0x16/0x1b
NULL pointer dereference at           (null)
IP: [<ffffffff81073edf>] futex_wake+0x8f/0x130
PGD 13b3c3067 PUD 1365dc067 PMD 0
Oops: 0000 [#15] PREEMPT SMP
CPU 2
Pid: 410, comm: udevadm Tainted: G      D     3.1.3+ #19 System manufacturer 
System Product Name/P5P43TD
RIP: 0010:[<ffffffff81073edf>]  [<ffffffff81073edf>] futex_wake+0x8f/0x130
RSP: 0018:ffff8801365cbd58  EFLAGS: 00010286
RAX: 0000000000000000 RBX: 00000000ffffffff RCX: 00000000e8e51f81
RDX: ffffffff81830760 RSI: 000000008e14c46a RDI: ffffffffffffffe8
RBP: ffff8801365cbdb8 R08: 0000000093a4c423 R09: 0000000000000000
R10: 00007fff1872ef80 R11: 0000000000000202 R12: 0000000000000001
R13: ffff8801365cbd68 R14: 0000000000000000 R15: 0000000000000000
FS:  00007f9d0d1a3700(0000) GS:ffff88013fd00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000000000 CR3: 0000000135977000 CR4: 00000000000406e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process udevadm (pid: 410, threadinfo ffff8801365ca000, task 
ffff88013b0e5cd0)
Stack:
 ffff8801365cbde8 ffffffff81830758 00007fff1872f000 ffff8801355ec340
 00000000000000ac ffffea0004ff6980 ffff8801365cbda8 0000000000000000
 00007fff1872f0ac 0000000000000001 0000000000000001 0000000000000000
Call Trace:
 [<ffffffff81075880>] do_futex+0xf0/0xba0
 [<ffffffff810c3570>] ? handle_mm_fault+0x130/0x220
 [<ffffffff81023c24>] ? do_page_fault+0x194/0x460
 [<ffffffff810fb87a>] ? mntput+0x1a/0x30
 [<ffffffff810d915d>] ? kmem_cache_free+0x8d/0x90
 [<ffffffff810763a6>] sys_futex+0x76/0x170
 [<ffffffff8149ba7b>] system_call_fastpath+0x16/0x1b
Code: 85 c0 75 d0 4c 89 ef e8 90 ef ff ff 48 89 c7 48 89 45 a8 e8 24 6d 42 
00 48 8b 55 a8 48 8b 42 08 48 83 c2 08 48 8d 78 e8 48 39 c2 <4c> 8b 7f 18 74 
6b 49 83 ef 18 eb 19 0f 1f 44 00 00 49 8d 47 18
RIP  [<ffffffff81073edf>] futex_wake+0x8f/0x130
 RSP <ffff8801365cbd58>
CR2: 0000000000000000
BUG: unable to handle kernel
---[ end trace bb26011d21a2b1db ]---
note: udevadm[410] exited with preempt_count 1
NULL pointer dereference at           (null)
IP: [<ffffffff81073edf>] futex_wake+0x8f/0x130
PGD 13a833067 PUD 13b0f9067 PMD 0
Oops: 0000 [#16] PREEMPT SMP
CPU 1
Pid: 411, comm: udevadm Tainted: G      D     3.1.3+ #19 System manufacturer 
System Product Name/P5P43TD
RIP: 0010:[<ffffffff81073edf>]  [<ffffffff81073edf>] futex_wake+0x8f/0x130
RSP: 0018:ffff8801365dfd58  EFLAGS: 00010286
RAX: 0000000000000000 RBX: 00000000ffffffff RCX: 00000000fac00f4f
RDX: ffffffff81831348 RSI: 00000000db842014 RDI: ffffffffffffffe8
RBP: ffff8801365dfdb8 R08: 00000000c0c798cf R09: 0000000000000000
R10: 00007fff43025c10 R11: 0000000000000202 R12: 0000000000000001
R13: ffff8801365dfd68 R14: 0000000000000000 R15: 0000000000000000
FS:  00007f250a154700(0000) GS:ffff88013fc80000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000000000 CR3: 000000013a835000 CR4: 00000000000406e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process udevadm (pid: 411, threadinfo ffff8801365de000, task 
ffff88013b0e56a0)
Stack:
 ffff8801365dfde8 ffffffff81831340 00007fff43025000 ffff88013b3e8000
 0000000000000d3c ffffea0004ff2640 ffff8801365dfda8 0000000000000000
 00007fff43025d3c 0000000000000001 0000000000000001 0000000000000000
Call Trace:
 [<ffffffff81075880>] do_futex+0xf0/0xba0
 [<ffffffff810c3570>] ? handle_mm_fault+0x130/0x220
 [<ffffffff81023c24>] ? do_page_fault+0x194/0x460
 [<ffffffff810fb87a>] ? mntput+0x1a/0x30
 [<ffffffff810d915d>] ? kmem_cache_free+0x8d/0x90
 [<ffffffff810763a6>] sys_futex+0x76/0x170
 [<ffffffff8149ba7b>] system_call_fastpath+0x16/0x1b
Code: 85 c0 75 d0 4c 89 ef e8 90 ef ff ff 48 89 c7 48 89 45 a8 e8 24 6d 42 
00 48 8b 55 a8 48 8b 42 08 48 83 c2 08 48 8d 78 e8 48 39 c2 <4c> 8b 7f 18 74 
6b 49 83 ef 18 eb 19 0f 1f 44 00 00 49 8d 47 18
RIP  [<ffffffff81073edf>] futex_wake+0x8f/0x130
 RSP <ffff8801365dfd58>
CR2: 0000000000000000
BUG: unable to handle kernel
---[ end trace bb26011d21a2b1dc ]---
note: udevadm[411] exited with preempt_count 1
BUG: scheduling while atomic: udevadm/411/0x10000002
Modules linked in:
Pid: 411, comm: udevadm Tainted: G      D     3.1.3+ #19
Call Trace:
 [<ffffffff8103b47c>] __schedule_bug+0x5c/0x60
 [<ffffffff81498dd1>] __schedule+0x6b1/0x8b0
 [<ffffffff8125749f>] ? symbol_string.clone.7+0x7f/0xe0
 [<ffffffff81255d19>] ? put_dec+0x59/0x60
 [<ffffffff81257091>] ? number.clone.2+0x311/0x350
 [<ffffffff8103fbe5>] __cond_resched+0x25/0x40
 [<ffffffff8149904c>] _cond_resched+0x2c/0x40
 [<ffffffff810c241d>] unmap_vmas+0x4ed/0x6d0
 [<ffffffff810c90d8>] exit_mmap+0xa8/0x110
 [<ffffffff81047bb7>] ? console_trylock+0x17/0x70
 [<ffffffff8149b0e7>] ? _raw_spin_unlock+0x27/0x30
 [<ffffffff8104501d>] mmput+0x2d/0xe0
 [<ffffffff810495bf>] exit_mm+0x10f/0x140
 [<ffffffff8149b068>] ? _raw_spin_unlock_irq+0x28/0x40
 [<ffffffff8104acc1>] do_exit+0x141/0x7e0
 [<ffffffff81005455>] oops_end+0x75/0xa0
 [<ffffffff81023480>] no_context+0xf0/0x260
 [<ffffffff81023715>] __bad_area_nosemaphore+0x125/0x210
 [<ffffffff8102380e>] bad_area_nosemaphore+0xe/0x10
 [<ffffffff81023e32>] do_page_fault+0x3a2/0x460
 [<ffffffff810ae64d>] ? __alloc_pages_nodemask+0x10d/0x700
 [<ffffffff8149b66f>] page_fault+0x1f/0x30
 [<ffffffff81073edf>] ? futex_wake+0x8f/0x130
 [<ffffffff81073ecc>] ? futex_wake+0x7c/0x130
 [<ffffffff81075880>] do_futex+0xf0/0xba0
 [<ffffffff810c3570>] ? handle_mm_fault+0x130/0x220
 [<ffffffff81023c24>] ? do_page_fault+0x194/0x460
 [<ffffffff810fb87a>] ? mntput+0x1a/0x30
 [<ffffffff810d915d>] ? kmem_cache_free+0x8d/0x90
 [<ffffffff810763a6>] sys_futex+0x76/0x170
 [<ffffffff8149ba7b>] system_call_fastpath+0x16/0x1b
NULL pointer dereference at           (null)
IP: [<ffffffff81073edf>] futex_wake+0x8f/0x130
PGD 135e36067 PUD 135e4d067 PMD 0
Oops: 0000 [#17] PREEMPT SMP
CPU 0
Pid: 412, comm: udevadm Tainted: G      D     3.1.3+ #19 System manufacturer 
System Product Name/P5P43TD
RIP: 0010:[<ffffffff81073edf>]  [<ffffffff81073edf>] futex_wake+0x8f/0x130
RSP: 0018:ffff8801365f1d58  EFLAGS: 00010282
RAX: 0000000000000000 RBX: 00000000ffffffff RCX: 00000000670a07fe
RDX: ffffffff81831a68 RSI: 00000000e6c5e910 RDI: ffffffffffffffe8
RBP: ffff8801365f1db8 R08: 0000000003f41d3d R09: 0000000000000000
R10: 00007fff42fa2ca0 R11: 0000000000000202 R12: 0000000000000001
R13: ffff8801365f1d68 R14: 0000000000000000 R15: 0000000000000000
FS:  00007f53f0174700(0000) GS:ffff88013fc00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000000000 CR3: 0000000135e7c000 CR4: 00000000000406f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process udevadm (pid: 412, threadinfo ffff8801365f0000, task 
ffff88013b0e6930)
Stack:
 ffff8801365f1de8 ffffffff81831a60 00007fff42fa2000 ffff8801365cc000
 0000000000000dcc ffffea0004ff0c00 ffff8801365f1da8 0000000000000000
 00007fff42fa2dcc 0000000000000001 0000000000000001 0000000000000000
Call Trace:
 [<ffffffff81075880>] do_futex+0xf0/0xba0
 [<ffffffff810c3570>] ? handle_mm_fault+0x130/0x220
 [<ffffffff81023c24>] ? do_page_fault+0x194/0x460
 [<ffffffff810fb87a>] ? mntput+0x1a/0x30
 [<ffffffff810d915d>] ? kmem_cache_free+0x8d/0x90
 [<ffffffff810763a6>] sys_futex+0x76/0x170
 [<ffffffff8149ba7b>] system_call_fastpath+0x16/0x1b
Code: 85 c0 75 d0 4c 89 ef e8 90 ef ff ff 48 89 c7 48 89 45 a8 e8 24 6d 42 
00 48 8b 55 a8 48 8b 42 08 48 83 c2 08 48 8d 78 e8 48 39 c2 <4c> 8b 7f 18 74 
6b 49 83 ef 18 eb 19 0f 1f 44 00 00 49 8d 47 18
RIP  [<ffffffff81073edf>] futex_wake+0x8f/0x130
 RSP <ffff8801365f1d58>
CR2: 0000000000000000
BUG: unable to handle kernel
---[ end trace bb26011d21a2b1dd ]---
note: udevadm[412] exited with preempt_count 1
NULL pointer dereference at           (null)
IP: [<ffffffff81073edf>] futex_wake+0x8f/0x130
PGD 13a836067 PUD 13b0ff067 PMD 0
Oops: 0000 [#18] PREEMPT SMP
CPU 1
Pid: 414, comm: udevadm Tainted: G      D     3.1.3+ #19 System manufacturer 
System Product Name/P5P43TD
RIP: 0010:[<ffffffff81073edf>]  [<ffffffff81073edf>] futex_wake+0x8f/0x130
RSP: 0018:ffff88013a857d58  EFLAGS: 00010286
RAX: 0000000000000000 RBX: 00000000ffffffff RCX: 00000000726b6701
RDX: ffffffff81830430 RSI: 000000008bc207ef RDI: ffffffffffffffe8
RBP: ffff88013a857db8 R08: 00000000831d36b4 R09: 0000000000000000
R10: 00007fffda683190 R11: 0000000000000202 R12: 0000000000000001
R13: ffff88013a857d68 R14: 0000000000000000 R15: 0000000000000000
FS:  00007f6ca000a700(0000) GS:ffff88013fc80000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000000000 CR3: 000000013a837000 CR4: 00000000000406e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process udevadm (pid: 414, threadinfo ffff88013a856000, task 
ffff88013b0e18c0)
Stack:
 ffff88013a857de8 ffffffff81830428 00007fffda683000 ffff88013b3e8340
 00000000000002bc ffffea0004ff67c0 ffff88013a857da8 0000000000000000
 00007fffda6832bc 0000000000000001 0000000000000001 0000000000000000
Call Trace:
 [<ffffffff81075880>] do_futex+0xf0/0xba0
 [<ffffffff810c3570>] ? handle_mm_fault+0x130/0x220
 [<ffffffff81023c24>] ? do_page_fault+0x194/0x460
 [<ffffffff810fb87a>] ? mntput+0x1a/0x30
 [<ffffffff810d915d>] ? kmem_cache_free+0x8d/0x90
 [<ffffffff810763a6>] sys_futex+0x76/0x170
 [<ffffffff8149ba7b>] system_call_fastpath+0x16/0x1b
Code: 85 c0 75 d0 4c 89 ef e8 90 ef ff ff 48 89 c7 48 89 45 a8 e8 24 6d 42 
00 48 8b 55 a8 48 8b 42 08 48 83 c2 08 48 8d 78 e8 48 39 c2 <4c> 8b 7f 18 74 
6b 49 83 ef 18 eb 19 0f 1f 44 00 00 49 8d 47 18
RIP  [<ffffffff81073edf>] futex_wake+0x8f/0x130
 RSP <ffff88013a857d58>
CR2: 0000000000000000
BUG: unable to handle kernel
---[ end trace bb26011d21a2b1de ]---
note: udevadm[414] exited with preempt_count 1
BUG: scheduling while atomic: udevadm/414/0x10000002
Modules linked in:
Pid: 414, comm: udevadm Tainted: G      D     3.1.3+ #19
Call Trace:
 [<ffffffff8103b47c>] __schedule_bug+0x5c/0x60
 [<ffffffff81498dd1>] __schedule+0x6b1/0x8b0
 [<ffffffff8125749f>] ? symbol_string.clone.7+0x7f/0xe0
 [<ffffffff81255d19>] ? put_dec+0x59/0x60
 [<ffffffff81257091>] ? number.clone.2+0x311/0x350
 [<ffffffff8103fbe5>] __cond_resched+0x25/0x40
 [<ffffffff8149904c>] _cond_resched+0x2c/0x40
 [<ffffffff810c241d>] unmap_vmas+0x4ed/0x6d0
 [<ffffffff810c90d8>] exit_mmap+0xa8/0x110
 [<ffffffff81047bb7>] ? console_trylock+0x17/0x70
 [<ffffffff8149b0e7>] ? _raw_spin_unlock+0x27/0x30
 [<ffffffff8104501d>] mmput+0x2d/0xe0
 [<ffffffff810495bf>] exit_mm+0x10f/0x140
 [<ffffffff8149b068>] ? _raw_spin_unlock_irq+0x28/0x40
 [<ffffffff8104acc1>] do_exit+0x141/0x7e0
 [<ffffffff81005455>] oops_end+0x75/0xa0
 [<ffffffff81023480>] no_context+0xf0/0x260
 [<ffffffff81023715>] __bad_area_nosemaphore+0x125/0x210
 [<ffffffff8102380e>] bad_area_nosemaphore+0xe/0x10
 [<ffffffff81023e32>] do_page_fault+0x3a2/0x460
 [<ffffffff810ae64d>] ? __alloc_pages_nodemask+0x10d/0x700
 [<ffffffff8149b66f>] page_fault+0x1f/0x30
 [<ffffffff81073edf>] ? futex_wake+0x8f/0x130
 [<ffffffff81073ecc>] ? futex_wake+0x7c/0x130
 [<ffffffff81075880>] do_futex+0xf0/0xba0
 [<ffffffff810c3570>] ? handle_mm_fault+0x130/0x220
 [<ffffffff81023c24>] ? do_page_fault+0x194/0x460
 [<ffffffff810fb87a>] ? mntput+0x1a/0x30
 [<ffffffff810d915d>] ? kmem_cache_free+0x8d/0x90
 [<ffffffff810763a6>] sys_futex+0x76/0x170
 [<ffffffff8149ba7b>] system_call_fastpath+0x16/0x1b
BUG: scheduling while atomic: udevadm/414/0x10000002
Modules linked in:
Pid: 414, comm: udevadm Tainted: G      D     3.1.3+ #19
Call Trace:
 [<ffffffff8103b47c>] __schedule_bug+0x5c/0x60
 [<ffffffff81498dd1>] __schedule+0x6b1/0x8b0
 [<ffffffff8125749f>] ? symbol_string.clone.7+0x7f/0xe0
 [<ffffffff81257091>] ? number.clone.2+0x311/0x350
 [<ffffffff8103fbe5>] __cond_resched+0x25/0x40
 [<ffffffff810c2013>] ? unmap_vmas+0xe3/0x6d0
 [<ffffffff8149904c>] _cond_resched+0x2c/0x40
 [<ffffffff810c241d>] unmap_vmas+0x4ed/0x6d0
 [<ffffffff810c90d8>] exit_mmap+0xa8/0x110
 [<ffffffff8104501d>] mmput+0x2d/0xe0
 [<ffffffff810495bf>] exit_mm+0x10f/0x140
 [<ffffffff8149b068>] ? _raw_spin_unlock_irq+0x28/0x40
 [<ffffffff8104acc1>] do_exit+0x141/0x7e0
 [<ffffffff81005455>] oops_end+0x75/0xa0
 [<ffffffff81023480>] no_context+0xf0/0x260
 [<ffffffff81023715>] __bad_area_nosemaphore+0x125/0x210
 [<ffffffff8102380e>] bad_area_nosemaphore+0xe/0x10
 [<ffffffff81023e32>] do_page_fault+0x3a2/0x460
 [<ffffffff810ae64d>] ? __alloc_pages_nodemask+0x10d/0x700
 [<ffffffff8149b66f>] page_fault+0x1f/0x30
 [<ffffffff81073edf>] ? futex_wake+0x8f/0x130
 [<ffffffff81073ecc>] ? futex_wake+0x7c/0x130
 [<ffffffff81075880>] do_futex+0xf0/0xba0
 [<ffffffff810c3570>] ? handle_mm_fault+0x130/0x220
 [<ffffffff81023c24>] ? do_page_fault+0x194/0x460
 [<ffffffff810fb87a>] ? mntput+0x1a/0x30
 [<ffffffff810d915d>] ? kmem_cache_free+0x8d/0x90
 [<ffffffff810763a6>] sys_futex+0x76/0x170
 [<ffffffff8149ba7b>] system_call_fastpath+0x16/0x1b
NULL pointer dereference at           (null)
IP: [<ffffffff81073edf>] futex_wake+0x8f/0x130
PGD 13591c067 PUD 13587b067 PMD 0
Oops: 0000 [#19] PREEMPT SMP
CPU 3
Pid: 415, comm: udevadm Tainted: G      D     3.1.3+ #19 System manufacturer 
System Product Name/P5P43TD
RIP: 0010:[<ffffffff81073edf>]  [<ffffffff81073edf>] futex_wake+0x8f/0x130
RSP: 0018:ffff8801355f5d58  EFLAGS: 00010282
RAX: 0000000000000000 RBX: 00000000ffffffff RCX: 000000004455e100
RDX: ffffffff818311b0 RSI: 000000007bfe3dfe RDI: ffffffffffffffe8
RBP: ffff8801355f5db8 R08: 000000004c933124 R09: 0000000000000000
R10: 00007fff09749b90 R11: 0000000000000202 R12: 0000000000000001
R13: ffff8801355f5d68 R14: 0000000000000000 R15: 0000000000000000
FS:  00007f94bea81700(0000) GS:ffff88013fd80000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000000000 CR3: 000000013a86f000 CR4: 00000000000406e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process udevadm (pid: 415, threadinfo ffff8801355f4000, task 
ffff88013b0e1ef0)
Stack:
 ffff8801355f5de8 ffffffff818311a8 00007fff09749000 ffff88013a8b4340
 0000000000000cbc ffffea0004ff4e40 ffff8801355f5da8 0000000000000000
 00007fff09749cbc 0000000000000001 0000000000000001 0000000000000000
Call Trace:
 [<ffffffff81075880>] do_futex+0xf0/0xba0
 [<ffffffff810c3570>] ? handle_mm_fault+0x130/0x220
 [<ffffffff81023c24>] ? do_page_fault+0x194/0x460
 [<ffffffff810fb87a>] ? mntput+0x1a/0x30
 [<ffffffff810d915d>] ? kmem_cache_free+0x8d/0x90
 [<ffffffff810763a6>] sys_futex+0x76/0x170
 [<ffffffff8149ba7b>] system_call_fastpath+0x16/0x1b
Code: 85 c0 75 d0 4c 89 ef e8 90 ef ff ff 48 89 c7 48 89 45 a8 e8 24 6d 42 
00 48 8b 55 a8 48 8b 42 08 48 83 c2 08 48 8d 78 e8 48 39 c2 <4c> 8b 7f 18 74 
6b 49 83 ef 18 eb 19 0f 1f 44 00 00 49 8d 47 18
RIP  [<ffffffff81073edf>] futex_wake+0x8f/0x130
 RSP <ffff8801355f5d58>
CR2: 0000000000000000
BUG: unable to handle kernel
---[ end trace bb26011d21a2b1df ]---
note: udevadm[415] exited with preempt_count 1
BUG: scheduling while atomic: udevadm/415/0x10000002
Modules linked in:
Pid: 415, comm: udevadm Tainted: G      D     3.1.3+ #19
Call Trace:
 [<ffffffff8103b47c>] __schedule_bug+0x5c/0x60
 [<ffffffff81498dd1>] __schedule+0x6b1/0x8b0
 [<ffffffff8125749f>] ? symbol_string.clone.7+0x7f/0xe0
 [<ffffffff81255d19>] ? put_dec+0x59/0x60
 [<ffffffff81257091>] ? number.clone.2+0x311/0x350
 [<ffffffff8103fbe5>] __cond_resched+0x25/0x40
 [<ffffffff8149904c>] _cond_resched+0x2c/0x40
 [<ffffffff810c241d>] unmap_vmas+0x4ed/0x6d0
 [<ffffffff810c90d8>] exit_mmap+0xa8/0x110
 [<ffffffff81047bb7>] ? console_trylock+0x17/0x70
 [<ffffffff8149b0e7>] ? _raw_spin_unlock+0x27/0x30
 [<ffffffff8104501d>] mmput+0x2d/0xe0
 [<ffffffff810495bf>] exit_mm+0x10f/0x140
 [<ffffffff8149b068>] ? _raw_spin_unlock_irq+0x28/0x40
 [<ffffffff8104acc1>] do_exit+0x141/0x7e0
 [<ffffffff81005455>] oops_end+0x75/0xa0
 [<ffffffff81023480>] no_context+0xf0/0x260
 [<ffffffff81023715>] __bad_area_nosemaphore+0x125/0x210
 [<ffffffff8102380e>] bad_area_nosemaphore+0xe/0x10
 [<ffffffff81023e32>] do_page_fault+0x3a2/0x460
 [<ffffffff810ae64d>] ? __alloc_pages_nodemask+0x10d/0x700
 [<ffffffff8149b66f>] page_fault+0x1f/0x30
 [<ffffffff81073edf>] ? futex_wake+0x8f/0x130
 [<ffffffff81073ecc>] ? futex_wake+0x7c/0x130
 [<ffffffff81075880>] do_futex+0xf0/0xba0
 [<ffffffff810c3570>] ? handle_mm_fault+0x130/0x220
 [<ffffffff81023c24>] ? do_page_fault+0x194/0x460
 [<ffffffff810fb87a>] ? mntput+0x1a/0x30
 [<ffffffff810d915d>] ? kmem_cache_free+0x8d/0x90
 [<ffffffff810763a6>] sys_futex+0x76/0x170
 [<ffffffff8149ba7b>] system_call_fastpath+0x16/0x1b
NULL pointer dereference at           (null)
IP: [<ffffffff81073edf>] futex_wake+0x8f/0x130
PGD 135e36067 PUD 135e4d067 PMD 0
Oops: 0000 [#20] PREEMPT SMP
CPU 0
Pid: 416, comm: udevadm Tainted: G      D     3.1.3+ #19 System manufacturer 
System Product Name/P5P43TD
RIP: 0010:[<ffffffff81073edf>]  [<ffffffff81073edf>] futex_wake+0x8f/0x130
RSP: 0018:ffff8801355f1d58  EFLAGS: 00010282
RAX: 0000000000000000 RBX: 00000000ffffffff RCX: 0000000062712cd7
RDX: ffffffff81830e80 RSI: 000000006cdfc323 RDI: ffffffffffffffe8
RBP: ffff8801355f1db8 R08: 000000007a0a9bcd R09: 0000000000000000
R10: 00007fff3caf2200 R11: 0000000000000202 R12: 0000000000000001
R13: ffff8801355f1d68 R14: 0000000000000000 R15: 0000000000000000
FS:  00007f9a84943700(0000) GS:ffff88013fc00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000000000 CR3: 000000013a83e000 CR4: 00000000000406f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process udevadm (pid: 416, threadinfo ffff8801355f0000, task 
ffff88013b0e6300)
Stack:
 ffff8801355f1de8 ffffffff81830e78 00007fff3caf2000 ffff8801365cc680
 000000000000032c ffffea0004ff2ec0 ffff8801355f1da8 0000000000000000
 00007fff3caf232c 0000000000000001 0000000000000001 0000000000000000
Call Trace:
 [<ffffffff81075880>] do_futex+0xf0/0xba0
 [<ffffffff810c3570>] ? handle_mm_fault+0x130/0x220
 [<ffffffff81023c24>] ? do_page_fault+0x194/0x460
 [<ffffffff810fb87a>] ? mntput+0x1a/0x30
 [<ffffffff810d915d>] ? kmem_cache_free+0x8d/0x90
 [<ffffffff810763a6>] sys_futex+0x76/0x170
 [<ffffffff8149ba7b>] system_call_fastpath+0x16/0x1b
Code: 85 c0 75 d0 4c 89 ef e8 90 ef ff ff 48 89 c7 48 89 45 a8 e8 24 6d 42 
00 48 8b 55 a8 48 8b 42 08 48 83 c2 08 48 8d 78 e8 48 39 c2 <4c> 8b 7f 18 74 
6b 49 83 ef 18 eb 19 0f 1f 44 00 00 49 8d 47 18
RIP  [<ffffffff81073edf>] futex_wake+0x8f/0x130
 RSP <ffff8801355f1d58>
CR2: 0000000000000000
BUG: unable to handle kernel
---[ end trace bb26011d21a2b1e0 ]---
note: udevadm[416] exited with preempt_count 1
BUG: scheduling while atomic: udevadm/416/0x10000002
Modules linked in:
Pid: 416, comm: udevadm Tainted: G      D     3.1.3+ #19
Call Trace:
 [<ffffffff8103b47c>] __schedule_bug+0x5c/0x60
 [<ffffffff81498dd1>] __schedule+0x6b1/0x8b0
 [<ffffffff8125749f>] ? symbol_string.clone.7+0x7f/0xe0
 [<ffffffff81255d19>] ? put_dec+0x59/0x60
 [<ffffffff81257091>] ? number.clone.2+0x311/0x350
 [<ffffffff8149b0a9>] ? _raw_spin_unlock_irqrestore+0x29/0x40
 [<ffffffff8103fbe5>] __cond_resched+0x25/0x40
 [<ffffffff8149904c>] _cond_resched+0x2c/0x40
 [<ffffffff810c241d>] unmap_vmas+0x4ed/0x6d0
 [<ffffffff810c90d8>] exit_mmap+0xa8/0x110
 [<ffffffff81047bb7>] ? console_trylock+0x17/0x70
 [<ffffffff8149b0e7>] ? _raw_spin_unlock+0x27/0x30
 [<ffffffff8104501d>] mmput+0x2d/0xe0
 [<ffffffff810495bf>] exit_mm+0x10f/0x140
 [<ffffffff8149b068>] ? _raw_spin_unlock_irq+0x28/0x40
 [<ffffffff8104acc1>] do_exit+0x141/0x7e0
 [<ffffffff81005455>] oops_end+0x75/0xa0
 [<ffffffff81023480>] no_context+0xf0/0x260
 [<ffffffff81023715>] __bad_area_nosemaphore+0x125/0x210
 [<ffffffff8102380e>] bad_area_nosemaphore+0xe/0x10
 [<ffffffff81023e32>] do_page_fault+0x3a2/0x460
 [<ffffffff810ae64d>] ? __alloc_pages_nodemask+0x10d/0x700
 [<ffffffff8149b66f>] page_fault+0x1f/0x30
 [<ffffffff81073edf>] ? futex_wake+0x8f/0x130
 [<ffffffff81073ecc>] ? futex_wake+0x7c/0x130
 [<ffffffff81075880>] do_futex+0xf0/0xba0
 [<ffffffff810c3570>] ? handle_mm_fault+0x130/0x220
 [<ffffffff81023c24>] ? do_page_fault+0x194/0x460
 [<ffffffff810fb87a>] ? mntput+0x1a/0x30
 [<ffffffff810d915d>] ? kmem_cache_free+0x8d/0x90
 [<ffffffff810763a6>] sys_futex+0x76/0x170
 [<ffffffff8149ba7b>] system_call_fastpath+0x16/0x1b
NULL pointer dereference at           (null)
IP: [<ffffffff81073edf>] futex_wake+0x8f/0x130
PGD 1358ac067 PUD 13b3e1067 PMD 0
Oops: 0000 [#21] PREEMPT SMP
CPU 3
Pid: 417, comm: udevadm Tainted: G      D     3.1.3+ #19 System manufacturer 
System Product Name/P5P43TD
RIP: 0010:[<ffffffff81073edf>]  [<ffffffff81073edf>] futex_wake+0x8f/0x130
RSP: 0018:ffff8801355f7d58  EFLAGS: 00010286
RAX: 0000000000000000 RBX: 00000000ffffffff RCX: 0000000012b5d8b7
RDX: ffffffff818304d8 RSI: 0000000086193db0 RDI: ffffffffffffffe8
RBP: ffff8801355f7db8 R08: 0000000025429fd9 R09: 0000000000000000
R10: 00007fff16d33ad0 R11: 0000000000000202 R12: 0000000000000001
R13: ffff8801355f7d68 R14: 0000000000000000 R15: 0000000000000000
FS:  00007f7cf2d62700(0000) GS:ffff88013fd80000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000000000 CR3: 00000001359a4000 CR4: 00000000000406e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process udevadm (pid: 417, threadinfo ffff8801355f6000, task 
ffff88013b0e2520)
Stack:
 ffff8801355f7de8 ffffffff818304d0 00007fff16d33000 ffff88013a8b4000
 0000000000000bfc ffffea0004ff2880 ffff8801355f7da8 0000000000000000
 00007fff16d33bfc 0000000000000001 0000000000000001 0000000000000000
Call Trace:
 [<ffffffff81075880>] do_futex+0xf0/0xba0
 [<ffffffff810c3570>] ? handle_mm_fault+0x130/0x220
 [<ffffffff81023c24>] ? do_page_fault+0x194/0x460
 [<ffffffff810fb87a>] ? mntput+0x1a/0x30
 [<ffffffff810d915d>] ? kmem_cache_free+0x8d/0x90
 [<ffffffff810763a6>] sys_futex+0x76/0x170
 [<ffffffff8149ba7b>] system_call_fastpath+0x16/0x1b
Code: 85 c0 75 d0 4c 89 ef e8 90 ef ff ff 48 89 c7 48 89 45 a8 e8 24 6d 42 
00 48 8b 55 a8 48 8b 42 08 48 83 c2 08 48 8d 78 e8 48 39 c2 <4c> 8b 7f 18 74 
6b 49 83 ef 18 eb 19 0f 1f 44 00 00 49 8d 47 18
RIP  [<ffffffff81073edf>] futex_wake+0x8f/0x130
 RSP <ffff8801355f7d58>
CR2: 0000000000000000
BUG: unable to handle kernel
---[ end trace bb26011d21a2b1e1 ]---
note: udevadm[417] exited with preempt_count 1
BUG: scheduling while atomic: udevadm/417/0x10000002
Modules linked in:
Pid: 417, comm: udevadm Tainted: G      D     3.1.3+ #19
Call Trace:
 [<ffffffff8103b47c>] __schedule_bug+0x5c/0x60
 [<ffffffff81498dd1>] __schedule+0x6b1/0x8b0
 [<ffffffff8125749f>] ? symbol_string.clone.7+0x7f/0xe0
 [<ffffffff81255d19>] ? put_dec+0x59/0x60
 [<ffffffff81257091>] ? number.clone.2+0x311/0x350
 [<ffffffff8103fbe5>] __cond_resched+0x25/0x40
 [<ffffffff8149904c>] _cond_resched+0x2c/0x40
 [<ffffffff810c241d>] unmap_vmas+0x4ed/0x6d0
 [<ffffffff810c90d8>] exit_mmap+0xa8/0x110
 [<ffffffff81047bb7>] ? console_trylock+0x17/0x70
 [<ffffffff8149b0e7>] ? _raw_spin_unlock+0x27/0x30
 [<ffffffff8104501d>] mmput+0x2d/0xe0
 [<ffffffff810495bf>] exit_mm+0x10f/0x140
 [<ffffffff8149b068>] ? _raw_spin_unlock_irq+0x28/0x40
 [<ffffffff8104acc1>] do_exit+0x141/0x7e0
 [<ffffffff81005455>] oops_end+0x75/0xa0
 [<ffffffff81023480>] no_context+0xf0/0x260
 [<ffffffff81023715>] __bad_area_nosemaphore+0x125/0x210
 [<ffffffff8102380e>] bad_area_nosemaphore+0xe/0x10
 [<ffffffff81023e32>] do_page_fault+0x3a2/0x460
 [<ffffffff810ae64d>] ? __alloc_pages_nodemask+0x10d/0x700
 [<ffffffff8149b66f>] page_fault+0x1f/0x30
 [<ffffffff81073edf>] ? futex_wake+0x8f/0x130
 [<ffffffff81073ecc>] ? futex_wake+0x7c/0x130
 [<ffffffff81075880>] do_futex+0xf0/0xba0
 [<ffffffff810c3570>] ? handle_mm_fault+0x130/0x220
 [<ffffffff81023c24>] ? do_page_fault+0x194/0x460
 [<ffffffff810fb87a>] ? mntput+0x1a/0x30
 [<ffffffff810d915d>] ? kmem_cache_free+0x8d/0x90
 [<ffffffff810763a6>] sys_futex+0x76/0x170
 [<ffffffff8149ba7b>] system_call_fastpath+0x16/0x1b
NULL pointer dereference at           (null)
IP: [<ffffffff81073edf>] futex_wake+0x8f/0x130
PGD 13b3ff067 PUD 13b200067 PMD 0
Oops: 0000 [#22] PREEMPT SMP
CPU 1
Pid: 418, comm: udevadm Tainted: G      D     3.1.3+ #19 System manufacturer 
System Product Name/P5P43TD
RIP: 0010:[<ffffffff81073edf>]  [<ffffffff81073edf>] futex_wake+0x8f/0x130
RSP: 0018:ffff88013a8c1d58  EFLAGS: 00010286
RAX: 0000000000000000 RBX: 00000000ffffffff RCX: 00000000247555d6
RDX: ffffffff81830388 RSI: 00000000286b9fe7 RDI: ffffffffffffffe8
RBP: ffff88013a8c1db8 R08: 00000000492bbdda R09: 0000000000000000
R10: 00007fff15394160 R11: 0000000000000202 R12: 0000000000000001
R13: ffff88013a8c1d68 R14: 0000000000000000 R15: 0000000000000000
FS:  00007f451bff3700(0000) GS:ffff88013fc80000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000000000 CR3: 000000013b0ff000 CR4: 00000000000406e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process udevadm (pid: 418, threadinfo ffff88013a8c0000, task 
ffff88013b0e2b50)
Stack:
 ffff88013a8c1de8 ffffffff81830380 00007fff15394000 ffff88013b3e8000
 000000000000028c ffffea0004ff6780 ffff88013a8c1da8 0000000000000000
 00007fff1539428c 0000000000000001 0000000000000001 0000000000000000
Call Trace:
 [<ffffffff81075880>] do_futex+0xf0/0xba0
 [<ffffffff810c3570>] ? handle_mm_fault+0x130/0x220
 [<ffffffff81023c24>] ? do_page_fault+0x194/0x460
 [<ffffffff810fb87a>] ? mntput+0x1a/0x30
 [<ffffffff810d915d>] ? kmem_cache_free+0x8d/0x90
 [<ffffffff810763a6>] sys_futex+0x76/0x170
 [<ffffffff8149ba7b>] system_call_fastpath+0x16/0x1b
Code: 85 c0 75 d0 4c 89 ef e8 90 ef ff ff 48 89 c7 48 89 45 a8 e8 24 6d 42 
00 48 8b 55 a8 48 8b 42 08 48 83 c2 08 48 8d 78 e8 48 39 c2 <4c> 8b 7f 18 74 
6b 49 83 ef 18 eb 19 0f 1f 44 00 00 49 8d 47 18
RIP  [<ffffffff81073edf>] futex_wake+0x8f/0x130
 RSP <ffff88013a8c1d58>
CR2: 0000000000000000
---[ end trace bb26011d21a2b1e2 ]---
Intel AES-NI instructions are not detected.
Intel PCLMULQDQ-NI instructions are not detected.
BUG: unable to handle kernel NULL pointer dereference at           (null)
IP: [<ffffffff81073edf>] futex_wake+0x8f/0x130
PGD 13a827067 PUD 13a801067 PMD 0
Oops: 0000 [#23] PREEMPT SMP
CPU 0
Pid: 422, comm: udevadm Tainted: G      D     3.1.3+ #19 System manufacturer 
System Product Name/P5P43TD
RIP: 0010:[<ffffffff81073edf>]  [<ffffffff81073edf>] futex_wake+0x8f/0x130
RSP: 0018:ffff88013a8c9d58  EFLAGS: 00010286
RAX: 0000000000000000 RBX: 00000000ffffffff RCX: 000000005300294b
RDX: ffffffff81830fb8 RSI: 0000000069eee82d RDI: ffffffffffffffe8
RBP: ffff88013a8c9db8 R08: 000000004289b6c5 R09: 0000000000000000
R10: 00007fff0b560b90 R11: 0000000000000202 R12: 0000000000000001
R13: ffff88013a8c9d68 R14: 0000000000000000 R15: 0000000000000000
FS:  00007f1a53e51700(0000) GS:ffff88013fc00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000000000 CR3: 0000000135e4d000 CR4: 00000000000406f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process udevadm (pid: 422, threadinfo ffff88013a8c8000, task 
ffff88013b0c6f60)
Stack:
 ffff88013a8c9de8 ffffffff81830fb0 00007fff0b560000 ffff8801365cc000
 0000000000000cbc ffffea0004ff0800 ffff88013a8c9da8 0000000000000000
 00007fff0b560cbc 0000000000000001 0000000000000001 0000000000000000
Call Trace:
 [<ffffffff81075880>] do_futex+0xf0/0xba0
 [<ffffffff810c3570>] ? handle_mm_fault+0x130/0x220
 [<ffffffff81023c24>] ? do_page_fault+0x194/0x460
 [<ffffffff810fb87a>] ? mntput+0x1a/0x30
 [<ffffffff810d915d>] ? kmem_cache_free+0x8d/0x90
 [<ffffffff810763a6>] sys_futex+0x76/0x170
 [<ffffffff8149ba7b>] system_call_fastpath+0x16/0x1b
Code: 85 c0 75 d0 4c 89 ef e8 90 ef ff ff 48 89 c7 48 89 45 a8 e8 24 6d 42 
00 48 8b 55 a8 48 8b 42 08 48 83 c2 08 48 8d 78 e8 48 39 c2 <4c> 8b 7f 18 74 
6b 49 83 ef 18 eb 19 0f 1f 44 00 00 49 8d 47 18
RIP  [<ffffffff81073edf>] futex_wake+0x8f/0x130
 RSP <ffff88013a8c9d58>
CR2: 0000000000000000
---[ end trace bb26011d21a2b1e3 ]---
BUG: unable to handle kernel NULL pointer dereference
note: udevadm[422] exited with preempt_count 1
 at           (null)
IP: [<ffffffff81073edf>] futex_wake+0x8f/0x130
PGD 13587b067 PUD 1358ac067 PMD 0
Oops: 0000 [#24] PREEMPT SMP
CPU 3
Pid: 423, comm: udevadm Tainted: G      D     3.1.3+ #19 System manufacturer 
System Product Name/P5P43TD
RIP: 0010:[<ffffffff81073edf>]  [<ffffffff81073edf>] futex_wake+0x8f/0x130
RSP: 0018:ffff88013a8cbd58  EFLAGS: 00010282
RAX: 0000000000000000 RBX: 00000000ffffffff RCX: 00000000f3b7c34e
RDX: ffffffff81830880 RSI: 00000000901aa743 RDI: ffffffffffffffe8
RBP: ffff88013a8cbdb8 R08: 000000006908fe99 R09: 0000000000000000
R10: 00007fffb8e3e070 R11: 0000000000000202 R12: 0000000000000001
R13: ffff88013a8cbd68 R14: 0000000000000000 R15: 0000000000000000
FS:  00007f5e5fdb8700(0000) GS:ffff88013fd80000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000000000 CR3: 00000001358ef000 CR4: 00000000000406e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process udevadm (pid: 423, threadinfo ffff88013a8ca000, task 
ffff88013b0c7590)
Stack:
 ffff88013a8cbde8 ffffffff81830878 00007fffb8e3e000 ffff88013a8b4340
 000000000000019c ffffea0004ff4b00 ffff88013a8cbda8 0000000000000000
 00007fffb8e3e19c 0000000000000001 0000000000000001 0000000000000000
Call Trace:
 [<ffffffff81075880>] do_futex+0xf0/0xba0
 [<ffffffff810c3570>] ? handle_mm_fault+0x130/0x220
 [<ffffffff81023c24>] ? do_page_fault+0x194/0x460
 [<ffffffff810fb87a>] ? mntput+0x1a/0x30
 [<ffffffff810d915d>] ? kmem_cache_free+0x8d/0x90
 [<ffffffff810763a6>] sys_futex+0x76/0x170
 [<ffffffff8149ba7b>] system_call_fastpath+0x16/0x1b
Code: 85 c0 75 d0 4c 89 ef e8 90 ef ff ff 48 89 c7 48 89 45 a8 e8 24 6d 42 
00 48 8b 55 a8 48 8b 42 08 48 83 c2 08 48 8d 78 e8 48 39 c2 <4c> 8b 7f 18 74 
6b 49 83 ef 18 eb 19 0f 1f 44 00 00 49 8d 47 18
RIP  [<ffffffff81073edf>] futex_wake+0x8f/0x130
 RSP <ffff88013a8cbd58>
CR2: 0000000000000000
---[ end trace bb26011d21a2b1e4 ]---
note: udevadm[423] exited with preempt_count 1
audit: initializing netlink socket (disabled)
type=2000 audit(1322462290.224:1): initialized
note: udevadm[418] exited with preempt_count 1
BUG: scheduling while atomic: udevadm/418/0x10000002
Modules linked in:
Pid: 418, comm: udevadm Tainted: G      D     3.1.3+ #19
Call Trace:
 [<ffffffff8103b47c>] __schedule_bug+0x5c/0x60
 [<ffffffff81498dd1>] __schedule+0x6b1/0x8b0
Btrfs loaded
msgmni has been set to 7903
 [<ffffffff81258a21>] ? delay_tsc+0xd1/0xe0
Block layer SCSI generic (bsg) driver version 0.4 loaded (major 254)
 [<ffffffff8149b0a9>] ? _raw_spin_unlock_irqrestore+0x29/0x40
 [<ffffffff81281d77>] ? vgacon_scroll+0x157/0x340
io scheduler noop registered
io scheduler cfq registered (default)
pcieport 0000:00:01.0: setting latency timer to 64
pcieport 0000:00:01.0: irq 40 for MSI/MSI-X
pcieport 0000:00:1c.0: setting latency timer to 64
pcieport 0000:00:1c.0: irq 41 for MSI/MSI-X
pcieport 0000:00:1c.4: setting latency timer to 64
pcieport 0000:00:1c.4: irq 42 for MSI/MSI-X
pcieport 0000:00:1c.5: setting latency timer to 64
pcieport 0000:00:1c.5: irq 43 for MSI/MSI-X
intel_idle: MWAIT substates: 0x22220
intel_idle: does not run on family 6 model 23
ERST: Table is not found!
Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
 [<ffffffff81068fcc>] ? __atomic_notifier_call_chain+0x4c/0x70
 [<ffffffff8103fbe5>] __cond_resched+0x25/0x40
00:0c: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
ramoops: platform device not found, using module parameters
ramoops: The memory size and the record size must be non-zero
ramoops: probe of ramoops failed with error -22
ahci 0000:00:1f.2: version 3.0
ahci 0000:00:1f.2: PCI INT B -> GSI 19 (level, low) -> IRQ 19
 [<ffffffff8149904c>] _cond_resched+0x2c/0x40
ahci 0000:00:1f.2: irq 44 for MSI/MSI-X
ahci: SSS flag set, parallel bus scan disabled
ahci 0000:00:1f.2: AHCI 0001.0200 32 slots 6 ports 3 Gbps 0x3f impl SATA 
mode
ahci 0000:00:1f.2: flags: 64bit ncq sntf stag pm led clo pmp pio slum part 
ccc ems sxs
ahci 0000:00:1f.2: setting latency timer to 64
 [<ffffffff810c241d>] unmap_vmas+0x4ed/0x6d0
 [<ffffffff810c90d8>] exit_mmap+0xa8/0x110
 [<ffffffff81048317>] ? vprintk+0x357/0x4a0
 [<ffffffff8104501d>] mmput+0x2d/0xe0
 [<ffffffff810495bf>] exit_mm+0x10f/0x140
 [<ffffffff8149b068>] ? _raw_spin_unlock_irq+0x28/0x40
scsi0 : ahci
scsi1 : ahci
scsi2 : ahci
scsi3 : ahci
scsi4 : ahci
scsi5 : ahci
ata1: SATA max UDMA/133 abar m2048@0xfcffc000 port 0xfcffc100 irq 44
ata2: SATA max UDMA/133 abar m2048@0xfcffc000 port 0xfcffc180 irq 44
ata3: SATA max UDMA/133 abar m2048@0xfcffc000 port 0xfcffc200 irq 44
ata4: SATA max UDMA/133 abar m2048@0xfcffc000 port 0xfcffc280 irq 44
ata5: SATA max UDMA/133 abar m2048@0xfcffc000 port 0xfcffc300 irq 44
ata6: SATA max UDMA/133 abar m2048@0xfcffc000 port 0xfcffc380 irq 44
pata_jmicron 0000:03:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
pata_jmicron 0000:03:00.0: setting latency timer to 64
scsi6 : pata_jmicron
 [<ffffffff8104acc1>] do_exit+0x141/0x7e0
scsi7 : pata_jmicron
ata7: PATA max UDMA/100 cmd 0xec00 ctl 0xe880 bmdma 0xe400 irq 16
ata8: PATA max UDMA/100 cmd 0xe800 ctl 0xe480 bmdma 0xe408 irq 16
 [<ffffffff81005455>] oops_end+0x75/0xa0
 [<ffffffff81023480>] no_context+0xf0/0x260
 [<ffffffff81023715>] __bad_area_nosemaphore+0x125/0x210
ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
ehci_hcd 0000:00:1a.7: PCI INT C -> GSI 18 (level, low) -> IRQ 18
ehci_hcd 0000:00:1a.7: setting latency timer to 64
ehci_hcd 0000:00:1a.7: EHCI Host Controller
ehci_hcd 0000:00:1a.7: new USB bus registered, assigned bus number 1
ehci_hcd 0000:00:1a.7: debug port 1
ehci_hcd 0000:00:1a.7: cache line size of 32 is not supported
ehci_hcd 0000:00:1a.7: irq 18, io mem 0xfcfff000
 [<ffffffff8102380e>] bad_area_nosemaphore+0xe/0x10
ehci_hcd 0000:00:1a.7: USB 2.0 started, EHCI 1.00
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 6 ports detected
ehci_hcd 0000:00:1d.7: PCI INT A -> GSI 23 (level, low) -> IRQ 23
ehci_hcd 0000:00:1d.7: setting latency timer to 64
ehci_hcd 0000:00:1d.7: EHCI Host Controller
ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 2
ehci_hcd 0000:00:1d.7: debug port 1
ehci_hcd 0000:00:1d.7: cache line size of 32 is not supported
ehci_hcd 0000:00:1d.7: irq 23, io mem 0xfcffe000
 [<ffffffff81023e32>] do_page_fault+0x3a2/0x460
ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 6 ports detected
uhci_hcd: USB Universal Host Controller Interface driver
uhci_hcd 0000:00:1a.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
uhci_hcd 0000:00:1a.0: setting latency timer to 64
uhci_hcd 0000:00:1a.0: UHCI Host Controller
uhci_hcd 0000:00:1a.0: new USB bus registered, assigned bus number 3
uhci_hcd 0000:00:1a.0: irq 16, io base 0x0000b800
hub 3-0:1.0: USB hub found
hub 3-0:1.0: 2 ports detected
uhci_hcd 0000:00:1a.1: PCI INT B -> GSI 21 (level, low) -> IRQ 21
uhci_hcd 0000:00:1a.1: setting latency timer to 64
uhci_hcd 0000:00:1a.1: UHCI Host Controller
uhci_hcd 0000:00:1a.1: new USB bus registered, assigned bus number 4
uhci_hcd 0000:00:1a.1: irq 21, io base 0x0000b880
hub 4-0:1.0: USB hub found
hub 4-0:1.0: 2 ports detected
uhci_hcd 0000:00:1a.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
uhci_hcd 0000:00:1a.2: setting latency timer to 64
uhci_hcd 0000:00:1a.2: UHCI Host Controller
uhci_hcd 0000:00:1a.2: new USB bus registered, assigned bus number 5
uhci_hcd 0000:00:1a.2: irq 18, io base 0x0000bc00
hub 5-0:1.0: USB hub found
hub 5-0:1.0: 2 ports detected
uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 23 (level, low) -> IRQ 23
uhci_hcd 0000:00:1d.0: setting latency timer to 64
uhci_hcd 0000:00:1d.0: UHCI Host Controller
uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 6
uhci_hcd 0000:00:1d.0: irq 23, io base 0x0000b080
hub 6-0:1.0: USB hub found
hub 6-0:1.0: 2 ports detected
uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 19 (level, low) -> IRQ 19
uhci_hcd 0000:00:1d.1: setting latency timer to 64
uhci_hcd 0000:00:1d.1: UHCI Host Controller
uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 7
uhci_hcd 0000:00:1d.1: irq 19, io base 0x0000b400
hub 7-0:1.0: USB hub found
hub 7-0:1.0: 2 ports detected
uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
uhci_hcd 0000:00:1d.2: setting latency timer to 64
uhci_hcd 0000:00:1d.2: UHCI Host Controller
uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 8
uhci_hcd 0000:00:1d.2: irq 18, io base 0x0000b480
hub 8-0:1.0: USB hub found
hub 8-0:1.0: 2 ports detected
usbcore: registered new interface driver cdc_acm
cdc_acm: USB Abstract Control Model driver for USB modems and ISDN adapters
Initializing USB Mass Storage driver...
usbcore: registered new interface driver usb-storage
USB Mass Storage support registered.
 [<ffffffff810ae64d>] ? __alloc_pages_nodemask+0x10d/0x700
i8042: PNP: No PS/2 controller found. Probing ports directly.
 [<ffffffff8149b66f>] page_fault+0x1f/0x30
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX port at 0x60,0x64 irq 12
mousedev: PS/2 mouse device common for all mice
md: linear personality registered for level -1
md: raid0 personality registered for level 0
md: raid1 personality registered for level 1
md: raid10 personality registered for level 10
md: raid6 personality registered for level 6
md: raid5 personality registered for level 5
md: raid4 personality registered for level 4
md: multipath personality registered for level -4
device-mapper: uevent: version 1.0.3
device-mapper: ioctl: 4.21.0-ioctl (2011-07-06) initialised: dm-
devel@redhat.com
device-mapper: multipath: version 1.3.0 loaded
device-mapper: multipath round-robin: version 1.0.0 loaded
device-mapper: multipath queue-length: version 0.1.0 loaded
cpuidle: using governor ladder
cpuidle: using governor menu
usbcore: registered new interface driver usbhid
usbhid: USB HID core driver
TCP cubic registered
Registering the dns_resolver key type
 [<ffffffff81073edf>] ? futex_wake+0x8f/0x130
 [<ffffffff81073ecc>] ? futex_wake+0x7c/0x130
 [<ffffffff81075880>] do_futex+0xf0/0xba0
 [<ffffffff810c3570>] ? handle_mm_fault+0x130/0x220
 [<ffffffff81023c24>] ? do_page_fault+0x194/0x460
 [<ffffffff810fb87a>] ? mntput+0x1a/0x30
 [<ffffffff810d915d>] ? kmem_cache_free+0x8d/0x90
 [<ffffffff810763a6>] sys_futex+0x76/0x170
 [<ffffffff8149ba7b>] system_call_fastpath+0x16/0x1b
ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
ata1.00: ATA-7: SSDSA2SH032G1GN INTEL, 045C8860, max UDMA/133
ata1.00: 62500000 sectors, multi 1: LBA48 NCQ (depth 31)
ata1.00: configured for UDMA/133
scsi 0:0:0:0: Direct-Access     ATA      SSDSA2SH032G1GN  045C PQ: 0 ANSI: 5
sd 0:0:0:0: [sda] 62500000 512-byte logical blocks: (32.0 GB/29.8 GiB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support 
DPO or FUA
usb 2-2: new high speed USB device number 3 using ehci_hcd
 sda: unknown partition table
sd 0:0:0:0: [sda] Attached SCSI disk
scsi8 : usb-storage 2-2:1.0
usb 2-3: new high speed USB device number 4 using ehci_hcd
ata2: SATA link down (SStatus 0 SControl 300)
scsi9 : usb-storage 2-3:1.0
ata3: SATA link down (SStatus 0 SControl 300)
usb 6-1: new full speed USB device number 2 using uhci_hcd
ata4: SATA link down (SStatus 0 SControl 300)
scsi 8:0:0:0: Direct-Access     HP       v125w            PMAP PQ: 0 ANSI: 0 
CCS
scsi: killing requests for dead queue
scsi: killing requests for dead queue
scsi: killing requests for dead queue
scsi: killing requests for dead queue
scsi: killing requests for dead queue
scsi: killing requests for dead queue
scsi: killing requests for dead queue
scsi: killing requests for dead queue
sd 8:0:0:0: [sdb] 7827456 512-byte logical blocks: (4.00 GB/3.73 GiB)
usb 8-1: new full speed USB device number 2 using uhci_hcd
sd 8:0:0:0: [sdb] Write Protect is off
sd 8:0:0:0: [sdb] Mode Sense: 23 00 00 00
sd 8:0:0:0: [sdb] No Caching mode page present
sd 8:0:0:0: [sdb] Assuming drive cache: write through
sd 8:0:0:0: [sdb] No Caching mode page present
sd 8:0:0:0: [sdb] Assuming drive cache: write through
 sdb: sdb1
sd 8:0:0:0: [sdb] No Caching mode page present
sd 8:0:0:0: [sdb] Assuming drive cache: write through
sd 8:0:0:0: [sdb] Attached SCSI removable disk
scsi 9:0:0:0: Direct-Access     T-Mobile myTouch 4G       0100 PQ: 0 ANSI: 2
scsi: killing requests for dead queue
scsi: killing requests for dead queue
scsi: killing requests for dead queue
scsi: killing requests for dead queue
scsi: killing requests for dead queue
scsi: killing requests for dead queue
scsi: killing requests for dead queue
scsi: killing requests for dead queue
sd 9:0:0:0: [sdc] Attached SCSI removable disk
ata5: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
usb 8-2: new full speed USB device number 3 using uhci_hcd
hub 8-2:1.0: USB hub found
hub 8-2:1.0: 3 ports detected
ata5.00: ATAPI: PLEXTOR DVDR   PX-755A, 1.02, max UDMA/66
ata5.00: applying bridge limits
ata5.00: configured for UDMA/66
scsi 4:0:0:0: CD-ROM            PLEXTOR  DVDR   PX-755A   1.02 PQ: 0 ANSI: 5
usb 8-2.1: new low speed USB device number 4 using uhci_hcd
input: Logitech Trackball as 
/devices/pci0000:00/0000:00:1d.2/usb8/8-2/8-2.1/8-2.1:1.0/input/input0
generic-usb 0003:046D:C404.0001: input,hidraw0: USB HID v1.10 Mouse 
[Logitech Trackball] on usb-0000:00:1d.2-2.1/input0
usb 8-2.2: new low speed USB device number 5 using uhci_hcd
ata6: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
ata6.00: ATA-7: Hitachi HDS721680PLA380, P21OABEA, max UDMA/133
ata6.00: 160836480 sectors, multi 0: LBA48 NCQ (depth 31/32), AA
ata6.00: configured for UDMA/133
scsi 5:0:0:0: Direct-Access     ATA      Hitachi HDS72168 P21O PQ: 0 ANSI: 5
sd 5:0:0:0: [sdd] 160836480 512-byte logical blocks: (82.3 GB/76.6 GiB)
sd 5:0:0:0: [sdd] Write Protect is off
sd 5:0:0:0: [sdd] Mode Sense: 00 3a 00 00
sd 5:0:0:0: [sdd] Write cache: enabled, read cache: enabled, doesn't support 
DPO or FUA
 sdd: unknown partition table
sd 5:0:0:0: [sdd] Attached SCSI disk
input: Gravis Eliminator AfterShock    as 
/devices/pci0000:00/0000:00:1d.2/usb8/8-2/8-2.2/8-2.2:1.0/input/input1
generic-usb 0003:047D:4006.0002: input,hidraw1: USB HID v1.10 Gamepad 
[Gravis Eliminator AfterShock   ] on usb-0000:00:1d.2-2.2/input0
Freeing unused kernel memory: 480k freed

