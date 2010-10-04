Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756941Ab0JDUJh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Oct 2010 16:09:37 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39828 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753945Ab0JDUJg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Oct 2010 16:09:36 -0400
Date: Mon, 4 Oct 2010 13:09:11 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: "Ted Ts'o" <tytso@mit.edu>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>,
        Cesar Eduardo Barros <cesarb@cesarb.net>, Tejun Heo <tj@kernel.org>,
        Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>,
        Jan Kara <jack@suse.cz>
Subject: Re: [Bug #19062] Dirtiable inode bdi default != sb bdi btrfs
Message-Id: <20101004130911.1375c6e3.akpm@linux-foundation.org>
In-Reply-To: <201010022358.35972.rjw@sisk.pl>
References: <MEG5YPP-fxC.A.vnD.So6nMB@chimera>
	<sQALkqF1FWE.A.15D.bo6nMB@chimera>
	<20101002165433.GL21129@thunk.org>
	<201010022358.35972.rjw@sisk.pl>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2 Oct 2010 23:58:35 +0200
"Rafael J. Wysocki" <rjw@sisk.pl> wrote:

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
> 
> Andrew, do you know whose area that is?

Christoph had a patch, and Jan had another patch.  Maybe

commit 692ebd17c2905313fff3c504c249c6a0faad16ec
Author: Jan Kara <jack@suse.cz>
Date:   Tue Sep 21 11:51:01 2010 +0200

    bdi: Fix warnings in __mark_inode_dirty for /dev/zero and friends

already fixed this?

