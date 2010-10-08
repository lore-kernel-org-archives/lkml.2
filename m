Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755786Ab0JHIot (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Oct 2010 04:44:49 -0400
Received: from canuck.infradead.org ([134.117.69.58]:59635 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750776Ab0JHIos (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Oct 2010 04:44:48 -0400
Date: Fri, 8 Oct 2010 04:44:41 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: Dave Chinner <david@fromorbit.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 15/18] fs: introduce a per-cpu last_ino allocator
Message-ID: <20101008084441.GA17366@infradead.org>
References: <1286515292-15882-1-git-send-email-david@fromorbit.com>
 <1286515292-15882-16-git-send-email-david@fromorbit.com>
 <87d3rl5c1h.fsf@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87d3rl5c1h.fsf@basil.nowhere.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 08, 2010 at 10:22:34AM +0200, Andi Kleen wrote:
> Dave Chinner <david@fromorbit.com> writes:
> 
> > From: Eric Dumazet <eric.dumazet@gmail.com>
> >
> > new_inode() dirties a contended cache line to get increasing
> > inode numbers. This limits performance on workloads that cause
> > significant parallel inode allocation.
> >
> > Solve this problem by using a per_cpu variable fed by the shared
> > last_ino in batches of 1024 allocations.  This reduces contention on
> > the shared last_ino, and give same spreading ino numbers than before
> > (i.e. same wraparound after 2^32 allocations).
> 
> This doesn't help for Unix disk file systems, so not fully sure why you
> need it for XFS.

Currently i_ino is assigned for every inode allocated using new_inode.
It's pretty stupid as most callers simply don't need it.  But Dave
didn't want to make this series even more complicated than nessecary
and leave sorting this out for later.

