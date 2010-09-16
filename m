Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754593Ab0IPXrr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Sep 2010 19:47:47 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:54609 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750826Ab0IPXrq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Sep 2010 19:47:46 -0400
Date: Thu, 16 Sep 2010 19:47:42 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Jan Kara <jack@suse.cz>
Cc: Jens@suse.cz, "Axboe <axboe"@kernel.dk,
        Christoph Hellwig <hch@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 0/3] BDI handling fixes
Message-ID: <20100916234742.GA26030@infradead.org>
References: <1284677051-28564-1-git-send-email-jack@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1284677051-28564-1-git-send-email-jack@suse.cz>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 17, 2010 at 12:44:08AM +0200, Jan Kara wrote:
> 
>   Hi,
> 
>   series of these three patches fixes the warning in __mark_inode_dirty()
> which happens when I do e.g. touch /dev/zero. The first two patches should
> be obvious enough and probably worth merging independently of the third
> patch. The third patch is upto a discussion whether we want to solve the
> problem that way or differently. Christoph, I know we spoke at LSF that
> inode_to_bdi() could be a per-sb method but the current version of the
> patch seems clean enough to me that we could maybe go even without the
> special callback?

Feel free to go with the simpler one.  But what I think really needs to
be changes is the no writeback flag - it's exactly the wrong way around.

Instead just add a flag to allow writeback for the block device and
fs-specific bdi structures.

