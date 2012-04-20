Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754588Ab2DTBtF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2012 21:49:05 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:55465 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751237Ab2DTBtD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2012 21:49:03 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.7.4
Message-ID: <4F90C01E.3040909@jp.fujitsu.com>
Date: Fri, 20 Apr 2012 10:47:10 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 6.0; rv:11.0) Gecko/20120327 Thunderbird/11.0.1
MIME-Version: 1.0
To: Hugh Dickins <hughd@google.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Miklos Szeredi <mszeredi@suse.cz>,
        Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.cz>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH] memcg: fix Bad page state after replace_page_cache
References: <alpine.LSU.2.00.1204182325350.3700@eggly.anvils>
In-Reply-To: <alpine.LSU.2.00.1204182325350.3700@eggly.anvils>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2012/04/19 15:34), Hugh Dickins wrote:

> My 9ce70c0240d0 "memcg: fix deadlock by inverting lrucare nesting" put a
> nasty little bug into v3.3's version of mem_cgroup_replace_page_cache(),
> sometimes used for FUSE.  Replacing __mem_cgroup_commit_charge_lrucare()
> by __mem_cgroup_commit_charge(), I used the "pc" pointer set up earlier:
> but it's for oldpage, and needs now to be for newpage.  Once oldpage was
> freed, its PageCgroupUsed bit (cleared above but set again here) caused
> "Bad page state" messages - and perhaps worse, being missed from newpage.
> (I didn't find this by using FUSE, but in reusing the function for tmpfs.)
> 
> Signed-off-by: Hugh Dickins <hughd@google.com>
> Cc: stable@vger.kernel.org [v3.3 only]


Thanks,
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>


> ---
> 
>  mm/memcontrol.c |    1 +
>  1 file changed, 1 insertion(+)
> 
> --- 3.4-rc3/mm/memcontrol.c	2012-04-15 20:47:37.151777506 -0700
> +++ linux/mm/memcontrol.c	2012-04-18 22:29:18.490639511 -0700
> @@ -3392,6 +3392,7 @@ void mem_cgroup_replace_page_cache(struc
>  	 * the newpage may be on LRU(or pagevec for LRU) already. We lock
>  	 * LRU while we overwrite pc->mem_cgroup.
>  	 */
> +	pc = lookup_page_cgroup(newpage);
>  	__mem_cgroup_commit_charge(memcg, newpage, 1, pc, type, true);
>  }
>  
> 
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Fight unfair telecom internet charges in Canada: sign http://stopthemeter.ca/
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
> 
> 



