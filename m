Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753986Ab1HSMZb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Aug 2011 08:25:31 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:48633 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753420Ab1HSMZ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Aug 2011 08:25:28 -0400
Message-ID: <C3F04976DA604F6CA3949E98B2A7B832@avitech.sk>
From: "Peter Hanzel" <hanzelpeter@gmail.com>
To: <linux-kernel@vger.kernel.org>
Subject: Linux 3.0.3 GCC 4.6.1 kernel BUGs
Date: Fri, 19 Aug 2011 14:25:20 +0200
MIME-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="iso-8859-1";
	reply-type=original
Content-Transfer-Encoding: 7bit
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook Express 6.00.2900.5931
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.6109
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

I just compiled LinuxFromScratch with Kernel 3.0.3 using GCC 4.6.1
For most programs i used gcc 
options -O2 -march=prescott -mmmx -msse -msse2 -msse3.

Then i was not able to boot GRUB was halting machine. So i recompile GRUB 
without flags.
Then udev was crashing with kernel

BUG: unable to handle kernel paging request at 5c5c0d50
EIP is at __kmalloc_track_caller+0x7c/0x140
Process udevd (pid: 844, ti=ddde6000 task=df1628a0 task.ti=ddde6000)
Call Trace:
Aug 19 12:13:08 lfs2011 kernel: [  181.732049]  [<c02b1809>] ? 
vfs_rename+0x99/0x3b0
Aug 19 12:13:08 lfs2011 kernel: [  181.732049]  [<c028c45e>] 
kstrdup+0x2e/0x50
Aug 19 12:13:08 lfs2011 kernel: [  181.732049]  [<c02b1809>] 
vfs_rename+0x99/0x3b0
Aug 19 12:13:08 lfs2011 kernel: [  181.732049]  [<c02bb057>] ? 
d_lookup+0x27/0x50
Aug 19 12:13:08 lfs2011 kernel: [  181.732049]  [<c02b03eb>] ? 
__lookup_hash+0x3b/0xf0
Aug 19 12:13:08 lfs2011 kernel: [  181.732049]  [<c02e4790>] ? 
generic_acl_chmod+0x160/0x160
Aug 19 12:13:08 lfs2011 kernel: [  181.732049]  [<c02b4745>] 
sys_renameat+0x1d5/0x200
Aug 19 12:13:08 lfs2011 kernel: [  181.732049]  [<c02d5700>] ? 
fsnotify+0x190/0x250
Aug 19 12:13:08 lfs2011 kernel: [  181.732049]  [<c02a75ef>] ? 
vfs_write+0x11f/0x160
Aug 19 12:13:08 lfs2011 kernel: [  181.732049]  [<c02a6d70>] ? 
wait_on_retry_sync_kiocb+0x50/0x50
Aug 19 12:13:08 lfs2011 kernel: [  181.732049]  [<c02b4798>] 
sys_rename+0x28/0x30
Aug 19 12:13:08 lfs2011 kernel: [  181.732049]  [<c05a9610>] 
sysenter_do_call+0x12/0x26

Full Stack Traces are on the end of email.

So i recompiled udevd without optiomization flags and result is mostly 
functional system.

But now I am getting the same kernel BUG with gpm, and sometimes with udev.
I also recompiled gpm without flags, but problem persists. I also recompiled 
kernel without flags.

Bug on gpm is:

BUG: unable to handle kernel paging request at ee80dd0b
Process gpm (pid: 1060, ti=dd07c000 task=dd0d5c70 task.ti=dd07c000)
Call Trace:
Aug 19 12:55:11 lfs2011 kernel: [ 1543.003437]  [<c04180bb>] ? 
tty_add_file+0x6b/0x90
Aug 19 12:55:11 lfs2011 kernel: [ 1543.003437]  [<c0419a43>] 
tty_open+0x1a3/0x4d0
Aug 19 12:55:11 lfs2011 kernel: [ 1543.003437]  [<c02aaa6a>] 
chrdev_open+0xda/0x1e0
Aug 19 12:55:11 lfs2011 kernel: [ 1543.003437]  [<c02a591b>] 
__dentry_open.isra.17+0x11b/0x290
Aug 19 12:55:11 lfs2011 kernel: [ 1543.003437]  [<c02a6914>] 
nameidata_to_filp+0x54/0x70
Aug 19 12:55:11 lfs2011 kernel: [ 1543.003437]  [<c02aa990>] ? 
cdev_put+0x20/0x20
Aug 19 12:55:11 lfs2011 kernel: [ 1543.003437]  [<c02b346f>] 
do_last.isra.47+0x23f/0x700
Aug 19 12:55:11 lfs2011 kernel: [ 1543.003437]  [<c02b3b7d>] 
path_openat+0x8d/0x320
Aug 19 12:55:11 lfs2011 kernel: [ 1543.003437]  [<c041812c>] ? 
tty_del_file+0x4c/0x60
Aug 19 12:55:11 lfs2011 kernel: [ 1543.003437]  [<c02b3e3c>] 
do_filp_open+0x2c/0x80
Aug 19 12:55:11 lfs2011 kernel: [ 1543.003437]  [<c02be6db>] ? 
alloc_fd+0x9b/0xe0
Aug 19 12:55:11 lfs2011 kernel: [ 1543.003437]  [<c02b0b1d>] ? 
getname_flags+0xbd/0xf0
Aug 19 12:55:11 lfs2011 kernel: [ 1543.003437]  [<c02a6a11>] 
do_sys_open+0xe1/0x1b0
Aug 19 12:55:11 lfs2011 kernel: [ 1543.003437]  [<c02a6b09>] 
sys_open+0x29/0x40
Aug 19 12:55:11 lfs2011 kernel: [ 1543.003437]  [<c05a9610>] 
sysenter_do_call+0x12/0x26


After I mount device with cifs and start Qt Browser i also get kernel BUG:

See trace 3 on the end.


This all looks to me like GCC 4.6.1 is broken somehow.

Or do you have any suggestion what to do?




