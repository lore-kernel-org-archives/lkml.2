Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754730Ab0HCE2s (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 00:28:48 -0400
Received: from mga01.intel.com ([192.55.52.88]:39451 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751074Ab0HCE2r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 00:28:47 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.55,307,1278313200"; 
   d="scan'208";a="592299792"
Date: Tue, 3 Aug 2010 12:28:35 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Minchan Kim <minchan.kim@gmail.com>
Cc: Chris Webb <chris@arachsys.com>, "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: Over-eager swapping
Message-ID: <20100803042835.GA17377@localhost>
References: <20100802124734.GI2486@arachsys.com>
 <AANLkTinnWQA-K6r_+Y+giEC9zs-MbY6GFs8dWadSq0kh@mail.gmail.com>
 <20100803033108.GA23117@arachsys.com>
 <AANLkTinjmZOOaq7FgwJOZ=UNGS8x8KtQWZg6nv7fqJMe@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTinjmZOOaq7FgwJOZ=UNGS8x8KtQWZg6nv7fqJMe@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 03, 2010 at 12:09:18PM +0800, Minchan Kim wrote:
> On Tue, Aug 3, 2010 at 12:31 PM, Chris Webb <chris@arachsys.com> wrote:
> > Minchan Kim <minchan.kim@gmail.com> writes:
> >
> >> Another possibility is _zone_reclaim_ in NUMA.
> >> Your working set has many anonymous page.
> >>
> >> The zone_reclaim set priority to ZONE_RECLAIM_PRIORITY.
> >> It can make reclaim mode to lumpy so it can page out anon pages.
> >>
> >> Could you show me /proc/sys/vm/[zone_reclaim_mode/min_unmapped_ratio] ?
> >
> > Sure, no problem. On the machine with the /proc/meminfo I showed earlier,
> > these are
> >
> >  # cat /proc/sys/vm/zone_reclaim_mode
> >  0
> >  # cat /proc/sys/vm/min_unmapped_ratio
> >  1
> 
> if zone_reclaim_mode is zero, it doesn't swap out anon_pages.

If there are lots of order-1 or higher allocations, anonymous pages
will be randomly evicted, regardless of their LRU ages. This is
probably another factor why the users claim. Are there easy ways to
confirm this other than patching the kernel?

Chris, what's in your /proc/slabinfo?

Thanks,
Fengguang
