Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759508Ab0GVPew (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jul 2010 11:34:52 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:40926 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754762Ab0GVPeu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jul 2010 11:34:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Vy841abBgFhZzCse4DuIISlHq0gnC2VafrSWO7q8Kfm1oG898Y/sPuXz7lgSg9vxVZ
         rG0YuZQ1d5MoOv+uKzU4cgq9c58oGrMAQ8wkeEZa7EpCB7BzNPY4DWTuikAA/JDsyYuV
         0YDuMJy5+E7jhmFZmETx7389C0wnV6Bhu2mfI=
Date: Fri, 23 Jul 2010 00:34:40 +0900
From: Minchan Kim <minchan.kim@gmail.com>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Mel Gorman <mel@csn.ul.ie>, Christoph Hellwig <hch@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Dave Chinner <david@fromorbit.com>,
        Chris Mason <chris.mason@oracle.com>, Nick Piggin <npiggin@suse.de>,
        Rik van Riel <riel@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>
Subject: Re: [PATCH 7/8] writeback: sync old inodes first in background
 writeback
Message-ID: <20100722153440.GA1898@barrios-desktop>
References: <1279545090-19169-1-git-send-email-mel@csn.ul.ie>
 <1279545090-19169-8-git-send-email-mel@csn.ul.ie>
 <20100719142145.GD12510@infradead.org>
 <20100719144046.GR13117@csn.ul.ie>
 <20100722085210.GA26714@localhost>
 <20100722092155.GA28425@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100722092155.GA28425@localhost>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Wu. 
Thanks for Cced me. 

AFAIR, we discussed this by private mail and didn't conclude yet. 
Let's start from beginning. 

On Thu, Jul 22, 2010 at 05:21:55PM +0800, Wu Fengguang wrote:
> > I guess this new patch is more problem oriented and acceptable:
> > 
> > --- linux-next.orig/mm/vmscan.c	2010-07-22 16:36:58.000000000 +0800
> > +++ linux-next/mm/vmscan.c	2010-07-22 16:39:57.000000000 +0800
> > @@ -1217,7 +1217,8 @@ static unsigned long shrink_inactive_lis
> >  			count_vm_events(PGDEACTIVATE, nr_active);
> >  
> >  			nr_freed += shrink_page_list(&page_list, sc,
> > -							PAGEOUT_IO_SYNC);
> > +					priority < DEF_PRIORITY / 3 ?
> > +					PAGEOUT_IO_SYNC : PAGEOUT_IO_ASYNC);
> >  		}
> >  
> >  		nr_reclaimed += nr_freed;
> 
> This one looks better:
> ---
> vmscan: raise the bar to PAGEOUT_IO_SYNC stalls
> 
> Fix "system goes totally unresponsive with many dirty/writeback pages"
> problem:
> 
> 	http://lkml.org/lkml/2010/4/4/86
> 
> The root cause is, wait_on_page_writeback() is called too early in the
> direct reclaim path, which blocks many random/unrelated processes when
> some slow (USB stick) writeback is on the way.
> 
> A simple dd can easily create a big range of dirty pages in the LRU
> list. Therefore priority can easily go below (DEF_PRIORITY - 2) in a
> typical desktop, which triggers the lumpy reclaim mode and hence
> wait_on_page_writeback().

I see oom message. order is zero. 
How is lumpy reclaim work?
For working lumpy reclaim, we have to meet priority < 10 and sc->order > 0.

Please, clarify the problem.

> 
> In Andreas' case, 512MB/1024 = 512KB, this is way too low comparing to
> the 22MB writeback and 190MB dirty pages. There can easily be a

What's 22MB and 190M?
It would be better to explain more detail. 
I think the description has to be clear as summary of the problem 
without the above link. 

Thanks for taking out this problem, again. :)
-- 
Kind regards,
Minchan Kim
