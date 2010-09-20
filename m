Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756087Ab0ITLS6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Sep 2010 07:18:58 -0400
Received: from gir.skynet.ie ([193.1.99.77]:56656 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754423Ab0ITLS5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Sep 2010 07:18:57 -0400
Date: Mon, 20 Sep 2010 12:18:44 +0100
From: Mel Gorman <mel@csn.ul.ie>
To: Andi Kleen <andi@firstfloor.org>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Christoph Lameter <cl@linux-foundation.org>,
        Wu Fengguang <fengguang.wu@intel.com>,
        "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>,
        linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 03/10] hugetlb: redefine hugepage copy functions
Message-ID: <20100920111844.GL1998@csn.ul.ie>
References: <1283908781-13810-1-git-send-email-n-horiguchi@ah.jp.nec.com> <1283908781-13810-4-git-send-email-n-horiguchi@ah.jp.nec.com> <20100920110323.GI1998@csn.ul.ie> <215a2d3717d0d55026688fb59ff7bb79.squirrel@www.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <215a2d3717d0d55026688fb59ff7bb79.squirrel@www.firstfloor.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 20, 2010 at 01:15:44PM +0200, Andi Kleen wrote:
> 
> >> +static void copy_gigantic_page(struct page *dst, struct page *src)
> >> +{
> >> +	int i;
> >> +	struct hstate *h = page_hstate(src);
> >> +	struct page *dst_base = dst;
> >> +	struct page *src_base = src;
> >> +
> >> +	for (i = 0; i < pages_per_huge_page(h); ) {
> >> +		cond_resched();
> >
> > Should this function not have a might_sleep() check too?
> 
> cond_resched() implies might_sleep I believe. I think
> that answers the earlier question too becuse that function
> calls this.
> 

You're right, cond_resched() calls might_sleep so the additional check
is redundant.

> 	/*
> >
> > Other than the removal of the might_sleep() check, this looks ok too.
> 
> Can I assume an Ack?
> 

Yes.

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
