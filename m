Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754524Ab0JDKAk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Oct 2010 06:00:40 -0400
Received: from cantor.suse.de ([195.135.220.2]:56323 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753102Ab0JDKAj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Oct 2010 06:00:39 -0400
Date: Mon, 4 Oct 2010 11:59:44 +0200
From: Jan Kara <jack@suse.cz>
To: Tejun Heo <tj@kernel.org>
Cc: "Ted Ts'o" <tytso@mit.edu>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>,
        Cesar Eduardo Barros <cesarb@cesarb.net>, Jens Axboe <axboe@kernel.dk>,
        Jan Kara <jack@suse.cz>, Christoph Hellwig <hch@infradead.org>
Subject: Re: [Bug #19062] Dirtiable inode bdi default != sb bdi btrfs
Message-ID: <20101004095943.GE3589@quack.suse.cz>
References: <MEG5YPP-fxC.A.vnD.So6nMB@chimera>
 <sQALkqF1FWE.A.15D.bo6nMB@chimera>
 <20101002165433.GL21129@thunk.org>
 <201010022358.35972.rjw@sisk.pl>
 <20101003022707.GN21129@thunk.org>
 <4CA89E63.4080907@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CA89E63.4080907@kernel.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun 03-10-10 17:16:51, Tejun Heo wrote:
> On 10/03/2010 04:27 AM, Ted Ts'o wrote:
> > WARNING: at /usr/projects/linux/ext4/fs/fs-writeback.c:87 inode_to_bdi+0x4e/0x5c()
> > Hardware name: 
> > Dirtiable inode bdi block != sb bdi block
> > Modules linked in:
> > Pid: 21649, comm: mkfs.ext4 Tainted: G        W   2.6.36-rc6-00016-gcc25699 #735
> > Call Trace:
> >  [<c015a2e2>] warn_slowpath_common+0x6a/0x7f
> >  [<c020a762>] ? inode_to_bdi+0x4e/0x5c
> >  [<c015a36a>] warn_slowpath_fmt+0x2b/0x2f
> >  [<c020a762>] inode_to_bdi+0x4e/0x5c
> >  [<c020b6c3>] __mark_inode_dirty+0xaf/0x162
> >  [<c0202305>] file_update_time+0xcc/0xe9
> >  [<c01c68dd>] __generic_file_aio_write+0x136/0x28f
> >  [<c02145a4>] blkdev_aio_write+0x33/0x72
> >  [<c01f20da>] do_sync_write+0x8f/0xca
> >  [<c0647678>] ? mutex_unlock+0xd/0xf
> >  [<c030d528>] ? security_file_permission+0x27/0x2b
> >  [<c01f227c>] ? rw_verify_area+0x9d/0xc0
> >  [<c01f204b>] ? do_sync_write+0x0/0xca
> >  [<c01f2629>] vfs_write+0x85/0xe3
> >  [<c01f2725>] sys_write+0x40/0x62
> >  [<c064915d>] syscall_call+0x7/0xb
> > ---[ end trace 1f39401760ab3a42 ]---
  Yes, it's caused by one of my fixes. It's harmless (the warning I've
added is just too strict). Christoph has a patch that also fixes this
- http://lkml.org/lkml/2010/9/29/76. I hope he'll push it soon.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
