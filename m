Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757005Ab0KLKjM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Nov 2010 05:39:12 -0500
Received: from mail4.comsite.net ([205.238.176.238]:62877 "EHLO
	mail4.comsite.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756897Ab0KLKjJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Nov 2010 05:39:09 -0500
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=71.22.127.106;
To: Andrew Morton <akpm@linux-foundation.org>
Cc: <linux-kernel@vger.kernel.org>, <linuxppc-dev@lists.ozlabs.org>,
        Ingo Molnar <mingo@redhat.com>,
        Subrata Modak <subrata@linux.vnet.ibm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
From: Milton Miller <miltonm@bga.com>
Subject: Re: [Call Trace: 2.6.37-rc1-git7 & 2.6.37-rc1-git8, Powerpc] LTPmsgctl11 test case
In-Reply-To: <20101110230016.40e4875e.akpm@linux-foundation.org>
References: <1289457219.5622.15.camel@subratamodak.linux.ibm.com>
	<1289457481.5622.16.camel@subratamodak.linux.ibm.com>
	<20101110230016.40e4875e.akpm@linux-foundation.org>
Date: Fri, 12 Nov 2010 04:38:25 -0600
X-Originating-IP: 71.22.127.106
Message-ID: <1289558305_15622@mail4.comsite.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


[guessing partial cc list, not subscribed]

On Thu Nov 11 2010 around 02:03:45 EST, Andrew Morton wrote:
> On Thu, 11 Nov 2010 12:03:39 +0530 Subrata Modak <subrata@xxxxxxxxxxxxxxxxxx> wrote:
> 
> > Hi Peter/Ingo,
> >
> > LTP__ msgctl11 test case creates Call trace and Exception for kernels
> > 2.6.37-rc1-git7 & 2.6.37-rc1-git8. Please see the dmesg below:

--- followup from Subrata Modak 
> > Kindly note that the same thing was not observed till git6 on the same
> > machine.
---

> >
> > ================================================
> > msgctl11: page allocation failure. order:0, mode:0x20
> > Call Trace:
> > [c0000000fffcef30] [c000000000014c74] .show_stack+0x74/0x1c0 (unreliable)
> > [c0000000fffcefe0] [c00000000015e938] .__alloc_pages_nodemask+0x6d8/0x950
> > [c0000000fffcf160] [c0000000001a0c60] .alloc_pages_current+0xa0/0x160
> > [c0000000fffcf200] [c0000000001abfd8] .new_slab+0x358/0x370
> > [c0000000fffcf2b0] [c0000000001ac1cc] .__slab_alloc+0x1dc/0x500
> > [c0000000fffcf390] [c0000000001ad808] .kmem_cache_alloc+0x1a8/0x1b0
> > [c0000000fffcf440] [c0000000004eec88] .scsi_pool_alloc_command+0x58/0xa0
> > [c0000000fffcf4d0] [c0000000004eed60] .scsi_host_alloc_command+0x30/0xb0
> > [c0000000fffcf560] [c0000000004eee00] .__scsi_get_command+0x20/0xd0
> > [c0000000fffcf5f0] [c0000000004ef158] .scsi_get_command+0x58/0xf0
> > [c0000000fffcf690] [c0000000004f7948] .scsi_setup_fs_cmnd+0x108/0x120
> > [c0000000fffcf720] [d000000001484ad8] .sd_prep_fn+0x2b8/0xc70 [sd_mod]
> > [c0000000fffcf800] [c0000000003ea92c] .blk_peek_request+0x14c/0x310
> > [c0000000fffcf8b0] [c0000000004f6b14] .scsi_request_fn+0x94/0x560
> > [c0000000fffcf980] [c0000000003eba00] .__blk_run_queue+0x90/0x1b0
> > [c0000000fffcfa00] [c0000000003ebc20] .blk_run_queue+0x30/0x60
> > [c0000000fffcfa90] [c0000000004f5d84] .scsi_run_queue+0x104/0x3c0
> > [c0000000fffcfb60] [c0000000004f7228] .scsi_next_command+0x48/0x70
> > [c0000000fffcfbf0] [c0000000004f8280] .scsi_io_completion+0x3e0/0x580
> > [c0000000fffcfcd0] [c0000000004ee0a8] .scsi_finish_command+0x128/0x180
> > [c0000000fffcfd70] [c0000000004f8548] .scsi_softirq_done+0x118/0x1e0
> > [c0000000fffcfe10] [c0000000003f2410] .blk_done_softirq+0xb0/0xe0
> > [c0000000fffcfea0] [c0000000000943c8] .__do_softirq+0x118/0x290
> > [c0000000fffcff90] [c000000000031f58] .call_do_softirq+0x14/0x24
> > [c0000000a0992a20] [c00000000000f554] .do_softirq+0xf4/0x120
> > [c0000000a0992ac0] [c0000000000941d4] .irq_exit+0xb4/0xc0
> > [c0000000a0992b40] [c00000000000f7e0] .do_IRQ+0x160/0x2c0
> > [c0000000a0992c00] [c000000000004898] hardware_interrupt_entry+0x18/0x80
> > --- Exception: 501 at .do_raw_spin_unlock+0x80/0xe0
> > LR = ._raw_spin_unlock+0x30/0x50
> > [c0000000a0992f70] [c00000000018943c] .__page_check_address+0x16c/0x1a0
> > [c0000000a0993010] [c00000000018a5b4] .page_referenced_one+0x54/0x200
> > [c0000000a09930d0] [c00000000018ab4c] .page_referenced+0x3ec/0x490
> > [c0000000a0993200] [c000000000168bbc] .shrink_page_list+0x2bc/0x6d0
> > [c0000000a0993350] [c00000000016942c] .shrink_inactive_list+0x15c/0x580
> > [c0000000a0993460] [c000000000169f10] .shrink_zone+0x2e0/0x4b0
> > [c0000000a0993580] [c00000000016b3c0] .do_try_to_free_pages+0x110/0x510
> > [c0000000a0993670] [c00000000016bb3c] .try_to_free_pages+0xbc/0x1a0
> > [c0000000a0993780] [c00000000015e7a0] .__alloc_pages_nodemask+0x540/0x950
> > [c0000000a0993900] [c0000000001a0db8] .alloc_page_vma+0x98/0x1d0
> > [c0000000a09939a0] [c00000000017c7f4] .do_wp_page+0x144/0xb60
> > [c0000000a0993a90] [c00000000017eef0] .handle_mm_fault+0x670/0xb50
> > [c0000000a0993b80] [c0000000006feea4] .do_page_fault+0x344/0x780
> > [c0000000a0993e30] [c00000000000522c] handle_page_fault+0x20/0x74
> 
> That trace is impressively hard to understand. Who called
> do_raw_spin_unlock?
> 

You seem to say that a lot for PowerPC traces :-)

