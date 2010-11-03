Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753254Ab0KCGsj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Nov 2010 02:48:39 -0400
Received: from mga11.intel.com ([192.55.52.93]:16465 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752712Ab0KCGsf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Nov 2010 02:48:35 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.58,287,1286175600"; 
   d="scan'208";a="853659780"
Subject: VM ops on 37-rc1
From: "Alex,Shi" <alex.shi@intel.com>
To: linux-kernel@vger.kernel.org
Cc: "Chen, Tim C" <tim.c.chen@intel.com>, "Li, Shaohua" <shaohua.li@intel.com>,
        fengguang.wu@intel.com, pzijlstr@redhat.com
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 03 Nov 2010 14:55:41 +0800
Message-ID: <1288767341.15466.4624.camel@debian>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I found some ops on one of Bensely Core2 machine. The ops may pops up
just system after booted. 2.6.36 kernel is good. The similar ops also
appears on IA64 machine.   Any idea of this?

general protection fault: 0000 [#1] SMP
last sysfs file: /sys/devices/system/cpu/cpu7/cache/index2/shared_cpu_map
CPU 1
Modules linked in: video output

Pid: 8494, comm: sadc Not tainted 2.6.37-rc1 #1 X7DWN/X7DW3
RIP: 0010:[<ffffffff812c6d89>]  [<ffffffff812c6d89>] strnlen+0x11/0x1a
RSP: 0018:ffff88022f1ddcf0  EFLAGS: 00010297
RAX: 41ffffffff81a197 RBX: 0000000000000000 RCX: ffffffffffffffff
RDX: 41ffffffff81a197 RSI: fffffffffffffffe RDI: 41ffffffff81a197
RBP: ffff88022ef42000 R08: 0000000000000002 R09: ffffffff81cb7a50
R10: ffff88022f1ddf50 R11: ffffffff81c4e3c8 R12: 41ffffffff81a197
R13: 000000000000ffff R14: ffff88022ef43000 R15: ffffffff81a19438
FS:  00007fd06b06e6f0(0000) GS:ffff8800cfc40000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 00007fd06b0a2000 CR3: 000000022db81000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process sadc (pid: 8494, threadinfo ffff88022f1dc000, task ffff88022b9d5a30)
Stack:
 ffffffff812c846d ffff88022f1ddd88 ffff88022ef42000 ffffffff81a19436
 ffff88022ef43000 ffff88022ef42000 ffffffff812c9196 ffff88022f08e4c0
 0000000000001000 ffffffffff0a0004 ffffffff810b30a1 0000000000000000
Call Trace:
 [<ffffffff812c846d>] ? string+0x43/0xb5
 [<ffffffff812c9196>] ? vsnprintf+0x1d8/0x421
 [<ffffffff810b30a1>] ? vma_adjust+0x205/0x435
 [<ffffffff810df8f5>] ? seq_printf+0x67/0x8f
 [<ffffffff8160d42b>] ? mutex_lock+0x20/0x44
 [<ffffffff8160d42b>] ? mutex_lock+0x20/0x44
 [<ffffffff810a9087>] ? all_vm_events+0x60/0x73
 [<ffffffff8103b615>] ? put_online_cpus+0x22/0x54
 [<ffffffff810a9169>] ? vmstat_start+0xcf/0x103
 [<ffffffff810a89a5>] ? vmstat_show+0x23/0x27
 [<ffffffff810dfe79>] ? seq_read+0x181/0x364
 [<ffffffff8110d8eb>] ? proc_reg_read+0x6a/0x84
 [<ffffffff810c86fc>] ? vfs_read+0xa8/0x12f
 [<ffffffff810c8ae4>] ? sys_read+0x45/0x6e
 [<ffffffff8100296b>] ? system_call_fastpath+0x16/0x1b
Code: f2 ae 48 f7 d1 48 8d 44 11 ff 40 38 30 74 0a 48 ff c8 48 39 d0 73 f3 31 c0 c3 48 89 f8 eb 03 48 ff c0 48 ff ce 48 83 fe ff 74 05 <80> 38 00 75 ef 48 29 f8 c3 31 c0 eb 12 41 38 c8 74 0a 48 ff c2
RIP  [<ffffffff812c6d89>] strnlen+0x11/0x1a
 RSP <ffff88022f1ddcf0>
---[ end trace 75434a01211a18e0 ]---

Sometime, the following ops appears. 


BUG: unable to handle kernel paging request at ffffff81a19733ff
IP: [<ffffffff812c6d89>] strnlen+0x11/0x1a
PGD 1c41067 PUD 0
Oops: 0000 [#3] SMP
last sysfs file: /sys/devices/system/cpu/cpu7/cache/index2/shared_cpu_map
CPU 0
Modules linked in: video output

Pid: 1781, comm: sadc Tainted: G      D     2.6.37-rc1 #1 X7DWN/X7DW3
RIP: 0010:[<ffffffff812c6d89>]  [<ffffffff812c6d89>] strnlen+0x11/0x1a
RSP: 0018:ffff88022dea1cf0  EFLAGS: 00010297
RAX: ffffff81a19733ff RBX: 0000000000000000 RCX: ffffffffffffffff
RDX: ffffff81a19733ff RSI: fffffffffffffffe RDI: ffffff81a19733ff
RBP: ffff88022ee38000 R08: 0000000000000002 R09: ffffffff81cb7a50
R10: ffff88022dea1f50 R11: ffffffff81c4e3c8 R12: ffffff81a19733ff
R13: 000000000000ffff R14: ffff88022ee39000 R15: ffffffff81a19438
FS:  00007fd6725dc6f0(0000) GS:ffff8800cfc00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: ffffff81a19733ff CR3: 000000022e5e7000 CR4: 00000000000006f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process sadc (pid: 1781, threadinfo ffff88022dea0000, task ffff88022e1229a0)
Stack:
 ffffffff812c846d ffff88022dea1d88 ffff88022ee38000 ffffffff81a19436
 ffff88022ee39000 ffff88022ee38000 ffffffff812c9196 ffff88022ee086c0
 0000000000001000 ffffffffff0a0004 ffffffff810b30a1 0000000000000000
Call Trace:
 [<ffffffff812c846d>] ? string+0x43/0xb5
 [<ffffffff812c9196>] ? vsnprintf+0x1d8/0x421
 [<ffffffff810b30a1>] ? vma_adjust+0x205/0x435
 [<ffffffff810df8f5>] ? seq_printf+0x67/0x8f
 [<ffffffff8160d42b>] ? mutex_lock+0x20/0x44
 [<ffffffff8160d42b>] ? mutex_lock+0x20/0x44
 [<ffffffff810a9087>] ? all_vm_events+0x60/0x73
 [<ffffffff8103b615>] ? put_online_cpus+0x22/0x54
 [<ffffffff810a9169>] ? vmstat_start+0xcf/0x103
 [<ffffffff810a89a5>] ? vmstat_show+0x23/0x27
 [<ffffffff810dfe79>] ? seq_read+0x181/0x364
 [<ffffffff8110d8eb>] ? proc_reg_read+0x6a/0x84
 [<ffffffff810c86fc>] ? vfs_read+0xa8/0x12f
 [<ffffffff810c8ae4>] ? sys_read+0x45/0x6e
 [<ffffffff8100296b>] ? system_call_fastpath+0x16/0x1b
Code: f2 ae 48 f7 d1 48 8d 44 11 ff 40 38 30 74 0a 48 ff c8 48 39 d0 73 f3 31 c0 c3 48 89 f8 eb 03 48 ff c0 48 ff ce 48 83 fe ff 74 05 <80> 38 00 75 ef 48 29 f8 c3 31 c0 eb 12 41 38 c8 74 0a 48 ff c2
RIP  [<ffffffff812c6d89>] strnlen+0x11/0x1a


