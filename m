Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751678Ab1AXKKE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jan 2011 05:10:04 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:33945 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751301Ab1AXKKD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jan 2011 05:10:03 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Mon, 24 Jan 2011 19:03:59 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
        "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>
Subject: Re: [PATCH 3/7] memcg : fix mem_cgroup_check_under_limit
Message-Id: <20110124190359.a79deec8.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20110124100434.GS2232@cmpxchg.org>
References: <20110121153431.191134dd.kamezawa.hiroyu@jp.fujitsu.com>
	<20110121154141.680c96d9.kamezawa.hiroyu@jp.fujitsu.com>
	<20110124100434.GS2232@cmpxchg.org>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.3 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 24 Jan 2011 11:04:34 +0100
Johannes Weiner <hannes@cmpxchg.org> wrote:
  
> >  	ret = mem_cgroup_hierarchical_reclaim(mem_over_limit, NULL,
> > -					gfp_mask, flags);
> > +					gfp_mask, flags, csize);
> >  	/*
> >  	 * try_to_free_mem_cgroup_pages() might not give us a full
> >  	 * picture of reclaim. Some pages are reclaimed and might be
> > @@ -1852,7 +1853,7 @@ static int __mem_cgroup_do_charge(struct
> >  	 * Check the limit again to see if the reclaim reduced the
> >  	 * current usage of the cgroup before giving up
> >  	 */
> > -	if (ret || mem_cgroup_check_under_limit(mem_over_limit))
> > +	if (ret || mem_cgroup_check_under_limit(mem_over_limit, csize))
> >  		return CHARGE_RETRY;
> 
> This is the only site that is really involved with THP. 

yes.

> But you need to touch every site because you change mem_cgroup_check_under_limit()
> instead of adding a new function.
> 
Yes.

> I would suggest just adding another function for checking available
> space explicitely and only changing this single call site to use it.
> 
> Just ignore the return value of mem_cgroup_hierarchical_reclaim() and
> check for enough space unconditionally.
> 
> Everybody else is happy with PAGE_SIZE pages.
> 
Hmm. ok, let us changes to be small and see how often hugepage alloc will fail.

Thanks,
-Kame



