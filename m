Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754920Ab2ATTFt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jan 2012 14:05:49 -0500
Received: from cantor2.suse.de ([195.135.220.15]:38510 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754643Ab2ATTFs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jan 2012 14:05:48 -0500
Date: Fri, 20 Jan 2012 20:05:45 +0100
From: Jan Kara <jack@suse.cz>
To: Christoph Hellwig <hch@infradead.org>
Cc: Jan Kara <jack@suse.cz>, Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PULL REQUEST] Ext3 & ext2 fix, quota improvement
Message-ID: <20120120190545.GA18688@quack.suse.cz>
References: <20120120163910.GA16973@quack.suse.cz>
 <20120120164400.GA19032@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120120164400.GA19032@infradead.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 20-01-12 11:44:00, Christoph Hellwig wrote:
> On Fri, Jan 20, 2012 at 05:39:10PM +0100, Jan Kara wrote:
> >       quota: Pass information that quota is stored in system file to userspace
> 
> Was that patch posted somewhere?  How does it apply to e.g. xfs, gfs2
> and ocfs2 that have always stored quota data internally?
  It was posted back in November (but I forgot it in a topic branch thus
I'm merging it only now), looking at the post I sent it to linux-ext4 only
which was probably a bit unlucky.

Regarding other filesystems - ocfs2 and gfs2 set DQUOT_QUOTA_SYS_FILE flag
so this will now be passed properly to userspace to inform userspace
programs (but quota-tools anyway use the flag only for ext4, for other
filesystems they know quota is handled internally just by looking at
filesystem type). XFS doesn't set the flag. It does not matter in practice
as XFS doesn't use VFS quota code which cares about the flag
(dquot_quota_sync, dquot_disable) and userspace tools know XFS handles
quota internally. But maybe we could make XFS set it just for consistency?

								Honza

-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
