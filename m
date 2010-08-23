Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753278Ab0HWNkF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Aug 2010 09:40:05 -0400
Received: from gir.skynet.ie ([193.1.99.77]:50973 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753093Ab0HWNkC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Aug 2010 09:40:02 -0400
Date: Mon, 23 Aug 2010 14:39:48 +0100
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
Message-ID: <20100823133948.GR19797@csn.ul.ie>
References: <1282550442-15193-1-git-send-email-mel@csn.ul.ie> <alpine.DEB.2.00.1008230742300.4094@router.home> <20100823130127.GP19797@csn.ul.ie> <alpine.DEB.2.00.1008230835220.5750@router.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1008230835220.5750@router.home>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 23, 2010 at 08:38:25AM -0500, Christoph Lameter wrote:
> On Mon, 23 Aug 2010, Mel Gorman wrote:
> 
> > > The maximum time for which the livelock can exists is the vm stat
> > > interval. By default the counters are brought up to date at least once per
> > > second or if a certain delta was violated. Drifts are controlled by the
> > > delta configuration.
> > >
> >
> > While there is a maximum time (2 seconds I think) the drift can exist
> > in, a machine under enough pressure can make a mess of the watermarks
> > during that time. If it wasn't the case, these livelocks with 0 pages
> > free wouldn't be happening.
> 
> So because we go way beyond the watermarks we reach a state in which a
> livelock exists that does not go away when the counters are finally
> updated?
> 

That appears to be the case. The system has already gotten into a state
where there are 0 pages free. Just because the NR_FREE_PAGES counter
gets updated to reflect the accurate count of 0 does not mean the system
can recover from it.

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
