Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755961Ab0E1Hov (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 May 2010 03:44:51 -0400
Received: from smtp.nokia.com ([192.100.122.233]:39808 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754162Ab0E1Hos (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 May 2010 03:44:48 -0400
Subject: Re: [PATCH 0/5] Per superblock shrinkers V2
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Dave Chinner <david@fromorbit.com>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, xfs@oss.sgi.com
In-Reply-To: <20100527133223.efa4740a.akpm@linux-foundation.org>
References: <1274777588-21494-1-git-send-email-david@fromorbit.com>
	 <20100527133223.efa4740a.akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 28 May 2010 10:42:06 +0300
Message-ID: <1275032526.15516.83.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 28 May 2010 07:43:50.0812 (UTC) FILETIME=[839C25C0:01CAFE39]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-05-27 at 13:32 -0700, Andrew Morton wrote:
> On Tue, 25 May 2010 18:53:03 +1000
> Dave Chinner <david@fromorbit.com> wrote:
> 
> > This series reworks the filesystem shrinkers. We currently have a
> > set of issues with the current filesystem shrinkers:
> > 
> >         1. There is an dependency between dentry and inode cache
> >            shrinking that is only implicitly defined by the order of
> >            shrinker registration.
> >         2. The shrinkers need to walk the superblock list and pin
> >            the superblock to avoid unmount races with the sb going
> >            away.
> >         3. The dentry cache uses per-superblock LRUs and proportions
> >            reclaim between all the superblocks which means we are
> >            doing breadth based reclaim. This means we touch every
> >            superblock for every shrinker call, and may only reclaim
> >            a single dentry at a time from a given superblock.
> >         4. The inode cache has a global LRU, so it has different
> >            reclaim patterns to the dentry cache, despite the fact
> >            that the dentry cache is generally the only thing that
> >            pins inodes in memory.
> >         5. Filesystems need to register their own shrinkers for
> >            caches and can't co-ordinate them with the dentry and
> >            inode cache shrinkers.
> 
> Nice description, but...  it never actually told us what the benefit of
> the changes are.  Presumably some undescribed workload had some
> undescribed user-visible problem.  But what was that workload, and what
> was the user-visible problem, and how does the patch affect all this?

For UBIFS it wwill give a benefit in terms of simpler UBIFS code - we
now have to keep our own list of UBIFS superblocks, provide locking for
it, and maintain. This is just extra burden. So the item 2 above will be
useful for UBIFS.

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)

