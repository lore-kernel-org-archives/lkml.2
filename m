Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756287Ab0DFUHE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Apr 2010 16:07:04 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49175 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755842Ab0DFUG5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Apr 2010 16:06:57 -0400
Date: Tue, 6 Apr 2010 13:02:35 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Borislav Petkov <bp@alien8.de>
cc: Andrew Morton <akpm@linux-foundation.org>, Rik van Riel <riel@redhat.com>,
       Minchan Kim <minchan.kim@gmail.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       Nick Piggin <npiggin@suse.de>, Andrea Arcangeli <aarcange@redhat.com>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>, sgunderson@bigfoot.com
Subject: Re: Ugly rmap NULL ptr deref oopsie on hibernate (was Linux
 2.6.34-rc3)
In-Reply-To: <20100406194238.GB20357@a1.tnic>
Message-ID: <alpine.LFD.2.00.1004061243240.3487@i5.linux-foundation.org>
References: <4BBB475A.7070002@redhat.com> <1270568096.1814.145.camel@barrios-desktop> <alpine.LFD.2.00.1004060841460.3487@i5.linux-foundation.org> <1270571019.1814.163.camel@barrios-desktop> <alpine.LFD.2.00.1004060926430.3487@i5.linux-foundation.org>
 <1270572327.1711.3.camel@barrios-desktop> <alpine.LFD.2.00.1004060951030.3487@i5.linux-foundation.org> <4BBB69A9.5090906@redhat.com> <alpine.LFD.2.00.1004061053450.3487@i5.linux-foundation.org> <20100406120315.53ad7390.akpm@linux-foundation.org>
 <20100406194238.GB20357@a1.tnic>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 6 Apr 2010, Borislav Petkov wrote:
