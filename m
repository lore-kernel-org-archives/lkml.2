Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750981Ab0JQENS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Oct 2010 00:13:18 -0400
Received: from bld-mail13.adl6.internode.on.net ([150.101.137.98]:53938 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750792Ab0JQENR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Oct 2010 00:13:17 -0400
Date: Sun, 17 Oct 2010 15:13:13 +1100
From: Dave Chinner <david@fromorbit.com>
To: Nick Piggin <npiggin@kernel.dk>
Cc: Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 17/19] fs: Reduce inode I_FREEING and factor inode
 disposal
Message-ID: <20101017041313.GJ32255@dastard>
References: <1287216853-17634-1-git-send-email-david@fromorbit.com>
 <1287216853-17634-18-git-send-email-david@fromorbit.com>
 <20101017013047.GA4394@infradead.org>
 <20101017024923.GA6453@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101017024923.GA6453@amd>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 17, 2010 at 01:49:23PM +1100, Nick Piggin wrote:
> On Sat, Oct 16, 2010 at 09:30:47PM -0400, Christoph Hellwig wrote:
> > >   * inode->i_lock is *always* the innermost lock.
> > >   *
> > > + * inode->i_lock is *always* the innermost lock.
> > > + *
> > 
> > No need to repeat, we got it..
> 
> Except that I didn't see where you fixed all the places where it is
> *not* the innermost lock. Like for example places that take dcache_lock
> inside i_lock.

I can't find any code outside of ceph where the dcache_lock is used
within 200 lines of code of the inode->i_lock. The ceph code is not
nesting them, though. And AFAICT, the i_lock is not used at all in the
dentry code.

So I must be missing something if this is occurring - can you point
out where this lock ordering is occurring in the mainline code?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
