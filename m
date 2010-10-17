Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757287Ab0JQCtd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Oct 2010 22:49:33 -0400
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:18661 "EHLO
	ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757228Ab0JQCtc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Oct 2010 22:49:32 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApYEAAsAukx5LcB2gWdsb2JhbAChKRYBARYiIsIRhUkEj0w
Date: Sun, 17 Oct 2010 13:49:23 +1100
From: Nick Piggin <npiggin@kernel.dk>
To: Christoph Hellwig <hch@infradead.org>
Cc: Dave Chinner <david@fromorbit.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 17/19] fs: Reduce inode I_FREEING and factor inode
 disposal
Message-ID: <20101017024923.GA6453@amd>
References: <1287216853-17634-1-git-send-email-david@fromorbit.com>
 <1287216853-17634-18-git-send-email-david@fromorbit.com>
 <20101017013047.GA4394@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101017013047.GA4394@infradead.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 16, 2010 at 09:30:47PM -0400, Christoph Hellwig wrote:
> >   * inode->i_lock is *always* the innermost lock.
> >   *
> > + * inode->i_lock is *always* the innermost lock.
> > + *
> 
> No need to repeat, we got it..

Except that I didn't see where you fixed all the places where it is
*not* the innermost lock. Like for example places that take dcache_lock
inside i_lock.

Really, the assertions that my series is causing the world to end
because it makes i_lock no longer the innermost lock (not that it is
anyway) etc. is just not constructive in the slightest.

A lock is a lock. If we take another lock inside it, it is not an
innermost lock. If we do it properly and don't introduce deadlocks, it
is not a bug.

