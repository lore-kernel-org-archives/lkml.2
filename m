Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755033Ab0HXNIk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 09:08:40 -0400
Received: from he.sipsolutions.net ([78.46.109.217]:44795 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755010Ab0HXNIh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 09:08:37 -0400
Subject: Re: workqueue destruction BUG_ON
From: Johannes Berg <johannes@sipsolutions.net>
To: Tejun Heo <tj@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <4C73BC96.6000003@kernel.org>
References: <1282640156.3695.5.camel@jlt3.sipsolutions.net>
	 <4C739DC6.1040309@kernel.org>
	 <1282646268.3695.9.camel@jlt3.sipsolutions.net>
	 <4C73BC96.6000003@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 24 Aug 2010 15:10:14 +0200
Message-ID: <1282655414.3695.25.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun,

> From 492a242b75b0abae3b1c17b4a654ab9ef67e612d Mon Sep 17 00:00:00 2001
> From: Tejun Heo <tj@kernel.org>
> Date: Tue, 24 Aug 2010 14:22:47 +0200
> Subject: [PATCH] workqueue: improve destroy_workqueue() debuggability

With this patch applied I still get just the BUG_ON:

[  500.874185] ------------[ cut here ]------------
[  500.875212] kernel BUG at kernel/workqueue.c:2849!
[  500.876224] invalid opcode: 0000 [#1] PREEMPT SMP 
[  500.877256] last sysfs file: /sys/module/iwlagn/refcnt
[  500.878267] CPU 1 
[  500.878281] Modules linked in: iwlagn(-) ...
[  500.880074] 
[  500.880074] Pid: 2167, comm: modprobe Not tainted 2.6.36-rc1-wl-p2p-64225-g61066fb-dirty #18 JPTR/Satellite U505
[  500.880074] RIP: 0010:[<ffffffff81078aac>]  [<ffffffff81078aac>] destroy_workqueue+0x19c/0x1e0
[  500.880074] RSP: 0018:ffff88012587fd58  EFLAGS: 00010286
[  500.880074] RAX: 000000000000003c RBX: 0000000000000002 RCX: 000000000000005a
[  500.880074] RDX: ffff880132783d80 RSI: 0000000000000004 RDI: 00000000ffffffff
[  500.880074] RBP: ffff88012587fd68 R08: 0000000000000000 R09: 0000000000000000
[  500.880074] R10: 0000000000000003 R11: 0000000000000000 R12: ffff880123709240
[  500.880074] R13: ffff880133aa6240 R14: ffff880124423258 R15: 0000000000000282
[  500.880074] FS:  00007fcf136b2700(0000) GS:ffff88002cc00000(0000) knlGS:0000000000000000
[  500.880074] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  500.880074] CR2: 00000000006e3aa4 CR3: 00000001231fc000 CR4: 00000000000006e0
[  500.880074] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  500.880074] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  500.880074] Process modprobe (pid: 2167, threadinfo ffff88012587e000, task ffff8801336c4780)
[  500.880074] Stack:
[  500.880074]  ffff880124422840 ffff880133aa61b0 ffff88012587fda8 ffffffffa040bc30
[  500.880074] <0> ffff88012587fd98 ffff880133aa6240 ffff880133aa6530 ffffffffa0417980
[  500.880074] <0> ffff880133aa61b0 0000000001c014b8 ffff88012587fdd8 ffffffff812421b4
[  500.880074] Call Trace:
[  500.880074]  [<ffffffffa040bc30>] iwl_pci_remove+0x18c/0x21f [iwlagn]
[  500.880074]  [<ffffffff812421b4>] pci_device_remove+0x54/0x120
[  500.880074]  [<ffffffff812d4ab5>] __device_release_driver+0x75/0xe0
[  500.880074]  [<ffffffff812d4bf8>] driver_detach+0xd8/0xe0
[  500.880074]  [<ffffffff812d3a58>] bus_remove_driver+0x88/0xe0
[  500.880074]  [<ffffffff812d5282>] driver_unregister+0x62/0xa0
[  500.880074]  [<ffffffff81242514>] pci_unregister_driver+0x44/0xc0
[  500.880074]  [<ffffffffa040ba9d>] iwl_exit+0x15/0x1c [iwlagn]
[  500.880074]  [<ffffffff810a1e32>] sys_delete_module+0x1a2/0x280
[  500.880074]  [<ffffffff8100c1b2>] system_call_fastpath+0x16/0x1b
[  500.880074] Code: 19 00 39 05 77 81 81 00 7f 06 41 8b 0c 24 eb b4 83 f8 04 89 c6 77 23 41 8b 0c 24 e9 28 ff ff ff 0f 0b eb fe 31 d2 e9 43 ff ff ff <0f> 0b eb fe 0f 0b eb fe 83 f8 04 89 c6 76 dd 41 8b 04 24 e9 c6 
[  500.880074] RIP  [<ffffffff81078aac>] destroy_workqueue+0x19c/0x1e0
[  500.880074]  RSP <ffff88012587fd58>
[  500.931585] ---[ end trace 06397bea564a72fe ]---

johannes

