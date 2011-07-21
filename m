Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752167Ab1GUX4j (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jul 2011 19:56:39 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:42239 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751607Ab1GUX4i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jul 2011 19:56:38 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Fri, 22 Jul 2011 08:49:27 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Michal Hocko <mhocko@suse.cz>
Cc: linux-mm@kvack.org, Balbir Singh <bsingharora@gmail.com>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/4] memcg: get rid of percpu_charge_mutex lock
Message-Id: <20110722084927.96b0aa86.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20110721124223.GE27855@tiehlicka.suse.cz>
References: <cover.1311241300.git.mhocko@suse.cz>
	<2bfb2b7687c1a6b39da2a04689190725075cc4f8.1311241300.git.mhocko@suse.cz>
	<20110721193051.cd3266e5.kamezawa.hiroyu@jp.fujitsu.com>
	<20110721114704.GC27855@tiehlicka.suse.cz>
	<20110721124223.GE27855@tiehlicka.suse.cz>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 21 Jul 2011 14:42:23 +0200
Michal Hocko <mhocko@suse.cz> wrote:

> On Thu 21-07-11 13:47:04, Michal Hocko wrote:
> > On Thu 21-07-11 19:30:51, KAMEZAWA Hiroyuki wrote:
> > > On Thu, 21 Jul 2011 09:58:24 +0200
> > > Michal Hocko <mhocko@suse.cz> wrote:
> [...]
> > > > --- a/mm/memcontrol.c
> > > > +++ b/mm/memcontrol.c
> > > > @@ -2166,7 +2165,8 @@ static void drain_all_stock(struct mem_cgroup *root_mem, bool sync)
> > > >  
> > > >  	for_each_online_cpu(cpu) {
> > > >  		struct memcg_stock_pcp *stock = &per_cpu(memcg_stock, cpu);
> > > > -		if (test_bit(FLUSHING_CACHED_CHARGE, &stock->flags))
> > > > +		if (root_mem == stock->cached &&
> > > > +				test_bit(FLUSHING_CACHED_CHARGE, &stock->flags))
> > > >  			flush_work(&stock->work);
> > > 
> > > Doesn't this new check handle hierarchy ?
> > > css_is_ancestor() will be required if you do this check.
> > 
> > Yes you are right. Will fix it. I will add a helper for the check.
> 
> Here is the patch with the helper. The above will then read 
> 	if (mem_cgroup_same_or_subtree(root_mem, stock->cached))
> 
> ---
> From b963a9f4dac61044daac49700f84b7819d7c2f53 Mon Sep 17 00:00:00 2001
> From: Michal Hocko <mhocko@suse.cz>
> Date: Thu, 21 Jul 2011 13:54:13 +0200
> Subject: [PATCH] memcg: add mem_cgroup_same_or_subtree helper
> 
> We are checking whether a given two groups are same or at least in the
> same subtree of a hierarchy at several places. Let's make a helper for
> it to make code easier to read.
> 
> Signed-off-by: Michal Hocko <mhocko@suse.cz>

Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>


