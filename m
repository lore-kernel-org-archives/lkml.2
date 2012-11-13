Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753307Ab2KMDWE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2012 22:22:04 -0500
Received: from mail-vc0-f174.google.com ([209.85.220.174]:38830 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752304Ab2KMDWB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2012 22:22:01 -0500
MIME-Version: 1.0
In-Reply-To: <20121105131415.GA13287@localhost>
References: <20121105131415.GA13287@localhost>
Date: Tue, 13 Nov 2012 11:22:00 +0800
Message-ID: <CA+2_Tiapq=Lb6mS91Z5SSiWZmUQZsL+2d98BsZDNJ+VhcOzqPQ@mail.gmail.com>
Subject: Re: [CPU hotplug, __disable_runtime] kernel BUG at kernel/sched/rt.c:687!
From: Neil Zhang <glacier1980@gmail.com>
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter and Ingo,


2012/11/5 Fengguang Wu <fengguang.wu@intel.com>:
> Greetings,
>
> I got a rather hard to reproduce/bisect oops when doing CPU hotplug
> testing:
>
> [  480.327742] CPU0 attaching NULL sched-domain.
> [  480.329408] ------------[ cut here ]------------
> [  480.330355] kernel BUG at /c/kernel-tests/src/stable/kernel/sched/rt.c:687!
> [  480.330355] invalid opcode: 0000 [#1] SMP DEBUG_PAGEALLOC
> [  480.330355] Modules linked in:
> [  480.330355] CPU 1
> [  480.330355] Pid: 3007, comm: 01-cpu-hotplug Not tainted 3.7.0-rc3-00017-g1a303f5 #2502 Bochs Bochs
> [  480.330355] RIP: 0010:[<ffffffff810a679b>]  [<ffffffff810a679b>] __disable_runtime+0x188/0x1c2
> [  480.330355] RSP: 0018:ffff8800199cbad8  EFLAGS: 00010082
> [  480.330355] RAX: ffffffff810a6796 RBX: ffff88001f3d3b40 RCX: 0000000000000005
> [  480.330355] RDX: ffffffff81a5ff61 RSI: 0000000000000092 RDI: 0000000000000046
> [  480.330355] RBP: ffff8800199cbb38 R08: 00000000000006fc R09: 000000000000000c
> [  480.330355] R10: 000000000000000c R11: ffff8800168cac88 R12: 0000000000000040
> [  480.330355] R13: ffff88001f3d4358 R14: 00000000001d3b40 R15: fffffffffd050f80
> [  480.330355] FS:  00007f2f660d9700(0000) GS:ffff88001f400000(0000) knlGS:0000000000000000
> [  480.330355] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> [  480.330355] CR2: 00007f2f65aab830 CR3: 00000000184a1000 CR4: 00000000000006e0
> [  480.330355] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [  480.330355] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> [  480.330355] Process 01-cpu-hotplug (pid: 3007, threadinfo ffff8800199ca000, task ffff8800168ca3e0)
> [  480.330355] Stack:
> [  480.330355]  ffff8800199cbb58 ffff8800168cac18 ffff88001f3d3b58 ffff880018544a58
> [  480.330355]  ffff88001f3d3cb8 0000000000000040 ffff8800199cbb58 ffff88001f3d3b40
> [  480.330355]  ffffffff81a931d0 ffffffff824086b0 ffff880018544a60 00000000ffffffff
> [  480.330355] Call Trace:
> [  480.330355]  [<ffffffff810a6d02>] rq_offline_rt+0x74/0x96
> [  480.330355]  [<ffffffff8109a724>] set_rq_offline.part.37+0x2a/0x81
> [  480.330355]  [<ffffffff8109be81>] rq_attach_root+0x85/0x193
> [  480.330355]  [<ffffffff8109c10f>] cpu_attach_domain+0x180/0x228
> [  480.330355]  [<ffffffff810a07d0>] partition_sched_domains+0x157/0x350
> [  480.330355]  [<ffffffff810a0782>] ? partition_sched_domains+0x109/0x350
> [  480.330355]  [<ffffffff810c1a18>] ? trace_hardirqs_on_caller+0x125/0x181
> [  480.330355]  [<ffffffff810da300>] cpuset_update_active_cpus+0x10c/0x117
> [  480.330355]  [<ffffffff8108688a>] ? keep_working+0x2d/0x2d
> [  480.330355]  [<ffffffff810a0a3b>] cpuset_cpu_inactive+0x20/0x3f
> [  480.330355]  [<ffffffff81a63c2a>] notifier_call_chain+0x65/0x95
> [  480.330355]  [<ffffffff81094e6e>] __raw_notifier_call_chain+0xe/0x10
> [  480.330355]  [<ffffffff8106f94c>] __cpu_notify+0x20/0x37
> [  480.330355]  [<ffffffff81a06b24>] _cpu_down+0xa4/0x26d
> [  480.330355]  [<ffffffff81a06d15>] cpu_down+0x28/0x3c
> [  480.330355]  [<ffffffff81a09687>] store_online+0x3e/0x8f
> [  480.330355]  [<ffffffff8156ccc4>] dev_attr_store+0x18/0x24
> [  480.330355]  [<ffffffff811bf7e4>] sysfs_write_file+0xee/0x126
> [  480.330355]  [<ffffffff811662ad>] vfs_write+0xa6/0x152
> [  480.330355]  [<ffffffff81166574>] sys_write+0x4c/0x80
> [  480.330355]  [<ffffffff81a678c0>] tracesys+0xdd/0xe2
> [  480.330355] Code: 00 00 00 49 63 d4 e8 e1 b8 39 00 3b 05 73 97 ff 00 48 89 45 c8 41 89 c4 0f 8c 2c ff ff ff 4c 89 ef e8 72 8d 9b 00 4d 85 ff 74 02 <0f> 0b 48 c7 83 10 08 00 00 ff ff ff ff 4c 89 ef c7 83 00 08 00
> [  480.330355] RIP  [<ffffffff810a679b>] __disable_runtime+0x188/0x1c2
> [  480.330355]  RSP <ffff8800199cbad8>
>
> Thanks,
> Fengguang

I have met the same issue on Marvell SOC.
Would you please take a look?
Thanks.

Best Regards,
Neil Zhang
