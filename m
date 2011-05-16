Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753692Ab1EPTAR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 May 2011 15:00:17 -0400
Received: from cantor.suse.de ([195.135.220.2]:37436 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751204Ab1EPTAP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 May 2011 15:00:15 -0400
Date: Mon, 16 May 2011 20:59:47 +0200
From: Jan Kara <jack@suse.cz>
To: "Darrick J. Wong" <djwong@us.ibm.com>
Cc: Jan Kara <jack@suse.cz>, Theodore Tso <tytso@mit.edu>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
        Jens Axboe <axboe@kernel.dk>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Jeff Layton <jlayton@redhat.com>, Dave Chinner <david@fromorbit.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Dave Hansen <dave@linux.vnet.ibm.com>,
        Christoph Hellwig <hch@infradead.org>, linux-mm@kvack.org,
        Chris Mason <chris.mason@oracle.com>, Joel Becker <jlbec@evilplan.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-ext4@vger.kernel.org, Mingming Cao <mcao@us.ibm.com>
Subject: Re: [PATCHSET v3.1 0/7] data integrity: Stabilize pages during
 writeback for various fses
Message-ID: <20110516185947.GK5344@quack.suse.cz>
References: <20110509230318.19566.66202.stgit@elm3c44.beaverton.ibm.com>
 <20110510125124.GD4402@quack.suse.cz>
 <20110511181901.GK20579@tux1.beaverton.ibm.com>
 <20110512094255.GA4690@quack.suse.cz>
 <20110516184927.GM20579@tux1.beaverton.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110516184927.GM20579@tux1.beaverton.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 16-05-11 11:49:27, Darrick J. Wong wrote:
> On Thu, May 12, 2011 at 11:42:55AM +0200, Jan Kara wrote:
> > On Wed 11-05-11 11:19:01, Darrick J. Wong wrote:
> > > On Tue, May 10, 2011 at 02:51:24PM +0200, Jan Kara wrote:
> > > > On Mon 09-05-11 16:03:18, Darrick J. Wong wrote:
> > > > > I am still chasing down what exactly is broken in ext3.  data=writeback mode
> > > > > passes with no failures.  data=ordered, however, does not pass; my current
> > > > > suspicion is that jbd is calling submit_bh on data buffers but doesn't call
> > > > > page_mkclean to kick the userspace programs off the page before writing it.
> > > >   Yes, ext3 in data=ordered mode writes pages from
> > > > journal_commit_transaction() via submit_bh() without clearing page dirty
> > > > bits thus page_mkclean() is not called for these pages. Frankly, do you
> > > > really want to bother with adding support for ext2 and ext3? People can use
> > > > ext4 as a fs driver when they want to start using blk-integrity support.
> > > > Especially ext2 patch looks really painful and just from a quick look I can
> > > > see code e.g. in fs/ext2/namei.c which isn't handled by your patch yet.
> > > 
> > > Yeah, I agree that ext2 is ugly and ext3/jbd might be more painful.  Are there
> > > any other code that wants stable pages that's already running with ext3?  In
> > > this months-long discussion I've heard that encryption and raid also like
> > > stable pages during writes.  Have those users been broken this whole time, or
> > > have they been stabilizing pages themselves?
> >   I believe part of them has been broken (e.g. raid) and part of them do
> > copy-out so they were OK.
> 
> A future step might be to undo all these homegrown copy-outs?
  Sure but I'm not the right one to tell you where these are ;).

> > > I suppose we can cross the "ext3 fails horribly on DIF" bridge when someone
> > > complains about it.  Possibly we could try to steer them to btrfs.
> >   Well, btrfs might be a bit too advantageous for production servers but
> > ext4 would be definitely viable for them.
> 
> Are there any distros that are going straight from ext3 to btrfs?
  Most distros currently offer users a choice of xfs, ext3, ext4, btrfs
with ext4 being the default. I'm not sure if that's what you are asking
about...

									Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
