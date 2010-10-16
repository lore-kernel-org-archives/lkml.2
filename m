Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753332Ab0JPH4p (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Oct 2010 03:56:45 -0400
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:23402 "EHLO
	ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753033Ab0JPH4n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Oct 2010 03:56:43 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAFP1uEx5LcB2/2dsb2JhbAChMXK8eIVJBI9K
Date: Sat, 16 Oct 2010 18:56:41 +1100
From: Nick Piggin <npiggin@kernel.dk>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Dave Chinner <david@fromorbit.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 07/17] fs: icache atomic inodes_stat
Message-ID: <20101016075641.GL19147@amd>
References: <1285762729-17928-1-git-send-email-david@fromorbit.com>
 <1285762729-17928-8-git-send-email-david@fromorbit.com>
 <20100929215253.6fd944a2.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100929215253.6fd944a2.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 29, 2010 at 09:52:53PM -0700, Andrew Morton wrote:
> On Wed, 29 Sep 2010 22:18:39 +1000 Dave Chinner <david@fromorbit.com> wrote:
> > From: Nick Piggin <npiggin@suse.de>
> > 
> > The inode use statistics are currently protected by the inode_lock.
> > Before we can remove the inode_lock, we need to protect these
> > counters against races. Do this by converting them to atomic
> > counters so they ar enot dependent on any lock at all.
> 
> typo

It's Dave, I swear :)


> > +struct inodes_stat_t {
> > +	atomic_t nr_inodes;
> > +	atomic_t nr_unused;
> > +	int dummy[5];		/* padding for sysctl ABI compatibility */
> > +};
> 
> OK, that's a hack.  The first two "ints" are copied out to userspace. 
> This change assumes that sizeof(atomic_t)=4 and that an atomic_t has
> the same layout, alignment and padding as an int.
> 
> Probably that's true in current kernels and with current architectures
> but it's a hack and it's presumptive.
> 
> It shouldn't be snuck into the tree unchangelogged and uncommented.
> 
> (time passes)
> 
> OK, I see that all of this gets reverted later on.  Please update the
> changelog so the next reviewer doesn't get fooled.

Yeah it is. I might end up folding the per-cpu stuff back over it
and avoid the issue completely. Otherwise I'll add a comment.

