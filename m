Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753853Ab1HBC3a (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Aug 2011 22:29:30 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:57274 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753206Ab1HBC30 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Aug 2011 22:29:26 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Tue, 2 Aug 2011 11:21:43 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Michal Hocko <mhocko@suse.cz>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>
Subject: Re: [PATCH v4 2/5] memcg : pass scan nodemask
Message-Id: <20110802112143.814e3720.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20110801135953.GE25251@tiehlicka.suse.cz>
References: <20110727144438.a9fdfd5b.kamezawa.hiroyu@jp.fujitsu.com>
	<20110727144742.420cf69c.kamezawa.hiroyu@jp.fujitsu.com>
	<20110801135953.GE25251@tiehlicka.suse.cz>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 1 Aug 2011 15:59:53 +0200
Michal Hocko <mhocko@suse.cz> wrote:

> On Wed 27-07-11 14:47:42, KAMEZAWA Hiroyuki wrote:
> > 
> > pass memcg's nodemask to try_to_free_pages().
> > 
> > try_to_free_pages can take nodemask as its argument but memcg
> > doesn't pass it. Considering memcg can be used with cpuset on
> > big NUMA, memcg should pass nodemask if available.
> > 
> > Now, memcg maintain nodemask with periodic updates. pass it.
> > 
> > Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> > ---
> >  include/linux/memcontrol.h |    2 +-
> >  mm/memcontrol.c            |    8 ++++++--
> >  mm/vmscan.c                |    3 ++-
> >  3 files changed, 9 insertions(+), 4 deletions(-)
> > 
> [...]
> > Index: mmotm-0710/mm/vmscan.c
> > ===================================================================
> > --- mmotm-0710.orig/mm/vmscan.c
> > +++ mmotm-0710/mm/vmscan.c
> > @@ -2280,6 +2280,7 @@ unsigned long try_to_free_mem_cgroup_pag
> >  	unsigned long nr_reclaimed;
> >  	unsigned long start, end;
> >  	int nid;
> > +	nodemask_t *mask;
> >  	struct scan_control sc = {
> >  		.may_writepage = !laptop_mode,
> >  		.may_unmap = 1,
> > @@ -2302,7 +2303,7 @@ unsigned long try_to_free_mem_cgroup_pag
> >  	 * take care of from where we get pages. So the node where we start the
> >  	 * scan does not need to be the current node.
> >  	 */
> > -	nid = mem_cgroup_select_victim_node(mem_cont);
> > +	nid = mem_cgroup_select_victim_node(mem_cont, &mask);
> 
> The mask is not used anywhere AFAICS and using it is a point of the
> patch AFAIU. I guess you wanted to use &sc.nodemask, right?
> 
> Other than that, looks good to me.
> 
> Reviewed-by: Michal Hocko <mhocko@suse.cz>

Ah, sorry. I'll fix.

Thanks,
-Kame

