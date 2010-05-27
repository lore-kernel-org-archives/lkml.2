Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933334Ab0E0EY6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 00:24:58 -0400
Received: from cantor2.suse.de ([195.135.220.15]:35057 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750724Ab0E0EY4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 00:24:56 -0400
Date: Thu, 27 May 2010 14:24:53 +1000
From: Nick Piggin <npiggin@suse.de>
To: Dave Chinner <david@fromorbit.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       linux-mm@kvack.org, xfs@oss.sgi.com
Subject: Re: [PATCH 3/5] superblock: introduce per-sb cache shrinker
 infrastructure
Message-ID: <20100527042453.GI22536@laptop>
References: <1274777588-21494-1-git-send-email-david@fromorbit.com>
 <1274777588-21494-4-git-send-email-david@fromorbit.com>
 <20100526164116.GD22536@laptop>
 <20100526231214.GB1395@dastard>
 <20100527021905.GG22536@laptop>
 <20100527040704.GJ12087@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100527040704.GJ12087@dastard>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 27, 2010 at 02:07:04PM +1000, Dave Chinner wrote:
> On Thu, May 27, 2010 at 12:19:05PM +1000, Nick Piggin wrote:
> > On Thu, May 27, 2010 at 09:12:14AM +1000, Dave Chinner wrote:
> > > On Thu, May 27, 2010 at 02:41:16AM +1000, Nick Piggin wrote:
> > > > > +	count = ((sb->s_nr_dentry_unused + sb->s_nr_inodes_unused) / 100)
> > > > > +						* sysctl_vfs_cache_pressure;
> > > > 
> > > > Do you think truncating in the divisions is at all a problem? It
> > > > probably doesn't matter much I suppose.
> > > 
> > > Same code as currently exists. IIRC, the reasoning is that if we've
> > > got less that 100 objects to reclaim, then we're unlikely to be able
> > > to free up any memory from the caches, anyway.
> > 
> > Yeah, which is why I stop short of saying you should change it in
> > this patch.
> > 
> > But I think we should ensure things can get reclaimed eventually.
> > 100 objects could be 100 slabs, which could be anything from
> > half a meg to half a dozen. Multiplied by each of the caches.
> > Could be significant in small systems.
> 
> True, but usually there are busy objects in the dentry and inode
> slabs, so it shouldn't be a significant issue. We can probably
> address such problems if they can be demonstrated to be an issue in
> a separate patch set....

I didn't want to say it is a problem with your patchset, I just
thought of it when reviewing.
