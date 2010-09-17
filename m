Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753768Ab0IQGfn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Sep 2010 02:35:43 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:59627 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752199Ab0IQGfm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Sep 2010 02:35:42 -0400
Date: Fri, 17 Sep 2010 12:05:37 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>
Subject: Re: [PATCH][-mm] memcg : memory cgroup cpu hotplug support update.
Message-ID: <20100917063537.GA4534@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <20100916144618.852b7e9a.kamezawa.hiroyu@jp.fujitsu.com>
 <20100916062159.GF22371@balbir.in.ibm.com>
 <20100916152204.6c457936.kamezawa.hiroyu@jp.fujitsu.com>
 <20100916161727.04a1f905.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20100916161727.04a1f905.kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> [2010-09-16 16:17:27]:

> On Thu, 16 Sep 2010 15:22:04 +0900
> KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:
> 
> > This naming is from mem_cgroup_walk_tree(). Now we have
> > 
> >   mem_cgroup_walk_tree();
> >   mem_cgroup_walk_all();
> > 
> > Rename both ? But it should be in separated patch.
> > 
> 
> Considering a bit ...but..
> 
> #define for_each_mem_cgroup(mem) \
> 	for (mem = mem_cgroup_get_first(); \
> 	     mem; \
> 	     mem = mem_cgroup_get_next(mem);) \
> 
> seems to need some helper functions. I'll consider about this clean up
> but it requires some amount of patch because css_get()/css_put()/rcu...etc..
> are problematic.
>

Why does this need to be a macro (I know we use this for lists and
other places), assuming for now we don't use the iterator pattern, we
can rename mem_cgroup_walk_all() to for_each_mem_cgroup(). 

-- 
	Three Cheers,
	Balbir
