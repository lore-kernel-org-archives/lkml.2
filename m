Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751455Ab1DVEu5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Apr 2011 00:50:57 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:59390 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750798Ab1DVEu4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Apr 2011 00:50:56 -0400
Date: Fri, 22 Apr 2011 00:50:54 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Josef Bacik <josef@toxicpanda.com>
Cc: Eric Blake <eblake@redhat.com>, linux-kernel@vger.kernel.org,
        linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 1/2] fs: add SEEK_HOLE and SEEK_DATA flags
Message-ID: <20110422045054.GB17795@infradead.org>
References: <1303414954-3315-1-git-send-email-josef@redhat.com>
 <loom.20110422T001650-760@post.gmane.org>
 <BANLkTiknb+hzFAjpwESwMcqMVtkFc0HFQQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BANLkTiknb+hzFAjpwESwMcqMVtkFc0HFQQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Eric: please don't drop the Cc list, thanks!]

On Thu, Apr 21, 2011 at 09:22:55PM -0400, Josef Bacik wrote:
> > since all files have a virtual hole at the end, but leaves the position
> > unchanged). ??I'd have to write a test program on Solaris to see whether that
> > definition is actually true, or if it is a bug in the Solaris man page.
> >
> 
> lseek's purpose is to reposition the file position, so I'd imagine
> this is just a bug in the man page.

I would be surprised if the bug is around for such a long time, but
otherwise I concur.

> Except you can have blocks allocated past i_size, so returning i_size
> isn't necessarily correct.  Obviously the idea is to have most of the
> filesystems doing the correct thing, but for my first go around I just
> was going to do one since I expect quite a bit of repainting for this
> bikeshed is yet to be done.  But I guess if you have data past i_size
> doing this would encourage the various fs people to fix it.

Trying to be smart about our semantics is not helpful here.  The
interface has been out in Solaris for a while, and we'll have to either
stick to it or use different names for the interface.  And staying
compatible is far more useful for userspace programmers.

