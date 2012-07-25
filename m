Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755850Ab2GYQHy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2012 12:07:54 -0400
Received: from cantor2.suse.de ([195.135.220.15]:54401 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754091Ab2GYQHx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2012 12:07:53 -0400
Date: Wed, 25 Jul 2012 17:07:49 +0100
From: Mel Gorman <mgorman@suse.de>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Stable <stable@vger.kernel.org>, Linux-MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 16/34] mm: compaction: Allow compaction to isolate dirty
 pages
Message-ID: <20120725160749.GD9222@suse.de>
References: <1343050727-3045-1-git-send-email-mgorman@suse.de>
 <1343050727-3045-17-git-send-email-mgorman@suse.de>
 <20120725154745.GB18901@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20120725154745.GB18901@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 25, 2012 at 08:47:45AM -0700, Greg KH wrote:
> On Mon, Jul 23, 2012 at 02:38:29PM +0100, Mel Gorman wrote:
> > commit a77ebd333cd810d7b680d544be88c875131c2bd3 upstream.
> > 
> > Stable note: Not tracked in Bugzilla. A fix aimed at preserving page aging
> > 	information by reducing LRU list churning had the side-effect of
> > 	reducing THP allocation success rates. This was part of a series
> > 	to restore the success rates while preserving the reclaim fix.
> > 
> > Commit [39deaf85: mm: compaction: make isolate_lru_page() filter-aware]
> > noted that compaction does not migrate dirty or writeback pages and
> > that is was meaningless to pick the page and re-add it to the LRU list.
> > 
> > What was missed during review is that asynchronous migration moves
> > dirty pages if their ->migratepage callback is migrate_page() because
> > these can be moved without blocking. This potentially impacted
> > hugepage allocation success rates by a factor depending on how many
> > dirty pages are in the system.
> > 
> > This patch partially reverts 39deaf85 to allow migration to isolate
> > dirty pages again. This increases how much compaction disrupts the
> > LRU but that is addressed later in the series.
> > 
> > Signed-off-by: Mel Gorman <mgorman@suse.de>
> > Reviewed-by: Andrea Arcangeli <aarcange@redhat.com>
> > Reviewed-by: Rik van Riel <riel@redhat.com>
> > Reviewed-by: Minchan Kim <minchan.kim@gmail.com>
> 
> Note, the changelog here differs from what is in Linus's tree by a LOT.
> I took the version in Linus's tree instead.
> 

Yet another case of where the distribution kernel got the patch first
and I mucked up the transfer back.  In this case the mainline changelog
includes the patch leader with a lot of additional information.

-- 
Mel Gorman
SUSE Labs
