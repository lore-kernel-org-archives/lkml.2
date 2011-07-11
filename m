Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753839Ab1GKKdc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jul 2011 06:33:32 -0400
Received: from mx1.redhat.com ([209.132.183.28]:29308 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753194Ab1GKKdb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jul 2011 06:33:31 -0400
Subject: Re: [PATCH] Remove incorrect usage of sysctl_vfs_cache_pressure
From: Steven Whitehouse <swhiteho@redhat.com>
To: Dave Chinner <david@fromorbit.com>
Cc: raghu.prabhu13@gmail.com, akpm@linux-foundation.org, mgorman@suse.de,
        kamezawa.hiroyu@jp.fujitsu.com, keithp@keithp.com,
        viro@zeniv.linux.org.uk, riel@redhat.com, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, jack@suse.cz,
        Raghavendra D Prabhu <rprabhu@wnohang.net>
In-Reply-To: <20110711020054.GE23038@dastard>
References: <cover.1310331583.git.rprabhu@wnohang.net>
	 <20110711020054.GE23038@dastard>
Content-Type: text/plain; charset="UTF-8"
Organization: Red Hat UK Ltd
Date: Mon, 11 Jul 2011 11:35:11 +0100
Message-ID: <1310380511.2766.3.camel@menhir>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, 2011-07-11 at 12:00 +1000, Dave Chinner wrote:
> On Mon, Jul 11, 2011 at 02:56:23AM +0530, raghu.prabhu13@gmail.com wrote:
> > From: Raghavendra D Prabhu <rprabhu@wnohang.net>
> > 
> > In shrinker functions, sysctl_vfs_cache_pressure variable is being used while
> > trimming slab caches in general and not restricted to inode/dentry caches as
> > documented for that sysctl.
> > 
> > Raghavendra D Prabhu (1):
> >   mm/vmscan: Remove sysctl_vfs_cache_pressure from non-vfs shrinkers
> > 
> >  drivers/gpu/drm/i915/i915_gem.c |    2 +-
> 
> That's the only questionable use of it as it has nothing to do with
> filesystems.
> 
> >  fs/gfs2/glock.c                 |    2 +-
> >  fs/gfs2/quota.c                 |    2 +-
> >  fs/mbcache.c                    |    2 +-
> >  fs/nfs/dir.c                    |    2 +-
> >  fs/quota/dquot.c                |    3 +--
> >  net/sunrpc/auth.c               |    2 +-
> 
> All the others are filesystem₋specific caches and as such the use of
> vfs_cache_pressure to adjust the balance of reclaim is valid usage.
> Especially the VFS quota cache shrinkers. ;)
> 
> Cheers,
> 
> Dave.

I agree for the two GFS2 uses of this variable. There is no need to make
this change,

Steve.


