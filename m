Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757450Ab0EMJvu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 05:51:50 -0400
Received: from mx1.redhat.com ([209.132.183.28]:29283 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755503Ab0EMJvs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 05:51:48 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20100512123629.41139fd5.akpm@linux-foundation.org>
References: <20100512123629.41139fd5.akpm@linux-foundation.org> <20100512143403.2722.29652.stgit@warthog.procyon.org.uk>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: dhowells@redhat.com, torvalds@linux-foundation.org,
       linux-cachefs@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] CacheFiles: Fix error handling in cachefiles_determine_cache_security()
Date: Thu, 13 May 2010 10:51:00 +0100
Message-ID: <20327.1273744260@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton <akpm@linux-foundation.org> wrote:

> The changelog makes it hard for civilians to work out what the
> user-visible effect of this bug was.

Sorry, I should've included the below oops report in the patch description.

Sadly, I think it's too late to fix that now as Linus has taken the patch.

The problem can only occur when the cache is being started up and if an LSM
(such as SELinux) is being used that can reject set_create_files_as().  It can
only be incurred by root, as only root can start up a cache.

Yes, it should got to stable too.

David
---
CacheFiles: Failed to register: -13
------------[ cut here ]------------
kernel BUG at kernel/cred.c:171!
invalid opcode: 0000 [#1] SMP
last sysfs file: /sys/block/sda/sda6/start
CPU 1
Modules linked in: cachefiles nfs fscache auth_rpcgss nfs_acl lockd sunrpc

Pid: 0, comm: swapper Not tainted 2.6.34-rc7-cachefs #74 DG965RY/
RIP: 0010:[<ffffffff81049bdf>]  [<ffffffff81049bdf>] __put_cred+0x1a/0x65
RSP: 0018:ffff880002103e10  EFLAGS: 00010202
RAX: 0000000000000001 RBX: ffff88003dd94d80 RCX: 0000000000000000
RDX: ffff88003dc7d6e0 RSI: 0000000000000000 RDI: ffff88003dd94d80
RBP: ffff880002103e10 R08: 0000000000000050 R09: 09f911029d74e35b
R10: ffffffff8107ba45 R11: ffff88000210e640 R12: ffff880030670040
R13: ffff88000210e640 R14: ffff880030670f50 R15: ffff88003dc93d58
FS:  0000000000000000(0000) GS:ffff880002100000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 00007f78e0e42098 CR3: 000000000161c000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process swapper (pid: 0, threadinfo ffff88003dcb0000, task ffff88003dc84040)
Stack:
 ffff880002103e30 ffffffff8104a78e ffff880030670040 ffffffff816326c0
<0> ffff880002103e50 ffffffff8102f87a ffff88000210e640 ffff880030670040
<0> ffff880002103e70 ffffffff810319d4 ffff880002103e70 ffff88000210e610
Call Trace:
 <IRQ>
 [<ffffffff8104a78e>] exit_creds+0x7f/0x15a
 [<ffffffff8102f87a>] __put_task_struct+0x65/0x94
 [<ffffffff810319d4>] delayed_put_task_struct+0x4e/0x52
 [<ffffffff8107bb41>] __rcu_process_callbacks+0x191/0x2a4
 [<ffffffff8107bc7a>] rcu_process_callbacks+0x26/0x4c
 [<ffffffff810355e6>] __do_softirq+0xa2/0x140
 [<ffffffff81002e0c>] call_softirq+0x1c/0x28
 [<ffffffff81004b54>] do_softirq+0x38/0x80
 [<ffffffff81034f82>] irq_exit+0x45/0x47
 [<ffffffff81017833>] smp_apic_timer_interrupt+0x88/0x96
 [<ffffffff810028d3>] apic_timer_interrupt+0x13/0x20
 <EOI>
 [<ffffffff810489e1>] ? __atomic_notifier_call_chain+0x0/0x86
 [<ffffffff810096bf>] ? mwait_idle+0x6e/0x78
 [<ffffffff810096b6>] ? mwait_idle+0x65/0x78
 [<ffffffff810011dc>] cpu_idle+0x4d/0x83
 [<ffffffff8138f62c>] start_secondary+0x1bd/0x1c1
Code: da c0 15 00 4c 89 e7 e8 bd 15 06 00 5b 41 5c c9 c3 55 8b 47 04 48 89 e5 8b 07 8b 07 85 c0 74 04 0f 0b eb fe 8b 47 04 85 c0 74 04 <0f> 0b eb fe c7 47 10 44 61 65 44 48 8b 45 08 48 89 47 08 65 48
RIP  [<ffffffff81049bdf>] __put_cred+0x1a/0x65
 RSP <ffff880002103e10>
---[ end trace f1e0ebe358730a1c ]---
Kernel panic - not syncing: Fatal exception in interrupt
Pid: 0, comm: swapper Tainted: G      D    2.6.34-rc7-cachefs #74
Call Trace:
 <IRQ>  [<ffffffff81392977>] panic+0x73/0xeb
 [<ffffffff81005c7c>] ? oops_end+0x42/0x8e
 [<ffffffff81005cbb>] oops_end+0x81/0x8e
 [<ffffffff81005e9f>] die+0x55/0x5e
 [<ffffffff81003574>] do_trap+0x11c/0x12b
 [<ffffffff810038fd>] ? do_invalid_op+0x72/0x9f
 [<ffffffff81003921>] do_invalid_op+0x96/0x9f
 [<ffffffff81049bdf>] ? __put_cred+0x1a/0x65
 [<ffffffff81395418>] ? trace_hardirqs_off_thunk+0x3a/0x3c
 [<ffffffff8107ba45>] ? __rcu_process_callbacks+0x95/0x2a4
 [<ffffffff81395eec>] ? irq_return+0x0/0x2
 [<ffffffff81002b95>] invalid_op+0x15/0x20
 [<ffffffff8107ba45>] ? __rcu_process_callbacks+0x95/0x2a4
 [<ffffffff81049bdf>] ? __put_cred+0x1a/0x65
 [<ffffffff8104a78e>] exit_creds+0x7f/0x15a
 [<ffffffff8102f87a>] __put_task_struct+0x65/0x94
 [<ffffffff810319d4>] delayed_put_task_struct+0x4e/0x52
 [<ffffffff8107bb41>] __rcu_process_callbacks+0x191/0x2a4
 [<ffffffff8107bc7a>] rcu_process_callbacks+0x26/0x4c
 [<ffffffff810355e6>] __do_softirq+0xa2/0x140
 [<ffffffff81002e0c>] call_softirq+0x1c/0x28
 [<ffffffff81004b54>] do_softirq+0x38/0x80
 [<ffffffff81034f82>] irq_exit+0x45/0x47
 [<ffffffff81017833>] smp_apic_timer_interrupt+0x88/0x96
 [<ffffffff810028d3>] apic_timer_interrupt+0x13/0x20
 <EOI>  [<ffffffff810489e1>] ? __atomic_notifier_call_chain+0x0/0x86
 [<ffffffff810096bf>] ? mwait_idle+0x6e/0x78
 [<ffffffff810096b6>] ? mwait_idle+0x65/0x78
 [<ffffffff810011dc>] cpu_idle+0x4d/0x83
 [<ffffffff8138f62c>] start_secondary+0x1bd/0x1c1
