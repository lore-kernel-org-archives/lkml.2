Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759604Ab0KRQR5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 11:17:57 -0500
Received: from gir.skynet.ie ([193.1.99.77]:39619 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754722Ab0KRQRz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 11:17:55 -0500
Date: Thu, 18 Nov 2010 16:17:41 +0000
From: Mel Gorman <mel@csn.ul.ie>
To: Andrea Arcangeli <aarcange@redhat.com>
Cc: linux-mm@kvack.org, Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Marcelo Tosatti <mtosatti@redhat.com>,
        Adam Litke <agl@us.ibm.com>, Avi Kivity <avi@redhat.com>,
        Hugh Dickins <hugh.dickins@tiscali.co.uk>,
        Rik van Riel <riel@redhat.com>, Dave Hansen <dave@linux.vnet.ibm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Ingo Molnar <mingo@elte.hu>, Mike Travis <travis@sgi.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Christoph Lameter <cl@linux-foundation.org>,
        Chris Wright <chrisw@sous-sol.org>, bpicco@redhat.com,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        Chris Mason <chris.mason@oracle.com>, Borislav Petkov <bp@alien8.de>
Subject: Re: [PATCH 52 of 66] enable direct defrag
Message-ID: <20101118161740.GC8135@csn.ul.ie>
References: <patchbomb.1288798055@v2.random> <db936dd7c1e500045f51.1288798107@v2.random>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <db936dd7c1e500045f51.1288798107@v2.random>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 03, 2010 at 04:28:27PM +0100, Andrea Arcangeli wrote:
> From: Andrea Arcangeli <aarcange@redhat.com>
> 
> With memory compaction in, and lumpy-reclaim removed, it seems safe enough to
> defrag memory during the (synchronous) transparent hugepage page faults
> (TRANSPARENT_HUGEPAGE_DEFRAG_FLAG) and not only during khugepaged (async)
> hugepage allocations that was already enabled even before memory compaction was
> in (TRANSPARENT_HUGEPAGE_DEFRAG_KHUGEPAGED_FLAG).
> 

While I'm hoping that my series on using compaction will be used instead
of outright deletion of lumpy reclaim, this patch would still make
sense.

Acked-by: Mel Gorman <mel@csn.ul.ie>

> Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
> ---
> 
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -28,6 +28,7 @@
>   */
>  unsigned long transparent_hugepage_flags __read_mostly =
>  	(1<<TRANSPARENT_HUGEPAGE_FLAG)|
> +	(1<<TRANSPARENT_HUGEPAGE_DEFRAG_FLAG)|
>  	(1<<TRANSPARENT_HUGEPAGE_DEFRAG_KHUGEPAGED_FLAG);
>  
>  /* default scan 8*512 pte (or vmas) every 30 second */
> 

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
