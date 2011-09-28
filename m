Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752015Ab1I1AEf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Sep 2011 20:04:35 -0400
Received: from ipmail04.adl6.internode.on.net ([150.101.137.141]:36186 "EHLO
	ipmail04.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751207Ab1I1AEe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Sep 2011 20:04:34 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Av0EAE1igk55LEyD/2dsb2JhbABBqAF5gVMBAQU6HA8UEAgDGC4UJQMhE8EqDoYdYAScKYhv
Date: Wed, 28 Sep 2011 10:04:29 +1000
From: Dave Chinner <david@fromorbit.com>
To: "kautuk.c @samsung.com" <consul.kautuk@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mgorman@suse.de>,
        Minchan Kim <minchan.kim@gmail.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Rik van Riel <riel@redhat.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: Why isn't shrink_slab more zone oriented ?
Message-ID: <20110928000429.GD3159@dastard>
References: <CAFPAmTRHFOT+tc=J-=jTBpvi8ksnp6H32UsEwptrrv=hagjUsA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFPAmTRHFOT+tc=J-=jTBpvi8ksnp6H32UsEwptrrv=hagjUsA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 26, 2011 at 05:21:12PM +0530, kautuk.c @samsung.com wrote:
> Hi,
> 
> I was going through the do_try_to_free_pages(), balance_pgdat(),
> __zone_reclaim()
> functions and I see that shrink_zone and shrink_slab are called for each zone.
> 
> But, shrink_slab() doesn't seem to bother about the zone from where it
> is freeing
> memory.

Work is in progress to do this.

http://lwn.net/Articles/456071/

Dirty slab objects are currently not tracked in a manner that makes
per-zone reclaim efficient to do, os that needs to be corrected
first.  Once we have generic per-zone LRU infrastructure, then we
can easily push zone reclaim hints down into the shrinkers for them
to scan the appropriate LRU....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
