Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755328Ab0GNNxm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jul 2010 09:53:42 -0400
Received: from smtp-out-223.synserver.de ([212.40.180.223]:1229 "HELO
	smtp-out-223.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753612Ab0GNNxk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jul 2010 09:53:40 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: markus@trippelsdorf.de
X-SynServer-PPID: 4497
Date: Wed, 14 Jul 2010 15:52:17 +0200
From: Markus Trippelsdorf <markus@trippelsdorf.de>
To: jaxboe@fusionio.com
Cc: linux-kernel@vger.kernel.org
Subject: kernel BUG at fs/block_dev.c:765!
Message-ID: <20100714135217.GA1797@arch.tripp.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

My machine just hanged (while browsing the web).
After reboot I've found this in the logs:

Jul 14 15:29:13 arch kernel: ------------[ cut here ]------------
Jul 14 15:29:13 arch kernel: kernel BUG at fs/block_dev.c:765!
Jul 14 15:29:13 arch kernel: invalid opcode: 0000 [#1] SMP
Jul 14 15:29:13 arch kernel: last sysfs file: /sys/devices/virtual/vc/vcsa9/uevent
Jul 14 15:29:13 arch kernel: CPU 0
Jul 14 15:29:13 arch kernel: Pid: 10176, comm: mount Not tainted 2.6.35-rc5-00006-gc9cc066 #26 M4A78T-E/System Product Name
Jul 14 15:29:13 arch kernel: RIP: 0010:[<ffffffff810f66bf>]  [<ffffffff810f66bf>] __bd_abort_claiming+0x17/0x40
Jul 14 15:29:13 arch kernel: RSP: 0018:ffff8800c9109d18  EFLAGS: 00010207
Jul 14 15:29:13 arch kernel: RAX: 000000000000c3c3 RBX: ffff88012fb65380 RCX: 0000000000000002
Jul 14 15:29:13 arch kernel: RDX: 0000000000000003 RSI: ffffffff8182f060 RDI: ffff88012fb65380
Jul 14 15:29:13 arch kernel: RBP: ffff8800c9109d28 R08: ffff8800c9109b68 R09: ffffffff81877e68
Jul 14 15:29:13 arch kernel: R10: ffff8800c9109cb8 R11: 0000000000000010 R12: ffff88012fb65380
Jul 14 15:29:13 arch kernel: R13: 0000000000000001 R14: ffffffff8182f060 R15: 00000000ffffff85
Jul 14 15:29:13 arch kernel: FS:  00007fd86f721740(0000) GS:ffff880001a00000(0000) knlGS:0000000000000000
Jul 14 15:29:13 arch kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
Jul 14 15:29:13 arch kernel: CR2: 00007ffce705e000 CR3: 000000001051d000 CR4: 00000000000006f0
Jul 14 15:29:13 arch kernel: DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Jul 14 15:29:13 arch kernel: DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Jul 14 15:29:13 arch kernel: Process mount (pid: 10176, threadinfo ffff8800c9108000, task ffff88012ef82c20)
Jul 14 15:29:13 arch kernel: Stack:
Jul 14 15:29:13 arch kernel: ffff8800c9109d28 ffffffffffffff85 ffff8800c9109d68 ffffffff810f7b64
Jul 14 15:29:13 arch kernel: <0> ffff8800c9109d98 0000000000000001 ffffffff8182f060 0000000000000001
Jul 14 15:29:13 arch kernel: <0> ffff8800cbfec000 ffffffff8182f060 ffff8800c9109de8 ffffffff810d3da2
Jul 14 15:29:13 arch kernel: Call Trace:
Jul 14 15:29:13 arch kernel: [<ffffffff810f7b64>] open_bdev_exclusive+0xb3/0xc3
Jul 14 15:29:13 arch kernel: [<ffffffff810d3da2>] get_sb_bdev+0x47/0x178
Jul 14 15:29:13 arch kernel: [<ffffffff81131214>] ? ext4_fill_super+0x0/0x208d
Jul 14 15:29:13 arch kernel: [<ffffffff8112e6b2>] ext4_get_sb+0x18/0x1a
Jul 14 15:29:13 arch kernel: [<ffffffff810d40a7>] vfs_kern_mount+0x62/0xff
Jul 14 15:29:13 arch kernel: [<ffffffff810d4313>] do_kern_mount+0x4d/0xef
Jul 14 15:29:13 arch kernel: [<ffffffff810e86a5>] do_mount+0x6cb/0x744
Jul 14 15:29:13 arch kernel: [<ffffffff810e87f3>] sys_mount+0x8c/0xcd
Jul 14 15:29:13 arch kernel: [<ffffffff8102b93b>] system_call_fastpath+0x16/0x1b
Jul 14 15:29:13 arch kernel: Code: c7 c3 f4 ff ff ff 5e 5f 48 89 d8 5b 41 5c 41 5d 41 5e c9 c3 55 48 89 e5 53 48 83 ec 08 e8 0a 50 f3 ff 48 39 77 50 48 89 fb 74 02 <0f> 0b 48 c7 47 50 00 00 00 00 48 8d 7f 50 31 f6 e8 8b ad f7 ff
Jul 14 15:29:13 arch kernel: RIP  [<ffffffff810f66bf>] __bd_abort_claiming+0x17/0x40
Jul 14 15:29:13 arch kernel: RSP <ffff8800c9109d18>
Jul 14 15:29:13 arch kernel: ---[ end trace e3e601b81dcec19b ]---

-- 
Markus
