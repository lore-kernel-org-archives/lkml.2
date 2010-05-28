Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932738Ab0E1Osq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 May 2010 10:48:46 -0400
Received: from gir.skynet.ie ([193.1.99.77]:46605 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932642Ab0E1Osn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 May 2010 10:48:43 -0400
Date: Fri, 28 May 2010 15:48:24 +0100
From: Mel Gorman <mel@csn.ul.ie>
To: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Wu Fengguang <fengguang.wu@intel.com>,
       Andrea Arcangeli <aarcange@redhat.com>,
       Larry Woodman <lwoodman@redhat.com>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>
Subject: Re: [PATCH 2/8] hugetlb, rmap: add reverse mapping for hugepage
Message-ID: <20100528144824.GD9774@csn.ul.ie>
References: <1275006562-18946-1-git-send-email-n-horiguchi@ah.jp.nec.com> <1275006562-18946-3-git-send-email-n-horiguchi@ah.jp.nec.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <1275006562-18946-3-git-send-email-n-horiguchi@ah.jp.nec.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 28, 2010 at 09:29:16AM +0900, Naoya Horiguchi wrote:
> This patch adds reverse mapping feature for hugepage by introducing
> mapcount for shared/private-mapped hugepage and anon_vma for
> private-mapped hugepage.
> 
> While hugepage is not currently swappable, reverse mapping can be useful
> for memory error handler.
> 
> Without this patch, memory error handler cannot identify processes
> using the bad hugepage nor unmap it from them. That is:
> - for shared hugepage:
>   we can collect processes using a hugepage through pagecache,
>   but can not unmap the hugepage because of the lack of mapcount.
> - for privately mapped hugepage:
>   we can neither collect processes nor unmap the hugepage.
> This patch solves these problems.
> 
> This patch include the bug fix given by commit 23be7468e8, so reverts it.
> 
> Dependency:
>   "hugetlb: move definition of is_vm_hugetlb_page() to hugepage_inline.h"
> 
> ChangeLog since May 24.
> - create hugetlb_inline.h and move is_vm_hugetlb_index() in it.
> - move functions setting up anon_vma for hugepage into mm/rmap.c.
> 
> ChangeLog since May 13.
> - rebased to 2.6.34
> - fix logic error (in case that private mapping and shared mapping coexist)
> - move is_vm_hugetlb_page() into include/linux/mm.h to use this function
>   from linear_page_index()
> - define and use linear_hugepage_index() instead of compound_order()
> - use page_move_anon_rmap() in hugetlb_cow()
> - copy exclusive switch of __set_page_anon_rmap() into hugepage counterpart.
> - revert commit 24be7468 completely
> 
> Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
> Cc: Andi Kleen <andi@firstfloor.org>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Wu Fengguang <fengguang.wu@intel.com>
> Cc: Mel Gorman <mel@csn.ul.ie>
> Cc: Andrea Arcangeli <aarcange@redhat.com>
> Cc: Larry Woodman <lwoodman@redhat.com>
> Cc: Lee Schermerhorn <Lee.Schermerhorn@hp.com>

Ok, I could find no other problems with the hugetlb side of things in the
first two patches. I haven't looked at the hwpoison parts but I'm assuming
Andi has looked at those already. Thanks

Acked-by: Mel Gorman <mel@csn.ul.ie>

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
