Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932304Ab0JLMFn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Oct 2010 08:05:43 -0400
Received: from bld-mail12.adl6.internode.on.net ([150.101.137.97]:46991 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932259Ab0JLMFm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Oct 2010 08:05:42 -0400
Date: Tue, 12 Oct 2010 23:05:37 +1100
From: Dave Chinner <david@fromorbit.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 19/18] fs: split __inode_add_to_list
Message-ID: <20101012120537.GD32255@dastard>
References: <1286515292-15882-1-git-send-email-david@fromorbit.com>
 <20101009080854.GA15943@infradead.org>
 <20101012104727.GC32255@dastard>
 <20101012113130.GA24650@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101012113130.GA24650@infradead.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 12, 2010 at 07:31:30AM -0400, Christoph Hellwig wrote:
> On Tue, Oct 12, 2010 at 09:47:27PM +1100, Dave Chinner wrote:
> > The only reason XFS hashed the inodes was to avoid problems in the
> > generic code that checked for unhashed inodes during clear_inode(). The
> > evict() changeover moved that unhashed check into
> > generic_drop_inode(), which the filesystem can override. Hence if
> > you add a ->drop_inode() method for XFS that just checks the link
> > count, we can avoid ha??hing the inodes altogether for XFS.
> > 
> > I can add another patch on top of this one to do that if you want...
> 
> It's unfortunately not that simple.  Take a look at the unhashed check
> in __mark_inode_dirty.

Damn - I forgot about that one. Does anyone know why that check is
there?

> The drop_inode check could be avoided for
> quite a long time now.  What we could do however is the same hack as
> JFS does in diReadSpecial().

Nasty, but effective. Worth considering, I think.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
