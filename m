Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760591Ab0J0ABH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Oct 2010 20:01:07 -0400
Received: from bld-mail17.adl2.internode.on.net ([150.101.137.102]:36933 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756546Ab0J0ABF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Oct 2010 20:01:05 -0400
Date: Wed, 27 Oct 2010 11:00:51 +1100
From: Dave Chinner <david@fromorbit.com>
To: linux-kernel@vger.kernel.org
Cc: Jens Axboe <jaxboe@fusionio.com>
Subject: [warn, 2.6.37-current] loop: sysfs: cannot create duplicate
 filename
Message-ID: <20101027000051.GC32255@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Folks,

I'm getting this warning triggering repeatedly when running xfstests
on a day old 2.6.37-git tree.

 [ 3393.738568] ------------[ cut here ]------------
 [ 3393.739389] WARNING: at fs/sysfs/dir.c:451 sysfs_add_one+0xc9/0x130()
 [ 3393.740490] Hardware name: Bochs
 [ 3393.741041] sysfs: cannot create duplicate filename '/devices/virtual/block/loop0/loop'
 [ 3393.742439] Modules linked in:
 [ 3393.742984] Pid: 5360, comm: mount Not tainted 2.6.36-dgc+ #590
 [ 3393.744125] Call Trace:
 [ 3393.744555]  [<ffffffff8108492f>] warn_slowpath_common+0x7f/0xc0
 [ 3393.745545]  [<ffffffff81084a26>] warn_slowpath_fmt+0x46/0x50
 [ 3393.746493]  [<ffffffff811d1539>] sysfs_add_one+0xc9/0x130
 [ 3393.747420]  [<ffffffff811d1621>] create_dir+0x81/0xd0
 [ 3393.748311]  [<ffffffff811d175c>] sysfs_create_subdir+0x1c/0x20
 [ 3393.749294]  [<ffffffff811d30b8>] internal_create_group+0x58/0x1a0
 [ 3393.750234]  [<ffffffff811d3233>] sysfs_create_group+0x13/0x20
 [ 3393.751223]  [<ffffffff81879e66>] lo_ioctl+0x506/0x7b0
 [ 3393.752111]  [<ffffffff8169b5a8>] __blkdev_driver_ioctl+0x28/0x30
 [ 3393.753115]  [<ffffffff8169ba8e>] blkdev_ioctl+0x22e/0x6f0
 [ 3393.754022]  [<ffffffff81190732>] block_ioctl+0x42/0x50
 [ 3393.754889]  [<ffffffff8116f239>] do_vfs_ioctl+0xa9/0x5a0
 [ 3393.755803]  [<ffffffff810bdded>] ? trace_hardirqs_on+0xd/0x10
 [ 3393.756805]  [<ffffffff8116f7b1>] sys_ioctl+0x81/0xa0
 [ 3393.757647]  [<ffffffff8103a072>] system_call_fastpath+0x16/0x1b
 [ 3393.758626] ---[ end trace 2a65a71ed74903b0 ]---

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