LR is the link register, which is a return address.  It is set by the
branch and link instruction to the address after the branch (ie the
sequential instruction that would have executed if the branch were
not taken).  Barring special assembly, it usually points either to the
instruction this function will return to or some place earlier in this
execution history of this function where a called function returned
upon its completion.  The normal calling convention is LR register is
saved lazily into a fixed stack slot (ie leaf functions to not save it)
and the PowerPC traceback code suppresses printing the slot if it
appears to not be valid. 

In this case, do_raw_spin_unlock was called from _raw_spin_unlock
(specifically, the call site was 0x30 - 4 = 0x2c bytes = 11 instructions
into the function), which in turn was called from __page_check_address,
probably via inlines and tail calls in the expansion of pte_unmap_unlock.

However, I'm not sure why you are intrested in that part of the
call chain.  Perhaps you are keying on seeing Exception printed near
that function?  In this case, the "trap" number is 501 which is just
an normal asynchronous external interrupt (either from a device or an
inter-processor interrupt -- the decremeter aka timer has its own vector).
You can recognise this by the calls to hardware_interrupt and __do_IRQ.
There is no fault or problem detected by the processor, do_raw_spin_unlock
is just the function happened to be executing when the device interrupt
came in.

So in this case, it looks like we were trying to free pages (to handle a
page fault for write access) with external interrupts enabled and took a
interrupt from an adapter serviced by the scsi subsystem.  The adapter
probably finshed some IO, but the system was so low on memory that it
denied the scsi layer request for 128 bytes to issue another command
even though the mode is __GFP_HIGH.

The memory stats is the intresting part of the trace.
7*64kB 3*128kB  (7 order-0 and 3 order-1 pages in buddy)
1414592  slab_unreclaimable
1059264  pagetables
169600   isolated(anon)
156336   kernel_stack
only 92 64k pages (100% full, <6MB total) in the failing kmalloc-128 pool


milton


Trivia: the 0x501 is the combination of the architected address
(0x500) the cpu starts fetching from when it decides to service the
external interrupt, and the 1 bit is a flag to note that we only
saved the registers not saved by the callee in the ABI.  However,
it's easier to recognise the trap from the called function(s), in this
case hardware_interrupt_entry and do_IRQ.  Other common trap numbers
include 0x900 for the timer interrupt, 300 for data page faults, 400
for instruction page faults, and 700 for illegal instructions and traps
which are used for BUG and WARN.  The trap numbers are generated by the
assembly code not directly from the target of the branch.

> > 
> > active_anon:17322 inactive_anon:4230 isolated_anon:2650
> > active_file:7 inactive_file:29 isolated_file:46
> > unevictable:0 dirty:0 writeback:343 unstable:0
> > free:57 slab_reclaimable:426 slab_unreclaimable:22103
> > mapped:19 shmem:0 pagetables:16551 bounce:0
> > Node 0 DMA free:832kB min:8128kB low:10112kB high:12160kB active_anon:1108608kB inactive_anon:270720kB active_file:448kB inactive_file:1856kB unevictable:0kB isolated(anon):169600kB isolated(file):2944kB present:4190720kB mlocked:0kB dirty:0kB writeback:21952kB mapped:1216kB shmem:0kB slab_reclaimable:27264kB slab_unreclaimable:1414592kB kernel_stack:156336kB pagetables:1059264kB unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:69 all_unreclaimable? no
> > lowmem_reserve[]: 0 0 0
> > Node 0 DMA: 7*64kB 3*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB 0*8192kB 0*16384kB = 832kB
> > 5188 total pagecache pages
> > 4932 pages in swap cache
> > Swap cache stats: add 37086, delete 32154, find 29567/36415
> > Free swap = 3652416kB
> > Total swap = 4095936kB
> > 65536 pages RAM
> > 1557 pages reserved
> > 31189 pages shared
> > 59735 pages non-shared
> > SLUB: Unable to allocate memory on node -1 (gfp=0x20)
> > cache: kmalloc-128, object size: 128, buffer size: 128, default order: 0, min order: 0
> > node 0: slabs: 92, objs: 47104, free: 0

