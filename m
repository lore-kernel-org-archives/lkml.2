Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755626Ab0JJRc1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Oct 2010 13:32:27 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:54766 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751129Ab0JJRcZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Oct 2010 13:32:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=dp8YHHGgUKze16tbWxVWpdqmRHctMQALd/LyqMZBSIgoMfhQrSsRZ8/hXDtPsERZUO
         u9prsw73091sXE9qRWQRcQVYJ1uRk8oyuZ5svArdGY5oMbtdYFChG11rU4saBOUMuXr6
         5Kh5YW/tdJ1r4znLS8B4h7fWLRY3fFUsp7Ny4=
MIME-Version: 1.0
Date: Sun, 10 Oct 2010 23:02:24 +0530
Message-ID: <AANLkTi=JkcuWBPo+X-i+9o-BJFVqjea1J3e=Mr=HvAWF@mail.gmail.com>
Subject: [LogFS][2.6.36.rc7+] Kernel BUG at readwrite.c:1193
From: Prasad Joshi <prasadjoshi124@gmail.com>
To: linux-fsdevel@vger.kernel.org, Joern <joern@logfs.org>,
        Al Viro <viro@zeniv.linux.org.uk>, Tejun Heo <tj@kernel.org>,
        Christoph Lameter <cl@linux-foundation.org>, logfs@logfs.org,
        Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

<2>[ 4452.144286] kernel BUG at /home/prasad/logfs_code/readwrite.c:1193!
<0>[ 4452.144352] invalid opcode: 0000 [#1] SMP
<0>[ 4452.144461] last sysfs file:
/sys/devices/pci0000:00/0000:00:10.0/host2/uevent
<4>[ 4452.144565] Modules linked in: logfs binfmt_misc acpiphp psmouse
shpchp serio_raw mptspi pcnet32 mptscsih mptbase intel_agp floppy mii
scsi_transport_spi agpgart [last unloaded: logfs]
<4>[ 4452.144857]
<4>[ 4452.145005] Pid: 2956, comm: fs_stress Not tainted 2.6.34-rc5 #2
440BX Desktop Reference Platform/VMware Virtual Platform
<4>[ 4452.145050] EIP: 0060:[<e099e05c>] EFLAGS: 00010286 CPU: 0
<4>[ 4452.145604] EIP is at fill_shadow_tree+0x21c/0x420 [logfs]
<4>[ 4452.145645] EAX: c4f2aedf EBX: df578210 ECX: c4f2a1a0 EDX: d937a000
<4>[ 4452.145668] ESI: d4dfc840 EDI: cc9ff000 EBP: d8205ca0 ESP: d8205c74
<4>[ 4452.145689]  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
<0>[ 4452.145733] Process fs_stress (pid: 2956, ti=d8204000
task=d4d29980 task.ti=d8204000)
<0>[ 4452.145753] Stack:
<4>[ 4452.145753]  00000000 00000000 cc9ff000 d937a000 d4dfc840
00000000 06da3b50 df578210
<4>[ 4452.145753] <0> d8205d14 c13565c0 cc9ff000 d8205cd8 e099e5b1
00000000 00000000 00000000
<4>[ 4452.145753] <0> 0100001e 00000000 df578210 0000021e 00000000
00205cd8 0000001e 00000000
<0>[ 4452.145753] Call Trace:
<4>[ 4452.145753]  [<e099e5b1>] ? logfs_write_i0+0x91/0x170 [logfs]
<4>[ 4452.145753]  [<e099fb66>] ? __logfs_write_rec+0x176/0x2b0 [logfs]
<4>[ 4452.145753]  [<e099fad8>] ? __logfs_write_rec+0xe8/0x2b0 [logfs]
<4>[ 4452.145753]  [<e099fd0b>] ? logfs_write_rec+0x6b/0xd0 [logfs]
<4>[ 4452.145753]  [<e09a0811>] ? __logfs_delete+0x41/0x70 [logfs]
<4>[ 4452.145753]  [<e09a0920>] ? logfs_delete_inode+0xe0/0x140 [logfs]
<4>[ 4452.145753]  [<c0203a0f>] ? generic_delete_inode+0x6f/0x100
<4>[ 4452.145753]  [<c020427d>] ? generic_drop_inode+0x3d/0x60
<4>[ 4452.145753]  [<e099afab>] ? logfs_drop_inode+0x6b/0x80 [logfs]
<4>[ 4452.145753]  [<c0203091>] ? iput+0x41/0x60
<4>[ 4452.145753]  [<e0999685>] ? __logfs_create+0xd5/0x1b0 [logfs]
<4>[ 4452.145753]  [<c0203b11>] ? __insert_inode_hash+0x31/0x60
<4>[ 4452.145753]  [<e0999885>] ? logfs_create+0x55/0x60 [logfs]
<4>[ 4452.145753]  [<c01f9bfa>] ? vfs_create+0x9a/0xc0
<4>[ 4452.145753]  [<c01fac07>] ? do_last+0x557/0x5d0
<4>[ 4452.145753]  [<c01fc742>] ? do_filp_open+0x182/0x4d0
<4>[ 4452.145753]  [<c01f044c>] ? do_sync_write+0x9c/0xd0
<4>[ 4452.145753]  [<c01f9335>] ? getname+0x25/0xf0
<4>[ 4452.145753]  [<c01ee9af>] ? do_sys_open+0x4f/0x110
<4>[ 4452.145753]  [<c01f2005>] ? fput+0x15/0x20
<4>[ 4452.145753]  [<c01eead9>] ? sys_open+0x29/0x40
<4>[ 4452.145753]  [<c0102fd7>] ? sysenter_do_call+0x12/0x22
<0>[ 4452.145753] Code: ac 00 00 00 8b 83 a4 00 00 00 8b 7d e4 8b 4f
74 89 fa ff 51 04 e9 23 fe ff ff 8b 01 83 e8 01 83 f8 08 77 07 ff 24
85 e0 45 9a e0 <0f> 0b eb fe 8b ba b4 00 00 00 3b 79 10 8b 82 b0 00 00
00 74 1d
<0>[ 4452.145753] EIP: [<e099e05c>] fill_shadow_tree+0x21c/0x420
[logfs] SS:ESP 0068:d8205c74
<4>[ 4452.147817] ---[ end trace b5f16f25f1682b9d ]---
