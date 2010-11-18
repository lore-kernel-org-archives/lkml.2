Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757517Ab0KRNTd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 08:19:33 -0500
Received: from gir.skynet.ie ([193.1.99.77]:53012 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756521Ab0KRNTc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 08:19:32 -0500
Date: Thu, 18 Nov 2010 13:19:17 +0000
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
Subject: Re: [PATCH 29 of 66] don't alloc harder for gfp nomemalloc even if
	nowait
Message-ID: <20101118131917.GS8135@csn.ul.ie>
References: <patchbomb.1288798055@v2.random> <ed6c78af29bc105fcee3.1288798084@v2.random>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <ed6c78af29bc105fcee3.1288798084@v2.random>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 03, 2010 at 04:28:04PM +0100, Andrea Arcangeli wrote:
> From: Andrea Arcangeli <aarcange@redhat.com>
> 
> Not worth throwing away the precious reserved free memory pool for allocations
> that can fail gracefully (either through mempool or because they're transhuge
> allocations later falling back to 4k allocations).
> 
> Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
> Acked-by: Rik van Riel <riel@redhat.com>

Acked-by: Mel Gorman <mel@csn.ul.ie>

> ---
> 
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -1941,7 +1941,12 @@ gfp_to_alloc_flags(gfp_t gfp_mask)
>  	alloc_flags |= (__force int) (gfp_mask & __GFP_HIGH);
>  
>  	if (!wait) {
> -		alloc_flags |= ALLOC_HARDER;
> +		/*
> +		 * Not worth trying to allocate harder for
> +		 * __GFP_NOMEMALLOC even if it can't schedule.
> +		 */
> +		if  (!(gfp_mask & __GFP_NOMEMALLOC))
> +			alloc_flags |= ALLOC_HARDER;
>  		/*
>  		 * Ignore cpuset if GFP_ATOMIC (!wait) rather than fail alloc.
>  		 * See also cpuset_zone_allowed() comment in kernel/cpuset.c.
> 

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
