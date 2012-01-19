Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753244Ab2ASMRK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jan 2012 07:17:10 -0500
Received: from alice.et.bocholt.fh-gelsenkirchen.de ([193.175.197.63]:48832
	"EHLO alice.et.bocholt.fh-gelsenkirchen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750779Ab2ASMRG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jan 2012 07:17:06 -0500
X-DKIM: Sendmail DKIM Filter v2.8.3 alice.et.bocholt.fh-gelsenkirchen.de q0JCGvBc031109
From: Dirk Gouders <gouders@et.bocholt.fh-gelsenkirchen.de>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [Problem] kernel hangs at boot (bisected 892d208bcf)
In-Reply-To: <20120119110121.GC9268@arm.com> (Catalin Marinas's message of
	"Thu, 19 Jan 2012 11:01:21 +0000")
References: <gi39bcyff8.fsf@mx10.gouders.net> <20120119110121.GC9268@arm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
Date: Thu, 19 Jan 2012 13:16:56 +0100
Message-ID: <gi1uqvsx8n.fsf@karga.hank.lab>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Greylist: Sender succeeded STARTTLS authentication, not delayed by milter-greylist-4.2.3 (alice.et.bocholt.fh-gelsenkirchen.de [192.168.0.63]); Thu, 19 Jan 2012 13:16:58 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Catalin,

Catalin Marinas <catalin.marinas@arm.com> writes:

> Hi Dirk,
>
> On Wed, Jan 18, 2012 at 07:32:59PM +0000, Dirk Gouders wrote:
>> I am not sure if you are the correct person to contact,
>
> I am for kmemleak :) but I'm not sure it's kmemleak's fault here.
>
>> but
>> I noticed a regression in Linus' master branch and bisected this to
>> commit 892d208bcf
>> "Merge tag 'kmemleak' of git://git.kernel.org/pub/scm/linux/kernel/git/cmarinas/linux".
> ...
>> Freeing unused kernel memory: 608k freed
>> kernel tried to execute NX-protected page - exploit attempt? (uid: 0)
>> BUG: unable to handle kernel paging request at ffffffff818b232b
>> IP: [<ffffffff818b232b>] kmemleak_late_init+0x8a/0x8a
>> PGD 17ed067 PUD 17f1063 PMD 3c6a9063 PTE 80000000018b2163
>> Oops: 0011 [#1] SMP
>> CPU 1
>> Modules linked in:
>> 
>> Pid: 1, comm: swapper/0 Not tainted 3.2.0-09104-gccb19d2 #4 Bochs Bochs
>> RIP: 0010:[<ffffffff818b232b>]  [<ffffffff818b232b>] kmemleak_late_init+0x8a/0x8a
>> RSP: 0018:ffff88003fd03e58  EFLAGS: 00010282
>> RAX: 0000000000000001 RBX: ffff88003dbd2600 RCX: 0000000000000000
>> RDX: 0000000000000000 RSI: ffff88003dbd2600 RDI: 0000000000000002
>> RBP: ffff88003e015488 R08: ffff88003fd0d5c0 R09: ffff88003fd122e0
>> R10: 0000000000000400 R11: ffffffff81572da5 R12: ffffea0000f6f480
>> R13: ffffffff810aa687 R14: 0000000000000000 R15: ffff88003e31dbc8
>> FS:  0000000000000000(0000) GS:ffff88003fd00000(0000) knlGS:0000000000000000
>> CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
>> CR2: ffffffff818b232b CR3: 00000000017eb000 CR4: 00000000000006e0
>> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
>> DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
>> Process swapper/0 (pid: 1, threadinfo ffff88003e272000, task ffff88003e278000)
>> Stack:
>>  ffffffff810fed11 ffff88003dbd2680 ffff88003fd0d830 ffffffff81805980
>>  ffff88003d48dd00 ffff88003fd0d860 ffffffff810aa687 ffff88003e2ad420
>>  0000000a3e2ad820 ffff88003e272000 ffff88003e278000 ffff88003fd03eb0
>> Call Trace:
>>  <IRQ>
>>  [<ffffffff810fed11>] ? kmem_cache_free+0x4f/0xd9
>>  [<ffffffff810aa687>] ? __rcu_process_callbacks+0x1bf/0x2e2
>>  [<ffffffff810aa7f4>] ? rcu_process_callbacks+0x4a/0x95
>> [<ffffffff8105cc1a>] ? __do_softirq+0xb6/0x171
>>  [<ffffffff8155a58c>] ? call_softirq+0x1c/0x30
>>  [<ffffffff81032d85>] ? do_softirq+0x31/0x68
>>  [<ffffffff8105ce7f>] ? irq_exit+0x44/0x9e
>>  [<ffffffff81047fd9>] ? smp_apic_timer_interrupt+0x85/0x95
>>  [<ffffffff818d1000>] ? free_area_init_node+0x21f/0x2fb
>>  [<ffffffff81559c4b>] ? apic_timer_interrupt+0x6b/0x70
>>  <EOI>
>>  [<ffffffff818d1000>] ? free_area_init_node+0x21f/0x2fb
>>  [<ffffffff818d14b0>] ? __next_free_mem_range_rev+0x57/0x11e
>>  [<ffffffff8104d31b>] ? free_init_pages+0xea/0x110
>>  [<ffffffff810001c0>] ? init_post+0xe/0xbb
>>  [<ffffffff81895b93>] ? kernel_init+0x10f/0x113
>>  [<ffffffff8155a494>] ? kernel_thread_helper+0x4/0x10
>>  [<ffffffff81895a84>] ? start_kernel+0x319/0x319
>>  [<ffffffff8155a490>] ? gs_change+0xb/0xb
>> Code: cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc <cc> cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc
>> RIP  [<ffffffff818b232b>] kmemleak_late_init+0x8a/0x8a
>>  RSP <ffff88003fd03e58>
>> CR2: ffffffff818b232b
>
> I don't really see how kmemleak could cause such error (or any of the
> recent changes I have made). It looks like some of the code in the
> .init.text section is not executable.
>
> If you still have the vmlinux around, could you please run:
>
> addr2line -i -f -e vmlinux ffffffff818b232b
>
> The code shown shown in the oops message is also a bit weird (all 0xcc).
> Maybe you could do an objdump -d in that area, see if it looks like sane
> asm code.

