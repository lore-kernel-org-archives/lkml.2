Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751989Ab1LPLaF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Dec 2011 06:30:05 -0500
Received: from cantor2.suse.de ([195.135.220.15]:43627 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751363Ab1LPL36 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Dec 2011 06:29:58 -0500
Date: Fri, 16 Dec 2011 11:29:54 +0000
From: Mel Gorman <mgorman@suse.de>
To: Rik van Riel <riel@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Minchan Kim <minchan.kim@gmail.com>, Dave Jones <davej@redhat.com>,
        Jan Kara <jack@suse.cz>, Andy Isaacson <adi@hexapodia.org>,
        Johannes Weiner <jweiner@redhat.com>, Nai Xia <nai.xia@gmail.com>,
        Linux-MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 10/11] mm: vmscan: Check if reclaim should really abort
 even if compaction_ready() is true for one zone
Message-ID: <20111216112954.GG3487@suse.de>
References: <1323877293-15401-1-git-send-email-mgorman@suse.de>
 <1323877293-15401-11-git-send-email-mgorman@suse.de>
 <4EEACB53.4040706@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <4EEACB53.4040706@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 15, 2011 at 11:38:43PM -0500, Rik van Riel wrote:
> On 12/14/2011 10:41 AM, Mel Gorman wrote:
> >If compaction can proceed for a given zone, shrink_zones() does not
> >reclaim any more pages from it. After commit [e0c2327: vmscan: abort
> >reclaim/compaction if compaction can proceed], do_try_to_free_pages()
> >tries to finish as soon as possible once one zone can compact.
> >
> >This was intended to prevent slabs being shrunk unnecessarily but
> >there are side-effects. One is that a small zone that is ready for
> >compaction will abort reclaim even if the chances of successfully
> >allocating a THP from that zone is small. It also means that reclaim
> >can return too early even though sc->nr_to_reclaim pages were not
> >reclaimed.
> 
> Having slabs shrunk "too much" might actually be good,
> because it does result in more memory blocks where
> compaction can be successful.
> 
> If we end up frequently evicting frequently accessed
> data from the slab cache, chances are the buffer cache
> will cache that data (since we reload it often).
> 
> If we end up evicting infrequently used data, chances
> are it won't really matter for performance.
> 

True, but I was being mindful of Dave Chinners recent work on
preventing slab cache being dumped entirely. There still may be an
impact to metadata-intensive workloads although I did not spot any
problems myself.

> >This partially reverts the commit until it is proven that slabs are
> >really being shrunk unnecessarily but preserves the check to return
> >1 to avoid OOM if reclaim was aborted prematurely.
> >
> >[aarcange@redhat.com: This patch replaces a revert from Andrea]
> >Signed-off-by: Mel Gorman<mgorman@suse.de>
> 
> Reviewed-by: Rik van Riel<riel@redhat.com>
> 

Thanks.

-- 
Mel Gorman
SUSE Labs
