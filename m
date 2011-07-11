Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756907Ab1GKCBA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jul 2011 22:01:00 -0400
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:12944 "EHLO
	ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756670Ab1GKCA7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jul 2011 22:00:59 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvYFAPpVGk55LCkBgWdsb2JhbABThESUBo5yFQEBFiYliHqvD5AHDoEdgXuCBTBfBJp2gTSHAw
Date: Mon, 11 Jul 2011 12:00:54 +1000
From: Dave Chinner <david@fromorbit.com>
To: raghu.prabhu13@gmail.com
Cc: akpm@linux-foundation.org, mgorman@suse.de, kamezawa.hiroyu@jp.fujitsu.com,
        keithp@keithp.com, viro@zeniv.linux.org.uk, riel@redhat.com,
        swhiteho@redhat.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        jack@suse.cz, Raghavendra D Prabhu <rprabhu@wnohang.net>
Subject: Re: [PATCH] Remove incorrect usage of sysctl_vfs_cache_pressure
Message-ID: <20110711020054.GE23038@dastard>
References: <cover.1310331583.git.rprabhu@wnohang.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <cover.1310331583.git.rprabhu@wnohang.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 11, 2011 at 02:56:23AM +0530, raghu.prabhu13@gmail.com wrote:
> From: Raghavendra D Prabhu <rprabhu@wnohang.net>
> 
> In shrinker functions, sysctl_vfs_cache_pressure variable is being used while
> trimming slab caches in general and not restricted to inode/dentry caches as
> documented for that sysctl.
> 
> Raghavendra D Prabhu (1):
>   mm/vmscan: Remove sysctl_vfs_cache_pressure from non-vfs shrinkers
> 
>  drivers/gpu/drm/i915/i915_gem.c |    2 +-

That's the only questionable use of it as it has nothing to do with
filesystems.

>  fs/gfs2/glock.c                 |    2 +-
>  fs/gfs2/quota.c                 |    2 +-
>  fs/mbcache.c                    |    2 +-
>  fs/nfs/dir.c                    |    2 +-
>  fs/quota/dquot.c                |    3 +--
>  net/sunrpc/auth.c               |    2 +-

All the others are filesystem₋specific caches and as such the use of
vfs_cache_pressure to adjust the balance of reclaim is valid usage.
Especially the VFS quota cache shrinkers. ;)

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
