Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753075Ab1HVDle (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Aug 2011 23:41:34 -0400
Received: from mail-iy0-f170.google.com ([209.85.210.170]:49621 "EHLO
	mail-iy0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751894Ab1HVDlc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Aug 2011 23:41:32 -0400
Message-ID: <4E51CFD8.2090508@gmail.com>
Date: Sun, 21 Aug 2011 20:41:12 -0700
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:5.0) Gecko/20110707 Thunderbird/5.0
MIME-Version: 1.0
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: INFO: possible circular locking dependency detected  3.1.0-rc2-00190-g3210d19
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

yikes.. seems the latest Mainline doesnt like rhythmbox or vice versa.

[   68.476921] =======================================================
[   68.476926] [ INFO: possible circular locking dependency detected ]
[   68.476929] 3.1.0-rc2-00190-g3210d19 #7
[   68.476931] -------------------------------------------------------
[   68.476934] rhythmbox/1597 is trying to acquire lock:
[   68.476937]  (&sb->s_type->i_mutex_key#8){+.+.+.}, at: 
[<ffffffff8119702e>] ext4_evict_inode+0x76/0x33c
[   68.476950]
[   68.476950] but task is already holding lock:
[   68.476953]  (&mm->mmap_sem){++++++}, at: [<ffffffff810fcb08>] 
sys_munmap+0x3b/0x60
[   68.476960]
[   68.476961] which lock already depends on the new lock.
[   68.476962]
[   68.476964]
[   68.476965] the existing dependency chain (in reverse order) is:
[   68.476968]
[   68.476968] -> #1 (&mm->mmap_sem){++++++}:
[   68.476973]        [<ffffffff810819d0>] lock_acquire+0x106/0x15b
[   68.476979]        [<ffffffff810f5fa3>] might_fault+0x89/0xac
[   68.476984]        [<ffffffff8113716b>] filldir+0x6f/0xc7
[   68.476990]        [<ffffffff8118df2b>] call_filldir+0x96/0xbd
[   68.476994]        [<ffffffff8118e258>] ext4_readdir+0x1b4/0x515
[   68.476998]        [<ffffffff811373c0>] vfs_readdir+0x7b/0xb1
[   68.477003]        [<ffffffff811374dc>] sys_getdents+0x7e/0xce
[   68.477007]        [<ffffffff814c6042>] system_call_fastpath+0x16/0x1b
[   68.477008]
[   68.477008] -> #0 (&sb->s_type->i_mutex_key#8){+.+.+.}:
[   68.477008]        [<ffffffff810811fa>] __lock_acquire+0xa06/0xce3
[   68.477008]        [<ffffffff810819d0>] lock_acquire+0x106/0x15b
[   68.477008]        [<ffffffff814bd955>] __mutex_lock_common+0x61/0x380
[   68.477008]        [<ffffffff814bdd83>] mutex_lock_nested+0x40/0x45
[   68.477008]        [<ffffffff8119702e>] ext4_evict_inode+0x76/0x33c
[   68.477008]        [<ffffffff8113d249>] evict+0x99/0x153
[   68.477008]        [<ffffffff8113d494>] iput+0x191/0x19a
[   68.477008]        [<ffffffff8113a155>] dentry_kill+0x123/0x145
[   68.477008]        [<ffffffff8113a564>] dput+0xf7/0x107
[   68.477008]        [<ffffffff8112970c>] fput+0x1ce/0x1e6
[   68.477008]        [<ffffffff810fb7cf>] remove_vma+0x56/0x87
[   68.477008]        [<ffffffff810fc995>] do_munmap+0x2f2/0x30b
[   68.477008]        [<ffffffff810fcb16>] sys_munmap+0x49/0x60
[   68.477008]        [<ffffffff814c6042>] system_call_fastpath+0x16/0x1b
[   68.477008]
[   68.477008] other info that might help us debug this:
[   68.477008]
[   68.477008]  Possible unsafe locking scenario:
[   68.477008]
[   68.477008]        CPU0                    CPU1
[   68.477008]        ----                    ----
[   68.477008]   lock(&mm->mmap_sem);
[   68.477008] 
lock(&sb->s_type->i_mutex_key);
[   68.477008]                                lock(&mm->mmap_sem);
[   68.477008]   lock(&sb->s_type->i_mutex_key);
[   68.477008]
[   68.477008]  *** DEADLOCK ***
[   68.477008]
[   68.477008] 1 lock held by rhythmbox/1597:
[   68.477008]  #0:  (&mm->mmap_sem){++++++}, at: [<ffffffff810fcb08>] 
sys_munmap+0x3b/0x60
[   68.477008]
[   68.477008] stack backtrace:
[   68.477008] Pid: 1597, comm: rhythmbox Not tainted 
3.1.0-rc2-00190-g3210d19 #7
[   68.477008] Call Trace:
[   68.477008]  [<ffffffff814b50da>] print_circular_bug+0x1f8/0x209
[   68.477008]  [<ffffffff810811fa>] __lock_acquire+0xa06/0xce3
[   68.477008]  [<ffffffff8119702e>] ? ext4_evict_inode+0x76/0x33c
[   68.477008]  [<ffffffff810819d0>] lock_acquire+0x106/0x15b
[   68.477008]  [<ffffffff8119702e>] ? ext4_evict_inode+0x76/0x33c
[   68.477008]  [<ffffffff814bd955>] __mutex_lock_common+0x61/0x380
[   68.477008]  [<ffffffff8119702e>] ? ext4_evict_inode+0x76/0x33c
[   68.477008]  [<ffffffff8113d219>] ? evict+0x69/0x153
[   68.477008]  [<ffffffff8119702e>] ? ext4_evict_inode+0x76/0x33c
[   68.477008]  [<ffffffff8113d219>] ? evict+0x69/0x153
[   68.477008]  [<ffffffff81081893>] ? lock_release+0x1a9/0x1e0
[   68.477008]  [<ffffffff814bdd83>] mutex_lock_nested+0x40/0x45
[   68.477008]  [<ffffffff8119702e>] ext4_evict_inode+0x76/0x33c
[   68.477008]  [<ffffffff8113d249>] evict+0x99/0x153
[   68.477008]  [<ffffffff8113d494>] iput+0x191/0x19a
[   68.477008]  [<ffffffff8113a155>] dentry_kill+0x123/0x145
[   68.477008]  [<ffffffff8113a564>] dput+0xf7/0x107
[   68.477008]  [<ffffffff8112970c>] fput+0x1ce/0x1e6
[   68.477008]  [<ffffffff810fb7cf>] remove_vma+0x56/0x87
[   68.477008]  [<ffffffff810fc995>] do_munmap+0x2f2/0x30b
[   68.477008]  [<ffffffff810fcb16>] sys_munmap+0x49/0x60
[   68.477008]  [<ffffffff814c6042>] system_call_fastpath+0x16/0x1b
[   69.728185] ata1: lost interrupt (Status 0x59)
[   69.728226] ata1: drained 8 bytes to clear DRQ
[   69.728240] ata1.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6 
frozen
[   69.728250] sr 0:0:0:0: CDB: Get event status notification: 4a 01 00 
00 10 00 00 00 08 00
[   69.728288] ata1.00: cmd a0/00:00:00:08:00/00:00:00:00:00/a0 tag 0 
pio 16392 in
[   69.728291]          res 40/00:03:00:00:00/00:00:00:00:00/a0 Emask 
0x4 (timeout)
[   69.728299] ata1.00: status: { DRDY }
[   74.738348] ata1: link is slow to respond, please be patient (ready=0)
[   79.772091] ata1: device not ready (errno=-16), forcing hardreset
[   79.772110] ata1: soft resetting link
[   79.934483] ata1.00: configured for UDMA/66
[   84.934264] ata1.00: qc timeout (cmd 0xa0)
[   84.934276] ata1.00: TEST_UNIT_READY failed (err_mask=0x5)
[   84.934327] ata1: soft resetting link
[   85.094470] ata1.00: configured for UDMA/66
[   90.094089] ata1.00: qc timeout (cmd 0xa0)
[   90.094108] ata1.00: TEST_UNIT_READY failed (err_mask=0x5)
[   90.094113] ata1.00: limiting speed to UDMA/66:PIO3
[   90.094153] ata1: soft resetting link
[   90.274440] ata1.00: configured for UDMA/66
[   95.274071] ata1.00: qc timeout (cmd 0xa0)
[   95.274084] ata1.00: TEST_UNIT_READY failed (err_mask=0x5)
[   95.274091] ata1.00: disabled
[   95.274157] ata1: soft resetting link
[   95.425185] ata1: EH complete


full dmesg here:
http://fpaste.org/Hxog/

Justin P. Mattock
