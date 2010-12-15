Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751828Ab0LOFad (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Dec 2010 00:30:33 -0500
Received: from mx1.redhat.com ([209.132.183.28]:17492 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750715Ab0LOFac (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Dec 2010 00:30:32 -0500
Date: Wed, 15 Dec 2010 06:29:10 +0100
From: Andrea Arcangeli <aarcange@redhat.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Mel Gorman <mel@csn.ul.ie>, linux-mm@kvack.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Marcelo Tosatti <mtosatti@redhat.com>,
        Adam Litke <agl@us.ibm.com>, Avi Kivity <avi@redhat.com>,
        Hugh Dickins <hugh.dickins@tiscali.co.uk>,
        Rik van Riel <riel@redhat.com>, Dave Hansen <dave@linux.vnet.ibm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Ingo Molnar <mingo@elte.hu>, Mike Travis <travis@sgi.com>,
        Christoph Lameter <cl@linux-foundation.org>,
        Chris Wright <chrisw@sous-sol.org>, bpicco@redhat.com,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        Chris Mason <chris.mason@oracle.com>, Borislav Petkov <bp@alien8.de>
Subject: Re: [PATCH 36 of 66] memcg compound
Message-ID: <20101215052910.GR5638@random.random>
References: <patchbomb.1288798055@v2.random>
 <495ffee2d60adab4d18b.1288798091@v2.random>
 <20101118152628.GY8135@csn.ul.ie>
 <20101119101041.ffe00712.kamezawa.hiroyu@jp.fujitsu.com>
 <20101214173817.GH5638@random.random>
 <20101215091209.8c757ad1.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101215091209.8c757ad1.kamezawa.hiroyu@jp.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Wed, Dec 15, 2010 at 09:12:09AM +0900, KAMEZAWA Hiroyuki wrote:
> Thank you. Hmm,..seems not very simple :( I'm sorry.
> Please do as you want.

I did the below change, let me know if there's any problem with it.

What's left is mem_cgroup_move_parent...

> > diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> > --- a/mm/memcontrol.c
> > +++ b/mm/memcontrol.c
> > @@ -2503,6 +2503,9 @@ __do_uncharge(struct mem_cgroup *mem, co
> >  	if (!batch->do_batch || test_thread_flag(TIF_MEMDIE))
> >  		goto direct_uncharge;
> >  
> > +	if (page_size != PAGE_SIZE)
> > +		goto direct_uncharge;
> > +
> >  	/*
> >  	 * In typical case, batch->memcg == mem. This means we can
> >  	 * merge a series of uncharges to an uncharge of res_counter.
> > @@ -2511,9 +2514,9 @@ __do_uncharge(struct mem_cgroup *mem, co
> >  	if (batch->memcg != mem)
> >  		goto direct_uncharge;
> >  	/* remember freed charge and uncharge it later */
> > -	batch->bytes += page_size;
> > +	batch->bytes += PAGE_SIZE;
> >  	if (uncharge_memsw)
> > -		batch->memsw_bytes += page_size;
> > +		batch->memsw_bytes += PAGE_SIZE;
> >  	return;
> >  direct_uncharge:
> >  	res_counter_uncharge(&mem->res, page_size);
> > 
> > 
> 
