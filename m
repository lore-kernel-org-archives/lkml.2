Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756768Ab1EaOhp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 10:37:45 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:39364 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754808Ab1EaOho (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 10:37:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=j094yLJ42JyXMmtRLjv8rbBvuXGRatD693gRVMb52RWZcTr1LgrtTMNHL6ALtGK9zv
         lZ4Jfg5Vm/epaiXP22mPkDAVtL9NSmWY71y7gy8vDC0gEmHYkNMCTk8RpThgCjHcnWE9
         kIxpwpH5mNuaNZZi0wpUJidO1C/pAH5/WHbzI=
Date: Tue, 31 May 2011 23:37:35 +0900
From: Minchan Kim <minchan.kim@gmail.com>
To: Andrea Arcangeli <aarcange@redhat.com>
Cc: Mel Gorman <mgorman@suse.de>, Mel Gorman <mel@csn.ul.ie>,
        akpm@linux-foundation.org, Ury Stankevich <urykhy@gmail.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org, stable@kernel.org
Subject: Re: [PATCH] mm: compaction: Abort compaction if too many pages are
 isolated and caller is asynchronous
Message-ID: <20110531143734.GB13418@barrios-laptop>
References: <20110530131300.GQ5044@csn.ul.ie>
 <20110530143109.GH19505@random.random>
 <20110530153748.GS5044@csn.ul.ie>
 <20110530165546.GC5118@suse.de>
 <20110530175334.GI19505@random.random>
 <20110531121620.GA3490@barrios-laptop>
 <20110531122437.GJ19505@random.random>
 <20110531133340.GB3490@barrios-laptop>
 <20110531141402.GK19505@random.random>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110531141402.GK19505@random.random>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 31, 2011 at 04:14:02PM +0200, Andrea Arcangeli wrote:
> On Tue, May 31, 2011 at 10:33:40PM +0900, Minchan Kim wrote:
> > I checked them before sending patch but I got failed to find strange things. :(
> 
> My review also doesn't show other bugs in migrate_pages callers like
> that one.
> 
> > Now I am checking the page's SwapBacked flag can be changed
> > between before and after of migrate_pages so accounting of NR_ISOLATED_XX can
> > make mistake. I am approaching the failure, too. Hmm.
> 
> When I checked that, I noticed the ClearPageSwapBacked in swapcache if
> radix insertion fails, but that happens before adding the page in the
> LRU so it shouldn't have a chance to be isolated.

True.

> 
> So far I only noticed an unsafe page_count in
> vmscan.c:isolate_lru_pages but that should at worst result in a
> invalid pointer dereference as random result from that page_count is
> not going to hurt and I think it's only a theoretical issue.


Yes. You find a new BUG.
It seems to be related to this problem but it should be solved although
it's very rare case.

-- 
Kind regards
Minchan Kim
