Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755718Ab1F0B51 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Jun 2011 21:57:27 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:60923 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755393Ab1F0B4r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Jun 2011 21:56:47 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Mon, 27 Jun 2011 10:49:41 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Ying Han <yinghan@google.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
        "bsingharora@gmail.com" <bsingharora@gmail.com>,
        Michal Hocko <mhocko@suse.cz>,
        "hannes@cmpxchg.org" <hannes@cmpxchg.org>
Subject: Re: [PATCH 3/7] memcg: add memory.scan_stat
Message-Id: <20110627104941.3b4cbb22.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <BANLkTimBPo6PyMKB4_ASL2nP2xiajExFK7ZWwvCUkdaqssnHiQ@mail.gmail.com>
References: <20110616124730.d6960b8b.kamezawa.hiroyu@jp.fujitsu.com>
	<20110616125314.4f78b1e0.kamezawa.hiroyu@jp.fujitsu.com>
	<BANLkTim-r6ejJK601rWq7smY37FC9um7mg@mail.gmail.com>
	<20110622092031.e4be1846.kamezawa.hiroyu@jp.fujitsu.com>
	<BANLkTimBPo6PyMKB4_ASL2nP2xiajExFK7ZWwvCUkdaqssnHiQ@mail.gmail.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 24 Jun 2011 14:40:42 -0700
Ying Han <yinghan@google.com> wrote:

> On Tue, Jun 21, 2011 at 5:20 PM, KAMEZAWA Hiroyuki
> <kamezawa.hiroyu@jp.fujitsu.com> wrote:
> > On Mon, 20 Jun 2011 23:49:54 -0700
> > Ying Han <yinghan@google.com> wrote:
> >
> >> On Wed, Jun 15, 2011 at 8:53 PM, KAMEZAWA Hiroyuki <
> >> kamezawa.hiroyu@jp.fujitsu.com> wrote:
> >>
> >> > From e08990dd9ada13cf236bec1ef44b207436434b8e Mon Sep 17 00:00:00 2001
> >> > From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> >> > Date: Wed, 15 Jun 2011 14:11:01 +0900
> >> > Subject: [PATCH 3/7] memcg: add memory.scan_stat

> >> > +
> >> > +struct scanstat {
> >> > +       spinlock_t      lock;
> >> > +       unsigned long   stats[NR_SCANSTATS];    /* local statistics */
> >> > +       unsigned long   totalstats[NR_SCANSTATS];   /* hierarchical */
> >> > +};
> 
> I wonder why not extending the mem_cgroup_stat_cpu struct, and then we
> can use the per-cpu counters like others.
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index b7d2d79..5b8bbe9 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -138,6 +138,7 @@ struct mem_cgroup_stat_cpu {
>         long count[MEM_CGROUP_STAT_NSTATS];
>         unsigned long events[MEM_CGROUP_EVENTS_NSTATS];
>         unsigned long targets[MEM_CGROUP_NTARGETS];
> +       unsigned long reclaim_stats[MEMCG_RECLAIM_NSTATS];
>  };
> 

Hmm, do we have enough benefit to consume 72 bytes per cpu and make
read-side slow for this rarely updated counter ?

Thanks,
-Kame

