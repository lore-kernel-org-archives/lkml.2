Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755741Ab1FJNRu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jun 2011 09:17:50 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:38345 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755392Ab1FJNRt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jun 2011 09:17:49 -0400
Subject: BUG on 3.0-rc on commit d72bce0e67e8afc6eb959f656013cbb577426f1e
From: Andrew Theurer <habanero@linux.vnet.ibm.com>
Reply-To: habanero@linux.vnet.ibm.com
To: linux-kernel@vger.kernel.org
Cc: peterz@infradead.org
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 10 Jun 2011 08:17:17 -0500
Message-ID: <1307711837.23688.33.camel@atheurer-ubuntu10>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Looks like commit d72bce0e67e8afc6eb959f656013cbb577426f1e breaks my
boot:

BUG: unable to handle kernel NULL pointer dereference at
0000000000000004
IP: [<ffffffff8104e8b1>] find_lowest_rq+0xa1/0x150
PGD 0
Oops: 0000 [#1] SMP
CPU 0
Modules linked in:

Pid: 1, comm: swapper Not tainted 3.0.0-rc1-00001-gd72bce0 #32 IBM
-[7145AC1]-/Node 1, Processor Card
RIP: 0010:[<ffffffff8104e8b1>]  [<ffffffff8104e8b1>] find_lowest_rq
+0xa1/0x150
RSP: 0018:ffff883732925ca0  EFLAGS: 00010002
RAX: 0000000000000020 RBX: 0000000000000020 RCX: 0000000000000050
RDX: 00000000ffffffff RSI: 0000000000000050 RDI: 0000000000000050
RBP: ffff883732925cd0 R08: ffff883732774d38 R09: 0000000000000000
R10: 0000000000000001 R11: 0000000000000000 R12: 0000000000000000
R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000012ac0
FS:  0000000000000000(0000) GS:ffff88387f800000(0000)
knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000000004 CR3: 0000000001a03000 CR4: 00000000000006f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process swapper (pid: 1, threadinfo ffff883732924000, task
ffff8837329234c0)
Stack:
 ffff883732925cf0 0000000000000020 0000000000000020 ffff883732775300
 0000000000000000 0000000000000286 ffff883732925cf0 ffffffff8104e9da
 0000000000000022 ffff883732774b40 ffff883732925d40 ffffffff8105ae11
Call Trace:
 [<ffffffff8104e9da>] select_task_rq_rt+0x7a/0x90
 [<ffffffff8105ae11>] try_to_wake_up+0x111/0x280
 [<ffffffff8105afd5>] wake_up_process+0x15/0x20
 [<ffffffff814cc5c9>] rcu_cpu_notify+0xd6/0x196
 [<ffffffff814d6625>] notifier_call_chain+0x55/0x80
 [<ffffffff8108a77e>] __raw_notifier_call_chain+0xe/0x10
 [<ffffffff81064560>] __cpu_notify+0x20/0x40
 [<ffffffff814caf88>] _cpu_up+0xc7/0x10e
 [<ffffffff814cb0a6>] cpu_up+0xd7/0xea
 [<ffffffff81c41cab>] smp_init+0x41/0x96
 [<ffffffff81c227d4>] kernel_init+0x1d6/0x262
 [<ffffffff814dbc04>] kernel_thread_helper+0x4/0x10
 [<ffffffff81c225fe>] ? do_basic_setup+0x5c/0x5c
 [<ffffffff814dbc00>] ? gs_change+0x13/0x13
Code: 2a 01 00 48 89 fe 48 8b 04 c5 40 a3 bf 81 4c 89 e2 49 8b 84 07 88
08 00 00 48 83 c0 38 48 89 c7 e8 b5 74 0a 00 85 c0 74 ae 89 d8
 0f a3 1c 24 19 d2 85 d2 75 a6 45 0f a3 2c 24 19 c0 41 be ff
RIP  [<ffffffff8104e8b1>] find_lowest_rq+0xa1/0x150
 RSP <ffff883732925ca0>
CR2: 0000000000000004
---[ end trace 6afdf060c90559fd ]---
Kernel panic - not syncing: Attempted to kill init!
Pid: 1, comm: swapper Tainted: G      D     3.0.0-rc1-00001-gd72bce0 #32
Call Trace:
 [<ffffffff814cfcd8>] panic+0x91/0x1a8
 [<ffffffff81065fdb>] forget_original_parent+0x32b/0x330
 [<ffffffff81065ffb>] exit_notify+0x1b/0x190
 [<ffffffff810666ed>] do_exit+0x1fd/0x430
 [<ffffffff814d3c4b>] oops_end+0xab/0xf0
 [<ffffffff8103d91c>] no_context+0xfc/0x190
 [<ffffffff8103dad5>] __bad_area_nosemaphore+0x125/0x1e0
 [<ffffffff8123b0a9>] ? put_dec+0x59/0x60
 [<ffffffff8103dba3>] bad_area_nosemaphore+0x13/0x20
 [<ffffffff814d6488>] do_page_fault+0x328/0x470
 [<ffffffff812f4cbe>] ? notify_update+0x2e/0x30
 [<ffffffff812f6aa8>] ? vt_console_print+0x2a8/0x390
 [<ffffffff810f7741>] ? __perf_event_task_sched_out+0x31/0x50
 [<ffffffff8105b503>] ? perf_event_task_sched_out+0x33/0xa0
 [<ffffffff814d2f95>] page_fault+0x25/0x30
 [<ffffffff8104e8b1>] ? find_lowest_rq+0xa1/0x150
 [<ffffffff8104e9da>] select_task_rq_rt+0x7a/0x90
 [<ffffffff8105ae11>] try_to_wake_up+0x111/0x280
 [<ffffffff8105afd5>] wake_up_process+0x15/0x20
 [<ffffffff814cc5c9>] rcu_cpu_notify+0xd6/0x196
 [<ffffffff814d6625>] notifier_call_chain+0x55/0x80
 [<ffffffff8108a77e>] __raw_notifier_call_chain+0xe/0x10
 [<ffffffff81064560>] __cpu_notify+0x20/0x40
 [<ffffffff814caf88>] _cpu_up+0xc7/0x10e
 [<ffffffff814cb0a6>] cpu_up+0xd7/0xea
 [<ffffffff81c41cab>] smp_init+0x41/0x96
 [<ffffffff81c227d4>] kernel_init+0x1d6/0x262
 [<ffffffff814dbc04>] kernel_thread_helper+0x4/0x10
 [<ffffffff81c225fe>] ? do_basic_setup+0x5c/0x5c
 [<ffffffff814dbc00>] ? gs_change+0x13/0x13



This is on a Westmere-EX (4 socket, 40 cores)

-Andrew



