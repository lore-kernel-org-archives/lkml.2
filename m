Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752113Ab0JPAUr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Oct 2010 20:20:47 -0400
Received: from bld-mail18.adl2.internode.on.net ([150.101.137.103]:33184 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751040Ab0JPAUq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Oct 2010 20:20:46 -0400
Date: Sat, 16 Oct 2010 11:20:43 +1100
From: Dave Chinner <david@fromorbit.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 07/18] fs: rework icount to be a locked variable
Message-ID: <20101016002043.GM4681@dastard>
References: <1286928961-15157-1-git-send-email-david@fromorbit.com>
 <1286928961-15157-8-git-send-email-david@fromorbit.com>
 <20101013113643.GD19456@infradead.org>
 <20101016001533.GL4681@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101016001533.GL4681@dastard>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 16, 2010 at 11:15:33AM +1100, Dave Chinner wrote:
> On Wed, Oct 13, 2010 at 07:36:43AM -0400, Christoph Hellwig wrote:
> > > -		atomic_inc(&inode->i_count);
> > > +		spin_lock(&inode->i_lock);
> > > +		inode->i_ref++;
> > > +		spin_unlock(&inode->i_lock);
> > 
> > Why isn't this using iref?
> > 
> > > +		spin_lock(&inode->i_lock);
> > > +		inode->i_ref++;
> > > +		spin_unlock(&inode->i_lock);
> > 
> > Same here and in a couple of others.
> > 
> > Hmm, I guess because the i_lock later covers other things around.
> > But it still looks a bit weird.
> 
> Ok, I've changed them to iref() calls and convert them to open
> coding later on when necessary.

Oh, NAK that - hit send too soon. I forgot - they're are done that
way because they are under the inode_lock, and iref(), at this point
in the series, takes the inode_lock. So while it looks weird, it has
to stay that way otherwise it deadlocks.....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
