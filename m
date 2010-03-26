Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753954Ab0CZNtt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Mar 2010 09:49:49 -0400
Received: from gir.skynet.ie ([193.1.99.77]:53691 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752955Ab0CZNts (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Mar 2010 09:49:48 -0400
Date: Fri, 26 Mar 2010 13:49:30 +0000
From: Mel Gorman <mel@csn.ul.ie>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Minchan Kim <minchan.kim@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Andrea Arcangeli <aarcange@redhat.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Adam Litke <agl@us.ibm.com>, Avi Kivity <avi@redhat.com>,
       David Rientjes <rientjes@google.com>, Rik van Riel <riel@redhat.com>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 02/11] mm,migration: Do not try to migrate unmapped
	anonymous pages
Message-ID: <20100326134930.GA2024@csn.ul.ie>
References: <20100325191229.8e3d2ba1.kamezawa.hiroyu@jp.fujitsu.com> <20100325133936.GR2024@csn.ul.ie> <20100326120429.6C98.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20100326120429.6C98.A69D9226@jp.fujitsu.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 26, 2010 at 12:07:02PM +0900, KOSAKI Motohiro wrote:
> very small nit
> 
> > There were minor changes in how the rcu_read_lock is taken and released
> > based on other comments. With your suggestion, the block now looks like;
> > 
> >         if (PageAnon(page)) {
> >                 rcu_read_lock();
> >                 rcu_locked = 1;
> > 
> >                 /*
> >                  * If the page has no mappings any more, just bail. An
> >                  * unmapped anon page is likely to be freed soon but
> >                  * worse,
> >                  * it's possible its anon_vma disappeared between when
> >                  * the page was isolated and when we reached here while
> >                  * the RCU lock was not held
> >                  */
> >                 if (!page_mapcount(page) && !PageSwapCache(page))
> 
>                         page_mapped?
> 

Will be fixed in V6.

Thanks

> >                         goto rcu_unlock;
> > 
> >                 anon_vma = page_anon_vma(page);
> >                 atomic_inc(&anon_vma->external_refcount);
> >         }
> 
> 
> 

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
