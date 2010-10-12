Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932238Ab0JLLbe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Oct 2010 07:31:34 -0400
Received: from canuck.infradead.org ([134.117.69.58]:36414 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932144Ab0JLLbd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Oct 2010 07:31:33 -0400
Date: Tue, 12 Oct 2010 07:31:30 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 19/18] fs: split __inode_add_to_list
Message-ID: <20101012113130.GA24650@infradead.org>
References: <1286515292-15882-1-git-send-email-david@fromorbit.com>
 <20101009080854.GA15943@infradead.org>
 <20101012104727.GC32255@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101012104727.GC32255@dastard>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 12, 2010 at 09:47:27PM +1100, Dave Chinner wrote:
> The only reason XFS hashed the inodes was to avoid problems in the
> generic code that checked for unhashed inodes during clear_inode(). The
> evict() changeover moved that unhashed check into
> generic_drop_inode(), which the filesystem can override. Hence if
> you add a ->drop_inode() method for XFS that just checks the link
> count, we can avoid ha??hing the inodes altogether for XFS.
> 
> I can add another patch on top of this one to do that if you want...

It's unfortunately not that simple.  Take a look at the unhashed check
in __mark_inode_dirty.  The drop_inode check could be avoided for
quite a long time now.  What we could do however is the same hack as
JFS does in diReadSpecial().
