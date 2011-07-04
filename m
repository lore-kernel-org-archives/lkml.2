Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752110Ab1GDU2y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jul 2011 16:28:54 -0400
Received: from rcsinet14.oracle.com ([148.87.113.126]:18813 "EHLO
	rcsinet14.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751911Ab1GDU2v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jul 2011 16:28:51 -0400
Date: Mon, 4 Jul 2011 13:26:50 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: linux-kernel@vger.kernel.org, sfr@canb.auug.org.au
Cc: akpm@linux-foundation.org, kamezawa.hiroyu@jp.fujitsu.com
Subject: Re: + memcg-fix-reclaimable-lru-check-in-memcg-fix-2.patch added to
 -mm tree
Message-Id: <20110704132650.da7329c5.randy.dunlap@oracle.com>
In-Reply-To: <201107011936.p61JaKZE010589@imap1.linux-foundation.org>
References: <201107011936.p61JaKZE010589@imap1.linux-foundation.org>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090205.4E122214.0047:SCFMA922111,ss=1,re=-4.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 01 Jul 2011 12:36:20 -0700 akpm@linux-foundation.org wrote:

> 
> The patch titled
>      memcg-fix-reclaimable-lru-check-in-memcg-fix-2
> has been added to the -mm tree.  Its filename is
>      memcg-fix-reclaimable-lru-check-in-memcg-fix-2.patch
> 

Is there some way to get this patch added to linux-next?

thanks.

> ------------------------------------------------------
> Subject: memcg-fix-reclaimable-lru-check-in-memcg-fix-2
> From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> 
>  memcg-fix-reclaimable-lru-check-in-memcg.patch
>  causes following error with !CONFIG_NUMA.
> 
> > mmotm-2011-0630-1559/mm/memcontrol.c:1579: error: implicit declaration of function 'mem_cgroup_node_nr_file_lru_pages'
> > mmotm-2011-0630-1559/mm/memcontrol.c:1583: error: implicit declaration of function 'mem_cgroup_node_nr_anon_lru_pages'
> >
> 
> This patch fixes it by moving functions out of #ifdef.
> 
> Reported-by: Randy Dunlap <randy.dunlap@oracle.com>
> Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> cked-by: Randy Dunlap <randy.dunlap@oracle.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
> 
>  mm/memcontrol.c |   23 +++++++++++------------
>  1 file changed, 11 insertions(+), 12 deletions(-)
> 
> diff -puN mm/memcontrol.c~memcg-fix-reclaimable-lru-check-in-memcg-fix-2 mm/memcontrol.c
> --- a/mm/memcontrol.c~memcg-fix-reclaimable-lru-check-in-memcg-fix-2
> +++ a/mm/memcontrol.c
> @@ -1120,7 +1120,6 @@ unsigned long mem_cgroup_zone_nr_lru_pag
>  	return MEM_CGROUP_ZSTAT(mz, lru);
>  }
>  
> -#ifdef CONFIG_NUMA
>  static unsigned long mem_cgroup_node_nr_file_lru_pages(struct mem_cgroup *memcg,
>  							int nid)
>  {
> @@ -1132,6 +1131,17 @@ static unsigned long mem_cgroup_node_nr_
>  	return ret;
>  }
>  
> +static unsigned long mem_cgroup_node_nr_anon_lru_pages(struct mem_cgroup *memcg,
> +							int nid)
> +{
> +	unsigned long ret;
> +
> +	ret = mem_cgroup_get_zonestat_node(memcg, nid, LRU_INACTIVE_ANON) +
> +		mem_cgroup_get_zonestat_node(memcg, nid, LRU_ACTIVE_ANON);
> +	return ret;
> +}
> +
> +#if MAX_NUMNODES > 1
>  static unsigned long mem_cgroup_nr_file_lru_pages(struct mem_cgroup *memcg)
>  {
>  	u64 total = 0;
> @@ -1143,17 +1153,6 @@ static unsigned long mem_cgroup_nr_file_
>  	return total;
>  }
>  
> -static unsigned long mem_cgroup_node_nr_anon_lru_pages(struct mem_cgroup *memcg,
> -							int nid)
> -{
> -	unsigned long ret;
> -
> -	ret = mem_cgroup_get_zonestat_node(memcg, nid, LRU_INACTIVE_ANON) +
> -		mem_cgroup_get_zonestat_node(memcg, nid, LRU_ACTIVE_ANON);
> -
> -	return ret;
> -}
> -
>  static unsigned long mem_cgroup_nr_anon_lru_pages(struct mem_cgroup *memcg)
>  {
>  	u64 total = 0;
> _


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
