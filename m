Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753251Ab0HZI1n (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Aug 2010 04:27:43 -0400
Received: from TYO202.gate.nec.co.jp ([202.32.8.206]:34486 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753104Ab0HZI1l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Aug 2010 04:27:41 -0400
Date: Thu, 26 Aug 2010 17:24:38 +0900
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Andi Kleen <andi@firstfloor.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Christoph Lameter <cl@linux-foundation.org>,
        Mel Gorman <mel@csn.ul.ie>, "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>,
        linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/8] hugetlb: add allocate function for hugepage migration
Message-ID: <20100826082438.GV21389@spritzera.linux.bs1.fc.nec.co.jp>
References: <1282694127-14609-1-git-send-email-n-horiguchi@ah.jp.nec.com>
 <1282694127-14609-3-git-send-email-n-horiguchi@ah.jp.nec.com>
 <20100825012941.GD7283@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-2022-jp
Content-Disposition: inline
In-Reply-To: <20100825012941.GD7283@localhost>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 25, 2010 at 09:29:41AM +0800, Wu Fengguang wrote:
> > +static struct page *alloc_buddy_huge_page_node(struct hstate *h, int nid)
> > +{
> > +	struct page *page = __alloc_huge_page_node(h, nid);
> >  	if (page) {
> > -		if (arch_prepare_hugepage(page)) {
> > -			__free_pages(page, huge_page_order(h));
> > +		set_compound_page_dtor(page, free_huge_page);
> > +		spin_lock(&hugetlb_lock);
> > +		h->nr_huge_pages++;
> > +		h->nr_huge_pages_node[nid]++;
> > +		spin_unlock(&hugetlb_lock);
> > +		put_page_testzero(page);
> > +	}
> > +	return page;
> > +}
> 
> One would expect the alloc_buddy_huge_page_node() to only differ with
> alloc_buddy_huge_page() in the alloc_pages/alloc_pages_exact_node
> calls. However you implement alloc_buddy_huge_page_node() in a quite
> different way. Can the two functions be unified at all?

Yes. I did it by adding argument @nid to alloc_buddy_huge_page().
Code gets cleaner and work without problems.

Thanks,
Naoya