I'll attach the information you asked for.
I mentioned that while bisecting there was another commit that gave me
hangs on boot.  This was when about six candidates were left and I will
re-bisect with treating that commit bad and see where I get then.

Best regards,

Dirk

------------------------------------------------------------------------

$ addr2line -i -f -e vmlinux ffffffff818b232b
log_early
kmemleak.c:0

And here the requested part of objdump (maybe obvious: I searched for
the cc pattern as well but did not find any):

ffffffff818b232b <log_early>:
ffffffff818b232b:       55                      push   %rbp
ffffffff818b232c:       53                      push   %rbx
ffffffff818b232d:       48 83 ec 08             sub    $0x8,%rsp
ffffffff818b2331:       8b 05 1d 32 13 00       mov    0x13321d(%rip),%eax        # ffffffff819e5554 <kmemleak_error>
ffffffff818b2337:       85 c0                   test   %eax,%eax
ffffffff818b2339:       74 08                   je     ffffffff818b2343 <log_early+0x18>
ffffffff818b233b:       ff 05 6f 2f 03 00       incl   0x32f6f(%rip)        # ffffffff818e52b0 <crt_early_log>
ffffffff818b2341:       eb 5c                   jmp    ffffffff818b239f <log_early+0x74>
ffffffff818b2343:       81 3d 63 2f 03 00 8f    cmpl   $0x18f,0x32f63(%rip)        # ffffffff818e52b0 <crt_early_log>
ffffffff818b234a:       01 00 00 
ffffffff818b234d:       76 0b                   jbe    ffffffff818b235a <log_early+0x2f>
ffffffff818b234f:       48 83 c4 08             add    $0x8,%rsp
ffffffff818b2353:       5b                      pop    %rbx
ffffffff818b2354:       5d                      pop    %rbp
ffffffff818b2355:       e9 68 0d 85 ff          jmpq   ffffffff811030c2 <kmemleak_disable>
ffffffff818b235a:       9c                      pushfq 
ffffffff818b235b:       5d                      pop    %rbp
ffffffff818b235c:       fa                      cli    
ffffffff818b235d:       48 63 1d 4c 2f 03 00    movslq 0x32f4c(%rip),%rbx        # ffffffff818e52b0 <crt_early_log>
