Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752649Ab1GULg2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jul 2011 07:36:28 -0400
Received: from cantor2.suse.de ([195.135.220.15]:59065 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752159Ab1GULg1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jul 2011 07:36:27 -0400
Date: Thu, 21 Jul 2011 13:36:26 +0200
From: Michal Hocko <mhocko@suse.cz>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: linux-mm@kvack.org, Balbir Singh <bsingharora@gmail.com>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/4] memcg: unify sync and async per-cpu charge cache
 draining
Message-ID: <20110721113626.GB27855@tiehlicka.suse.cz>
References: <cover.1311241300.git.mhocko@suse.cz>
 <16dca2225fc14783a16d00c43f6680b67418da65.1311241300.git.mhocko@suse.cz>
 <20110721192525.56721c52.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110721192525.56721c52.kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 21-07-11 19:25:25, KAMEZAWA Hiroyuki wrote:
> On Thu, 21 Jul 2011 09:50:00 +0200
> Michal Hocko <mhocko@suse.cz> wrote:
> 
> > Currently we have two ways how to drain per-CPU caches for charges.
> > drain_all_stock_sync will synchronously drain all caches while
> > drain_all_stock_async will asynchronously drain only those that refer to
> > a given memory cgroup or its subtree in hierarchy.
> > Targeted async draining has been introduced by 26fe6168 (memcg: fix
> > percpu cached charge draining frequency) to reduce the cpu workers
> > number.
> > 
> > sync draining is currently triggered only from mem_cgroup_force_empty
> > which is triggered only by userspace (mem_cgroup_force_empty_write) or
> > when a cgroup is removed (mem_cgroup_pre_destroy). Although these are
> > not usually frequent operations it still makes some sense to do targeted
> > draining as well, especially if the box has many CPUs.
> > 
> > This patch unifies both methods to use the single code (drain_all_stock)
> > which relies on the original async implementation and just adds
> > flush_work to wait on all caches that are still under work for the sync
> > mode.
> > We are using FLUSHING_CACHED_CHARGE bit check to prevent from waiting on
> > a work that we haven't triggered.
> > Please note that both sync and async functions are currently protected
> > by percpu_charge_mutex so we cannot race with other drainers.
> > 
> > Signed-off-by: Michal Hocko <mhocko@suse.cz>
> 
> hmm..maybe good.
> Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

Thanks

-- 
Michal Hocko
SUSE Labs
SUSE LINUX s.r.o.
Lihovarska 1060/12
190 00 Praha 9    
Czech Republic
