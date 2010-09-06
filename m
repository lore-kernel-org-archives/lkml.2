Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755219Ab0IFDYS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Sep 2010 23:24:18 -0400
Received: from nessie.weebeastie.net ([220.233.7.36]:52601 "EHLO
	bunyip.billabong.weebeastie.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755161Ab0IFDYR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Sep 2010 23:24:17 -0400
X-Greylist: delayed 2142 seconds by postgrey-1.27 at vger.kernel.org; Sun, 05 Sep 2010 23:24:16 EDT
Date: Mon, 6 Sep 2010 12:48:29 +1000
From: AP <ap@zip.com.au>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org
Subject: 2.6.35.2, .4 and 36-rc3: gpf from proc/libvirtd when starting guest
Message-ID: <20100906024829.GC12684@zip.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have a guest that I can start that causes 2.6.35.2, 2.6.35.4 and
2.6.36-rc3 to lock up. I've only been able to get a full crash out
of .2 though. I can start other guests without problems, it seems
and the major difference between them and this one is that the one
that causes the crash runs asterisk. This crash happens on a cleanly
rebooted system and occurs even if the crash-causing guest is the only
one started.

The box is a dual core intel with 4gb of ram and .config for the kernel
is attached.

qemu-kvm 0.12.5 is in use with libvirtd 0.8.3. Guests are started as a
non-root user.

Not sure what other info to provide so please shout.

kernel: [238426.129396] general protection fault: 0000 [#1] SMP
kernel: [238426.129530] last sysfs file: /sys/devices/system/cpu/cpu1/topology/thread_siblings
kernel: [238426.129611] CPU 1
kernel: [238426.129701] Pid: 1837, comm: libvirtd Not tainted 2.6.35.2-moocow.20100819-114947 #17 S3000AH/
kernel: [238426.129789] RIP: 0010:[<ffffffff8110fa97>]  [<ffffffff8110fa97>] get_vmalloc_info+0x6b/0xc4
kernel: [238426.129914] RSP: 0018:ffff8801198c3bb8  EFLAGS: 00010206
kernel: [238426.129980] RAX: 4602e9dc00000000 RBX: ffff8801198c3dd8 RCX: ffffc900052be000
kernel: [238426.130060] RDX: 0000000000000000 RSI: ffffe8fffffffffe RDI: ffffc8ffffffffff
kernel: [238426.130143] RBP: ffff8801198c3bc8 R08: 000000000005e000 R09: 0000000000000000
kernel: [238426.130223] R10: 0000000000000022 R11: 0000000000000202 R12: ffff880023f7e8c0
kernel: [238426.130305] R13: ffff880116636740 R14: 0000000000000001 R15: 000000000004e653
kernel: [238426.130387] FS:  00007ff7524c0710(0000) GS:ffff880001c80000(0000) knlGS:0000000000000000
kernel: [238426.130474] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
kernel: [238426.130536] CR2: 00007ff757d9a000 CR3: 00000001194ab000 CR4: 00000000000026f0
kernel: [238426.130622] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
kernel: [238426.130709] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
kernel: [238426.130792] Process libvirtd (pid: 1837, threadinfo ffff8801198c2000, task ffff88011be578d0)
kernel: [238426.130882] Stack:
kernel: [238426.130936]  ffff8801198c3bc8 000000000015be8b ffff8801198c3e18 ffffffff81116f52
kernel: [238426.131106] <0> ffff880119b951c0 0000000000000000 0000000000000000 0000000000000202
kernel: [238426.131355] <0> ffff8801198c3c18 0000000000000000 ffff880023f7e8c0 ffff88008ef456e0
kernel: [238426.131658] Call Trace:
kernel: [238426.131715]  [<ffffffff81116f52>] meminfo_proc_show+0xa5/0x463
kernel: [238426.131777]  [<ffffffff810e3a3f>] ? seq_open+0x68/0x89
kernel: [238426.131839]  [<ffffffff81116ead>] ? meminfo_proc_show+0x0/0x463
kernel: [238426.131908]  [<ffffffff810e3b2c>] ? single_open+0x5d/0x89
kernel: [238426.131972]  [<ffffffff81652f1e>] ? _raw_spin_lock+0x9/0xd
kernel: [238426.132034]  [<ffffffff81110fbd>] ? proc_reg_open+0x123/0x137
kernel: [238426.132100]  [<ffffffff81116e96>] ? meminfo_proc_open+0x0/0x17
kernel: [238426.132166]  [<ffffffff81110e9a>] ? proc_reg_open+0x0/0x137
kernel: [238426.132230]  [<ffffffff810ca8cd>] ? __dentry_open+0x10a/0x1fd
kernel: [238426.132290]  [<ffffffff812b38e8>] ? rb_insert_color+0x68/0xe5
kernel: [238426.132356]  [<ffffffff810b071d>] ? mmap_region+0x3cd/0x4fb
kernel: [238426.132417]  [<ffffffff810e380e>] seq_read+0x162/0x32b
kernel: [238426.132479]  [<ffffffff81111435>] proc_reg_read+0x87/0xa6
kernel: [238426.132502]  [<ffffffff810e36ac>] ? seq_read+0x0/0x32b
kernel: [238426.132502]  [<ffffffff810cc4da>] vfs_read+0xaa/0x14b
kernel: [238426.132502]  [<ffffffff810cc634>] sys_read+0x45/0x6c
kernel: [238426.132502]  [<ffffffff810229c2>] system_call_fastpath+0x16/0x1b
kernel: [238426.132502] Code: 28 35 54 00 48 8b 05 d1 d5 8f 00 48 b9 00 00 00 00 00 c9 ff ff 48 bf ff ff ff ff ff c8 ff ff 48 be fe ff ff ff ff e8 ff ff eb 2f <48> 8b 50 08 48 39 fa 76 23 48 39 f2 77 26 4c 8b 40 10 4c 01 03
kernel: [238426.132502] RIP  [<ffffffff8110fa97>] get_vmalloc_info+0x6b/0xc4
kernel: [238426.132502]  RSP <ffff8801198c3bb8>
kernel: [238426.135352] ---[ end trace cabe8f8b4800a6b8 ]---
kernel: [238426.586185] FWD: IN=br0 OUT=br0 PHYSIN=eth0 PHYSOUT=itap4 SRC=58.96.1.2 DST=220.233.2.70 LEN=459 TOS=0x10 PREC=0x00 TTL=61 ID=0 DF PROTO=UDP SPT=5060 DPT=5060 LEN=439
kernel: [238426.606518] general protection fault: 0000 [#2] SMP
kernel: [238426.606652] last sysfs file: /sys/devices/system/cpu/cpu1/topology/thread_siblings
kernel: [238426.606731] CPU 1
kernel: [238426.606829] Pid: 1840, comm: libvirtd Tainted: G      D     2.6.35.2-moocow.20100819-114947 #17 S3000AH/
kernel: [238426.606915] RIP: 0010:[<ffffffff8110fa97>]  [<ffffffff8110fa97>] get_vmalloc_info+0x6b/0xc4
kernel: [238426.607034] RSP: 0018:ffff88011aca7bb8  EFLAGS: 00010206
kernel: [238426.607096] RAX: 4602e9dc00000000 RBX: ffff88011aca7dd8 RCX: ffffc900052be000
kernel: [238426.607175] RDX: 0000000000000000 RSI: ffffe8fffffffffe RDI: ffffc8ffffffffff
kernel: [238426.607254] RBP: ffff88011aca7bc8 R08: 000000000005e000 R09: 0000000000000000
kernel: [238426.607332] R10: 0000000000000022 R11: 0000000000000202 R12: ffff880023f7e980
kernel: [238426.607411] R13: ffff8801166366c0 R14: 0000000000000001 R15: 000000000004e87f
kernel: [238426.607492] FS:  00007ff750cbd710(0000) GS:ffff880001c80000(0000) knlGS:0000000000000000
kernel: [238426.607582] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
kernel: [238426.607644] CR2: 00007ff757d99000 CR3: 00000001194ab000 CR4: 00000000000026f0
kernel: [238426.607727] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
kernel: [238426.607809] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
kernel: [238426.607893] Process libvirtd (pid: 1840, threadinfo ffff88011aca6000, task ffff88011be8f280)
kernel: [238426.607978] Stack:
kernel: [238426.608035]  ffff88011aca7bc8 000000000015beed ffff88011aca7e18 ffffffff81116f52
kernel: [238426.608215] <0> ffff880119b951c0 ffff8800100091e0 ffff8801198b25f0 0000000000000202
kernel: [238426.608461] <0> ffff88011aca7cb8 0000000000000000 ffff880023f7e980 ffff88008ef45680
kernel: [238426.608502] Call Trace:
kernel: [238426.608502]  [<ffffffff81116f52>] meminfo_proc_show+0xa5/0x463
kernel: [238426.608502]  [<ffffffff810e3a3f>] ? seq_open+0x68/0x89
kernel: [238426.608502]  [<ffffffff81116ead>] ? meminfo_proc_show+0x0/0x463
kernel: [238426.608502]  [<ffffffff810e3b2c>] ? single_open+0x5d/0x89
kernel: [238426.608502]  [<ffffffff81652f1e>] ? _raw_spin_lock+0x9/0xd
kernel: [238426.608502]  [<ffffffff81652f1e>] ? _raw_spin_lock+0x9/0xd
kernel: [238426.608502]  [<ffffffff81110fbd>] ? proc_reg_open+0x123/0x137
kernel: [238426.608502]  [<ffffffff81116e96>] ? meminfo_proc_open+0x0/0x17
kernel: [238426.608502]  [<ffffffff81110e9a>] ? proc_reg_open+0x0/0x137
kernel: [238426.608502]  [<ffffffff810b071d>] ? mmap_region+0x3cd/0x4fb
kernel: [238426.608502]  [<ffffffff810e380e>] seq_read+0x162/0x32b
kernel: [238426.608502]  [<ffffffff81111435>] proc_reg_read+0x87/0xa6
kernel: [238426.608502]  [<ffffffff810e36ac>] ? seq_read+0x0/0x32b
kernel: [238426.608502]  [<ffffffff810cc4da>] vfs_read+0xaa/0x14b
kernel: [238426.608502]  [<ffffffff810cc634>] sys_read+0x45/0x6c
kernel: [238426.608502]  [<ffffffff810229c2>] system_call_fastpath+0x16/0x1b
kernel: [238426.608502] Code: 28 35 54 00 48 8b 05 d1 d5 8f 00 48 b9 00 00 00 00 00 c9 ff ff 48 bf ff ff ff ff ff c8 ff ff 48 be fe ff ff ff ff e8 ff ff eb 2f <48> 8b 50 08 48 39 fa 76 23 48 39 f2 77 26 4c 8b 40 10 4c 01 03
kernel: [238426.608502] RIP  [<ffffffff8110fa97>] get_vmalloc_info+0x6b/0xc4
kernel: [238426.608502]  RSP <ffff88011aca7bb8>
kernel: [238426.612369] ---[ end trace cabe8f8b4800a6b9 ]---

ap
