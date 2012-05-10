Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760062Ab2EJPUJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 11:20:09 -0400
Received: from e23smtp02.au.ibm.com ([202.81.31.144]:57893 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757805Ab2EJPUC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 11:20:02 -0400
From: Nikunj A Dadhania <nikunj@linux.vnet.ibm.com>
To: Avi Kivity <avi@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>, KVM <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: KVM: Softlockups in guests while running kernbench
In-Reply-To: <4FAB88B8.5060203@redhat.com>
References: <87wr4kjvtk.fsf@abhimanyu.in.ibm.com> <4FAB88B8.5060203@redhat.com>
User-Agent: Notmuch/0.10.2+70~gf0e0053 (http://notmuchmail.org) Emacs/24.0.95.1 (x86_64-unknown-linux-gnu)
Date: Thu, 10 May 2012 15:39:04 +0530
Message-ID: <87pqace4an.fsf@abhimanyu.in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain
x-cbid: 12050923-5490-0000-0000-0000015B2267
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 10 May 2012 12:22:00 +0300, Avi Kivity <avi@redhat.com> wrote:
> On 05/10/2012 11:15 AM, Nikunj A Dadhania wrote:
> > I am running a 3.4.0-rc4 based kernel(commit: af3a3ab2), guest config
> > attached.
> >
> > During my tests, I saw few softlockups inside the guests while running
> > kernbench inside the guest. I can reproduce this repeatedly.
> >
> > Test Setup:
> >
> > - Create 4 VMs (8vcpu, 1GB RAM)
> > - Run kernbench inside each guests (kernbench -f -M -H -o 16) in parallel
> >
> 
> How overcommitted are you?  
8 Physical CPU and 32 vCPUs

> What does the host hardware look like?  
Machine : IBM xSeries with Intel(R) Xeon(R) x5570 2.93GHz CPU with 8 core , 64GB RAM
Threading is disabled.

> Is there any load on the host?
No

> 
> The traces themselves always point a couple of instructions after
> interrupts are enabled.  Can you post a few more?
> 
Console logs of one VM:

----------------------------------------------------------------
BUG: soft lockup - CPU#1 stuck for 22s! [khugepaged:52]
Modules linked in:
CPU 1 
Modules linked in:

Pid: 52, comm: khugepaged Not tainted 3.4.0-rc4-base+ #1 Red Hat KVM
RIP: 0010:[<ffffffff815e34d9>]  [<ffffffff815e34d9>] _raw_spin_unlock_irqrestore+0x19/0x30
RSP: 0000:ffff880038189a38  EFLAGS: 00000286
RAX: 0000000000000000 RBX: ffff88003df90000 RCX: ffff88003d981680
RDX: ffffea00005647d8 RSI: 0000000000000286 RDI: 0000000000000286
RBP: ffff880038189a40 R08: ffffea0000562ae0 R09: f600000000000000
R10: ffff88003d981680 R11: 0000000000000000 R12: ffff880038189a00
R13: ffff88003d655258 R14: 0000000000000297 R15: ffffea000055ebf8
FS:  0000000000000000(0000) GS:ffff88003d640000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 00007ff586ffc000 CR3: 0000000001a0b000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process khugepaged (pid: 52, threadinfo ffff880038188000, task ffff880038182b30)
Stack:
BUG: soft lockup - CPU#3 stuck for 22s! [cc1:5177]
Modules linked in:
CPU 3 
Modules linked in:

Pid: 5177, comm: cc1 Not tainted 3.4.0-rc4-base+ #1 Red Hat KVM
RIP: 0010:[<ffffffff815e34d9>]  [<ffffffff815e34d9>] _raw_spin_unlock_irqrestore+0x19/0x30
RSP: 0018:ffff88003806fcc0  EFLAGS: 00000286
RAX: ffffea0000a5ef68 RBX: ffffffff8110d7f8 RCX: ffff88003d981680
RDX: ffffea0000a5e1a0 RSI: 0000000000000286 RDI: 0000000000000286
RBP: ffff88003806fcc8 R08: ffffea0000a5e1a0 R09: 0000000000000000
R10: ffff88003e7fdfb8 R11: 0000000000000000 R12: 0000000000000297
R13: ffff88003806fc88 R14: ffff88003d6d5258 R15: 0000000000000297
FS:  0000000000000000(0000) GS:ffff88003d6c0000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000003cddcaae90 CR3: 0000000001a0b000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process cc1 (pid: 5177, threadinfo ffff88003806e000, task ffff88003dc914a0)
Stack:
 000000000000000e ffff88003806fd48 ffffffff8110d7ed ffff88003806fd78
 ffffea0000a5ef68 ffff88003d981680 0000000000000005 0000000000000286
 0000000200000000 ffffea0000a5ef68 ffffea0000a35908 0000000000000000
Call Trace:
 [<ffffffff8110d7ed>] release_pages+0x1ad/0x210
 [<ffffffff81139424>] free_pages_and_swap_cache+0xb4/0xe0
 [<ffffffff812d1da1>] ? cpumask_any_but+0x31/0x50
 [<ffffffff8112515c>] tlb_flush_mmu+0x6c/0x90
 [<ffffffff81125644>] tlb_finish_mmu+0x14/0x40
 [<ffffffff8112c4a8>] exit_mmap+0xd8/0x140
 [<ffffffff8103e143>] mmput+0x73/0x120
 [<ffffffff81044fca>] exit_mm+0x10a/0x140
 [<ffffffff8104516b>] do_exit+0x16b/0x450
 [<ffffffff810454a5>] do_group_exit+0x55/0xd0
 [<ffffffff81045537>] sys_exit_group+0x17/0x20
 [<ffffffff815eb9e9>] system_call_fastpath+0x16/0x1b
Code: 66 90 e8 db b9 a4 ff 66 90 c9 c3 0f 1f 80 00 00 00 00 55 48 89 e5 53 66 66 66 66 90 48 89 f3 e8 1e ba a4 ff 66 90 48 89 df 57 9d <66> 66 90 66 90 5b c9 c3 66 66 66 66 66 66 2e 0f 1f 84 00 00 00 
Call Trace:
 [<ffffffff8110d7ed>] release_pages+0x1ad/0x210
 [<ffffffff81139424>] free_pages_and_swap_cache+0xb4/0xe0
 [<ffffffff812d1da1>] ? cpumask_any_but+0x31/0x50
 [<ffffffff8112515c>] tlb_flush_mmu+0x6c/0x90
 [<ffffffff81125644>] tlb_finish_mmu+0x14/0x40
 [<ffffffff8112c4a8>] exit_mmap+0xd8/0x140
 [<ffffffff8103e143>] mmput+0x73/0x120
 [<ffffffff81044fca>] exit_mm+0x10a/0x140
 [<ffffffff8104516b>] do_exit+0x16b/0x450
 [<ffffffff810454a5>] do_group_exit+0x55/0xd0
 [<ffffffff81045537>] sys_exit_group+0x17/0x20
 [<ffffffff815eb9e9>] system_call_fastpath+0x16/0x1b
 000000000000000e ffff880038189ac0 ffffffff8110d7ed 0000000000000004
 ffffea00005c1238 ffff88003d981680 0000000000000009 0000000000000286
 0000000200000282 ffffea00005c1238 ffffea0000562878 0000000000000010
Call Trace:
 [<ffffffff8110d7ed>] release_pages+0x1ad/0x210
 [<ffffffff8110d250>] ? add_page_to_unevictable_list+0xd0/0xd0
 [<ffffffff8110d91f>] pagevec_lru_move_fn+0xcf/0xf0
 [<ffffffff8110d957>] __pagevec_lru_add+0x17/0x20
 [<ffffffff8110ddc8>] __lru_cache_add+0x68/0x90
 [<ffffffff8115bed9>] ? __mem_cgroup_uncharge_common+0xf9/0x280
 [<ffffffff8110de1d>] lru_cache_add_lru+0x2d/0x50
 [<ffffffff81112919>] putback_lru_page+0x69/0xe0
 [<ffffffff81151eeb>] release_pte_page+0x2b/0x40
 [<ffffffff81152335>] __collapse_huge_page_copy+0x185/0x200
 [<ffffffff81152096>] ? __collapse_huge_page_isolate+0x116/0x1c0
 [<ffffffff811526d7>] collapse_huge_page+0x327/0x500
 [<ffffffff81152a75>] khugepaged_scan_pmd+0x1c5/0x2f0
 [<ffffffff815e240e>] ? __schedule+0x3de/0x710
 [<ffffffff81152ffe>] khugepaged_scan_mm_slot+0x17e/0x280
 [<ffffffff8115407c>] khugepaged_do_scan+0xbc/0xe0
 [<ffffffff81154f5f>] khugepaged_loop+0x5f/0x3c0
 [<ffffffff81062bd0>] ? wake_up_bit+0x40/0x40
 [<ffffffff811552c0>] ? khugepaged_loop+0x3c0/0x3c0
 [<ffffffff8115530a>] khugepaged+0x4a/0xb0
 [<ffffffff810624fe>] kthread+0x9e/0xb0
 [<ffffffff815ecce4>] kernel_thread_helper+0x4/0x10
 [<ffffffff81062460>] ? kthread_freezable_should_stop+0x70/0x70
 [<ffffffff815ecce0>] ? gs_change+0x13/0x13
Code: 66 90 e8 db b9 a4 ff 66 90 c9 c3 0f 1f 80 00 00 00 00 55 48 89 e5 53 66 66 66 66 90 48 89 f3 e8 1e ba a4 ff 66 90 48 89 df 57 9d <66> 66 90 66 90 5b c9 c3 66 66 66 66 66 66 2e 0f 1f 84 00 00 00 
Call Trace:
 [<ffffffff8110d7ed>] release_pages+0x1ad/0x210
 [<ffffffff8110d250>] ? add_page_to_unevictable_list+0xd0/0xd0
 [<ffffffff8110d91f>] pagevec_lru_move_fn+0xcf/0xf0
 [<ffffffff8110d957>] __pagevec_lru_add+0x17/0x20
 [<ffffffff8110ddc8>] __lru_cache_add+0x68/0x90
 [<ffffffff8115bed9>] ? __mem_cgroup_uncharge_common+0xf9/0x280
 [<ffffffff8110de1d>] lru_cache_add_lru+0x2d/0x50
 [<ffffffff81112919>] putback_lru_page+0x69/0xe0
 [<ffffffff81151eeb>] release_pte_page+0x2b/0x40
 [<ffffffff81152335>] __collapse_huge_page_copy+0x185/0x200
 [<ffffffff81152096>] ? __collapse_huge_page_isolate+0x116/0x1c0
 [<ffffffff811526d7>] collapse_huge_page+0x327/0x500
 [<ffffffff81152a75>] khugepaged_scan_pmd+0x1c5/0x2f0
 [<ffffffff815e240e>] ? __schedule+0x3de/0x710
 [<ffffffff81152ffe>] khugepaged_scan_mm_slot+0x17e/0x280
 [<ffffffff8115407c>] khugepaged_do_scan+0xbc/0xe0
 [<ffffffff81154f5f>] khugepaged_loop+0x5f/0x3c0
 [<ffffffff81062bd0>] ? wake_up_bit+0x40/0x40
 [<ffffffff811552c0>] ? khugepaged_loop+0x3c0/0x3c0
 [<ffffffff8115530a>] khugepaged+0x4a/0xb0
 [<ffffffff810624fe>] kthread+0x9e/0xb0
 [<ffffffff815ecce4>] kernel_thread_helper+0x4/0x10
 [<ffffffff81062460>] ? kthread_freezable_should_stop+0x70/0x70
 [<ffffffff815ecce0>] ? gs_change+0x13/0x13
hdparm: sending ioctl 330 to a partition!
hdparm: sending ioctl 330 to a partition!
hdparm: sending ioctl 330 to a partition!
hdparm: sending ioctl 330 to a partition!
hdparm: sending ioctl 330 to a partition!
hdparm: sending ioctl 330 to a partition!
hdparm: sending ioctl 330 to a partition!
hdparm: sending ioctl 330 to a partition!
hdparm: sending ioctl 330 to a partition!
hdparm: sending ioctl 330 to a partition!
BUG: soft lockup - CPU#6 stuck for 22s! [khugepaged:52]
Modules linked in:
CPU 6 
Modules linked in:

Pid: 52, comm: khugepaged Not tainted 3.4.0-rc4-base+ #1 Red Hat KVM
RIP: 0010:[<ffffffff815e34d9>]  [<ffffffff815e34d9>] _raw_spin_unlock_irqrestore+0x19/0x30
RSP: 0018:ffff880038189ab8  EFLAGS: 00000282
RAX: 0000000000000282 RBX: 000000000000000e RCX: ffffc90000182000
RDX: 0000000000000009 RSI: 0000000000000282 RDI: 0000000000000282
RBP: ffff880038189ac0 R08: 000000000000000a R09: 9e00000000000000
R10: ffff88003d981680 R11: 0000000000000000 R12: ffff88003d78f1e0
R13: 000000000000000e R14: 0000000000000010 R15: ffffffff81109eaf
FS:  0000000000000000(0000) GS:ffff88003d780000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 00007f6ffe87f000 CR3: 0000000001a0b000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process khugepaged (pid: 52, threadinfo ffff880038188000, task ffff880038182b30)
Stack:
 ffff88003d78f160 ffff880038189b10 ffffffff8110d90f 0000000000000282
 0000000000000001 ffffea00009e05e0 ffffea00007efa78 ffff88003d78f160
 0000000000000000 00000000ffffffff 000000000067ddb8 ffff880038189b20
Call Trace:
 [<ffffffff8110d90f>] pagevec_lru_move_fn+0xbf/0xf0
 [<ffffffff8110d957>] __pagevec_lru_add+0x17/0x20
 [<ffffffff8110ddc8>] __lru_cache_add+0x68/0x90
 [<ffffffff8115bed9>] ? __mem_cgroup_uncharge_common+0xf9/0x280
 [<ffffffff8110de1d>] lru_cache_add_lru+0x2d/0x50
 [<ffffffff81112919>] putback_lru_page+0x69/0xe0
 [<ffffffff81151eeb>] release_pte_page+0x2b/0x40
 [<ffffffff81152335>] __collapse_huge_page_copy+0x185/0x200
 [<ffffffff81152096>] ? __collapse_huge_page_isolate+0x116/0x1c0
 [<ffffffff811526d7>] collapse_huge_page+0x327/0x500
 [<ffffffff812d84be>] ? rb_erase+0xce/0x150
 [<ffffffff81152a75>] khugepaged_scan_pmd+0x1c5/0x2f0
 [<ffffffff81152ffe>] khugepaged_scan_mm_slot+0x17e/0x280
 [<ffffffff8115407c>] khugepaged_do_scan+0xbc/0xe0
 [<ffffffff81154f5f>] khugepaged_loop+0x5f/0x3c0
 [<ffffffff81062bd0>] ? wake_up_bit+0x40/0x40
 [<ffffffff811552c0>] ? khugepaged_loop+0x3c0/0x3c0
 [<ffffffff8115530a>] khugepaged+0x4a/0xb0
 [<ffffffff810624fe>] kthread+0x9e/0xb0
 [<ffffffff815ecce4>] kernel_thread_helper+0x4/0x10
 [<ffffffff81062460>] ? kthread_freezable_should_stop+0x70/0x70
 [<ffffffff815ecce0>] ? gs_change+0x13/0x13
Code: 66 90 e8 db b9 a4 ff 66 90 c9 c3 0f 1f 80 00 00 00 00 55 48 89 e5 53 66 66 66 66 90 48 89 f3 e8 1e ba a4 ff 66 90 48 89 df 57 9d <66> 66 90 66 90 5b c9 c3 66 66 66 66 66 66 2e 0f 1f 84 00 00 00 
Call Trace:
 [<ffffffff8110d90f>] pagevec_lru_move_fn+0xbf/0xf0
 [<ffffffff8110d957>] __pagevec_lru_add+0x17/0x20
 [<ffffffff8110ddc8>] __lru_cache_add+0x68/0x90
 [<ffffffff8115bed9>] ? __mem_cgroup_uncharge_common+0xf9/0x280
 [<ffffffff8110de1d>] lru_cache_add_lru+0x2d/0x50
 [<ffffffff81112919>] putback_lru_page+0x69/0xe0
 [<ffffffff81151eeb>] release_pte_page+0x2b/0x40
 [<ffffffff81152335>] __collapse_huge_page_copy+0x185/0x200
 [<ffffffff81152096>] ? __collapse_huge_page_isolate+0x116/0x1c0
 [<ffffffff811526d7>] collapse_huge_page+0x327/0x500
 [<ffffffff812d84be>] ? rb_erase+0xce/0x150
 [<ffffffff81152a75>] khugepaged_scan_pmd+0x1c5/0x2f0
 [<ffffffff81152ffe>] khugepaged_scan_mm_slot+0x17e/0x280
 [<ffffffff8115407c>] khugepaged_do_scan+0xbc/0xe0
 [<ffffffff81154f5f>] khugepaged_loop+0x5f/0x3c0
 [<ffffffff81062bd0>] ? wake_up_bit+0x40/0x40
 [<ffffffff811552c0>] ? khugepaged_loop+0x3c0/0x3c0
 [<ffffffff8115530a>] khugepaged+0x4a/0xb0
 [<ffffffff810624fe>] kthread+0x9e/0xb0
 [<ffffffff815ecce4>] kernel_thread_helper+0x4/0x10
 [<ffffffff81062460>] ? kthread_freezable_should_stop+0x70/0x70
 [<ffffffff815ecce0>] ? gs_change+0x13/0x13
BUG: soft lockup - CPU#2 stuck for 22s! [cc1:5311]
Modules linked in:
CPU 2 
Modules linked in:

Pid: 5311, comm: cc1 Not tainted 3.4.0-rc4-base+ #1 Red Hat KVM
RIP: 0010:[<ffffffff815e34d9>]  [<ffffffff815e34d9>] _raw_spin_unlock_irqrestore+0x19/0x30
RSP: 0018:ffff880038a99cc0  EFLAGS: 00000286
RAX: ffffea0000ad9d50 RBX: ffffffff8110d7f8 RCX: ffff88003d981680
RDX: ffffea000054b348 RSI: 0000000000000286 RDI: 0000000000000286
RBP: ffff880038a99cc8 R08: ffffea000054b348 R09: 0000000000000000
R10: ffff88003e7fdf88 R11: 0000000000000000 R12: 0000000000000297
R13: ffff880038a99c88 R14: ffff88003d695258 R15: 0000000000000297
FS:  0000000000000000(0000) GS:ffff88003d680000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000003cddcaae90 CR3: 0000000001a0b000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process cc1 (pid: 5311, threadinfo ffff880038a98000, task ffff88003dc90a70)
Stack:
 000000000000000e ffff880038a99d48 ffffffff8110d7ed ffff880038a99d78
 ffffea0000ad9d50 ffff88003d981680 0000000000000005 0000000000000286
 0000000200000000 ffffea0000ad9d50 ffffea000096e760 0000000000000000
Call Trace:
 [<ffffffff8110d7ed>] release_pages+0x1ad/0x210
 [<ffffffff81139424>] free_pages_and_swap_cache+0xb4/0xe0
 [<ffffffff812d1da1>] ? cpumask_any_but+0x31/0x50
 [<ffffffff8112515c>] tlb_flush_mmu+0x6c/0x90
 [<ffffffff81125644>] tlb_finish_mmu+0x14/0x40
 [<ffffffff8112c4a8>] exit_mmap+0xd8/0x140
 [<ffffffff8103e143>] mmput+0x73/0x120
 [<ffffffff81044fca>] exit_mm+0x10a/0x140
 [<ffffffff8104516b>] do_exit+0x16b/0x450
 [<ffffffff810454a5>] do_group_exit+0x55/0xd0
 [<ffffffff81045537>] sys_exit_group+0x17/0x20
 [<ffffffff815eb9e9>] system_call_fastpath+0x16/0x1b
Code: 66 90 e8 db b9 a4 ff 66 90 c9 c3 0f 1f 80 00 00 00 00 55 48 89 e5 53 66 66 66 66 90 48 89 f3 e8 1e ba a4 ff 66 90 48 89 df 57 9d <66> 66 90 66 90 5b c9 c3 66 66 66 66 66 66 2e 0f 1f 84 00 00 00 
Call Trace:
 [<ffffffff8110d7ed>] release_pages+0x1ad/0x210
 [<ffffffff81139424>] free_pages_and_swap_cache+0xb4/0xe0
 [<ffffffff812d1da1>] ? cpumask_any_but+0x31/0x50
 [<ffffffff8112515c>] tlb_flush_mmu+0x6c/0x90
 [<ffffffff81125644>] tlb_finish_mmu+0x14/0x40
 [<ffffffff8112c4a8>] exit_mmap+0xd8/0x140
 [<ffffffff8103e143>] mmput+0x73/0x120
 [<ffffffff81044fca>] exit_mm+0x10a/0x140
 [<ffffffff8104516b>] do_exit+0x16b/0x450
 [<ffffffff810454a5>] do_group_exit+0x55/0xd0
 [<ffffffff81045537>] sys_exit_group+0x17/0x20
 [<ffffffff815eb9e9>] system_call_fastpath+0x16/0x1b
BUG: soft lockup - CPU#4 stuck for 22s! [cc1:5296]
Modules linked in:
CPU 4 
Modules linked in:

Pid: 5296, comm: cc1 Not tainted 3.4.0-rc4-base+ #1 Red Hat KVM
RIP: 0010:[<ffffffff815e34d9>]  [<ffffffff815e34d9>] _raw_spin_unlock_irqrestore+0x19/0x30
RSP: 0018:ffff88003b201cc0  EFLAGS: 00000286
RAX: ffffea0000540090 RBX: 0000000001a03025 RCX: ffff88003d981680
RDX: ffffea0000540058 RSI: 0000000000000286 RDI: 0000000000000286
RBP: ffff88003b201cc8 R08: ffffea0000540058 R09: 0000000000000000
R10: ffff88003e7fdf70 R11: 0000000000000020 R12: 0000000000000297
R13: ffff88003b201c88 R14: ffff88003d715258 R15: 0000000000000297
BUG: soft lockup - CPU#6 stuck for 22s! [khugepaged:52]
Modules linked in:
CPU 6 
Modules linked in:

Pid: 52, comm: khugepaged Not tainted 3.4.0-rc4-base+ #1 Red Hat KVM
RIP: 0010:[<ffffffff815e34d9>]  [<ffffffff815e34d9>] _raw_spin_unlock_irqrestore+0x19/0x30
RSP: 0018:ffff880038189a38  EFLAGS: 00000286
RAX: 0000000000000000 RBX: 0000000000000002 RCX: ffff88003d981680
RDX: ffffea0000592940 RSI: 0000000000000286 RDI: 0000000000000286
RBP: ffff880038189a40 R08: ffffea00007d1fe8 R09: 5000000000000000
R10: ffff88003d981680 R11: 0000000000000000 R12: ffff880038189a00
R13: ffff88003d795258 R14: 0000000000000297 R15: ffffea00009f4460
FS:  0000000000000000(0000) GS:ffff88003d780000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 00007f6ffe87f000 CR3: 0000000001a0b000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process khugepaged (pid: 52, threadinfo ffff880038188000, task ffff880038182b30)
Stack:
 000000000000000e ffff880038189ac0 ffffffff8110d7ed 0000000000000008
 ffffea0000856920 ffff88003d981680 0000000000000009 0000000000000286
 0000000200000282 ffffea0000856920 ffffea00007670d8 0000000000000010
Call Trace:
 [<ffffffff8110d7ed>] release_pages+0x1ad/0x210
 [<ffffffff8110d250>] ? add_page_to_unevictable_list+0xd0/0xd0
 [<ffffffff8110d91f>] pagevec_lru_move_fn+0xcf/0xf0
 [<ffffffff8110d957>] __pagevec_lru_add+0x17/0x20
 [<ffffffff8110ddc8>] __lru_cache_add+0x68/0x90
 [<ffffffff8115bed9>] ? __mem_cgroup_uncharge_common+0xf9/0x280
 [<ffffffff8110de1d>] lru_cache_add_lru+0x2d/0x50
 [<ffffffff81112919>] putback_lru_page+0x69/0xe0
 [<ffffffff81151eeb>] release_pte_page+0x2b/0x40
 [<ffffffff81152335>] __collapse_huge_page_copy+0x185/0x200
 [<ffffffff81152096>] ? __collapse_huge_page_isolate+0x116/0x1c0
 [<ffffffff811526d7>] collapse_huge_page+0x327/0x500
 [<ffffffff812d84be>] ? rb_erase+0xce/0x150
 [<ffffffff81152a75>] khugepaged_scan_pmd+0x1c5/0x2f0
 [<ffffffff815e240e>] ? __schedule+0x3de/0x710
 [<ffffffff81152ffe>] khugepaged_scan_mm_slot+0x17e/0x280
 [<ffffffff8115407c>] khugepaged_do_scan+0xbc/0xe0
 [<ffffffff81154f5f>] khugepaged_loop+0x5f/0x3c0
 [<ffffffff81062bd0>] ? wake_up_bit+0x40/0x40
 [<ffffffff811552c0>] ? khugepaged_loop+0x3c0/0x3c0
 [<ffffffff8115530a>] khugepaged+0x4a/0xb0
 [<ffffffff810624fe>] kthread+0x9e/0xb0
 [<ffffffff815ecce4>] kernel_thread_helper+0x4/0x10
 [<ffffffff81062460>] ? kthread_freezable_should_stop+0x70/0x70
 [<ffffffff815ecce0>] ? gs_change+0x13/0x13
Code: 66 90 e8 db b9 a4 ff 66 90 c9 c3 0f 1f 80 00 00 00 00 55 48 89 e5 53 66 66 66 66 90 48 89 f3 e8 1e ba a4 ff 66 90 48 89 df 57 9d <66> 66 90 66 90 5b c9 c3 66 66 66 66 66 66 2e 0f 1f 84 00 00 00 
Call Trace:
 [<ffffffff8110d7ed>] release_pages+0x1ad/0x210
 [<ffffffff8110d250>] ? add_page_to_unevictable_list+0xd0/0xd0
 [<ffffffff8110d91f>] pagevec_lru_move_fn+0xcf/0xf0
 [<ffffffff8110d957>] __pagevec_lru_add+0x17/0x20
 [<ffffffff8110ddc8>] __lru_cache_add+0x68/0x90
 [<ffffffff8115bed9>] ? __mem_cgroup_uncharge_common+0xf9/0x280
 [<ffffffff8110de1d>] lru_cache_add_lru+0x2d/0x50
 [<ffffffff81112919>] putback_lru_page+0x69/0xe0
 [<ffffffff81151eeb>] release_pte_page+0x2b/0x40
 [<ffffffff81152335>] __collapse_huge_page_copy+0x185/0x200
 [<ffffffff81152096>] ? __collapse_huge_page_isolate+0x116/0x1c0
 [<ffffffff811526d7>] collapse_huge_page+0x327/0x500
 [<ffffffff812d84be>] ? rb_erase+0xce/0x150
 [<ffffffff81152a75>] khugepaged_scan_pmd+0x1c5/0x2f0
 [<ffffffff815e240e>] ? __schedule+0x3de/0x710
 [<ffffffff81152ffe>] khugepaged_scan_mm_slot+0x17e/0x280
 [<ffffffff8115407c>] khugepaged_do_scan+0xbc/0xe0
 [<ffffffff81154f5f>] khugepaged_loop+0x5f/0x3c0
 [<ffffffff81062bd0>] ? wake_up_bit+0x40/0x40
 [<ffffffff811552c0>] ? khugepaged_loop+0x3c0/0x3c0
 [<ffffffff8115530a>] khugepaged+0x4a/0xb0
 [<ffffffff810624fe>] kthread+0x9e/0xb0
 [<ffffffff815ecce4>] kernel_thread_helper+0x4/0x10
 [<ffffffff81062460>] ? kthread_freezable_should_stop+0x70/0x70
 [<ffffffff815ecce0>] ? gs_change+0x13/0x13
FS:  0000000000000000(0000) GS:ffff88003d700000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000003cddcaae90 CR3: 0000000001a0b000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process cc1 (pid: 5296, threadinfo ffff88003b200000, task ffff88003b1ed4a0)
Stack:
 000000000000000e ffff88003b201d48 ffffffff8110d7ed ffff88003b201d78
 ffffea0000540090 ffff88003d981680 00000000ffffffff 0000000000000286
 0000000200000000 ffffea0000540090 ffffea00004fe3f0 0000000000000000
Call Trace:
 [<ffffffff8110d7ed>] release_pages+0x1ad/0x210
 [<ffffffff81139424>] free_pages_and_swap_cache+0xb4/0xe0
 [<ffffffff812d1da1>] ? cpumask_any_but+0x31/0x50
 [<ffffffff8112515c>] tlb_flush_mmu+0x6c/0x90
 [<ffffffff81125644>] tlb_finish_mmu+0x14/0x40
 [<ffffffff8112c4a8>] exit_mmap+0xd8/0x140
 [<ffffffff8103e143>] mmput+0x73/0x120
 [<ffffffff81044fca>] exit_mm+0x10a/0x140
 [<ffffffff8104516b>] do_exit+0x16b/0x450
 [<ffffffff810454a5>] do_group_exit+0x55/0xd0
 [<ffffffff81045537>] sys_exit_group+0x17/0x20
 [<ffffffff815eb9e9>] system_call_fastpath+0x16/0x1b
Code: 66 90 e8 db b9 a4 ff 66 90 c9 c3 0f 1f 80 00 00 00 00 55 48 89 e5 53 66 66 66 66 90 48 89 f3 e8 1e ba a4 ff 66 90 48 89 df 57 9d <66> 66 90 66 90 5b c9 c3 66 66 66 66 66 66 2e 0f 1f 84 00 00 00 
Call Trace:
 [<ffffffff8110d7ed>] release_pages+0x1ad/0x210
 [<ffffffff81139424>] free_pages_and_swap_cache+0xb4/0xe0
 [<ffffffff812d1da1>] ? cpumask_any_but+0x31/0x50
 [<ffffffff8112515c>] tlb_flush_mmu+0x6c/0x90
 [<ffffffff81125644>] tlb_finish_mmu+0x14/0x40
 [<ffffffff8112c4a8>] exit_mmap+0xd8/0x140
 [<ffffffff8103e143>] mmput+0x73/0x120
 [<ffffffff81044fca>] exit_mm+0x10a/0x140
 [<ffffffff8104516b>] do_exit+0x16b/0x450
 [<ffffffff810454a5>] do_group_exit+0x55/0xd0
 [<ffffffff81045537>] sys_exit_group+0x17/0x20
 [<ffffffff815eb9e9>] system_call_fastpath+0x16/0x1b
BUG: soft lockup - CPU#3 stuck for 22s! [cc1:5346]
Modules linked in:
CPU 3 
Modules linked in:

Pid: 5346, comm: cc1 Not tainted 3.4.0-rc4-base+ #1 Red Hat KVM
RIP: 0010:[<ffffffff815e34d9>]  [<ffffffff815e34d9>] _raw_spin_unlock_irqrestore+0x19/0x30
RSP: 0018:ffff880038a1dcc0  EFLAGS: 00000286
BUG: soft lockup - CPU#7 stuck for 22s! [cc1:5292]
Modules linked in:
CPU 7 
Modules linked in:

Pid: 5292, comm: cc1 Not tainted 3.4.0-rc4-base+ #1 Red Hat KVM
RIP: 0010:[<ffffffff815e34d9>]  [<ffffffff815e34d9>] _raw_spin_unlock_irqrestore+0x19/0x30
RSP: 0018:ffff88003b22fcc0  EFLAGS: 00000286
RAX: ffffea000092aa98 RBX: ffffffff8110d7f8 RCX: ffff88003d981680
RDX: ffffea000092aa60 RSI: 0000000000000286 RDI: 0000000000000286
RBP: ffff88003b22fcc8 R08: ffffea000092aa60 R09: 0000000000000000
R10: ffff88003e7fdfa0 R11: 0000000000000000 R12: 0000000000000297
R13: ffff88003b22fc88 R14: ffff88003d7d5258 R15: 0000000000000297
FS:  0000000000000000(0000) GS:ffff88003d7c0000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000003cddcaae90 CR3: 0000000001a0b000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process cc1 (pid: 5292, threadinfo ffff88003b22e000, task ffff88003b22d560)
Stack:
 000000000000000e ffff88003b22fd48 ffffffff8110d7ed ffff88003b22fd78
 ffffea000092aa98 ffff88003d981680 0000000000000005 0000000000000286
 0000000200000000 ffffea000092aa98 ffffea0000609b90 0000000000000000
Call Trace:
 [<ffffffff8110d7ed>] release_pages+0x1ad/0x210
 [<ffffffff81139424>] free_pages_and_swap_cache+0xb4/0xe0
 [<ffffffff812d1da1>] ? cpumask_any_but+0x31/0x50
 [<ffffffff8112515c>] tlb_flush_mmu+0x6c/0x90
 [<ffffffff81125644>] tlb_finish_mmu+0x14/0x40
 [<ffffffff8112c4a8>] exit_mmap+0xd8/0x140
 [<ffffffff8103e143>] mmput+0x73/0x120
 [<ffffffff81044fca>] exit_mm+0x10a/0x140
 [<ffffffff8104516b>] do_exit+0x16b/0x450
 [<ffffffff810454a5>] do_group_exit+0x55/0xd0
 [<ffffffff81045537>] sys_exit_group+0x17/0x20
 [<ffffffff815eb9e9>] system_call_fastpath+0x16/0x1b
Code: 66 90 e8 db b9 a4 ff 66 90 c9 c3 0f 1f 80 00 00 00 00 55 48 89 e5 53 66 66 66 66 90 48 89 f3 e8 1e ba a4 ff 66 90 48 89 df 57 9d <66> 66 90 66 90 5b c9 c3 66 66 66 66 66 66 2e 0f 1f 84 00 00 00 
Call Trace:
 [<ffffffff8110d7ed>] release_pages+0x1ad/0x210
 [<ffffffff81139424>] free_pages_and_swap_cache+0xb4/0xe0
 [<ffffffff812d1da1>] ? cpumask_any_but+0x31/0x50
 [<ffffffff8112515c>] tlb_flush_mmu+0x6c/0x90
 [<ffffffff81125644>] tlb_finish_mmu+0x14/0x40
 [<ffffffff8112c4a8>] exit_mmap+0xd8/0x140
 [<ffffffff8103e143>] mmput+0x73/0x120
 [<ffffffff81044fca>] exit_mm+0x10a/0x140
 [<ffffffff8104516b>] do_exit+0x16b/0x450
 [<ffffffff810454a5>] do_group_exit+0x55/0xd0
 [<ffffffff81045537>] sys_exit_group+0x17/0x20
 [<ffffffff815eb9e9>] system_call_fastpath+0x16/0x1b
RAX: ffffea000086a4c8 RBX: 0000000001a03025 RCX: ffff88003d981680
RDX: ffffea000086a490 RSI: 0000000000000286 RDI: 0000000000000286
RBP: ffff880038a1dcc8 R08: ffffea000086a490 R09: 0000000000000000
R10: ffff88003e7fdfa0 R11: 0000000000000020 R12: 0000000000000297
R13: ffff880038a1dc88 R14: ffff88003d6d5258 R15: 0000000000000297
FS:  00007fc542663700(0000) GS:ffff88003d6c0000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000003cddcaae90 CR3: 0000000001a0b000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process cc1 (pid: 5346, threadinfo ffff880038a1c000, task ffff880038200040)
Stack:
 000000000000000e ffff880038a1dd48 ffffffff8110d7ed 0000000000000020
 ffffea000086a4c8 ffff88003d981680 0000000000813c88 0000000000000286
 000000023810ce10 ffffea000086a4c8 ffffea000072f030 0000000000000297
Call Trace:
 [<ffffffff8110d7ed>] release_pages+0x1ad/0x210
 [<ffffffff81139424>] free_pages_and_swap_cache+0xb4/0xe0
 [<ffffffff812d1da1>] ? cpumask_any_but+0x31/0x50
 [<ffffffff8112515c>] tlb_flush_mmu+0x6c/0x90
 [<ffffffff81125644>] tlb_finish_mmu+0x14/0x40
 [<ffffffff8112c4a8>] exit_mmap+0xd8/0x140
 [<ffffffff8103e143>] mmput+0x73/0x120
 [<ffffffff81044fca>] exit_mm+0x10a/0x140
 [<ffffffff8104516b>] do_exit+0x16b/0x450
 [<ffffffff810454a5>] do_group_exit+0x55/0xd0
 [<ffffffff81045537>] sys_exit_group+0x17/0x20
 [<ffffffff815eb9e9>] system_call_fastpath+0x16/0x1b
Code: 66 90 e8 db b9 a4 ff 66 90 c9 c3 0f 1f 80 00 00 00 00 55 48 89 e5 53 66 66 66 66 90 48 89 f3 e8 1e ba a4 ff 66 90 48 89 df 57 9d <66> 66 90 66 90 5b c9 c3 66 66 66 66 66 66 2e 0f 1f 84 00 00 00 
Call Trace:
 [<ffffffff8110d7ed>] release_pages+0x1ad/0x210
 [<ffffffff81139424>] free_pages_and_swap_cache+0xb4/0xe0
 [<ffffffff812d1da1>] ? cpumask_any_but+0x31/0x50
 [<ffffffff8112515c>] tlb_flush_mmu+0x6c/0x90
 [<ffffffff81125644>] tlb_finish_mmu+0x14/0x40
 [<ffffffff8112c4a8>] exit_mmap+0xd8/0x140
 [<ffffffff8103e143>] mmput+0x73/0x120
 [<ffffffff81044fca>] exit_mm+0x10a/0x140
 [<ffffffff8104516b>] do_exit+0x16b/0x450
 [<ffffffff810454a5>] do_group_exit+0x55/0xd0
 [<ffffffff81045537>] sys_exit_group+0x17/0x20
 [<ffffffff815eb9e9>] system_call_fastpath+0x16/0x1b
BUG: soft lockup - CPU#5 stuck for 22s! [khugepaged:52]
Modules linked in:
CPU 5 
Modules linked in:

Pid: 52, comm: khugepaged Not tainted 3.4.0-rc4-base+ #1 Red Hat KVM
RIP: 0010:[<ffffffff815e34d9>]  [<ffffffff815e34d9>] _raw_spin_unlock_irqrestore+0x19/0x30
RSP: 0000:ffff880038189b18  EFLAGS: 00000282
RAX: 000000000001529a RBX: 0000000000000010 RCX: ffffffffffffffe0
RDX: fffffffffffffff5 RSI: 0000000000000282 RDI: 0000000000000282
RBP: ffff880038189b20 R08: 00000000fffffff6 R09: 0000000000000000
R10: ffff88003e7fdfb8 R11: 0000000000000000 R12: ffffea000073b858
R13: 0000000200000282 R14: 0000000000000286 R15: 0000000000000009
FS:  0000000000000000(0000) GS:ffff88003d740000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 00007ff4e3946000 CR3: 0000000001a0b000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process khugepaged (pid: 52, threadinfo ffff880038188000, task ffff880038182b30)
Stack:
 ffff88003d981680 ffff880038189b60 ffffffff8110d450 ffff880038189b70
 ffffea0000831ad0 ffffea0000831ad0 ffff88003df5b538 0000000000000538
 0000000000511488 ffff880038189b80 ffffffff8110d4c6 ffff880038189b80
Call Trace:
 [<ffffffff8110d450>] __page_cache_release+0x100/0x130
 [<ffffffff8110d4c6>] __put_single_page+0x16/0x30
 [<ffffffff8110dba5>] put_page+0x25/0x40
 [<ffffffff8113933a>] free_page_and_swap_cache+0x2a/0x60
 [<ffffffff81152381>] __collapse_huge_page_copy+0x1d1/0x200
 [<ffffffff81152096>] ? __collapse_huge_page_isolate+0x116/0x1c0
 [<ffffffff811526d7>] collapse_huge_page+0x327/0x500
 [<ffffffff812d84be>] ? rb_erase+0xce/0x150
 [<ffffffff81152a75>] khugepaged_scan_pmd+0x1c5/0x2f0
 [<ffffffff815e240e>] ? __schedule+0x3de/0x710
 [<ffffffff81152ffe>] khugepaged_scan_mm_slot+0x17e/0x280
 [<ffffffff8115407c>] khugepaged_do_scan+0xbc/0xe0
 [<ffffffff81154f5f>] khugepaged_loop+0x5f/0x3c0
 [<ffffffff81062bd0>] ? wake_up_bit+0x40/0x40
 [<ffffffff811552c0>] ? khugepaged_loop+0x3c0/0x3c0
 [<ffffffff8115530a>] khugepaged+0x4a/0xb0
 [<ffffffff810624fe>] kthread+0x9e/0xb0
 [<ffffffff815ecce4>] kernel_thread_helper+0x4/0x10
 [<ffffffff81062460>] ? kthread_freezable_should_stop+0x70/0x70
 [<ffffffff815ecce0>] ? gs_change+0x13/0x13
Code: 66 90 e8 db b9 a4 ff 66 90 c9 c3 0f 1f 80 00 00 00 00 55 48 89 e5 53 66 66 66 66 90 48 89 f3 e8 1e ba a4 ff 66 90 48 89 df 57 9d <66> 66 90 66 90 5b c9 c3 66 66 66 66 66 66 2e 0f 1f 84 00 00 00 
Call Trace:
 [<ffffffff8110d450>] __page_cache_release+0x100/0x130
 [<ffffffff8110d4c6>] __put_single_page+0x16/0x30
 [<ffffffff8110dba5>] put_page+0x25/0x40
 [<ffffffff8113933a>] free_page_and_swap_cache+0x2a/0x60
 [<ffffffff81152381>] __collapse_huge_page_copy+0x1d1/0x200
 [<ffffffff81152096>] ? __collapse_huge_page_isolate+0x116/0x1c0
 [<ffffffff811526d7>] collapse_huge_page+0x327/0x500
 [<ffffffff812d84be>] ? rb_erase+0xce/0x150
 [<ffffffff81152a75>] khugepaged_scan_pmd+0x1c5/0x2f0
 [<ffffffff815e240e>] ? __schedule+0x3de/0x710
 [<ffffffff81152ffe>] khugepaged_scan_mm_slot+0x17e/0x280
 [<ffffffff8115407c>] khugepaged_do_scan+0xbc/0xe0
 [<ffffffff81154f5f>] khugepaged_loop+0x5f/0x3c0
 [<ffffffff81062bd0>] ? wake_up_bit+0x40/0x40
 [<ffffffff811552c0>] ? khugepaged_loop+0x3c0/0x3c0
 [<ffffffff8115530a>] khugepaged+0x4a/0xb0
 [<ffffffff810624fe>] kthread+0x9e/0xb0
 [<ffffffff815ecce4>] kernel_thread_helper+0x4/0x10
 [<ffffffff81062460>] ? kthread_freezable_should_stop+0x70/0x70
 [<ffffffff815ecce0>] ? gs_change+0x13/0x13
parted: sending ioctl 1261 to a partition!
parted: sending ioctl 1261 to a partition!
parted: sending ioctl 1261 to a partition!
parted: sending ioctl 1261 to a partition!
parted: sending ioctl 1261 to a partition!
parted: sending ioctl 1261 to a partition!
parted: sending ioctl 1261 to a partition!
parted: sending ioctl 1261 to a partition!
parted: sending ioctl 1261 to a partition!
BUG: soft lockup - CPU#3 stuck for 23s! [cc1:5744]
Modules linked in:
CPU 3 
Modules linked in:

Pid: 5744, comm: cc1 Not tainted 3.4.0-rc4-base+ #1 Red Hat KVM
RIP: 0010:[<ffffffff815e34d9>] 
BUG: soft lockup - CPU#5 stuck for 23s! [khugepaged:52]
Modules linked in:
CPU 5 
Modules linked in:

Pid: 52, comm: khugepaged Not tainted 3.4.0-rc4-base+ #1 Red Hat KVM
RIP: 0010:[<ffffffff815e34d9>]  [<ffffffff815e34d9>] _raw_spin_unlock_irqrestore+0x19/0x30
RSP: 0000:ffff880038189ab8  EFLAGS: 00000282
RAX: 0000000000000282 RBX: 000000000000000e RCX: ffffc90000182000
RDX: 0000000000000009 RSI: 0000000000000282 RDI: 0000000000000282
RBP: ffff880038189ac0 R08: 00000000fffffff2 R09: fa00000000000000
R10: ffff88003d981680 R11: 0000000000000000 R12: ffff88003d74f1e0
R13: 000000000000000e R14: 0000000000000010 R15: ffffffff81109eaf
FS:  0000000000000000(0000) GS:ffff88003d740000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 00007fff8827c908 CR3: 0000000001a0b000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process khugepaged (pid: 52, threadinfo ffff880038188000, task ffff880038182b30)
Stack:
 ffff88003d74f160 ffff880038189b10 ffffffff8110d90f 0000000000000282
 0000000000000001 ffffea0000629798 ffffea00008d0fe8 ffff88003d74f160
 0000000000000000 00000000ffffffff 000000000048b8b8 ffff880038189b20
Call Trace:
 [<ffffffff8110d90f>] pagevec_lru_move_fn+0xbf/0xf0
 [<ffffffff8110d957>] __pagevec_lru_add+0x17/0x20
 [<ffffffff8110ddc8>] __lru_cache_add+0x68/0x90
 [<ffffffff8115bed9>] ? __mem_cgroup_uncharge_common+0xf9/0x280
 [<ffffffff8110de1d>] lru_cache_add_lru+0x2d/0x50
 [<ffffffff81112919>] putback_lru_page+0x69/0xe0
 [<ffffffff81151eeb>] release_pte_page+0x2b/0x40
 [<ffffffff81152335>] __collapse_huge_page_copy+0x185/0x200
 [<ffffffff81152096>] ? __collapse_huge_page_isolate+0x116/0x1c0
 [<ffffffff811526d7>] collapse_huge_page+0x327/0x500
 [<ffffffff812d84be>] ? rb_erase+0xce/0x150
 [<ffffffff81152a75>] khugepaged_scan_pmd+0x1c5/0x2f0
 [<ffffffff81152ffe>] khugepaged_scan_mm_slot+0x17e/0x280
 [<ffffffff8115407c>] khugepaged_do_scan+0xbc/0xe0
 [<ffffffff81154f5f>] khugepaged_loop+0x5f/0x3c0
 [<ffffffff81062bd0>] ? wake_up_bit+0x40/0x40
 [<ffffffff811552c0>] ? khugepaged_loop+0x3c0/0x3c0
 [<ffffffff8115530a>] khugepaged+0x4a/0xb0
 [<ffffffff810624fe>] kthread+0x9e/0xb0
 [<ffffffff815ecce4>] kernel_thread_helper+0x4/0x10
 [<ffffffff81062460>] ? kthread_freezable_should_stop+0x70/0x70
 [<ffffffff815ecce0>] ? gs_change+0x13/0x13
Code: 66 90 e8 db b9 a4 ff 66 90 c9 c3 0f 1f 80 00 00 00 00 55 48 89 e5 53 66 66 66 66 90 48 89 f3 e8 1e ba a4 ff 66 90 48 89 df 57 9d <66> 66 90 66 90 5b c9 c3 66 66 66 66 66 66 2e 0f 1f 84 00 00 00 
Call Trace:
 [<ffffffff8110d90f>] pagevec_lru_move_fn+0xbf/0xf0
 [<ffffffff8110d957>] __pagevec_lru_add+0x17/0x20
 [<ffffffff8110ddc8>] __lru_cache_add+0x68/0x90
 [<ffffffff8115bed9>] ? __mem_cgroup_uncharge_common+0xf9/0x280
 [<ffffffff8110de1d>] lru_cache_add_lru+0x2d/0x50
 [<ffffffff81112919>] putback_lru_page+0x69/0xe0
 [<ffffffff81151eeb>] release_pte_page+0x2b/0x40
 [<ffffffff81152335>] __collapse_huge_page_copy+0x185/0x200
 [<ffffffff81152096>] ? __collapse_huge_page_isolate+0x116/0x1c0
 [<ffffffff811526d7>] collapse_huge_page+0x327/0x500
 [<ffffffff812d84be>] ? rb_erase+0xce/0x150
 [<ffffffff81152a75>] khugepaged_scan_pmd+0x1c5/0x2f0
 [<ffffffff81152ffe>] khugepaged_scan_mm_slot+0x17e/0x280
 [<ffffffff8115407c>] khugepaged_do_scan+0xbc/0xe0
 [<ffffffff81154f5f>] khugepaged_loop+0x5f/0x3c0
 [<ffffffff81062bd0>] ? wake_up_bit+0x40/0x40
 [<ffffffff811552c0>] ? khugepaged_loop+0x3c0/0x3c0
 [<ffffffff8115530a>] khugepaged+0x4a/0xb0
 [<ffffffff810624fe>] kthread+0x9e/0xb0
 [<ffffffff815ecce4>] kernel_thread_helper+0x4/0x10
 [<ffffffff81062460>] ? kthread_freezable_should_stop+0x70/0x70
 [<ffffffff815ecce0>] ? gs_change+0x13/0x13
 [<ffffffff815e34d9>] _raw_spin_unlock_irqrestore+0x19/0x30
RSP: 0018:ffff88003928bcc0  EFLAGS: 00000286
RAX: ffffea00007849c8 RBX: 0000000001a03025 RCX: ffff88003d981680
RDX: ffffea0000784990 RSI: 0000000000000286 RDI: 0000000000000286
RBP: ffff88003928bcc8 R08: ffffea0000784990 R09: 0000000000000000
R10: ffff88003e7fdf88 R11: 0000000000000020 R12: 0000000000000297
R13: ffff88003928bc88 R14: ffff88003d6d5258 R15: 0000000000000297
FS:  0000000000000000(0000) GS:ffff88003d6c0000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000003cddcaae90 CR3: 0000000001a0b000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process cc1 (pid: 5744, threadinfo ffff88003928a000, task ffff88003dd46040)
Stack:
 000000000000000e ffff88003928bd48 ffffffff8110d7ed ffff88003928bd78
 ffffea00007849c8 ffff88003d981680 00000000ffffffff 0000000000000286
 0000000200000000 ffffea00007849c8 ffffea00006ce028 0000000000000000
Call Trace:
 [<ffffffff8110d7ed>] release_pages+0x1ad/0x210
 [<ffffffff81139424>] free_pages_and_swap_cache+0xb4/0xe0
 [<ffffffff812d1da1>] ? cpumask_any_but+0x31/0x50
 [<ffffffff8112515c>] tlb_flush_mmu+0x6c/0x90
 [<ffffffff81125644>] tlb_finish_mmu+0x14/0x40
 [<ffffffff8112c4a8>] exit_mmap+0xd8/0x140
 [<ffffffff8103e143>] mmput+0x73/0x120
 [<ffffffff81044fca>] exit_mm+0x10a/0x140
 [<ffffffff8104516b>] do_exit+0x16b/0x450
 [<ffffffff810454a5>] do_group_exit+0x55/0xd0
 [<ffffffff81045537>] sys_exit_group+0x17/0x20
 [<ffffffff815eb9e9>] system_call_fastpath+0x16/0x1b
Code: 66 90 e8 db b9 a4 ff 66 90 c9 c3 0f 1f 80 00 00 00 00 55 48 89 e5 53 66 66 66 66 90 48 89 f3 e8 1e ba a4 ff 66 90 48 89 df 57 9d <66> 66 90 66 90 5b c9 c3 66 66 66 66 66 66 2e 0f 1f 84 00 00 00 
Call Trace:
 [<ffffffff8110d7ed>] release_pages+0x1ad/0x210
 [<ffffffff81139424>] free_pages_and_swap_cache+0xb4/0xe0
 [<ffffffff812d1da1>] ? cpumask_any_but+0x31/0x50
 [<ffffffff8112515c>] tlb_flush_mmu+0x6c/0x90
 [<ffffffff81125644>] tlb_finish_mmu+0x14/0x40
 [<ffffffff8112c4a8>] exit_mmap+0xd8/0x140
 [<ffffffff8103e143>] mmput+0x73/0x120
 [<ffffffff81044fca>] exit_mm+0x10a/0x140
 [<ffffffff8104516b>] do_exit+0x16b/0x450
 [<ffffffff810454a5>] do_group_exit+0x55/0xd0
 [<ffffffff81045537>] sys_exit_group+0x17/0x20
 [<ffffffff815eb9e9>] system_call_fastpath+0x16/0x1b
parted: sending ioctl 1261 to a partition!
parted: sending ioctl 1261 to a partition!
parted: sending ioctl 1261 to a partition!
BUG: soft lockup - CPU#6 stuck for 22s! [cc1:5922]
Modules linked in:
CPU 6 
Modules linked in:

Pid: 5922, comm: cc1 Not tainted 3.4.0-rc4-base+ #1 Red Hat KVM
RIP: 0010:[<ffffffff815e34d9>]  [<ffffffff815e34d9>] _raw_spin_unlock_irqrestore+0x19/0x30
RSP: 0000:ffff8800392bdcc0  EFLAGS: 00000286
RAX: ffffea0000a1b7a8 RBX: 0000000001a03025 RCX: ffff88003d981680
RDX: ffffea00009fa760 RSI: 0000000000000286 RDI: 0000000000000286
RBP: ffff8800392bdcc8 R08: ffffea00009fa760 R09: 0000000000000000
R10: ffff88003e7fdf70 R11: 0000000000000020 R12: 0000000000000297
R13: ffff8800392bdc88 R14: ffff88003d795258 R15: 0000000000000297
FS:  00007f11b1808700(0000) GS:ffff88003d780000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f210a362000 CR3: 0000000038d14000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process cc1 (pid: 5922, threadinfo ffff8800392bc000, task ffff880039966100)
Stack:
 000000000000000e ffff8800392bdd48 ffffffff8110d7ed ffff8800392bdd78
 ffffea0000a1b7a8 ffff88003d981680 00000000ffffffff 0000000000000286
 0000000200000000 ffffea0000a1b7a8 ffffea0000745f08 0000000000000000
Call Trace:
 [<ffffffff8110d7ed>] release_pages+0x1ad/0x210
 [<ffffffff81139424>] free_pages_and_swap_cache+0xb4/0xe0
 [<ffffffff812d1da1>] ? cpumask_any_but+0x31/0x50
 [<ffffffff8112515c>] tlb_flush_mmu+0x6c/0x90
 [<ffffffff81125644>] tlb_finish_mmu+0x14/0x40
 [<ffffffff8112c4a8>] exit_mmap+0xd8/0x140
 [<ffffffff8103e143>] mmput+0x73/0x120
 [<ffffffff81044fca>] exit_mm+0x10a/0x140
 [<ffffffff8104516b>] do_exit+0x16b/0x450
 [<ffffffff810454a5>] do_group_exit+0x55/0xd0
 [<ffffffff81045537>] sys_exit_group+0x17/0x20
 [<ffffffff815eb9e9>] system_call_fastpath+0x16/0x1b
Code: 66 90 e8 db b9 a4 ff 66 90 c9 c3 0f 1f 80 00 00 00 00 55 48 89 e5 53 66 66 66 66 90 48 89 f3 e8 1e ba a4 ff 66 90 48 89 df 57 9d <66> 66 90 66 90 5b c9 c3 66 66 66 66 66 66 2e 0f 1f 84 00 00 00 
Call Trace:
 [<ffffffff8110d7ed>] release_pages+0x1ad/0x210
 [<ffffffff81139424>] free_pages_and_swap_cache+0xb4/0xe0
 [<ffffffff812d1da1>] ? cpumask_any_but+0x31/0x50
 [<ffffffff8112515c>] tlb_flush_mmu+0x6c/0x90
 [<ffffffff81125644>] tlb_finish_mmu+0x14/0x40
 [<ffffffff8112c4a8>] exit_mmap+0xd8/0x140
 [<ffffffff8103e143>] mmput+0x73/0x120
 [<ffffffff81044fca>] exit_mm+0x10a/0x140
 [<ffffffff8104516b>] do_exit+0x16b/0x450
 [<ffffffff810454a5>] do_group_exit+0x55/0xd0
 [<ffffffff81045537>] sys_exit_group+0x17/0x20
 [<ffffffff815eb9e9>] system_call_fastpath+0x16/0x1b
BUG: soft lockup - CPU#0 stuck for 22s! [khugepaged:52]
Modules linked in:
CPU 0 
Modules linked in:

Pid: 52, comm: khugepaged Not tainted 3.4.0-rc4-base+ #1 Red Hat KVM
RIP: 0010:[<ffffffff815e34d9>]  [<ffffffff815e34d9>] _raw_spin_unlock_irqrestore+0x19/0x30
RSP: 0000:ffff880038189ab8  EFLAGS: 00000282
RAX: 0000000000000282 RBX: 000000000000000e RCX: ffffc90000182000
RDX: 0000000000000009 RSI: 0000000000000282 RDI: 0000000000000282
RBP: ffff880038189ac0 R08: 0000000000000005 R09: d800000000000000
R10: ffff88003d981680 R11: 0000000000000000 R12: ffff88003d60f1e0
R13: 000000000000000e R14: 0000000000000010 R15: ffffffff81109eaf
FS:  0000000000000000(0000) GS:ffff88003d600000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 00007f212fb1c020 CR3: 0000000001a0b000 CR4: 00000000000006f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process khugepaged (pid: 52, threadinfo ffff880038188000, task ffff880038182b30)
Stack:
 ffff88003d60f160 ffff880038189b10 ffffffff8110d90f 0000000000000282
 0000000000000001 ffffea00007e2450 ffffea0000850b60 ffff88003d60f160
 0000000000000000 00000000ffffffff 0000000000486800 ffff880038189b20
Call Trace:
 [<ffffffff8110d90f>] pagevec_lru_move_fn+0xbf/0xf0
 [<ffffffff8110d957>] __pagevec_lru_add+0x17/0x20
 [<ffffffff8110ddc8>] __lru_cache_add+0x68/0x90
 [<ffffffff8115bed9>] ? __mem_cgroup_uncharge_common+0xf9/0x280
 [<ffffffff8110de1d>] lru_cache_add_lru+0x2d/0x50
 [<ffffffff81112919>] putback_lru_page+0x69/0xe0
 [<ffffffff81151eeb>] release_pte_page+0x2b/0x40
 [<ffffffff81152335>] __collapse_huge_page_copy+0x185/0x200
 [<ffffffff81152096>] ? __collapse_huge_page_isolate+0x116/0x1c0
 [<ffffffff811526d7>] collapse_huge_page+0x327/0x500
 [<ffffffff81152a75>] khugepaged_scan_pmd+0x1c5/0x2f0
 [<ffffffff815e240e>] ? __schedule+0x3de/0x710
 [<ffffffff81152ffe>] khugepaged_scan_mm_slot+0x17e/0x280
 [<ffffffff8115407c>] khugepaged_do_scan+0xbc/0xe0
 [<ffffffff81154f5f>] khugepaged_loop+0x5f/0x3c0
 [<ffffffff81062bd0>] ? wake_up_bit+0x40/0x40
 [<ffffffff811552c0>] ? khugepaged_loop+0x3c0/0x3c0
 [<ffffffff8115530a>] khugepaged+0x4a/0xb0
 [<ffffffff810624fe>] kthread+0x9e/0xb0
 [<ffffffff815ecce4>] kernel_thread_helper+0x4/0x10
 [<ffffffff81062460>] ? kthread_freezable_should_stop+0x70/0x70
 [<ffffffff815ecce0>] ? gs_change+0x13/0x13
Code: 66 90 e8 db b9 a4 ff 66 90 c9 c3 0f 1f 80 00 00 00 00 55 48 89 e5 53 66 66 66 66 90 48 89 f3 e8 1e ba a4 ff 66 90 48 89 df 57 9d <66> 66 90 66 90 5b c9 c3 66 66 66 66 66 66 2e 0f 1f 84 00 00 00 
Call Trace:
 [<ffffffff8110d90f>] pagevec_lru_move_fn+0xbf/0xf0
 [<ffffffff8110d957>] __pagevec_lru_add+0x17/0x20
 [<ffffffff8110ddc8>] __lru_cache_add+0x68/0x90
 [<ffffffff8115bed9>] ? __mem_cgroup_uncharge_common+0xf9/0x280
 [<ffffffff8110de1d>] lru_cache_add_lru+0x2d/0x50
 [<ffffffff81112919>] putback_lru_page+0x69/0xe0
 [<ffffffff81151eeb>] release_pte_page+0x2b/0x40
 [<ffffffff81152335>] __collapse_huge_page_copy+0x185/0x200
 [<ffffffff81152096>] ? __collapse_huge_page_isolate+0x116/0x1c0
 [<ffffffff811526d7>] collapse_huge_page+0x327/0x500
 [<ffffffff81152a75>] khugepaged_scan_pmd+0x1c5/0x2f0
 [<ffffffff815e240e>] ? __schedule+0x3de/0x710
 [<ffffffff81152ffe>] khugepaged_scan_mm_slot+0x17e/0x280
 [<ffffffff8115407c>] khugepaged_do_scan+0xbc/0xe0
 [<ffffffff81154f5f>] khugepaged_loop+0x5f/0x3c0
 [<ffffffff81062bd0>] ? wake_up_bit+0x40/0x40
 [<ffffffff811552c0>] ? khugepaged_loop+0x3c0/0x3c0
 [<ffffffff8115530a>] khugepaged+0x4a/0xb0
 [<ffffffff810624fe>] kthread+0x9e/0xb0
 [<ffffffff815ecce4>] kernel_thread_helper+0x4/0x10
 [<ffffffff81062460>] ? kthread_freezable_should_stop+0x70/0x70
 [<ffffffff815ecce0>] ? gs_change+0x13/0x13
BUG: soft lockup - CPU#1 stuck for 23s! [cc1:5942]
Modules linked in:
CPU 1 
Modules linked in:

Pid: 5942, comm: cc1 Not tainted 3.4.0-rc4-base+ #1 Red Hat KVM
RIP: 0010:[<ffffffff815e34d9>]  [<ffffffff815e34d9>] _raw_spin_unlock_irqrestore+0x19/0x30
RSP: 0018:ffff88003b21fcc0  EFLAGS: 00000286
RAX: ffffea0000a09c28 RBX: 0000000001a03025 RCX: ffff88003d981680
RDX: ffffea0000a09bf0 RSI: 0000000000000286 RDI: 0000000000000286
RBP: ffff88003b21fcc8 R08: ffffea0000a09bf0 R09: 0000000000000000
R10: ffff88003e7fdfa0 R11: 0000000000000020 R12: 0000000000000297
R13: ffff88003b21fc88 R14: ffff88003d655258 R15: 0000000000000297
FS:  0000000000000000(0000) GS:ffff88003d640000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000003cddcaae90 CR3: 0000000001a0b000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process cc1 (pid: 5942, threadinfo ffff88003b21e000, task ffff88003a2494a0)
BUG: soft lockup - CPU#5 stuck for 23s! [cc1:5872]
Modules linked in:
CPU 5 
Modules linked in:

Pid: 5872, comm: cc1 Not tainted 3.4.0-rc4-base+ #1 Red Hat KVM
RIP: 0010:[<ffffffff815e34d9>]  [<ffffffff815e34d9>] _raw_spin_unlock_irqrestore+0x19/0x30
RSP: 0018:ffff880038999cc0  EFLAGS: 00000286
RAX: ffffea00009a6220 RBX: 0000000001a03025 RCX: ffff88003d981680
RDX: ffffea0000a4dd88 RSI: 0000000000000286 RDI: 0000000000000286
RBP: ffff880038999cc8 R08: ffffea0000a4dd88 R09: 0000000000000000
R10: ffff88003e7fdfa0 R11: 0000000000000020 R12: 0000000000000297
R13: ffff880038999c88 R14: ffff88003d755258 R15: 0000000000000297
FS:  0000000000000000(0000) GS:ffff88003d740000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000003cddcaae90 CR3: 0000000001a0b000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process cc1 (pid: 5872, threadinfo ffff880038998000, task ffff8800387a0100)
Stack:
 000000000000000e ffff880038999d48 ffffffff8110d7ed ffff880038999d78
 ffffea00009a6220 ffff88003d981680 00000000ffffffff 0000000000000286
 0000000200000000 ffffea00009a6220 ffffea000068d4d0 0000000000000000
Call Trace:
 [<ffffffff8110d7ed>] release_pages+0x1ad/0x210
 [<ffffffff81139424>] free_pages_and_swap_cache+0xb4/0xe0
 [<ffffffff812d1da1>] ? cpumask_any_but+0x31/0x50
 [<ffffffff8112515c>] tlb_flush_mmu+0x6c/0x90
 [<ffffffff81125644>] tlb_finish_mmu+0x14/0x40
 [<ffffffff8112c4a8>] exit_mmap+0xd8/0x140
 [<ffffffff8103e143>] mmput+0x73/0x120
 [<ffffffff81044fca>] exit_mm+0x10a/0x140
 [<ffffffff8104516b>] do_exit+0x16b/0x450
 [<ffffffff810454a5>] do_group_exit+0x55/0xd0
 [<ffffffff81045537>] sys_exit_group+0x17/0x20
 [<ffffffff815eb9e9>] system_call_fastpath+0x16/0x1b
Code: 66 90 e8 db b9 a4 ff 66 90 c9 c3 0f 1f 80 00 00 00 00 55 48 89 e5 53 66 66 66 66 90 48 89 f3 e8 1e ba a4 ff 66 90 48 89 df 57 9d <66> 66 90 66 90 5b c9 c3 66 66 66 66 66 66 2e 0f 1f 84 00 00 00 
Call Trace:
 [<ffffffff8110d7ed>] release_pages+0x1ad/0x210
 [<ffffffff81139424>] free_pages_and_swap_cache+0xb4/0xe0
 [<ffffffff812d1da1>] ? cpumask_any_but+0x31/0x50
 [<ffffffff8112515c>] tlb_flush_mmu+0x6c/0x90
 [<ffffffff81125644>] tlb_finish_mmu+0x14/0x40
 [<ffffffff8112c4a8>] exit_mmap+0xd8/0x140
 [<ffffffff8103e143>] mmput+0x73/0x120
 [<ffffffff81044fca>] exit_mm+0x10a/0x140
 [<ffffffff8104516b>] do_exit+0x16b/0x450
 [<ffffffff810454a5>] do_group_exit+0x55/0xd0
 [<ffffffff81045537>] sys_exit_group+0x17/0x20
 [<ffffffff815eb9e9>] system_call_fastpath+0x16/0x1b
Stack:
 000000000000000e ffff88003b21fd48 ffffffff8110d7ed ffff88003b21fd78
 ffffea0000a09c28 ffff88003d981680 00000000ffffffff 0000000000000286
 0000000200000000 ffffea0000a09c28 ffffea0000aafe30 0000000000000000
Call Trace:
 [<ffffffff8110d7ed>] release_pages+0x1ad/0x210
 [<ffffffff81139424>] free_pages_and_swap_cache+0xb4/0xe0
 [<ffffffff812d1da1>] ? cpumask_any_but+0x31/0x50
 [<ffffffff8112515c>] tlb_flush_mmu+0x6c/0x90
 [<ffffffff81125644>] tlb_finish_mmu+0x14/0x40
 [<ffffffff8112c4a8>] exit_mmap+0xd8/0x140
 [<ffffffff8103e143>] mmput+0x73/0x120
 [<ffffffff81044fca>] exit_mm+0x10a/0x140
 [<ffffffff8104516b>] do_exit+0x16b/0x450
 [<ffffffff810454a5>] do_group_exit+0x55/0xd0
 [<ffffffff81045537>] sys_exit_group+0x17/0x20
 [<ffffffff815eb9e9>] system_call_fastpath+0x16/0x1b
Code: 66 90 e8 db b9 a4 ff 66 90 c9 c3 0f 1f 80 00 00 00 00 55 48 89 e5 53 66 66 66 66 90 48 89 f3 e8 1e ba a4 ff 66 90 48 89 df 57 9d <66> 66 90 66 90 5b c9 c3 66 66 66 66 66 66 2e 0f 1f 84 00 00 00 
Call Trace:
 [<ffffffff8110d7ed>] release_pages+0x1ad/0x210
 [<ffffffff81139424>] free_pages_and_swap_cache+0xb4/0xe0
 [<ffffffff812d1da1>] ? cpumask_any_but+0x31/0x50
 [<ffffffff8112515c>] tlb_flush_mmu+0x6c/0x90
 [<ffffffff81125644>] tlb_finish_mmu+0x14/0x40
 [<ffffffff8112c4a8>] exit_mmap+0xd8/0x140
 [<ffffffff8103e143>] mmput+0x73/0x120
 [<ffffffff81044fca>] exit_mm+0x10a/0x140
 [<ffffffff8104516b>] do_exit+0x16b/0x450
 [<ffffffff810454a5>] do_group_exit+0x55/0xd0
 [<ffffffff81045537>] sys_exit_group+0x17/0x20
 [<ffffffff815eb9e9>] system_call_fastpath+0x16/0x1b
BUG: soft lockup - CPU#0 stuck for 22s! [khugepaged:52]
Modules linked in:
CPU 0 
Modules linked in:

Pid: 52, comm: khugepaged Not tainted 3.4.0-rc4-base+ #1 Red Hat KVM
RIP: 0010:[<ffffffff8111286e>]  [<ffffffff8111286e>] isolate_lru_page+0x12e/0x170
RSP: 0000:ffff880038189b90  EFLAGS: 00000286
RAX: 000000000001529a RBX: 0000000000000000 RCX: ffffffffffffffe0
RDX: ffffffffffffffe6 RSI: 0000000000000002 RDI: ffff88003d981b00
RBP: ffff880038189bc0 R08: 00000000ffffffe7 R09: 0000000000015258
R10: ffff88003d981680 R11: 0000000000000020 R12: ffffc90000182000
R13: 0000000000c352da R14: 0000000000000003 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff88003d600000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 00007f3688d6b000 CR3: 0000000001a0b000 CR4: 00000000000006f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process khugepaged (pid: 52, threadinfo ffff880038188000, task ffff880038182b30)
Stack:
 ffffffff81a55ce0 ffffea0000483000 ffff880038e76de0 0000000000000de0
 00007f74169bc000 0000000000000067 ffff880038189c30 ffffffff8115207d
 ffff880038189bf0 ffffea00005168f8 ffff880038e77000 0000000138e76067
Call Trace:
 [<ffffffff8115207d>] __collapse_huge_page_isolate+0xfd/0x1c0
 [<ffffffff81152696>] collapse_huge_page+0x2e6/0x500
 [<ffffffff81152a75>] khugepaged_scan_pmd+0x1c5/0x2f0
 [<ffffffff81152ffe>] khugepaged_scan_mm_slot+0x17e/0x280
 [<ffffffff8115407c>] khugepaged_do_scan+0xbc/0xe0
 [<ffffffff81154f5f>] khugepaged_loop+0x5f/0x3c0
 [<ffffffff81062bd0>] ? wake_up_bit+0x40/0x40
 [<ffffffff811552c0>] ? khugepaged_loop+0x3c0/0x3c0
 [<ffffffff8115530a>] khugepaged+0x4a/0xb0
 [<ffffffff810624fe>] kthread+0x9e/0xb0
 [<ffffffff815ecce4>] kernel_thread_helper+0x4/0x10
 [<ffffffff81062460>] ? kthread_freezable_should_stop+0x70/0x70
 [<ffffffff815ecce0>] ? gs_change+0x13/0x13
Code: 89 de 4c 89 ef 25 00 40 00 00 48 83 f8 01 19 d2 31 db 81 ca 00 fe ff ff e8 30 c6 00 00 4c 89 e7 e8 88 c6 f1 ff 66 90 fb 66 66 90 <66> 66 90 e9 08 ff ff ff 66 2e 0f 1f 84 00 00 00 00 00 89 c3 eb 
Call Trace:
 [<ffffffff8115207d>] __collapse_huge_page_isolate+0xfd/0x1c0
 [<ffffffff81152696>] collapse_huge_page+0x2e6/0x500
 [<ffffffff81152a75>] khugepaged_scan_pmd+0x1c5/0x2f0
 [<ffffffff81152ffe>] khugepaged_scan_mm_slot+0x17e/0x280
 [<ffffffff8115407c>] khugepaged_do_scan+0xbc/0xe0
 [<ffffffff81154f5f>] khugepaged_loop+0x5f/0x3c0
 [<ffffffff81062bd0>] ? wake_up_bit+0x40/0x40
 [<ffffffff811552c0>] ? khugepaged_loop+0x3c0/0x3c0
 [<ffffffff8115530a>] khugepaged+0x4a/0xb0
 [<ffffffff810624fe>] kthread+0x9e/0xb0
 [<ffffffff815ecce4>] kernel_thread_helper+0x4/0x10
 [<ffffffff81062460>] ? kthread_freezable_should_stop+0x70/0x70
 [<ffffffff815ecce0>] ? gs_change+0x13/0x13
sysctl: The scan_unevictable_pages sysctl/node-interface has been disabled for lack of a legitimate use case.  If you have one, please send an email to linux-mm@kvack.org.
BUG: soft lockup - CPU#1 stuck for 22s! [khugepaged:52]
Modules linked in:
CPU 1 
Modules linked in:

Pid: 52, comm: khugepaged Not tainted 3.4.0-rc4-base+ #1 Red Hat KVM
RIP: 0010:[<ffffffff8111286e>]  [<ffffffff8111286e>] isolate_lru_page+0x12e/0x170
RSP: 0000:ffff880038189b90  EFLAGS: 00000282
RAX: 000000000001529a RBX: 0000000000000000 RCX: ffffffffffffffe0
RDX: fffffffffffffffd RSI: 0000000000000002 RDI: ffff88003d981b00
RBP: ffff880038189bc0 R08: 00000000fffffffe R09: 0000000000015258
R10: ffff88003d981680 R11: 0000000000000020 R12: ffffea000067b000
R13: ffffc90000182000 R14: 0000000000000003 R15: ffff88003b9f6000
FS:  0000000000000000(0000) GS:ffff88003d640000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 00007ff65a089000 CR3: 0000000001a0b000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process khugepaged (pid: 52, threadinfo ffff880038188000, task ffff880038182b30)
Stack:
 ffffffff81a55ce0 ffffea000067b000 ffff880038a37f38 0000000000000f38
 00007f8ac8be7000 0000000000000067 ffff880038189c30 ffffffff8115207d
 ffff880038189bf0 ffffea00007773b8 ffff880038a38000 0000000138a37067
Call Trace:
 [<ffffffff8115207d>] __collapse_huge_page_isolate+0xfd/0x1c0
 [<ffffffff81152696>] collapse_huge_page+0x2e6/0x500
 [<ffffffff81152a75>] khugepaged_scan_pmd+0x1c5/0x2f0
 [<ffffffff815e240e>] ? __schedule+0x3de/0x710
 [<ffffffff81152ffe>] khugepaged_scan_mm_slot+0x17e/0x280
 [<ffffffff8115407c>] khugepaged_do_scan+0xbc/0xe0
 [<ffffffff81154f5f>] khugepaged_loop+0x5f/0x3c0
 [<ffffffff81062bd0>] ? wake_up_bit+0x40/0x40
 [<ffffffff811552c0>] ? khugepaged_loop+0x3c0/0x3c0
 [<ffffffff8115530a>] khugepaged+0x4a/0xb0
 [<ffffffff810624fe>] kthread+0x9e/0xb0
 [<ffffffff815ecce4>] kernel_thread_helper+0x4/0x10
 [<ffffffff81062460>] ? kthread_freezable_should_stop+0x70/0x70
 [<ffffffff815ecce0>] ? gs_change+0x13/0x13
Code: 89 de 4c 89 ef 25 00 40 00 00 48 83 f8 01 19 d2 31 db 81 ca 00 fe ff ff e8 30 c6 00 00 4c 89 e7 e8 88 c6 f1 ff 66 90 fb 66 66 90 <66> 66 90 e9 08 ff ff ff 66 2e 0f 1f 84 00 00 00 00 00 89 c3 eb 
Call Trace:
 [<ffffffff8115207d>] __collapse_huge_page_isolate+0xfd/0x1c0
 [<ffffffff81152696>] collapse_huge_page+0x2e6/0x500
 [<ffffffff81152a75>] khugepaged_scan_pmd+0x1c5/0x2f0
 [<ffffffff815e240e>] ? __schedule+0x3de/0x710
 [<ffffffff81152ffe>] khugepaged_scan_mm_slot+0x17e/0x280
 [<ffffffff8115407c>] khugepaged_do_scan+0xbc/0xe0
 [<ffffffff81154f5f>] khugepaged_loop+0x5f/0x3c0
 [<ffffffff81062bd0>] ? wake_up_bit+0x40/0x40
 [<ffffffff811552c0>] ? khugepaged_loop+0x3c0/0x3c0
 [<ffffffff8115530a>] khugepaged+0x4a/0xb0
 [<ffffffff810624fe>] kthread+0x9e/0xb0
 [<ffffffff815ecce4>] kernel_thread_helper+0x4/0x10
 [<ffffffff81062460>] ? kthread_freezable_should_stop+0x70/0x70
 [<ffffffff815ecce0>] ? gs_change+0x13/0x13
BUG: soft lockup - CPU#5 stuck for 22s! [cc1:6560]
Modules linked in:
CPU 5 
Modules linked in:

Pid: 6560, comm: cc1 Not tainted 3.4.0-rc4-base+ #1 Red Hat KVM
RIP: 0010:[<ffffffff815e34d9>]  [<ffffffff815e34d9>] _raw_spin_unlock_irqrestore+0x19/0x30
RSP: 0018:ffff88003b2f3cc0  EFLAGS: 00000286
RAX: ffffea0000937988 RBX: 0000000001a03025 RCX: ffff88003d981680
RDX: ffffea0000937950 RSI: 0000000000000286 RDI: 0000000000000286
RBP: ffff88003b2f3cc8 R08: ffffea0000937950 R09: 0000000000000000
R10: ffff88003e7fdfb8 R11: 0000000000000020 R12: 0000000000000297
R13: ffff88003b2f3c88 R14: ffff88003d755258 R15: 0000000000000297
BUG: soft lockup - CPU#7 stuck for 23s! [cc1:6572]
Modules linked in:
CPU 7 
Modules linked in:

Pid: 6572, comm: cc1 Not tainted 3.4.0-rc4-base+ #1 Red Hat KVM
RIP: 0010:[<ffffffff815e34d9>]  [<ffffffff815e34d9>] _raw_spin_unlock_irqrestore+0x19/0x30
RSP: 0018:ffff88003a3bbcc0  EFLAGS: 00000286
RAX: ffffea0000993c90 RBX: 0000000001a03025 RCX: ffff88003d981680
RDX: ffffea0000993c58 RSI: 0000000000000286 RDI: 0000000000000286
RBP: ffff88003a3bbcc8 R08: ffffea0000993c58 R09: 0000000000000000
R10: ffff88003e7fdfa0 R11: 0000000000000020 R12: 0000000000000297
R13: ffff88003a3bbc88 R14: ffff88003d7d5258 R15: 0000000000000297
FS:  0000000000000000(0000) GS:ffff88003d7c0000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000003cddcaae90 CR3: 0000000001a0b000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process cc1 (pid: 6572, threadinfo ffff88003a3ba000, task ffff880038f30080)
Stack:
 000000000000000e ffff88003a3bbd48 ffffffff8110d7ed ffff88003a3bbd78
 ffffea0000993c90 ffff88003d981680 00000000ffffffff 0000000000000286
 0000000200000000 ffffea0000993c90 ffffea0000719cb0 0000000000000000
Call Trace:
 [<ffffffff8110d7ed>] release_pages+0x1ad/0x210
 [<ffffffff81139424>] free_pages_and_swap_cache+0xb4/0xe0
 [<ffffffff812d1da1>] ? cpumask_any_but+0x31/0x50
 [<ffffffff8112515c>] tlb_flush_mmu+0x6c/0x90
 [<ffffffff81125644>] tlb_finish_mmu+0x14/0x40
 [<ffffffff8112c4a8>] exit_mmap+0xd8/0x140
 [<ffffffff8103e143>] mmput+0x73/0x120
 [<ffffffff81044fca>] exit_mm+0x10a/0x140
 [<ffffffff8104516b>] do_exit+0x16b/0x450
 [<ffffffff810454a5>] do_group_exit+0x55/0xd0
 [<ffffffff81045537>] sys_exit_group+0x17/0x20
 [<ffffffff815eb9e9>] system_call_fastpath+0x16/0x1b
Code: 66 90 e8 db b9 a4 ff 66 90 c9 c3 0f 1f 80 00 00 00 00 55 48 89 e5 53 66 66 66 66 90 48 89 f3 e8 1e ba a4 ff 66 90 48 89 df 57 9d <66> 66 90 66 90 5b c9 c3 66 66 66 66 66 66 2e 0f 1f 84 00 00 00 
Call Trace:
 [<ffffffff8110d7ed>] release_pages+0x1ad/0x210
 [<ffffffff81139424>] free_pages_and_swap_cache+0xb4/0xe0
 [<ffffffff812d1da1>] ? cpumask_any_but+0x31/0x50
 [<ffffffff8112515c>] tlb_flush_mmu+0x6c/0x90
 [<ffffffff81125644>] tlb_finish_mmu+0x14/0x40
 [<ffffffff8112c4a8>] exit_mmap+0xd8/0x140
 [<ffffffff8103e143>] mmput+0x73/0x120
 [<ffffffff81044fca>] exit_mm+0x10a/0x140
 [<ffffffff8104516b>] do_exit+0x16b/0x450
 [<ffffffff810454a5>] do_group_exit+0x55/0xd0
 [<ffffffff81045537>] sys_exit_group+0x17/0x20
 [<ffffffff815eb9e9>] system_call_fastpath+0x16/0x1b
FS:  0000000000000000(0000) GS:ffff88003d740000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000003cddcaae90 CR3: 0000000001a0b000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process cc1 (pid: 6560, threadinfo ffff88003b2f2000, task ffff88003820b4e0)
Stack:
 000000000000000e ffff88003b2f3d48 ffffffff8110d7ed ffff88003b2f3d78
 ffffea0000937988 ffff88003d981680 00000000ffffffff 0000000000000286
 0000000200000000 ffffea0000937988 ffffea0000842330 0000000000000000
Call Trace:
 [<ffffffff8110d7ed>] release_pages+0x1ad/0x210
 [<ffffffff81139424>] free_pages_and_swap_cache+0xb4/0xe0
 [<ffffffff812d1da1>] ? cpumask_any_but+0x31/0x50
 [<ffffffff8112515c>] tlb_flush_mmu+0x6c/0x90
 [<ffffffff81125644>] tlb_finish_mmu+0x14/0x40
 [<ffffffff8112c4a8>] exit_mmap+0xd8/0x140
 [<ffffffff8103e143>] mmput+0x73/0x120
 [<ffffffff81044fca>] exit_mm+0x10a/0x140
 [<ffffffff8104516b>] do_exit+0x16b/0x450
 [<ffffffff810454a5>] do_group_exit+0x55/0xd0
 [<ffffffff81045537>] sys_exit_group+0x17/0x20
 [<ffffffff815eb9e9>] system_call_fastpath+0x16/0x1b
Code: 66 90 e8 db b9 a4 ff 66 90 c9 c3 0f 1f 80 00 00 00 00 55 48 89 e5 53 66 66 66 66 90 48 89 f3 e8 1e ba a4 ff 66 90 48 89 df 57 9d <66> 66 90 66 90 5b c9 c3 66 66 66 66 66 66 2e 0f 1f 84 00 00 00 
Call Trace:
 [<ffffffff8110d7ed>] release_pages+0x1ad/0x210
 [<ffffffff81139424>] free_pages_and_swap_cache+0xb4/0xe0
 [<ffffffff812d1da1>] ? cpumask_any_but+0x31/0x50
 [<ffffffff8112515c>] tlb_flush_mmu+0x6c/0x90
 [<ffffffff81125644>] tlb_finish_mmu+0x14/0x40
 [<ffffffff8112c4a8>] exit_mmap+0xd8/0x140
 [<ffffffff8103e143>] mmput+0x73/0x120
 [<ffffffff81044fca>] exit_mm+0x10a/0x140
 [<ffffffff8104516b>] do_exit+0x16b/0x450
 [<ffffffff810454a5>] do_group_exit+0x55/0xd0
 [<ffffffff81045537>] sys_exit_group+0x17/0x20
 [<ffffffff815eb9e9>] system_call_fastpath+0x16/0x1b
BUG: soft lockup - CPU#4 stuck for 23s! [khugepaged:52]
Modules linked in:
CPU 4 
Modules linked in:

Pid: 52, comm: khugepaged Not tainted 3.4.0-rc4-base+ #1 Red Hat KVM
RIP: 0010:[<ffffffff815e34d9>]  [<ffffffff815e34d9>] _raw_spin_unlock_irqrestore+0x19/0x30
RSP: 0018:ffff880038189ab8  EFLAGS: 00000282
RAX: 0000000000000282 RBX: 000000000000000e RCX: ffffc90000182000
RDX: 0000000000000009 RSI: 0000000000000282 RDI: 0000000000000282
RBP: ffff880038189ac0 R08: 0000000000000003 R09: 5e00000000000000
R10: ffff88003d981680 R11: 0000000000000000 R12: ffff88003d70f1e0
R13: 000000000000000e R14: 0000000000000010 R15: ffffffff81109eaf
FS:  0000000000000000(0000) GS:ffff88003d700000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000d52c9c CR3: 0000000001a0b000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process khugepaged (pid: 52, threadinfo ffff880038188000, task ffff880038182b30)
Stack:
 ffff88003d70f160 ffff880038189b10 ffffffff8110d90f 0000000000000282
 0000000000000001 ffffea00008287d0 ffffea0000733178 ffff88003d70f160
 0000000000000000 00000000ffffffff 000000000043f958 ffff880038189b20
Call Trace:
 [<ffffffff8110d90f>] pagevec_lru_move_fn+0xbf/0xf0
 [<ffffffff8110d957>] __pagevec_lru_add+0x17/0x20
 [<ffffffff8110ddc8>] __lru_cache_add+0x68/0x90
 [<ffffffff8115bed9>] ? __mem_cgroup_uncharge_common+0xf9/0x280
 [<ffffffff8110de1d>] lru_cache_add_lru+0x2d/0x50
 [<ffffffff81112919>] putback_lru_page+0x69/0xe0
 [<ffffffff81151eeb>] release_pte_page+0x2b/0x40
 [<ffffffff81152335>] __collapse_huge_page_copy+0x185/0x200
 [<ffffffff81152096>] ? __collapse_huge_page_isolate+0x116/0x1c0
 [<ffffffff811526d7>] collapse_huge_page+0x327/0x500
 [<ffffffff812d84be>] ? rb_erase+0xce/0x150
 [<ffffffff81152a75>] khugepaged_scan_pmd+0x1c5/0x2f0
 [<ffffffff81152ffe>] khugepaged_scan_mm_slot+0x17e/0x280
 [<ffffffff8115407c>] khugepaged_do_scan+0xbc/0xe0
 [<ffffffff81154f5f>] khugepaged_loop+0x5f/0x3c0
 [<ffffffff81062bd0>] ? wake_up_bit+0x40/0x40
 [<ffffffff811552c0>] ? khugepaged_loop+0x3c0/0x3c0
 [<ffffffff8115530a>] khugepaged+0x4a/0xb0
 [<ffffffff810624fe>] kthread+0x9e/0xb0
 [<ffffffff815ecce4>] kernel_thread_helper+0x4/0x10
 [<ffffffff81062460>] ? kthread_freezable_should_stop+0x70/0x70
 [<ffffffff815ecce0>] ? gs_change+0x13/0x13
Code: 66 90 e8 db b9 a4 ff 66 90 c9 c3 0f 1f 80 00 00 00 00 55 48 89 e5 53 66 66 66 66 90 48 89 f3 e8 1e ba a4 ff 66 90 48 89 df 57 9d <66> 66 90 66 90 5b c9 c3 66 66 66 66 66 66 2e 0f 1f 84 00 00 00 
Call Trace:
 [<ffffffff8110d90f>] pagevec_lru_move_fn+0xbf/0xf0
 [<ffffffff8110d957>] __pagevec_lru_add+0x17/0x20
 [<ffffffff8110ddc8>] __lru_cache_add+0x68/0x90
 [<ffffffff8115bed9>] ? __mem_cgroup_uncharge_common+0xf9/0x280
 [<ffffffff8110de1d>] lru_cache_add_lru+0x2d/0x50
 [<ffffffff81112919>] putback_lru_page+0x69/0xe0
 [<ffffffff81151eeb>] release_pte_page+0x2b/0x40
 [<ffffffff81152335>] __collapse_huge_page_copy+0x185/0x200
 [<ffffffff81152096>] ? __collapse_huge_page_isolate+0x116/0x1c0
 [<ffffffff811526d7>] collapse_huge_page+0x327/0x500
 [<ffffffff812d84be>] ? rb_erase+0xce/0x150
 [<ffffffff81152a75>] khugepaged_scan_pmd+0x1c5/0x2f0
 [<ffffffff81152ffe>] khugepaged_scan_mm_slot+0x17e/0x280
 [<ffffffff8115407c>] khugepaged_do_scan+0xbc/0xe0
 [<ffffffff81154f5f>] khugepaged_loop+0x5f/0x3c0
 [<ffffffff81062bd0>] ? wake_up_bit+0x40/0x40
 [<ffffffff811552c0>] ? khugepaged_loop+0x3c0/0x3c0
 [<ffffffff8115530a>] khugepaged+0x4a/0xb0
 [<ffffffff810624fe>] kthread+0x9e/0xb0
 [<ffffffff815ecce4>] kernel_thread_helper+0x4/0x10
 [<ffffffff81062460>] ? kthread_freezable_should_stop+0x70/0x70
 [<ffffffff815ecce0>] ? gs_change+0x13/0x13
BUG: soft lockup - CPU#6 stuck for 21s! [cc1:6599]
Modules linked in:
CPU 6 
Modules linked in:

Pid: 6599, comm: cc1 Not tainted 3.4.0-rc4-base+ #1 Red Hat KVM
RIP: 0010:[<ffffffff815e34d9>]  [<ffffffff815e34d9>] _raw_spin_unlock_irqrestore+0x19/0x30
RSP: 0018:ffff880038dcfcc0  EFLAGS: 00000286
RAX: ffffea0000768ca0 RBX: 0000000001a03025 RCX: ffff88003d981680
RDX: ffffea0000748400 RSI: 0000000000000286 RDI: 0000000000000286
RBP: ffff880038dcfcc8 R08: ffffea0000748400 R09: 0000000000000000
R10: ffff88003e7fdf88 R11: 0000000000000020 R12: 0000000000000297
R13: ffff880038dcfc88 R14: ffff88003d795258 R15: 0000000000000297
FS:  0000000000000000(0000) GS:ffff88003d780000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000003cddcaae90 CR3: 0000000001a0b000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process cc1 (pid: 6599, threadinfo ffff880038dce000, task ffff88003a0c60c0)
Stack:
 000000000000000e ffff880038dcfd48 ffffffff8110d7ed ffff880038dcfd78
 ffffea0000768ca0 ffff88003d981680 00000000ffffffff 0000000000000286
 0000000200000000 ffffea0000768ca0 ffffea00007ca1e8 0000000000000000
Call Trace:
 [<ffffffff8110d7ed>] release_pages+0x1ad/0x210
 [<ffffffff81139424>] free_pages_and_swap_cache+0xb4/0xe0
 [<ffffffff812d1da1>] ? cpumask_any_but+0x31/0x50
 [<ffffffff8112515c>] tlb_flush_mmu+0x6c/0x90
 [<ffffffff81125644>] tlb_finish_mmu+0x14/0x40
 [<ffffffff8112c4a8>] exit_mmap+0xd8/0x140
 [<ffffffff8103e143>] mmput+0x73/0x120
 [<ffffffff81044fca>] exit_mm+0x10a/0x140
 [<ffffffff8104516b>] do_exit+0x16b/0x450
 [<ffffffff810454a5>] do_group_exit+0x55/0xd0
 [<ffffffff81045537>] sys_exit_group+0x17/0x20
 [<ffffffff815eb9e9>] system_call_fastpath+0x16/0x1b
Code: 66 90 e8 db b9 a4 ff 66 90 c9 c3 0f 1f 80 00 00 00 00 55 48 89 e5 53 66 66 66 66 90 48 89 f3 e8 1e ba a4 ff 66 90 48 89 df 57 9d <66> 66 90 66 90 5b c9 c3 66 66 66 66 66 66 2e 0f 1f 84 00 00 00 
Call Trace:
 [<ffffffff8110d7ed>] release_pages+0x1ad/0x210
 [<ffffffff81139424>] free_pages_and_swap_cache+0xb4/0xe0
 [<ffffffff812d1da1>] ? cpumask_any_but+0x31/0x50
 [<ffffffff8112515c>] tlb_flush_mmu+0x6c/0x90
 [<ffffffff81125644>] tlb_finish_mmu+0x14/0x40
 [<ffffffff8112c4a8>] exit_mmap+0xd8/0x140
 [<ffffffff8103e143>] mmput+0x73/0x120
 [<ffffffff81044fca>] exit_mm+0x10a/0x140
 [<ffffffff8104516b>] do_exit+0x16b/0x450
 [<ffffffff810454a5>] do_group_exit+0x55/0xd0
 [<ffffffff81045537>] sys_exit_group+0x17/0x20
 [<ffffffff815eb9e9>] system_call_fastpath+0x16/0x1b
BUG: soft lockup - CPU#4 stuck for 23s! [khugepaged:52]
Modules linked in:
CPU 4 
Modules linked in:

Pid: 52, comm: khugepaged Not tainted 3.4.0-rc4-base+ #1 Red Hat KVM
RIP: 0010:[<ffffffff815e34d9>]  [<ffffffff815e34d9>] _raw_spin_unlock_irqrestore+0x19/0x30
RSP: 0018:ffff880038189ab8  EFLAGS: 00000282
RAX: 0000000000000282 RBX: 000000000000000e RCX: ffffc90000182000
RDX: 0000000000000009 RSI: 0000000000000282 RDI: 0000000000000282
RBP: ffff880038189ac0 R08: 00000000ffffffff R09: 4c00000000000000
R10: ffff88003d981680 R11: 0000000000000000 R12: ffff88003d70f1e0
R13: 000000000000000e R14: 0000000000000010 R15: ffffffff81109eaf
FS:  0000000000000000(0000) GS:ffff88003d700000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000d52c9c CR3: 0000000001a0b000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process khugepaged (pid: 52, threadinfo ffff880038188000, task ffff880038182b30)
Stack:
 ffff88003d70f160 ffff880038189b10 ffffffff8110d90f 0000000000000282
 0000000000000001 ffffea0000647a60 ffffea0000849930 ffff88003d70f160
 0000000000000000 00000000ffffffff 0000000000423488 ffff880038189b20
Call Trace:
 [<ffffffff8110d90f>] pagevec_lru_move_fn+0xbf/0xf0
 [<ffffffff8110d957>] __pagevec_lru_add+0x17/0x20
 [<ffffffff8110ddc8>] __lru_cache_add+0x68/0x90
 [<ffffffff8115bed9>] ? __mem_cgroup_uncharge_common+0xf9/0x280
 [<ffffffff8110de1d>] lru_cache_add_lru+0x2d/0x50
 [<ffffffff81112919>] putback_lru_page+0x69/0xe0
 [<ffffffff81151eeb>] release_pte_page+0x2b/0x40
 [<ffffffff81152335>] __collapse_huge_page_copy+0x185/0x200
 [<ffffffff81152096>] ? __collapse_huge_page_isolate+0x116/0x1c0
 [<ffffffff811526d7>] collapse_huge_page+0x327/0x500
 [<ffffffff812d84be>] ? rb_erase+0xce/0x150
 [<ffffffff81152a75>] khugepaged_scan_pmd+0x1c5/0x2f0
 [<ffffffff815e240e>] ? __schedule+0x3de/0x710
 [<ffffffff81152ffe>] khugepaged_scan_mm_slot+0x17e/0x280
 [<ffffffff8115407c>] khugepaged_do_scan+0xbc/0xe0
 [<ffffffff81154f5f>] khugepaged_loop+0x5f/0x3c0
 [<ffffffff81062bd0>] ? wake_up_bit+0x40/0x40
 [<ffffffff811552c0>] ? khugepaged_loop+0x3c0/0x3c0
 [<ffffffff8115530a>] khugepaged+0x4a/0xb0
 [<ffffffff810624fe>] kthread+0x9e/0xb0
 [<ffffffff815ecce4>] kernel_thread_helper+0x4/0x10
 [<ffffffff81062460>] ? kthread_freezable_should_stop+0x70/0x70
 [<ffffffff815ecce0>] ? gs_change+0x13/0x13
Code: 66 90 e8 db b9 a4 ff 66 90 c9 c3 0f 1f 80 00 00 00 00 55 48 89 e5 53 66 66 66 66 90 48 89 f3 e8 1e ba a4 ff 66 90 48 89 df 57 9d <66> 66 90 66 90 5b c9 c3 66 66 66 66 66 66 2e 0f 1f 84 00 00 00 
Call Trace:
 [<ffffffff8110d90f>] pagevec_lru_move_fn+0xbf/0xf0
 [<ffffffff8110d957>] __pagevec_lru_add+0x17/0x20
 [<ffffffff8110ddc8>] __lru_cache_add+0x68/0x90
 [<ffffffff8115bed9>] ? __mem_cgroup_uncharge_common+0xf9/0x280
 [<ffffffff8110de1d>] lru_cache_add_lru+0x2d/0x50
 [<ffffffff81112919>] putback_lru_page+0x69/0xe0
 [<ffffffff81151eeb>] release_pte_page+0x2b/0x40
 [<ffffffff81152335>] __collapse_huge_page_copy+0x185/0x200
 [<ffffffff81152096>] ? __collapse_huge_page_isolate+0x116/0x1c0
 [<ffffffff811526d7>] collapse_huge_page+0x327/0x500
 [<ffffffff812d84be>] ? rb_erase+0xce/0x150
 [<ffffffff81152a75>] khugepaged_scan_pmd+0x1c5/0x2f0
 [<ffffffff815e240e>] ? __schedule+0x3de/0x710
 [<ffffffff81152ffe>] khugepaged_scan_mm_slot+0x17e/0x280
 [<ffffffff8115407c>] khugepaged_do_scan+0xbc/0xe0
 [<ffffffff81154f5f>] khugepaged_loop+0x5f/0x3c0
 [<ffffffff81062bd0>] ? wake_up_bit+0x40/0x40
 [<ffffffff811552c0>] ? khugepaged_loop+0x3c0/0x3c0
 [<ffffffff8115530a>] khugepaged+0x4a/0xb0
 [<ffffffff810624fe>] kthread+0x9e/0xb0
 [<ffffffff815ecce4>] kernel_thread_helper+0x4/0x10
 [<ffffffff81062460>] ? kthread_freezable_should_stop+0x70/0x70
 [<ffffffff815ecce0>] ? gs_change+0x13/0x13
BUG: soft lockup - CPU#1 stuck for 22s! [cc1:6608]
Modules linked in:
CPU 1 
Modules linked in:

Pid: 6608, comm: cc1 Not tainted 3.4.0-rc4-base+ #1 Red Hat KVM
RIP: 0010:[<ffffffff815e34d9>]  [<ffffffff815e34d9>] _raw_spin_unlock_irqrestore+0x19/0x30
RSP: 0018:ffff88003e17bcc0  EFLAGS: 00000286
RAX: ffffea0000b6ac48 RBX: 0000000001a03025 RCX: ffff88003d981680
RDX: ffffea0000b6ac10 RSI: 0000000000000286 RDI: 0000000000000286
RBP: ffff88003e17bcc8 R08: ffffea0000b6ac10 R09: 0000000000000000
R10: ffff88003e7fdf88 R11: 0000000000000020 R12: 0000000000000297
R13: ffff88003e17bc88 R14: ffff88003d655258 R15: 0000000000000297
FS:  0000000000000000(0000) GS:ffff88003d640000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000003cddcaae90 CR3: 0000000001a0b000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process cc1 (pid: 6608, threadinfo ffff88003e17a000, task ffff88003989e100)
Stack:
 000000000000000e ffff88003e17bd48 ffffffff8110d7ed ffff88003e17bd78
 ffffea0000b6ac48 ffff88003d981680 00000000ffffffff 0000000000000286
 0000000200000000 ffffea0000b6ac48 ffffea00007ebcb0 0000000000000000
Call Trace:
 [<ffffffff8110d7ed>] release_pages+0x1ad/0x210
 [<ffffffff81139424>] free_pages_and_swap_cache+0xb4/0xe0
 [<ffffffff812d1da1>] ? cpumask_any_but+0x31/0x50
 [<ffffffff8112515c>] tlb_flush_mmu+0x6c/0x90
 [<ffffffff81125644>] tlb_finish_mmu+0x14/0x40
 [<ffffffff8112c4a8>] exit_mmap+0xd8/0x140
 [<ffffffff8103e143>] mmput+0x73/0x120
 [<ffffffff81044fca>] exit_mm+0x10a/0x140
 [<ffffffff8104516b>] do_exit+0x16b/0x450
 [<ffffffff810454a5>] do_group_exit+0x55/0xd0
 [<ffffffff81045537>] sys_exit_group+0x17/0x20
 [<ffffffff815eb9e9>] system_call_fastpath+0x16/0x1b
Code: 66 90 e8 db b9 a4 ff 66 90 c9 c3 0f 1f 80 00 00 00 00 55 48 89 e5 53 66 66 66 66 90 48 89 f3 e8 1e ba a4 ff 66 90 48 89 df 57 9d <66> 66 90 66 90 5b c9 c3 66 66 66 66 66 66 2e 0f 1f 84 00 00 00 
Call Trace:
 [<ffffffff8110d7ed>] release_pages+0x1ad/0x210
 [<ffffffff81139424>] free_pages_and_swap_cache+0xb4/0xe0
 [<ffffffff812d1da1>] ? cpumask_any_but+0x31/0x50
 [<ffffffff8112515c>] tlb_flush_mmu+0x6c/0x90
 [<ffffffff81125644>] tlb_finish_mmu+0x14/0x40
 [<ffffffff8112c4a8>] exit_mmap+0xd8/0x140
 [<ffffffff8103e143>] mmput+0x73/0x120
 [<ffffffff81044fca>] exit_mm+0x10a/0x140
 [<ffffffff8104516b>] do_exit+0x16b/0x450
 [<ffffffff810454a5>] do_group_exit+0x55/0xd0
 [<ffffffff81045537>] sys_exit_group+0x17/0x20
 [<ffffffff815eb9e9>] system_call_fastpath+0x16/0x1b
BUG: soft lockup - CPU#2 stuck for 22s! [cc1:6683]
Modules linked in:
CPU 2 
Modules linked in:

Pid: 6683, comm: cc1 Not tainted 3.4.0-rc4-base+ #1 Red Hat KVM
RIP: 0010:[<ffffffff815e34d9>]  [<ffffffff815e34d9>] _raw_spin_unlock_irqrestore+0x19/0x30
RSP: 0018:ffff8800388e5cc0  EFLAGS: 00000286
RAX: ffffea00008b0618 RBX: 0000000001a03025 RCX: ffff88003d981680
RDX: ffffea00008b05e0 RSI: 0000000000000286 RDI: 0000000000000286
RBP: ffff8800388e5cc8 R08: ffffea00008b05e0 R09: 0000000000000000
R10: ffff88003e7fdfa0 R11: 0000000000000010 R12: 0000000000000297
R13: ffff8800388e5c88 R14: ffff88003d695258 R15: 0000000000000297
FS:  0000000000000000(0000) GS:ffff88003d680000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000003cddcaae90 CR3: 0000000001a0b000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process cc1 (pid: 6683, threadinfo ffff8800388e4000, task ffff88003834b4a0)
Stack:
 000000000000000e ffff8800388e5d48 ffffffff8110d7ed ffff8800388e5d78
 ffffea00008b0618 ffff88003d981680 00000000ffffffff 0000000000000286
 0000000200000000 ffffea00008b0618 ffffea000064e930 0000000000000000
Call Trace:
 [<ffffffff8110d7ed>] release_pages+0x1ad/0x210
 [<ffffffff81139424>] free_pages_and_swap_cache+0xb4/0xe0
 [<ffffffff812d1da1>] ? cpumask_any_but+0x31/0x50
 [<ffffffff8112515c>] tlb_flush_mmu+0x6c/0x90
 [<ffffffff81125644>] tlb_finish_mmu+0x14/0x40
 [<ffffffff8112c4a8>] exit_mmap+0xd8/0x140
 [<ffffffff8103e143>] mmput+0x73/0x120
 [<ffffffff81044fca>] exit_mm+0x10a/0x140
 [<ffffffff8104516b>] do_exit+0x16b/0x450
 [<ffffffff810454a5>] do_group_exit+0x55/0xd0
 [<ffffffff81045537>] sys_exit_group+0x17/0x20
 [<ffffffff815eb9e9>] system_call_fastpath+0x16/0x1b
Code: 66 90 e8 db b9 a4 ff 66 90 c9 c3 0f 1f 80 00 00 00 00 55 48 89 e5 53 66 66 66 66 90 48 89 f3 e8 1e ba a4 ff 66 90 48 89 df 57 9d <66> 66 90 66 90 5b c9 c3 66 66 66 66 66 66 2e 0f 1f 84 00 00 00 
Call Trace:
 [<ffffffff8110d7ed>] release_pages+0x1ad/0x210
 [<ffffffff81139424>] free_pages_and_swap_cache+0xb4/0xe0
 [<ffffffff812d1da1>] ? cpumask_any_but+0x31/0x50
 [<ffffffff8112515c>] tlb_flush_mmu+0x6c/0x90
 [<ffffffff81125644>] tlb_finish_mmu+0x14/0x40
 [<ffffffff8112c4a8>] exit_mmap+0xd8/0x140
 [<ffffffff8103e143>] mmput+0x73/0x120
 [<ffffffff81044fca>] exit_mm+0x10a/0x140
 [<ffffffff8104516b>] do_exit+0x16b/0x450
 [<ffffffff810454a5>] do_group_exit+0x55/0xd0
 [<ffffffff81045537>] sys_exit_group+0x17/0x20
 [<ffffffff815eb9e9>] system_call_fastpath+0x16/0x1b
BUG: soft lockup - CPU#6 stuck for 22s! [khugepaged:52]
Modules linked in:
CPU 6 
Modules linked in:

Pid: 52, comm: khugepaged Not tainted 3.4.0-rc4-base+ #1 Red Hat KVM
RIP: 0010:[<ffffffff815e34d9>]  [<ffffffff815e34d9>] _raw_spin_unlock_irqrestore+0x19/0x30
RSP: 0000:ffff880038189b18  EFLAGS: 00000282
RAX: 000000000001529a RBX: 0000000000000010 RCX: ffffffffffffffe0
RDX: ffffffffffffffe7 RSI: 0000000000000282 RDI: 0000000000000282
RBP: ffff880038189b20 R08: 00000000ffffffe8 R09: 0000000000000000
R10: ffff88003e7fdfa0 R11: 0000000000000000 R12: ffffea000077c9d0
R13: 0000000200000282 R14: 0000000000000286 R15: 0000000000000009
FS:  0000000000000000(0000) GS:ffff88003d780000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 00007f1962d0f000 CR3: 0000000001a0b000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process khugepaged (pid: 52, threadinfo ffff880038188000, task ffff880038182b30)
Stack:
 ffff88003d981680 ffff880038189b60 ffffffff8110d450 ffff880038189b70
 ffffea000077c9e8 ffffea000077c9e8 ffff88003995f580 0000000000000580
 0000000000454680 ffff880038189b80 ffffffff8110d4c6 ffff880038189b80
Call Trace:
 [<ffffffff8110d450>] __page_cache_release+0x100/0x130
 [<ffffffff8110d4c6>] __put_single_page+0x16/0x30
 [<ffffffff8110dba5>] put_page+0x25/0x40
 [<ffffffff8113933a>] free_page_and_swap_cache+0x2a/0x60
 [<ffffffff81152381>] __collapse_huge_page_copy+0x1d1/0x200
 [<ffffffff81152096>] ? __collapse_huge_page_isolate+0x116/0x1c0
 [<ffffffff811526d7>] collapse_huge_page+0x327/0x500
 [<ffffffff812d84be>] ? rb_erase+0xce/0x150
 [<ffffffff81152a75>] khugepaged_scan_pmd+0x1c5/0x2f0
 [<ffffffff815e240e>] ? __schedule+0x3de/0x710
 [<ffffffff81152ffe>] khugepaged_scan_mm_slot+0x17e/0x280
 [<ffffffff8115407c>] khugepaged_do_scan+0xbc/0xe0
 [<ffffffff81154f5f>] khugepaged_loop+0x5f/0x3c0
 [<ffffffff81062bd0>] ? wake_up_bit+0x40/0x40
 [<ffffffff811552c0>] ? khugepaged_loop+0x3c0/0x3c0
 [<ffffffff8115530a>] khugepaged+0x4a/0xb0
 [<ffffffff810624fe>] kthread+0x9e/0xb0
 [<ffffffff815ecce4>] kernel_thread_helper+0x4/0x10
 [<ffffffff81062460>] ? kthread_freezable_should_stop+0x70/0x70
 [<ffffffff815ecce0>] ? gs_change+0x13/0x13
Code: 66 90 e8 db b9 a4 ff 66 90 c9 c3 0f 1f 80 00 00 00 00 55 48 89 e5 53 66 66 66 66 90 48 89 f3 e8 1e ba a4 ff 66 90 48 89 df 57 9d <66> 66 90 66 90 5b c9 c3 66 66 66 66 66 66 2e 0f 1f 84 00 00 00 
Call Trace:
 [<ffffffff8110d450>] __page_cache_release+0x100/0x130
 [<ffffffff8110d4c6>] __put_single_page+0x16/0x30
 [<ffffffff8110dba5>] put_page+0x25/0x40
 [<ffffffff8113933a>] free_page_and_swap_cache+0x2a/0x60
 [<ffffffff81152381>] __collapse_huge_page_copy+0x1d1/0x200
 [<ffffffff81152096>] ? __collapse_huge_page_isolate+0x116/0x1c0
 [<ffffffff811526d7>] collapse_huge_page+0x327/0x500
 [<ffffffff812d84be>] ? rb_erase+0xce/0x150
 [<ffffffff81152a75>] khugepaged_scan_pmd+0x1c5/0x2f0
 [<ffffffff815e240e>] ? __schedule+0x3de/0x710
 [<ffffffff81152ffe>] khugepaged_scan_mm_slot+0x17e/0x280
 [<ffffffff8115407c>] khugepaged_do_scan+0xbc/0xe0
 [<ffffffff81154f5f>] khugepaged_loop+0x5f/0x3c0
 [<ffffffff81062bd0>] ? wake_up_bit+0x40/0x40
 [<ffffffff811552c0>] ? khugepaged_loop+0x3c0/0x3c0
 [<ffffffff8115530a>] khugepaged+0x4a/0xb0
 [<ffffffff810624fe>] kthread+0x9e/0xb0
 [<ffffffff815ecce4>] kernel_thread_helper+0x4/0x10
 [<ffffffff81062460>] ? kthread_freezable_should_stop+0x70/0x70
 [<ffffffff815ecce0>] ? gs_change+0x13/0x13
hdparm: sending ioctl 330 to a partition!
hdparm: sending ioctl 330 to a partition!
hdparm: sending ioctl 330 to a partition!
hdparm: sending ioctl 330 to a partition!
BUG: soft lockup - CPU#6 stuck for 22s! [khugepaged:52]
Modules linked in:
CPU 6 
Modules linked in:

Pid: 52, comm: khugepaged Not tainted 3.4.0-rc4-base+ #1 Red Hat KVM
RIP: 0010:[<ffffffff815e34d9>]  [<ffffffff815e34d9>] _raw_spin_unlock_irqrestore+0x19/0x30
RSP: 0000:ffff880038189a38  EFLAGS: 00000286
RAX: 0000000000000000 RBX: 0000000000000002 RCX: ffff88003d981680
RDX: ffffea00007d7ba8 RSI: 0000000000000286 RDI: 0000000000000286
RBP: ffff880038189a40 R08: ffffea00007d7b58 R09: ea00000000000000
R10: ffff88003d981680 R11: 0000000000000000 R12: ffff880038189a00
R13: ffff88003d795258 R14: 0000000000000297 R15: ffffea000098db18
FS:  0000000000000000(0000) GS:ffff88003d780000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 00007f1962d0f000 CR3: 0000000001a0b000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process khugepaged (pid: 52, threadinfo ffff880038188000, task ffff880038182b30)
Stack:
 000000000000000e ffff880038189ac0 ffffffff8110d7ed 000000000000000c
 ffffea00007d7b90 ffff88003d981680 0000000000000009 0000000000000286
 0000000200000282 ffffea00007d7b90 ffffea0000544a80 0000000000000010
Call Trace:
 [<ffffffff8110d7ed>] release_pages+0x1ad/0x210
 [<ffffffff8110d250>] ? add_page_to_unevictable_list+0xd0/0xd0
 [<ffffffff8110d91f>] pagevec_lru_move_fn+0xcf/0xf0
 [<ffffffff8110d957>] __pagevec_lru_add+0x17/0x20
 [<ffffffff8110ddc8>] __lru_cache_add+0x68/0x90
 [<ffffffff8115bed9>] ? __mem_cgroup_uncharge_common+0xf9/0x280
 [<ffffffff8110de1d>] lru_cache_add_lru+0x2d/0x50
 [<ffffffff81112919>] putback_lru_page+0x69/0xe0
 [<ffffffff81151eeb>] release_pte_page+0x2b/0x40
 [<ffffffff81152335>] __collapse_huge_page_copy+0x185/0x200
 [<ffffffff81152096>] ? __collapse_huge_page_isolate+0x116/0x1c0
 [<ffffffff811526d7>] collapse_huge_page+0x327/0x500
 [<ffffffff812d84be>] ? rb_erase+0xce/0x150
 [<ffffffff81152a75>] khugepaged_scan_pmd+0x1c5/0x2f0
 [<ffffffff815e240e>] ? __schedule+0x3de/0x710
 [<ffffffff81152ffe>] khugepaged_scan_mm_slot+0x17e/0x280
 [<ffffffff8115407c>] khugepaged_do_scan+0xbc/0xe0
 [<ffffffff81154f5f>] khugepaged_loop+0x5f/0x3c0
 [<ffffffff81062bd0>] ? wake_up_bit+0x40/0x40
 [<ffffffff811552c0>] ? khugepaged_loop+0x3c0/0x3c0
 [<ffffffff8115530a>] khugepaged+0x4a/0xb0
 [<ffffffff810624fe>] kthread+0x9e/0xb0
 [<ffffffff815ecce4>] kernel_thread_helper+0x4/0x10
 [<ffffffff81062460>] ? kthread_freezable_should_stop+0x70/0x70
 [<ffffffff815ecce0>] ? gs_change+0x13/0x13
Code: 66 90 e8 db b9 a4 ff 66 90 c9 c3 0f 1f 80 00 00 00 00 55 48 89 e5 53 66 66 66 66 90 48 89 f3 e8 1e ba a4 ff 66 90 48 89 df 57 9d <66> 66 90 66 90 5b c9 c3 66 66 66 66 66 66 2e 0f 1f 84 00 00 00 
Call Trace:
 [<ffffffff8110d7ed>] release_pages+0x1ad/0x210
 [<ffffffff8110d250>] ? add_page_to_unevictable_list+0xd0/0xd0
 [<ffffffff8110d91f>] pagevec_lru_move_fn+0xcf/0xf0
 [<ffffffff8110d957>] __pagevec_lru_add+0x17/0x20
 [<ffffffff8110ddc8>] __lru_cache_add+0x68/0x90
 [<ffffffff8115bed9>] ? __mem_cgroup_uncharge_common+0xf9/0x280
 [<ffffffff8110de1d>] lru_cache_add_lru+0x2d/0x50
 [<ffffffff81112919>] putback_lru_page+0x69/0xe0
 [<ffffffff81151eeb>] release_pte_page+0x2b/0x40
 [<ffffffff81152335>] __collapse_huge_page_copy+0x185/0x200
 [<ffffffff81152096>] ? __collapse_huge_page_isolate+0x116/0x1c0
 [<ffffffff811526d7>] collapse_huge_page+0x327/0x500
 [<ffffffff812d84be>] ? rb_erase+0xce/0x150
 [<ffffffff81152a75>] khugepaged_scan_pmd+0x1c5/0x2f0
 [<ffffffff815e240e>] ? __schedule+0x3de/0x710
 [<ffffffff81152ffe>] khugepaged_scan_mm_slot+0x17e/0x280
 [<ffffffff8115407c>] khugepaged_do_scan+0xbc/0xe0
 [<ffffffff81154f5f>] khugepaged_loop+0x5f/0x3c0
 [<ffffffff81062bd0>] ? wake_up_bit+0x40/0x40
 [<ffffffff811552c0>] ? khugepaged_loop+0x3c0/0x3c0
 [<ffffffff8115530a>] khugepaged+0x4a/0xb0
 [<ffffffff810624fe>] kthread+0x9e/0xb0
 [<ffffffff815ecce4>] kernel_thread_helper+0x4/0x10
 [<ffffffff81062460>] ? kthread_freezable_should_stop+0x70/0x70
 [<ffffffff815ecce0>] ? gs_change+0x13/0x13
hdparm: sending ioctl 330 to a partition!
hdparm: sending ioctl 330 to a partition!
hdparm: sending ioctl 330 to a partition!
hdparm: sending ioctl 330 to a partition!
hdparm: sending ioctl 330 to a partition!
hdparm: sending ioctl 330 to a partition!
BUG: soft lockup - CPU#6 stuck for 22s! [khugepaged:52]
Modules linked in:
CPU 6 
Modules linked in:

Pid: 52, comm: khugepaged Not tainted 3.4.0-rc4-base+ #1 Red Hat KVM
RIP: 0010:[<ffffffff815e34d9>]  [<ffffffff815e34d9>] _raw_spin_unlock_irqrestore+0x19/0x30
RSP: 0018:ffff880038189b18  EFLAGS: 00000282
RAX: 000000000001529a RBX: 0000000000000010 RCX: ffffffffffffffe0
RDX: ffffffffffffffea RSI: 0000000000000282 RDI: 0000000000000282
RBP: ffff880038189b20 R08: 00000000ffffffeb R09: 0000000000000000
R10: ffff88003e7fdfd0 R11: 0000000000000000 R12: ffffea0000aa6e78
R13: 0000000200000282 R14: 0000000000000286 R15: 0000000000000009
FS:  0000000000000000(0000) GS:ffff88003d780000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000dc3018 CR3: 0000000001a0b000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process khugepaged (pid: 52, threadinfo ffff880038188000, task ffff880038182b30)
Stack:
 ffff88003d981680 ffff880038189b60 ffffffff8110d450 ffff880038189b70
 ffffea00008eee88 ffffea00008eee88 ffff880038041fb0 0000000000000fb0
 0000000000443dd0 ffff880038189b80 ffffffff8110d4c6 ffff880038189b80
Call Trace:
 [<ffffffff8110d450>] __page_cache_release+0x100/0x130
 [<ffffffff8110d4c6>] __put_single_page+0x16/0x30
 [<ffffffff8110dba5>] put_page+0x25/0x40
 [<ffffffff8113933a>] free_page_and_swap_cache+0x2a/0x60
 [<ffffffff81152381>] __collapse_huge_page_copy+0x1d1/0x200
 [<ffffffff81152096>] ? __collapse_huge_page_isolate+0x116/0x1c0
 [<ffffffff811526d7>] collapse_huge_page+0x327/0x500
 [<ffffffff81152a75>] khugepaged_scan_pmd+0x1c5/0x2f0
 [<ffffffff81152ffe>] khugepaged_scan_mm_slot+0x17e/0x280
 [<ffffffff8115407c>] khugepaged_do_scan+0xbc/0xe0
 [<ffffffff81154f5f>] khugepaged_loop+0x5f/0x3c0
 [<ffffffff81062bd0>] ? wake_up_bit+0x40/0x40
 [<ffffffff811552c0>] ? khugepaged_loop+0x3c0/0x3c0
 [<ffffffff8115530a>] khugepaged+0x4a/0xb0
 [<ffffffff810624fe>] kthread+0x9e/0xb0
 [<ffffffff815ecce4>] kernel_thread_helper+0x4/0x10
 [<ffffffff81062460>] ? kthread_freezable_should_stop+0x70/0x70
 [<ffffffff815ecce0>] ? gs_change+0x13/0x13
Code: 66 90 e8 db b9 a4 ff 66 90 c9 c3 0f 1f 80 00 00 00 00 55 48 89 e5 53 66 66 66 66 90 48 89 f3 e8 1e ba a4 ff 66 90 48 89 df 57 9d <66> 66 90 66 90 5b c9 c3 66 66 66 66 66 66 2e 0f 1f 84 00 00 00 
Call Trace:
 [<ffffffff8110d450>] __page_cache_release+0x100/0x130
 [<ffffffff8110d4c6>] __put_single_page+0x16/0x30
 [<ffffffff8110dba5>] put_page+0x25/0x40
 [<ffffffff8113933a>] free_page_and_swap_cache+0x2a/0x60
 [<ffffffff81152381>] __collapse_huge_page_copy+0x1d1/0x200
 [<ffffffff81152096>] ? __collapse_huge_page_isolate+0x116/0x1c0
 [<ffffffff811526d7>] collapse_huge_page+0x327/0x500
 [<ffffffff81152a75>] khugepaged_scan_pmd+0x1c5/0x2f0
 [<ffffffff81152ffe>] khugepaged_scan_mm_slot+0x17e/0x280
 [<ffffffff8115407c>] khugepaged_do_scan+0xbc/0xe0
 [<ffffffff81154f5f>] khugepaged_loop+0x5f/0x3c0
 [<ffffffff81062bd0>] ? wake_up_bit+0x40/0x40
 [<ffffffff811552c0>] ? khugepaged_loop+0x3c0/0x3c0
 [<ffffffff8115530a>] khugepaged+0x4a/0xb0
 [<ffffffff810624fe>] kthread+0x9e/0xb0
 [<ffffffff815ecce4>] kernel_thread_helper+0x4/0x10
 [<ffffffff81062460>] ? kthread_freezable_should_stop+0x70/0x70
 [<ffffffff815ecce0>] ? gs_change+0x13/0x13
BUG: soft lockup - CPU#6 stuck for 24s! [khugepaged:52]
Modules linked in:
CPU 6 
Modules linked in:

Pid: 52, comm: khugepaged Not tainted 3.4.0-rc4-base+ #1 Red Hat KVM
RIP: 0010:[<ffffffff815e34d9>]  [<ffffffff815e34d9>] _raw_spin_unlock_irqrestore+0x19/0x30
RSP: 0018:ffff880038189a38  EFLAGS: 00000286
RAX: 0000000000000000 RBX: ffff8800381899f0 RCX: ffff88003d981680
RDX: ffffea000091b690 RSI: 0000000000000286 RDI: 0000000000000286
RBP: ffff880038189a40 R08: ffffea0000523ae0 R09: a400000000000000
R10: ffff88003d981680 R11: 0000000000000000 R12: ffff880038189a00
R13: ffff88003d795258 R14: 0000000000000297 R15: ffffea00008a9ac8
FS:  0000000000000000(0000) GS:ffff88003d780000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000002eed68f CR3: 0000000001a0b000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process khugepaged (pid: 52, threadinfo ffff880038188000, task ffff880038182b30)
Stack:
 000000000000000e ffff880038189ac0 ffffffff8110d7ed 000000000000000a
 ffffea000092a718 ffff88003d981680 0000000000000009 0000000000000286
 0000000200000282 ffffea000092a718 ffffea00009983e0 0000000000000010
Call Trace:
 [<ffffffff8110d7ed>] release_pages+0x1ad/0x210
 [<ffffffff8110d250>] ? add_page_to_unevictable_list+0xd0/0xd0
 [<ffffffff8110d91f>] pagevec_lru_move_fn+0xcf/0xf0
 [<ffffffff8110d957>] __pagevec_lru_add+0x17/0x20
 [<ffffffff8110ddc8>] __lru_cache_add+0x68/0x90
 [<ffffffff8115bed9>] ? __mem_cgroup_uncharge_common+0xf9/0x280
 [<ffffffff8110de1d>] lru_cache_add_lru+0x2d/0x50
 [<ffffffff81112919>] putback_lru_page+0x69/0xe0
 [<ffffffff81151eeb>] release_pte_page+0x2b/0x40
 [<ffffffff81152335>] __collapse_huge_page_copy+0x185/0x200
 [<ffffffff81152096>] ? __collapse_huge_page_isolate+0x116/0x1c0
 [<ffffffff811526d7>] collapse_huge_page+0x327/0x500
 [<ffffffff81152a75>] khugepaged_scan_pmd+0x1c5/0x2f0
 [<ffffffff815e240e>] ? __schedule+0x3de/0x710
 [<ffffffff81152ffe>] khugepaged_scan_mm_slot+0x17e/0x280
 [<ffffffff8115407c>] khugepaged_do_scan+0xbc/0xe0
 [<ffffffff81154f5f>] khugepaged_loop+0x5f/0x3c0
 [<ffffffff81062bd0>] ? wake_up_bit+0x40/0x40
 [<ffffffff811552c0>] ? khugepaged_loop+0x3c0/0x3c0
 [<ffffffff8115530a>] khugepaged+0x4a/0xb0
 [<ffffffff810624fe>] kthread+0x9e/0xb0
 [<ffffffff815ecce4>] kernel_thread_helper+0x4/0x10
 [<ffffffff81062460>] ? kthread_freezable_should_stop+0x70/0x70
 [<ffffffff815ecce0>] ? gs_change+0x13/0x13
Code: 66 90 e8 db b9 a4 ff 66 90 c9 c3 0f 1f 80 00 00 00 00 55 48 89 e5 53 66 66 66 66 90 48 89 f3 e8 1e ba a4 ff 66 90 48 89 df 57 9d <66> 66 90 66 90 5b c9 c3 66 66 66 66 66 66 2e 0f 1f 84 00 00 00 
Call Trace:
 [<ffffffff8110d7ed>] release_pages+0x1ad/0x210
 [<ffffffff8110d250>] ? add_page_to_unevictable_list+0xd0/0xd0
 [<ffffffff8110d91f>] pagevec_lru_move_fn+0xcf/0xf0
 [<ffffffff8110d957>] __pagevec_lru_add+0x17/0x20
 [<ffffffff8110ddc8>] __lru_cache_add+0x68/0x90
 [<ffffffff8115bed9>] ? __mem_cgroup_uncharge_common+0xf9/0x280
 [<ffffffff8110de1d>] lru_cache_add_lru+0x2d/0x50
 [<ffffffff81112919>] putback_lru_page+0x69/0xe0
 [<ffffffff81151eeb>] release_pte_page+0x2b/0x40
 [<ffffffff81152335>] __collapse_huge_page_copy+0x185/0x200
 [<ffffffff81152096>] ? __collapse_huge_page_isolate+0x116/0x1c0
 [<ffffffff811526d7>] collapse_huge_page+0x327/0x500
 [<ffffffff81152a75>] khugepaged_scan_pmd+0x1c5/0x2f0
 [<ffffffff815e240e>] ? __schedule+0x3de/0x710
 [<ffffffff81152ffe>] khugepaged_scan_mm_slot+0x17e/0x280
 [<ffffffff8115407c>] khugepaged_do_scan+0xbc/0xe0
 [<ffffffff81154f5f>] khugepaged_loop+0x5f/0x3c0
 [<ffffffff81062bd0>] ? wake_up_bit+0x40/0x40
 [<ffffffff811552c0>] ? khugepaged_loop+0x3c0/0x3c0
 [<ffffffff8115530a>] khugepaged+0x4a/0xb0
 [<ffffffff810624fe>] kthread+0x9e/0xb0
 [<ffffffff815ecce4>] kernel_thread_helper+0x4/0x10
 [<ffffffff81062460>] ? kthread_freezable_should_stop+0x70/0x70
 [<ffffffff815ecce0>] ? gs_change+0x13/0x13
BUG: soft lockup - CPU#6 stuck for 23s! [khugepaged:52]
Modules linked in:
CPU 6 
Modules linked in:

Pid: 52, comm: khugepaged Not tainted 3.4.0-rc4-base+ #1 Red Hat KVM
RIP: 0010:[<ffffffff815e34d9>]  [<ffffffff815e34d9>] _raw_spin_unlock_irqrestore+0x19/0x30
RSP: 0000:ffff880038189a38  EFLAGS: 00000286
RAX: 0000000000000000 RBX: ffff8800381899f0 RCX: ffff88003d981680
RDX: ffffea0000954928 RSI: 0000000000000286 RDI: 0000000000000286
RBP: ffff880038189a40 R08: ffffea0000736928 R09: 4a00000000000000
R10: ffff88003d981680 R11: 0000000000000000 R12: ffff880038189a00
R13: ffff88003d795258 R14: 0000000000000297 R15: ffffea00006af058
FS:  0000000000000000(0000) GS:ffff88003d780000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 00007f2cb099a000 CR3: 0000000001a0b000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process khugepaged (pid: 52, threadinfo ffff880038188000, task ffff880038182b30)
Stack:
 000000000000000e ffff880038189ac0 ffffffff8110d7ed 000000000000000d
 ffffea0000722a38 ffff88003d981680 0000000000000009 0000000000000286
 0000000200000282 ffffea0000722a38 ffffea00005e2d38 0000000000000010
Call Trace:
 [<ffffffff8110d7ed>] release_pages+0x1ad/0x210
 [<ffffffff8110d250>] ? add_page_to_unevictable_list+0xd0/0xd0
 [<ffffffff8110d91f>] pagevec_lru_move_fn+0xcf/0xf0
 [<ffffffff8110d957>] __pagevec_lru_add+0x17/0x20
 [<ffffffff8110ddc8>] __lru_cache_add+0x68/0x90
 [<ffffffff8115bed9>] ? __mem_cgroup_uncharge_common+0xf9/0x280
 [<ffffffff8110de1d>] lru_cache_add_lru+0x2d/0x50
 [<ffffffff81112919>] putback_lru_page+0x69/0xe0
 [<ffffffff81151eeb>] release_pte_page+0x2b/0x40
 [<ffffffff81152335>] __collapse_huge_page_copy+0x185/0x200
 [<ffffffff81152096>] ? __collapse_huge_page_isolate+0x116/0x1c0
 [<ffffffff811526d7>] collapse_huge_page+0x327/0x500
 [<ffffffff81152a75>] khugepaged_scan_pmd+0x1c5/0x2f0
 [<ffffffff81152ffe>] khugepaged_scan_mm_slot+0x17e/0x280
 [<ffffffff8115407c>] khugepaged_do_scan+0xbc/0xe0
 [<ffffffff81154f5f>] khugepaged_loop+0x5f/0x3c0
 [<ffffffff81062bd0>] ? wake_up_bit+0x40/0x40
 [<ffffffff811552c0>] ? khugepaged_loop+0x3c0/0x3c0
 [<ffffffff8115530a>] khugepaged+0x4a/0xb0
 [<ffffffff810624fe>] kthread+0x9e/0xb0
 [<ffffffff815ecce4>] kernel_thread_helper+0x4/0x10
 [<ffffffff81062460>] ? kthread_freezable_should_stop+0x70/0x70
 [<ffffffff815ecce0>] ? gs_change+0x13/0x13
Code: 66 90 e8 db b9 a4 ff 66 90 c9 c3 0f 1f 80 00 00 00 00 55 48 89 e5 53 66 66 66 66 90 48 89 f3 e8 1e ba a4 ff 66 90 48 89 df 57 9d <66> 66 90 66 90 5b c9 c3 66 66 66 66 66 66 2e 0f 1f 84 00 00 00 
Call Trace:
 [<ffffffff8110d7ed>] release_pages+0x1ad/0x210
 [<ffffffff8110d250>] ? add_page_to_unevictable_list+0xd0/0xd0
 [<ffffffff8110d91f>] pagevec_lru_move_fn+0xcf/0xf0
 [<ffffffff8110d957>] __pagevec_lru_add+0x17/0x20
 [<ffffffff8110ddc8>] __lru_cache_add+0x68/0x90
 [<ffffffff8115bed9>] ? __mem_cgroup_uncharge_common+0xf9/0x280
 [<ffffffff8110de1d>] lru_cache_add_lru+0x2d/0x50
 [<ffffffff81112919>] putback_lru_page+0x69/0xe0
 [<ffffffff81151eeb>] release_pte_page+0x2b/0x40
 [<ffffffff81152335>] __collapse_huge_page_copy+0x185/0x200
 [<ffffffff81152096>] ? __collapse_huge_page_isolate+0x116/0x1c0
 [<ffffffff811526d7>] collapse_huge_page+0x327/0x500
 [<ffffffff81152a75>] khugepaged_scan_pmd+0x1c5/0x2f0
 [<ffffffff81152ffe>] khugepaged_scan_mm_slot+0x17e/0x280
 [<ffffffff8115407c>] khugepaged_do_scan+0xbc/0xe0
 [<ffffffff81154f5f>] khugepaged_loop+0x5f/0x3c0
 [<ffffffff81062bd0>] ? wake_up_bit+0x40/0x40
 [<ffffffff811552c0>] ? khugepaged_loop+0x3c0/0x3c0
 [<ffffffff8115530a>] khugepaged+0x4a/0xb0
 [<ffffffff810624fe>] kthread+0x9e/0xb0
 [<ffffffff815ecce4>] kernel_thread_helper+0x4/0x10
 [<ffffffff81062460>] ? kthread_freezable_should_stop+0x70/0x70
 [<ffffffff815ecce0>] ? gs_change+0x13/0x13
OHparted: sending ioctl 1261 to a partition!
parted: sending ioctl 1261 to a partition!
parted: sending ioctl 1261 to a partition!
BUG: soft lockup - CPU#6 stuck for 22s! [khugepaged:52]
Modules linked in:
CPU 6 
Modules linked in:

Pid: 52, comm: khugepaged Not tainted 3.4.0-rc4-base+ #1 Red Hat KVM
RIP: 0010:[<ffffffff815e34d9>]  [<ffffffff815e34d9>] _raw_spin_unlock_irqrestore+0x19/0x30
RSP: 0000:ffff880038189a38  EFLAGS: 00000286
RAX: 0000000000000000 RBX: ffff8800381899f0 RCX: ffff88003d981680
RDX: ffffea0000892838 RSI: 0000000000000286 RDI: 0000000000000286
RBP: ffff880038189a40 R08: ffffea0000a34018 R09: 0e00000000000000
R10: ffff88003d981680 R11: 0000000000000000 R12: ffff880038189a00
R13: ffff88003d795258 R14: 0000000000000297 R15: ffffea00006b0018
FS:  0000000000000000(0000) GS:ffff88003d780000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 000000000300c528 CR3: 0000000001a0b000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process khugepaged (pid: 52, threadinfo ffff880038188000, task ffff880038182b30)
Stack:
 000000000000000e ffff880038189ac0 ffffffff8110d7ed 00000000fffffff2
 ffffea00009b4178 ffff88003d981680 0000000000000009 0000000000000286
 0000000200000282 ffffea00009b4178 ffffea0000648ce0 0000000000000010
Call Trace:
 [<ffffffff8110d7ed>] release_pages+0x1ad/0x210
 [<ffffffff8110d250>] ? add_page_to_unevictable_list+0xd0/0xd0
 [<ffffffff8110d91f>] pagevec_lru_move_fn+0xcf/0xf0
 [<ffffffff8110d957>] __pagevec_lru_add+0x17/0x20
 [<ffffffff8110ddc8>] __lru_cache_add+0x68/0x90
 [<ffffffff8115bed9>] ? __mem_cgroup_uncharge_common+0xf9/0x280
 [<ffffffff8110de1d>] lru_cache_add_lru+0x2d/0x50
 [<ffffffff81112919>] putback_lru_page+0x69/0xe0
 [<ffffffff81151eeb>] release_pte_page+0x2b/0x40
 [<ffffffff81152335>] __collapse_huge_page_copy+0x185/0x200
 [<ffffffff81152096>] ? __collapse_huge_page_isolate+0x116/0x1c0
 [<ffffffff811526d7>] collapse_huge_page+0x327/0x500
 [<ffffffff81152a75>] khugepaged_scan_pmd+0x1c5/0x2f0
 [<ffffffff815e240e>] ? __schedule+0x3de/0x710
 [<ffffffff81152ffe>] khugepaged_scan_mm_slot+0x17e/0x280
 [<ffffffff8115407c>] khugepaged_do_scan+0xbc/0xe0
 [<ffffffff81154f5f>] khugepaged_loop+0x5f/0x3c0
 [<ffffffff81062bd0>] ? wake_up_bit+0x40/0x40
 [<ffffffff811552c0>] ? khugepaged_loop+0x3c0/0x3c0
 [<ffffffff8115530a>] khugepaged+0x4a/0xb0
 [<ffffffff810624fe>] kthread+0x9e/0xb0
 [<ffffffff815ecce4>] kernel_thread_helper+0x4/0x10
 [<ffffffff81062460>] ? kthread_freezable_should_stop+0x70/0x70
 [<ffffffff815ecce0>] ? gs_change+0x13/0x13
Code: 66 90 e8 db b9 a4 ff 66 90 c9 c3 0f 1f 80 00 00 00 00 55 48 89 e5 53 66 66 66 66 90 48 89 f3 e8 1e ba a4 ff 66 90 48 89 df 57 9d <66> 66 90 66 90 5b c9 c3 66 66 66 66 66 66 2e 0f 1f 84 00 00 00 
Call Trace:
 [<ffffffff8110d7ed>] release_pages+0x1ad/0x210
 [<ffffffff8110d250>] ? add_page_to_unevictable_list+0xd0/0xd0
 [<ffffffff8110d91f>] pagevec_lru_move_fn+0xcf/0xf0
 [<ffffffff8110d957>] __pagevec_lru_add+0x17/0x20
 [<ffffffff8110ddc8>] __lru_cache_add+0x68/0x90
 [<ffffffff8115bed9>] ? __mem_cgroup_uncharge_common+0xf9/0x280
 [<ffffffff8110de1d>] lru_cache_add_lru+0x2d/0x50
 [<ffffffff81112919>] putback_lru_page+0x69/0xe0
 [<ffffffff81151eeb>] release_pte_page+0x2b/0x40
 [<ffffffff81152335>] __collapse_huge_page_copy+0x185/0x200
 [<ffffffff81152096>] ? __collapse_huge_page_isolate+0x116/0x1c0
 [<ffffffff811526d7>] collapse_huge_page+0x327/0x500
 [<ffffffff81152a75>] khugepaged_scan_pmd+0x1c5/0x2f0
 [<ffffffff815e240e>] ? __schedule+0x3de/0x710
 [<ffffffff81152ffe>] khugepaged_scan_mm_slot+0x17e/0x280
 [<ffffffff8115407c>] khugepaged_do_scan+0xbc/0xe0
 [<ffffffff81154f5f>] khugepaged_loop+0x5f/0x3c0
 [<ffffffff81062bd0>] ? wake_up_bit+0x40/0x40
 [<ffffffff811552c0>] ? khugepaged_loop+0x3c0/0x3c0
 [<ffffffff8115530a>] khugepaged+0x4a/0xb0
 [<ffffffff810624fe>] kthread+0x9e/0xb0
 [<ffffffff815ecce4>] kernel_thread_helper+0x4/0x10
 [<ffffffff81062460>] ? kthread_freezable_should_stop+0x70/0x70
 [<ffffffff815ecce0>] ? gs_change+0x13/0x13

BUG: soft lockup - CPU#2 stuck for 22s! [khugepaged:52]
Modules linked in:
CPU 2 
Modules linked in:

Pid: 52, comm: khugepaged Not tainted 3.4.0-rc4-base+ #1 Red Hat KVM
RIP: 0010:[<ffffffff8111286e>]  [<ffffffff8111286e>] isolate_lru_page+0x12e/0x170
RSP: 0018:ffff880038189b90  EFLAGS: 00000282
RAX: 000000000001529a RBX: ffff88003d692478 RCX: ffffffffffffffe0
RDX: fffffffffffffff7 RSI: 0000000000000002 RDI: ffff88003d981b00
RBP: ffff880038189bc0 R08: 00000000fffffff8 R09: 0000000000015258
R10: ffff88003d981680 R11: 0000000000000020 R12: 0000000038189b50
R13: ffff880038989528 R14: ffff88003d692478 R15: ffffffff81001762
FS:  0000000000000000(0000) GS:ffff88003d680000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 00007f0983253000 CR3: 0000000001a0b000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process khugepaged (pid: 52, threadinfo ffff880038188000, task ffff880038182b30)
Stack:
 ffff880038189fd8 0000000000012400 ffff88003848fcd0 0000000000000cd0
 00007f5bf299a000 0000000000000067 ffff880038189c30 ffffffff8115207d
 ffff880038189bf0 ffffea00009d59b8 ffff880038490000 000000013848f067
Call Trace:
 [<ffffffff8115207d>] __collapse_huge_page_isolate+0xfd/0x1c0
 [<ffffffff81152696>] collapse_huge_page+0x2e6/0x500
 [<ffffffff812d84be>] ? rb_erase+0xce/0x150
 [<ffffffff81152a75>] khugepaged_scan_pmd+0x1c5/0x2f0
 [<ffffffff81152ffe>] khugepaged_scan_mm_slot+0x17e/0x280
 [<ffffffff8115407c>] khugepaged_do_scan+0xbc/0xe0
 [<ffffffff81154f5f>] khugepaged_loop+0x5f/0x3c0
 [<ffffffff81062bd0>] ? wake_up_bit+0x40/0x40
 [<ffffffff811552c0>] ? khugepaged_loop+0x3c0/0x3c0
 [<ffffffff8115530a>] khugepaged+0x4a/0xb0
 [<ffffffff810624fe>] kthread+0x9e/0xb0
 [<ffffffff815ecce4>] kernel_thread_helper+0x4/0x10
 [<ffffffff81062460>] ? kthread_freezable_should_stop+0x70/0x70
 [<ffffffff815ecce0>] ? gs_change+0x13/0x13
Code: 89 de 4c 89 ef 25 00 40 00 00 48 83 f8 01 19 d2 31 db 81 ca 00 fe ff ff e8 30 c6 00 00 4c 89 e7 e8 88 c6 f1 ff 66 90 fb 66 66 90 <66> 66 90 e9 08 ff ff ff 66 2e 0f 1f 84 00 00 00 00 00 89 c3 eb 
Call Trace:
 [<ffffffff8115207d>] __collapse_huge_page_isolate+0xfd/0x1c0
 [<ffffffff81152696>] collapse_huge_page+0x2e6/0x500
 [<ffffffff812d84be>] ? rb_erase+0xce/0x150
 [<ffffffff81152a75>] khugepaged_scan_pmd+0x1c5/0x2f0
 [<ffffffff81152ffe>] khugepaged_scan_mm_slot+0x17e/0x280
 [<ffffffff8115407c>] khugepaged_do_scan+0xbc/0xe0
 [<ffffffff81154f5f>] khugepaged_loop+0x5f/0x3c0
 [<ffffffff81062bd0>] ? wake_up_bit+0x40/0x40
 [<ffffffff811552c0>] ? khugepaged_loop+0x3c0/0x3c0
 [<ffffffff8115530a>] khugepaged+0x4a/0xb0
 [<ffffffff810624fe>] kthread+0x9e/0xb0
 [<ffffffff815ecce4>] kernel_thread_helper+0x4/0x10
 [<ffffffff81062460>] ? kthread_freezable_should_stop+0x70/0x70
 [<ffffffff815ecce0>] ? gs_change+0x13/0x13
BUG: soft lockup - CPU#1 stuck for 21s! [cc1:7665]
Modules linked in:
CPU 1 
Modules linked in:

Pid: 7665, comm: cc1 Not tainted 3.4.0-rc4-base+ #1 Red Hat KVM
RIP: 0010:[<ffffffff815e34d9>]  [<ffffffff815e34d9>] _raw_spin_unlock_irqrestore+0x19/0x30
RSP: 0018:ffff8800388bfcc0  EFLAGS: 00000286
RAX: ffffea00004d1c90 RBX: 0000000001a03025 RCX: ffff88003d981680
RDX: ffffea00005ba040 RSI: 0000000000000286 RDI: 0000000000000286
RBP: ffff8800388bfcc8 R08: ffffea00005ba040 R09: 0000000000000000
R10: ffff88003e7fdfa0 R11: 0000000000000020 R12: 0000000000000297
R13: ffff8800388bfc88 R14: ffff88003d655258 R15: 0000000000000297
FS:  0000000000000000(0000) GS:ffff88003d640000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000003cddcaae90 CR3: 0000000001a0b000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process cc1 (pid: 7665, threadinfo ffff8800388be000, task ffff880038e7a040)
Stack:
 000000000000000e ffff8800388bfd48 ffffffff8110d7ed ffff8800388bfd78
 ffffea00004d1c90 ffff88003d981680 00000000ffffffff 0000000000000286
 0000000200000000 ffffea00004d1c90 ffffea0000b64118 0000000000000000
Call Trace:
 [<ffffffff8110d7ed>] release_pages+0x1ad/0x210
 [<ffffffff81139424>] free_pages_and_swap_cache+0xb4/0xe0
 [<ffffffff812d1da1>] ? cpumask_any_but+0x31/0x50
 [<ffffffff8112515c>] tlb_flush_mmu+0x6c/0x90
 [<ffffffff81125644>] tlb_finish_mmu+0x14/0x40
 [<ffffffff8112c4a8>] exit_mmap+0xd8/0x140
 [<ffffffff8103e143>] mmput+0x73/0x120
 [<ffffffff81044fca>] exit_mm+0x10a/0x140
 [<ffffffff8104516b>] do_exit+0x16b/0x450
 [<ffffffff810454a5>] do_group_exit+0x55/0xd0
 [<ffffffff81045537>] sys_exit_group+0x17/0x20
 [<ffffffff815eb9e9>] system_call_fastpath+0x16/0x1b
Code: 66 90 e8 db b9 a4 ff 66 90 c9 c3 0f 1f 80 00 00 00 00 55 48 89 e5 53 66 66 66 66 90 48 89 f3 e8 1e ba a4 ff 66 90 48 89 df 57 9d <66> 66 90 66 90 5b c9 c3 66 66 66 66 66 66 2e 0f 1f 84 00 00 00 
Call Trace:
 [<ffffffff8110d7ed>] release_pages+0x1ad/0x210
 [<ffffffff81139424>] free_pages_and_swap_cache+0xb4/0xe0
 [<ffffffff812d1da1>] ? cpumask_any_but+0x31/0x50
 [<ffffffff8112515c>] tlb_flush_mmu+0x6c/0x90
 [<ffffffff81125644>] tlb_finish_mmu+0x14/0x40
 [<ffffffff8112c4a8>] exit_mmap+0xd8/0x140
 [<ffffffff8103e143>] mmput+0x73/0x120
 [<ffffffff81044fca>] exit_mm+0x10a/0x140
 [<ffffffff8104516b>] do_exit+0x16b/0x450
 [<ffffffff810454a5>] do_group_exit+0x55/0xd0
 [<ffffffff81045537>] sys_exit_group+0x17/0x20
 [<ffffffff815eb9e9>] system_call_fastpath+0x16/0x1b

