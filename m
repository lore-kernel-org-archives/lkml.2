Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756889Ab0JHJvs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Oct 2010 05:51:48 -0400
Received: from bld-mail17.adl2.internode.on.net ([150.101.137.102]:52533 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756776Ab0JHJvq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Oct 2010 05:51:46 -0400
Date: Fri, 8 Oct 2010 20:51:42 +1100
From: Dave Chinner <david@fromorbit.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 04/18] fs: Implement lazy LRU updates for inodes.
Message-ID: <20101008095142.GA4681@dastard>
References: <1286515292-15882-1-git-send-email-david@fromorbit.com>
 <1286515292-15882-5-git-send-email-david@fromorbit.com>
 <20101008090802.GV19804@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101008090802.GV19804@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 08, 2010 at 10:08:02AM +0100, Al Viro wrote:
> On Fri, Oct 08, 2010 at 04:21:18PM +1100, Dave Chinner wrote:
> 
> >  void __iget(struct inode *inode)
> >  {
> > -	if (atomic_inc_return(&inode->i_count) != 1)
> > -		return;
> > -
> > -	if (!(inode->i_state & (I_DIRTY|I_SYNC)))
> > -		list_move(&inode->i_list, &inode_in_use);
> > -	percpu_counter_dec(&nr_inodes_unused);
> > +	atomic_inc(&inode->i_count);
> >  }
> 
> Umm...  Are you sure we don't rely on implict barriers present in the current
> version?

I'll confess that I have no idea what you are talking about, Al.

Instead, I'll ask if the conversion later one where all accesses and
modifications to the reference count are moved under the
inode->i_lock is sufficient to provide the necessary memory
barriers?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
