Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752826Ab0J0FZ0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Oct 2010 01:25:26 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:41518 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751928Ab0J0FZW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Oct 2010 01:25:22 -0400
Date: Wed, 27 Oct 2010 06:25:20 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Dave Chinner <david@fromorbit.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/4] fs: remove inode_lock from iput_final and
 prune_icache
Message-ID: <20101027052520.GF19804@ZenIV.linux.org.uk>
References: <1288153384-8878-1-git-send-email-david@fromorbit.com>
 <1288153384-8878-5-git-send-email-david@fromorbit.com>
 <20101027044038.GE19804@ZenIV.linux.org.uk>
 <1288154866.2652.84.camel@edumazet-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1288154866.2652.84.camel@edumazet-laptop>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 27, 2010 at 06:47:46AM +0200, Eric Dumazet wrote:
> Le mercredi 27 octobre 2010 ?? 05:40 +0100, Al Viro a ??crit :
> > On Wed, Oct 27, 2010 at 03:23:04PM +1100, Dave Chinner wrote:
> > > From: Dave Chinner <dchinner@redhat.com>
> > > 
> > > Now that inode state changes are protected by the inode->i_lock and
> > > the inode LRU manipulations by the inode_lru_lock, we can remove the
> > > inode_lock from prune_icache and the initial part of iput_final().
> > > 
> > > instead of using the inode_lock to protect the inode during
> > > iput_final, use the inode->i_lock instead. This protects the inode
> > > against new references being taken while we change the inode state
> > > to I_FREEING, as well as preventing prune_icache from grabbing the
> > > inode while we are manipulating it. Hence we no longer need the
> > > i???ode_lock in iput_final prior to setting I_FREEING on the inode.
> >   ^^^^^^^^^^^^
> > 
> > ... the hell?  There's more such damage elsewhere in the thread; what's
> > going on?
> > --
> 
> Maybe its on your side, no problem here on my copy.

"i\xe1\xb9\x89ode_lock", i.e. 'n' turned into U+1E49, aka "latin small letter
n with line below".  I doubt that it's MTA braindamage.

In the first patch there's 

- * invalidate_inodes    - attempt to free all inodes on a
+ * nvalidate_inodes    - attempt to free all inodes on a

and I _really_ doubt that anything in mail system is capable of something
that elaborate.
