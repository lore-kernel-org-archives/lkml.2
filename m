Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758472Ab0FJBnH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jun 2010 21:43:07 -0400
Received: from mga11.intel.com ([192.55.52.93]:53621 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755921Ab0FJBnD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jun 2010 21:43:03 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.53,395,1272870000"; 
   d="scan'208";a="806464023"
Subject: Re: [PATCH 00/28] mm: preemptibility -v3
From: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Andrea Arcangeli <aarcange@redhat.com>, Avi Kivity <avi@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>, Rik van Riel <riel@redhat.com>,
       Ingo Molnar <mingo@elte.hu>, akpm@linux-foundation.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       David Miller <davem@davemloft.net>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>, Mel Gorman <mel@csn.ul.ie>,
       Nick Piggin <npiggin@suse.de>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
In-Reply-To: <20100607110654.606530953@chello.nl>
References: <20100607110654.606530953@chello.nl>
Content-Type: text/plain; charset="ISO-8859-1"
Date: Thu, 10 Jun 2010 09:45:11 +0800
Message-Id: <1276134311.2096.438.camel@ymzhang.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.0 (2.28.0-2.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-06-07 at 13:06 +0200, Peter Zijlstra wrote:
> This patch-set makes part of the mm a lot more preemptible. It converts
> i_mmap_lock and anon_vma->lock to mutexes and makes mmu_gather fully
> preemptible.
I applied it against 2.6.35-rc2 on x86_64 machine, but kernel booting panic.

Pid: 1, comm: init Not tainted 2.6.35-rc2-petermm #1 X7DW3/X7DW3
RIP: 0010:[<ffffffff8160e055>]  [<ffffffff8160e055>] mutex_unlock
+0x0/0x13
RSP: 0018:ffff88022fc61a78  EFLAGS: 00010206
RAX: 0000000000000000 RBX: ffff88022ebd5780 RCX: 0000000000000020
RDX: 0000000000000000 RSI: 0000000000100173 RDI: 8000000000000025
RBP: 0000000000000020 R08: 00007fffffffe000 R09: 0000000000000001
R10: 0000000000000002 R11: ffffffff8128c275 R12: ffff88022e76b000
R13: 0000000000021000 R14: ffff88022fc68000 R15: 00007fff4c0e6000
FS:  0000000000000000(0000) GS:ffff8800021c0000(0000)
knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000000000 CR3: 000000022e76c000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process init (pid: 1, threadinfo ffff88022fc60000, task
ffff88022fc58000)
Stack:
 ffffffff810aabac 00000000ffffefff 0000000000000000 00007fff4c107000
<0> ffff88022e76b000 00007fffffffe000 00007ffffffff000 00007fff4c106000
<0> ffffffff810c5e5a ffff88022ebd5780 ffff88022ebd5780 ffff88022ebd5780
Call Trace:
 [<ffffffff810aabac>] ? expand_downwards+0x149/0x15a
 [<ffffffff810c5e5a>] ? setup_arg_pages+0x333/0x361
 [<ffffffff810c8955>] ? inode_permission+0x76/0x95
 [<ffffffff810f8a19>] ? load_elf_binary+0x0/0x16c9
 [<ffffffff810f8e7e>] ? load_elf_binary+0x465/0x16c9
 [<ffffffff810c488a>] ? get_arg_page+0x4b/0xa4
 [<ffffffff810f8a19>] ? load_elf_binary+0x0/0x16c9
 [<ffffffff810c4ce4>] ? search_binary_handler+0xd4/0x26f
 [<ffffffff810f7a1c>] ? load_script+0x0/0x1e4
 [<ffffffff810f7bea>] ? load_script+0x1ce/0x1e4
 [<ffffffff810c488a>] ? get_arg_page+0x4b/0xa4
 [<ffffffff810c4ce4>] ? search_binary_handler+0xd4/0x26f
 [<ffffffff810c6228>] ? do_execve+0x1e5/0x2b6
 [<ffffffff81008d60>] ? sys_execve+0x35/0x53
 [<ffffffff81003648>] ? kernel_execve+0x68/0xd0
 [<ffffffff81000342>] ? init_post+0x5a/0xd4
 [<ffffffff81cdf97d>] ? kernel_init+0x1e5/0x1ec
 [<ffffffff810035d4>] ? kernel_thread_helper+0x4/0x10
 [<ffffffff81cdf798>] ? kernel_init+0x0/0x1ec
 [<ffffffff810035d0>] ? kernel_thread_helper+0x0/0x10
Code: 1c 24 44 89 64 24 08 48 c7 44 24 20 07 fd 04 81 48 89 44 24 28 48
89 44 24 30 e8 26 ff ff ff 48 83 c4 48 5b 41 5c 41 5d 41 5e c3 <48> c7
47 18 00 00 00 00 f0 ff 07 7f 05 e8 01 00 00 00 c3 53 48 
RIP  [<ffffffff8160e055>] mutex_unlock+0x0/0x13
 RSP <ffff88022fc61a78>
---[ end trace dc724d36e0cd4a32 ]---

> 
> The main motivation was making mm_take_all_locks() preemptible, since it
> appears people are nesting hundreds of spinlocks there.
> 
> The side-effects are that can finally make mmu_gather preemptible,
> something which lots of people have wanted to do for a long time.
> 
> It also gets us anon_vma refcounting, which seems to result in a nice
> cleanup of the anon_vma lifetime rules wrt KSM and compaction.
> 
> This patch-set it build and boot-tested on x86_64 (a previous version was
> also tested on Dave's Niagra2 machines, and I suppose s390 did too when
> Martin provided the conversion patch for his arch).
> 
> There are no known architectures left unconverted, although some arch code
> never did see a compiler (superh and um come to mind).
> 
> Can we move this work forwards, or is there anything people would want to
> see done?
> 
> [ The series includes Rik's latest patches to the same area for
> convenience ]
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/


