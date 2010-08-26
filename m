Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752643Ab0HZJoM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Aug 2010 05:44:12 -0400
Received: from gir.skynet.ie ([193.1.99.77]:37880 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751582Ab0HZJoK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Aug 2010 05:44:10 -0400
Date: Thu, 26 Aug 2010 10:43:56 +0100
From: Mel Gorman <mel@csn.ul.ie>
To: Minchan Kim <minchan.kim@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel List <linux-kernel@vger.kernel.org>, linux-mm@kvack.org,
        Wu Fengguang <fengguang.wu@intel.com>,
        Iram Shahzad <iram.shahzad@jp.fujitsu.com>
Subject: Re: [PATCH v2 1/2] compaction: handle active and inactive fairly
	in too_many_isolated
Message-ID: <20100826094356.GD20944@csn.ul.ie>
References: <1282663879-4130-1-git-send-email-minchan.kim@gmail.com> <20100826090305.GC20944@csn.ul.ie> <AANLkTikE-_=8GCu=LjLiyyO9W+soSKAC0bkXfYAnwMux@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <AANLkTikE-_=8GCu=LjLiyyO9W+soSKAC0bkXfYAnwMux@mail.gmail.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 26, 2010 at 06:39:49PM +0900, Minchan Kim wrote:
> On Thu, Aug 26, 2010 at 6:03 PM, Mel Gorman <mel@csn.ul.ie> wrote:
> > On Wed, Aug 25, 2010 at 12:31:18AM +0900, Minchan Kim wrote:
> >> Iram reported compaction's too_many_isolated loops forever.
> >> (http://www.spinics.net/lists/linux-mm/msg08123.html)
> >>
> >> The meminfo of situation happened was inactive anon is zero.
> >> That's because the system has no memory pressure until then.
> >> While all anon pages was in active lru, compaction could select
> >> active lru as well as inactive lru. That's different things
> >> with vmscan's isolated. So we has been two too_many_isolated.
> >>
> >> While compaction can isolated pages in both active and inactive,
> >> current implementation of too_many_isolated only considers inactive.
> >> It made Iram's problem.
> >>
> >> This patch handles active and inactive with fair.
> >> That's because we can't expect where from and how many compaction would
> >> isolated pages.
> >>
> >> This patch changes (nr_isolated > nr_inactive) with
> >> nr_isolated > (nr_active + nr_inactive) / 2.
> >>
> >> Cc: Iram Shahzad <iram.shahzad@jp.fujitsu.com>
> >> Acked-by: Mel Gorman <mel@csn.ul.ie>
> >> Acked-by: Wu Fengguang <fengguang.wu@intel.com>
> >> Signed-off-by: Minchan Kim <minchan.kim@gmail.com>
> >
> > Please send this patch on its own as it looks like it should be merged and
> > arguably is a stable candidate for 2.6.35. Alternatively, Andrew, can you pick
> > up just this patch? It seems unrelated to the second patch on COMPACTPAGEFAILED.
> 
> I thought it's not urgent and next patch would apply based on this
> patch without HUNK.

Well it fixes a known bug so I would consider it a little urgent. It's not
earth shattering or anything but why delay unnecessarily?

> If Andrew doesn't have a response, I will resend as a standalone.
> Thanks.
> 

Thanks.

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
