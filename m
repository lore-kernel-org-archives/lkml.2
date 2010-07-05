Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756615Ab0GEJ20 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jul 2010 05:28:26 -0400
Received: from one.firstfloor.org ([213.235.205.2]:35025 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751009Ab0GEJ2W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jul 2010 05:28:22 -0400
Date: Mon, 5 Jul 2010 11:28:16 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>,
       Wu Fengguang <fengguang.wu@intel.com>,
       "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>,
       linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/7] hugetlb: add allocate function for hugepage
 migration
Message-ID: <20100705092816.GA8510@basil.fritz.box>
References: <1278049646-29769-1-git-send-email-n-horiguchi@ah.jp.nec.com>
 <1278049646-29769-4-git-send-email-n-horiguchi@ah.jp.nec.com>
 <20100702090854.GD12221@basil.fritz.box>
 <20100705084629.GC29648@spritzera.linux.bs1.fc.nec.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100705084629.GC29648@spritzera.linux.bs1.fc.nec.co.jp>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 05, 2010 at 05:46:29PM +0900, Naoya Horiguchi wrote:
> On Fri, Jul 02, 2010 at 11:08:54AM +0200, Andi Kleen wrote:
> > On Fri, Jul 02, 2010 at 02:47:22PM +0900, Naoya Horiguchi wrote:
> > > We can't use existing hugepage allocation functions to allocate hugepage
> > > for page migration, because page migration can happen asynchronously with
> > > the running processes and page migration users should call the allocation
> > > function with physical addresses (not virtual addresses) as arguments.
> > 
> > I looked through this patch and didn't see anything bad. Some more
> > eyes familiar with hugepages would be good though.
> 
> Yes.
> 
> > Since there are now so many different allocation functions some
> > comments on when they should be used may be useful too
> 
> OK. How about this?
> 
> +/*
> + * This allocation function is useful in the context where vma is irrelevant.
> + * E.g. soft-offlining uses this function because it only cares physical
> + * address of error page.
> + */

Looks good thanks.

> +struct page *alloc_huge_page_node(struct hstate *h, int nid)
> +{
> 
> BTW, I don't like this function name very much.
> Since the most significant difference of this function to alloc_huge_page()
> is lack of vma argument, so I'm going to change the name to
> alloc_huge_page_no_vma_node() in the next version if it is no problem.
> 
> Or, since the postfix like "_no_vma" is verbose, I think it might be
> a good idea to rename present alloc_huge_page() to alloc_huge_page_vma().
> Is this worthwhile?

Yes, in a separate patch

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
