Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755723Ab1F1IzE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jun 2011 04:55:04 -0400
Received: from cantor2.suse.de ([195.135.220.15]:33274 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756742Ab1F1Ixh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jun 2011 04:53:37 -0400
Date: Tue, 28 Jun 2011 10:53:36 +0200
From: Michal Hocko <mhocko@suse.cz>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, torvalds@linux-foundation.org,
        nishimura@mxp.nes.nec.co.jp, yinghan@google.com, linux-mm@kvack.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [patch 14/22] memcg: fix direct softlimit reclaim to be called
 in limit path
Message-ID: <20110628085335.GA17961@tiehlicka.suse.cz>
References: <201106272318.p5RNICJW001465@imap1.linux-foundation.org>
 <20110628080847.GA16518@tiehlicka.suse.cz>
 <20110628170649.87043e05.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110628170649.87043e05.kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 28-06-11 17:06:49, KAMEZAWA Hiroyuki wrote:
> On Tue, 28 Jun 2011 10:08:47 +0200
> Michal Hocko <mhocko@suse.cz> wrote:
> 
> > I am sorry, that I am answering that late but I didn't get to this
> > sooner.
> > 
> > On Mon 27-06-11 16:18:12, Andrew Morton wrote:
> > > From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> > > 
> > > commit d149e3b ("memcg: add the soft_limit reclaim in global direct
> > > reclaim") adds a softlimit hook to shrink_zones().  By this, soft limit is
> > > called as
> > > 
> > >    try_to_free_pages()
> > >        do_try_to_free_pages()
> > >            shrink_zones()
> > >                mem_cgroup_soft_limit_reclaim()
> > > 
> > > Then, direct reclaim is memcg softlimit hint aware, now.
> > > 
> > > But, the memory cgroup's "limit" path can call softlimit shrinker.
> > > 
> > >    try_to_free_mem_cgroup_pages()
> > >        do_try_to_free_pages()
> > >            shrink_zones()
> > >                mem_cgroup_soft_limit_reclaim()
> > > 
> > > This will cause a global reclaim when a memcg hits limit.
> > 
> > Sorry, I do not get it. How does it cause the global reclaim? Did you
> > mean soft reclaim?
> > 
> 
> yes. soft reclaim does global reclaim (in some means). 

But calling it global reclaim is rather confusing because in both paths
we have sc.mem_cgroup set to non-NULL which is evaluated as
!scanning_global_lru(sc). Anyway, this is not that important, I just
wanted to be sure what you meant by that comment.

-- 
Michal Hocko
SUSE Labs
SUSE LINUX s.r.o.
Lihovarska 1060/12
190 00 Praha 9    
Czech Republic
