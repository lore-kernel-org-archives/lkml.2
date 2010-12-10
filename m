Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753138Ab0LJKnN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Dec 2010 05:43:13 -0500
Received: from gir.skynet.ie ([193.1.99.77]:49188 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751563Ab0LJKnM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Dec 2010 05:43:12 -0500
Date: Fri, 10 Dec 2010 10:42:54 +0000
From: Mel Gorman <mel@csn.ul.ie>
To: Minchan Kim <minchan.kim@gmail.com>
Cc: Simon Kirby <sim@hostway.ca>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Shaohua Li <shaohua.li@intel.com>,
        Dave Hansen <dave@linux.vnet.ibm.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-mm <linux-mm@kvack.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/6] mm: kswapd: Reset kswapd_max_order and
	classzone_idx after reading
Message-ID: <20101210104254.GL20133@csn.ul.ie>
References: <1291893500-12342-1-git-send-email-mel@csn.ul.ie> <1291893500-12342-5-git-send-email-mel@csn.ul.ie> <20101209155925.GD1740@barrios-desktop> <AANLkTimKVZjfVtZ_Rz0p0xKbE76Uoa1rDrYmN9EC4wLU@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <AANLkTimKVZjfVtZ_Rz0p0xKbE76Uoa1rDrYmN9EC4wLU@mail.gmail.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 10, 2010 at 01:03:01AM +0900, Minchan Kim wrote:
> On Fri, Dec 10, 2010 at 12:59 AM, Minchan Kim <minchan.kim@gmail.com> wrote:
> > On Thu, Dec 09, 2010 at 11:18:18AM +0000, Mel Gorman wrote:
> >> When kswapd wakes up, it reads its order and classzone from pgdat and
> >> calls balance_pgdat. While its awake, it potentially reclaimes at a high
> >> order and a low classzone index. This might have been a once-off that
> >> was not required by subsequent callers. However, because the pgdat
> >> values were not reset, they remain artifically high while
> >> balance_pgdat() is running and potentially kswapd enters a second
> >> unnecessary reclaim cycle. Reset the pgdat order and classzone index
> >> after reading.
> >>
> >> Signed-off-by: Mel Gorman <mel@csn.ul.ie>
> > Reviewed-by: Minchan Kim <minchan.kim@gmail.com>
> 
> Nitpick.
> Shouldn't this patch be merged with 1/6?
> 

I don't think so as it's a standalone fix. For example, if this was
merged on its own, the "order" should still be reset after reading.

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
