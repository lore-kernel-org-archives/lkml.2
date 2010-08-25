Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755268Ab0HYBaM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 21:30:12 -0400
Received: from mga11.intel.com ([192.55.52.93]:27561 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753172Ab0HYBaK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 21:30:10 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.56,265,1280732400"; 
   d="scan'208";a="599900112"
Date: Wed, 25 Aug 2010 09:29:41 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Andi Kleen <andi@firstfloor.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Christoph Lameter <cl@linux-foundation.org>,
        Mel Gorman <mel@csn.ul.ie>, "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>,
        linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/8] hugetlb: add allocate function for hugepage
 migration
Message-ID: <20100825012941.GD7283@localhost>
References: <1282694127-14609-1-git-send-email-n-horiguchi@ah.jp.nec.com>
 <1282694127-14609-3-git-send-email-n-horiguchi@ah.jp.nec.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1282694127-14609-3-git-send-email-n-horiguchi@ah.jp.nec.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +static struct page *alloc_buddy_huge_page_node(struct hstate *h, int nid)
> +{
> +	struct page *page = __alloc_huge_page_node(h, nid);
>  	if (page) {
> -		if (arch_prepare_hugepage(page)) {
> -			__free_pages(page, huge_page_order(h));
> +		set_compound_page_dtor(page, free_huge_page);
> +		spin_lock(&hugetlb_lock);
> +		h->nr_huge_pages++;
> +		h->nr_huge_pages_node[nid]++;
> +		spin_unlock(&hugetlb_lock);
> +		put_page_testzero(page);
> +	}
> +	return page;
> +}

One would expect the alloc_buddy_huge_page_node() to only differ with
alloc_buddy_huge_page() in the alloc_pages/alloc_pages_exact_node
calls. However you implement alloc_buddy_huge_page_node() in a quite
different way. Can the two functions be unified at all?

Thanks,
Fengguang
