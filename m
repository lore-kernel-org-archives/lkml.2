Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754371Ab2FSMkk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2012 08:40:40 -0400
Received: from cantor2.suse.de ([195.135.220.15]:51387 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754327Ab2FSMki (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2012 08:40:38 -0400
Date: Tue, 19 Jun 2012 14:40:36 +0200
From: Michal Hocko <mhocko@suse.cz>
To: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: linux-mm <linux-mm@kvack.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        cgroups@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH 1/2] memcg: remove -EINTR at rmdir()
Message-ID: <20120619124036.GB22254@tiehlicka.suse.cz>
References: <4FDF17A3.9060202@jp.fujitsu.com>
 <20120618133012.GB2313@tiehlicka.suse.cz>
 <4FDFC34B.3010003@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FDFC34B.3010003@jp.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 19-06-12 09:09:47, KAMEZAWA Hiroyuki wrote:
> (2012/06/18 22:30), Michal Hocko wrote:
> > On Mon 18-06-12 20:57:23, KAMEZAWA Hiroyuki wrote:
> >> 2 follow-up patches for "memcg: move charges to root cgroup if use_hierarchy=0",
> >> developped/tested onto memcg-devel tree. Maybe no HUNK with -next and -mm....
> >> -Kame
> >> ==
> >> memcg: remove -EINTR at rmdir()
> >>
> >> By commit "memcg: move charges to root cgroup if use_hierarchy=0",
> >> no memory reclaiming will occur at removing memory cgroup.
> > 
> > OK, so the there are only 2 reasons why move_parent could fail in this
> > path. 1) it races with somebody else who is uncharging or moving the
> > charge and 2) THP split.
> > 1) works for us and 2) doens't seem to be serious enough to expect that
> > it would stall rmdir on the group for unbound amount of time so the
> > change is safe (can we make this into the changelog please?).
> > 
> 
> Yes. But the failure of move_parent() (-EBUSY) will be retried.
> 
> Remaining problems are
>  - attaching task while pre_destroy() is called.
>  - creating child cgroup while pre_destroy() is called.

I don't know why but I thought that tasks and subgroups are not alowed
when pre_destroy is called. If this is possible then we probably want to
check for pending signals or at least add cond_resched.

> 
> I think I need to make a patch for cgroup layer as I previously posted.
> I'd like to try again.
> 
> Thanks,
> -Kame
> 

-- 
Michal Hocko
SUSE Labs
SUSE LINUX s.r.o.
Lihovarska 1060/12
190 00 Praha 9    
Czech Republic
