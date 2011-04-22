Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754783Ab1DVB5U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Apr 2011 21:57:20 -0400
Received: from trent.utfs.org ([194.246.123.103]:35712 "EHLO trent.utfs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752995Ab1DVB5T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Apr 2011 21:57:19 -0400
Date: Thu, 21 Apr 2011 18:57:16 -0700 (PDT)
From: Christian Kujau <lists@nerdbynature.de>
To: LKML <linux-kernel@vger.kernel.org>
cc: xfs@oss.sgi.com
Subject: 2.6.39-rc4+: oom-killer busy killing tasks
Message-ID: <alpine.DEB.2.01.1104211841510.18728@trent.utfs.org>
User-Agent: Alpine 2.01 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-AV-Checked: ClamAV using ClamSMTP (127.0.0.1)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

after the block layer regression[0] seemed to be fixed, the machine 
appeared to be running fine. But after putting some disk I/O to the system 
(PowerBook G4) it became unresponsive, I/O wait went up high and I could 
see that the OOM killer was killing processes. Logging in via SSH was 
sometimes possible, but the each session was killed shortly after, so I 
could not do much.

The box finally rebooted itself, the logfile recorded something xfs 
related in the first backtrace, hence I'm cc'ing the xfs list too:

du invoked oom-killer: gfp_mask=0x842d0, order=0, oom_adj=0, oom_score_adj=0
Call Trace:
[c0009ce4] show_stack+0x70/0x1bc (unreliable)
[c008f508] T.528+0x74/0x1cc
[c008f734] T.526+0xd4/0x2a0
[c008fb7c] out_of_memory+0x27c/0x360
[c0093b3c] __alloc_pages_nodemask+0x6f8/0x708
[c00c00b4] new_slab+0x244/0x27c
[c00c0620] T.879+0x1cc/0x37c
[c00c08d0] kmem_cache_alloc+0x100/0x108
[c01cb2b8] kmem_zone_alloc+0xa4/0x114
[c01a7d58] xfs_inode_alloc+0x40/0x13c
[c01a8218] xfs_iget+0x258/0x5a0
[c01c922c] xfs_lookup+0xf8/0x114
[c01d70b0] xfs_vn_lookup+0x5c/0xb0
[c00d14c8] d_alloc_and_lookup+0x54/0x90
[c00d1d4c] do_lookup+0x248/0x2bc
[c00d33cc] path_lookupat+0xfc/0x8f4
[c00d3bf8] do_path_lookup+0x34/0xac
[c00d53e0] user_path_at+0x64/0xb4
[c00ca638] vfs_fstatat+0x58/0xbc
[c00ca6c0] sys_fstatat64+0x24/0x50
[c00124f4] ret_from_syscall+0x0/0x38
 --- Exception: c01 at 0xff4b050
   LR = 0x10008cf8


This is wih today's git (91e8549bde...); full log & .config on: 

  http://nerdbynature.de/bits/2.6.39-rc4/oom/

Thanks,
Christian.

[0] https://lkml.org/lkml/2011/4/14/702
-- 
BOFH excuse #117:

the printer thinks its a router.
