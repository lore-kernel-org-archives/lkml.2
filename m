Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757763Ab0KKHDl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 02:03:41 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40914 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757722Ab0KKHDk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Nov 2010 02:03:40 -0500
Date: Wed, 10 Nov 2010 23:00:16 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: subrata@linux.vnet.ibm.com
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        DIVYA PRAKASH <dipraksh@linux.vnet.ibm.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Linuxppc-dev <Linuxppc-dev@ozlabs.org>
Subject: Re: [Call Trace: 2.6.37-rc1-git7 & 2.6.37-rc1-git8, Powerpc] LTP
 msgctl11 test case
Message-Id: <20101110230016.40e4875e.akpm@linux-foundation.org>
In-Reply-To: <1289457219.5622.15.camel@subratamodak.linux.ibm.com>
References: <1289457219.5622.15.camel@subratamodak.linux.ibm.com>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 11 Nov 2010 12:03:39 +0530 Subrata Modak <subrata@linux.vnet.ibm.com> wrote:

> Hi Peter/Ingo,
> 
> LTP__ msgctl11 test case creates Call trace and Exception for kernels
> 2.6.37-rc1-git7 & 2.6.37-rc1-git8. Please see the dmesg below:
> 
> ================================================
> msgctl11: page allocation failure. order:0, mode:0x20
> Call Trace:
> [c0000000fffcef30] [c000000000014c74] .show_stack+0x74/0x1c0 (unreliable)
> [c0000000fffcefe0] [c00000000015e938] .__alloc_pages_nodemask+0x6d8/0x950
> [c0000000fffcf160] [c0000000001a0c60] .alloc_pages_current+0xa0/0x160
> [c0000000fffcf200] [c0000000001abfd8] .new_slab+0x358/0x370
> [c0000000fffcf2b0] [c0000000001ac1cc] .__slab_alloc+0x1dc/0x500
> [c0000000fffcf390] [c0000000001ad808] .kmem_cache_alloc+0x1a8/0x1b0
> [c0000000fffcf440] [c0000000004eec88] .scsi_pool_alloc_command+0x58/0xa0
> [c0000000fffcf4d0] [c0000000004eed60] .scsi_host_alloc_command+0x30/0xb0
> [c0000000fffcf560] [c0000000004eee00] .__scsi_get_command+0x20/0xd0
> [c0000000fffcf5f0] [c0000000004ef158] .scsi_get_command+0x58/0xf0
> [c0000000fffcf690] [c0000000004f7948] .scsi_setup_fs_cmnd+0x108/0x120
> [c0000000fffcf720] [d000000001484ad8] .sd_prep_fn+0x2b8/0xc70 [sd_mod]
> [c0000000fffcf800] [c0000000003ea92c] .blk_peek_request+0x14c/0x310
> [c0000000fffcf8b0] [c0000000004f6b14] .scsi_request_fn+0x94/0x560
> [c0000000fffcf980] [c0000000003eba00] .__blk_run_queue+0x90/0x1b0
> [c0000000fffcfa00] [c0000000003ebc20] .blk_run_queue+0x30/0x60
> [c0000000fffcfa90] [c0000000004f5d84] .scsi_run_queue+0x104/0x3c0
> [c0000000fffcfb60] [c0000000004f7228] .scsi_next_command+0x48/0x70
> [c0000000fffcfbf0] [c0000000004f8280] .scsi_io_completion+0x3e0/0x580
> [c0000000fffcfcd0] [c0000000004ee0a8] .scsi_finish_command+0x128/0x180
> [c0000000fffcfd70] [c0000000004f8548] .scsi_softirq_done+0x118/0x1e0
> [c0000000fffcfe10] [c0000000003f2410] .blk_done_softirq+0xb0/0xe0
> [c0000000fffcfea0] [c0000000000943c8] .__do_softirq+0x118/0x290
> [c0000000fffcff90] [c000000000031f58] .call_do_softirq+0x14/0x24
> [c0000000a0992a20] [c00000000000f554] .do_softirq+0xf4/0x120
> [c0000000a0992ac0] [c0000000000941d4] .irq_exit+0xb4/0xc0
> [c0000000a0992b40] [c00000000000f7e0] .do_IRQ+0x160/0x2c0
> [c0000000a0992c00] [c000000000004898] hardware_interrupt_entry+0x18/0x80
> --- Exception: 501 at .do_raw_spin_unlock+0x80/0xe0
>     LR = ._raw_spin_unlock+0x30/0x50
> [c0000000a0992f70] [c00000000018943c] .__page_check_address+0x16c/0x1a0
> [c0000000a0993010] [c00000000018a5b4] .page_referenced_one+0x54/0x200
> [c0000000a09930d0] [c00000000018ab4c] .page_referenced+0x3ec/0x490
> [c0000000a0993200] [c000000000168bbc] .shrink_page_list+0x2bc/0x6d0
> [c0000000a0993350] [c00000000016942c] .shrink_inactive_list+0x15c/0x580
> [c0000000a0993460] [c000000000169f10] .shrink_zone+0x2e0/0x4b0
> [c0000000a0993580] [c00000000016b3c0] .do_try_to_free_pages+0x110/0x510
> [c0000000a0993670] [c00000000016bb3c] .try_to_free_pages+0xbc/0x1a0
> [c0000000a0993780] [c00000000015e7a0] .__alloc_pages_nodemask+0x540/0x950
> [c0000000a0993900] [c0000000001a0db8] .alloc_page_vma+0x98/0x1d0
> [c0000000a09939a0] [c00000000017c7f4] .do_wp_page+0x144/0xb60
> [c0000000a0993a90] [c00000000017eef0] .handle_mm_fault+0x670/0xb50
> [c0000000a0993b80] [c0000000006feea4] .do_page_fault+0x344/0x780
> [c0000000a0993e30] [c00000000000522c] handle_page_fault+0x20/0x74

That trace is impressively hard to understand.  Who called
do_raw_spin_unlock?

