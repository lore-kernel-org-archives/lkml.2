Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933003Ab0GTWyG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jul 2010 18:54:06 -0400
Received: from bld-mail17.adl2.internode.on.net ([150.101.137.102]:58477 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932946Ab0GTWyE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jul 2010 18:54:04 -0400
Date: Wed, 21 Jul 2010 08:53:55 +1000
From: Dave Chinner <david@fromorbit.com>
To: Alex Elder <aelder@sgi.com>
Cc: xfs@oss.sgi.com, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 1/3] mm: add context argument to shrinker callback
Message-ID: <20100720225355.GP32635@dastard>
References: <1279194418-16119-1-git-send-email-david@fromorbit.com>
 <1279194418-16119-2-git-send-email-david@fromorbit.com>
 <1279654204.1859.232.camel@doink>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1279654204.1859.232.camel@doink>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 20, 2010 at 02:30:04PM -0500, Alex Elder wrote:
> On Thu, 2010-07-15 at 21:46 +1000, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > The current shrinker implementation requires the registered callback
> > to have global state to work from. This makes it difficult to shrink
> > caches that are not global (e.g. per-filesystem caches). Pass the shrinker
> > structure to the callback so that users can embed the shrinker structure
> > in the context the shrinker needs to operate on and get back to it in the
> > callback via container_of().
> 
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > ---
> >  arch/x86/kvm/mmu.c              |    2 +-
> >  drivers/gpu/drm/i915/i915_gem.c |    2 +-
> >  fs/dcache.c                     |    2 +-
> >  fs/gfs2/glock.c                 |    2 +-
> >  fs/gfs2/quota.c                 |    2 +-
> >  fs/gfs2/quota.h                 |    2 +-
> >  fs/inode.c                      |    2 +-
> >  fs/mbcache.c                    |    5 +++--
> >  fs/nfs/dir.c                    |    2 +-
> >  fs/nfs/internal.h               |    3 ++-
> >  fs/quota/dquot.c                |    2 +-
> >  fs/ubifs/shrinker.c             |    2 +-
> >  fs/ubifs/ubifs.h                |    2 +-
> >  fs/xfs/linux-2.6/xfs_buf.c      |    5 +++--
> >  fs/xfs/linux-2.6/xfs_sync.c     |    1 +
> >  fs/xfs/quota/xfs_qm.c           |    7 +++++--
> >  include/linux/mm.h              |    2 +-
> >  mm/vmscan.c                     |    8 +++++---
> >  18 files changed, 31 insertions(+), 22 deletions(-)
> 
> You seem to have missed two registered shrinkers:
> - ttm_pool_mm_shrink() in "drivers/gpu/drm/ttm/ttm_page_alloc.c"
> - rpcauth_cache_shrinker() in "net/sunrpc/auth.c"

Bugger - one's a new shrinker since 2.6.34, and I'm not sure how I
missed the auth cache one. Oh, it throws a single warning:

net/sunrpc/auth.c:586: warning: initialization from incompatible pointer type

that I didn't notice as being a new warning.

Oh well, time to update.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
