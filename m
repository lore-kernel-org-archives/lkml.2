Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760757Ab0J0JM7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Oct 2010 05:12:59 -0400
Received: from bld-mail15.adl6.internode.on.net ([150.101.137.100]:50623 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751016Ab0J0JM4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Oct 2010 05:12:56 -0400
Date: Wed, 27 Oct 2010 20:12:52 +1100
From: Dave Chinner <david@fromorbit.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/4] fs: remove inode_lock from iput_final and
 prune_icache
Message-ID: <20101027091252.GE32255@dastard>
References: <1288153384-8878-1-git-send-email-david@fromorbit.com>
 <1288153384-8878-5-git-send-email-david@fromorbit.com>
 <20101027044038.GE19804@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20101027044038.GE19804@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 27, 2010 at 05:40:38AM +0100, Al Viro wrote:
> On Wed, Oct 27, 2010 at 03:23:04PM +1100, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > Now that inode state changes are protected by the inode->i_lock and
> > the inode LRU manipulations by the inode_lru_lock, we can remove the
> > inode_lock from prune_icache and the initial part of iput_final().
> > 
> > instead of using the inode_lock to protect the inode during
> > iput_final, use the inode->i_lock instead. This protects the inode
> > against new references being taken while we change the inode state
> > to I_FREEING, as well as preventing prune_icache from grabbing the
> > inode while we are manipulating it. Hence we no longer need the
> > i???ode_lock in iput_final prior to setting I_FREEING on the inode.
>   ^^^^^^^^^^^^
> 
> ... the hell?  There's more such damage elsewhere in the thread; what's
> going on?

vim utf-8 multibyte support that is causing these characters to be
created. e.g.  e<backspace>' results in é. sometimes the resultant
character looks almost identical and so I didn't notice. I haven't
found the magic recipe to turn this off (maxcombine=0 doesn't seem
to stop it) or change the special compose sequence, so I'll keep
looking.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
