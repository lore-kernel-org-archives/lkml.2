Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932162Ab0EZQol (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 12:44:41 -0400
Received: from cantor.suse.de ([195.135.220.2]:49855 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755885Ab0EZQok (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 12:44:40 -0400
Date: Thu, 27 May 2010 02:44:37 +1000
From: Nick Piggin <npiggin@suse.de>
To: Dave Chinner <david@fromorbit.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       linux-mm@kvack.org, xfs@oss.sgi.com
Subject: Re: [PATCH 0/5] Per superblock shrinkers V2
Message-ID: <20100526164437.GE22536@laptop>
References: <1274777588-21494-1-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1274777588-21494-1-git-send-email-david@fromorbit.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 25, 2010 at 06:53:03PM +1000, Dave Chinner wrote:
> 
> This series reworks the filesystem shrinkers. We currently have a
> set of issues with the current filesystem shrinkers:
> 
>         1. There is an dependency between dentry and inode cache
>            shrinking that is only implicitly defined by the order of
>            shrinker registration.
>         2. The shrinkers need to walk the superblock list and pin
>            the superblock to avoid unmount races with the sb going
>            away.
>         3. The dentry cache uses per-superblock LRUs and proportions
>            reclaim between all the superblocks which means we are
>            doing breadth based reclaim. This means we touch every
>            superblock for every shrinker call, and may only reclaim
>            a single dentry at a time from a given superblock.
>         4. The inode cache has a global LRU, so it has different
>            reclaim patterns to the dentry cache, despite the fact
>            that the dentry cache is generally the only thing that
>            pins inodes in memory.
>         5. Filesystems need to register their own shrinkers for
>            caches and can't co-ordinate them with the dentry and
>            inode cache shrinkers.

Seems like a fairly good approach overall. Thanks.

