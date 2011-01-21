Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752436Ab1AUDM1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jan 2011 22:12:27 -0500
Received: from tn-76-7-162-101.sta.embarqhsd.net ([76.7.162.101]:43574 "EHLO
	animx.eu.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750856Ab1AUDM0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jan 2011 22:12:26 -0500
X-Greylist: delayed 1385 seconds by postgrey-1.27 at vger.kernel.org; Thu, 20 Jan 2011 22:12:25 EST
Date: Thu, 20 Jan 2011 21:49:18 -0500
From: Wakko Warner <wakko@animx.eu.org>
To: linux-kernel@vger.kernel.org
Subject: NILFS crash on 2.6.37
Message-ID: <20110121024918.GA29598@animx.eu.org>
Mail-Followup-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.6+20040907i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

At one time I had created a filesystem with nilfs on it.  I don't know if
it's nilfs or nilfs2.  Attempting to mount it with nilfs2 on 2.6.37 (also
happens on 2.6.36.2), the kernel oopses.  Once the kernel oopses, any
further attempts to mount it hangs the process.  I have also noticed that
attempting to umount other filesystems also hangs the process.

[ 1202.579525] NILFS version 2 loaded
[ 1202.581501] NILFS warning: broken superblock. using spare superblock.
[ 1202.582093] NILFS warning: broken superblock. using spare superblock.
[ 1202.821896] segctord starting. Construction interval = 5 seconds, CP frequency < 30 seconds
[ 1202.824419] BUG: unable to handle kernel NULL pointer dereference at   (null)
[ 1202.824561] IP: [<c03196bc>] memcpy+0xc/0x1b
[ 1202.824667] *pdpt = 0000000033b94001 *pde = 0000000000000000 
[ 1202.824797] Oops: 0002 [#1] SMP 
[ 1202.824922] last sysfs file: /sys/devices/virtual/block/dm-9/dm/name
[ 1202.824978] Modules linked in: nilfs2 crc32 sha256_generic nfsd exportfs ipv6 nfs lockd nfs_acl auth_rpcgss sunrpc ext2 8250_pnp sr_mod cdrom ata_piix e1000 floppy aic7xxx libata sg 8250 evdev serial_core button processor thermal_sys
[ 1202.825136] 
[ 1202.825136] Pid: 3529, comm: mount.nilfs2 Not tainted 2.6.37 #1 /
[ 1202.825136] EIP: 0060:[<c03196bc>] EFLAGS: 00010202 CPU: 3
[ 1202.825136] EIP is at memcpy+0xc/0x1b
[ 1202.825136] EAX: 00000000 EBX: 00000100 ECX: 00000040 EDX: f7b55400
[ 1202.825136] ESI: f7b55400 EDI: 00000000 EBP: f3f45b20 ESP: f3b35e74
[ 1202.825136]  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
[ 1202.825136] Process mount.nilfs2 (pid: 3529, ti=f3b34000 task=f3870d40 task.ti=f3b34000)
[ 1202.825136] Stack:
[ 1202.825136]  f3d77cc0 f3f45b00 f7b55400 f953720e f51f0c38 f95369e9 00000000 00000000
[ 1202.825136]  f3f45b08 00000000 f9537a08 00000001 f3b35ee8 f5006584 00000002 00000003
[ 1202.825136]  f51f0c00 f4c23800 f3d77cc0 f3f45b00 00000000 392d6d64 00000000 f50dbde0
[ 1202.825136] Call Trace:
[ 1202.825136]  [<f953720e>] ? nilfs_setup_super+0x6c/0xa5 [nilfs2]
[ 1202.825136]  [<f95369e9>] ? nilfs_get_root_dentry+0x81/0xcb [nilfs2]
[ 1202.825136]  [<f9537a08>] ? nilfs_mount+0x4f9/0x62c [nilfs2]
[ 1202.825136]  [<c02745cf>] ? kstrdup+0x36/0x3f
[ 1202.825136]  [<f953750f>] ? nilfs_mount+0x0/0x62c [nilfs2]
[ 1202.825136]  [<c0293940>] ? vfs_kern_mount+0x4d/0x12c
[ 1202.825136]  [<c02a5100>] ? get_fs_type+0x76/0x8f
[ 1202.825136]  [<c0293a68>] ? do_kern_mount+0x33/0xbf
[ 1202.825136]  [<c02a784a>] ? do_mount+0x2ed/0x714
[ 1202.825136]  [<c02a6171>] ? copy_mount_options+0x28/0xfc
[ 1202.825136]  [<c02a7ce3>] ? sys_mount+0x72/0xaf
[ 1202.825136]  [<c0473085>] ? syscall_call+0x7/0xb
[ 1202.825136] Code: 43 4c 04 83 fe 01 19 c0 24 fc 04 08 88 43 4d 5b 5e 5f c3 90 90 90 90 90 90 90 90 90 90 90 90 57 56 53 89 cb c1 e9 02 89 c7 89 d6 <f3> a5 89 d9 83 e1 03 74 02 f3 a4 5b 5e 5f c3 55 57 56 53 89 c5 
[ 1202.825136] EIP: [<c03196bc>] memcpy+0xc/0x1b SS:ESP 0068:f3b35e74
[ 1202.825136] CR2: 0000000000000000
[ 1202.831111] ---[ end trace e5a2d0918d598efa ]---

-- 
 Microsoft has beaten Volkswagen's world record.  Volkswagen only created 22
 million bugs.
