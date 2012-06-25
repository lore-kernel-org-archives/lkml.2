Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754229Ab2FYHwe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2012 03:52:34 -0400
Received: from zene.cmpxchg.org ([85.214.230.12]:52967 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751410Ab2FYHwc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2012 03:52:32 -0400
Date: Mon, 25 Jun 2012 09:52:15 +0200
From: Johannes Weiner <hannes@cmpxchg.org>
To: Wanpeng Li <liwp.linux@gmail.com>
Cc: Michal Hocko <mhocko@suse.cz>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Balbir Singh <bsingharora@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Mike Frysinger <vapier@gentoo.org>, Arun Sharma <asharma@fb.com>,
        linux-kernel@vger.kernel.org, cgroups@vger.kernel.org
Subject: Re: [PATCH 1/5 v2] memcg: replace unsigned long by u64 to avoid
 overflow
Message-ID: <20120625075215.GW27816@cmpxchg.org>
References: <1340604266-7937-1-git-send-email-liwp.linux@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1340604266-7937-1-git-send-email-liwp.linux@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 25, 2012 at 02:04:20PM +0800, Wanpeng Li wrote:
> Changlog:
> 
> V2 -> V1:
> * fix zone_page_state()::/include/linux/vmstat.h returns 'unsigned long'
> 
> From: Wanpeng Li <liwp@linux.vnet.ibm.com>
> 
> Since the return value variable in mem_cgroup_zone_nr_lru_pages and
> mem_cgroup_node_nr_lru_pages functions are u64, so replace the return
> value of funtions by u64 to avoid overflow.
> 
> Signed-off-by: Wanpeng Li <liwp.linux@gmail.com>
> ---
>  include/linux/vmstat.h |    2 +-
>  mm/memcontrol.c        |    5 ++---
>  2 files changed, 3 insertions(+), 4 deletions(-)
> 
> diff --git a/include/linux/vmstat.h b/include/linux/vmstat.h
> index 65efb92..6a14291 100644
> --- a/include/linux/vmstat.h
> +++ b/include/linux/vmstat.h
> @@ -106,7 +106,7 @@ static inline unsigned long global_page_state(enum zone_stat_item item)
>  	return x;
>  }
>  
> -static inline unsigned long zone_page_state(struct zone *zone,
> +static inline u64 zone_page_state(struct zone *zone,
>  					enum zone_stat_item item)
>  {
>  	long x = atomic_long_read(&zone->vm_stat[item]);

We established that there is no known reason to use ulong for page
counters and that IF YOU HAD ONE, you should obviously say so and then
do a wholesale conversion.  But I don't think you have one.

This patch makes absolutely no sense.
