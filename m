Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932996Ab1FAAjo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 20:39:44 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:36206
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758469Ab1FAAjn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 20:39:43 -0400
Date: Tue, 31 May 2011 20:39:42 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Hugh Dickins <hughd@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [PATCH 3/14] tmpfs: take control of its truncate_range
Message-ID: <20110601003942.GB4433@infradead.org>
References: <alpine.LSU.2.00.1105301726180.5482@sister.anvils>
 <alpine.LSU.2.00.1105301737040.5482@sister.anvils>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.00.1105301737040.5482@sister.anvils>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Note that drivers/gpu/drm/i915/i915_gem.c i915_gem_object_truncate()
> calls the tmpfs ->truncate_range directly: update that in a separate
> patch later, for now just let it duplicate the truncate_inode_pages().
> Because i915 handles unmap_mapping_range() itself at a different stage,
> we have chosen not to bundle that into ->truncate_range.

In your next series that makes it call the readpae replacement directly
it might be nice to also call directly into shmem for hole punching.

> I notice that ext4 is now joining ocfs2 and xfs in supporting fallocate
> FALLOC_FL_PUNCH_HOLE: perhaps they should support truncate_range, and
> tmpfs should support fallocate?  But worry about that another time...

No, truncate_range and the madvice interface are pretty sad hacks that
should never have been added in the first place.  Adding
FALLOC_FL_PUNCH_HOLE support for shmem on the other hand might make
some sense.

