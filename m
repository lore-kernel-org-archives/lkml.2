Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757904Ab0JWQAN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Oct 2010 12:00:13 -0400
Received: from verein.lst.de ([213.95.11.210]:36762 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757762Ab0JWQAK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Oct 2010 12:00:10 -0400
Date: Sat, 23 Oct 2010 17:59:50 +0200
From: Christoph Hellwig <hch@lst.de>
To: mbroz@redhat.com, jaxboe@fusionio.com
Cc: linux-kernel@vger.kernel.org
Subject: loop warnings in current git HEAD
Message-ID: <20101023155950.GA31946@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.3.28i
X-Spam-Score: 0 () 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The loop driver in current git HEAD is rather unhappy when running
xfstests.  I gets lots of warnings like the one below.  The most likely
culprit seems to be:

	loop: add some basic read-only sysfs attributes

(commit ee86273062cbb310665fe49e1f1937d2cf85b0b9)

[ 1055.017350] WARNING: at /home/hch/work/linux-2.6/fs/sysfs/dir.c:451 sysfs_add_one+0xa4/0x110()
[ 1055.019843] Hardware name: Bochs
[ 1055.021004] sysfs: cannot create duplicate filename '/devices/virtual/block/loop0/loop'
[ 1055.023362] Modules linked in:
[ 1055.024274] Pid: 7028, comm: mount Tainted: G        W   2.6.36+ #6
[ 1055.025622] Call Trace:
[ 1055.026312]  [<c0169ead>] warn_slowpath_common+0x6d/0xa0
[ 1055.027464]  [<c026f534>] ? sysfs_add_one+0xa4/0x110
[ 1055.028651]  [<c026f534>] ? sysfs_add_one+0xa4/0x110
[ 1055.030329]  [<c0169f5e>] warn_slowpath_fmt+0x2e/0x30
[ 1055.031877]  [<c026f534>] sysfs_add_one+0xa4/0x110
[ 1055.033052]  [<c09e7645>] ? mutex_lock_nested+0x35/0x40
[ 1055.034273]  [<c026f5fc>] create_dir+0x5c/0xa0
[ 1055.035318]  [<c026f712>] sysfs_create_subdir+0x22/0x30
[ 1055.036570]  [<c0270aec>] internal_create_group+0x4c/0x170
[ 1055.037778]  [<c0270c3c>] sysfs_create_group+0xc/0x10
[ 1055.038902]  [<c079de83>] lo_ioctl+0x623/0x8c0
[ 1055.042214]  [<c019a3fa>] ? print_lock_contention_bug+0x1a/0xe0
[ 1055.043471]  [<c079d860>] ? lo_ioctl+0x0/0x8c0
[ 1055.044557]  [<c07065ac>] __blkdev_driver_ioctl+0x2c/0x40
[ 1055.048076]  [<c0706a9b>] blkdev_ioctl+0x21b/0x730
[ 1055.049155]  [<c019bf3b>] ? trace_hardirqs_on+0xb/0x10
[ 1055.050277]  [<c023ce0b>] block_ioctl+0x3b/0x50
[ 1055.051302]  [<c023cdd0>] ? block_ioctl+0x0/0x50
[ 1055.059103]  [<c02216ed>] do_vfs_ioctl+0x7d/0x5e0
[ 1055.060225]  [<c021d510>] ? path_put+0x20/0x30
[ 1055.061263]  [<c0217881>] ? sys_readlinkat+0x71/0x90
[ 1055.062360]  [<c0221c89>] sys_ioctl+0x39/0x60
[ 1055.063358]  [<c09e907d>] syscall_call+0x7/0xb
[ 1055.064470] ---[ end trace 1de52d78815cd17d ]---

