Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752445Ab0JCC1U (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Oct 2010 22:27:20 -0400
Received: from thunk.org ([69.25.196.29]:41186 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751688Ab0JCC1T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Oct 2010 22:27:19 -0400
Date: Sat, 2 Oct 2010 22:27:07 -0400
From: "Ted Ts'o" <tytso@mit.edu>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>,
        Cesar Eduardo Barros <cesarb@cesarb.net>, Tejun Heo <tj@kernel.org>,
        Jens Axboe <axboe@kernel.dk>
Subject: Re: [Bug #19062] Dirtiable inode bdi default != sb bdi btrfs
Message-ID: <20101003022707.GN21129@thunk.org>
Mail-Followup-To: Ted Ts'o <tytso@mit.edu>,
	"Rafael J. Wysocki" <rjw@sisk.pl>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Kernel Testers List <kernel-testers@vger.kernel.org>,
	Maciej Rutecki <maciej.rutecki@gmail.com>,
	Florian Mickler <florian@mickler.org>,
	Cesar Eduardo Barros <cesarb@cesarb.net>, Tejun Heo <tj@kernel.org>,
	Jens Axboe <axboe@kernel.dk>
References: <MEG5YPP-fxC.A.vnD.So6nMB@chimera>
 <sQALkqF1FWE.A.15D.bo6nMB@chimera>
 <20101002165433.GL21129@thunk.org>
 <201010022358.35972.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201010022358.35972.rjw@sisk.pl>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 02, 2010 at 11:58:35PM +0200, Rafael J. Wysocki wrote:
> On Saturday, October 02, 2010, Ted Ts'o wrote:
> > On Sun, Sep 26, 2010 at 10:04:15PM +0200, Rafael J. Wysocki wrote:
> > > The following bug entry is on the current list of known regressions
> > > from 2.6.35.  Please verify if it still should be listed and let the tracking team
> > > know (either way).
> > > 
> > > 
> > > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=19062
> > > Subject		: Dirtiable inode bdi default != sb bdi btrfs
> > > Submitter	: Cesar Eduardo Barros <cesarb@cesarb.net>
> > > Date		: 2010-09-23 0:54 (4 days old)
> > > Message-ID	: <4C9AA546.6050201@cesarb.net>
> > > References	: http://marc.info/?l=linux-kernel&m=128520328929595&w=2
> > 
> > Note: I'm seeing this warning (Dirtiable inode bdi default != sb bdi)
> > when I moved from 2.6.36-rc3 to 2.6.36-rc6, using ext4 as a root
> > partition, and running mke2fs and e2fsck on ext2, ext3, and ext4 file
> > systems.  So I'm seeing this as a known regression from rc3 to rc6.
> > Maybe it's different bug with ext4, but in any case, it's highly
> > annoying.
> 
> Thanks for the info.  I wonder who should see this report.

Oops, correction, the correct warning that I'm seeing is:

Dirtiable inode bdi block != sb bdi block
                    ^^^^^           ^^^^^

------------[ cut here ]------------
WARNING: at /usr/projects/linux/ext4/fs/fs-writeback.c:87 inode_to_bdi+0x4e/0x5c()
Hardware name: 
Dirtiable inode bdi block != sb bdi block
Modules linked in:
Pid: 21649, comm: mkfs.ext4 Tainted: G        W   2.6.36-rc6-00016-gcc25699 #735
Call Trace:
 [<c015a2e2>] warn_slowpath_common+0x6a/0x7f
 [<c020a762>] ? inode_to_bdi+0x4e/0x5c
 [<c015a36a>] warn_slowpath_fmt+0x2b/0x2f
 [<c020a762>] inode_to_bdi+0x4e/0x5c
 [<c020b6c3>] __mark_inode_dirty+0xaf/0x162
 [<c0202305>] file_update_time+0xcc/0xe9
 [<c01c68dd>] __generic_file_aio_write+0x136/0x28f
 [<c02145a4>] blkdev_aio_write+0x33/0x72
 [<c01f20da>] do_sync_write+0x8f/0xca
 [<c0647678>] ? mutex_unlock+0xd/0xf
 [<c030d528>] ? security_file_permission+0x27/0x2b
 [<c01f227c>] ? rw_verify_area+0x9d/0xc0
 [<c01f204b>] ? do_sync_write+0x0/0xca
 [<c01f2629>] vfs_write+0x85/0xe3
 [<c01f2725>] sys_write+0x40/0x62
 [<c064915d>] syscall_call+0x7/0xb
---[ end trace 1f39401760ab3a42 ]---

					- Ted
