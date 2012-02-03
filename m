Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756832Ab2BCQEg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Feb 2012 11:04:36 -0500
Received: from cantor2.suse.de ([195.135.220.15]:60551 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754145Ab2BCQEf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Feb 2012 11:04:35 -0500
Date: Fri, 3 Feb 2012 17:04:31 +0100
From: Michal Hocko <mhocko@suse.cz>
To: Geunsik Lim <geunsik.lim@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        linux-mm <linux-mm@kvack.org>
Subject: Re: [PATCH] Handling of unused variable 'do-numainfo on compilation
 time
Message-ID: <20120203160431.GB13461@tiehlicka.suse.cz>
References: <1328258627-2241-1-git-send-email-geunsik.lim@gmail.com>
 <20120203133950.GA1690@cmpxchg.org>
 <20120203145304.GA18335@tiehlicka.suse.cz>
 <CAGFP0LK4_PhKLJVtMhsNe4YfUQoHcoTK3hJhHaBy51f359ef7A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGFP0LK4_PhKLJVtMhsNe4YfUQoHcoTK3hJhHaBy51f359ef7A@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat 04-02-12 00:36:36, Geunsik Lim wrote:
> On Fri, Feb 3, 2012 at 11:53 PM, Michal Hocko <mhocko@suse.cz> wrote:
> 
> > On Fri 03-02-12 14:39:50, Johannes Weiner wrote:
> > > Michal, this keeps coming up, please decide between the proposed
> > > solutions ;-)
> >
> > Hmm, I thought we already sorted this out
> > https://lkml.org/lkml/2012/1/26/25 ?
> >
> I don't know previous history about this variable.
> Is it same? Please, adjust this patch or fix the unsuitable
> variable 'do_numainfo' as I mentioned.

The patch (I guess the author is Andrew) just silence the compiler
warning which is the easiest fix in this case because we know it will be
used only for MAX_NUMNODES > 1.
Your patch fixes it as well but it adds an ugly ifdef around the
variable.

Andrew, could you pick up this one, please?
---
>From 9fe9ae356ace2daf9529bb8cfa2e20bef7c415af Mon Sep 17 00:00:00 2001
From: Andrew Morton <akpm@linux-foundation.org>
Date: Fri, 3 Feb 2012 16:58:19 +0100
Subject: [PATCH] memcg: memcg_check_events: silent unused variable warning

do_numainfo is used only if MAX_NUMNODES > 1 so we have a following
warning for UMA machines.

CC      mm/memcontrol.o
mm/memcontrol.c: In function 'memcg_check_events':
mm/memcontrol.c:779:22: warning: unused variable 'do_numainfo'

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Michal Hocko <mhocko@suse.cz>
Acked-by: Kirill A. Shutemov <kirill@shutemov.name>
---
 mm/memcontrol.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index bf29761..5f805cc 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -708,7 +708,8 @@ static void memcg_check_events(struct mem_cgroup *memcg, struct page *page)
 	/* threshold event is triggered in finer grain than soft limit */
 	if (unlikely(mem_cgroup_event_ratelimit(memcg,
 						MEM_CGROUP_TARGET_THRESH))) {
-		bool do_softlimit, do_numainfo;
+		bool do_softlimit;
+		bool do_numainfo __maybe_unused;
 
 		do_softlimit = mem_cgroup_event_ratelimit(memcg,
 						MEM_CGROUP_TARGET_SOFTLIMIT);
-- 
1.7.8.3


-- 
Michal Hocko
SUSE Labs
SUSE LINUX s.r.o.
Lihovarska 1060/12
190 00 Praha 9    
Czech Republic
