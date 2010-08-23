Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752792Ab0HWNBn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Aug 2010 09:01:43 -0400
Received: from gir.skynet.ie ([193.1.99.77]:34647 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751805Ab0HWNBl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Aug 2010 09:01:41 -0400
Date: Mon, 23 Aug 2010 14:01:27 +0100
From: Mel Gorman <mel@csn.ul.ie>
To: Christoph Lameter <cl@linux.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel List <linux-kernel@vger.kernel.org>, linux-mm@kvack.org,
        Rik van Riel <riel@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Minchan Kim <minchan.kim@gmail.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: [PATCH 0/3] Reduce watermark-related problems with the per-cpu
	allocator V2
Message-ID: <20100823130127.GP19797@csn.ul.ie>
References: <1282550442-15193-1-git-send-email-mel@csn.ul.ie> <alpine.DEB.2.00.1008230742300.4094@router.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1008230742300.4094@router.home>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 23, 2010 at 07:45:25AM -0500, Christoph Lameter wrote:
> On Mon, 23 Aug 2010, Mel Gorman wrote:
> 
> > Internal IBM test teams beta testing distribution kernels have reported
> > problems on machines with a large number of CPUs whereby page allocator
> > failure messages show huge differences between the nr_free_pages vmstat
> > counter and what is available on the buddy lists. In an extreme example,
> > nr_free_pages was above the min watermark but zero pages were on the buddy
> > lists allowing the system to potentially livelock unable to make forward
> > progress unless an allocation succeeds. There is no reason why the problems
> > would not affect mainline so the following series mitigates the problems
> > in the page allocator related to to per-cpu counter drift and lists.
> 
> The maximum time for which the livelock can exists is the vm stat
> interval. By default the counters are brought up to date at least once per
> second or if a certain delta was violated. Drifts are controlled by the
> delta configuration.
> 

While there is a maximum time (2 seconds I think) the drift can exist
in, a machine under enough pressure can make a mess of the watermarks
during that time. If it wasn't the case, these livelocks with 0 pages
free wouldn't be happening.

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
