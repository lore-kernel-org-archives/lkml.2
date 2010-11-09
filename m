Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755130Ab0KIDDu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Nov 2010 22:03:50 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:52597 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753843Ab0KIDDt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Nov 2010 22:03:49 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Andrea Arcangeli <aarcange@redhat.com>
Subject: Re: [PATCH 08 of 66] fix bad_page to show the real reason the page is bad
Cc: kosaki.motohiro@jp.fujitsu.com, linux-mm@kvack.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Marcelo Tosatti <mtosatti@redhat.com>,
        Adam Litke <agl@us.ibm.com>, Avi Kivity <avi@redhat.com>,
        Hugh Dickins <hugh.dickins@tiscali.co.uk>,
        Rik van Riel <riel@redhat.com>, Mel Gorman <mel@csn.ul.ie>,
        Dave Hansen <dave@linux.vnet.ibm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Ingo Molnar <mingo@elte.hu>, Mike Travis <travis@sgi.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Christoph Lameter <cl@linux-foundation.org>,
        Chris Wright <chrisw@sous-sol.org>, bpicco@redhat.com,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        Chris Mason <chris.mason@oracle.com>, Borislav Petkov <bp@alien8.de>
In-Reply-To: <412c4bbbe7738978ce73.1288798063@v2.random>
References: <patchbomb.1288798055@v2.random> <412c4bbbe7738978ce73.1288798063@v2.random>
Message-Id: <20101109120400.BC45.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Tue,  9 Nov 2010 12:03:43 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Andrea Arcangeli <aarcange@redhat.com>
> 
> page_count shows the count of the head page, but the actual check is done on
> the tail page, so show what is really being checked.
> 
> Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
> Acked-by: Rik van Riel <riel@redhat.com>
> Acked-by: Mel Gorman <mel@csn.ul.ie>
> ---
> 
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -5564,7 +5564,7 @@ void dump_page(struct page *page)
>  {
>  	printk(KERN_ALERT
>  	       "page:%p count:%d mapcount:%d mapping:%p index:%#lx\n",
> -		page, page_count(page), page_mapcount(page),
> +		page, atomic_read(&page->_count), page_mapcount(page),
>  		page->mapping, page->index);
>  	dump_page_flags(page->flags);
>  }

Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>




