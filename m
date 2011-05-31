Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756737Ab1EaFiL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 01:38:11 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:48415 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751064Ab1EaFiJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 01:38:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=iW/KAgI0Q2WE7MzuGyZ4yI7UIIDssCZwP1lqjuKhJukQLZddHiX74xB+R7uzI0FVGO
         N9qBZw471/U5RnpgvvLmS49JAkLMRTR1cS2eD0lmsiKp7UcksrU1p2sLZTTCWBOK84+r
         eVd8xWQtctOQ2SpMeFH+jG7/ky11zS5e/eIeo=
Date: Tue, 31 May 2011 14:38:02 +0900
From: Minchan Kim <minchan.kim@gmail.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Mel Gorman <mel@csn.ul.ie>, akpm@linux-foundation.org,
        Ury Stankevich <urykhy@gmail.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Andrea Arcangeli <aarcange@redhat.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, stable@kernel.org
Subject: Re: [PATCH] mm: compaction: Abort compaction if too many pages are
 isolated and caller is asynchronous
Message-ID: <20110531053802.GA1519@barrios-laptop>
References: <20110530131300.GQ5044@csn.ul.ie>
 <20110531134835.b7c9edc2.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110531134835.b7c9edc2.kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kame,

On Tue, May 31, 2011 at 01:48:35PM +0900, KAMEZAWA Hiroyuki wrote:
> On Mon, 30 May 2011 14:13:00 +0100
> Mel Gorman <mel@csn.ul.ie> wrote:
> 
> > Asynchronous compaction is used when promoting to huge pages. This is
> > all very nice but if there are a number of processes in compacting
> > memory, a large number of pages can be isolated. An "asynchronous"
> > process can stall for long periods of time as a result with a user
> > reporting that firefox can stall for 10s of seconds. This patch aborts
> > asynchronous compaction if too many pages are isolated as it's better to
> > fail a hugepage promotion than stall a process.
> > 
> > If accepted, this should also be considered for 2.6.39-stable. It should
> > also be considered for 2.6.38-stable but ideally [11bc82d6: mm:
> > compaction: Use async migration for __GFP_NO_KSWAPD and enforce no
> > writeback] would be applied to 2.6.38 before consideration.
> > 
> > Reported-and-Tested-by: Ury Stankevich <urykhy@gmail.com>
> > Signed-off-by: Mel Gorman <mgorman@suse.de>
> 
> 
> 
> Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> 
> BTW, I'm surprised to see both of vmscan.c and compaction.c has too_many_isolated()..
> in different logic ;)
> 
> BTW, compaction ignores UNEVICTABLE LRU ?

Good point.
Yes. now compaction doesn't work with unevictable LRU but I think we have no reason
to work well with unveictable pages. 
If we don't support unevictable lru, it would be a problem in lots of
mlocked pages workload.
It would be a good enhance point on compaction.

> 
> Thanks,
> -Kame
-- 
Kind regards
Minchan Kim
