Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751946Ab0DMJSj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Apr 2010 05:18:39 -0400
Received: from bld-mail19.adl2.internode.on.net ([150.101.137.104]:48309 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751158Ab0DMJSi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Apr 2010 05:18:38 -0400
Date: Tue, 13 Apr 2010 19:18:23 +1000
From: Dave Chinner <david@fromorbit.com>
To: Hans-Peter Jansen <hpj@urpla.net>
Cc: linux-kernel@vger.kernel.org, opensuse-kernel@opensuse.org,
       xfs@oss.sgi.com
Subject: Re: 2.6.34-rc3: simple du (on a big xfs tree) triggers oom killer
 [bisected: 57817c68229984818fea9e614d6f95249c3fb098]
Message-ID: <20100413091823.GD7544@dastard>
References: <201004050049.17952.hpj@urpla.net>
 <201004080002.21137.hpj@urpla.net>
 <20100412223241.GM2493@dastard>
 <201004131050.36395.hpj@urpla.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201004131050.36395.hpj@urpla.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 13, 2010 at 10:50:35AM +0200, Hans-Peter Jansen wrote:
> On Tuesday 13 April 2010, 00:32:41 Dave Chinner wrote:
> > On Thu, Apr 08, 2010 at 12:02:20AM +0200, Hans-Peter Jansen wrote:
> > > On Wednesday 07 April 2010, 03:45:33 Dave Chinner wrote:
> > >
> > > > The patches below apply to the xfs-dev tree, which is currently at
> > > > 34-rc1. If they don't apply, let me know and I'll redo them against
> > > > a vanilla kernel tree. Can you test them to see if the problem goes
> > > > away? If the problem is fixed, I'll push them for a proper review
> > > > cycle...
> > >
> > > Of course, you did the original patch for a reason... Therefor I would
> > > love to test your patches. I've tried to apply them to 2.6.33.2, but
> > > after fixing the same reject as noted below, I'm stuck here:
> > >
> > > /usr/src/packages/BUILD/kernel-default-2.6.33.2/linux-2.6.33/fs/xfs/lin
> > >ux-2.6/xfs_sync.c: In function 'xfs_reclaim_inode_shrink':
> > > /usr/src/packages/BUILD/kernel-default-2.6.33.2/linux-2.6.33/fs/xfs/lin
> > >ux-2.6/xfs_sync.c:805: error: implicit declaration of function
> > > 'xfs_perag_get'
> > > /usr/src/packages/BUILD/kernel-default-2.6.33.2/linux-2.6.33/fs/xfs/lin
> > >ux-2.6/xfs_sync.c:805: warning: assignment makes pointer from integer
> > > without a cast
> > > /usr/src/packages/BUILD/kernel-default-2.6.33.2/linux-2.6.33/fs/xfs/lin
> > >ux-2.6/xfs_sync.c:807: error: implicit declaration of function
> > > 'xfs_perag_put'
> > >
> > > Now I see, that there happened a rename of the offending functions, but
> > > also they've grown a radix_tree structure and locking. How do I handle
> > > that?
> >
> > With difficulty. I'd need to backport it to match the .33 code,
> > which may or may not be trivial...
> 
> Dave, may I ask you kindly for briefly elaborating on the worst consequences 
> of just reverting this hunk, as I've done before?

Well, given that is the new shrinker code generating the warnings,
reverting/removing that hunk will render the patch useless :0

I'll get you a working 2.6.33 patch tomorrow - it's dinner time
now....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
