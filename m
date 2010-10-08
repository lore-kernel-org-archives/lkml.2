Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932092Ab0JHJvc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Oct 2010 05:51:32 -0400
Received: from canuck.infradead.org ([134.117.69.58]:47300 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756776Ab0JHJvb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Oct 2010 05:51:31 -0400
Date: Fri, 8 Oct 2010 05:51:26 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Dave Chinner <david@fromorbit.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 11/18] fs: Introduce per-bucket inode hash locks
Message-ID: <20101008095126.GA15567@infradead.org>
References: <1286515292-15882-1-git-send-email-david@fromorbit.com>
 <1286515292-15882-12-git-send-email-david@fromorbit.com>
 <20101008094915.GZ19804@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101008094915.GZ19804@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 08, 2010 at 10:49:15AM +0100, Al Viro wrote:
> >  	HFS_I(inode)->rsrc_inode = dir;
> >  	HFS_I(dir)->rsrc_inode = inode;
> >  	igrab(dir);
> > -	hlist_add_head(&inode->i_hash, &HFS_SB(dir->i_sb)->rsrc_inodes);
> > +	hlist_bl_add_head(&inode->i_hash, &HFS_SB(dir->i_sb)->rsrc_inodes);
> >  	mark_inode_dirty(inode);
> 
> Lovely.  What protects that list?  Same question for hfsplus...

Nothing.  It's also never actually read.  For hfsplus all that is fixed
in my hfsplus tree, but I'll still need to find a sucker to backport
all this to hfs.