Trace1:
Aug 19 12:13:08 lfs2011 kernel: [  181.728844] BUG: unable to handle kernel 
paging request at 5c5c0d50
Aug 19 12:13:08 lfs2011 kernel: [  181.730010] IP: [<c02a52ec>] 
__kmalloc_track_caller+0x7c/0x140
Aug 19 12:13:08 lfs2011 kernel: [  181.731564] *pde = 00000000
Aug 19 12:13:08 lfs2011 kernel: [  181.732049] Oops: 0000 [#1] PREEMPT SMP
Aug 19 12:13:08 lfs2011 kernel: [  181.732049] Modules linked in:
Aug 19 12:13:08 lfs2011 kernel: [  181.732049]
Aug 19 12:13:08 lfs2011 kernel: [  181.732049] Pid: 844, comm: udevd Not 
tainted 3.0.3 #1 VMware, Inc. VMware Virtual Platform/440BX Desktop 
Reference Platform
Aug 19 12:13:08 lfs2011 kernel: [  181.732049] EIP: 0060:[<c02a52ec>] 
EFLAGS: 00010206 CPU: 0
Aug 19 12:13:08 lfs2011 kernel: [  181.732049] EIP is at 
__kmalloc_track_caller+0x7c/0x140
Aug 19 12:13:08 lfs2011 kernel: [  181.732049] EAX: 00000000 EBX: 00005e70 
ECX: 5c5c0d50 EDX: 00005e70
Aug 19 12:13:08 lfs2011 kernel: [  181.732049] ESI: df002280 EDI: c074ea50 
EBP: ddde7e4c ESP: ddde7e28
Aug 19 12:13:08 lfs2011 kernel: [  181.732049]  DS: 007b ES: 007b FS: 00d8 
GS: 0033 SS: 0068
Aug 19 12:13:08 lfs2011 kernel: [  181.732049] Process udevd (pid: 844, 
ti=ddde6000 task=df1628a0 task.ti=ddde6000)
Aug 19 12:13:08 lfs2011 kernel: [  181.732049] Stack:
Aug 19 12:13:08 lfs2011 kernel: [  181.732049]  5c5c0d50 00000000 ddd69068 
00005e70 c02b1809 000000d0 00000000 dee180a4
Aug 19 12:13:08 lfs2011 kernel: [  181.732049]  000000d0 ddde7e64 c028c45e 
0000000a dec2e000 00000000 dee18080 ddde7ea8
Aug 19 12:13:08 lfs2011 kernel: [  181.732049]  c02b1809 c02bb057 00000000 
dec2e000 ddde7f28 ddde7e9c c02b03eb c02e4790
Aug 19 12:13:08 lfs2011 kernel: [  181.732049] Call Trace:
Aug 19 12:13:08 lfs2011 kernel: [  181.732049]  [<c02b1809>] ? 
vfs_rename+0x99/0x3b0
Aug 19 12:13:08 lfs2011 kernel: [  181.732049]  [<c028c45e>] 
kstrdup+0x2e/0x50
Aug 19 12:13:08 lfs2011 kernel: [  181.732049]  [<c02b1809>] 
vfs_rename+0x99/0x3b0
Aug 19 12:13:08 lfs2011 kernel: [  181.732049]  [<c02bb057>] ? 
d_lookup+0x27/0x50
Aug 19 12:13:08 lfs2011 kernel: [  181.732049]  [<c02b03eb>] ? 
__lookup_hash+0x3b/0xf0
Aug 19 12:13:08 lfs2011 kernel: [  181.732049]  [<c02e4790>] ? 
generic_acl_chmod+0x160/0x160
Aug 19 12:13:08 lfs2011 kernel: [  181.732049]  [<c02b4745>] 
sys_renameat+0x1d5/0x200
Aug 19 12:13:08 lfs2011 kernel: [  181.732049]  [<c02d5700>] ? 
fsnotify+0x190/0x250
Aug 19 12:13:08 lfs2011 kernel: [  181.732049]  [<c02a75ef>] ? 
vfs_write+0x11f/0x160
Aug 19 12:13:08 lfs2011 kernel: [  181.732049]  [<c02a6d70>] ? 
wait_on_retry_sync_kiocb+0x50/0x50
Aug 19 12:13:08 lfs2011 kernel: [  181.732049]  [<c02b4798>] 
sys_rename+0x28/0x30
Aug 19 12:13:08 lfs2011 kernel: [  181.732049]  [<c05a9610>] 
sysenter_do_call+0x12/0x26
Aug 19 12:13:08 lfs2011 kernel: [  181.732049] Code: 55 8b 06 64 03 05 14 ae 
74 c0 8b 50 04 89 55 e8 8b 00 85 c0 89 45 dc 0f 84 90 00 00 00 8b 4d dc 8b 
46 14 8b 5d e8 8b 55 e8 8b 3e <8b> 04 01 83 c3 04 89 5d e0 8b 4d e0 89 45 e4 
89 c3 8b 45 dc 64
Aug 19 12:13:08 lfs2011 kernel: [  181.732049] EIP: [<c02a52ec>] 
__kmalloc_track_caller+0x7c/0x140 SS:ESP 0068:ddde7e28
Aug 19 12:13:08 lfs2011 kernel: [  181.732049] CR2: 000000005c5c0d50
Aug 19 12:13:08 lfs2011 kernel: [  181.786592] BUG: unable to handle kernel 
paging request at 5c5c0d50
Aug 19 12:13:08 lfs2011 kernel: [  181.788045] IP: [<c02a3c70>] 
kmem_cache_alloc+0x40/0xb0
Aug 19 12:13:08 lfs2011 kernel: [  181.788297] *pde = 00000000
Aug 19 12:13:08 lfs2011 kernel: [  181.788297] Oops: 0000 [#2] PREEMPT SMP
Aug 19 12:13:08 lfs2011 kernel: [  181.788297] Modules linked in:
Aug 19 12:13:08 lfs2011 kernel: [  181.788297]
Aug 19 12:13:08 lfs2011 kernel: [  181.788297] Pid: 1125, comm: syslogd 
Tainted: G      D     3.0.3 #1 VMware, Inc. VMware Virtual Platform/440BX 
Desktop Reference Platform
Aug 19 12:13:08 lfs2011 kernel: [  181.788297] EIP: 0060:[<c02a3c70>] 
EFLAGS: 00010206 CPU: 0
Aug 19 12:13:08 lfs2011 kernel: [  181.788297] EIP is at 
kmem_cache_alloc+0x40/0xb0
Aug 19 12:13:08 lfs2011 kernel: [  181.788297] EAX: 00000000 EBX: 00005e70 
ECX: 5c5c0d50 EDX: 00005e70
Aug 19 12:13:08 lfs2011 kernel: [  181.788297] ESI: df002280 EDI: c074ea50 
EBP: ddf2ddd0 ESP: ddf2ddac
Aug 19 12:13:08 lfs2011 kernel: [  181.788297]  DS: 007b ES: 007b FS: 00d8 
GS: 0033 SS: 0068
Aug 19 12:13:08 lfs2011 kernel: [  181.788297] Process syslogd (pid: 1125, 
ti=ddf2c000 task=df26d860 task.ti=ddf2c000)
Aug 19 12:13:08 lfs2011 kernel: [  181.788297] Stack:
Aug 19 12:13:08 lfs2011 kernel: [  181.788297]  5c5c0d50 00000000 00000040 
00005e70 c0418076 000000d0 dd09c800 dde1e380
Aug 19 12:13:08 lfs2011 kernel: [  181.788297]  00400001 ddf2dde4 c0418076 
df1710c0 dd09c800 00400001 ddf2de14 c0419a2d
Aug 19 12:13:08 lfs2011 kernel: [  181.788297]  dd09c818 dd051068 df26d860 
00000101 00000100 dde1e380 00000000 dd051068
Aug 19 12:13:08 lfs2011 kernel: [  181.788297] Call Trace:
Aug 19 12:13:09 lfs2011 kernel: [  181.788297]  [<c0418076>] ? 
tty_add_file+0x26/0x90
Aug 19 12:13:09 lfs2011 kernel: [  181.788297]  [<c0418076>] 
tty_add_file+0x26/0x90
Aug 19 12:13:09 lfs2011 kernel: [  181.788297]  [<c0419a2d>] 
tty_open+0x18d/0x4d0
Aug 19 12:13:09 lfs2011 kernel: [  181.788297]  [<c02aaa6a>] 
chrdev_open+0xda/0x1e0
Aug 19 12:13:09 lfs2011 kernel: [  181.788297]  [<c02a591b>] 
__dentry_open.isra.17+0x11b/0x290
Aug 19 12:13:09 lfs2011 kernel: [  181.788297]  [<c02a6914>] 
nameidata_to_filp+0x54/0x70
Aug 19 12:13:09 lfs2011 kernel: [  181.788297]  [<c02aa990>] ? 
cdev_put+0x20/0x20
Aug 19 12:13:09 lfs2011 kernel: [  181.788297]  [<c02b346f>] 
do_last.isra.47+0x23f/0x700
Aug 19 12:13:09 lfs2011 kernel: [  181.788297]  [<c02b3b7d>] 
path_openat+0x8d/0x320
Aug 19 12:13:09 lfs2011 kernel: [  181.788297]  [<c03ba968>] ? 
timerqueue_add+0x58/0xb0
Aug 19 12:13:09 lfs2011 kernel: [  181.788297]  [<c02b3e3c>] 
do_filp_open+0x2c/0x80
Aug 19 12:13:09 lfs2011 kernel: [  181.788297]  [<c02be6db>] ? 
alloc_fd+0x9b/0xe0
Aug 19 12:13:09 lfs2011 kernel: [  181.788297]  [<c02b0b1d>] ? 
getname_flags+0xbd/0xf0
Aug 19 12:13:09 lfs2011 kernel: [  181.788297]  [<c02a6a11>] 
do_sys_open+0xe1/0x1b0
Aug 19 12:13:09 lfs2011 kernel: [  181.788297]  [<c02a6b09>] 
sys_open+0x29/0x40
Aug 19 12:13:09 lfs2011 kernel: [  181.788297]  [<c05a9610>] 
sysenter_do_call+0x12/0x26
Aug 19 12:13:09 lfs2011 kernel: [  181.788297] Code: 55 f0 89 4d ec 8b 06 64 
03 05 14 ae 74 c0 8b 50 04 89 55 e8 8b 00 85 c0 89 45 dc 74 6a 8b 4d dc 8b 
46 14 8b 5d e8 8b 55 e8 8b 3e <8b> 04 01 83 c3 04 89 5d e0 8b 4d e0 89 45 e4 
89 c3 8b 45 dc 64
Aug 19 12:13:09 lfs2011 kernel: [  181.788297] EIP: [<c02a3c70>] 
kmem_cache_alloc+0x40/0xb0 SS:ESP 0068:ddf2ddac
Aug 19 12:13:09 lfs2011 kernel: [  181.788297] CR2: 000000005c5c0d50
Aug 19 12:13:09 lfs2011 kernel: [  181.846603] CIFS VFS: cifs_mount failed 
w/return code = -22
Aug 19 12:13:09 lfs2011 kernel: [  181.882597] ---[ end trace 
e131f25cbdf7f33e ]---
Aug 19 12:13:09 lfs2011 kernel: [  181.885266] BUG: unable to handle kernel 
paging request at 65800d30
Aug 19 12:13:09 lfs2011 kernel: [  181.886606] IP: [<c02a3c70>] 
kmem_cache_alloc+0x40/0xb0
Aug 19 12:13:09 lfs2011 kernel: [  181.887945] *pde = 00000000
Aug 19 12:13:09 lfs2011 kernel: [  181.888027] Oops: 0000 [#3] PREEMPT SMP
Aug 19 12:13:09 lfs2011 kernel: [  181.888027] Modules linked in:
Aug 19 12:13:09 lfs2011 kernel: [  181.888027]
Aug 19 12:13:09 lfs2011 kernel: [  181.888027] Pid: 889, comm: udevd 
Tainted: G      D     3.0.3 #1 VMware, Inc. VMware Virtual Platform/440BX 
Desktop Reference Platform
Aug 19 12:13:09 lfs2011 kernel: [  181.888027] EIP: 0060:[<c02a3c70>] 
EFLAGS: 00010206 CPU: 0
Aug 19 12:13:09 lfs2011 kernel: [  181.888027] EIP is at 
kmem_cache_alloc+0x40/0xb0
Aug 19 12:13:09 lfs2011 kernel: [  181.888027] EAX: 00000000 EBX: 00005e98 
ECX: 65800d30 EDX: 00005e98
Aug 19 12:13:09 lfs2011 kernel: [  181.888027] ESI: df002280 EDI: c074ea50 
EBP: ddfb9ec4 ESP: ddfb9ea0
Aug 19 12:13:09 lfs2011 kernel: [  181.888027]  DS: 007b ES: 007b FS: 00d8 
GS: 0033 SS: 0068
Aug 19 12:13:09 lfs2011 kernel: [  181.888027] Process udevd (pid: 889, 
ti=ddfb8000 task=df2ae490 task.ti=ddfb8000)
Aug 19 12:13:09 lfs2011 kernel: [  181.888027] Stack:
Aug 19 12:13:09 lfs2011 kernel: [  181.888027]  65800d30 00000000 ddfb9ec4 
00005e98 c02d7926 00000050 df285140 df236580
Aug 19 12:13:09 lfs2011 kernel: [  181.888027]  ddd4f740 ddfb9eec c02d7926 
00000000 00000000 00000000 00000050 df285140
Aug 19 12:13:09 lfs2011 kernel: [  181.888027]  df285140 df236580 df285154 
ddfb9ef4 c02d7098 ddfb9f14 c02d68ee 00000000
Aug 19 12:13:09 lfs2011 kernel: [  181.888027] Call Trace:
Aug 19 12:13:09 lfs2011 kernel: [  181.888027]  [<c02d7926>] ? 
inotify_ignored_and_remove_idr+0x56/0xc0
Aug 19 12:13:09 lfs2011 kernel: [  181.888027]  [<c02d7926>] 
inotify_ignored_and_remove_idr+0x56/0xc0
Aug 19 12:13:09 lfs2011 kernel: [  181.888027]  [<c02d7098>] 
inotify_freeing_mark+0x8/0x10
Aug 19 12:13:09 lfs2011 kernel: [  181.888027]  [<c02d68ee>] 
fsnotify_destroy_mark+0xde/0x150
Aug 19 12:13:09 lfs2011 kernel: [  181.888027]  [<c02d6c0b>] 
fsnotify_clear_marks_by_group_flags+0xab/0xd0
Aug 19 12:13:09 lfs2011 kernel: [  181.888027]  [<c02d6c3d>] 
fsnotify_clear_marks_by_group+0xd/0x10
Aug 19 12:13:09 lfs2011 kernel: [  181.888027]  [<c02d733e>] 
inotify_release+0xe/0x20
Aug 19 12:13:09 lfs2011 kernel: [  181.888027]  [<c02a8b6a>] fput+0xaa/0x1d0
Aug 19 12:13:09 lfs2011 kernel: [  181.888027]  [<c02a56b6>] 
filp_close+0x46/0x70
Aug 19 12:13:09 lfs2011 kernel: [  181.888027]  [<c02a574f>] 
sys_close+0x6f/0xc0
Aug 19 12:13:09 lfs2011 kernel: [  181.888027]  [<c05a9610>] 
sysenter_do_call+0x12/0x26
Aug 19 12:13:09 lfs2011 kernel: [  181.888027] Code: 55 f0 89 4d ec 8b 06 64 
03 05 14 ae 74 c0 8b 50 04 89 55 e8 8b 00 85 c0 89 45 dc 74 6a 8b 4d dc 8b 
46 14 8b 5d e8 8b 55 e8 8b 3e <8b> 04 01 83 c3 04 89 5d e0 8b 4d e0 89 45 e4 
89 c3 8b 45 dc 64
Aug 19 12:13:09 lfs2011 kernel: [  181.888027] EIP: [<c02a3c70>] 
kmem_cache_alloc+0x40/0xb0 SS:ESP 0068:ddfb9ea0
Aug 19 12:13:09 lfs2011 kernel: [  181.888027] CR2: 0000000065800d30
Aug 19 12:13:09 lfs2011 kernel: [  181.941038] ---[ end trace 
e131f25cbdf7f33f ]---
Aug 19 12:13:09 lfs2011 kernel: [  181.943738] ---[ end trace 
e131f25cbdf7f340 ]--- 


Trace2:

Aug 19 12:55:11 lfs2011 kernel: [ 1543.000053] BUG: unable to handle kernel 
paging request at 1114ddd0
Aug 19 12:55:11 lfs2011 kernel: [ 1543.003266] IP: [<c0417460>] 
check_tty_count+0x30/0xa0
Aug 19 12:55:11 lfs2011 kernel: [ 1543.003437] *pde = 00000000
Aug 19 12:55:11 lfs2011 kernel: [ 1543.003437] Oops: 0000 [#1] PREEMPT SMP
Aug 19 12:55:11 lfs2011 kernel: [ 1543.003437] Modules linked in:
Aug 19 12:55:11 lfs2011 kernel: [ 1543.003437]
Aug 19 12:55:11 lfs2011 kernel: [ 1543.003437] Pid: 1060, comm: gpm Not 
tainted 3.0.3 #1 VMware, Inc. VMware Virtual Platform/440BX Desktop 
Reference Platform
Aug 19 12:55:11 lfs2011 kernel: [ 1543.003437] EIP: 0060:[<c0417460>] 
EFLAGS: 00010213 CPU: 0
Aug 19 12:55:11 lfs2011 kernel: [ 1543.003437] EIP is at 
check_tty_count+0x30/0xa0
Aug 19 12:55:11 lfs2011 kernel: [ 1543.003437] EAX: 1114ddd0 EBX: dd0b1000 
ECX: 00006450 EDX: dd0b1114
Aug 19 12:55:11 lfs2011 kernel: [ 1543.003437] ESI: 00000002 EDI: c066c2b5 
EBP: dd07dde4 ESP: dd07ddc4
Aug 19 12:55:11 lfs2011 kernel: [ 1543.003437]  DS: 007b ES: 007b FS: 00d8 
GS: 0033 SS: 0068
Aug 19 12:55:11 lfs2011 kernel: [ 1543.003437] Process gpm (pid: 1060, 
ti=dd07c000 task=dd0d5c70 task.ti=dd07c000)
Aug 19 12:55:11 lfs2011 kernel: [ 1543.003437] Stack:
Aug 19 12:55:11 lfs2011 kernel: [ 1543.003437]  dd0b1000 ddfaee80 00400000 
dd07dde4 c04180bb 00000000 dd0b1000 00400000
Aug 19 12:55:11 lfs2011 kernel: [ 1543.003437]  dd07de14 c0419a43 dd0b1018 
dddd23e8 dd0d5c70 00000000 00000001 ddfaee80
Aug 19 12:55:11 lfs2011 kernel: [ 1543.003437]  00000001 dddd23e8 c078daa0 
ddfaee80 dd07de30 c02aaa6a 00000000 dd07de30
Aug 19 12:55:11 lfs2011 kernel: [ 1543.003437] Call Trace:
Aug 19 12:55:11 lfs2011 kernel: [ 1543.003437]  [<c04180bb>] ? 
tty_add_file+0x6b/0x90
Aug 19 12:55:11 lfs2011 kernel: [ 1543.003437]  [<c0419a43>] 
tty_open+0x1a3/0x4d0
Aug 19 12:55:11 lfs2011 kernel: [ 1543.003437]  [<c02aaa6a>] 
chrdev_open+0xda/0x1e0
Aug 19 12:55:11 lfs2011 kernel: [ 1543.003437]  [<c02a591b>] 
__dentry_open.isra.17+0x11b/0x290
Aug 19 12:55:11 lfs2011 kernel: [ 1543.003437]  [<c02a6914>] 
nameidata_to_filp+0x54/0x70
Aug 19 12:55:11 lfs2011 kernel: [ 1543.003437]  [<c02aa990>] ? 
cdev_put+0x20/0x20
Aug 19 12:55:11 lfs2011 kernel: [ 1543.003437]  [<c02b346f>] 
do_last.isra.47+0x23f/0x700
Aug 19 12:55:11 lfs2011 kernel: [ 1543.003437]  [<c02b3b7d>] 
path_openat+0x8d/0x320
Aug 19 12:55:11 lfs2011 kernel: [ 1543.003437]  [<c041812c>] ? 
tty_del_file+0x4c/0x60
Aug 19 12:55:11 lfs2011 kernel: [ 1543.003437]  [<c02b3e3c>] 
do_filp_open+0x2c/0x80
Aug 19 12:55:11 lfs2011 kernel: [ 1543.003437]  [<c02be6db>] ? 
alloc_fd+0x9b/0xe0
Aug 19 12:55:11 lfs2011 kernel: [ 1543.003437]  [<c02b0b1d>] ? 
getname_flags+0xbd/0xf0
Aug 19 12:55:11 lfs2011 kernel: [ 1543.003437]  [<c02a6a11>] 
do_sys_open+0xe1/0x1b0
Aug 19 12:55:11 lfs2011 kernel: [ 1543.003437]  [<c02a6b09>] 
sys_open+0x29/0x40
Aug 19 12:55:11 lfs2011 kernel: [ 1543.003437]  [<c05a9610>] 
sysenter_do_call+0x12/0x26
Aug 19 12:55:11 lfs2011 kernel: [ 1543.003437] Code: d7 56 31 f6 53 89 c3 83 
ec 14 b8 e4 cc 78 c0 e8 37 14 19 00 8b 83 14 01 00 00 8d 93 14 01 00 00 39 
d0 74 10 8d b4 26 00 00 00 00 <8b> 00 83 c6 01 39 d0 75 f7 b8 e4 cc 78 c0 e8 
dd 15 19 00 8b 43
Aug 19 12:55:11 lfs2011 kernel: [ 1543.003437] EIP: [<c0417460>] 
check_tty_count+0x30/0xa0 SS:ESP 0068:dd07ddc4
Aug 19 12:55:11 lfs2011 kernel: [ 1543.003437] CR2: 000000001114ddd0
Aug 19 12:55:11 lfs2011 kernel: [ 1543.054383] ---[ end trace 
c68ab111f34450ad ]---
Aug 19 12:55:11 lfs2011 kernel: [ 1543.055862] note: gpm[1060] exited with 
preempt_count 1
Aug 19 12:55:11 lfs2011 kernel: [ 1543.057365] BUG: scheduling while atomic: 
gpm/1060/0x10000002
Aug 19 12:55:11 lfs2011 kernel: [ 1543.058763] Modules linked in:
Aug 19 12:55:11 lfs2011 kernel: [ 1543.060243] Pid: 1060, comm: gpm Tainted: 
G      D     3.0.3 #1
Aug 19 12:55:11 lfs2011 kernel: [ 1543.061593] Call Trace:
Aug 19 12:55:11 lfs2011 kernel: [ 1543.062914]  [<c05a36a8>] 
__schedule_bug+0x55/0x5b
Aug 19 12:55:11 lfs2011 kernel: [ 1543.064134]  [<c05a6f13>] 
schedule+0x6b3/0x870
Aug 19 12:55:11 lfs2011 kernel: [ 1543.064134]  [<c02238dc>] ? 
sched_slice.isra.123+0x4c/0xa0
Aug 19 12:55:11 lfs2011 kernel: [ 1543.064134]  [<c0223b8f>] ? 
task_tick_fair+0x10f/0x120
Aug 19 12:55:11 lfs2011 kernel: [ 1543.064134]  [<c024b886>] ? 
sched_clock_tick+0x56/0x90
Aug 19 12:55:11 lfs2011 kernel: [ 1543.064134]  [<c0228c96>] 
__cond_resched+0x16/0x30
Aug 19 12:55:11 lfs2011 kernel: [ 1543.064134]  [<c05a72c5>] 
_cond_resched+0x25/0x30
Aug 19 12:55:11 lfs2011 kernel: [ 1543.064134]  [<c0292905>] 
unmap_vmas+0x3b5/0x460
Aug 19 12:55:11 lfs2011 kernel: [ 1543.073091]  [<c02541af>] ? 
tick_dev_program_event+0x3f/0x160
Aug 19 12:55:11 lfs2011 kernel: [ 1543.074302]  [<c0297605>] 
exit_mmap+0x85/0xf0
Aug 19 12:55:11 lfs2011 kernel: [ 1543.075484]  [<c026d6c8>] ? 
rcu_irq_exit+0x8/0x10
Aug 19 12:55:11 lfs2011 kernel: [ 1543.076724]  [<c0232da7>] ? 
irq_exit+0x37/0xa0
Aug 19 12:55:11 lfs2011 kernel: [ 1543.077899]  [<c02157e4>] ? 
smp_apic_timer_interrupt+0x54/0x90
Aug 19 12:55:11 lfs2011 kernel: [ 1543.079086]  [<c022b356>] mmput+0x26/0xb0
Aug 19 12:55:11 lfs2011 kernel: [ 1543.080261]  [<c022f182>] 
exit_mm+0xe2/0x110
Aug 19 12:55:11 lfs2011 kernel: [ 1543.080697]  [<c0230cb5>] 
do_exit+0x565/0x730
Aug 19 12:55:11 lfs2011 kernel: [ 1543.080697]  [<c05a38c0>] ? 
printk+0x18/0x1a
Aug 19 12:55:11 lfs2011 kernel: [ 1543.080697]  [<c0205656>] 
oops_end+0x86/0xc0
Aug 19 12:55:11 lfs2011 kernel: [ 1543.080697]  [<c05a329a>] 
no_context+0x137/0x13f
Aug 19 12:55:11 lfs2011 kernel: [ 1543.080697]  [<c05a33b6>] 
__bad_area_nosemaphore+0x114/0x11c
Aug 19 12:55:11 lfs2011 kernel: [ 1543.080697]  [<c02201ff>] ? 
pick_next_highest_task_rt+0x7f/0xe0
Aug 19 12:55:11 lfs2011 kernel: [ 1543.080697]  [<c021b1c0>] ? 
vmalloc_sync_all+0x110/0x110
Aug 19 12:55:11 lfs2011 kernel: [ 1543.080697]  [<c05a33d0>] 
bad_area_nosemaphore+0x12/0x14
Aug 19 12:55:11 lfs2011 kernel: [ 1543.090874]  [<c021b428>] 
do_page_fault+0x268/0x3c0
Aug 19 12:55:11 lfs2011 kernel: [ 1543.092085]  [<c03e2e9f>] ? 
fbcon_putcs+0xff/0x130
Aug 19 12:55:11 lfs2011 kernel: [ 1543.093287]  [<c03e6cf0>] ? 
bit_cursor+0x530/0x530
Aug 19 12:55:11 lfs2011 kernel: [ 1543.094453]  [<c021b1c0>] ? 
vmalloc_sync_all+0x110/0x110
Aug 19 12:55:11 lfs2011 kernel: [ 1543.094860]  [<c05a93a2>] 
error_code+0x5a/0x60
Aug 19 12:55:11 lfs2011 kernel: [ 1543.094860]  [<c021b1c0>] ? 
vmalloc_sync_all+0x110/0x110
Aug 19 12:55:11 lfs2011 kernel: [ 1543.094860]  [<c0417460>] ? 
check_tty_count+0x30/0xa0
Aug 19 12:55:11 lfs2011 kernel: [ 1543.094860]  [<c04180bb>] ? 
tty_add_file+0x6b/0x90
Aug 19 12:55:11 lfs2011 kernel: [ 1543.094860]  [<c0419a43>] 
tty_open+0x1a3/0x4d0
Aug 19 12:55:11 lfs2011 kernel: [ 1543.100898]  [<c02aaa6a>] 
chrdev_open+0xda/0x1e0
Aug 19 12:55:11 lfs2011 kernel: [ 1543.101910]  [<c02a591b>] 
__dentry_open.isra.17+0x11b/0x290
Aug 19 12:55:11 lfs2011 kernel: [ 1543.102920]  [<c02a6914>] 
nameidata_to_filp+0x54/0x70
Aug 19 12:55:11 lfs2011 kernel: [ 1543.103920]  [<c02aa990>] ? 
cdev_put+0x20/0x20
Aug 19 12:55:11 lfs2011 kernel: [ 1543.104885]  [<c02b346f>] 
do_last.isra.47+0x23f/0x700
Aug 19 12:55:11 lfs2011 kernel: [ 1543.105938]  [<c02b3b7d>] 
path_openat+0x8d/0x320
Aug 19 12:55:11 lfs2011 kernel: [ 1543.106928]  [<c041812c>] ? 
tty_del_file+0x4c/0x60
Aug 19 12:55:11 lfs2011 kernel: [ 1543.107914]  [<c02b3e3c>] 
do_filp_open+0x2c/0x80
Aug 19 12:55:11 lfs2011 kernel: [ 1543.108901]  [<c02be6db>] ? 
alloc_fd+0x9b/0xe0
Aug 19 12:55:11 lfs2011 kernel: [ 1543.109885]  [<c02b0b1d>] ? 
getname_flags+0xbd/0xf0
Aug 19 12:55:11 lfs2011 kernel: [ 1543.109926]  [<c02a6a11>] 
do_sys_open+0xe1/0x1b0
Aug 19 12:55:11 lfs2011 kernel: [ 1543.109926]  [<c02a6b09>] 
sys_open+0x29/0x40
Aug 19 12:55:11 lfs2011 kernel: [ 1543.109926]  [<c05a9610>] 
sysenter_do_call+0x12/0x26
Aug 19 12:55:11 lfs2011 kernel: [ 1543.125746] BUG: scheduling while atomic: 
gpm/1060/0x00000002
Aug 19 12:55:11 lfs2011 kernel: [ 1543.126922] Modules linked in:
Aug 19 12:55:11 lfs2011 kernel: [ 1543.127929] Pid: 1060, comm: gpm Tainted: 
G      D     3.0.3 #1
Aug 19 12:55:11 lfs2011 kernel: [ 1543.128993] Call Trace:
Aug 19 12:55:11 lfs2011 kernel: [ 1543.129988]  [<c05a38c0>] ? 
printk+0x18/0x1a
Aug 19 12:55:11 lfs2011 kernel: [ 1543.130988]  [<c05a36a8>] 
__schedule_bug+0x55/0x5b
Aug 19 12:55:11 lfs2011 kernel: [ 1543.131989]  [<c05a6f13>] 
schedule+0x6b3/0x870
Aug 19 12:55:11 lfs2011 kernel: [ 1543.132978]  [<c0222526>] ? 
finish_task_switch+0x46/0xa0
Aug 19 12:55:11 lfs2011 kernel: [ 1543.132978]  [<c05a6a51>] ? 
schedule+0x1f1/0x870
Aug 19 12:55:11 lfs2011 kernel: [ 1543.132978]  [<c028106c>] ? 
free_pcppages_bulk+0x28c/0x2c0
Aug 19 12:55:11 lfs2011 kernel: [ 1543.132978]  [<c05a75dd>] 
schedule_timeout+0x14d/0x1b0
Aug 19 12:55:11 lfs2011 kernel: [ 1543.137080]  [<c02a225e>] ? 
add_partial+0x3e/0x70
Aug 19 12:55:11 lfs2011 kernel: [ 1543.137799]  [<c05a65ff>] 
wait_for_common+0x8f/0x120
Aug 19 12:55:11 lfs2011 kernel: [ 1543.138487]  [<c0226170>] ? 
try_to_wake_up+0x1f0/0x1f0
Aug 19 12:55:11 lfs2011 kernel: [ 1543.139176]  [<c05a66a2>] 
wait_for_completion+0x12/0x20
Aug 19 12:55:11 lfs2011 kernel: [ 1543.139873]  [<c026caa1>] 
synchronize_rcu+0x41/0x50
Aug 19 12:55:11 lfs2011 kernel: [ 1543.140567]  [<c0242ca0>] ? 
find_ge_pid+0x40/0x40
Aug 19 12:55:11 lfs2011 kernel: [ 1543.141064]  [<c04d8a8d>] 
mousedev_release+0x3d/0x70
Aug 19 12:55:11 lfs2011 kernel: [ 1543.141064]  [<c02a8b6a>] fput+0xaa/0x1d0
Aug 19 12:55:11 lfs2011 kernel: [ 1543.141064]  [<c02a56b6>] 
filp_close+0x46/0x70
Aug 19 12:55:11 lfs2011 kernel: [ 1543.141064]  [<c0230643>] 
put_files_struct+0x73/0xd0
Aug 19 12:55:11 lfs2011 kernel: [ 1543.141064]  [<c0230740>] 
exit_files+0x40/0x50
Aug 19 12:55:11 lfs2011 kernel: [ 1543.141064]  [<c0230cc8>] 
do_exit+0x578/0x730
Aug 19 12:55:11 lfs2011 kernel: [ 1543.141064]  [<c05a38c0>] ? 
printk+0x18/0x1a
Aug 19 12:55:11 lfs2011 kernel: [ 1543.141064]  [<c0205656>] 
oops_end+0x86/0xc0
Aug 19 12:55:11 lfs2011 kernel: [ 1543.141064]  [<c05a329a>] 
no_context+0x137/0x13f
Aug 19 12:55:11 lfs2011 kernel: [ 1543.141064]  [<c05a33b6>] 
__bad_area_nosemaphore+0x114/0x11c
Aug 19 12:55:11 lfs2011 kernel: [ 1543.141064]  [<c02201ff>] ? 
pick_next_highest_task_rt+0x7f/0xe0
Aug 19 12:55:11 lfs2011 kernel: [ 1543.141064]  [<c021b1c0>] ? 
vmalloc_sync_all+0x110/0x110
Aug 19 12:55:11 lfs2011 kernel: [ 1543.141064]  [<c05a33d0>] 
bad_area_nosemaphore+0x12/0x14
Aug 19 12:55:11 lfs2011 kernel: [ 1543.141064]  [<c021b428>] 
do_page_fault+0x268/0x3c0
Aug 19 12:55:11 lfs2011 kernel: [ 1543.141064]  [<c03e2e9f>] ? 
fbcon_putcs+0xff/0x130
Aug 19 12:55:11 lfs2011 kernel: [ 1543.141064]  [<c03e6cf0>] ? 
bit_cursor+0x530/0x530
Aug 19 12:55:11 lfs2011 kernel: [ 1543.141064]  [<c021b1c0>] ? 
vmalloc_sync_all+0x110/0x110
Aug 19 12:55:11 lfs2011 kernel: [ 1543.152783]  [<c05a93a2>] 
error_code+0x5a/0x60
Aug 19 12:55:11 lfs2011 kernel: [ 1543.153456]  [<c021b1c0>] ? 
vmalloc_sync_all+0x110/0x110
Aug 19 12:55:11 lfs2011 kernel: [ 1543.154133]  [<c0417460>] ? 
check_tty_count+0x30/0xa0
Aug 19 12:55:11 lfs2011 kernel: [ 1543.154804]  [<c04180bb>] ? 
tty_add_file+0x6b/0x90
Aug 19 12:55:11 lfs2011 kernel: [ 1543.155464]  [<c0419a43>] 
tty_open+0x1a3/0x4d0
Aug 19 12:55:11 lfs2011 kernel: [ 1543.156114]  [<c02aaa6a>] 
chrdev_open+0xda/0x1e0
Aug 19 12:55:11 lfs2011 kernel: [ 1543.156819]  [<c02a591b>] 
__dentry_open.isra.17+0x11b/0x290
Aug 19 12:55:11 lfs2011 kernel: [ 1543.157475]  [<c02a6914>] 
nameidata_to_filp+0x54/0x70
Aug 19 12:55:11 lfs2011 kernel: [ 1543.158260]  [<c02aa990>] ? 
cdev_put+0x20/0x20
Aug 19 12:55:11 lfs2011 kernel: [ 1543.159057]  [<c02b346f>] 
do_last.isra.47+0x23f/0x700
Aug 19 12:55:11 lfs2011 kernel: [ 1543.159731]  [<c02b3b7d>] 
path_openat+0x8d/0x320
Aug 19 12:55:11 lfs2011 kernel: [ 1543.160404]  [<c041812c>] ? 
tty_del_file+0x4c/0x60
Aug 19 12:55:11 lfs2011 kernel: [ 1543.160809]  [<c02b3e3c>] 
do_filp_open+0x2c/0x80
Aug 19 12:55:11 lfs2011 kernel: [ 1543.160809]  [<c02be6db>] ? 
alloc_fd+0x9b/0xe0
Aug 19 12:55:11 lfs2011 kernel: [ 1543.160809]  [<c02b0b1d>] ? 
getname_flags+0xbd/0xf0
Aug 19 12:55:11 lfs2011 kernel: [ 1543.160809]  [<c02a6a11>] 
do_sys_open+0xe1/0x1b0
Aug 19 12:55:11 lfs2011 kernel: [ 1543.160809]  [<c02a6b09>] 
sys_open+0x29/0x40
Aug 19 12:55:11 lfs2011 kernel: [ 1543.164426]  [<c05a9610>] 
sysenter_do_call+0x12/0x26
Aug 19 12:55:11 lfs2011 kernel: [ 1543.182400] BUG: scheduling while atomic: 
gpm/1060/0x00000002
Aug 19 12:55:11 lfs2011 kernel: [ 1543.183130] Modules linked in:
Aug 19 12:55:11 lfs2011 kernel: [ 1543.183811] Pid: 1060, comm: gpm Tainted: 
G      D     3.0.3 #1
Aug 19 12:55:11 lfs2011 kernel: [ 1543.184048] Call Trace:
Aug 19 12:55:11 lfs2011 kernel: [ 1543.185187]  [<c05a38c0>] ? 
printk+0x18/0x1a
Aug 19 12:55:11 lfs2011 kernel: [ 1543.185871]  [<c05a36a8>] 
__schedule_bug+0x55/0x5b
Aug 19 12:55:11 lfs2011 kernel: [ 1543.186546]  [<c05a6f13>] 
schedule+0x6b3/0x870
Aug 19 12:55:11 lfs2011 kernel: [ 1543.187238]  [<c022209c>] ? 
set_next_entity+0x2c/0x70
Aug 19 12:55:11 lfs2011 kernel: [ 1543.187928]  [<c0222526>] ? 
finish_task_switch+0x46/0xa0
Aug 19 12:55:11 lfs2011 kernel: [ 1543.188616]  [<c028106c>] ? 
free_pcppages_bulk+0x28c/0x2c0
Aug 19 12:55:11 lfs2011 kernel: [ 1543.189160]  [<c05a75dd>] 
schedule_timeout+0x14d/0x1b0
Aug 19 12:55:11 lfs2011 kernel: [ 1543.190452]  [<c05a75dd>] ? 
schedule_timeout+0x14d/0x1b0
Aug 19 12:55:11 lfs2011 kernel: [ 1543.191165]  [<c05a65ff>] 
wait_for_common+0x8f/0x120
Aug 19 12:55:11 lfs2011 kernel: [ 1543.191870]  [<c0226170>] ? 
try_to_wake_up+0x1f0/0x1f0
Aug 19 12:55:11 lfs2011 kernel: [ 1543.192561]  [<c05a66a2>] 
wait_for_completion+0x12/0x20
Aug 19 12:55:11 lfs2011 kernel: [ 1543.193254]  [<c026caa1>] 
synchronize_rcu+0x41/0x50
Aug 19 12:55:11 lfs2011 kernel: [ 1543.193950]  [<c0242ca0>] ? 
find_ge_pid+0x40/0x40
Aug 19 12:55:11 lfs2011 kernel: [ 1543.194415]  [<c04d52db>] 
input_close_device+0x5b/0x70
Aug 19 12:55:11 lfs2011 kernel: [ 1543.194415]  [<c04d89f0>] 
mousedev_close_device+0x50/0xb0
Aug 19 12:55:11 lfs2011 kernel: [ 1543.194415]  [<c04d8a4e>] 
mousedev_close_device+0xae/0xb0
Aug 19 12:55:11 lfs2011 kernel: [ 1543.194415]  [<c04d8a9b>] 
mousedev_release+0x4b/0x70
Aug 19 12:55:11 lfs2011 kernel: [ 1543.194415]  [<c02a8b6a>] fput+0xaa/0x1d0
Aug 19 12:55:11 lfs2011 kernel: [ 1543.194415]  [<c02a56b6>] 
filp_close+0x46/0x70
Aug 19 12:55:11 lfs2011 kernel: [ 1543.194415]  [<c0230643>] 
put_files_struct+0x73/0xd0
Aug 19 12:55:11 lfs2011 kernel: [ 1543.199490]  [<c0230740>] 
exit_files+0x40/0x50
Aug 19 12:55:11 lfs2011 kernel: [ 1543.200156]  [<c0230cc8>] 
do_exit+0x578/0x730
Aug 19 12:55:11 lfs2011 kernel: [ 1543.200815]  [<c05a38c0>] ? 
printk+0x18/0x1a
Aug 19 12:55:11 lfs2011 kernel: [ 1543.201779]  [<c0205656>] 
oops_end+0x86/0xc0
Aug 19 12:55:11 lfs2011 kernel: [ 1543.202507]  [<c05a329a>] 
no_context+0x137/0x13f
Aug 19 12:55:11 lfs2011 kernel: [ 1543.203175]  [<c05a33b6>] 
__bad_area_nosemaphore+0x114/0x11c
Aug 19 12:55:11 lfs2011 kernel: [ 1543.203840]  [<c02201ff>] ? 
pick_next_highest_task_rt+0x7f/0xe0
Aug 19 12:55:11 lfs2011 kernel: [ 1543.204522]  [<c021b1c0>] ? 
vmalloc_sync_all+0x110/0x110
Aug 19 12:55:11 lfs2011 kernel: [ 1543.205207]  [<c05a33d0>] 
bad_area_nosemaphore+0x12/0x14
Aug 19 12:55:11 lfs2011 kernel: [ 1543.205756]  [<c021b428>] 
do_page_fault+0x268/0x3c0
Aug 19 12:55:11 lfs2011 kernel: [ 1543.205756]  [<c03e2e9f>] ? 
fbcon_putcs+0xff/0x130
Aug 19 12:55:11 lfs2011 kernel: [ 1543.205756]  [<c03e6cf0>] ? 
bit_cursor+0x530/0x530
Aug 19 12:55:11 lfs2011 kernel: [ 1543.205756]  [<c021b1c0>] ? 
vmalloc_sync_all+0x110/0x110
Aug 19 12:55:11 lfs2011 kernel: [ 1543.205756]  [<c05a93a2>] 
error_code+0x5a/0x60
Aug 19 12:55:11 lfs2011 kernel: [ 1543.205756]  [<c021b1c0>] ? 
vmalloc_sync_all+0x110/0x110
Aug 19 12:55:11 lfs2011 kernel: [ 1543.205756]  [<c0417460>] ? 
check_tty_count+0x30/0xa0
Aug 19 12:55:11 lfs2011 kernel: [ 1543.205756]  [<c04180bb>] ? 
tty_add_file+0x6b/0x90
Aug 19 12:55:11 lfs2011 kernel: [ 1543.205756]  [<c0419a43>] 
tty_open+0x1a3/0x4d0
Aug 19 12:55:11 lfs2011 kernel: [ 1543.205756]  [<c02aaa6a>] 
chrdev_open+0xda/0x1e0
Aug 19 12:55:11 lfs2011 kernel: [ 1543.205756]  [<c02a591b>] 
__dentry_open.isra.17+0x11b/0x290
Aug 19 12:55:11 lfs2011 kernel: [ 1543.205756]  [<c02a6914>] 
nameidata_to_filp+0x54/0x70
Aug 19 12:55:11 lfs2011 kernel: [ 1543.205756]  [<c02aa990>] ? 
cdev_put+0x20/0x20
Aug 19 12:55:11 lfs2011 kernel: [ 1543.205756]  [<c02b346f>] 
do_last.isra.47+0x23f/0x700
Aug 19 12:55:11 lfs2011 kernel: [ 1543.215183]  [<c02b3b7d>] 
path_openat+0x8d/0x320
Aug 19 12:55:11 lfs2011 kernel: [ 1543.215845]  [<c041812c>] ? 
tty_del_file+0x4c/0x60
Aug 19 12:55:11 lfs2011 kernel: [ 1543.216480]  [<c02b3e3c>] 
do_filp_open+0x2c/0x80
Aug 19 12:55:11 lfs2011 kernel: [ 1543.217111]  [<c02be6db>] ? 
alloc_fd+0x9b/0xe0
Aug 19 12:55:11 lfs2011 kernel: [ 1543.217736]  [<c02b0b1d>] ? 
getname_flags+0xbd/0xf0
Aug 19 12:55:11 lfs2011 kernel: [ 1543.218358]  [<c02a6a11>] 
do_sys_open+0xe1/0x1b0
Aug 19 12:55:11 lfs2011 kernel: [ 1543.219058]  [<c02a6b09>] 
sys_open+0x29/0x40
Aug 19 12:55:11 lfs2011 kernel: [ 1543.219678]  [<c05a9610>] 
sysenter_do_call+0x12/0x26
Aug 19 12:55:11 lfs2011 kernel: [ 1543.228292] BUG: unable to handle kernel 
paging request at ee80dd0b
Aug 19 12:55:11 lfs2011 kernel: [ 1543.229200] IP: [<c041814a>] 
tty_paranoia_check+0xa/0x70
Aug 19 12:55:11 lfs2011 kernel: [ 1543.229915] *pde = 00000000
Aug 19 12:55:11 lfs2011 kernel: [ 1543.230601] Oops: 0000 [#2] PREEMPT SMP
Aug 19 12:55:11 lfs2011 kernel: [ 1543.231272] Modules linked in:
Aug 19 12:55:11 lfs2011 kernel: [ 1543.231941]
Aug 19 12:55:11 lfs2011 kernel: [ 1543.232139] Pid: 1060, comm: gpm Tainted: 
G      D     3.0.3 #1 VMware, Inc. VMware Virtual Platform/440BX Desktop 
Reference Platform
Aug 19 12:55:11 lfs2011 kernel: [ 1543.232139] EIP: 0060:[<c041814a>] 
EFLAGS: 00010282 CPU: 0
Aug 19 12:55:11 lfs2011 kernel: [ 1543.232139] EIP is at 
tty_paranoia_check+0xa/0x70
Aug 19 12:55:11 lfs2011 kernel: [ 1543.232139] EAX: ee80dd0b EBX: ee80dd0b 
ECX: c066c2a5 EDX: dddd23e8
Aug 19 12:55:11 lfs2011 kernel: [ 1543.232139] ESI: 00000010 EDI: ddfaeb00 
EBP: dd07db30 ESP: dd07db20
Aug 19 12:55:11 lfs2011 kernel: [ 1543.232139]  DS: 007b ES: 007b FS: 00d8 
GS: 0000 SS: 0068
Aug 19 12:55:11 lfs2011 kernel: [ 1543.232139] Process gpm (pid: 1060, 
ti=dd07c000 task=dd0d5c70 task.ti=dd07c000)
Aug 19 12:55:11 lfs2011 kernel: [ 1543.232139] Stack:
Aug 19 12:55:11 lfs2011 kernel: [ 1543.232139]  00000286 00000286 00000286 
ded79f80 dd07dbb8 c0419412 dd07db64 c02a35fb
Aug 19 12:55:11 lfs2011 kernel: [ 1543.232139]  c02b82c4 dddd23e8 decfba9c 
dd07db58 00008f9c c02b82c4 ded79fa4 ded79f80
Aug 19 12:55:11 lfs2011 kernel: [ 1543.232139]  dddd23e8 dd07db74 c02b82c4 
ded79f80 decfba9c dd07db80 c02b99c5 ded79f80
Aug 19 12:55:11 lfs2011 kernel: [ 1543.232139] Call Trace:
Aug 19 12:55:11 lfs2011 kernel: [ 1543.232139]  [<c0419412>] 
tty_release+0x22/0x4b0
Aug 19 12:55:11 lfs2011 kernel: [ 1543.232139]  [<c02a35fb>] ? 
kmem_cache_free+0x9b/0xa0
Aug 19 12:55:11 lfs2011 kernel: [ 1543.232139]  [<c02b82c4>] ? 
__d_free+0x34/0x50
Aug 19 12:55:11 lfs2011 last message repeated 2 times
Aug 19 12:55:11 lfs2011 kernel: [ 1543.232139]  [<c02b99c5>] ? 
d_free+0x45/0x50
Aug 19 12:55:11 lfs2011 kernel: [ 1543.232139]  [<c02a8b6a>] fput+0xaa/0x1d0
Aug 19 12:55:11 lfs2011 kernel: [ 1543.232139]  [<c02a56b6>] 
filp_close+0x46/0x70
Aug 19 12:55:11 lfs2011 kernel: [ 1543.232139]  [<c0230643>] 
put_files_struct+0x73/0xd0
Aug 19 12:55:11 lfs2011 kernel: [ 1543.232139]  [<c0230740>] 
exit_files+0x40/0x50
Aug 19 12:55:11 lfs2011 kernel: [ 1543.232139]  [<c0230cc8>] 
do_exit+0x578/0x730
Aug 19 12:55:11 lfs2011 kernel: [ 1543.232139]  [<c05a38c0>] ? 
printk+0x18/0x1a
Aug 19 12:55:11 lfs2011 kernel: [ 1543.232139]  [<c0205656>] 
oops_end+0x86/0xc0
Aug 19 12:55:11 lfs2011 kernel: [ 1543.232139]  [<c05a329a>] 
no_context+0x137/0x13f
Aug 19 12:55:11 lfs2011 kernel: [ 1543.232139]  [<c05a33b6>] 
__bad_area_nosemaphore+0x114/0x11c
Aug 19 12:55:11 lfs2011 kernel: [ 1543.232139]  [<c02201ff>] ? 
pick_next_highest_task_rt+0x7f/0xe0
Aug 19 12:55:11 lfs2011 kernel: [ 1543.232139]  [<c021b1c0>] ? 
vmalloc_sync_all+0x110/0x110
Aug 19 12:55:11 lfs2011 kernel: [ 1543.232139]  [<c05a33d0>] 
bad_area_nosemaphore+0x12/0x14
Aug 19 12:55:11 lfs2011 kernel: [ 1543.232139]  [<c021b428>] 
do_page_fault+0x268/0x3c0
Aug 19 12:55:11 lfs2011 kernel: [ 1543.232139]  [<c03e2e9f>] ? 
fbcon_putcs+0xff/0x130
Aug 19 12:55:11 lfs2011 kernel: [ 1543.232139]  [<c03e6cf0>] ? 
bit_cursor+0x530/0x530
Aug 19 12:55:11 lfs2011 kernel: [ 1543.232139]  [<c021b1c0>] ? 
vmalloc_sync_all+0x110/0x110
Aug 19 12:55:11 lfs2011 kernel: [ 1543.232139]  [<c05a93a2>] 
error_code+0x5a/0x60
Aug 19 12:55:11 lfs2011 kernel: [ 1543.232139]  [<c021b1c0>] ? 
vmalloc_sync_all+0x110/0x110
Aug 19 12:55:11 lfs2011 kernel: [ 1543.232139]  [<c0417460>] ? 
check_tty_count+0x30/0xa0
Aug 19 12:55:11 lfs2011 kernel: [ 1543.232139]  [<c04180bb>] ? 
tty_add_file+0x6b/0x90
Aug 19 12:55:11 lfs2011 kernel: [ 1543.232139]  [<c0419a43>] 
tty_open+0x1a3/0x4d0
Aug 19 12:55:11 lfs2011 kernel: [ 1543.232139]  [<c02aaa6a>] 
chrdev_open+0xda/0x1e0
Aug 19 12:55:11 lfs2011 kernel: [ 1543.232139]  [<c02a591b>] 
__dentry_open.isra.17+0x11b/0x290
Aug 19 12:55:11 lfs2011 kernel: [ 1543.232139]  [<c02a6914>] 
nameidata_to_filp+0x54/0x70
Aug 19 12:55:11 lfs2011 kernel: [ 1543.232139]  [<c02aa990>] ? 
cdev_put+0x20/0x20
Aug 19 12:55:11 lfs2011 kernel: [ 1543.232139]  [<c02b346f>] 
do_last.isra.47+0x23f/0x700
Aug 19 12:55:11 lfs2011 kernel: [ 1543.232139]  [<c02b3b7d>] 
path_openat+0x8d/0x320
Aug 19 12:55:11 lfs2011 kernel: [ 1543.232139]  [<c041812c>] ? 
tty_del_file+0x4c/0x60
Aug 19 12:55:11 lfs2011 kernel: [ 1543.232139]  [<c02b3e3c>] 
do_filp_open+0x2c/0x80
Aug 19 12:55:11 lfs2011 kernel: [ 1543.232139]  [<c02be6db>] ? 
alloc_fd+0x9b/0xe0
Aug 19 12:55:11 lfs2011 kernel: [ 1543.232139]  [<c02b0b1d>] ? 
getname_flags+0xbd/0xf0
Aug 19 12:55:11 lfs2011 kernel: [ 1543.232139]  [<c02a6a11>] 
do_sys_open+0xe1/0x1b0
Aug 19 12:55:11 lfs2011 kernel: [ 1543.232139]  [<c02a6b09>] 
sys_open+0x29/0x40
Aug 19 12:55:11 lfs2011 kernel: [ 1543.232139]  [<c05a9610>] 
sysenter_do_call+0x12/0x26
Aug 19 12:55:11 lfs2011 kernel: [ 1543.232139] Code: d8 c7 46 70 00 00 00 00 
e8 04 b5 e8 ff 8b 5d f8 8b 75 fc 89 ec 5d c3 8d 76 00 8d bc 27 00 00 00 00 
55 89 e5 83 ec 10 85 c0 74 0c
Aug 19 12:55:11 lfs2011 kernel: <81>[ 1543.232139]  38 01 54 00 00 75 31 31 
c0 c9 c3 8b 42 6c 89 4c 24 0c c7 04
Aug 19 12:55:11 lfs2011 kernel: [ 1543.232139] EIP: [<c041814a>] 
tty_paranoia_check+0xa/0x70 SS:ESP 0068:dd07db20
Aug 19 12:55:11 lfs2011 kernel: [ 1543.232139] CR2: 00000000ee80dd0b
Aug 19 12:55:11 lfs2011 kernel: [ 1543.232139] ---[ end trace 
c68ab111f34450ae ]---
Aug 19 12:55:11 lfs2011 kernel: [ 1543.232139] Fixing recursive fault but 
reboot is needed!
Aug 19 12:55:11 lfs2011 kernel: [ 1543.232139] BUG: scheduling while atomic: 
gpm/1060/0x00000002
Aug 19 12:55:11 lfs2011 kernel: [ 1543.232139] Modules linked in:
Aug 19 12:55:11 lfs2011 kernel: [ 1543.232139] Pid: 1060, comm: gpm Tainted: 
G      D     3.0.3 #1
Aug 19 12:55:11 lfs2011 kernel: [ 1543.232139] Call Trace:
Aug 19 12:55:11 lfs2011 kernel: [ 1543.232139]  [<c05a38c0>] ? 
printk+0x18/0x1a
Aug 19 12:55:11 lfs2011 kernel: [ 1543.232139]  [<c05a36a8>] 
__schedule_bug+0x55/0x5b
Aug 19 12:55:11 lfs2011 kernel: [ 1543.232139]  [<c05a6f13>] 
schedule+0x6b3/0x870
Aug 19 12:55:11 lfs2011 kernel: [ 1543.232139]  [<c0230e68>] 
do_exit+0x718/0x730
Aug 19 12:55:11 lfs2011 kernel: [ 1543.232139]  [<c022edc8>] ? 
kmsg_dump+0x98/0xc0
Aug 19 12:55:11 lfs2011 kernel: [ 1543.232139]  [<c05a38c0>] ? 
printk+0x18/0x1a
Aug 19 12:55:11 lfs2011 kernel: [ 1543.232139]  [<c0205656>] 
oops_end+0x86/0xc0
Aug 19 12:55:11 lfs2011 kernel: [ 1543.232139]  [<c05a329a>] 
no_context+0x137/0x13f
Aug 19 12:55:11 lfs2011 kernel: [ 1543.232139]  [<c05a33b6>] 
__bad_area_nosemaphore+0x114/0x11c
Aug 19 12:55:11 lfs2011 kernel: [ 1543.232139]  [<c0223aef>] ? 
task_tick_fair+0x6f/0x120
Aug 19 12:55:11 lfs2011 kernel: [ 1543.232139]  [<c021b1c0>] ? 
vmalloc_sync_all+0x110/0x110
Aug 19 12:55:11 lfs2011 kernel: [ 1543.232139]  [<c05a33d0>] 
bad_area_nosemaphore+0x12/0x14
Aug 19 12:55:11 lfs2011 kernel: [ 1543.232139]  [<c021b428>] 
do_page_fault+0x268/0x3c0
Aug 19 12:55:11 lfs2011 kernel: [ 1543.232139]  [<c0252fd1>] ? 
clockevents_program_event+0x81/0x120
Aug 19 12:55:11 lfs2011 kernel: [ 1543.232139]  [<c02542ec>] ? 
tick_program_event+0x1c/0x30
Aug 19 12:55:11 lfs2011 kernel: [ 1543.232139]  [<c0249903>] ? 
hrtimer_interrupt+0x153/0x250
Aug 19 12:55:11 lfs2011 kernel: [ 1543.232139]  [<c05a75dd>] ? 
schedule_timeout+0x14d/0x1b0
Aug 19 12:55:11 lfs2011 kernel: [ 1543.232139]  [<c021b1c0>] ? 
vmalloc_sync_all+0x110/0x110
Aug 19 12:55:11 lfs2011 kernel: [ 1543.232139]  [<c05a93a2>] 
error_code+0x5a/0x60
Aug 19 12:55:11 lfs2011 kernel: [ 1543.232139]  [<c021b1c0>] ? 
vmalloc_sync_all+0x110/0x110
Aug 19 12:55:11 lfs2011 kernel: [ 1543.232139]  [<c041814a>] ? 
tty_paranoia_check+0xa/0x70
Aug 19 12:55:11 lfs2011 kernel: [ 1543.232139]  [<c0419412>] 
tty_release+0x22/0x4b0
Aug 19 12:55:11 lfs2011 kernel: [ 1543.232139]  [<c02a35fb>] ? 
kmem_cache_free+0x9b/0xa0
Aug 19 12:55:11 lfs2011 kernel: [ 1543.232139]  [<c02b82c4>] ? 
__d_free+0x34/0x50
Aug 19 12:55:11 lfs2011 last message repeated 2 times
Aug 19 12:55:11 lfs2011 kernel: [ 1543.232139]  [<c02b99c5>] ? 
d_free+0x45/0x50
Aug 19 12:55:11 lfs2011 kernel: [ 1543.232139]  [<c02a8b6a>] fput+0xaa/0x1d0
Aug 19 12:55:11 lfs2011 kernel: [ 1543.232139]  [<c02a56b6>] 
filp_close+0x46/0x70
Aug 19 12:55:11 lfs2011 kernel: [ 1543.232139]  [<c0230643>] 
put_files_struct+0x73/0xd0
Aug 19 12:55:11 lfs2011 kernel: [ 1543.232139]  [<c0230740>] 
exit_files+0x40/0x50
Aug 19 12:55:11 lfs2011 kernel: [ 1543.232139]  [<c0230cc8>] 
do_exit+0x578/0x730
Aug 19 12:55:11 lfs2011 kernel: [ 1543.232139]  [<c05a38c0>] ? 
printk+0x18/0x1a
Aug 19 12:55:11 lfs2011 kernel: [ 1543.232139]  [<c0205656>] 
oops_end+0x86/0xc0
Aug 19 12:55:11 lfs2011 kernel: [ 1543.232139]  [<c05a329a>] 
no_context+0x137/0x13f
Aug 19 12:55:11 lfs2011 kernel: [ 1543.232139]  [<c05a33b6>] 
__bad_area_nosemaphore+0x114/0x11c
Aug 19 12:55:11 lfs2011 kernel: [ 1543.232139]  [<c02201ff>] ? 
pick_next_highest_task_rt+0x7f/0xe0
Aug 19 12:55:11 lfs2011 kernel: [ 1543.232139]  [<c021b1c0>] ? 
vmalloc_sync_all+0x110/0x110
Aug 19 12:55:11 lfs2011 kernel: [ 1543.232139]  [<c05a33d0>] 
bad_area_nosemaphore+0x12/0x14
Aug 19 12:55:11 lfs2011 kernel: [ 1543.232139]  [<c021b428>] 
do_page_fault+0x268/0x3c0
Aug 19 12:55:11 lfs2011 kernel: [ 1543.232139]  [<c03e2e9f>] ? 
fbcon_putcs+0xff/0x130
Aug 19 12:55:11 lfs2011 kernel: [ 1543.232139]  [<c03e6cf0>] ? 
bit_cursor+0x530/0x530
Aug 19 12:55:11 lfs2011 kernel: [ 1543.232139]  [<c021b1c0>] ? 
vmalloc_sync_all+0x110/0x110
Aug 19 12:55:11 lfs2011 kernel: [ 1543.232139]  [<c05a93a2>] 
error_code+0x5a/0x60
Aug 19 12:55:11 lfs2011 kernel: [ 1543.232139]  [<c021b1c0>] ? 
vmalloc_sync_all+0x110/0x110
Aug 19 12:55:11 lfs2011 kernel: [ 1543.232139]  [<c0417460>] ? 
check_tty_count+0x30/0xa0
Aug 19 12:55:11 lfs2011 kernel: [ 1543.232139]  [<c04180bb>] ? 
tty_add_file+0x6b/0x90
Aug 19 12:55:11 lfs2011 kernel: [ 1543.232139]  [<c0419a43>] 
tty_open+0x1a3/0x4d0
Aug 19 12:55:11 lfs2011 kernel: [ 1543.232139]  [<c02aaa6a>] 
chrdev_open+0xda/0x1e0
Aug 19 12:55:11 lfs2011 kernel: [ 1543.232139]  [<c02a591b>] 
__dentry_open.isra.17+0x11b/0x290
Aug 19 12:55:11 lfs2011 kernel: [ 1543.232139]  [<c02a6914>] 
nameidata_to_filp+0x54/0x70
Aug 19 12:55:11 lfs2011 kernel: [ 1543.232139]  [<c02aa990>] ? 
cdev_put+0x20/0x20
Aug 19 12:55:11 lfs2011 kernel: [ 1543.232139]  [<c02b346f>] 
do_last.isra.47+0x23f/0x700
Aug 19 12:55:11 lfs2011 kernel: [ 1543.232139]  [<c02b3b7d>] 
path_openat+0x8d/0x320
Aug 19 12:55:11 lfs2011 kernel: [ 1543.232139]  [<c041812c>] ? 
tty_del_file+0x4c/0x60
Aug 19 12:55:11 lfs2011 kernel: [ 1543.232139]  [<c02b3e3c>] 
do_filp_open+0x2c/0x80
Aug 19 12:55:11 lfs2011 kernel: [ 1543.232139]  [<c02be6db>] ? 
alloc_fd+0x9b/0xe0
Aug 19 12:55:11 lfs2011 kernel: [ 1543.232139]  [<c02b0b1d>] ? 
getname_flags+0xbd/0xf0
Aug 19 12:55:11 lfs2011 kernel: [ 1543.232139]  [<c02a6a11>] 
do_sys_open+0xe1/0x1b0
Aug 19 12:55:11 lfs2011 kernel: [ 1543.232139]  [<c02a6b09>] 
sys_open+0x29/0x40
Aug 19 12:55:11 lfs2011 kernel: [ 1543.232139]  [<c05a9610>] 
sysenter_do_call+0x12/0x26


Trace 3:

Aug 19 13:08:01 lfs2011 kernel: [  328.025450] BUG: unable to handle kernel 
paging request at 48005d20
Aug 19 13:08:01 lfs2011 kernel: [  328.025510] IP: [<c02a3c70>] 
kmem_cache_alloc+0x40/0xb0
Aug 19 13:08:01 lfs2011 kernel: [  328.025788] *pde = 00000000
Aug 19 13:08:01 lfs2011 kernel: [  328.025873] Oops: 0000 [#1] PREEMPT SMP
Aug 19 13:08:01 lfs2011 kernel: [  328.025969] Modules linked in:
Aug 19 13:08:01 lfs2011 kernel: [  328.026062]
Aug 19 13:08:01 lfs2011 kernel: [  328.026169] Pid: 1139, comm: browser Not 
tainted 3.0.3 #1 VMware, Inc. VMware Virtual Platform/440BX Desktop 
Reference Platform
Aug 19 13:08:01 lfs2011 kernel: [  328.026224] EIP: 0060:[<c02a3c70>] 
EFLAGS: 00210202 CPU: 0
Aug 19 13:08:01 lfs2011 kernel: [  328.026265] EIP is at 
kmem_cache_alloc+0x40/0xb0
Aug 19 13:08:01 lfs2011 kernel: [  328.026283] EAX: 00000000 EBX: 00006e68 
ECX: 48005d20 EDX: 00006e68
Aug 19 13:08:01 lfs2011 kernel: [  328.026295] ESI: df002280 EDI: c074ea50 
EBP: c3e31d80 ESP: c3e31d5c
Aug 19 13:08:01 lfs2011 kernel: [  328.026308]  DS: 007b ES: 007b FS: 00d8 
GS: 0033 SS: 0068
Aug 19 13:08:01 lfs2011 kernel: [  328.026334] Process browser (pid: 1139, 
ti=c3e30000 task=df26d040 task.ti=c3e30000)
Aug 19 13:08:01 lfs2011 kernel: [  328.026348] Stack:
Aug 19 13:08:01 lfs2011 kernel: [  328.026376]  48005d20 00000006 c3e30000 
00006e68 c0393844 000080d0 00000001 00000000
Aug 19 13:08:01 lfs2011 kernel: [  328.026409]  00000001 c3e31f78 c0393844 
ca5f435e ffffffff 05fa0d5e 00000000 00000001
Aug 19 13:08:01 lfs2011 kernel: [  328.026414]  05fa0d5e 00000001 c06dd5c0 
00000000 c3e31db0 ffff0000 00001000 000280da
Aug 19 13:08:01 lfs2011 kernel: [  328.026446] Call Trace:
Aug 19 13:08:01 lfs2011 kernel: [  328.026609]  [<c0393844>] ? 
sys_semtimedop+0x454/0x7f0
Aug 19 13:08:01 lfs2011 kernel: [  328.026630]  [<c0393844>] 
sys_semtimedop+0x454/0x7f0
Aug 19 13:08:01 lfs2011 kernel: [  328.026646]  [<c027acfa>] ? 
find_get_page+0x5a/0xa0
Aug 19 13:08:01 lfs2011 kernel: [  328.026651]  [<c027ce74>] ? 
filemap_fault+0x84/0x3c0
Aug 19 13:08:01 lfs2011 kernel: [  328.026655]  [<c028082c>] ? 
__alloc_pages_nodemask+0xec/0x5c0
Aug 19 13:08:01 lfs2011 kernel: [  328.026659]  [<c027aebd>] ? 
unlock_page+0x3d/0x40
Aug 19 13:08:01 lfs2011 kernel: [  328.026664]  [<c0290ff8>] ? 
__do_fault+0x318/0x3f0
Aug 19 13:08:01 lfs2011 kernel: [  328.026671]  [<c0222526>] ? 
finish_task_switch+0x46/0xa0
Aug 19 13:08:01 lfs2011 kernel: [  328.026676]  [<c02931d9>] ? 
handle_pte_fault+0xd9/0x660
Aug 19 13:08:01 lfs2011 kernel: [  328.026681]  [<c02937f5>] ? 
handle_mm_fault+0x95/0x100
Aug 19 13:08:01 lfs2011 kernel: [  328.026687]  [<c021b1c0>] ? 
vmalloc_sync_all+0x110/0x110
Aug 19 13:08:01 lfs2011 kernel: [  328.026691]  [<c021b33b>] ? 
do_page_fault+0x17b/0x3c0
Aug 19 13:08:01 lfs2011 kernel: [  328.026696]  [<c02a7747>] ? 
vfs_read+0x117/0x160
Aug 19 13:08:01 lfs2011 kernel: [  328.026700]  [<c03951b0>] 
sys_ipc+0x80/0x230
Aug 19 13:08:01 lfs2011 kernel: [  328.026703]  [<c02a77c8>] ? 
sys_read+0x38/0x70
Aug 19 13:08:01 lfs2011 kernel: [  328.026724]  [<c05a9610>] 
sysenter_do_call+0x12/0x26
Aug 19 13:08:01 lfs2011 kernel: [  328.026763] Code: 55 f0 89 4d ec 8b 06 64 
03 05 14 ae 74 c0 8b 50 04 89 55 e8 8b 00 85 c0 89 45 dc 74 6a 8b 4d dc 8b 
46 14 8b 5d e8 8b 55 e8 8b 3e <8b> 04 01 83 c3 04 89 5d e0 8b 4d e0 89 45 e4 
89 c3 8b 45 dc 64
Aug 19 13:08:01 lfs2011 kernel: [  328.026901] EIP: [<c02a3c70>] 
kmem_cache_alloc+0x40/0xb0 SS:ESP 0068:c3e31d5c
Aug 19 13:08:01 lfs2011 kernel: [  328.026943] CR2: 0000000048005d20
Aug 19 13:08:01 lfs2011 kernel: [  328.027174] ---[ end trace 
dc4a4d3a4980617a ]---
Aug 19 13:08:01 lfs2011 kernel: [  328.030011] BUG: unable to handle kernel 
paging request at 2060c02c
Aug 19 13:08:01 lfs2011 kernel: [  328.030023] IP: [<c041814a>] 
tty_paranoia_check+0xa/0x70
Aug 19 13:08:01 lfs2011 kernel: [  328.030040] *pde = 00000000
Aug 19 13:08:01 lfs2011 kernel: [  328.030043] Oops: 0000 [#2] PREEMPT SMP
Aug 19 13:08:01 lfs2011 kernel: [  328.030046] Modules linked in:
Aug 19 13:08:01 lfs2011 kernel: [  328.030052]
Aug 19 13:08:01 lfs2011 kernel: [  328.030094] Pid: 1139, comm: browser 
Tainted: G      D     3.0.3 #1 VMware, Inc. VMware Virtual Platform/440BX 
Desktop Reference Platform
Aug 19 13:08:01 lfs2011 kernel: [  328.030101] EIP: 0060:[<c041814a>] 
EFLAGS: 00210202 CPU: 0
Aug 19 13:08:01 lfs2011 kernel: [  328.030105] EIP is at 
tty_paranoia_check+0xa/0x70
Aug 19 13:08:01 lfs2011 kernel: [  328.030110] EAX: 2060c02c EBX: 2060c02c 
ECX: c066c2a5 EDX: ddfa5e68
Aug 19 13:08:01 lfs2011 kernel: [  328.030113] ESI: 00000008 EDI: df0aca00 
EBP: c3e31abc ESP: c3e31aac
Aug 19 13:08:01 lfs2011 kernel: [  328.030115]  DS: 007b ES: 007b FS: 00d8 
GS: 0000 SS: 0068
Aug 19 13:08:01 lfs2011 kernel: [  328.030118] Process browser (pid: 1139, 
ti=c3e30000 task=df26d040 task.ti=c3e30000)
Aug 19 13:08:01 lfs2011 kernel: [  328.030120] Stack:
Aug 19 13:08:01 lfs2011 kernel: [  328.030121]  00200282 dec30a80 00200282 
ded21b00 c3e31b44 c0419412 c3e31af0 c02a35fb
Aug 19 13:08:01 lfs2011 kernel: [  328.030126]  c02b82c4 ddfa5e68 dec30d9c 
c3e31ae4 0001bc74 c02b82c4 ded21b24 ded21b00
Aug 19 13:08:01 lfs2011 kernel: [  328.030131]  ddfa5e68 c3e31b00 c02b82c4 
ded21b00 dec30d9c c3e31b0c c02b99c5 ded21b00
Aug 19 13:08:01 lfs2011 kernel: [  328.030136] Call Trace:
Aug 19 13:08:01 lfs2011 kernel: [  328.030141]  [<c0419412>] 
tty_release+0x22/0x4b0
Aug 19 13:08:01 lfs2011 kernel: [  328.030146]  [<c02a35fb>] ? 
kmem_cache_free+0x9b/0xa0
Aug 19 13:08:01 lfs2011 kernel: [  328.030152]  [<c02b82c4>] ? 
__d_free+0x34/0x50
Aug 19 13:08:01 lfs2011 kernel: [  328.030156]  [<c02b82c4>] ? 
__d_free+0x34/0x50
Aug 19 13:08:01 lfs2011 kernel: [  328.030159]  [<c02b82c4>] ? 
__d_free+0x34/0x50
Aug 19 13:08:01 lfs2011 kernel: [  328.030163]  [<c02b99c5>] ? 
d_free+0x45/0x50
Aug 19 13:08:01 lfs2011 kernel: [  328.030167]  [<c02a8b6a>] fput+0xaa/0x1d0
Aug 19 13:08:01 lfs2011 kernel: [  328.030171]  [<c02a56b6>] 
filp_close+0x46/0x70
Aug 19 13:08:01 lfs2011 kernel: [  328.030175]  [<c0230643>] 
put_files_struct+0x73/0xd0
Aug 19 13:08:01 lfs2011 kernel: [  328.030179]  [<c0230740>] 
exit_files+0x40/0x50
Aug 19 13:08:01 lfs2011 kernel: [  328.030183]  [<c0230cc8>] 
do_exit+0x578/0x730
Aug 19 13:08:01 lfs2011 kernel: [  328.030187]  [<c05a38c0>] ? 
printk+0x18/0x1a
Aug 19 13:08:01 lfs2011 kernel: [  328.030192]  [<c0205656>] 
oops_end+0x86/0xc0
Aug 19 13:08:01 lfs2011 kernel: [  328.030196]  [<c05a329a>] 
no_context+0x137/0x13f
Aug 19 13:08:01 lfs2011 kernel: [  328.030200]  [<c05a33b6>] 
__bad_area_nosemaphore+0x114/0x11c
Aug 19 13:08:01 lfs2011 kernel: [  328.030204]  [<c0220d03>] ? 
cpuacct_charge+0x53/0x60
Aug 19 13:08:01 lfs2011 kernel: [  328.030208]  [<c0220e6e>] ? 
update_curr+0x15e/0x1b0
Aug 19 13:08:01 lfs2011 kernel: [  328.030211]  [<c05a3405>] 
bad_area+0x33/0x39
Aug 19 13:08:01 lfs2011 kernel: [  328.030216]  [<c021b1c0>] ? 
vmalloc_sync_all+0x110/0x110
Aug 19 13:08:01 lfs2011 kernel: [  328.030220]  [<c021b514>] 
do_page_fault+0x354/0x3c0
Aug 19 13:08:01 lfs2011 kernel: [  328.030224]  [<c0201a47>] ? 
__switch_to+0x147/0x1d0
Aug 19 13:08:01 lfs2011 kernel: [  328.030228]  [<c021b1c0>] ? 
vmalloc_sync_all+0x110/0x110
Aug 19 13:08:01 lfs2011 kernel: [  328.030232]  [<c05a93a2>] 
error_code+0x5a/0x60
Aug 19 13:08:01 lfs2011 kernel: [  328.030236]  [<c021b1c0>] ? 
vmalloc_sync_all+0x110/0x110
Aug 19 13:08:01 lfs2011 kernel: [  328.030240]  [<c02a3c70>] ? 
kmem_cache_alloc+0x40/0xb0
Aug 19 13:08:01 lfs2011 kernel: [  328.030244]  [<c0393844>] ? 
sys_semtimedop+0x454/0x7f0
Aug 19 13:08:01 lfs2011 kernel: [  328.030248]  [<c0393844>] 
sys_semtimedop+0x454/0x7f0
Aug 19 13:08:01 lfs2011 kernel: [  328.030253]  [<c027acfa>] ? 
find_get_page+0x5a/0xa0
Aug 19 13:08:01 lfs2011 kernel: [  328.030257]  [<c027ce74>] ? 
filemap_fault+0x84/0x3c0
Aug 19 13:08:01 lfs2011 kernel: [  328.030262]  [<c028082c>] ? 
__alloc_pages_nodemask+0xec/0x5c0
Aug 19 13:08:01 lfs2011 kernel: [  328.030266]  [<c027aebd>] ? 
unlock_page+0x3d/0x40
Aug 19 13:08:01 lfs2011 kernel: [  328.030270]  [<c0290ff8>] ? 
__do_fault+0x318/0x3f0
Aug 19 13:08:01 lfs2011 kernel: [  328.030274]  [<c0222526>] ? 
finish_task_switch+0x46/0xa0
Aug 19 13:08:01 lfs2011 kernel: [  328.030278]  [<c02931d9>] ? 
handle_pte_fault+0xd9/0x660
Aug 19 13:08:01 lfs2011 kernel: [  328.030282]  [<c02937f5>] ? 
handle_mm_fault+0x95/0x100
Aug 19 13:08:01 lfs2011 kernel: [  328.030286]  [<c021b1c0>] ? 
vmalloc_sync_all+0x110/0x110
Aug 19 13:08:01 lfs2011 kernel: [  328.030290]  [<c021b33b>] ? 
do_page_fault+0x17b/0x3c0
Aug 19 13:08:01 lfs2011 kernel: [  328.030294]  [<c02a7747>] ? 
vfs_read+0x117/0x160
Aug 19 13:08:01 lfs2011 kernel: [  328.030298]  [<c03951b0>] 
sys_ipc+0x80/0x230
Aug 19 13:08:01 lfs2011 kernel: [  328.030301]  [<c02a77c8>] ? 
sys_read+0x38/0x70
Aug 19 13:08:01 lfs2011 kernel: [  328.030305]  [<c05a9610>] 
sysenter_do_call+0x12/0x26
Aug 19 13:08:01 lfs2011 kernel: [  328.030307] Code: d8 c7 46 70 00 00 00 00 
e8 04 b5 e8 ff 8b 5d f8 8b 75 fc 89 ec 5d c3 8d 76 00 8d bc 27 00 00 00 00 
55 89 e5 83 ec 10 85 c0 74 0c
Aug 19 13:08:01 lfs2011 kernel: <81>[  328.030333]  38 01 54 00 00 75 31 31 
c0 c9 c3 8b 42 6c 89 4c 24 0c c7 04
Aug 19 13:08:01 lfs2011 kernel: [  328.030344] EIP: [<c041814a>] 
tty_paranoia_check+0xa/0x70 SS:ESP 0068:c3e31aac
Aug 19 13:08:01 lfs2011 kernel: [  328.030349] CR2: 000000002060c02c
Aug 19 13:08:01 lfs2011 kernel: [  328.030357] ---[ end trace 
dc4a4d3a4980617b ]---
Aug 19 13:08:01 lfs2011 kernel: [  328.030370] Fixing recursive fault but 
reboot is needed!
Aug 19 13:08:01 lfs2011 kernel: [  328.031007] BUG: unable to handle kernel 
paging request at 23f0c02c
Aug 19 13:08:01 lfs2011 kernel: [  328.031012] IP: [<c0417460>] 
check_tty_count+0x30/0xa0
Aug 19 13:08:01 lfs2011 kernel: [  328.031020] *pde = 00000000
Aug 19 13:08:01 lfs2011 kernel: [  328.031023] Oops: 0000 [#3] PREEMPT SMP
Aug 19 13:08:01 lfs2011 kernel: [  328.031026] Modules linked in:
Aug 19 13:08:01 lfs2011 kernel: [  328.031028]
Aug 19 13:08:01 lfs2011 kernel: [  328.031033] Pid: 1140, comm: syslogd 
Tainted: G      D     3.0.3 #1 VMware, Inc. VMware Virtual Platform/440BX 
Desktop Reference Platform
Aug 19 13:08:01 lfs2011 kernel: [  328.031039] EIP: 0060:[<c0417460>] 
EFLAGS: 00010207 CPU: 0
Aug 19 13:08:01 lfs2011 kernel: [  328.031042] EIP is at 
check_tty_count+0x30/0xa0
Aug 19 13:08:01 lfs2011 kernel: [  328.031045] EAX: 23f0c02c EBX: ddde4800 
ECX: 00006e70 EDX: ddde4914
Aug 19 13:08:01 lfs2011 kernel: [  328.031050] ESI: 00000002 EDI: c066c2b5 
EBP: ddf1bde4 ESP: ddf1bdc4
Aug 19 13:08:01 lfs2011 kernel: [  328.031052]  DS: 007b ES: 007b FS: 00d8 
GS: 0033 SS: 0068
Aug 19 13:08:01 lfs2011 kernel: [  328.031055] Process syslogd (pid: 1140, 
ti=ddf1a000 task=df26d860 task.ti=ddf1a000)
Aug 19 13:08:01 lfs2011 kernel: [  328.031057] Stack:
Aug 19 13:08:01 lfs2011 kernel: [  328.031058]  ddde4800 df094c80 00400001 
ddf1bde4 c04180bb 00000000 ddde4800 00400001
Aug 19 13:08:01 lfs2011 kernel: [  328.031063]  ddf1be14 c0419a43 ddde4818 
dd09c3e8 df26d860 00000101 00000100 df094c80
Aug 19 13:08:01 lfs2011 kernel: [  328.031068]  00000000 dd09c3e8 df0b40c8 
df094c80 ddf1be30 c02aaa6a 00000000 ddf1be30
Aug 19 13:08:01 lfs2011 kernel: [  328.031073] Call Trace:
Aug 19 13:08:01 lfs2011 kernel: [  328.031077]  [<c04180bb>] ? 
tty_add_file+0x6b/0x90
Aug 19 13:08:01 lfs2011 kernel: [  328.031081]  [<c0419a43>] 
tty_open+0x1a3/0x4d0
Aug 19 13:08:01 lfs2011 kernel: [  328.031085]  [<c02aaa6a>] 
chrdev_open+0xda/0x1e0
Aug 19 13:08:01 lfs2011 kernel: [  328.031090]  [<c02a591b>] 
__dentry_open.isra.17+0x11b/0x290
Aug 19 13:08:01 lfs2011 kernel: [  328.031094]  [<c02a6914>] 
nameidata_to_filp+0x54/0x70
Aug 19 13:08:01 lfs2011 kernel: [  328.031097]  [<c02aa990>] ? 
cdev_put+0x20/0x20
Aug 19 13:08:01 lfs2011 kernel: [  328.031101]  [<c02b346f>] 
do_last.isra.47+0x23f/0x700
Aug 19 13:08:01 lfs2011 kernel: [  328.031105]  [<c02b3b7d>] 
path_openat+0x8d/0x320
Aug 19 13:08:01 lfs2011 kernel: [  328.031110]  [<c03ba968>] ? 
timerqueue_add+0x58/0xb0
Aug 19 13:08:01 lfs2011 kernel: [  328.031113]  [<c02b3e3c>] 
do_filp_open+0x2c/0x80
Aug 19 13:08:01 lfs2011 kernel: [  328.031118]  [<c02be6db>] ? 
alloc_fd+0x9b/0xe0
Aug 19 13:08:01 lfs2011 kernel: [  328.031121]  [<c02b0b1d>] ? 
getname_flags+0xbd/0xf0
Aug 19 13:08:01 lfs2011 kernel: [  328.031125]  [<c02a6a11>] 
do_sys_open+0xe1/0x1b0
Aug 19 13:08:01 lfs2011 kernel: [  328.031128]  [<c02a6b09>] 
sys_open+0x29/0x40
Aug 19 13:08:01 lfs2011 kernel: [  328.031132]  [<c05a9610>] 
sysenter_do_call+0x12/0x26
Aug 19 13:08:01 lfs2011 kernel: [  328.031134] Code: d7 56 31 f6 53 89 c3 83 
ec 14 b8 e4 cc 78 c0 e8 37 14 19 00 8b 83 14 01 00 00 8d 93 14 01 00 00 39 
d0 74 10 8d b4 26 00 00 00 00 <8b> 00 83 c6 01 39 d0 75 f7 b8 e4 cc 78 c0 e8 
dd 15 19 00 8b 43
Aug 19 13:08:01 lfs2011 kernel: [  328.031161] EIP: [<c0417460>] 
check_tty_count+0x30/0xa0 SS:ESP 0068:ddf1bdc4
Aug 19 13:08:01 lfs2011 kernel: [  328.031166] CR2: 0000000023f0c02c
Aug 19 13:08:01 lfs2011 kernel: [  328.031168] ---[ end trace 
dc4a4d3a4980617c ]---  

