Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753877Ab0IQMxi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Sep 2010 08:53:38 -0400
Received: from cantor2.suse.de ([195.135.220.15]:56335 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752377Ab0IQMxh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Sep 2010 08:53:37 -0400
Date: Fri, 17 Sep 2010 14:52:45 +0200
From: Jan Kara <jack@suse.cz>
To: Christoph Hellwig <hch@infradead.org>
Cc: Jan Kara <jack@suse.cz>, Jens@suse.cz, "Axboe <axboe"@kernel.dk,
        LKML <linux-kernel@vger.kernel.org>, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 0/3] BDI handling fixes
Message-ID: <20100917125245.GA3342@quack.suse.cz>
References: <1284677051-28564-1-git-send-email-jack@suse.cz>
 <20100916234742.GA26030@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100916234742.GA26030@infradead.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 16-09-10 19:47:42, Christoph Hellwig wrote:
> On Fri, Sep 17, 2010 at 12:44:08AM +0200, Jan Kara wrote:
> > 
> >   Hi,
> > 
> >   series of these three patches fixes the warning in __mark_inode_dirty()
> > which happens when I do e.g. touch /dev/zero. The first two patches should
> > be obvious enough and probably worth merging independently of the third
> > patch. The third patch is upto a discussion whether we want to solve the
> > problem that way or differently. Christoph, I know we spoke at LSF that
> > inode_to_bdi() could be a per-sb method but the current version of the
> > patch seems clean enough to me that we could maybe go even without the
> > special callback?
> 
> Feel free to go with the simpler one.  But what I think really needs to
> be changes is the no writeback flag - it's exactly the wrong way around.
> 
> Instead just add a flag to allow writeback for the block device and
> fs-specific bdi structures.
  Agreed. I just think that I'll first make the flags right and then just
mechanically flip NO_WRITEBACK and WRITEBACK...

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
