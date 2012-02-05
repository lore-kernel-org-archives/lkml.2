Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752555Ab2BEU5V (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Feb 2012 15:57:21 -0500
Received: from mailout03.t-online.de ([194.25.134.81]:50856 "EHLO
	mailout03.t-online.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750763Ab2BEU5U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Feb 2012 15:57:20 -0500
Message-ID: <4F2EED22.3070901@t-online.de>
Date: Sun, 05 Feb 2012 21:57:06 +0100
From: Knut Petersen <Knut_Petersen@t-online.de>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:9.0) Gecko/20111220 Thunderbird/9.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [BUG 3.3-rc2] spinlock trylock failure on UP on CPU#0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-ID: TFw0RcZTrhcPeyHIxcuzaPZECCSyryltvHKz0RhGgKCRYIeNcWx73maHh10HRBwZHT
X-TOI-MSGID: 6aa27807-495d-4e69-97e5-d0248286827e
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Booting  23783f817bceedd6d4e549385e3f400ea64059e5 I get the following trace
an AOpen i915GMm-hfs with Pentium-M Dothan:


[   12.526390] BUG: spinlock trylock failure on UP on CPU#0, scsi_id/543
[   12.528009]  lock: f4ed8830, .magic: dead4ead, .owner: scsi_id/543, .owner_cpu: 0
[   12.528009] Pid: 543, comm: scsi_id Not tainted 3.3.0-rc2-main+ #21
[   12.528009] Call Trace:
[   12.528009]  [<c011dd19>] ? console_unlock+0x1ad/0x1d3
[   12.528009]  [<c043e56d>] spin_dump+0x6c/0x76
[   12.528009]  [<c043e594>] spin_bug+0x1d/0x21
[   12.528009]  [<c027739a>] do_raw_spin_trylock+0x33/0x38
[   12.528009]  [<c04429c2>] _raw_spin_trylock+0x17/0x63
[   12.528009]  [<c025fafa>] put_io_context+0xa1/0x10a
[   12.528009]  [<c0269d85>] __cfq_slice_expired+0x2f6/0x319
[   12.528009]  [<c026a8b2>] cfq_dispatch_requests+0x39/0x714
[   12.528009]  [<c025b328>] elv_drain_elevator+0x3f/0x7d
[   12.528009]  [<c025b3f0>] __elv_add_request+0x8a/0x169
[   12.528009]  [<c02604a4>] blk_execute_rq_nowait+0x88/0xab
[   12.528009]  [<c0260573>] blk_execute_rq+0xac/0xcd
[   12.528009]  [<c02603f4>] ? blk_rq_map_user+0x1b5/0x1b5
[   12.528009]  [<c0260775>] ? blk_recount_segments+0x16/0x24
[   12.528009]  [<c0263cf5>] sg_io+0x23c/0x325
[   12.528009]  [<c02642a3>] scsi_cmd_ioctl+0x1b1/0x332
[   12.528009]  [<c0264452>] scsi_cmd_blk_ioctl+0x2e/0x38
[   12.528009]  [<c035c15e>] sd_ioctl+0xd4/0xf4
[   12.528009]  [<c035c08a>] ? sd_getgeo+0x98/0x98
[   12.528009]  [<c02618ce>] __blkdev_driver_ioctl+0x26/0x2e
[   12.528009]  [<c026226a>] blkdev_ioctl+0x70e/0x728
[   12.528009]  [<c011af95>] ? __kunmap_atomic+0x61/0x78
[   12.528009]  [<c0137f14>] ? get_parent_ip+0xb/0x31
[   12.528009]  [<c04450e4>] ? add_preempt_count+0x98/0x9b
[   12.528009]  [<c01b3f87>] block_ioctl+0x31/0x39
[   12.528009]  [<c01b3f87>] ? block_ioctl+0x31/0x39
[   12.528009]  [<c01b3f56>] ? bd_set_size+0x62/0x62
[   12.528009]  [<c019ebb9>] do_vfs_ioctl+0x47b/0x4af
[   12.528009]  [<c0134c7e>] ? up_read+0x16/0x28
[   12.528009]  [<c0444ea7>] ? do_page_fault+0x3d4/0x402
[   12.528009]  [<c01957a8>] ? sys_fstat64+0x20/0x22
[   12.528009]  [<c019ec2e>] sys_ioctl+0x41/0x63
[   12.528009]  [<c0442c05>] syscall_call+0x7/0xb

cu,
  -kp
