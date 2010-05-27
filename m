Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932501Ab0E0Ucn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 16:32:43 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60459 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932109Ab0E0Ucm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 16:32:42 -0400
Date: Thu, 27 May 2010 13:32:23 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Dave Chinner <david@fromorbit.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       linux-mm@kvack.org, xfs@oss.sgi.com
Subject: Re: [PATCH 0/5] Per superblock shrinkers V2
Message-Id: <20100527133223.efa4740a.akpm@linux-foundation.org>
In-Reply-To: <1274777588-21494-1-git-send-email-david@fromorbit.com>
References: <1274777588-21494-1-git-send-email-david@fromorbit.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 25 May 2010 18:53:03 +1000
Dave Chinner <david@fromorbit.com> wrote:

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

Nice description, but...  it never actually told us what the benefit of
the changes are.  Presumably some undescribed workload had some
undescribed user-visible problem.  But what was that workload, and what
was the user-visible problem, and how does the patch affect all this?

Stuff like that.
