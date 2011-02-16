Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757755Ab1BPIE0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Feb 2011 03:04:26 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:45492 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751532Ab1BPIEX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Feb 2011 03:04:23 -0500
Date: Wed, 16 Feb 2011 03:04:20 -0500
From: Christoph Hellwig <hch@infradead.org>
To: Charles Manning <manningc2@actrix.gen.nz>
Cc: Christoph Hellwig <hch@infradead.org>,
        Charles Manning <cdhmanning@gmail.com>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, ryan@bluewatersys.com,
        akpm@linux-foundation.org
Subject: Re: [PATCH 0/10] Add yaffs2 file system:  Fifth patchset
Message-ID: <20110216080419.GA21261@infradead.org>
References: <1297221968-6747-1-git-send-email-cdhmanning@gmail.com>
 <20110209045221.GB29650@infradead.org>
 <201102100722.47854.manningc2@actrix.gen.nz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201102100722.47854.manningc2@actrix.gen.nz>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 10, 2011 at 07:22:47AM +1300, Charles Manning wrote:
> Can you be a bit more specific?

Just compare the mes in yaffs_linux.c with a normal linux filesystem.
All that gross magic nfsd detection in readdir could have been removed
long ago.  ->readlink should not be implemented by a normal filesystem
but use generic_readlink, the fs-specific inode should embedd the vfs
inode instead of requiring two allocations, tons of useless function
pointer indirections like sb_dirty_fn and the put_super_fn really must
go away.  The procfs interfaces should be replaced by something saner,
the insane amount of ad-hoc tracing crap should be replaced by much
less strategically placed trace events, and all those stupid compile
time options have absolutely no business at all beeing there for a
filesystem - remember you can get media from all over the place.
If you can't encode these difference in your on-disk format it has
absolutely no business going into mainline with this format.

And last but not least there's no way we'll merge a filesystem with a
global mutex and all kinds of hacky release and reaquire semantics
these days.  I really think you need to get back to the drawing board.

