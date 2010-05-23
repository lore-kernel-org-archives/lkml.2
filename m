Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751903Ab0EWFU1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 May 2010 01:20:27 -0400
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:41202 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751349Ab0EWFUZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 May 2010 01:20:25 -0400
X-Sasl-enc: pZWh6QxrO4xBmacCN3ZDpGIENOTjy9f7EjnDvn4o10Pj 1274592025
Date: Sun, 23 May 2010 00:20:23 -0500
From: Roman Kononov <roman@binarylife.net>
To: xfs@oss.sgi.com, linux-kernel@vger.kernel.org
Subject: WARNING in xfs_lwr.c, xfs_write()
Message-ID: <20100523002023.41f5a5c8@aaa.pulp.binarylife.net>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Under some workload, once per ~10 seconds, I'm getting the following warnings
with 2.6.32.13 and 2.6.33.4 (x86_64). Why are they?

Thanks.

May 22 23:53:13 hrech kernel: WARNING: at /home/stuff/base/linux-2.6.32.13/fs/xfs/linux-2.6/xfs_lrw.c:714 xfs_write+0x8a2/0x8c0()
May 22 23:53:13 hrech kernel: Modules linked in: ib_mthca sata_nv 3w_9xxx
May 22 23:53:13 hrech kernel: Pid: 30650, comm: postmaster Not tainted 2.6.32.13 #2
May 22 23:53:13 hrech kernel: Call Trace:
May 22 23:53:13 hrech kernel:  [<ffffffff8118baf2>] ? xfs_write+0x8a2/0x8c0
May 22 23:53:13 hrech kernel:  [<ffffffff8118baf2>] ? xfs_write+0x8a2/0x8c0
May 22 23:53:13 hrech kernel:  [<ffffffff8103a775>] ? warn_slowpath_common+0x85/0xb0
May 22 23:53:13 hrech kernel:  [<ffffffff8118baf2>] ? xfs_write+0x8a2/0x8c0
May 22 23:53:13 hrech kernel:  [<ffffffff811b7293>] ? cpumask_next_and+0x23/0x40
May 22 23:53:13 hrech kernel:  [<ffffffff81036826>] ? select_task_rq_fair+0x326/0x6a0
May 22 23:53:13 hrech kernel:  [<ffffffff810a7869>] ? do_sync_write+0xd9/0x120
May 22 23:53:13 hrech kernel:  [<ffffffff8104ef20>] ? autoremove_wake_function+0x0/0x30
May 22 23:53:13 hrech kernel:  [<ffffffff81037b1d>] ? wake_up_new_task+0x9d/0xc0
May 22 23:53:13 hrech kernel:  [<ffffffff81039b02>] ? do_fork+0x102/0x330
May 22 23:53:13 hrech kernel:  [<ffffffff810a8088>] ? vfs_write+0xc8/0x180
May 22 23:53:13 hrech kernel:  [<ffffffff810a88a1>] ? sys_pwrite64+0x91/0xa0
May 22 23:53:13 hrech kernel:  [<ffffffff8100bc6b>] ? system_call_fastpath+0x16/0x1b
May 22 23:53:13 hrech kernel: ---[ end trace 615b846a6bbdf833 ]---


May 22 09:06:25 hrech kernel: WARNING: at /home/stuff/base/linux-2.6.33.4/fs/xfs/linux-2.6/xfs_lrw.c:651 xfs_write+0x961/0x970()
May 22 09:06:25 hrech kernel: Modules linked in: dm_mod ib_mthca sata_nv 3w_9xxx
May 22 09:06:25 hrech kernel: Pid: 1937, comm: postmaster Not tainted 2.6.33.4 #2
May 22 09:06:25 hrech kernel: Call Trace:
May 22 09:06:25 hrech kernel:  [<ffffffff81036bb3>] ? warn_slowpath_common+0x73/0xb0
May 22 09:06:25 hrech kernel:  [<ffffffff8119cce1>] ? xfs_write+0x961/0x970
May 22 09:06:25 hrech kernel:  [<ffffffff810b2b3f>] ? do_sync_write+0xbf/0x100
May 22 09:06:25 hrech kernel:  [<ffffffff81030a52>] ? wake_up_new_task+0xc2/0xe0
May 22 09:06:25 hrech kernel:  [<ffffffff81035f60>] ? do_fork+0xf0/0x380
May 22 09:06:25 hrech kernel:  [<ffffffff810b3236>] ? vfs_write+0xb6/0x170
May 22 09:06:25 hrech kernel:  [<ffffffff810b36a3>] ? sys_pwrite64+0x83/0xa0
May 22 09:06:25 hrech kernel:  [<ffffffff81002ceb>] ? system_call_fastpath+0x16/0x1b
May 22 09:06:25 hrech kernel: ---[ end trace 62b123c1948e55fa ]---
