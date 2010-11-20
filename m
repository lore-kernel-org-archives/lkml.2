Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753190Ab0KTVCd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Nov 2010 16:02:33 -0500
Received: from fr.prnet.org ([188.165.216.122]:57530 "EHLO fr.prnet.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752193Ab0KTVCb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Nov 2010 16:02:31 -0500
X-Greylist: delayed 1407 seconds by postgrey-1.27 at vger.kernel.org; Sat, 20 Nov 2010 16:02:31 EST
Message-ID: <4CE831E6.8040903@prnet.org>
Date: Sat, 20 Nov 2010 21:39:02 +0100
From: David Arendt <admin@prnet.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.12) Gecko/20101029 Lightning/1.0b3pre Thunderbird/3.1.6
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: nfs mounting problem on kernel 2.6.36
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I have the following problem mounting an nfs device on kernel 2.6.36 
(amd64). The nfs server is Windows Services for Unix on Windows XP. The 
mount command was: mount fs01:e /mnt

Thanks in advance
Bye,
David Arendt

BUG: unable to handle kernel NULL pointer dereference at 0000000000000090
IP: [<ffffffff814c869f>] rpcauth_refreshcred+0x1f/0x1c0
PGD 6ce12067 PUD c8136067 PMD 0
Oops: 0000 [#3] PREEMPT SMP
last sysfs file: 
/sys/devices/pci0000:00/0000:00:1d.0/usb6/6-1/6-1:1.0/uevent
CPU 1
Modules linked in: nvidia(P)

Pid: 10827, comm: mount.nfs Tainted: P      D     2.6.36server #3 
P5QL-E/P5QL-E
RIP: 0010:[<ffffffff814c869f>]  [<ffffffff814c869f>] 
rpcauth_refreshcred+0x1f/0x1c0
RSP: 0018:ffff880040f15b58  EFLAGS: 00010292
RAX: ffffffff816772e0 RBX: ffff88012ff24480 RCX: 0000000000000006
RDX: ffff88012dbcebc0 RSI: ffff88000188ef60 RDI: ffff88012ff24480
RBP: ffff88012ff244f0 R08: ffff880040f14000 R09: ffffffff817740b0
R10: 0000aa006c4c11da R11: 0000000000000000 R12: 0000000000000000
R13: 0000000000000000 R14: ffff88012dbcead8 R15: ffff8800210ef300
FS:  00007fa721e4b700(0000) GS:ffff880001880000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000000090 CR3: 0000000084a3b000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process mount.nfs (pid: 10827, threadinfo ffff880040f14000, task 
ffff880095379220)
Stack:
  ffffffff810735e0 ffff880040f15b60 ffff880040f15b60 ffff88012ff24480
<0> ffff88012ff244f0 ffff88012ff24480 ffff88012ff244f0 0000000000000000
<0> 0000000000000000 ffffffff814c7210 0000000000000000 ffff88012ff24480
Call Trace:
  [<ffffffff810735e0>] ? wake_bit_function+0x0/0x40
  [<ffffffff814c7210>] ? __rpc_execute+0x70/0x220
  [<ffffffff814c0355>] ? rpc_run_task+0xd5/0x130
  [<ffffffff814c04ab>] ? rpc_call_sync+0x3b/0x70
  [<ffffffff81177525>] ? T.883+0x25/0x70
  [<ffffffff81178a83>] ? nfs3_proc_pathconf+0x43/0x90
  [<ffffffff81161525>] ? nfs_probe_fsinfo+0x4d5/0x5b0
  [<ffffffff81160f50>] ? nfs_init_server_rpcclient+0x30/0x130
  [<ffffffff81162647>] ? nfs_create_server+0x387/0x620
  [<ffffffff8116c9cd>] ? nfs_get_sb+0x36d/0xb90
  [<ffffffff810cf95c>] ? vfs_kern_mount+0x6c/0x160
  [<ffffffff810e661e>] ? get_fs_type+0x3e/0xd0
  [<ffffffff810cfac3>] ? do_kern_mount+0x53/0x130
  [<ffffffff810e9d3b>] ? do_mount+0x2eb/0x870
  [<ffffffff810ea35a>] ? sys_mount+0x9a/0x100
  [<ffffffff8102b36b>] ? system_call_fastpath+0x16/0x1b
Code: ff 66 66 2e 0f 1f 84 00 00 00 00 00 48 83 ec 48 48 89 5c 24 28 48 
89 6c 24 30 4c 89 64 24 38 4c 89 6c 24 40 48 89 fb 4c 8b 67 20 <49> 8b 
ac 24 90 00 00 00 48 85 ed 74 54 f6 05 a5 bd 2d 00 10 0f
RIP  [<ffffffff814c869f>] rpcauth_refreshcred+0x1f/0x1c0
  RSP <ffff880040f15b58>
CR2: 0000000000000090
---[ end trace d0e0b9fa5e85ce98 ]---