> 
> [ 2995.478125] PM: Preallocating image memory... 
> [ 2995.713692] BUG: unable to handle kernel NULL pointer dereference at (null)
> [ 2995.714001] IP: [<ffffffff810c194d>] page_referenced+0xee/0x1dc
> [ 2995.714001] PGD 22d1b8067 PUD 22dd85067 PMD 0 
> [ 2995.714001] Oops: 0000 [#1] PREEMPT SMP 
> [ 2995.714001] last sysfs file: /sys/power/state
> [ 2995.714001] CPU 0 
> [ 2995.714001] Modules linked in: tun powernow_k8 cpufreq_ondemand cpufreq_powersave cpufreq_userspace freq_table cpufreq_conservative binfmt_misc kvm_amd kvm ipv6 vfat fat dm_crypt dm_mod ohci_hcd pcspkr 8250_pnp 8250 k10temp edac_core serial_core
> [ 2995.714001] 
> [ 2995.714001] Pid: 7440, comm: hib.sh Not tainted 2.6.34-rc3-00288-gab195c5 #1 M3A78 PRO/System Product Name
> [ 2995.714001] RIP: 0010:[<ffffffff810c194d>]  [<ffffffff810c194d>] page_referenced+0xee/0x1dc
> [ 2995.714001] RSP: 0018:ffff88022fa038b8  EFLAGS: 00010283
> [ 2995.714001] RAX: ffff88022d747098 RBX: ffffea00078efb70 RCX: 0000000000000000
> [ 2995.714001] RDX: ffff88022fa03cf8 RSI: ffff88022d747070 RDI: ffff88022fb32520
> [ 2995.714001] RBP: ffff88022fa03938 R08: 0000000000000002 R09: 0000000000000000
> [ 2995.714001] R10: ffff88022fa038a8 R11: ffff88022d295d10 R12: 0000000000000000
> [ 2995.714001] R13: ffffffffffffffe0 R14: ffff88022d747058 R15: ffff88022fa03a00
> [ 2995.714001] FS:  00007f4da8b966f0(0000) GS:ffff88000a000000(0000) knlGS:0000000000000000
> [ 2995.714001] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> [ 2995.714001] CR2: 0000000000000000 CR3: 000000022d11e000 CR4: 00000000000006f0
> [ 2995.714001] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [ 2995.714001] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> [ 2995.714001] Process hib.sh (pid: 7440, threadinfo ffff88022fa02000, task ffff88022fb32520)
> [ 2995.714001] Stack:
> [ 2995.714001]  ffff88022d747098 00000000813fd2ac ffffffff8165ee28 0000000000000416
> [ 2995.714001] <0> ffff88022fa038f8 ffffffff810c6d40 ffffea00078fae60 ffffea00078fae60
> [ 2995.714001] <0> ffff88022fa03938 00000002810abd98 ffffea00078ec530 ffffea00078efb98
> [ 2995.714001] Call Trace:
> [ 2995.714001]  [<ffffffff810c6d40>] ? swapcache_free+0x37/0x3c
> [ 2995.714001]  [<ffffffff810ac31d>] shrink_page_list+0x171/0x4b1
> [ 2995.714001]  [<ffffffff813fd1e6>] ? _raw_spin_unlock_irq+0x30/0x58
> [ 2995.714001]  [<ffffffff810ac9b9>] shrink_inactive_list+0x35c/0x623
> [ 2995.714001]  [<ffffffff810acd94>] ? shrink_zone+0x114/0x3d4
> [ 2995.714001]  [<ffffffff81064f29>] ? print_lock_contention_bug+0x1b/0xe1
> [ 2995.714001]  [<ffffffff813fc790>] ? _raw_spin_lock_irq+0x19/0x79
> [ 2995.714001]  [<ffffffff810acf8a>] shrink_zone+0x30a/0x3d4
> [ 2995.714001]  [<ffffffff810ad19e>] ? shrink_slab+0x14a/0x15c
> [ 2995.714001]  [<ffffffff810adb65>] do_try_to_free_pages+0x176/0x27f
> [ 2995.714001]  [<ffffffff8103de67>] ? irq_exit+0x93/0x95
> [ 2995.714001]  [<ffffffff810add03>] shrink_all_memory+0x95/0xc4
> [ 2995.714001]  [<ffffffff810ab0f0>] ? isolate_pages_global+0x0/0x217
> [ 2995.714001]  [<ffffffff81077503>] ? count_data_pages+0x65/0x79
> [ 2995.714001]  [<ffffffff8107776a>] hibernate_preallocate_memory+0x1aa/0x2cb
> [ 2995.714001]  [<ffffffff813f95b5>] ? printk+0x41/0x44
> [ 2995.714001]  [<ffffffff810760b3>] hibernation_snapshot+0x36/0x1e1
> [ 2995.714001]  [<ffffffff8107632c>] hibernate+0xce/0x172
> [ 2995.714001]  [<ffffffff81075099>] state_store+0x5c/0xd3
> [ 2995.714001]  [<ffffffff8118728f>] kobj_attr_store+0x17/0x19
> [ 2995.714001]  [<ffffffff81127b69>] sysfs_write_file+0x108/0x144
> [ 2995.714001]  [<ffffffff810d66ff>] vfs_write+0xb2/0x153
> [ 2995.714001]  [<ffffffff810641a9>] ? trace_hardirqs_on_caller+0x1f/0x14b
> [ 2995.714001]  [<ffffffff810d6863>] sys_write+0x4a/0x71
> [ 2995.714001]  [<ffffffff810021db>] system_call_fastpath+0x16/0x1b
> [ 2995.714001] Code: 3b 56 10 73 1e 48 83 fa f2 74 18 48 8d 4d cc 4d 89 f8 48 89 df e8 4d f2 ff ff 41 01 c4 83 7d cc 00 74 19 4d 8b 6d 20 49 83 ed 20 <49> 8b 45 20 0f 18 08 49 8d 45 20 48 39 45 80 75 aa 4c 89 f7 e8 
> [ 2995.714001] RIP  [<ffffffff810c194d>] page_referenced+0xee/0x1dc
> [ 2995.714001]  RSP <ffff88022fa038b8>
> [ 2995.714001] CR2: 0000000000000000
> [ 2995.729717] ---[ end trace 92c25d74e4800968 ]---

So again, I can show that the code has never actually been through the 
loop. The above code decodes to:

   0:	3b 56 10             	cmp    0x10(%rsi),%edx
   3:	73 1e                	jae    0x23
   5:	48 83 fa f2          	cmp    $0xfffffffffffffff2,%rdx
   9:	74 18                	je     0x23
   b:	48 8d 4d cc          	lea    -0x34(%rbp),%rcx
   f:	4d 89 f8             	mov    %r15,%r8
  12:	48 89 df             	mov    %rbx,%rdi
  15:	e8 4d f2 ff ff       	callq  0xfffffffffffff267
  1a:	41 01 c4             	add    %eax,%r12d
  1d:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  21:	74 19                	je     0x3c
  23:	4d 8b 6d 20          	mov    0x20(%r13),%r13
  27:	49 83 ed 20          	sub    $0x20,%r13
  2b:*	49 8b 45 20          	mov    0x20(%r13),%rax     <-- trapping instruction
  2f:	0f 18 08             	prefetcht0 (%rax)
  32:	49 8d 45 20          	lea    0x20(%r13),%rax
  36:	48 39 45 80          	cmp    %rax,-0x80(%rbp)
  3a:	75 aa                	jne    0xffffffffffffffe6
  3c:	4c 89 f7             	mov    %r14,%rdi
  3f:	e8                   	.byte 0xe8

and in your case, if we had gone through the loop, then %rax would still 
contain the return value from page_referenced_one(). 

But %rax is a kernel pointer, and %r12d is 0.

So again, it's actually anon_vma.head.next that is NULL, not any of the 
entries on the list itself.

Now, I can see several cases for this:

 - the obvious one: anon_vma just wasn't correctly initialized, and is 
   missing a INIT_LIST_HEAD(&anon_vma->head). That's either a slab bug (we 
   don't have a whole lot of coverage of constructors), or somebody 
   allocated an anon_vma without using the anon_vma_cachep.

 - Related to the above: perhaps the RCU freeing isn't working, or 
   slub/slab/slob ends up reusing the allocations for something else than 
   anonvma's, so together with the race _and_ an unlucky re-use, you get 
   some odd crud.

   I haven't looked at the kernel config files: do they perhaps share the 
   same (odd?) SLUB/SLAB/SLOB config?

 - anon_vma isn't actually an anonvma at all. 'page->mapping' was crud 
   with the low bit set. That sounds unlikely, but who knows. The ksm code 
   sets mapping to "stable_node + PAGE_MAPPING_ANON | PAGE_MAPPING_KSM"

   Did people have KSM enabled?

.. and probably other things I haven't even thought about.

		Linus
