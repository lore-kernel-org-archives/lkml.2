Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756083Ab1KNTnQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Nov 2011 14:43:16 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:62129 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754011Ab1KNTnO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Nov 2011 14:43:14 -0500
From: "Justin Piszcz" <jpiszcz@lucidpixels.com>
To: <linux-kernel@vger.kernel.org>
Cc: <ap@solarrain.com>
References: <00c001cca300$4b512b80$e1f38280$@lucidpixels.com>
In-Reply-To: <00c001cca300$4b512b80$e1f38280$@lucidpixels.com>
Subject: RE: kernel 3.1.1 - cifs issue - ls: cannot access /cifs_mnt: Cannot allocate memory
Date: Mon, 14 Nov 2011 14:43:08 -0500
Message-ID: <00d901cca305$a3175100$e945f300$@lucidpixels.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-Index: AQLZrMe+81ABFycPwSqDEaFeFY6RxpOSsVsw
Content-Language: en-us
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Unmount/remount fails, a reboot appears to be the only way to fix:

 [72000.638947] INFO: task cp:29420 blocked for more than 120 seconds.
[72000.638949] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables
this message.
[72000.638950] cp              D c32cfdb8     0 29420      1 0x00000000
[72000.638954]  c334f150 00200086 00000002 c32cfdb8 00000008 00000000
c1679000 0443da4c
[72000.638959]  c334f2b8 f77cc900 00000020 c14a8c15 00000000 00000003
f5c240c0 f5ed5a80
[72000.638964]  f5ed5a88 00011200 f5ed5a90 00000000 00011200 f5ed5a40
00011200 f5c240c0
[72000.638969] Call Trace:
[72000.638973]  [<c14a8c15>] ? cache_alloc_refill+0x6a/0x428
[72000.638976]  [<c11c3ef5>] ? wait_for_free_request+0x85/0x110
[72000.638979]  [<c10467b0>] ? abort_exclusive_wait+0x90/0x90
[72000.638982]  [<c11c4a0f>] ? SendReceive+0x7f/0x2d0
[72000.638985]  [<c11ac973>] ? CIFSSMBQPathInfo+0x123/0x240
[72000.638988]  [<c11bea9e>] ? cifs_get_inode_info+0x29e/0x3d0
[72000.638992]  [<c11b6d8c>] ? build_path_from_dentry+0x10c/0x230
[72000.638995]  [<c10a4cb8>] ? do_path_lookup+0x28/0x80
[72000.638998]  [<c11c0288>] ? cifs_revalidate_dentry_attr+0x118/0x1b0
[72000.639001]  [<c11c0370>] ? cifs_revalidate_dentry+0x20/0x20
[72000.639004]  [<c11c03be>] ? cifs_getattr+0x4e/0x110
[72000.639016]  [<c11c0370>] ? cifs_revalidate_dentry+0x20/0x20
[72000.639019]  [<c109d139>] ? vfs_getattr+0x19/0x40
[72000.639021]  [<c109d1bd>] ? vfs_fstatat+0x5d/0x80
[72000.639024]  [<c109d218>] ? vfs_stat+0x18/0x20
[72000.639027]  [<c109d47e>] ? sys_stat64+0xe/0x30
[72000.639031]  [<c10899d7>] ? remove_vma+0x37/0x50
[72000.639035]  [<c108a80a>] ? do_munmap+0x16a/0x2b0
[72000.639038]  [<c1003930>] ? math_state_restore+0x40/0x40
[72000.639042]  [<c1009b23>] ? fpu_finit+0x23/0x70
[72000.639046]  [<c1009bb9>] ? init_fpu+0x49/0x150
[72000.639049]  [<c101f3f0>] ? vmalloc_sync_all+0x140/0x140
[72000.639053]  [<c14af310>] ? sysenter_do_call+0x12/0x26
[72000.639057] INFO: task cp:29422 blocked for more than 120 seconds.
[72000.639059] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables
this message.
[72000.639062] cp              D c3199db8     0 29422      1 0x00000000
[72000.639067]  c334ee00 00200082 00000002 c3199db8 00000008 00000000
c1679000 0443dcf6
[72000.639076]  c334ef68 f77cca00 00000021 c14a8c15 00000000 00000003
f5c240c0 f5ed5a80
[72000.639086]  f5ed5a88 00011200 f5ed5a90 00000000 00011200 f5ed5a40
00011200 f5c240c0
[72000.639095] Call Trace:
[72000.639099]  [<c14a8c15>] ? cache_alloc_refill+0x6a/0x428
[72000.639104]  [<c11c3ef5>] ? wait_for_free_request+0x85/0x110
[72000.639109]  [<c10467b0>] ? abort_exclusive_wait+0x90/0x90
[72000.639113]  [<c11c4a0f>] ? SendReceive+0x7f/0x2d0
[72000.639116]  [<c11ac973>] ? CIFSSMBQPathInfo+0x123/0x240
[72000.639121]  [<c11bea9e>] ? cifs_get_inode_info+0x29e/0x3d0
[72000.639125]  [<c11b6d8c>] ? build_path_from_dentry+0x10c/0x230
[72000.639129]  [<c10a4cb8>] ? do_path_lookup+0x28/0x80
[72000.639133]  [<c11c0288>] ? cifs_revalidate_dentry_attr+0x118/0x1b0
[72000.639138]  [<c11c0370>] ? cifs_revalidate_dentry+0x20/0x20
[72000.639141]  [<c11c03be>] ? cifs_getattr+0x4e/0x110
[72000.639145]  [<c11c0370>] ? cifs_revalidate_dentry+0x20/0x20
[72000.639149]  [<c109d139>] ? vfs_getattr+0x19/0x40
[72000.639153]  [<c109d1bd>] ? vfs_fstatat+0x5d/0x80
[72000.639157]  [<c109d218>] ? vfs_stat+0x18/0x20
[72000.639160]  [<c109d47e>] ? sys_stat64+0xe/0x30
[72000.639164]  [<c10899d7>] ? remove_vma+0x37/0x50
[72000.639168]  [<c108a80a>] ? do_munmap+0x16a/0x2b0
[72000.639172]  [<c1003930>] ? math_state_restore+0x40/0x40
[72000.639176]  [<c1009b23>] ? fpu_finit+0x23/0x70
[72000.639179]  [<c1009bb9>] ? init_fpu+0x49/0x150
[72000.639183]  [<c101f3f0>] ? vmalloc_sync_all+0x140/0x140
[72000.639187]  [<c14af310>] ? sysenter_do_call+0x12/0x26
[72012.028045] CIFS VFS: Server 192.168.0.20 has not responded in 300
seconds. Reconnecting...
[104345.704201] CIFS VFS: Send error in SessSetup = -12
[104345.704235] CIFS VFS: cifs_mount failed w/return code = -12
[104361.549636] CIFS VFS: Send error in SessSetup = -12
[104361.549726] CIFS VFS: cifs_mount failed w/return code = -12

Justin.



