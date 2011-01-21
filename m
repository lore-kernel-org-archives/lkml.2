Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753591Ab1AUHir (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jan 2011 02:38:47 -0500
Received: from sh.osrg.net ([192.16.179.4]:59321 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750872Ab1AUHip (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jan 2011 02:38:45 -0500
Date: Fri, 21 Jan 2011 16:37:38 +0900 (JST)
Message-Id: <20110121.163738.135792151.ryusuke@osrg.net>
To: wakko@animx.eu.org
Cc: linux-nilfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: NILFS crash on 2.6.37
From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
In-Reply-To: <20110121024918.GA29598@animx.eu.org>
References: <20110121024918.GA29598@animx.eu.org>
X-Mailer: Mew version 5.2 on Emacs 22.2 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Fri, 21 Jan 2011 16:37:40 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(Cc'ed to linux-nilfs)
On Thu, 20 Jan 2011 21:49:18 -0500, Wakko Warner wrote:
> At one time I had created a filesystem with nilfs on it.  I don't know if
> it's nilfs or nilfs2.  Attempting to mount it with nilfs2 on 2.6.37 (also
> happens on 2.6.36.2), the kernel oopses.  Once the kernel oopses, any
> further attempts to mount it hangs the process.  I have also noticed that
> attempting to umount other filesystems also hangs the process.
> 
> [ 1202.579525] NILFS version 2 loaded
> [ 1202.581501] NILFS warning: broken superblock. using spare superblock.
> [ 1202.582093] NILFS warning: broken superblock. using spare superblock.
> [ 1202.821896] segctord starting. Construction interval = 5 seconds, CP frequency < 30 seconds
> [ 1202.824419] BUG: unable to handle kernel NULL pointer dereference at   (null)
> [ 1202.824561] IP: [<c03196bc>] memcpy+0xc/0x1b
> [ 1202.824667] *pdpt = 0000000033b94001 *pde = 0000000000000000 
> [ 1202.824797] Oops: 0002 [#1] SMP 
<snip>
> [ 1202.825136] Call Trace:
> [ 1202.825136]  [<f953720e>] ? nilfs_setup_super+0x6c/0xa5 [nilfs2]
> [ 1202.825136]  [<f95369e9>] ? nilfs_get_root_dentry+0x81/0xcb [nilfs2]
> [ 1202.825136]  [<f9537a08>] ? nilfs_mount+0x4f9/0x62c [nilfs2]
> [ 1202.825136]  [<c02745cf>] ? kstrdup+0x36/0x3f
> [ 1202.825136]  [<f953750f>] ? nilfs_mount+0x0/0x62c [nilfs2]
> [ 1202.825136]  [<c0293940>] ? vfs_kern_mount+0x4d/0x12c
> [ 1202.825136]  [<c02a5100>] ? get_fs_type+0x76/0x8f
> [ 1202.825136]  [<c0293a68>] ? do_kern_mount+0x33/0xbf
> [ 1202.825136]  [<c02a784a>] ? do_mount+0x2ed/0x714
> [ 1202.825136]  [<c02a6171>] ? copy_mount_options+0x28/0xfc
> [ 1202.825136]  [<c02a7ce3>] ? sys_mount+0x72/0xaf
> [ 1202.825136]  [<c0473085>] ? syscall_call+0x7/0xb
> [ 1202.825136] Code: 43 4c 04 83 fe 01 19 c0 24 fc 04 08 88 43 4d 5b 5e 5f c3 90 90 90 90 90 90 90 90 90 90 90 90 57 56 53 89 cb c1 e9 02 89 c7 89 d6 <f3> a5 89 d9 83 e1 03 74 02 f3 a4 5b 5e 5f c3 55 57 56 53 89 c5 
> [ 1202.825136] EIP: [<c03196bc>] memcpy+0xc/0x1b SS:ESP 0068:f3b35e74
> [ 1202.825136] CR2: 0000000000000000
> [ 1202.831111] ---[ end trace e5a2d0918d598efa ]---

Thanks for the report.

This seems to be a regression on 2.6.36 which could happen when one of
two superblocks is broken.

I'll fix it.

Ryusuke Konishi
