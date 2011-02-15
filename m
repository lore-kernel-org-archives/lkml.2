Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754627Ab1BOOmh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 09:42:37 -0500
Received: from smtp1-g21.free.fr ([212.27.42.1]:58708 "EHLO smtp1-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751201Ab1BOOmd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 09:42:33 -0500
Message-ID: <4D5A90D0.9040403@free.fr>
Date: Tue, 15 Feb 2011 15:42:24 +0100
From: Daniel Lezcano <daniel.lezcano@free.fr>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: WARNING: at kernel/lockdep.c:2323 trace_hardirqs_on_caller+0xb9/0x16c()
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,

I am running a 2.6.38-rc4-next-20110215+ kernel on qemu x86_64 and the 
following traces appear in the console:

Feb 15 15:00:24 lucid kernel: ------------[ cut here ]------------
Feb 15 15:00:24 lucid kernel: WARNING: at kernel/lockdep.c:2323 
trace_hardirqs_on_caller+0xb9/0x16c()
Feb 15 15:00:24 lucid kernel: Hardware name: Bochs
Feb 15 15:00:24 lucid kernel: Pid: 1477, comm: mountall Not tainted 
2.6.38-rc4-next-20110215+ #74
Feb 15 15:00:24 lucid kernel: Call Trace:
Feb 15 15:00:24 lucid kernel: <IRQ>  [<ffffffff8102b8a5>] ? 
warn_slowpath_common+0x7b/0x93
Feb 15 15:00:24 lucid kernel: [<ffffffff8146c097>] ? 
_raw_spin_unlock_irq+0x2b/0x30
Feb 15 15:00:24 lucid kernel: [<ffffffff8102b8d2>] ? 
warn_slowpath_null+0x15/0x17
Feb 15 15:00:24 lucid kernel: [<ffffffff8104f796>] ? 
trace_hardirqs_on_caller+0xb9/0x16c
Feb 15 15:00:24 lucid kernel: [<ffffffff8104f856>] ? 
trace_hardirqs_on+0xd/0xf
Feb 15 15:00:24 lucid kernel: [<ffffffff8146c097>] ? 
_raw_spin_unlock_irq+0x2b/0x30
Feb 15 15:00:24 lucid kernel: [<ffffffff812e167e>] ? 
do_ide_request+0x32/0x590
Feb 15 15:00:24 lucid kernel: [<ffffffff8124a708>] ? elv_insert+0x4f/0x144
Feb 15 15:00:24 lucid kernel: [<ffffffff8124c79f>] ? 
__blk_run_queue+0x44/0x6d
Feb 15 15:00:24 lucid kernel: [<ffffffff8124eb04>] ? 
flush_data_end_io+0x41/0x4d
Feb 15 15:00:24 lucid kernel: [<ffffffff8124bfad>] ? 
blk_finish_request+0x1c4/0x1f9
Feb 15 15:00:24 lucid kernel: [<ffffffff8124c285>] ? 
blk_end_bidi_request+0x3d/0x58
Feb 15 15:00:24 lucid kernel: [<ffffffff8124c2d2>] ? blk_end_request+0xb/0xd
Feb 15 15:00:24 lucid kernel: [<ffffffff812e1588>] ? ide_end_rq+0x44/0x4f
Feb 15 15:00:24 lucid kernel: [<ffffffff812e15c5>] ? 
ide_complete_rq+0x32/0x46
Feb 15 15:00:24 lucid kernel: [<ffffffff812e992d>] ? ide_dma_intr+0x92/0xd5
Feb 15 15:00:24 lucid kernel: [<ffffffff812e119d>] ? ide_intr+0x173/0x223
Feb 15 15:00:24 lucid kernel: [<ffffffff812e989b>] ? ide_dma_intr+0x0/0xd5
Feb 15 15:00:24 lucid kernel: [<ffffffff8106efd8>] ? 
handle_IRQ_event+0x20/0xa6
Feb 15 15:00:24 lucid kernel: [<ffffffff81070ba0>] ? 
handle_edge_irq+0x101/0x14d
Feb 15 15:00:24 lucid kernel: [<ffffffff81004b7c>] ? handle_irq+0x82/0x8a
Feb 15 15:00:24 lucid kernel: [<ffffffff81004556>] ? do_IRQ+0x45/0xa5
Feb 15 15:00:24 lucid kernel: [<ffffffff8146c353>] ? ret_from_intr+0x0/0x12
Feb 15 15:00:24 lucid kernel: [<ffffffff810306d3>] ? __do_softirq+0x56/0x12b
Feb 15 15:00:24 lucid kernel: [<ffffffff810035aa>] ? call_softirq+0x1a/0x24
Feb 15 15:00:24 lucid kernel: [<ffffffff81004ab2>] ? do_softirq+0x36/0x7e
Feb 15 15:00:24 lucid kernel: [<ffffffff81030527>] ? irq_exit+0x42/0x44
Feb 15 15:00:24 lucid kernel: [<ffffffff810163e8>] ? 
smp_apic_timer_interrupt+0x79/0x86
Feb 15 15:00:24 lucid kernel: [<ffffffff810031d3>] ? 
apic_timer_interrupt+0x13/0x20
Feb 15 15:00:24 lucid kernel: <EOI>  [<ffffffff810a26a0>] ? 
kmem_cache_free+0xbc/0xc5
Feb 15 15:00:24 lucid kernel: [<ffffffff810995d9>] ? anon_vma_free+0x13/0x15
Feb 15 15:00:24 lucid kernel: [<ffffffff81099646>] ? 
unlink_anon_vmas+0x6b/0xa5
Feb 15 15:00:24 lucid kernel: [<ffffffff8109324b>] ? free_pgtables+0x50/0xa5
Feb 15 15:00:24 lucid kernel: [<ffffffff81094ebe>] ? exit_mmap+0xb1/0x101
Feb 15 15:00:24 lucid kernel: [<ffffffff810298d4>] ? mmput+0x3e/0x99
Feb 15 15:00:24 lucid kernel: [<ffffffff810b17a7>] ? 
flush_old_exec+0x4d6/0x5b0
Feb 15 15:00:24 lucid kernel: [<ffffffff810e7aeb>] ? 
load_elf_binary+0x29c/0x1651
Feb 15 15:00:24 lucid kernel: [<ffffffff810b1159>] ? 
search_binary_handler+0x14b/0x1c6
Feb 15 15:00:24 lucid kernel: [<ffffffff810b10b4>] ? 
search_binary_handler+0xa6/0x1c6
Feb 15 15:00:24 lucid kernel: [<ffffffff810e784f>] ? 
load_elf_binary+0x0/0x1651
Feb 15 15:00:24 lucid kernel: [<ffffffff810b2a02>] ? do_execve+0x163/0x259
Feb 15 15:00:24 lucid kernel: [<ffffffff81009071>] ? sys_execve+0x3e/0x55
Feb 15 15:00:24 lucid kernel: [<ffffffff81002c9b>] ? stub_execve+0x6b/0xc0
Feb 15 15:00:24 lucid kernel: ---[ end trace d9437fca559c1042 ]---


Then this message is followed by:

Feb 15 15:00:24 lucid kernel: INFO: lockdep is turned off.
Feb 15 15:00:24 lucid kernel: Pid: 1477, comm: mountall Tainted: 
G        W   2.6.38-rc4-next-20110215+ #74
Feb 15 15:00:24 lucid kernel: Call Trace:
Feb 15 15:00:24 lucid kernel: <IRQ>  [<ffffffff81026646>] ? 
__might_sleep+0xec/0xf1
Feb 15 15:00:24 lucid kernel: [<ffffffff812e1691>] ? 
do_ide_request+0x45/0x590
Feb 15 15:00:24 lucid kernel: [<ffffffff8124a708>] ? elv_insert+0x4f/0x144
Feb 15 15:00:24 lucid kernel: [<ffffffff8124c79f>] ? 
__blk_run_queue+0x44/0x6d
Feb 15 15:00:24 lucid kernel: [<ffffffff8124eb04>] ? 
flush_data_end_io+0x41/0x4d
Feb 15 15:00:24 lucid kernel: [<ffffffff8124bfad>] ? 
blk_finish_request+0x1c4/0x1f9
Feb 15 15:00:24 lucid kernel: [<ffffffff8124c285>] ? 
blk_end_bidi_request+0x3d/0x58
Feb 15 15:00:24 lucid kernel: [<ffffffff8124c2d2>] ? blk_end_request+0xb/0xd
Feb 15 15:00:24 lucid kernel: [<ffffffff812e1588>] ? ide_end_rq+0x44/0x4f
Feb 15 15:00:24 lucid kernel: [<ffffffff812e15c5>] ? 
ide_complete_rq+0x32/0x46
Feb 15 15:00:24 lucid kernel: [<ffffffff812e992d>] ? ide_dma_intr+0x92/0xd5
Feb 15 15:00:24 lucid kernel: [<ffffffff812e119d>] ? ide_intr+0x173/0x223
Feb 15 15:00:24 lucid kernel: [<ffffffff812e989b>] ? ide_dma_intr+0x0/0xd5
Feb 15 15:00:24 lucid kernel: [<ffffffff8106efd8>] ? 
handle_IRQ_event+0x20/0xa6
Feb 15 15:00:24 lucid kernel: [<ffffffff81070ba0>] ? 
handle_edge_irq+0x101/0x14d
Feb 15 15:00:24 lucid kernel: [<ffffffff81004b7c>] ? handle_irq+0x82/0x8a
Feb 15 15:00:24 lucid kernel: [<ffffffff81004556>] ? do_IRQ+0x45/0xa5
Feb 15 15:00:24 lucid kernel: [<ffffffff8146c353>] ? ret_from_intr+0x0/0x12
Feb 15 15:00:24 lucid kernel: [<ffffffff810306d3>] ? __do_softirq+0x56/0x12b
Feb 15 15:00:24 lucid kernel: [<ffffffff810035aa>] ? call_softirq+0x1a/0x24
Feb 15 15:00:24 lucid kernel: [<ffffffff81004ab2>] ? do_softirq+0x36/0x7e
Feb 15 15:00:24 lucid kernel: [<ffffffff81030527>] ? irq_exit+0x42/0x44
Feb 15 15:00:24 lucid kernel: [<ffffffff810163e8>] ? 
smp_apic_timer_interrupt+0x79/0x86
Feb 15 15:00:24 lucid kernel: [<ffffffff810031d3>] ? 
apic_timer_interrupt+0x13/0x20
Feb 15 15:00:24 lucid kernel: <EOI>  [<ffffffff810a26a0>] ? 
kmem_cache_free+0xbc/0xc5
Feb 15 15:00:24 lucid kernel: [<ffffffff810995d9>] ? anon_vma_free+0x13/0x15
Feb 15 15:00:24 lucid kernel: [<ffffffff81099646>] ? 
unlink_anon_vmas+0x6b/0xa5
Feb 15 15:00:24 lucid kernel: [<ffffffff8109324b>] ? free_pgtables+0x50/0xa5
Feb 15 15:00:24 lucid kernel: [<ffffffff81094ebe>] ? exit_mmap+0xb1/0x101
Feb 15 15:00:24 lucid kernel: [<ffffffff810298d4>] ? mmput+0x3e/0x99
Feb 15 15:00:24 lucid kernel: [<ffffffff810b17a7>] ? 
flush_old_exec+0x4d6/0x5b0
Feb 15 15:00:24 lucid kernel: [<ffffffff810e7aeb>] ? 
load_elf_binary+0x29c/0x1651
Feb 15 15:00:24 lucid kernel: [<ffffffff810b1159>] ? 
search_binary_handler+0x14b/0x1c6
Feb 15 15:00:24 lucid kernel: [<ffffffff810b10b4>] ? 
search_binary_handler+0xa6/0x1c6
Feb 15 15:00:24 lucid kernel: [<ffffffff810e784f>] ? 
load_elf_binary+0x0/0x1651
Feb 15 15:00:24 lucid kernel: [<ffffffff810b2a02>] ? do_execve+0x163/0x259
Feb 15 15:00:24 lucid kernel: [<ffffffff81009071>] ? sys_execve+0x3e/0x55
Feb 15 15:00:24 lucid kernel: [<ffffffff81002c9b>] ? stub_execve+0x6b/0xc0
Feb 15 15:00:24 lucid kernel: INFO: lockdep is turned off.
Feb 15 15:00:24 lucid kernel: Pid: 1478, comm: udevd Tainted: G        
W   2.6.38-rc4-next-20110215+ #74
Feb 15 15:00:24 lucid kernel: Call Trace:
Feb 15 15:00:24 lucid kernel: <IRQ>  [<ffffffff81026646>] ? 
__might_sleep+0xec/0xf1
Feb 15 15:00:24 lucid kernel: [<ffffffff812e1691>] ? 
do_ide_request+0x45/0x590
Feb 15 15:00:24 lucid kernel: [<ffffffff8104e6bc>] ? 
trace_hardirqs_off+0xd/0xf
Feb 15 15:00:24 lucid kernel: [<ffffffff8124a708>] ? elv_insert+0x4f/0x144
Feb 15 15:00:24 lucid kernel: [<ffffffff8124c79f>] ? 
__blk_run_queue+0x44/0x6d
Feb 15 15:00:24 lucid kernel: [<ffffffff8124eb04>] ? 
flush_data_end_io+0x41/0x4d
Feb 15 15:00:24 lucid kernel: [<ffffffff8124bfad>] ? 
blk_finish_request+0x1c4/0x1f9
Feb 15 15:00:24 lucid kernel: [<ffffffff8124c285>] ? 
blk_end_bidi_request+0x3d/0x58
Feb 15 15:00:24 lucid kernel: [<ffffffff8124c2d2>] ? blk_end_request+0xb/0xd
Feb 15 15:00:24 lucid kernel: [<ffffffff812e1588>] ? ide_end_rq+0x44/0x4f
Feb 15 15:00:24 lucid kernel: [<ffffffff812e15c5>] ? 
ide_complete_rq+0x32/0x46
Feb 15 15:00:24 lucid kernel: [<ffffffff812e992d>] ? ide_dma_intr+0x92/0xd5
Feb 15 15:00:24 lucid kernel: [<ffffffff812e119d>] ? ide_intr+0x173/0x223
Feb 15 15:00:24 lucid kernel: [<ffffffff812e989b>] ? ide_dma_intr+0x0/0xd5
Feb 15 15:00:24 lucid kernel: [<ffffffff8106efd8>] ? 
handle_IRQ_event+0x20/0xa6
Feb 15 15:00:24 lucid kernel: [<ffffffff81070ba0>] ? 
handle_edge_irq+0x101/0x14d
Feb 15 15:00:24 lucid kernel: [<ffffffff81004b7c>] ? handle_irq+0x82/0x8a
Feb 15 15:00:24 lucid kernel: [<ffffffff81004556>] ? do_IRQ+0x45/0xa5
Feb 15 15:00:24 lucid kernel: [<ffffffff8146c353>] ? ret_from_intr+0x0/0x12
Feb 15 15:00:24 lucid kernel: <EOI>  [<ffffffff8101e30b>] ? 
kernel_map_pages+0x139/0x14c
Feb 15 15:00:24 lucid kernel: [<ffffffff81080bbd>] ? 
get_page_from_freelist+0x3ad/0x4fc
Feb 15 15:00:24 lucid kernel: [<ffffffff81080ebc>] ? 
__alloc_pages_nodemask+0x1b0/0x717
Feb 15 15:00:24 lucid kernel: [<ffffffff8108fb59>] ? do_wp_page+0x32c/0x6ed
Feb 15 15:00:24 lucid kernel: [<ffffffff8109050a>] ? 
handle_pte_fault+0x5f0/0x635
Feb 15 15:00:24 lucid kernel: [<ffffffff81020167>] ? pte_alloc_one+0x1a/0x3f
Feb 15 15:00:24 lucid kernel: [<ffffffff81091434>] ? __pte_alloc+0x19/0xb6
Feb 15 15:00:24 lucid kernel: [<ffffffff810915ba>] ? 
handle_mm_fault+0xe9/0x131
Feb 15 15:00:24 lucid kernel: [<ffffffff8101d0c1>] ? 
do_page_fault+0x366/0x38b
Feb 15 15:00:24 lucid kernel: [<ffffffff8146c103>] ? 
_raw_spin_unlock+0x26/0x2a
Feb 15 15:00:24 lucid kernel: [<ffffffff810bda1c>] ? dput+0xde/0x162
Feb 15 15:00:24 lucid kernel: [<ffffffff810c4daa>] ? mntput+0x21/0x23
Feb 15 15:00:24 lucid kernel: [<ffffffff810b4a7b>] ? path_put+0x1d/0x21
Feb 15 15:00:24 lucid kernel: [<ffffffff810cd885>] ? do_utimes+0xbd/0xd2
Feb 15 15:00:24 lucid kernel: [<ffffffff8146b92d>] ? 
trace_hardirqs_off_thunk+0x3a/0x3c
Feb 15 15:00:24 lucid kernel: [<ffffffff8146c5df>] ? page_fault+0x1f/0x30
Feb 15 15:00:24 lucid kernel: INFO: lockdep is turned off.
Feb 15 15:00:24 lucid kernel: Pid: 1, comm: init Tainted: G        W   
2.6.38-rc4-next-20110215+ #74
Feb 15 15:00:24 lucid kernel: Call Trace:
Feb 15 15:00:24 lucid kernel: <IRQ>  [<ffffffff81026646>] ? 
__might_sleep+0xec/0xf1
Feb 15 15:00:24 lucid kernel: [<ffffffff812e1691>] ? 
do_ide_request+0x45/0x590
Feb 15 15:00:24 lucid kernel: [<ffffffff8104e6bc>] ? 
trace_hardirqs_off+0xd/0xf
Feb 15 15:00:24 lucid kernel: [<ffffffff8124a708>] ? elv_insert+0x4f/0x144
Feb 15 15:00:24 lucid kernel: [<ffffffff8124c79f>] ? 
__blk_run_queue+0x44/0x6d
Feb 15 15:00:24 lucid kernel: [<ffffffff8124eb04>] ? 
flush_data_end_io+0x41/0x4d
Feb 15 15:00:24 lucid kernel: [<ffffffff8124bfad>] ? 
blk_finish_request+0x1c4/0x1f9
Feb 15 15:00:24 lucid kernel: [<ffffffff8124c285>] ? 
blk_end_bidi_request+0x3d/0x58
Feb 15 15:00:24 lucid kernel: [<ffffffff8124c2d2>] ? blk_end_request+0xb/0xd
Feb 15 15:00:24 lucid kernel: [<ffffffff812e1588>] ? ide_end_rq+0x44/0x4f
Feb 15 15:00:24 lucid kernel: [<ffffffff812e15c5>] ? 
ide_complete_rq+0x32/0x46
Feb 15 15:00:24 lucid kernel: [<ffffffff812e992d>] ? ide_dma_intr+0x92/0xd5
Feb 15 15:00:24 lucid kernel: [<ffffffff812e119d>] ? ide_intr+0x173/0x223
Feb 15 15:00:24 lucid kernel: [<ffffffff812e989b>] ? ide_dma_intr+0x0/0xd5
Feb 15 15:00:24 lucid kernel: [<ffffffff8106efd8>] ? 
handle_IRQ_event+0x20/0xa6
Feb 15 15:00:24 lucid kernel: [<ffffffff81070ba0>] ? 
handle_edge_irq+0x101/0x14d
Feb 15 15:00:24 lucid kernel: [<ffffffff81004b7c>] ? handle_irq+0x82/0x8a
Feb 15 15:00:24 lucid kernel: [<ffffffff81004556>] ? do_IRQ+0x45/0xa5
Feb 15 15:00:24 lucid kernel: [<ffffffff8146c353>] ? ret_from_intr+0x0/0x12
Feb 15 15:00:24 lucid kernel: <EOI>  [<ffffffff810292a0>] ? T.991+0x7a/0xb6
Feb 15 15:00:24 lucid kernel: [<ffffffff8146c097>] ? 
_raw_spin_unlock_irq+0x2b/0x30
Feb 15 15:00:24 lucid kernel: [<ffffffff8146c099>] ? 
_raw_spin_unlock_irq+0x2d/0x30
Feb 15 15:00:24 lucid kernel: [<ffffffff810292a0>] ? T.991+0x7a/0xb6
Feb 15 15:00:24 lucid kernel: [<ffffffff81029262>] ? T.991+0x3c/0xb6
Feb 15 15:00:24 lucid kernel: [<ffffffff81469d8f>] ? schedule+0x490/0x4d6
Feb 15 15:00:24 lucid kernel: [<ffffffff8101d0a7>] ? 
do_page_fault+0x34c/0x38b
Feb 15 15:00:24 lucid kernel: [<ffffffff8108ec48>] ? might_fault+0x4c/0x9c
Feb 15 15:00:24 lucid kernel: [<ffffffff8146b964>] ? 
lockdep_sys_exit_thunk+0x35/0x67
Feb 15 15:00:24 lucid kernel: [<ffffffff8146b8ee>] ? 
trace_hardirqs_on_thunk+0x3a/0x3f
Feb 15 15:00:24 lucid kernel: [<ffffffff8146c442>] ? 
retint_careful+0x12/0x2d
Feb 15 15:00:24 lucid kernel: INFO: lockdep is turned off.
Feb 15 15:00:24 lucid kernel: Pid: 1439, comm: udevd Tainted: G        
W   2.6.38-rc4-next-20110215+ #74
Feb 15 15:00:24 lucid kernel: Call Trace:
Feb 15 15:00:24 lucid kernel: <IRQ>  [<ffffffff81026646>] ? 
__might_sleep+0xec/0xf1
Feb 15 15:00:24 lucid kernel: [<ffffffff812e1691>] ? 
do_ide_request+0x45/0x590
Feb 15 15:00:24 lucid kernel: [<ffffffff8104e6bc>] ? 
trace_hardirqs_off+0xd/0xf
Feb 15 15:00:24 lucid kernel: [<ffffffff8124a708>] ? elv_insert+0x4f/0x144
Feb 15 15:00:24 lucid kernel: [<ffffffff8124c79f>] ? 
__blk_run_queue+0x44/0x6d
Feb 15 15:00:24 lucid kernel: [<ffffffff8124eb04>] ? 
flush_data_end_io+0x41/0x4d
Feb 15 15:00:24 lucid kernel: [<ffffffff8124bfad>] ? 
blk_finish_request+0x1c4/0x1f9
Feb 15 15:00:24 lucid kernel: [<ffffffff8124c285>] ? 
blk_end_bidi_request+0x3d/0x58
Feb 15 15:00:24 lucid kernel: [<ffffffff8124c2d2>] ? blk_end_request+0xb/0xd
Feb 15 15:00:24 lucid kernel: [<ffffffff812e1588>] ? ide_end_rq+0x44/0x4f
Feb 15 15:00:24 lucid kernel: [<ffffffff812e15c5>] ? 
ide_complete_rq+0x32/0x46
Feb 15 15:00:24 lucid kernel: [<ffffffff812e992d>] ? ide_dma_intr+0x92/0xd5
Feb 15 15:00:24 lucid kernel: [<ffffffff812e119d>] ? ide_intr+0x173/0x223
Feb 15 15:00:24 lucid kernel: [<ffffffff812e989b>] ? ide_dma_intr+0x0/0xd5
Feb 15 15:00:24 lucid kernel: [<ffffffff8106efd8>] ? 
handle_IRQ_event+0x20/0xa6
Feb 15 15:00:24 lucid kernel: [<ffffffff81070ba0>] ? 
handle_edge_irq+0x101/0x14d
Feb 15 15:00:24 lucid kernel: [<ffffffff81004b7c>] ? handle_irq+0x82/0x8a
Feb 15 15:00:24 lucid kernel: [<ffffffff81004556>] ? do_IRQ+0x45/0xa5
Feb 15 15:00:24 lucid kernel: [<ffffffff8146c353>] ? ret_from_intr+0x0/0x12
Feb 15 15:00:24 lucid kernel: <EOI>  [<ffffffff810bda1c>] ? dput+0xde/0x162
Feb 15 15:00:24 lucid kernel: [<ffffffff810b7973>] ? 
link_path_walk+0x9b9/0xa30
Feb 15 15:00:24 lucid kernel: [<ffffffff810b7973>] ? 
link_path_walk+0x9b9/0xa30
Feb 15 15:00:24 lucid kernel: [<ffffffff810b6a9d>] ? 
path_init_rcu+0x37/0x1f9
Feb 15 15:00:24 lucid kernel: [<ffffffff810b7c41>] ? 
do_path_lookup+0x4a/0x107
Feb 15 15:00:24 lucid kernel: [<ffffffff810b871e>] ? user_path_at+0x51/0x8e
Feb 15 15:00:24 lucid kernel: [<ffffffff8104f856>] ? 
trace_hardirqs_on+0xd/0xf
Feb 15 15:00:24 lucid kernel: [<ffffffff810bd97a>] ? dput+0x3c/0x162
Feb 15 15:00:24 lucid kernel: [<ffffffff810afeef>] ? vfs_fstatat+0x3c/0x67
Feb 15 15:00:24 lucid kernel: [<ffffffff8146c103>] ? 
_raw_spin_unlock+0x26/0x2a
Feb 15 15:00:24 lucid kernel: [<ffffffff810afff3>] ? vfs_stat+0x16/0x18
Feb 15 15:00:24 lucid kernel: [<ffffffff810b000f>] ? sys_newstat+0x1a/0x38
Feb 15 15:00:24 lucid kernel: [<ffffffff810b4a7b>] ? path_put+0x1d/0x21
Feb 15 15:00:24 lucid kernel: [<ffffffff8146b8ee>] ? 
trace_hardirqs_on_thunk+0x3a/0x3f
Feb 15 15:00:24 lucid kernel: [<ffffffff810027f8>] ? 
system_call_fastpath+0x16/0x1b
Feb 15 15:00:24 lucid kernel: IPv4 FIB: Using LC-trie version 0.409
Feb 15 15:00:24 lucid kernel: INFO: lockdep is turned off.
Feb 15 15:00:24 lucid kernel: Pid: 1336, comm: plymouthd Tainted: 
G        W   2.6.38-rc4-next-20110215+ #74
Feb 15 15:00:24 lucid kernel: Call Trace:
Feb 15 15:00:24 lucid kernel: <IRQ>  [<ffffffff81026646>] ? 
__might_sleep+0xec/0xf1
Feb 15 15:00:24 lucid kernel: [<ffffffff812e1691>] ? 
do_ide_request+0x45/0x590
Feb 15 15:00:24 lucid kernel: [<ffffffff8104e6bc>] ? 
trace_hardirqs_off+0xd/0xf
Feb 15 15:00:24 lucid kernel: [<ffffffff8124a708>] ? elv_insert+0x4f/0x144
Feb 15 15:00:24 lucid kernel: [<ffffffff8124c79f>] ? 
__blk_run_queue+0x44/0x6d
Feb 15 15:00:24 lucid kernel: [<ffffffff8124eb04>] ? 
flush_data_end_io+0x41/0x4d
Feb 15 15:00:24 lucid kernel: [<ffffffff8124bfad>] ? 
blk_finish_request+0x1c4/0x1f9
Feb 15 15:00:24 lucid kernel: [<ffffffff8124c285>] ? 
blk_end_bidi_request+0x3d/0x58
Feb 15 15:00:24 lucid kernel: [<ffffffff8124c2d2>] ? blk_end_request+0xb/0xd
Feb 15 15:00:24 lucid kernel: [<ffffffff812e1588>] ? ide_end_rq+0x44/0x4f
Feb 15 15:00:24 lucid kernel: [<ffffffff812e15c5>] ? 
ide_complete_rq+0x32/0x46
Feb 15 15:00:24 lucid kernel: [<ffffffff812e992d>] ? ide_dma_intr+0x92/0xd5
Feb 15 15:00:24 lucid kernel: [<ffffffff812e119d>] ? ide_intr+0x173/0x223
Feb 15 15:00:24 lucid kernel: [<ffffffff812e989b>] ? ide_dma_intr+0x0/0xd5
Feb 15 15:00:24 lucid kernel: [<ffffffff8106efd8>] ? 
handle_IRQ_event+0x20/0xa6
Feb 15 15:00:24 lucid kernel: [<ffffffff81070ba0>] ? 
handle_edge_irq+0x101/0x14d
Feb 15 15:00:24 lucid kernel: [<ffffffff81004b7c>] ? handle_irq+0x82/0x8a
Feb 15 15:00:24 lucid kernel: [<ffffffff81004556>] ? do_IRQ+0x45/0xa5
Feb 15 15:00:24 lucid kernel: [<ffffffff8146c353>] ? ret_from_intr+0x0/0x12
Feb 15 15:00:24 lucid kernel: [<ffffffff810306d0>] ? __do_softirq+0x53/0x12b
Feb 15 15:00:24 lucid kernel: [<ffffffff810306d3>] ? __do_softirq+0x56/0x12b
Feb 15 15:00:24 lucid kernel: [<ffffffff810035aa>] ? call_softirq+0x1a/0x24
Feb 15 15:00:24 lucid kernel: [<ffffffff81004ab2>] ? do_softirq+0x36/0x7e
Feb 15 15:00:24 lucid kernel: [<ffffffff81030527>] ? irq_exit+0x42/0x44
Feb 15 15:00:24 lucid kernel: [<ffffffff810163e8>] ? 
smp_apic_timer_interrupt+0x79/0x86
Feb 15 15:00:24 lucid kernel: [<ffffffff810031d3>] ? 
apic_timer_interrupt+0x13/0x20
Feb 15 15:00:24 lucid kernel: <EOI>  [<ffffffff81002828>] ? 
sysret_check+0x26/0x60

etc ...

Did anyone experienced the same problem ? Is there a fix for this ?

Thanks in advance

   -- Daniel
