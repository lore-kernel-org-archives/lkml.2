Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751190Ab0HSFNt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Aug 2010 01:13:49 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:48257 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750967Ab0HSFNr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Aug 2010 01:13:47 -0400
Date: Thu, 19 Aug 2010 10:43:39 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Minchan Kim <minchan.kim@gmail.com>, Chris Webb <chris@arachsys.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: Over-eager swapping
Message-ID: <20100819051339.GH28417@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <20100802124734.GI2486@arachsys.com>
 <AANLkTinnWQA-K6r_+Y+giEC9zs-MbY6GFs8dWadSq0kh@mail.gmail.com>
 <20100803033108.GA23117@arachsys.com>
 <AANLkTinjmZOOaq7FgwJOZ=UNGS8x8KtQWZg6nv7fqJMe@mail.gmail.com>
 <20100803042835.GA17377@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20100803042835.GA17377@localhost>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Wu Fengguang <fengguang.wu@intel.com> [2010-08-03 12:28:35]:

> On Tue, Aug 03, 2010 at 12:09:18PM +0800, Minchan Kim wrote:
> > On Tue, Aug 3, 2010 at 12:31 PM, Chris Webb <chris@arachsys.com> wrote:
> > > Minchan Kim <minchan.kim@gmail.com> writes:
> > >
> > >> Another possibility is _zone_reclaim_ in NUMA.
> > >> Your working set has many anonymous page.
> > >>
> > >> The zone_reclaim set priority to ZONE_RECLAIM_PRIORITY.
> > >> It can make reclaim mode to lumpy so it can page out anon pages.
> > >>
> > >> Could you show me /proc/sys/vm/[zone_reclaim_mode/min_unmapped_ratio] ?
> > >
> > > Sure, no problem. On the machine with the /proc/meminfo I showed earlier,
> > > these are
> > >
> > >  # cat /proc/sys/vm/zone_reclaim_mode
> > >  0
> > >  # cat /proc/sys/vm/min_unmapped_ratio
> > >  1
> > 
> > if zone_reclaim_mode is zero, it doesn't swap out anon_pages.
> 
> If there are lots of order-1 or higher allocations, anonymous pages
> will be randomly evicted, regardless of their LRU ages. This is
> probably another factor why the users claim. Are there easy ways to
> confirm this other than patching the kernel?
> 
> Chris, what's in your /proc/slabinfo?
>

I don't know if Chris saw the link I pointed to earlier, but one of
the reclaim challenges with virtual machines is that cached memory
in the guest (in fact all memory) shows up as anonymous on the host.
If the guests are doing a lot of caching and the guest reclaim sees
no reason to evict the cache, the host will see pressure.

That is one of the reasons I wanted to see meminfo inside the guest if
possible. Setting swappiness to 0 inside the guest is one way of
avoiding double caching that might take place, but I've not found it
to be very effective. 

Do we have reason to believe the problem can be solved entirely in the
host?

-- 
	Three Cheers,
	Balbir
