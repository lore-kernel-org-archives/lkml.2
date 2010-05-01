Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752753Ab0EANvl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 May 2010 09:51:41 -0400
Received: from f0.cmpxchg.org ([85.214.51.133]:35770 "EHLO cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752672Ab0EANvk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 May 2010 09:51:40 -0400
Date: Sat, 1 May 2010 15:51:10 +0200
From: Johannes Weiner <hannes@cmpxchg.org>
To: Andrea Arcangeli <aarcange@redhat.com>
Cc: Mel Gorman <mel@csn.ul.ie>, Andrew Morton <akpm@linux-foundation.org>,
       Linux-MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
       Minchan Kim <minchan.kim@gmail.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Christoph Lameter <cl@linux.com>, Rik van Riel <riel@redhat.com>
Subject: Re: [PATCH 0/2] Fix migration races in rmap_walk() V3
Message-ID: <20100501135110.GP20640@cmpxchg.org>
References: <1272529930-29505-1-git-send-email-mel@csn.ul.ie> <20100430182853.GK22108@random.random>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100430182853.GK22108@random.random>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 30, 2010 at 08:28:53PM +0200, Andrea Arcangeli wrote:
> Subject: adapt mprotect to anon_vma chain semantics
> 
> From: Andrea Arcangeli <aarcange@redhat.com>
> 
> wait_split_huge_page interface changed.
> 
> Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
> ---
> 
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -929,7 +929,7 @@ int change_huge_pmd(struct vm_area_struc
>  	if (likely(pmd_trans_huge(*pmd))) {
>  		if (unlikely(pmd_trans_splitting(*pmd))) {
>  			spin_unlock(&mm->page_table_lock);
> -			wait_split_huge_page(vma->anon_vma, pmd);
> +			wait_split_huge_page(mm, pmd);

That makes mprotect-vma-arg obsolete, I guess.
