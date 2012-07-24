Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755798Ab2GXXeA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2012 19:34:00 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:57386 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753694Ab2GXXeA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2012 19:34:00 -0400
X-AuditID: 9c93016f-b7b08ae00000790d-90-500f30e57e97
Date: Wed, 25 Jul 2012 08:34:22 +0900
From: Minchan Kim <minchan@kernel.org>
To: Rik van Riel <riel@redhat.com>
Cc: linux-mm@kvack.org, Andrea Arcangeli <aarcange@redhat.com>,
        lkml <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>
Subject: Re: [PATCH -mm] remove __GFP_NO_KSWAPD
Message-ID: <20120724233422.GB14411@bbox>
References: <20120724111222.2c5e6b30@annuminas.surriel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120724111222.2c5e6b30@annuminas.surriel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rik,

On Tue, Jul 24, 2012 at 11:12:22AM -0400, Rik van Riel wrote:
> When transparent huge pages were introduced, memory compaction and
> swap storms were an issue, and the kernel had to be careful to not
> make THP allocations cause pageout or compaction.
> 
> Now that we have working compaction deferral, kswapd is smart enough
> to invoke compaction and the quadratic behaviour around isolate_free_pages
> has been fixed, it should be safe to remove __GFP_NO_KSWAPD.

Could you point out specific patches you mentiond which makes kswapd/compaction
smart? It will make description very clear.

> 
> Signed-off-by: Rik van Riel <riel@redhat.com>

I support it because I had a concern about that flags which is likely to be
used by other subsystems without careful thinking when the flag was introduced.
It's proved by mtd_kmalloc_up_to which was merged with sneaking without catching
from mm guys's eyes. When I read comment of that function, it seems to be proper
usage but I don't like it because it requries users of mm to know mm internal
like kswapd. So it should be avoided if possible.

Plus, it means you need to fix it with show_gfp_flags. :)


> ---
> This has been running fine on my system for a while, but my system
> only has 12GB and moderate memory pressure. I propose we keep this
> in -mm and -next for a while, and merge it for 3.7 if nobody complains.

Yes. it should be very careful.
I guess Mel and Andrea would have opinions and benchmark.

-- 
Kind regards,
Minchan Kim
