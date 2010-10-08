Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756992Ab0JHKJu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Oct 2010 06:09:50 -0400
Received: from one.firstfloor.org ([213.235.205.2]:50087 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752267Ab0JHKJt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Oct 2010 06:09:49 -0400
Date: Fri, 8 Oct 2010 12:09:44 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Andi Kleen <andi@firstfloor.org>, Dave Chinner <david@fromorbit.com>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 15/18] fs: introduce a per-cpu last_ino allocator
Message-ID: <20101008100944.GE13352@basil.fritz.box>
References: <1286515292-15882-1-git-send-email-david@fromorbit.com>
 <1286515292-15882-16-git-send-email-david@fromorbit.com>
 <87d3rl5c1h.fsf@basil.nowhere.org>
 <20101008095824.GB19804@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101008095824.GB19804@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 08, 2010 at 10:58:24AM +0100, Al Viro wrote:
> On Fri, Oct 08, 2010 at 10:22:34AM +0200, Andi Kleen wrote:
> > Dave Chinner <david@fromorbit.com> writes:
> > 
> > > From: Eric Dumazet <eric.dumazet@gmail.com>
> > >
> > > new_inode() dirties a contended cache line to get increasing
> > > inode numbers. This limits performance on workloads that cause
> > > significant parallel inode allocation.
> > >
> > > Solve this problem by using a per_cpu variable fed by the shared
> > > last_ino in batches of 1024 allocations.  This reduces contention on
> > > the shared last_ino, and give same spreading ino numbers than before
> > > (i.e. same wraparound after 2^32 allocations).
> > 
> > This doesn't help for Unix disk file systems, so not fully sure why you
> > need it for XFS.
> > 
> > But looks reasonable, although it would be better to simply fix 
> > sockets/pipes/etc. to not allocate an inode numbers.
> 
> Can be done if you bother to add ->getattr() for those, but you'll need
> to do some kind of lazy allocation of inumbers for those; fstat() _will_
> want st_ino.

Why not just put 0 in st_ino for sockets/pipes/etc. ? 

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
