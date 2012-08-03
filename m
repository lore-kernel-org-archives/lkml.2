Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753486Ab2HCOSH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2012 10:18:07 -0400
Received: from www262.sakura.ne.jp ([202.181.97.72]:55531 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753043Ab2HCOSD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2012 10:18:03 -0400
X-Nat-Received: from [202.181.97.72]:54005 [ident-empty]
	by smtp-proxy.isp with TPROXY id 1344003482.19447
To: linux-kernel@vger.kernel.org
Subject: [3.6-rc1] sched: clock counts too quickly
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Message-Id: <201208032318.FGJ64576.tOMVLOFHFQOFJS@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.51 PL2]
X-Accept-Language: ja,en,zh
Date: Fri, 3 Aug 2012 23:18:02 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Anti-Virus: Kaspersky Anti-Virus for Linux Mail Server 5.6.45.2/RELEASE, bases: 03082012 #8324146, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Under unknown condition, clock starts counting up too quickly which is enough
to confuse hangcheck timer to print stall warning.

I don't know the condition but it seems that
"[sched_delayed] sched: RT throttling activated" message is printed
when time jump starts and the CPU usage is high (running my testing program).

Below are examples which happened within a few minutes despite the timestamp
field of the log.

Example 1:

[  516.710080] EXT4-fs (ram0): mounting ext2 file system using the ext4 subsystem
[  516.721264] EXT4-fs (ram0): mounted filesystem without journal. Opts: (null)
[  517.118131] warning: process `ccs_file_test' used the deprecated sysctl system call with 3.5.56.
[ 1617.117747] [sched_delayed] sched: RT throttling activated
[ 1636.759901] EXT4-fs (ram0): mounting ext2 file system using the ext4 subsystem
[ 1636.764755] EXT4-fs (ram0): mounted filesystem without journal. Opts: (null)
[ 1644.236465] BUG: soft lockup - CPU#0 stuck for 23s! [swapper/0:0]
[ 1644.236503] Modules linked in: ipv6 binfmt_misc ccsecurity
[ 1644.236503] irq event stamp: 2190088
[ 1644.236503] hardirqs last  enabled at (2190087): [<c109ee94>] rcu_idle_exit+0x54/0xc0
[ 1644.236503] hardirqs last disabled at (2190088): [<c13ed3a0>] _raw_spin_lock_irq+0x10/0x80
[ 1644.236503] softirqs last  enabled at (2190084): [<c103a7b2>] __do_softirq+0xf2/0x160
[ 1644.236503] softirqs last disabled at (2190053): [<c1004d07>] do_softirq+0x87/0xd0
[ 1644.236503] Pid: 0, comm: swapper/0 Not tainted 3.6.0-rc1 #1 VMware, Inc. VMware Virtual Platform/440BX Desktop Reference Platform
[ 1644.236503] EIP: 0060:[<c1009f71>] EFLAGS: 00000246 CPU: 0
[ 1644.236503] EIP is at default_idle+0x21/0x40
[ 1644.236503] EAX: 00000000 EBX: ffffffff ECX: 00000000 EDX: 00000000
[ 1644.236503] ESI: c15ae3b0 EDI: 01d8d000 EBP: c156df98 ESP: c156df98
[ 1644.236503]  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
[ 1644.236503] CR0: 8005003b CR2: b75df9db CR3: 17185000 CR4: 000006d0
[ 1644.236503] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
[ 1644.236503] DR6: ffff0ff0 DR7: 00000400

Example 2:

[  125.371118]  [<c13ee58c>] sysenter_do_call+0x12/0x32
[  138.869458] EXT4-fs (ram0): mounting ext2 file system using the ext4 subsystem
[  138.881184] EXT4-fs (ram0): mounted filesystem without journal. Opts: (null)
[  139.222763] warning: process `ccs_file_test' used the deprecated sysctl system call with 3.5.56.
[ 1239.068731] [sched_delayed] sched: RT throttling activated
[ 2356.123229] EXT4-fs (ram0): mounting ext2 file system using the ext4 subsystem
[ 2356.125715] EXT4-fs (ram0): mounted filesystem without journal. Opts: (null)
[ 2484.942962] EXT4-fs (ram0): mounting ext2 file system using the ext4 subsystem
[ 2484.947182] EXT4-fs (ram0): mounted filesystem without journal. Opts: (null)
[ 3602.556243] EXT4-fs (ram0): mounting ext2 file system using the ext4 subsystem
[ 3602.566267] EXT4-fs (ram0): mounted filesystem without journal. Opts: (null)
[ 3834.980066] EXT4-fs (ram0): mounting ext2 file system using the ext4 subsystem
[ 3834.983705] EXT4-fs (ram0): mounted filesystem without journal. Opts: (null)
[ 3855.531019] EXT4-fs (ram0): mounting ext2 file system using the ext4 subsystem
[ 3855.535266] EXT4-fs (ram0): mounted filesystem without journal. Opts: (null)
[ 3898.597722] EXT4-fs (ram0): mounting ext2 file system using the ext4 subsystem
[ 3898.601656] EXT4-fs (ram0): mounted filesystem without journal. Opts: (null)
[ 6117.070638] EXT4-fs (ram0): mounting ext2 file system using the ext4 subsystem
[ 6117.073990] EXT4-fs (ram0): mounted filesystem without journal. Opts: (null)
[ 6136.209395] BUG: soft lockup - CPU#0 stuck for 22s! [ccs_cond_test:8618]
[ 6136.209441] Modules linked in: ipv6 binfmt_misc ccsecurity
[ 6136.209441] irq event stamp: 0
[ 6136.209441] hardirqs last  enabled at (0): [<  (null)>]   (null)
[ 6136.209441] hardirqs last disabled at (0): [<c1030add>] copy_process+0x26d/0xf30
[ 6136.209441] softirqs last  enabled at (0): [<c1030add>] copy_process+0x26d/0xf30

Config is at http://I-love.SAKURA.ne.jp/tmp/config-3.6-rc1 .

Regards.
