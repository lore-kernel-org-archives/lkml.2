Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755296Ab1AaJDt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 04:03:49 -0500
Received: from e28smtp01.in.ibm.com ([122.248.162.1]:45172 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755204Ab1AaJDq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Jan 2011 04:03:46 -0500
Date: Mon, 31 Jan 2011 13:11:42 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>
Subject: Re: [BUGFIX][PATCH 3/4] mecg: fix oom flag at THP charge
Message-ID: <20110131074142.GG5054@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <20110128122229.6a4c74a2.kamezawa.hiroyu@jp.fujitsu.com>
 <20110128122729.1f1c613e.kamezawa.hiroyu@jp.fujitsu.com>
 <20110128080213.GC2213@cmpxchg.org>
 <20110128172146.940751a5.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20110128172146.940751a5.kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> [2011-01-28 17:21:46]:

> On Fri, 28 Jan 2011 09:02:13 +0100
> Johannes Weiner <hannes@cmpxchg.org> wrote:
> 
> > On Fri, Jan 28, 2011 at 12:27:29PM +0900, KAMEZAWA Hiroyuki wrote:
> > > 
> > > Thanks to Johanns and Daisuke for suggestion.
> > > =
> > > Hugepage allocation shouldn't trigger oom.
> > > Allocation failure is not fatal.
> > > 
> > > Orignal-patch-by: Johannes Weiner <hannes@cmpxchg.org>
> > > Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> > > ---
> > >  mm/memcontrol.c |    4 +++-
> > >  1 file changed, 3 insertions(+), 1 deletion(-)
> > > 
> > > Index: mmotm-0125/mm/memcontrol.c
> > > ===================================================================
> > > --- mmotm-0125.orig/mm/memcontrol.c
> > > +++ mmotm-0125/mm/memcontrol.c
> > > @@ -2369,11 +2369,14 @@ static int mem_cgroup_charge_common(stru
> > >  	struct page_cgroup *pc;
> > >  	int ret;
> > >  	int page_size = PAGE_SIZE;
> > > +	bool oom;
> > >  
> > >  	if (PageTransHuge(page)) {
> > >  		page_size <<= compound_order(page);
> > >  		VM_BUG_ON(!PageTransHuge(page));
> > > -	}
> > > +		oom = false;
> > > +	} else
> > > +		oom = true;
> > 
> > That needs a comment.  You can take the one from my patch if you like.
> > 
> 
> How about this ?
> ==
> Hugepage allocation shouldn't trigger oom.
> Allocation failure is not fatal.
>

 
Acked-by: Balbir Singh <balbir@linux.vnet.ibm.com>
 
-- 
	Three Cheers,
	Balbir
