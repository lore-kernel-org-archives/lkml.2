Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752755Ab1FCFQN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jun 2011 01:16:13 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:45043
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752215Ab1FCFQM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jun 2011 01:16:12 -0400
Date: Fri, 3 Jun 2011 01:16:09 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Hugh Dickins <hughd@google.com>
Cc: Christoph Hellwig <hch@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 3/14] tmpfs: take control of its truncate_range
Message-ID: <20110603051609.GC16721@infradead.org>
References: <alpine.LSU.2.00.1105301726180.5482@sister.anvils>
 <alpine.LSU.2.00.1105301737040.5482@sister.anvils>
 <20110601003942.GB4433@infradead.org>
 <alpine.LSU.2.00.1106010940590.23468@sister.anvils>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.00.1106010940590.23468@sister.anvils>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 01, 2011 at 09:58:18AM -0700, Hugh Dickins wrote:
> (i915 isn't really doing hole-punching there, I think it just found it
> a useful interface to remove the page-and-swapcache without touching
> i_size.  Parentheses because it makes no difference to your point.)

Keeping i_size while removing pages on tmpfs fits the defintion of hole
punching for me.  Not that it matters anyway.

> When I say "shmem", I am including the !SHMEM-was-TINY_SHMEM case too,
> which goes to ramfs.  Currently i915 has been configured to disable that
> possibility, though we insisted on it originally: there may or may not be
> good reason for disabling it - may just be a side-effect of the rather
> twisted unintuitive SHMEM/TMPFS dependencies.

Hmm, the two different implementations make everything harder.  Also
because we don't even implement the hole punching in !SHMEM tmpfs.

> Fine, I'll add tmpfs PUNCH_HOLE later on.  And wire up madvise MADV_REMOVE
> to fallocate PUNCH_HOLE, yes?

Yeah.  One thing I've noticed is that the hole punching doesn't seem
to do the unmap_mapping_range.  It might be worth to audit that from the
VM point of view.

> Would you like me to remove the ->truncate_range method from
> inode_operations completely?

Doing that would be nice.  Do we always have the required file struct
for ->fallocate in the callers?

