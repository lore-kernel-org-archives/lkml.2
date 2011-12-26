Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751359Ab1LZGg7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Dec 2011 01:36:59 -0500
Received: from shutemov.name ([188.40.19.243]:58773 "EHLO shutemov.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751028Ab1LZGgx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Dec 2011 01:36:53 -0500
Date: Mon, 26 Dec 2011 08:36:52 +0200
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
        containers@lists.linux-foundation.org,
        Balbir Singh <bsingharora@gmail.com>, Michal Hocko <mhocko@suse.cz>,
        Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH 1/6] memcg: fix unused variable warning
Message-ID: <20111226063652.GA13273@shutemov.name>
References: <1324695619-5537-1-git-send-email-kirill@shutemov.name>
 <20111226152531.e0335ec4.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <20111226152531.e0335ec4.kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 26, 2011 at 03:25:31PM +0900, KAMEZAWA Hiroyuki wrote:
> On Sat, 24 Dec 2011 05:00:14 +0200
> "Kirill A. Shutemov" <kirill@shutemov.name> wrote:
> 
> > From: "Kirill A. Shutemov" <kirill@shutemov.name>
> > 
> > mm/memcontrol.c: In function ‘memcg_check_events’:
> > mm/memcontrol.c:784:22: warning: unused variable ‘do_numainfo’ [-Wunused-variable]
> > 
> > Signed-off-by: Kirill A. Shutemov <kirill@shutemov.name>
> 
> Hmm ? Doesn't this fix cause a new Warning ?
> 
> mm/memcontrol.c: In function ?memcg_check_events?:
> mm/memcontrol.c:789: warning: ISO C90 forbids mixed declarations and code

I don't see how. The result code is:

	if (unlikely(mem_cgroup_event_ratelimit(memcg,
						MEM_CGROUP_TARGET_THRESH))) {
		bool do_softlimit;

#if MAX_NUMNODES > 1
		bool do_numainfo;
		do_numainfo = mem_cgroup_event_ratelimit(memcg,
						MEM_CGROUP_TARGET_NUMAINFO);
#endif
		do_softlimit = mem_cgroup_event_ratelimit(memcg,
						MEM_CGROUP_TARGET_SOFTLIMIT);
		preempt_enable();

		mem_cgroup_threshold(memcg);


> 
> Thanks,
> -Kame
> > ---
> >  mm/memcontrol.c |    7 ++++---
> >  1 files changed, 4 insertions(+), 3 deletions(-)
> > 
> > diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> > index d643bd6..a5e92bd 100644
> > --- a/mm/memcontrol.c
> > +++ b/mm/memcontrol.c
> > @@ -781,14 +781,15 @@ static void memcg_check_events(struct mem_cgroup *memcg, struct page *page)
> >  	/* threshold event is triggered in finer grain than soft limit */
> >  	if (unlikely(mem_cgroup_event_ratelimit(memcg,
> >  						MEM_CGROUP_TARGET_THRESH))) {
> > -		bool do_softlimit, do_numainfo;
> > +		bool do_softlimit;
> >  
> > -		do_softlimit = mem_cgroup_event_ratelimit(memcg,
> > -						MEM_CGROUP_TARGET_SOFTLIMIT);
> >  #if MAX_NUMNODES > 1
> > +		bool do_numainfo;
> >  		do_numainfo = mem_cgroup_event_ratelimit(memcg,
> >  						MEM_CGROUP_TARGET_NUMAINFO);
> >  #endif
> > +		do_softlimit = mem_cgroup_event_ratelimit(memcg,
> > +						MEM_CGROUP_TARGET_SOFTLIMIT);
> >  		preempt_enable();
> >  
> >  		mem_cgroup_threshold(memcg);
> > -- 
> > 1.7.7.3
> > 
> 

-- 
 Kirill A. Shutemov
