Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753214Ab0DVHw1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 03:52:27 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:42997 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752250Ab0DVHwZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 03:52:25 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Andrew Morton <akpm@linux-foundation.org>,
       David Airlie <airlied@redhat.com>
Cc: linux-kernel@vger.kernel.org, dri-devel@lists.sourceforge.net
Subject: 34-rc4-mmotm0415 - OOPS in nouveau driver
From: Valdis.Kletnieks@vt.edu
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1271922716_8122P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Thu, 22 Apr 2010 03:51:56 -0400
Message-ID: <16125.1271922716@localhost>
X-Mirapoint-Received-SPF: 128.173.34.98 localhost Valdis.Kletnieks@vt.edu 2 pass
X-Mirapoint-IP-Reputation: reputation=neutral-1,
	source=Fixed,
	refid=n/a,
	actions=MAILHURDLE SPF TAG
X-Junkmail-Info: (45) HELO_LOCALHOST
X-Junkmail-Status: score=45/50, host=dagger.cc.vt.edu
X-Junkmail-SD-Raw: score=unknown,
	refid=str=0001.0A02020A.4BD0001D.00ED,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2009-09-22 00:05:22,
	dmn=2009-09-10 00:05:08,
	mode=multiengine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1271922716_8122P
Content-Type: text/plain; charset=us-ascii

Dell Latitude E6500, with NVidia graphics:
01:00.0 VGA compatible controller: nVidia Corporation G98M [Quadro NVS 160M] (rev a1)

http://hubblesite.org/newscenter/archive/releases/2003/15/image/a/warn/

Nice 6116x7014 jpeg on there. Opened it in firefox, and it opened the squished
up fit-in-window version.  Clicked on it to expand it to full size, and kablam
dead X server. I think it got indigestion on the pixmap size.

dmesg says:

[29070.917875] [drm] nouveau 0000:01:00.0: PFIFO_DMA_PUSHER - Ch 2
[29073.917082] BUG: unable to handle kernel NULL pointer dereference at 0000000000000028
[29073.917089] IP: [<ffffffff812b412e>] ttm_bo_pci_offset+0x56/0x76
[29073.917098] PGD 11f7e7067 PUD 11a291067 PMD 0 
[29073.917103] Oops: 0000 [#1] PREEMPT SMP 
[29073.917109] last sysfs file: /sys/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0A:00/power_supply/BAT0/charge_full
[29073.917113] CPU 0 
[29073.917114] Modules linked in: sunrpc [last unloaded: scsi_wait_scan]
[29073.917120] 
[29073.917124] Pid: 3670, comm: Xorg Not tainted 2.6.34-rc4-mm1 #1 0X564R/Latitude E6500
[29073.917127] RIP: 0010:[<ffffffff812b412e>]  [<ffffffff812b412e>] ttm_bo_pci_offset+0x56/0x76
[29073.917132] RSP: 0018:ffff88011e7298e8  EFLAGS: 00010202
[29073.917134] RAX: 0000000000000000 RBX: ffff88011e729b68 RCX: ffff88011e729910
[29073.917137] RDX: ffff88011e729900 RSI: ffff88011e729b68 RDI: ffff88011dd00118
[29073.917140] RBP: ffff88011e7298e8 R08: ffff88011e729908 R09: 0000000000000160
[29073.917142] R10: 0000000000000002 R11: 0000000000000002 R12: ffff88011e7299e8
[29073.917145] R13: ffff88011dd00118 R14: 0000000000000002 R15: ffff88010ec99100
[29073.917148] FS:  00007f96fa760840(0000) GS:ffff880002600000(0000) knlGS:0000000000000000
[29073.917151] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[29073.917154] CR2: 0000000000000028 CR3: 000000011cb2b000 CR4: 00000000000406f0
[29073.917157] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[29073.917159] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[29073.917162] Process Xorg (pid: 3670, threadinfo ffff88011e728000, task ffff88011e714340)
[29073.917164] Stack:
[29073.917166]  ffff88011e729948 ffffffff812b76de 0000000000000282 00000000e0000000
[29073.917172] <0> 0000000000000000 0000000001420000 ffff8800b7a137c0 ffff88011e729b68
[29073.917178] <0> ffff88010ec99000 0000000000000000 0000000000000000 ffff88010ec99100
[29073.917186] Call Trace:
[29073.917191]  [<ffffffff812b76de>] ttm_mem_reg_ioremap+0x36/0xa7
[29073.917195]  [<ffffffff812b7bc4>] ttm_bo_move_memcpy+0x74/0x3bc
[29073.917199]  [<ffffffff81207572>] ? kref_put+0x9b/0xba
[29073.917204]  [<ffffffff812c7bb2>] ? nouveau_fence_unref+0x24/0x2f
[29073.917208]  [<ffffffff812c6f77>] ? nouveau_bo_move_m2mf+0x34f/0x361
[29073.917212]  [<ffffffff812c732f>] nouveau_bo_move+0x3a6/0x433
[29073.917217]  [<ffffffff810c3bde>] ? unmap_mapping_range+0x15c/0x16b
[29073.917221]  [<ffffffff812b4e77>] ttm_bo_handle_move_mem+0x1a8/0x2b0
[29073.917226]  [<ffffffff812b6d54>] ttm_bo_move_buffer+0xd2/0x122
[29073.917229]  [<ffffffff812b4bc2>] ? ttm_bo_reserve+0x33/0x111
[29073.917233]  [<ffffffff812b6e84>] ttm_bo_validate+0xe0/0x130
[29073.917237]  [<ffffffff812c8648>] validate_list+0x1ba/0x2e4
[29073.917241]  [<ffffffff812c940e>] nouveau_gem_ioctl_pushbuf+0x6d8/0xfb6
[29073.917248]  [<ffffffff812a0b72>] drm_ioctl+0x27b/0x349
[29073.917251]  [<ffffffff812c8d36>] ? nouveau_gem_ioctl_pushbuf+0x0/0xfb6
[29073.917257]  [<ffffffff810ea0bd>] vfs_ioctl+0x2d/0xa1
[29073.917260]  [<ffffffff810ea660>] do_vfs_ioctl+0x4b8/0x4fe
[29073.917264]  [<ffffffff810ea6fd>] sys_ioctl+0x57/0x95
[29073.917269]  [<ffffffff810026ab>] system_call_fastpath+0x16/0x1b
[29073.917272] Code: 69 c0 b0 00 00 00 8b 44 07 54 a8 01 75 13 45 85 d2 74 0a a8 08 75 06 f6 46 22 01 74 04 31 c0 c9 c3 48 8b 06 4d 69 c9 b0 00 00 00 <48> 8b 40 28 48 c1 e0 0c 48 89 01 48 8b 46 10 48 c1 e0 0c 49 89 
[29073.917337] RIP  [<ffffffff812b412e>] ttm_bo_pci_offset+0x56/0x76
[29073.917342]  RSP <ffff88011e7298e8>
[29073.917344] CR2: 0000000000000028
[29073.917347] ---[ end trace dec9a802bd56f54b ]---


--==_Exmh_1271922716_8122P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFL0AAccC3lWbTT17ARAm64AJ42VyL0zsDp4IHb0CyyHkw7DlXZtQCgn8GG
LY0OSDBOnwozdgfqK901VXg=
=RgjF
-----END PGP SIGNATURE-----

--==_Exmh_1271922716_8122P--

