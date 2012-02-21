Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755082Ab2BULJZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Feb 2012 06:09:25 -0500
Received: from trent.utfs.org ([94.185.90.103]:46895 "EHLO trent.utfs.org"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752754Ab2BULJY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Feb 2012 06:09:24 -0500
X-Greylist: delayed 542 seconds by postgrey-1.27 at vger.kernel.org; Tue, 21 Feb 2012 06:09:24 EST
Date: Tue, 21 Feb 2012 03:00:16 -0800 (PST)
From: Christian Kujau <lists@nerdbynature.de>
To: LKML <linux-kernel@vger.kernel.org>
cc: Jens Axboe <axboe@kernel.dk>
Subject: WARNING: at block/genhd.c:1465
Message-ID: <alpine.DEB.2.01.1202210246400.4930@trent.utfs.org>
User-Agent: Alpine 2.01 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-AV-Checked: ClamAV using ClamSMTP (127.0.0.1)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

During bootup of 3.3.0-rc4 on this PowerPC machine (G4, 32bit), the 
WARNING below is printed. This did not happen with -rc2, and I skipped 
-rc3, so I don't know if it happend there.

According to the gitlog, there haven't been any changes to block/genhd.c 
lateley, and that's the place where "__disk_unblock_events" appears. But 
"blkdev_get" shows up in block/ioctl.c, where a few changes have been 
made.

Full dmesg & .config: http://nerdbynature.de/bits/3.3.0-rc4/

Is this something to worry about?

Thanks,
C.

 ------------[ cut here ]------------
 WARNING: at /usr/local/src/linux-2.6-git/block/genhd.c:1465
 Modules linked in: firewire_sbp2 arc4 sd_mod i2c_powermac b43 mac80211 cfg80211 usb_storage scsi_mod
 NIP: c02f96fc LR: c02f95c0 CTR: f10611f0
 REGS: eed59c60 TRAP: 0700   Not tainted  (3.3.0-rc4)
 MSR: 00021032 <ME,IR,DR,RI>  CR: 28042482  XER: 00000000
 TASK = eec91700[804] 'fsck' THREAD: eed58000
 GPR00: 00000001 eed59d10 eec91700 00009032 ffffffff c071eb90 15300000 00000000 
 GPR08: 00000000 c0bf148c c0976a14 0000000a 28042488 1001e828 00000000 00000830 
 GPR16: 0ffeb778 0ffeb760 0ffefeb4 0ffeb748 00000000 ffffffe9 0ffeb5e4 bfa506b0 
 GPR24: eed59d38 00000000 0000001d 00000000 eed64800 eec1dc00 00009032 eec1dc0c 
 NIP [c02f96fc] __disk_unblock_events+0x174/0x18c
 LR [c02f95c0] __disk_unblock_events+0x38/0x18c
 Call Trace:
 [eed59d10] [c02f95c0] __disk_unblock_events+0x38/0x18c (unreliable)
 [eed59d30] [c0110154] __blkdev_get+0x1e0/0x3dc
 [eed59d70] [c01103b4] blkdev_get+0x64/0x38c
 [eed59dd0] [c00d3698] __dentry_open+0x268/0x35c
 [eed59df0] [c00e6630] do_last+0x140/0x78c
 [eed59e30] [c00e6d68] path_openat+0xec/0x410
 [eed59e90] [c00e71ac] do_filp_open+0x44/0xb0
 [eed59f10] [c00d3324] do_sys_open+0x104/0x1e8
 [eed59f40] [c00127a0] ret_from_syscall+0x0/0x38
 --- Exception: c01 at 0xfef4d58
     LR = 0xfef4d08
 Instruction dump:
 8361000c 7c0803a6 83810010 83a10014 83c10018 83e1001c 38210020 4e800020 
 3d20c0bf 3929148c 88090404 68000001 <0f000000> 2f800000 419eff10 38000001 
 ---[ end trace 85b35f260c2a2e44 ]---


-- 
BOFH excuse #328:

Fiber optics caused gas main leak
