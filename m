Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761468Ab2FVLPA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2012 07:15:00 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:36184 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757888Ab2FVLO5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2012 07:14:57 -0400
Message-ID: <1340363755.27031.37.camel@lappy>
Subject: crypto: gpf on boot with linux-next
From: Sasha Levin <levinsasha928@gmail.com>
To: David Miller <davem@davemloft.net>, herbert@gondor.hengli.com.au
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-crypto@vger.kernel.org
Date: Fri, 22 Jun 2012 13:15:55 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

I'm seeing the following panic when booting the latest linux-next kernel:

[   44.210559] general protection fault: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
[   44.210618] CPU 0 
[   44.210618] Pid: 1, comm: swapper/0 Tainted: G        W    3.5.0-rc3-next-20120622-sasha-dirty #457  
[   44.210618] RIP: 0010:[<ffffffff811644b0>]  [<ffffffff811644b0>] __lock_acquire+0x110/0x4b0
[   44.210618] RSP: 0018:ffff89519a519aa0  EFLAGS: 00010002
[   44.210618] RAX: 6b6b6b6b6b6b6b6b RBX: ffff89519a510000 RCX: 0000000000000000
[   44.210618] RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
[   44.210618] RBP: ffff89519a519b00 R08: 0000000000000001 R09: 0000000000000001
[   44.210618] R10: 0000000000000000 R11: 0000000000000001 R12: 0000000000000002
[   44.210618] R13: ffff8951806f0a40 R14: 0000000000000000 R15: 0000000000000000
[   44.210618] FS:  0000000000000000(0000) GS:ffff89525ba00000(0000) knlGS:0000000000000000
[   44.210618] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[   44.210618] CR2: 0000000000000000 CR3: 0000000004825000 CR4: 00000000000006f0
[   44.210618] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[   44.210618] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[   44.210618] Process swapper/0 (pid: 1, threadinfo ffff89519a518000, task ffff89519a510000)
[   44.210618] Stack:
[   44.210618]  ffff89519a519ae0 ffffffff810ffa20 ffff89519a519b00 ffffffff85374700
[   44.210618]  ffffffff85374700 00000000fffd0333 ffff89519a519ae0 ffff89519a510000
[   44.210618]  0000000000000000 0000000000000002 0000000000000000 0000000000000000
[   44.210618] Call Trace:
[   44.210618]  [<ffffffff810ffa20>] ? del_timer_sync+0x120/0x140
[   44.210618]  [<ffffffff811649da>] lock_acquire+0x18a/0x1e0
[   44.210618]  [<ffffffff836fd47a>] ? wait_for_common+0x10a/0x170
[   44.210618]  [<ffffffff836ff171>] _raw_spin_lock_irq+0x61/0xa0
[   44.210618]  [<ffffffff836fd47a>] ? wait_for_common+0x10a/0x170
[   44.210618]  [<ffffffff836fd47a>] wait_for_common+0x10a/0x170
[   44.210618]  [<ffffffff81133d40>] ? try_to_wake_up+0x290/0x290
[   44.210618]  [<ffffffff836fd52e>] wait_for_completion_interruptible_timeout+0xe/0x10
[   44.210618]  [<ffffffff81913a77>] cryptomgr_schedule_probe+0x2d7/0x310
[   44.210618]  [<ffffffff81913c75>] cryptomgr_notify+0x25/0x40
[   44.210618]  [<ffffffff811231be>] notifier_call_chain+0xee/0x130
[   44.210618]  [<ffffffff811235a6>] __blocking_notifier_call_chain+0xa6/0xd0
[   44.210618]  [<ffffffff8112174e>] ? up_write+0x1e/0x40
[   44.210618]  [<ffffffff811235e1>] blocking_notifier_call_chain+0x11/0x20
[   44.210618]  [<ffffffff8190ad89>] crypto_probing_notify+0x29/0x50
[   44.210618]  [<ffffffff8190b479>] crypto_alg_mod_lookup+0x39/0x80
[   44.210618]  [<ffffffff8190b52c>] crypto_alloc_base+0x3c/0xb0
[   44.210618]  [<ffffffff851675a5>] ? af_rxrpc_init+0x1a3/0x1a3
[   44.210618]  [<ffffffff851675ed>] rxkad_init+0x48/0x69
[   44.210618]  [<ffffffff850cf639>] do_one_initcall+0x7a/0x155
[   44.210618]  [<ffffffff850cf7db>] do_basic_setup+0x9c/0xba
[   44.210618]  [<ffffffff850cf7f9>] ? do_basic_setup+0xba/0xba
[   44.210618]  [<ffffffff850f1173>] ? smp_init+0x8a/0x92
[   44.210618]  [<ffffffff850cfa5c>] kernel_init+0x208/0x28a
[   44.210618]  [<ffffffff83701e34>] kernel_thread_helper+0x4/0x10
[   44.210618]  [<ffffffff837000b4>] ? retint_restore_args+0x13/0x13
[   44.210618]  [<ffffffff850cf854>] ? repair_env_string+0x5b/0x5b
[   44.210618]  [<ffffffff83701e30>] ? gs_change+0x13/0x13
[   44.210618] Code: 4d b8 44 89 4d b0 4c 89 55 a8 4c 89 ef e8 39 b4 ff ff 8b 4d b8 48 85 c0 44 8b 4d b0 4c 8b 55 a8 0f 84 7d 03 00 00 0f 1f 44 00 00 <f0> ff 80 98 01 00 00 8b 15 27 f2 1c 04 44 8b b3 f0 08 00 00 85 
[   44.210618] RIP  [<ffffffff811644b0>] __lock_acquire+0x110/0x4b0
[   44.210618]  RSP <ffff89519a519aa0>
[   44.210618] ---[ end trace 8f6ca168297608b8 ]---

