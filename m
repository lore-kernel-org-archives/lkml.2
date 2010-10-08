Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756923Ab0JHJ7D (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Oct 2010 05:59:03 -0400
Received: from bld-mail17.adl2.internode.on.net ([150.101.137.102]:45936 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755196Ab0JHJ7B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Oct 2010 05:59:01 -0400
Date: Fri, 8 Oct 2010 20:58:57 +1100
From: Dave Chinner <david@fromorbit.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 05/18] fs: inode split IO and LRU lists
Message-ID: <20101008095857.GB4681@dastard>
References: <1286515292-15882-1-git-send-email-david@fromorbit.com>
 <1286515292-15882-6-git-send-email-david@fromorbit.com>
 <20101008091617.GW19804@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101008091617.GW19804@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 08, 2010 at 10:16:17AM +0100, Al Viro wrote:
> > -	struct list_head	i_list;		/* backing dev IO list */
> > +	struct list_head	i_io;		/* backing dev IO list */
> > +	struct list_head	i_lru;		/* backing dev IO list */
> 
> a) that pair of comments would be disqualified in IOCCC ;-)

Oops.

> b) have a pity on folks who will have to talk about the code.  I mean,
> how would you say that?  Ai-Ai-Oh?

Fair call. How about i_wb_list?

> > +extern struct percpu_counter nr_inodes;
> > +extern struct percpu_counter nr_inodes_unused;
> 
> Ehh...  At least take that to fs/internal.h.  Preferably don't expose at
> all.

That get's cleaned up later with helpers. As Christoph suggested, I need
to move the helpers forward in the series.

> 
> > -				list_del(&inode->i_list);
> > -				list_add(&inode->i_list, &bdi->wb.b_dirty);
> > +				list_del(&inode->i_io);
> > +				list_add(&inode->i_io, &bdi->wb.b_dirty);
> 
> list_move()?  Ditto for the next few.  And, while that's not directed
> at you, this kind of loops is Not Nice(tm)...

Not a great fan of them myself, but Christoph pointed out that the
inode <-> bdi fix of his that just landed in mainline should remove
the need for these loops.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
