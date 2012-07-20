Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752830Ab2GTOQ4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2012 10:16:56 -0400
Received: from zene.cmpxchg.org ([85.214.230.12]:54434 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752473Ab2GTOQz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2012 10:16:55 -0400
Date: Fri, 20 Jul 2012 16:16:25 +0200
From: Johannes Weiner <hannes@cmpxchg.org>
To: Michal Hocko <mhocko@suse.cz>
Cc: Tim Chen <tim.c.chen@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Minchan Kim <minchan@kernel.org>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        "andi.kleen" <andi.kleen@intel.com>, linux-mm <linux-mm@kvack.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Cgroup: Fix memory accounting scalability in
 shrink_page_list
Message-ID: <20120720141625.GA1426@cmpxchg.org>
References: <1342740866.13492.50.camel@schen9-DESK>
 <20120720135329.GA12440@tiehlicka.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120720135329.GA12440@tiehlicka.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 20, 2012 at 03:53:29PM +0200, Michal Hocko wrote:
> On Thu 19-07-12 16:34:26, Tim Chen wrote:
> [...]
> > diff --git a/mm/vmscan.c b/mm/vmscan.c
> > index 33dc256..aac5672 100644
> > --- a/mm/vmscan.c
> > +++ b/mm/vmscan.c
> > @@ -779,6 +779,7 @@ static unsigned long shrink_page_list(struct list_head *page_list,
> >  
> >  	cond_resched();
> >  
> > +	mem_cgroup_uncharge_start();
> >  	while (!list_empty(page_list)) {
> >  		enum page_references references;
> >  		struct address_space *mapping;
> 
> Is this safe? We have a scheduling point few lines below. What prevents
> from task move while we are in the middle of the batch?

The batch is accounted in task_struct, so moving a batching task to
another CPU shouldn't be a problem.
