Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753260Ab2H1Pxc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2012 11:53:32 -0400
Received: from thumper2.emsphone.com ([199.67.51.102]:36281 "EHLO
	thumper2.allantgroup.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752909Ab2H1Pxa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2012 11:53:30 -0400
X-Greylist: delayed 943 seconds by postgrey-1.27 at vger.kernel.org; Tue, 28 Aug 2012 11:53:30 EDT
Message-ID: <503CE5CA.1060900@allantgroup.com>
Date: Tue, 28 Aug 2012 10:37:46 -0500
From: genanr <aryan@allantgroup.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.2) Gecko/20120216 Thunderbird/10.0.2
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: BUG jbd2/transaction.c:332
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I am often hitting this BUG on an OCFS2 volume shared among 6 machines.  
Not only does this bug cause the kernel panic on the machine it occurs 
on, but when it happens it block access to that volume from the other 
machines connected to it until the problem machine is rebooted.  The 
machine it occurs on varies and it seems to happen during high I/O.  
Below is the panic message, kernel 3.0.38.

Any help would be appreciated,

Andy



Aug 28 07:00:22 sapblade08 kernel: ------------[ cut here ]------------
Aug 28 07:00:22 sapblade08 kernel: kernel BUG at fs/jbd2/transaction.c:332!
Aug 28 07:00:22 sapblade08 kernel: invalid opcode: 0000 [#1] SMP
Aug 28 07:00:22 sapblade08 kernel: CPU 0
Aug 28 07:00:22 sapblade08 kernel: Modules linked in: nls_utf8 ocfs2 
ocfs2_dlmfs ocfs2_stack_o2cb ocfs2_dlm ocfs2_nodemanager ocfs2_stackglue 
configfs bonding microcode md_mod sr_mod cdrom dcdbas qla2xxx
Aug 28 07:00:22 sapblade08 kernel:
Aug 28 07:00:22 sapblade08 kernel: Pid: 13777, comm: chattr Not tainted 
3.0.38 #1 Dell Inc. PowerEdge M710HD/037M3H
Aug 28 07:00:22 sapblade08 kernel: RIP: 0010:[<ffffffff811a445c>]  
[<ffffffff811a445c>] jbd2__journal_start+0xdc/0xe0
Aug 28 07:00:22 sapblade08 kernel: RSP: 0018:ffff880456049978  EFLAGS: 
00010287
Aug 28 07:00:22 sapblade08 kernel: RAX: ffff880bfee4b980 RBX: 
ffff880496866fd8 RCX: 000000001c725e9b
Aug 28 07:00:22 sapblade08 kernel: RDX: 0000000000000050 RSI: 
000000000000c0002 RDI: ffff880bf7fe4800
Aug 28 07:00:22 sapblade08 kernel: RBP: ffff880bf7fe4800 R08: 
ffff880456049fd8 R09: 0000000000000001
Aug 28 07:00:22 sapblade08 kernel: R10: 0000000000000040 R11: 
dead000000200200 R12: ffff880bf4d42c90
Aug 28 07:00:22 sapblade08 kernel: R13: 0000000000000002 R14: 
0000000000000050 R15: 000000001c725e9b
Aug 28 07:00:22 sapblade08 kernel: FS:  0000000000000000(0000) 
GS:ffff880c2fc00000(0000) knlGS:0000000000000000
Aug 28 07:00:22 sapblade08 kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 
0000000080050033
Aug 28 07:00:22 sapblade08 kernel: CR2: 00007f9efd9d1560 CR3: 
0000000001787000 CR4: 00000000000006f0
Aug 28 07:00:22 sapblade08 kernel: DR0: 0000000000000000 DR1: 
0000000000000000 DR2: 0000000000000000
Aug 28 07:00:22 sapblade08 kernel: DR3: 0000000000000000 DR6: 
00000000ffff0ff0 DR7: 0000000000000400
Aug 28 07:00:22 sapblade08 kernel: Process chattr (pid: 13777, 
threadinfo ffff880456048000, task ffff880bf4d42c90)
Aug 28 07:00:22 sapblade08 kernel: Stack:
Aug 28 07:00:22 sapblade08 kernel:  ffff880bf7f53c00 ffff880bf7fe4800 
0000000000000001 00000000503cb2d6
Aug 28 07:00:22 sapblade08 kernel:  0000000000000002 ffffffff81182daa 
0000000001f86570 ffff880456049b28
Aug 28 07:00:22 sapblade08 kernel:  ffff880a1b9ce4f8 0000000000000000 
ffff880a1b9ce448 0000000000000000
Aug 28 07:00:22 sapblade08 kernel: Call Trace:
Aug 28 07:00:22 sapblade08 kernel:  [<ffffffff81182daa>] ? 
ext4_journal_start_sb+0x5a/0x150
Aug 28 07:00:22 sapblade08 kernel:  [<ffffffff8116e65f>] ? 
ext4_dirty_inode+0x1f/0x70
Aug 28 07:00:22 sapblade08 kernel:  [<ffffffff811076aa>] ? 
__mark_inode_dirty+0x3a/0x220
Aug 28 07:00:22 sapblade08 kernel:  [<ffffffff810fbd21>] ? 
file_update_time+0x111/0x190
Aug 28 07:00:22 sapblade08 kernel:  [<ffffffff810a2206>] ? 
__generic_file_aio_write+0x246/0x460
Aug 28 07:00:22 sapblade08 kernel:  [<ffffffff810a2478>] ? 
generic_file_aio_write+0x58/0xc0
Aug 28 07:00:22 sapblade08 kernel:  [<ffffffff8116a0d1>] ? 
ext4_file_write+0x71/0x2e0
Aug 28 07:00:22 sapblade08 kernel:  [<ffffffff810e4300>] ? 
do_sync_write+0xc0/0x100
Aug 28 07:00:22 sapblade08 kernel:  [<ffffffff810aba5a>] ? 
release_pages+0x20a/0x240
Aug 28 07:00:22 sapblade08 kernel:  [<ffffffff810779b1>] ? 
do_acct_process+0x471/0x690
Aug 28 07:00:22 sapblade08 kernel:  [<ffffffff810c2adb>] ? 
remove_vma+0x5b/0x80
Aug 28 07:00:22 sapblade08 kernel:  [<ffffffff810c2be8>] ? 
exit_mmap+0xe8/0x110
Aug 28 07:00:22 sapblade08 kernel:  [<ffffffff81077c09>] ? 
acct_process+0x39/0xa0
Aug 28 07:00:22 sapblade08 kernel:  [<ffffffff810493fd>] ? 
do_exit+0x7bd/0x870
Aug 28 07:00:22 sapblade08 kernel:  [<ffffffff810494e9>] ? 
do_group_exit+0x39/0xb0
Aug 28 07:00:22 sapblade08 kernel:  [<ffffffff81049572>] ? 
sys_exit_group+0x12/0x20
Aug 28 07:00:22 sapblade08 kernel:  [<ffffffff815835fb>] ? 
system_call_fastpath+0x16/0x1b
Aug 28 07:00:22 sapblade08 kernel: Code: 48 63 dd e8 57 60 f3 ff 49 c7 
84 24 c0 04 00 00 00 00 00 00 e9 7b ff ff ff 66 0f 1f 44 00 00 48 c7 c3 
f4 ff ff ff e9 69 ff ff ff <0f> 0b eb fe ba 50 00 00 00 e9 16 ff ff ff 
66 0f 1f 44 00 00 48
Aug 28 07:00:22 sapblade08 kernel: RIP  [<ffffffff811a445c>] 
jbd2__journal_start+0xdc/0xe0
Aug 28 07:00:22 sapblade08 kernel:  RSP <ffff880456049978>
Aug 28 07:00:22 sapblade08 kernel: ---[ end trace fe7e5fff1f9958fb ]---
