Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751789Ab1LZGv2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Dec 2011 01:51:28 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:37638 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751340Ab1LZGvV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Dec 2011 01:51:21 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Mon, 26 Dec 2011 15:50:08 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
        containers@lists.linux-foundation.org,
        Balbir Singh <bsingharora@gmail.com>, Michal Hocko <mhocko@suse.cz>,
        Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH 1/6] memcg: fix unused variable warning
Message-Id: <20111226155008.9ab21c6f.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20111226064734.GA13355@shutemov.name>
References: <1324695619-5537-1-git-send-email-kirill@shutemov.name>
	<20111226152531.e0335ec4.kamezawa.hiroyu@jp.fujitsu.com>
	<20111226063652.GA13273@shutemov.name>
	<20111226154252.d3621532.kamezawa.hiroyu@jp.fujitsu.com>
	<20111226064734.GA13355@shutemov.name>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 26 Dec 2011 08:47:34 +0200
"Kirill A. Shutemov" <kirill@shutemov.name> wrote:

> On Mon, Dec 26, 2011 at 03:42:52PM +0900, KAMEZAWA Hiroyuki wrote:
> > On Mon, 26 Dec 2011 08:36:52 +0200
> > "Kirill A. Shutemov" <kirill@shutemov.name> wrote:
> > 
> > > On Mon, Dec 26, 2011 at 03:25:31PM +0900, KAMEZAWA Hiroyuki wrote:
> > > > On Sat, 24 Dec 2011 05:00:14 +0200
> > > > "Kirill A. Shutemov" <kirill@shutemov.name> wrote:
> > > > 
> > > > > From: "Kirill A. Shutemov" <kirill@shutemov.name>
> > > > > 
> > > > > mm/memcontrol.c: In function ‘memcg_check_events’:
> > > > > mm/memcontrol.c:784:22: warning: unused variable ‘do_numainfo’ [-Wunused-variable]
> > > > > 
> > > > > Signed-off-by: Kirill A. Shutemov <kirill@shutemov.name>
> > > > 
> > > > Hmm ? Doesn't this fix cause a new Warning ?
> > > > 
> > > > mm/memcontrol.c: In function ?memcg_check_events?:
> > > > mm/memcontrol.c:789: warning: ISO C90 forbids mixed declarations and code
> > > 
> > > I don't see how. The result code is:
> > > 
> > > 	if (unlikely(mem_cgroup_event_ratelimit(memcg,
> > > 						MEM_CGROUP_TARGET_THRESH))) {
> > > 		bool do_softlimit;
> > > 
> > > #if MAX_NUMNODES > 1
> > > 		bool do_numainfo;
> > > 		do_numainfo = mem_cgroup_event_ratelimit(memcg,
> > > 						MEM_CGROUP_TARGET_NUMAINFO);
> > > #endif
> > > 		do_softlimit = mem_cgroup_event_ratelimit(memcg,
> > > 						MEM_CGROUP_TARGET_SOFTLIMIT);
> > > 		preempt_enable();
> > > 
> > > 		mem_cgroup_threshold(memcg);
> > > 
> > 
> > Ah. please see linux-next and rebase onto that.
> 
> The patchset is on top of next-20111222. Have I missed something?
> 
Ah, ok. my mistake. Sorry.

Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>





